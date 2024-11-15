import 'dart:convert';

RegisterResponseModel registerResponseModel(String str) {
  return RegisterResponseModel.fromJson(json.decode(str));
}

class RegisterResponseModel {
  RegisterResponseModel({
    required this.message,
    required this.data,
  });
  late final String message;
  late final RegisterData? data;

  RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? RegisterData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['message'] = message;
    data['data'] = this.data!.toJson();

    return data;
  }
}

class RegisterData {
  String? username;
  String? email;
  String? password;
  String? id;

  RegisterData(
      {required this.username,
      required this.email,
      required this.password,
      required this.id});

  RegisterData.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    password = json['password'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['email'] = email;
    data['password'] = password;
    data['id'] = id;
    return data;
  }
}
