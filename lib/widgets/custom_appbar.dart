import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:makipos/view/login.dart';

import '../theme/colors.dart';
import '../view/ControlPage.dart';
import '../view/SettingsPage.dart';
import '../view/StatusPage.dart';
import '../view/home.dart';

class CustomAppbar extends StatefulWidget with PreferredSizeWidget {
  // CustomAppbar({Key? key,}) : super(key: key);
  const CustomAppbar(
    this._token,
  );

  final String _token;

  @override
  _CustomAppbarState createState() => _CustomAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 43);
}

class _CustomAppbarState extends State<CustomAppbar> {
  String _id = "";
  var _data;
  var length;
  var checkid = false;

  getData() async {
    try {
      var responseGet_Listdevice = await http.get(
        Uri.parse("https://smarthome.test.makipos.net:3029/devices"),
        headers: {"Authorization": widget._token.toString()},
      );
      Map<String, dynamic> userMap = jsonDecode(responseGet_Listdevice.body);
      _data = userMap["data"];
      print("Du lieu : ${_data.toString()}");
      if (_data.toString() == '[]' || _data.toString() == null || responseGet_Listdevice.statusCode != 200) {
        checkid = false;
        // print("NoOke: $checkid");
      } else {
        checkid = true;
        // print("Oke: $checkid");
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    double heightR, widthR;
    heightR = MediaQuery.of(context).size.height / 1080; //v26
    widthR = MediaQuery.of(context).size.width / 2400;
    var curR = widthR;
    return Container(
      height: 80 * heightR,
      padding: EdgeInsets.only(
          left: 50 * widthR, right: 15 * widthR, top: 10 * heightR),
      decoration: BoxDecoration(color: shadowColor, boxShadow: [
        BoxShadow(
            color: shadowColor.withOpacity(0.1),
            blurRadius: .5,
            spreadRadius: .5,
            offset: Offset(0, 1))
      ]),
      child: StreamBuilder(
          stream: Stream.periodic(Duration(seconds: 1)).asyncMap((event) => getData()),
          builder: (context, snapshot) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              checkid
                  ? IconButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      backgroundColor: Colors.grey[200],
                      title: Center(
                        child: Text(
                          'List Device',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32 * heightR,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        SizedBox(
                          height: 600 * heightR,
                          width: 800 * heightR,
                          child: ListView.builder(
                              itemCount: 9,
                              itemBuilder:
                                  (BuildContext context, int index) {
                                return TextButton(
                                    onPressed: () {
                                      _id =
                                          _data[index]["_id"].toString();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Home(
                                              token: widget._token,
                                              id: _id),
                                        ),
                                      );
                                      print(_id);
                                    },
                                    child: Container(
                                      height: 50 * heightR,
                                      // color: Colors.white60,
                                      child: Text(
                                          "${_data[index]["productId"]}",
                                        style: TextStyle(
                                          fontSize: 24*heightR,
                                          color: Colors.black,

                                        ),
                                      ),
                                    ));
                              }),
                        )
                      ],
                    )),
                icon: Icon(
                  Icons.menu,
                  color: secondary,
                  size: 30 * heightR,
                ),
              )
                  : IconButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    backgroundColor: Colors.grey[200],
                    title: Center(
                      child: Text(
                        'List Device',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32 * heightR,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      SizedBox(
                          height: 600 * heightR,
                          width: 800 * heightR,
                          child: Column(
                            children: [
                              Container(
                                child: Text(
                                    'Không có thiết bị nào trên tài khoản này!',
                                    style: TextStyle(
                                        fontSize: 20 * heightR,
                                        color: Colors.black87)),
                              )
                            ],
                          ))
                    ],
                  ),
                ),
                icon: Icon(
                  Icons.menu,
                  color: secondary,
                  size: 30 * heightR,
                ),
              ),

              Text(
                "${DateFormat("yyyy-MM-dd").format(DateTime.now())} ${DateFormat.Hms().format(DateTime.now())}",
                style: TextStyle(color: Colors.white, fontSize: 24 * heightR),
              ),
              PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: secondary,
                    size: 30 * heightR,
                  ),
                  // color: secondary,
                  // elevation: 20,
                  // enabled: true,
                  onSelected: (value) {
                    if (value == 'logout') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LogInPage(),
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text("Logout"),
                      value: "logout",
                    ),
                    // PopupMenuItem(
                    //   child: Text("Second"),
                    //   value: "Second",
                    // ),
                  ]),
            ],
          )
      ),

    );
  }
}
