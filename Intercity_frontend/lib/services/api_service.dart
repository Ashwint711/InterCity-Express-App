import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:login_app/config.dart';
// import 'package:login_app/models/login_response_model.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';

class APIService {
  //Creating a client to make HTTP requests
  static var client = http.Client();

  static Future<bool> login(LoginRequestModel model) async {
    // var requestHeaders = {
    //   'Content-Type': 'application/json',
    // };

    var url = Uri.http(Config.apiURL,
        '${Config.loginAPI}/${model.username}/${model.password}');
    print(url);
    //response will contain data revieved from a http call

    var response = await client.get(url);
    var body = response.body;
    List<dynamic> userData = jsonDecode(body);
    print(userData);
    Map<String, dynamic> responseData;
    if (userData.isEmpty) {
      return false;
    }
    responseData = userData[0];
    print(responseData);
    if (responseData['username'] == model.username &&
        responseData['password'] == model.password) {
      return true;
    } else {
      return false;
    }
  }

  //Register functionality
  static Future<RegisterResponseModel> register(
      RegisterRequestModel model) async {
    var requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiURL, Config.registerAPI);

    //response will contain data revieved from a http call

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
      // body: jsonEncode({
      //   "username": model.username,
      //   "email": model.email,
      //   "password": model.password,
      // }),
    );

    var resp = jsonDecode(response.body);

    RegisterData data = RegisterData(
      username: resp['username'],
      email: resp['email'],
      password: resp['password'],
      id: resp['id'].toString(),
    );

    RegisterResponseModel mod =
        RegisterResponseModel(message: "message", data: data);
    return mod;
  }
}
