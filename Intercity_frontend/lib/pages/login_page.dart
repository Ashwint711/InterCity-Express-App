import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:login_app/config.dart';
import 'package:login_app/models/login_request_model.dart';
import 'package:login_app/services/api_service.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool isAPIcallProcess = false;
  bool hidePassword = true;
  //globalFormKey will be used across application to uniquely identify the form.
  GlobalKey<FormState> globalLoginFormKey = GlobalKey<FormState>();
  String? username;
  String? password;

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
          key: globalLoginFormKey,
          child: _loginUI(context),
        ),
      ),
    ));
  }

  Widget _loginUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //child 1
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
              "L O G I N",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
          //FORM STARTING
          FormHelper.inputFieldWidget(
            context,
            'username',
            'Username',
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return "Username can't be empty.";
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
          ),
          const SizedBox(height: 10),
          FormHelper.inputFieldWidget(
            context,
            'password',
            'Password',
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return "Password can't be empty.";
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
            obscureText: hidePassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  hidePassword = !hidePassword;
                });
              },
              icon: Icon(
                color: Colors.white.withOpacity(0.7),
                hidePassword ? Icons.visibility_off : Icons.visibility,
              ),
            ),
          ),
          // Forget password hyperlink starting
          Padding(
            padding: const EdgeInsets.only(top: 25, right: 25),
            child: Align(
              alignment: Alignment.bottomRight,
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Forget Password?',
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('Forget password');
                        },
                    )
                  ],
                ),
              ),
            ),
          ), // Forget password hyperlink ending
          const SizedBox(height: 20),
          Center(
            child: FormHelper.submitButton(
              "Login",
              () {
                //DISMISS KEYBOARD after click
                FocusScope.of(context).unfocus();

                if (validateAndSave()) {
                  setState(() {
                    //It will start loader
                    isAPIcallProcess = true;
                  });

                  LoginRequestModel model = LoginRequestModel(
                    username: username,
                    password: password,
                  );

                  APIService.login(model).then((response) {
                    setState(() {
                      //It will start loader
                      isAPIcallProcess = false;
                    });

                    //If True that means user is successfully logged in
                    //thus we'll remve previous pages from stack
                    if (response) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (route) => false,
                      );
                    } else {
                      FormHelper.showSimpleAlertDialog(
                        context,
                        Config.appName,
                        'Invalid Username/Password',
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
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'OR',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),

          Center(
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Don\'t have an account? ',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  TextSpan(
                      text: 'Sign Up',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          //Sign up functionality
                          Navigator.pushNamed(context, '/register');
                        })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final formData = globalLoginFormKey.currentState;

    //form!.validate() - Validates every [FormField] that is a descendant of this
    //[Form], and returns true if there are no errors
    if (formData!.validate()) {
      //.save() - Saves every [FormField] that is a descendant of this [Form].
      formData.save();
      return true;
    } else {
      return false;
    }
  }
}
