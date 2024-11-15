import 'package:flutter/material.dart';
import 'package:login_app/config.dart';
import 'package:login_app/models/register_request_model.dart';
import 'package:login_app/services/api_service.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<RegisterPage> {
  bool isAPIcallProcess = false;
  bool hidePassword = true;
  //globalFormKey will be used across application to uniquely identify the form.
  GlobalKey<FormState> globalRegisterFormKey = GlobalKey<FormState>();
  String? username;
  String? password;
  String? email;
  String? phone;
  String? userType; //Agent or Passenger

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: HexColor("#283B71"),
      //ProgreeHUD is highly customizable widget to display progress indicator
      body: ProgressHUD(
        //isAsyncCall attribute takes a boolean value and displays Progres indicator if the value is True.
        inAsyncCall: isAPIcallProcess,
        //UniqueKey() : Creates a key that is equal only to itself.
        key: UniqueKey(),
        opacity: 0.3,
        child: Form(
          //assigned globalFormKey to Form widget so that i can access this form data across my application.
          key: globalRegisterFormKey,
          child: _registerUI(context),
        ),
      ),
    ));
  }

  Widget _registerUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Train image and white background
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3.7,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.orange,
                  Colors.white,
                  Colors.lightGreen,
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
              ),
            ),
            // child: Column(
            //   children: [
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/trainlogo.png',
                width: 200,
                fit: BoxFit.contain,
              ),
            ),
            //   ],
            // ),
          ), // child 1 end
          const Padding(
            padding: EdgeInsets.only(
              left: 20,
              top: 50,
              bottom: 30,
            ),
            child: Text(
              "R E G I S T E R",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
          // Username textfield start
          FormHelper.inputFieldWidget(
            context,
            'username',
            'Username',
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return "Username can\t be empty.";
              }
              return null;
            },
            (onSavedVal) {
              username = onSavedVal;
            },
            borderFocusColor: Colors.white,
            prefixIconColor: Colors.white,
            borderColor: Colors.white,
            textColor: Colors.white,
            hintColor: Colors.white.withOpacity(0.7),
            borderRadius: 10,
            showPrefixIcon: true,
            prefixIcon: const Icon(Icons.person),
          ), //Username textfield end
          const SizedBox(height: 10),

          //Email textfield start
          FormHelper.inputFieldWidget(
            context,
            'email',
            'Email',
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return "Email can't be empty.";
              }

              return null;
            },
            (onSavedVal) {
              email = onSavedVal;
            },
            borderFocusColor: Colors.white,
            prefixIconColor: Colors.white,
            borderColor: Colors.white,
            textColor: Colors.white,
            hintColor: Colors.white.withOpacity(0.7),
            borderRadius: 10,
            showPrefixIcon: true,
            prefixIcon: const Icon(Icons.email),
          ),
          //Email textfield end
          const SizedBox(height: 10),

          //Password textfield start
          FormHelper.inputFieldWidget(
            context,
            'password',
            'Password',
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return "Password can't be empty.";
              } else {
                password = onValidateVal;
              }
              return null;
            },
            (onSavedVal) {
              password = onSavedVal;
            },
            borderFocusColor: Colors.white,
            prefixIconColor: Colors.white,
            borderColor: Colors.white,
            textColor: Colors.white,
            hintColor: Colors.white.withOpacity(0.7),
            borderRadius: 10,
            showPrefixIcon: true,
            prefixIcon: const Icon(Icons.lock),
          ), //Password textfield end
          const SizedBox(height: 10),
          //Re-enter Password textfield start
          FormHelper.inputFieldWidget(
            context,
            'password',
            'Re-enter password',
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return "Re-enter password";
              } else if (onValidateVal != password) {
                return "Password doesn't match.";
              }
              return null;
            },
            (onSavedVal) {
              password = onSavedVal;
            },
            borderFocusColor: Colors.white,
            prefixIconColor: Colors.white,
            borderColor: Colors.white,
            textColor: Colors.white,
            hintColor: Colors.white.withOpacity(0.7),
            borderRadius: 10,
            showPrefixIcon: true,
            prefixIcon: const Icon(Icons.lock),
          ), //Re-enter Password textfield end

          const SizedBox(height: 20),
          Center(
            child: FormHelper.submitButton(
              "Register",
              () {
                //DISMISS KEYBOARD after click
                FocusScope.of(context).unfocus();

                if (validateAndSave()) {
                  setState(() {
                    isAPIcallProcess = true;
                  });

                  RegisterRequestModel model = RegisterRequestModel(
                    username: username,
                    password: password,
                    email: email,
                  );

                  APIService.register(model).then((response) {
                    setState(() {
                      isAPIcallProcess = false;
                    });

                    if (response.data != null) {
                      //Dialog box
                      FormHelper.showSimpleAlertDialog(
                        context,
                        Config.appName,
                        'Registration Successfull. Please login to the account.',
                        'OK',
                        () {
                          Navigator.pop(context);
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => true,
                          );
                        },
                      );
                    } else {
                      FormHelper.showSimpleAlertDialog(
                        context,
                        Config.appName,
                        response.message,
                        'OK',
                        () => Navigator.pop(context),
                      );
                    }
                  });
                }
              },
              btnColor: HexColor("#283B71"),
              txtColor: Colors.white,
              borderColor: Colors.white,
              borderRadius: 10,
            ),
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = globalRegisterFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
