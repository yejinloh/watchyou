//import 'dart:async';

import 'package:flutter/material.dart';
import 'package:watchyou/registerscreen.dart';
import 'package:watchyou/mainscreen.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:watchyou/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

final TextEditingController _emailcontroller = new TextEditingController();
final TextEditingController _passwordcontroller = new TextEditingController();

bool rememberMe = false;

void main() => runApp(LoginScreen());

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
   TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _passEditingController = new TextEditingController();
  String urlLogin = "https://yjjmappflutter.com/WatchYou/php/login_user.php";

  @override
  void initState() {
    loadpref();
    print('I AM INISTATE');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 50),
              child: Center(
                child: Image.asset('assets/images/logo.png',
                    height: 100.0, width: 200.0),
              ),
            ),
            Text('\n'),
            TextField(
              style: TextStyle(fontFamily: 'Do Hyeon', fontSize: 20),
              controller: _emailcontroller,
              decoration: InputDecoration(
                hintText: "Email (Ex: example12@gmail.com)",
                hintStyle: TextStyle(fontSize: 20.0, color: Colors.black38),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.teal,
                  ),
                ),
                prefixIcon: const Icon(
                  Icons.email,
                  color: Colors.white,
                ),
              ),
            ),
            TextField(
              style: TextStyle(fontFamily: 'Do Hyeon', fontSize: 20),
              controller: _passwordcontroller,
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(fontSize: 20.0, color: Colors.black38),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.teal,
                  ),
                ),
                prefixIcon: const Icon(
                  Icons.security,
                  color: Colors.white,
                ),
              ),
              obscureText: _obscureText,
            ),
            new FlatButton(
                onPressed: _toggle,
                child: new Text(_obscureText ? "Show" : "Hide")),
            Row(
              children: <Widget>[
                Checkbox(
                  value: rememberMe,
                  onChanged: (bool value) {
                    _onRememberMeChanged(value);
                  },
                ),
                Text('Remember Me ',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            GestureDetector(
              onTap: _loginUser,
              child: roundedRectButton("Login", loginGradients, false),
            ),
            Text("Don't have an account? ", style: TextStyle(fontSize: 16.0)),
            GestureDetector(
              onTap: _registerUser,
              child: roundedRectButton("Register", registerGradients, false),
            ),
          ],
        ),
      ),
    );
  }

  void _onRememberMeChanged(bool newValue) => setState(() {
        rememberMe = newValue;
        print(rememberMe);
        if (rememberMe) {
          savepref(true);
        } else {
          savepref(false);
        }
      });

        /*void _loginUser() async {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Log in...");
      pr.show();
      String _email = _emailEditingController.text;
      String _password = _passEditingController.text;
      http.post(urlLogin, body: {
        "email": _email,
        "password": _password,
      })
          //.timeout(const Duration(seconds: 4))
          .then((res) {
        print(res.body);
        var string = res.body;
        List userdata = string.split(",");
        if (userdata[0] == "success") {
          User _user = new User(
              name: userdata[1],
              email: _email,
              password: _password,
              phone: userdata[3],
              credit: userdata[4],
              datereg: userdata[5],
              quantity: userdata[6]);
          //pr.dismiss();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MainScreen(
                        user: _user,
                      )));
        } else {
          //pr.dismiss();
          Toast.show("Login failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
       // pr.dismiss();
      });
    } on Exception catch (_) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }*/

  void _loginUser() {
    ProgressDialog pr = new ProgressDialog(context,
    type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message:"Log in...");
    pr.show();
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
  }

  void loadpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    if (email.length > 1) {
      setState(() {
        _emailcontroller.text = email;
        _passwordcontroller.text = password;
        rememberMe = true;
      });
    }
  }

  void savepref(bool value) async {
    String email = _emailcontroller.text;
    String password = _passwordcontroller.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (value) {
      await prefs.setString('email', email);
      await prefs.setString('pass', password);

      Toast.show("Preferences have been saved", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        _emailcontroller.text = '';
        _passwordcontroller.text = '';
        rememberMe = false;
      });
      Toast.show("Preferences have removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  void _registerUser() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RegisterScreen()));
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}

Widget roundedRectButton(
    String title, List<Color> gradient, bool isEndIconVisible) {
  return Builder(builder: (BuildContext mContext) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Stack(
        alignment: Alignment(1.0, 0.0),
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(mContext).size.width / 1.7,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            child: Text(title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500)),
            padding: EdgeInsets.only(top: 16, bottom: 16),
          ),
        ],
      ),
    );
  });
}

const List<Color> loginGradients = [
  Color(0xDD1123DD),
  Color(0xFF0179DD),
];

const List<Color> registerGradients = [
  Color(0xFF0179DD),
  Color(0xDD1123DD),
];
