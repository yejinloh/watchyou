import 'package:flutter/material.dart';
import 'package:watchyou/user.dart';
 
void main() => runApp(MainScreen());
 
class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({Key key, this.user}) : super(key:key);

  @override
  _MainScreenState createState() => _MainScreenState();
    
  }
  
  class _MainScreenState extends State<MainScreen>{
  @override
  Widget build(BuildContext context) {
    
    return null;
  }
}
