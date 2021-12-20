import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:openid_client/openid_client_io.dart';
import 'package:url_launcher/url_launcher.dart';

class Authentication {
  http.Client client;

  Authentication({required this.client});

  Future<Map<String, dynamic>> signIn({
    required String username,
    required String password,
  }) async {
    try {
      Uri url = Uri.parse(
          'https://auth.odd.limited/auth/realms/Odds/protocol/openid-connect/token');
      http.Response response = await client.post(
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
    } on http.ClientException catch (e) {
      throw Exception("Network error: $e");
    }
  }

  Future<Map<String, dynamic>> ssoSignIn() async {
    Uri url = Uri.parse('https://auth.odd.limited/auth/realms/Odds');
    var issuer = await Issuer.discover(url);
    var client = Client(
      issuer,
      'flutter',
      clientSecret: '2e9ab7fd-423d-4944-8496-c2997a06ba14',
    );

    urlLauncher(String url) async {
      if (await canLaunch(url)) {
        await launch(url, forceWebView: true);
      } else {
        throw 'Could not launch $url';
      }
    }

    var authenticator = Authenticator(
      client,
      scopes: ['email', 'profile'],
      port: 4200,
      urlLancher: urlLauncher,
    );

    Credential credential = await authenticator.authorize();
    closeWebView();

    TokenResponse response = await credential.getTokenResponse();
    return Jwt.parseJwt(response.accessToken!);
  }
}

class UsernameOrPasswordError implements Exception {}
