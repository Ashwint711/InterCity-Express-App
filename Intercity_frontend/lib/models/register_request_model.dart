class RegisterRequestModel {
  int? id;
  String? username;
  String? password;
  String? email;

  RegisterRequestModel(
      {required this.username, required this.password, required this.email});

  RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    password = json['password'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    data['email'] = email;
    return data;
  }
}
