import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:http/http.dart' as http;

class DeskPage extends StatefulWidget {
  //@override
  final String username;
  DeskPage({String username}): this.username = username;
  _DeskPageState createState() => _DeskPageState(username);
  
}

class _DeskPageState extends State<DeskPage> {

  _DeskPageState(this.username);
  final String username;

  
  String _barcodeString = '';
  Permission permission = Permission.Camera;

  @override
  Widget build(BuildContext context) {
    //String a = this.username;
    return Scaffold(
      appBar: new AppBar(
        title: Text('Home'),
      ),
      body: new SafeArea(
        child: new Container(
          child: Center(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text('$_barcodeString'),
                RaisedButton(
                  onPressed: (){
                    // Navigator.pushReplacementNamed(context, '/login');
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // return object of type Dialog
                        return AlertDialog(
                          title: new Text("Exit"),
                          content: new Text("Are you really want to exit?"),
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
                  child: Text('Exit'),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: scan,
        child: new Icon(Icons.camera_alt),
      ),
    );
  }
  requestPermission() async{
    bool result = (await SimplePermissions.requestPermission(permission)) as bool;
  }

  void input(String _barcodeString){
    var url = "http://192.168.2.19/project_bi/kegiatan/addData";

    http.post(url, body: {
      "tabel": _barcodeString,
      "username": this.username,
    });
  }

  scan() async{
    try{
      String reader = await BarcodeScanner.scan();
      if(!mounted){return;}
      setState(() => _barcodeString = reader);
      input(_barcodeString);
      //Navigator.pop(context);
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
