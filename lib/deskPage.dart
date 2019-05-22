import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:http/http.dart' as http;
import 'package:project_bi/templateForm/templateForm.dart';
import 'package:project_bi/detail.dart';

import 'dart:async';
import 'dart:convert';

class DeskPage extends StatefulWidget {
  //@override
  final String username;
  final String id;
  final Function() onPressed;
  final String tooltip;
  final IconData icon;
  DeskPage({String username, String id, this.onPressed, this.tooltip, this.icon}): this.username = username, this.id = id;
  _DeskPageState createState() => _DeskPageState(username, id);
  
}

class _DeskPageState extends State<DeskPage> with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget exit() {
    return Container(
      child: FloatingActionButton(
        heroTag: "btnExit",
        onPressed: (){
          // Navigator.pushReplacementNamed(context, '/login');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: new Text("Exit"),
                content: new Text("Do you really want to exit?"),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    child: new Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  new FlatButton(
                    child: new Text("Yes"),
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
                    },
                  )
                ],
              );
            },
          );
        },
        tooltip: 'Exit',
        child: Icon(Icons.exit_to_app),
      ),
    );
  }

  Widget camera() {
    return Container(
      child: FloatingActionButton(
        heroTag: "btnScan",
        onPressed: scan,
        tooltip: 'Scan',
        child: Icon(Icons.camera_alt),
      ),
    );
  }

  Widget profile() {
    return Container(
      child: FloatingActionButton(
        heroTag: "btnProfile",
        onPressed: null,
        tooltip: 'Profile',
        child: Icon(Icons.person),
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
      ),
    );
  }

  _DeskPageState(this.username, this.id);
  final String username;
  final String id;

  
  String _barcodeString = '';
  Permission permission = Permission.Camera;

  Future<List> getData() async {
    final response = await http.get("$ip"+"/kegiatan/getData/"+"${this.id}");
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    // String a = this.username;
    // String b = this.id;
    return MaterialApp(
      home: Scaffold(
      appBar: new AppBar(
        title: Text('Home'),
      ),
      body: new FutureBuilder<List>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? new ItemList(
                  list: snapshot.data,
                )
              : new Center(
                  child: new CircularProgressIndicator(),
                );
        },
      ),
      floatingActionButton:Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Transform(
            transform: Matrix4.translationValues(
              0.0,
              _translateButton.value * 3.0,
              0.0,
            ),
            child: profile(),
          ),
          Transform(
            transform: Matrix4.translationValues(
              0.0,
              _translateButton.value * 2.0,
              0.0,
            ),
            child: camera(),
          ),
          Transform(
            transform: Matrix4.translationValues(
              0.0,
              _translateButton.value,
              0.0,
            ),
            child: exit(),
          ),
          toggle(),
        ],
      ),
      ),
    );
  }
  requestPermission() async{
    bool result = (await SimplePermissions.requestPermission(permission)) as bool;
  }

  void input(String _barcodeString){
    // var url = "$ip"+"/kegiatan/addData";
    var url = "$ip"+"/kegiatan/addDataEvent";

    http.post(url, body: {
      // "tabel": _barcodeString,
      // "username": this.username,
      "id_kegiatan": _barcodeString,
      "id_user": this.id
    });
  }

  scan() async{
    try{
      String reader = await BarcodeScanner.scan();
      if(!mounted){return;}
      setState(() => _barcodeString = reader);
      input(_barcodeString);
    }on PlatformException catch(e){
      if(e.code==BarcodeScanner.CameraAccessDenied){
        requestPermission();
      }else{
        setState(()=> _barcodeString = "unknown error : $e");
      }
    }on FormatException{
      setState(()=> _barcodeString = "user return without scanning");
    }catch(e){
      setState(()=> _barcodeString = "unknown error : $e");
    }
  }
}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({this.list});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new Container(
          padding: const EdgeInsets.all(10.0),
          child: new GestureDetector(
            onTap: () => Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (BuildContext context) => new Detail(
                  list1: list,
                  index1: i,
                )
              ),
            ),
            child: new Card(
              child: new ListTile(
                title: new Text(
                  list[i]['nama_kegiatan'],
                  style: TextStyle(fontSize: 25.0, color: Colors.blueGrey),
                ),
                leading: new Icon(
                  Icons.event,
                  size: 36,
                  color: Colors.greenAccent,
                ),
                subtitle: new Text(
                  "Waktu : ${list[i]['waktu_kegiatan']}",
                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
