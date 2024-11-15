import 'dart:convert';

//Converting String to LoginResponseModel type
LoginResponseModel loginResponseJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  LoginResponseModel({
    required this.message,
    required this.data,
  });
  late String message;
  late LoginData data;

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = LoginData.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['message'] = message;
    data['data'] = this.data.toJson();

    return data;
  }
}

class LoginData {
  String? username;
  String? email;
  String? password;
  String? date;
  String? id;

  LoginData({this.username, this.email, this.date, this.id, this.password});

  LoginData.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    date = json['date'];
    id = json['id'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['email'] = email;
    data['date'] = date;
    data['id'] = id;
    data['password'] = password;
    return data;
  }
}
