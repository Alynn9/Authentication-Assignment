import 'dart:convert';
import 'package:auth_app/constants/endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:auth_app/constants/keys.dart';
import 'package:auth_app/main.dart';

class AuthService {
  static Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(Endpoints.login),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'lang': 'EN',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      hiveBox.put(Keys.authToken, responseBody['jwttoken']);
      hiveBox.put(Keys.refreshToken, responseBody['refreshtoken']['token']);
      var parsed = _parseJwt(responseBody['jwttoken']);
      DateTime exp = DateTime.fromMicrosecondsSinceEpoch(parsed["exp"]);
      hiveBox.put(Keys.exp, exp);

      return true;
    } else {
      return false;
    }
  }

  static Future<bool> refreshToken() async {
    final response = await http.post(
      Uri.parse(Endpoints.refresh),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'refreshtoken': hiveBox.get(Keys.refreshToken),
        'jwttoken': hiveBox.get(Keys.authToken),
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      hiveBox.put(Keys.authToken, responseBody['jwttoken']);
      hiveBox.put(Keys.refreshToken, responseBody['refreshtoken']['token']);
      return true;
    } else {
      return false;
    }
  }

  static Future<int?> getGeneralReport() async {
    var exp = hiveBox.get(Keys.exp);
    if (exp != null && exp.isBefore(DateTime.now())) {
      var refreshed = await refreshToken();
      if (!refreshed) {
        return null;
      }
    }
    final response = await http.post(
      Uri.parse(Endpoints.generalReport),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${hiveBox.get(Keys.authToken)}',
      },
      body: jsonEncode(<String, String>{
        'fromdate': '2024-1-1',
        'todate': '2024-4-1',
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody['totalcount'];
    } else {
      return null;
    }
  }

  static Future<void> logout() async {
    hiveBox.delete(Keys.authToken);
    hiveBox.delete(Keys.refreshToken);
    hiveBox.delete(Keys.exp);
  }

  static Map<String, dynamic> _parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }
}
