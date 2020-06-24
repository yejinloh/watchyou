import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:watchyou/cartscreen.dart';
import 'package:watchyou/profilescreen.dart';
import 'package:watchyou/paymenthistoryscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:watchyou/user.dart';
import 'package:progress_dialog/progress_dialog.dart';
//import 'package:watchyou/product.dart';

void main() => runApp(MainScreen());

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List productdata;
  double screenHeight, screenWidth;
  String currentSelectedValue;
  SharedPreferences prefs;
  String cartquantity = "0";
  String titlecenter = "Loading products...";
  int quantity = 1;
  String server = "https://yjjmappflutter.com/WatchYou";
  List<String> _brand = [
    'Huawei',
    'Apple',
    'Xiaomi',
    'Fossil',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
    _read();
  }

  _read() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      currentSelectedValue = prefs.getString('key') ?? "Huawei";
      _sort(currentSelectedValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (productdata == null) {
      return WillPopScope(
          onWillPop: _onBackPress,
          child: Scaffold(
            drawer: mainDrawer(context),
              appBar: AppBar(
                title: Text('Product List'),
                backgroundColor: Colors.blueGrey,
              ),
              body: Container(
                  child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Loading Datas",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ))));
    } else {
      return WillPopScope(
        onWillPop: _onBackPress,
        child: Scaffold(
          drawer: mainDrawer(context),
          appBar: AppBar(
            title: Text('Product List'),
            backgroundColor: Colors.blueGrey,
            actions: <Widget>[
              new IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {}),
              new IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => CartScreen()));
                  })
            ],
          ),
          body: Center(
            child: Container(
                child: Column(children: <Widget>[
              DropdownButton<String>(
                hint: Text(
                  'Select Brand',
                  textAlign: TextAlign.center,
                ),
                value: currentSelectedValue,
                onChanged: (newValue) {
                  setState(() {
                    currentSelectedValue = newValue;
                  });
                  prefs.setString('key', currentSelectedValue);
                  _sort(currentSelectedValue);
                },
                items: _brand.map(
                  (String value) {
                    return DropdownMenuItem<String>(
                      child: Text(
                        value,
                        textAlign: TextAlign.center,
                      ),
                      value: value,
                    );
                  },
                ).toList(),
              ),
              Flexible(
                  child: GridView.count(
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                      childAspectRatio: (screenWidth / screenHeight) / 0.8,
                      children: List.generate(productdata.length, (index) {
                        return Card(
                          child: Column(children: <Widget>[
                            Container(
                                height: screenHeight / 5.0,
                                width: screenWidth / 2.5,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      imageUrl:
                                          "https://yjjmappflutter.com/WatchYou/images/${productdata[index]['code']}.jpg",
                                      placeholder: (context, url) =>
                                          new CircularProgressIndicator(
                                            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueGrey),),
                                      errorWidget: (context, url, error) =>
                                          new Icon(Icons.error),
                                    ))),
                            SizedBox(height: 4),
                            Text(productdata[index]['name'],
                                maxLines: 1,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                              "Price: RM" + productdata[index]['price'],
                              maxLines: 1,
                            ),
                            Text(
                              "Quantity: " + productdata[index]['quantity'],
                              maxLines: 1,
                            ),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              minWidth: 100,
                              height: 30,
                              child: Text(
                                'Add to Cart',
                              ),
                              color: Color.fromRGBO(44, 133, 172, 50),
                              textColor: Colors.white,
                              elevation: 10,
                              onPressed: () => _addtocartdialog(index),
                            ),
                          ]),
                        );
                      })))
            ])),
          ),
        ),
      );
    }
  }

  void _loadData() async{
    String urlLoad = "http://yjjmappflutter.com/WatchYou/php/loadProduct.php";
    await http.post(urlLoad, body: {}).then((res) {
     if (res.body == "nodata") {
        cartquantity = "0";
        titlecenter = "No product found";
        setState(() {
          productdata = null;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          productdata = extractdata["products"];
          cartquantity = widget.user.quantity;
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  Widget mainDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          
          ListTile(
              title: Text(
                "Payment History",
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    Navigator.pop(context),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                PaymentHistoryScreen(
                                  user: widget.user,
                                ))),
                  }),
          ListTile(
              title: Text(
                "User Profile",
                
              ),
              /*trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    Navigator.pop(context),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ProfileScreen(
                                  user: widget.user,
                                )))
                  }*/),
          /*Visibility(
            visible: _isadmin,
            child: Column(
              children: <Widget>[
                Divider(
                  height: 2,
                  color: Colors.white,
                ),
                Center(
                  child: Text(
                    "Admin Menu",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                    title: Text(
                      "My Products",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () => {
                          Navigator.pop(context),
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      AdminProduct(
                                        user: widget.user,
                                      )))
                        }),
                ListTile(
                  title: Text(
                    "Customer Orders",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward),
                ),
                ListTile(
                  title: Text(
                    "Report",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ],
            ),
          )*/
        ],
      ),
    );
  }

  void _sort(String currentSelectedValue) {
    String urlLoad = "http://yjjmappflutter.com/WatchYou/php/loadProduct.php";
    http.post(urlLoad, body: {
      "brand": currentSelectedValue,
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        productdata = extractdata["products"];
        FocusScope.of(context).requestFocus(new FocusNode());
      });
    });
  }

  Future<bool> _onBackPress() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text("Exit")),
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("Cancel")),
            ],
          ),
        ) ??
        false;
  }

  _addtocartdialog(int index) {
    quantity = 1;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, newSetState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Add " + productdata[index]['name'] + " to Cart?",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Select quantity of product",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () => {
                              newSetState(() {
                                if (quantity > 1) {
                                  quantity--;
                                }
                              })
                            },
                            child: Icon(
                              MdiIcons.minus,
                              color: Colors.blueGrey,
                            ),
                          ),
                          Text(
                            quantity.toString(),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          FlatButton(
                            onPressed: () => {
                              newSetState(() {
                                if (quantity <
                                    (int.parse(productdata[index]['quantity']) -
                                        2)) {
                                  quantity++;
                                } else {
                                  Toast.show("Quantity not available", context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                }
                              })
                            },
                            child: Icon(
                              MdiIcons.plus,
                              color: Colors.blueGrey
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              actions: <Widget>[
                MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      _addtoCart(index);
                    },
                    child: Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.blueGrey,
                      ),
                    )),
                MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.blueGrey,
                      ),
                    )),
              ],
            );
          });
        });
  }

  void _addtoCart(int index) {
    /*if (widget.user.email == "unregistered@grocery.com") {
      Toast.show("Please register first", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (widget.user.email == "admin@grocery.com") {
      Toast.show("Admin mode", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }*/
    try {
      int cquantity = int.parse(productdata[index]["quantity"]);
      print(cquantity);
      print(productdata[index]["code"]);
      //print(widget.user.email);
      if (cquantity > 0) {
        ProgressDialog pr = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: true);
        pr.style(message: "Add to cart...");
        pr.show();
        String urlLoadJobs = server + "/php/insertCart.php";
        http.post(urlLoadJobs, body: {
          //"email": widget.user.email,
          "procode": productdata[index]["code"],
          "quantity": quantity.toString(),
        }).then((res) {
          print(res.body);
          if (res.body == "failed") {
            Toast.show("Failed add to cart", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            //pr.dismiss();
            return;
          } else {
            List respond = res.body.split(",");
            setState(() {
              cartquantity = respond[1];
              widget.user.quantity = cartquantity;
            });
            Toast.show("Success add to cart", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
          //pr.dismiss();
        }).catchError((err) {
          print(err);
          // pr.dismiss();
        });
        // pr.dismiss();
      } else {
        Toast.show("Out of stock", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } catch (e) {
      Toast.show("Failed add to cart", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }
}
