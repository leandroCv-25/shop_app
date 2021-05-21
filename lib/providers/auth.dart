//dart
import 'dart:convert';

//flutter
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> signup(String email, String password) async {
    const String _url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAQvaL8n8WxOT7zDVeQH6L6dkD8FyK2I24";
    try{
      final response = await http.post(
      _url,
      body: json.encode(
        {
          "email": email,
          "password": password,
          "returnSecureToken": true,
        },
      ),
    );
    print(json.decode(response.body));
    } catch(error){
      throw error;
    }
  }
}
