import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../api.dart';

class MessageService {
  // static const String baseUrl = 'http://localhost:3000'; // Replace with your server URL

  Future<Map<String, dynamic>> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData; // Return the nested 'message' object
      } else {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<String> receiveMessage(String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/receive'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'otp': otp,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final String message = responseData['message']['message'] as String;
        return message;
      } else {
        throw Exception('Failed to receive message');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
