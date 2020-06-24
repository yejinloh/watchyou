import 'package:flutter/material.dart';
import 'package:watchyou/loginscreen.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

void main() => runApp(RegisterScreen());

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscureText = true;
  bool _isChecked = false;
  String urlRegister ="https://yjjmappflutter.com/WatchYou/php/register_user.php";
  TextEditingController _name = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/register.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Center(
                child: Image.asset('assets/images/logo.png',
                    height: 100.0, width: 200.0),
              ),
            ),

            TextField(
              style: TextStyle(color: Colors.white,
                fontFamily: 'Do Hyeon', fontSize: 20),
              controller: _name,
              decoration: InputDecoration(
                hintText: "Username",
                hintStyle: TextStyle(fontSize: 20.0, color: Colors.black38),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.teal,
                  ),
                ),
                prefixIcon: const Icon(
                  Icons.people,
                  color: Colors.white,
                ),
              ),
            ),

            TextField(
              style: TextStyle(color: Colors.white,
                fontFamily: 'Do Hyeon', fontSize: 20),
              controller: _email,
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
              style: TextStyle(color: Colors.white,
                fontFamily: 'Do Hyeon', fontSize: 20),
              controller: _phone,
              decoration: InputDecoration(
                hintText: "Phone (Ex: 0129876543)",
                hintStyle: TextStyle(fontSize: 20.0, color: Colors.black38),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.teal,
                  ),
                ),
                prefixIcon: const Icon(
                  Icons.phone,
                  color: Colors.white,
                ),
              ),
            ),

            TextField(
              style: TextStyle(color: Colors.white,
                fontFamily: 'Do Hyeon', fontSize: 20),
              controller: _password,
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Checkbox(
                  value: _isChecked,
                  onChanged: (bool value) {
                    _onChanged(value);
                  },
                ),
                GestureDetector(
                  onTap: _showEULA,
                  child: Text('I agree the terms. ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: _onConfirm,
                    child:
                        roundedRectButton("Register", registerGradients, false),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('\t\t\t\t\t\t'),
                Text(
                  'Already Register ?',
                  style: TextStyle(fontSize: 16.0),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: _loginScreen,
                    child: roundedRectButton("Login", loginGradients, false),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
              width: 150,
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

  static const List<Color> loginGradients = [
    Color(0xFFFF9945),
    Color(0xFFFc6076),
  ];

  static const List<Color> registerGradients = [
    Color(0xFFFF2345),
    Color(0xFFFc6076),
  ];

  void _onChanged(bool value) {
    setState(() {
      _isChecked = value;
    });
  }

  void _onConfirm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Register Confirmation"),
          content: new Container(
            height: 50,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: _showEULA,
                  child: Text('Are you sure you want to register?',
                      style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
              onPressed: _onRegister,
              
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onRegister() {
    String name = _name.text;
    String email = _email.text;
    String phone = _phone.text;
    String password = _password.text;

    if (!_isChecked) {
      Toast.show("Please Accept Term", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    http.post(urlRegister, body: {
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
    }).then((res) {
      if (res.body == "success") {
        Navigator.pop(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
        Toast.show("Registration success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        Toast.show("Registration failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _loginScreen() {
    Navigator.pop(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  void _showEULA() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("EULA"),
          content: new Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.0,
                            ),
                            text:
                                "This End-User License Agreement is a legal agreement between you and Slumberjer This EULA agreement governs your acquisition and use of our MY.GROCERY software (Software) directly from Slumberjer or indirectly through a Slumberjer authorized reseller or distributor (a Reseller).Please read this EULA agreement carefully before completing the installation process and using the MY.GROCERY software. It provides a license to use the MY.GROCERY software and contains warranty information and liability disclaimers. If you register for a free trial of the MY.GROCERY software, this EULA agreement will also govern that trial. By clicking accept or installing and/or using the MY.GROCERY software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement. If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.This EULA agreement shall apply only to the Software supplied by Slumberjer herewith regardless of whether other software is referred to or described herein. The terms also apply to any Slumberjer updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for MY.GROCERY. Slumberjer shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of Slumberjer. Slumberjer reserves the right to grant licences to use the Software to third parties"
                            )),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}