// import 'dart:convert';
// import 'package:frontend/message.model.dart';
// import 'package:frontend/user.model.dart';
// import 'package:http/http.dart' as http;

// class MessageService {
//   final String baseUrl = 'http://192.168.1.157:4000/api/messages';
//   final String url = 'http://192.168.1.157:4000/getallusers';
//   Future<List<User>> getUsers() async {
//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       final List<dynamic> jsonUsers = jsonDecode(response.body);
//       return jsonUsers
//           .map((json) => User(userId: json['_id'], username: json['userid'],fullname: json['fullname']))
//           .toList();
//     } else {

//       throw Exception('Failed to load users');
//     }
//   }

//   Future<void> sendMessage(
//       String senderUserId, String receiverUserId, String text) async {
//     final response = await http.post(
//       Uri.parse(baseUrl),
//       body: jsonEncode(
//           {'sender': senderUserId, 'receiver': receiverUserId, 'text': text}),
//       headers: {'Content-Type': 'application/json'},
//     );

//     if (response.statusCode == 201) {
//       print('Message sent successfully');
//     } else {
//       print('Failed to send message');
//     }
//   }

//   Future<List<Message>> getMessages(String sender, String receiver) async {
//     final response = await http.get(Uri.parse('$baseUrl/$sender/$receiver'));

//     if (response.statusCode == 200) {
//       final List<dynamic> jsonMessages = jsonDecode(response.body);
//       return jsonMessages.map((json) => Message.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load messages');
//     }
//   }
// }
import 'dart:convert';
import 'package:frontend/message.model.dart';
import 'package:frontend/user.model.dart';
import 'package:http/http.dart' as http;

class MessageService {
  final String baseUrl = 'http://192.18.12:4001/api/messages';
  final String url = 'http://192.168.18.12:4001/getallusers';

  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> jsonUsers = jsonDecode(response.body);
      return jsonUsers
          .map((json) => User(
              id: json['_id'],
              username: json['userid'],
              fullname: json['fullname']))
          .toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> sendMessage(
      String senderFullName, String receiverFullName, String text) async {
    final senderUserId = await getUserIdByFullName(senderFullName);
    final receiverUserId = await getUserIdByFullName(receiverFullName);

    if (senderUserId != null && receiverUserId != null) {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: jsonEncode(
            {'sender': senderUserId, 'receiver': receiverUserId, 'text': text}),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);
      if (response.statusCode == 201) {
        // Update chat history for both sender and receiver
        print(Message.fromJson(jsonDecode(response.body)));
        await updateChatHistory(
            senderUserId, Message.fromJson(jsonDecode(response.body)));
        await updateChatHistory(
            receiverUserId, Message.fromJson(jsonDecode(response.body)));
        print('Message sent successfully');
      } else {
        print('Failed to send message');
      }
    } else {
      // Handle the case where either senderUserId or receiverUserId is null
      print('Error: SenderUserId or ReceiverUserId is null');
    }
  }

  Future<List<Message>> getMessages(String sender, String receiver) async {
    final response = await http.get(Uri.parse('$baseUrl/$sender/$receiver'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonMessages = jsonDecode(response.body);
      return jsonMessages.map((json) => Message.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<void> updateChatHistory(String id, Message message) async {
    List<Message> chatHistory = await getChatHistory(id);

    // Add the new message to the chat history
    chatHistory.add(message);

    // Save the updated chat history to the database
    await saveChatHistory(id, chatHistory);
  }

  Future<String?> getUserIdByFullName(String Fullname) async {
    final response = await http
        .get(Uri.parse('http://192.168.18.12:4001/getidbyfullname/$Fullname'));

    if (response.statusCode == 200) {
      final dynamic responseBody = jsonDecode(response.body);
      print(Fullname);
      // Check if the response body is not null and contains the expected field
      if (responseBody != null && responseBody['_id'] != null) {
        print(responseBody['_id']);
        return responseBody['_id'];
      } else {
        // Handle the case where the expected field is not present in the response
        print('Error: Missing _id field in the response body');
        return null;
      }
    } else {
      print('Error: Failed to get _id (${response.statusCode})');
      return null;
    }
  }

  Future<List<Message>> getChatHistory(String id) async {
    final response = await http.get(
        Uri.parse('http://192.168.18.12:4001/api/messages/getchathistory/$id'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonMessages = jsonDecode(response.body);
      return jsonMessages.map((json) => Message.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load chat history');
    }
  }

  Future<void> saveChatHistory(String id, List<Message> chatHistory) async {
    await http.post(
      Uri.parse('http://192.168.18.12:001/api/messages/savechathistory/$id'),
      body: jsonEncode(chatHistory.map((message) => message.toJson()).toList()),
      headers: {'Content-Type': 'application/json'},
    );
  }
}
