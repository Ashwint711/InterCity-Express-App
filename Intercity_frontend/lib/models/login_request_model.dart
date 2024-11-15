//Creating a LoginRequestModel - It is a model(class) which i will use to convert login details to json.
//For that i need two methods -
//1.toJson - This function will convert given data into json format which can transferred over the net.
//2.fromJson - It will be used to convert http response from json to HashMap.

// class LoginRequestModel {
//   String? username;
//   String? password;

//   LoginRequestModel({this.username, this.password});

//   LoginRequestModel.fromJson(Map<String, dynamic> json) {
//     username = json['username'];
//     password = json['password'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['username'] = this.username;
//     data['password'] = this.password;
//     return data;
//   }
// }

class LoginRequestModel {
  LoginRequestModel({
    required this.username,
    required this.password,
  });
  String? username;
  String? password;

  LoginRequestModel.fromJson(Map<String, dynamic> data) {
    username = data['username'];
    password = data['password'];
  }

  //Creating a Map Object from variables.
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    return data;
  }
}

