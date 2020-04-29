import 'package:flutter/material.dart';
import 'package:watchyou/loginscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double screenHeight;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.brown,
      ),
      title: 'Material App',
      home: Scaffold(
          body: Container(
        child: Stack(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/splash.jpg'),
                        fit: BoxFit.cover))),
            Container(height: 300, child: ProgressIndicator())
          ],
        ),
      )),
    );
  }
}
 
class ProgressIndicator extends StatefulWidget {

  @override
  _ProgressIndicatorState createState() => new _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator> 
with SingleTickerProviderStateMixin{
  AnimationController controller;
  Animation<double> animation;

 @override
  void initState() { 
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 2000),vsync: this);
      animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          if (animation.value>0.99) {
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(
                builder: (BuildContext context)=> LoginScreen()));
          }
        });
      });
      controller.repeat();
  }
  
  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return new Center(
      child: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
           new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Expanded(
                flex: 3,
                child: new Container(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                    )),
              ),
              CircularProgressIndicator(
              backgroundColor: Colors.grey,
              valueColor: new AlwaysStoppedAnimation<Color>(
                Colors.black),
              ),
            ],  
          ),
         ],
      ),
    ) ;
  }
}