import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:online_note/behavior/disable_overscroll.dart';
import 'package:online_note/pages/home_page.dart';
import 'package:online_note/widgets/buttonwidget.dart';
import 'package:online_note/widgets/textfieldwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _loading = false;

  final cUsername = TextEditingController();
  final cPassword = TextEditingController();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Color(0xff202125),
          body: Container(
            alignment: Alignment.center,
            child: ScrollConfiguration(
              behavior: DisableOverscroll(),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: EdgeInsets.all(35.0),
                    child: Form(
                      key: _loginFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(
                            image: AssetImage('assets/logo.png'),
                            height: 35,
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          TextFieldWidget(
                            textController: cUsername,
                            hintText: "Username",
                            obscureText: false,
                            prefixIconData: Icons.account_circle,
                            isAutoValidator: true,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextFieldWidget(
                                textController: cPassword,
                                hintText: "Password",
                                obscureText: true,
                                prefixIconData: Icons.lock,
                                isAutoValidator: true,
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              InkWell(
                                onTap: () {},
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          ButtonWidget(
                            isLoading: _loading,
                            title: "Login",
                            onTapFunction: () {
                              if(_loginFormKey.currentState.validate()){
                                _loading = true;
                                submitDataLogin();
                              }
                            },
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          ButtonWidget(
                            title: "Register",
                            hasBorder: true,
                            onTapFunction: () {
                              Navigator.pushNamed(context, '/register');
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  submitDataLogin() async {
    var data;
    setState(() {
      _loading = true;
    });
    try{
      final responseData = await http.post("https://alkalynxt.000webhostapp.com/udacoding_note/login/", body: {
        "username": cUsername.text,
        "password": cPassword.text,
      });
      data = jsonDecode(responseData.body);
      setState(() {
        _loading = false;
      });
    }on SocketException{
      toast("No Internet Connection");
      setState(() {
        _loading = false;
      });
    }

    final value = data["value"];
    final message = data["message"];
    final dataID = data["user_id"];
    final dataName = data["name"];
    final dataUsername = data["username"];
    final dataEmail = data["email"];
    final dataPhone = data["phone"];

    setState(() {
      if(value==1){
        setDataPref(value: value, id: dataID, name: dataName, username: dataUsername, email: dataEmail, phone: dataPhone);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));
      }
      toast(message);
    });
  }

  setDataPref({int value, String id, String name, String username, String email, String phone}) async {
    var sharedPreference = await SharedPreferences.getInstance();
    setState(() {
      sharedPreference.setInt("value", value);
      sharedPreference.setString("sID", id);
      sharedPreference.setString("sName", name);
      sharedPreference.setString("sUsername", username);
      sharedPreference.setString("sEmail", email);
      sharedPreference.setString("sPhone", phone);
    });
  }


  toast(String message) {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xff6aa0e1),
        textColor: Colors.black,
        fontSize: 16.0);
  }

}