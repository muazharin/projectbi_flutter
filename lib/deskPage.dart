import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:simple_permissions/simple_permissions.dart';

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
              children: <Widget>[
                new Text('$_barcodeString'+this.username)
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

  scan() async{
    try{
      String reader = await BarcodeScanner.scan();
      if(!mounted){return;}
      setState(() => _barcodeString = reader);
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
