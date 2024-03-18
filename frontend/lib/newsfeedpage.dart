import 'package:flutter/material.dart';
import 'package:frontend/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:velocity_x/velocity_x.dart';

class Post {
  final String id;
  final String content;
  int likes;
  final String fullname;
  final List<String> comments;
  //int totalLikes;
  final List<String> pictures;
  final DateTime timestamp;
  final String userId;
  final String role;
  Post({
    required this.id,
    required this.content,
    required this.userId,
    required this.likes,
    required this.role,
    required this.timestamp,
    required this.fullname,
    // required this.totalLikes,
    List<String>? comments,
    required this.pictures,
  }) : comments = comments ?? [];
  factory Post.fromJson(Map<String, dynamic> json) {
    try {
      return Post(
        id: json['_id'] ?? '',
        content: json['content'] ?? '',
        likes: (json['likes'] is List) ? (json['likes'] as List).length : 0,
        userId: json['userId'] ?? '',
        fullname: json['fullname'] ?? '',
           role: json['role'] ?? '',
        timestamp: json['timestamp'] != null
            ? (json['timestamp'] is String
                ? DateTime.parse(json['timestamp'])
                : DateTime.now())
            : DateTime.now(),
        comments: List<String>.from(json['comments']) ?? [],
        pictures: List<String>.from(json['pictures'] ?? []),
      );
    } catch (e) {
      print('Error parsing createdAt: $e');
      return Post(
        id: json['_id'] ?? '',
        role:json['role'] ?? '',
        content: json['content'] ?? '',
        likes: (json['likes'] is List) ? (json['likes'] as List).length : 0,
        userId: json['userId']['_id'] ?? '',
        fullname: json['userId']['fullname'] ?? '',
        // totalLikes: json['totalLikes']??'',
        timestamp: DateTime.now(), // Provide a default date if parsing fails
        comments: List<String>.from(json['comments']) ?? [],
        pictures: List<String>.from(json['pictures'] ?? []),
      );
    }
  }
}

class NewsFeed extends StatefulWidget {
  final String token;

  const NewsFeed({Key? key, required this.token}) : super(key: key);

  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  bool areCommentsExpanded = false;
  String role = '';
  List<Post> posts = [];
  Set<String> likedPostIds = Set<String>();
  @override
  void initState() {
    super.initState();
    fetchPosts();
    Map<String, dynamic>? jwtDecodedToken = JwtDecoder.decode(widget.token);

    if (jwtDecodedToken != null) {
      role = jwtDecodedToken['role'] ?? '';
    } else {
      role = 'Project Manager';
    }
    print(role);
  }

  Future<String> fetchFullname(String userId) async {
    print(userId);
    try {
      final response = await http.get(
        Uri.parse('http://192.168.18.12:4001/getFullNamebyId/$userId'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['status'] == true) {
          final Map<String, dynamic> user = data['user'];
          print(data['user']);
          print(user['fullname']);
          return user['fullname'] ?? '';
        } else {
          throw Exception('Failed to retrieve user');
        }
      } else {
        throw Exception('Failed to fetch user fullname');
      }
    } catch (e) {
      print('Error fetching user fullname: $e');
      return '';
    }
  }

  Future<void> updateLikes(String postId, bool hasLiked) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.18.12:4001/api/posts/$postId/like'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        if (hasLiked) {
          // If the user has liked the post, decrease the likes count
          setState(() {
            posts.firstWhere((post) => post.id == postId).likes--;
          });
        } else {
          // If the user hasn't liked the post, increase the likes count
          setState(() {
            posts.firstWhere((post) => post.id == postId).likes++;
          });
        }
      } else {
        throw Exception('Failed to update likes');
      }
    } catch (e) {
      print('Error updating likes: $e');
    }
  }

  Future<void> fetchPosts() async {
    try {
      final response = await http.get(
        Uri.parse(fetchposts),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        final Iterable<dynamic> data = json.decode(response.body);
        setState(() {
          posts = data.map((post) => Post.fromJson(post)).toList();
        });
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  Future<void> addPost(String content, List<File> images) async {
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);
      String userId = decodedToken['_id'];
      String fullname = decodedToken['fullname'];
      String role = decodedToken['role'];
      print(fullname);
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(fetchposts),
      );
      print(role);
      request.fields['content'] = content;
      request.fields['userId'] = userId;
      request.fields['fullname'] = fullname;
      print(request.fields['userId']);
      for (var i = 0; i < images.length; i++) {
        request.files.add(await http.MultipartFile.fromPath(
          'pictures',
          images[i].path,
        ));
      }

      request.headers['Authorization'] = 'Bearer ${widget.token}';

      final response = await request.send();

      if (response.statusCode == 201) {
        fetchPosts();
      } else {
        throw Exception('Failed to add post');
      }
    } catch (e) {
      print('Error adding post: $e');
      print(e);
    }
  }

  Future<void> postComment(String postId, String comment) async {
    try {
      print(postId + 'ddd');
      print('Posting comment: $comment to post: $postId');
      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
      String userId = jwtDecodedToken['_id'];
      String fullname = jwtDecodedToken['fullname'];
       print('UserID: $userId, Fullname: $fullname');
     final response = await http.post(
        Uri.parse('http://192.168.18.12:4001/api/posts/$postId/comment'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'comment': comment,
          'userId': userId, // Include the user ID in the comment data
          'fullname': fullname, // Include the full name in the comment data
        }),
      );

      if (response.statusCode == 201) {
        fetchPosts();
      } else {
        throw Exception('Failed to post comment');
      }
    } catch (e, stackTrace) {
      print('Stack trace: $stackTrace');
      print('Error posting comment: $e');
      if (e is http.ClientException) {
        print('Client exception details: ${e.message}');
      }
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.18.12:4001/api/posts/$postId'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        fetchPosts();
      } else {
        throw Exception('Failed to delete post');
      }
    } catch (e) {
      print('Error deleting post: $e');
    }
  }

  Future<void> updatePost(String postId, String newContent) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.18.12:4001/api/posts/$postId'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'content': newContent}),
      );

      if (response.statusCode == 200) {
        fetchPosts();
      } else {
        throw Exception('Failed to update post');
      }
    } catch (e) {
      print('Error updating post: $e');
    }
  }

  void showAddPostDialog() {
    TextEditingController contentController = TextEditingController();
    List<File> selectedImages = [];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Post'),
          content: Container(
            height: 150,
            child: Column(
              children: [
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(hintText: 'Enter your post'),
                ),
                SizedBox(
                  height: 50,
                ),
                IconButton(
                    onPressed: () async {
                      final List<XFile>? pickedImages =
                          await ImagePicker().pickMultiImage();
                      if (pickedImages != null) {
                        selectedImages = pickedImages
                            .map((pickedImage) => File(pickedImage.path))
                            .toList();
                      }
                    },
                    icon: Icon(Icons.image)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String content = contentController.text.trim();
                if (content.isNotEmpty) {
                  addPost(content, selectedImages);
                  Navigator.pop(context);
                }
              },
              child: Text('Add Post'),
              style: ElevatedButton.styleFrom(backgroundColor:  Color.fromARGB(255, 150, 125, 241),),
            ),
          ],
        );
      },
    );
  }

  void showCommentDialog(Post post) {
    TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Comment'),
          content: Container(
            height: 80,
            child: Column(
              children: [
                TextField(
                  controller: commentController,
                  decoration: InputDecoration(hintText: 'Type your comment'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String comment = commentController.text.trim();
                print(comment);
                if (comment.isNotEmpty) {
                  postComment(post.id, comment);
                  Navigator.pop(context);
                }
              },
              child: Text('Post Comment'),
            ),
          ],
        );
      },
    );
  }

  void showUpdatePostDialog(Post post) {
    TextEditingController contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Post'),
          content: Container(
            height: 80,
            child: Column(
              children: [
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(
                    hintText: 'Enter your updated post content',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String newContent = contentController.text.trim();
                if (newContent.isNotEmpty) {
                  updatePost(post.id, newContent);
                  Navigator.pop(context);
                }
              },
              child: Text('Update '),
            ),
          ],
        );
      },
    );
  }

  void showDeleteConfirmationDialog(String postId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Confirmation'),
          content: Text('Are you sure you want to delete this post?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                deletePost(postId);
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget buildPostMenu(Post post) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'update') {
          showUpdatePostDialog(post);
        } else if (value == 'delete') {
          showDeleteConfirmationDialog(post.id);
        }
        // }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'update',
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('Update'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
         backgroundColor: Color.fromARGB(255, 150, 125, 241),
        title: Text("News feed"),
        actions: [
          if (role != 'intern' && role != 'regular')
            IconButton(
              icon: Icon(Icons.add_box_outlined),
              onPressed: () {
                showAddPostDialog();
              },
            ),
        ],
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          bool hasLiked = false;
          if (post.likes > 0) {
            hasLiked = post.likes.contains(post.userId);
          }

          return Card(
            elevation:7.0,
            margin: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(post.fullname,          
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16,)),
                    Text("posted  "),
                    Text(
                        "${DateFormat('MMM, d ,H:mm a').format(post.timestamp)}"),
                    Spacer(
                      flex: 10,
                    ),
                    if (role != 'intern' && role != 'regular')
                      buildPostMenu(post),
                  ]),
                  Container(
                      child: Row(children: [
                    Container(
                      width: 250,
                      child: Text(
                        post.content,
                        style: TextStyle(fontSize: 13.0),
                      ),
                    ),
                  ])),
                  SizedBox(height: 8.0),
                  if (post.pictures.isNotEmpty)
                    Column(
                      children: post.pictures.map((picture) {
                        picture = picture.startsWith('/')
                            ? picture.substring(1)
                            : picture;
                        String completeUrl =
                            'http://192.168.18.12:4001/$picture';
                        return Image.network(completeUrl);
                      }).toList(),
                    ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {
                          // if (!hasLiked) {
                          //   updateLikes(post.id, hasLiked);
                          // }
                          if (!likedPostIds.contains(post.id)) {
                            updateLikes(post.id, hasLiked);
                            // Add the post ID to the likedPostIds set
                            setState(() {
                              likedPostIds.add(post.id);
                            });
                          }
                        },
                        icon: Icon(
                          Icons.thumb_up,
                          color: likedPostIds.contains(post.id)
                              ? Colors.blue
                              : Colors.grey,
                        ),
                        label: Text(""),
                      ),
                      SizedBox(width: 8.0),
                      TextButton.icon(
                          onPressed: () {
                            showCommentDialog(post);
                          },
                          icon: Icon(Icons.comment_rounded),
                          label: Text("")),
                      SizedBox(width: 8.0),
                    ],
                  ),
                  Text('Likes: ${post.likes}'),
                  SizedBox(height: 8.0),
                  ExpansionTile(
                    title: Text('Comments (${post.comments.length})'),
                    initiallyExpanded: areCommentsExpanded,
                    onExpansionChanged: (expanded) {
                      setState(() {
                        areCommentsExpanded = expanded;
                      });
                    },
                    children: [
                      // Add a ListView to display comments
                      // ListView.builder(
                      //   shrinkWrap: true,
                      //   itemCount: post.comments.length,
                      //   itemBuilder: (context, commentIndex) {
                      //     return ListTile(
                      //       subtitle: Text(post.comments[commentIndex]),
                      //     );
                      //   },
                      // ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: post.comments.length,
                        itemBuilder: (context, commentIndex) {
                          return FutureBuilder(
                            future: fetchFullname(
                                post.comments[commentIndex]), // Fetch fullname
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(); // Show loading indicator while fetching
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                String fullname =
                                    snapshot.data.toString();
                                return ListTile(
                                  title: Text(post.fullname),
                                  subtitle: Text(post.comments[commentIndex]),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
