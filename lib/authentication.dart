import 'dart:convert';

import 'package:http/http.dart';
import 'package:jwt_decode/jwt_decode.dart';

class Authentication {
  Client client;

  Authentication({required this.client});

  Future<Map<String, dynamic>> signIn({
    required String username,
    required String password,
  }) async {
    try {
      Uri url = Uri.parse(
          'https://auth.odd.limited/auth/realms/Odds/protocol/openid-connect/token');
      Response response = await client.post(
        url,
        body: {
          'client_id': 'api',
          'grant_type': 'password',
          'client_secret': 'ada910b4-f211-45fa-abec-18156863362a',
          'scope': 'openid',
          'username': username,
          'password': password
        },
      );
      if (response.statusCode != 200) {
        throw UsernameOrPasswordError();
      }

      Map<String, dynamic> decoded = jsonDecode(
        utf8.decode(response.bodyBytes),
      );
      Map<String, dynamic> payload =
          Jwt.parseJwt(decoded["access_token"] as String);
      return payload;
    } on ClientException catch (e) {
      throw Exception("Network error: $e");
    }
  }
}

class UsernameOrPasswordError implements Exception {}
