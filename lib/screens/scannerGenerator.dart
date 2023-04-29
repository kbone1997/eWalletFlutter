import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:firebase_auth/firebase_auth.dart';

class scannergen extends StatefulWidget {
  const scannergen({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  @override
  _scannergenstate createState() => _scannergenstate();
}

class _scannergenstate extends State<scannergen> {
  final _firebase = FirebaseAuth.instance;
  late String accountNumber="doha";
  Future getCurrentUser() async{
    try{
      var user =_firebase.currentUser;
      if(user!=null){
        accountNumber = user.uid;
        print("user selected!");
      }
      else{
        print("no logged in user");
      }
    }
    catch(e){
      print(e);
    }
  }
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 300,
          child: SfBarcodeGenerator(
            value: accountNumber,
            symbology: QRCode(),
            showValue: true,
            textSpacing: 15,
            textStyle: TextStyle(
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}