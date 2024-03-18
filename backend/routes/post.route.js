
const express = require('express');
const router = express.Router();
const Post = require('../models/post.model');
const multer = require('multer');
const path = require('path');
const bodyParser = require('body-parser');
const User = require('../models/user.model');
const jsonParser = bodyParser.json({ limit: '100mb' });
router.use(jsonParser);
const jwt = require('jsonwebtoken');
// Get all posts
// router.get('/', async (req, res) => {
//   try {
//     const posts = await Post.find();
//     res.json(posts);
//   } catch (err) {
//     res.status(500).json({ message: err.message });
//   }
// });

router.get('/', async (req, res) => {
  try {
    const posts = await Post.find().populate('userId', 'fullname');
    const formattedPosts = posts.map(post => ({
      userId: post.userId,
      content: post.content,
      likes: post.likes,
      comments: post.comments,
      totalLikes: post.likes.length,
      pictures: post.pictures, 
      _id: post._id,
      timestamp: post.timestamp,
      __v: post.__v,
      fullname: post.fullname,
    }));
    res.json(formattedPosts);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});
const storage = multer.diskStorage({
  destination: './uploads/', // Set the destination folder for uploaded pictures
  filename: function (req, file, cb) {
    cb(null, file.fieldname + '-' + Date.now() + path.extname(file.originalname));
  },
});

const upload = multer({ storage: storage });

router.post('/', upload.array('pictures', 5), async (req, res) => {
  try {
    if (!req.files || req.files.length === 0) {
      return res.status(400).json({ message: 'No pictures provided.' });
    }    const userId = req.body.userId;

    const user = await User.findById(userId);
    console.log(user.fullname);
    const post = new Post({
      content: req.body.content,
      userId: req.body.userId,
      likes: [],
      fullname: user.fullname, 
      pictures: req.files.map(file => '/uploads/' + file.filename),
    });

    const newPost = await post.save();
    const responsePost = {
      userId: newPost.userId,
      content: newPost.content,
      likes: newPost.likes,
      comments: newPost.comments,
      totalLikes: newPost.likes.length,
      pictures: newPost.pictures,
      _id: newPost._id,
      timestamp: newPost.timestamp,
      __v: newPost.__v,
      fullname: user.fullname,
    };
    console.log(responsePost);
 
    res.status(201).json(responsePost);
  } catch (err) {
    console.error(err);
    res.status(400).json({ message: 'Failed to process the request.' });
  }
});
router.put('/:id', upload.array('pictures', 2), async (req, res) => {
  try {
    const post = await Post.findById(req.params.id);

    if (!post) {
      return res.status(404).json({ message: 'Post not found.' });
    }

    // Update the post properties
    post.content = req.body.content || post.content;

    if (req.files && req.files.length > 0) {
      post.pictures = req.files.map(file => '/uploads/' + file.filename);
    }

    const updatedPost = await post.save();
    const responsePost = {
      ...updatedPost.toObject(),
      totalLikes: updatedPost.likes.length,
    };

    res.json(updatedPost);
  } catch (err) {
    console.error(err);
    res.status(400).json({ message: 'Failed to process the request.' });
  }
});
router.delete('/:id', async (req, res) => {
  try {
    const post = await Post.findById(req.params.id);

    if (!post) {
      return res.status(404).json({ message: 'Post not found.' });
    }
    await Post.deleteOne({ _id: req.params.id }); 
    res.json({ message: 'Post deleted successfully.' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: err.message });
  }
});
router.post('/:id/comment', async (req, res) => {
  try {
    const post = await Post.findById(req.params.id);
    
    if (!req.body.comment) {
      return res.status(400).json({ message: 'Comment is required.' });
    }

    post.comments.push(req.body.comment);
    const updatedPost = await post.save();
    res.json(updatedPost);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});



// router.post('/:id/comment', async (req, res) => {
//   try {
//     const post = await Post.findById(req.params.id);

//     if (!req.body.comment) {
//       return res.status(400).json({ message: 'Comment is required.' });
//     }

//     // Extract userId and fullname from the request body
//     console.log(req.body);
//   const { comment, userId,fullname } = req.body;
//   //const { userId, fullname, comment } = req.body;
//   console.log({comment, userId,fullname});
//     // Push the comment with userId and fullname to the post
//     post.comments.push({comment, userId,fullname  });

//     const updatedPost = await post.save();
//     console.log(updatedPost);
//     console.log('Updated Post:', updatedPost);
//     res.json(updatedPost);
//   } catch (err) {
//     res.status(500).json({ message: err.message });
//   }
// });


router.put('/:id/like', async (req, res) => {
  try {
    const post = await Post.findById(req.params.id);

    if (!post) {
      return res.status(404).json({ message: 'Post not found.' });
    }

    const userId = req.body.userId;

    // Ensure that post.likes is an array, initialize as an empty array if null
    post.likes = Array.isArray(post.likes) ? post.likes : [];

    // Check if the user has already liked the post
    //const hasLiked = post.likes.some((like) => like.userId.toString() === userId.toString());
    const hasLiked = post.likes.some((like) => like.userId && like.userId.toString() === userId.toString());

    if (hasLiked) {
      // If already liked, unlike the post
      post.likes = post.likes.filter((like) => like.userId.toString() !== userId.toString());
    } else {
      // If not liked, add the like with userId
      post.likes.push({ userId }); // Assuming you want to store the userId with the like
    }

    const updatedPost = await post.save();
    const responsePost = {
      ...updatedPost.toObject(),
      totalLikes: updatedPost.likes.length,
    };
    res.json(responsePost);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: err.message });
  }
});

// ...

// ...


// ...

module.exports = router;
