import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_screen/screens/BankingDashboard.dart';
import 'chat_screen.dart';

class sendMoney extends StatefulWidget {
  String email1=" ";
  sendMoney(email) {
    email1 = email;
  }
  @override
  sendMoneyState createState() => sendMoneyState();
}

class sendMoneyState extends State<sendMoney> {
  late String email;
  late String money;
  late String balance;
  late String balance1;


  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 200.0,
              child: Image.asset('images/logo.png'),
            ),
            SizedBox(
              height: 48.0,
            ),
            Text(widget.email1,
              textAlign: TextAlign.center,
              style: TextStyle(
              color: Colors.black54,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),),

            TextFormField(
              initialValue: widget.email1,
              style: TextStyle(
                  color: Colors.black54
              ),
              textAlign: TextAlign.center,
              onChanged: (value) {
                //Do something with the user input.
                if(value == null){
                  email = widget.email1;
                }
                else{
                  email = value;
                }
              },
              decoration: InputDecoration(
                hintText: 'Enter receivers account Number',
                contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              style: TextStyle(
                  color: Colors.black54
              ),
              textAlign: TextAlign.center,
              obscureText: true,
              onChanged: (value) {
                //Do something with the user input.
                money = value;
              },
              decoration: InputDecoration(
                hintText: 'Enter amount of money.',
                contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () async {
                   // Implement sendMoney functionality.
                   //    await for(var snapshot in _firestore.collection('information').snapshots()){
                   //      for(var snap in snapshot.docs){
                   //        //print("printing current user: "+user.email);
                   //        if(snap.data().values.last == email){
                   //          //userName = (snap.data()) ['name'];
                   //          balance = (snap.data()) ['balance'];
                   //          var afterSummingMoney = int.parse(balance)+ int.parse(money);
                   //          String afterSummingMoneyString = "$afterSummingMoney";
                   //          print("balance: "+balance);
                   //          print("here is the id: "+snap.id+" ------------###############################################################");
                   //          _firestore.collection('information').doc(snap.id).update({"balance": afterSummingMoneyString}).then(
                   //                  (value) => print("DocumentSnapshot successfully updated!"),
                   //              onError: (e) => print("Error updating document $e"));
                   //          afterSummingMoneyString = "0";
                   //        }
                   //      }
                   //    }
                    //jare send kortesi
                    final docRef = _firestore.collection("information").doc(email);
                    docRef.get().then(
                          (DocumentSnapshot doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        // ...
                            balance = data['balance'];
                            print("is this the balance: "+balance);
                      },
                      onError: (e) => print("Error getting document: $e"),
                    );
                    var sum = int.parse(balance) + int.parse(money);
                    balance = "$sum";
                    _firestore.collection('information').doc(email).update({"balance": balance}).then(
                            (value) => print("DocumentSnapshot successfully updated!"),
                        onError: (e) => print("Error updating document $e"));

                    //below sender er taka minus kortesi
                    final docRef1 = _firestore.collection("information").doc(_auth.currentUser?.uid);
                    docRef1.get().then(
                          (DocumentSnapshot doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        // ...
                        balance1 = data['balance'];
                        print("is this the balance: "+balance1);
                      },
                      onError: (e) => print("Error getting document: $e"),
                    );
                    var sum1 = int.parse(balance1) - int.parse(money);
                    balance1 = "$sum1";
                    _firestore.collection('information').doc(_auth.currentUser?.uid).update({"balance": balance1}).then(
                            (value) => print("DocumentSnapshot successfully updated!"),
                        onError: (e) => print("Error updating document $e"));

                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Send Money',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}