import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_bi/templateForm/templateForm.dart';

class RegistPage extends StatefulWidget {
  @override
  _RegistPageState createState() => _RegistPageState();
}

class _RegistPageState extends State<RegistPage> {
  
  GlobalKey<FormState> formKey = new GlobalKey();
  bool _validate = false;
  String _username, _password, _name, _email, _telp;

  void register(){
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      try{
        var url = "http://192.168.2.19/project_bi/user/register";
        http.post(url, body: {
          "nama_lengkap": _name,
          "username": _username,
          "password": _password,
          "email": _email,
          "no_telp": _telp
        });
        
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
        title: Text('Register'),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: formKey,
            autovalidate: _validate,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    validator: validationName,
                    onSaved: (String val){
                      _name = val;
                    },
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
                    validator: validationUser,
                    onSaved: (String val){
                      _username = val;
                    },
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
                    validator: validationPass,
                    onSaved: (String val){
                      _password = val;
                    },
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
                    validator: validationEmail,
                    onSaved: (String val){
                      _email = val;
                    },
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
                    validator: validationPhone,
                    onSaved: (String val){
                      _telp = val;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.phone,
                        color: Colors.blue,
                      ),
                      filled: true,
                      labelText: 'Mobile'
                    )
                  ),
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        onPressed: (){
                          formKey.currentState.reset();
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