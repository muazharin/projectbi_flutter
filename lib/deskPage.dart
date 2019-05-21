import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:http/http.dart' as http;
import 'package:project_bi/templateForm/templateForm.dart';

class DeskPage extends StatefulWidget {
  //@override
  final String username;
  final String id;
  DeskPage({String username, String id}): this.username = username, this.id = id;
  _DeskPageState createState() => _DeskPageState(username, id);
  
}

class _DeskPageState extends State<DeskPage> {

  _DeskPageState(this.username, this.id);
  final String username;
  final String id;

  
  String _barcodeString = '';
  Permission permission = Permission.Camera;

  @override
  Widget build(BuildContext context) {
    // String a = this.username;
    // String b = this.id;
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
                new Text('$_barcodeString ${this.username} ${this.id}'),
                RaisedButton(
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
