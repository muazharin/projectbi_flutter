import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegistPage extends StatefulWidget {
  @override
  _RegistPageState createState() => _RegistPageState();
}

class _RegistPageState extends State<RegistPage> {
  final formKey = new GlobalKey<FormState>();
  bool validateAndSave(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  final controllerUser = new TextEditingController();
  final controllerPass = new TextEditingController();
  final controllerName = new TextEditingController();
  final controllerEmail = new TextEditingController();
  final controllerNumber = new TextEditingController();

  void register(){
    if(validateAndSave()){
      try{
        var url = "http://192.168.2.19/project_bi/user/register";
        http.post(url, body: {
          "nama_lengkap": controllerName.text,
          "username": controllerUser.text,
          "password": controllerPass.text,
          "email": controllerEmail.text,
          "no_telp": controllerNumber.text
        });
        // Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Registrasi"),
              content: new Text("Data berhasil terdaftar"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    // Navigator.of(context).pop();
                    Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
                  },
                ),
              ],
            );
          },
        );
        
      }catch(e){
        print(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    validator: (value) => value.isEmpty ? 'Name can\'t be empty':null,
                    controller: controllerName,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.contacts,
                        color: Colors.blue,
                      ),
                      filled: true,
                      labelText: 'Name'
                    )
                  ),
                  TextFormField(
                    validator: (value) => value.isEmpty ? 'Username can\'t be empty':null,
                    controller: controllerUser,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      filled: true,
                      labelText: 'Username'
                    )
                  ),
                  TextFormField(
                    validator: (value) => value.isEmpty ? 'Password can\'t be empty':null,
                    controller: controllerPass,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.vpn_key,
                        color: Colors.blue,
                      ),
                      filled: true,
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  TextFormField(
                    validator: (value) => value.isEmpty ? 'Email can\'t be empty':null,
                    controller: controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.email,
                        color: Colors.blue,
                      ),
                      filled: true,
                      labelText: 'Email'
                    )
                  ),
                  TextFormField(
                    validator: (value) => value.isEmpty ? 'No Telp can\'t be empty':null,
                    controller: controllerNumber,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.phone,
                        color: Colors.blue,
                      ),
                      filled: true,
                      labelText: 'No Telp'
                    )
                  ),
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        onPressed: (){
                          controllerUser.clear();
                          controllerName.clear();
                          controllerPass.clear();
                          controllerEmail.clear();
                          controllerNumber.clear();
                        },
                        child: Text('Reset'),
                      ),
                      RaisedButton(
                        onPressed: register,
                        child: Text('Sign Up'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}