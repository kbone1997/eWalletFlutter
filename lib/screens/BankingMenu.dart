import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_screen/screens/scannerGenerator.dart';
import '../mainMap.dart';
import 'BankingQuestionAnswer.dart';
import 'BankingRateInfo.dart';
import 'BankingTermsCondition.dart';
import 'PurchaseMoreScreen.dart';
import 'utils/BankingColors.dart';
import 'utils/BankingContants.dart';
import 'utils/BankingImages.dart';
import 'utils/BankingStrings.dart';
import 'utils/BankingWidget.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'BankingHome1.dart';

class BankingMenu extends StatefulWidget {
  static var tag = "/BankingMenu";


  @override
  _BankingMenuState createState() => _BankingMenuState();
}

class _BankingMenuState extends State<BankingMenu> {
  late String userName="";
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late final user;
  late String balance = "";
  late String accountNumber="";
  Future<void> getInformation() async {
    await for(var snapshot in _firestore.collection('information').snapshots()){
      for(var snap in snapshot.docs){
        print("printing current user: "+user.email);
        if(snap.data().values.last == user.email){
          userName = (snap.data()) ['name'];
          balance = (snap.data()) ['balance'];
          print("balance: "+balance);
        }
      }
    }
  }

  Future getCurrentUser() async{
    try{
      user =_auth.currentUser;
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Banking_app_Background,
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              10.height,
              Text(Banking_lbl_Menu, style: boldTextStyle(color: Banking_TextColorPrimary, size: 35)),
              16.height,
              Container(
                padding: EdgeInsets.all(8),
                decoration: boxDecorationWithShadow(borderRadius: BorderRadius.circular(10)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(backgroundImage: AssetImage(Banking_ic_user1), radius: 40),
                    10.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        5.height,
                        Text(userName, style: boldTextStyle(color: Colors.red, size: 18)),
                        5.height,
                        Text(accountNumber, style: primaryTextStyle(color: Colors.black26, size: 16, fontFamily: fontMedium)),
                        5.height,
                        Text("E-WALLETER", style: primaryTextStyle(color: Banking_TextColorSecondary, size: 16, fontFamily: fontMedium)),
                      ],
                    ).expand()
                  ],
                ),
              ),
              16.height,
              Container(
                padding: EdgeInsets.all(8),
                decoration: boxDecorationWithShadow(borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: <Widget>[
                    bankingOption(Banking_ic_Setting, Banking_lbl_Setting, Banking_blueColor),
                    bankingOption(Banking_ic_security, Banking_lbl_Change_Password, Banking_pinkColor).onTap(() {
                     PurchaseMoreScreen().launch(context);
                    }),
                    bankingOption(Banking_ic_Share, Banking_lbl_Share_Information_account, Banking_greenLightColor).onTap(() {
                      //  BankingShareInformation().launch(context);
                      PurchaseMoreScreen().launch(context);
                    }),
                  ],
                ),
              ),
              16.height,
              Container(
                padding: EdgeInsets.all(8),
                decoration: boxDecorationWithShadow(borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: <Widget>[
                    10.height,
                    bankingOption(Banking_ic_QR, "QR Bar", Banking_blueColor).onTap(() {
                      scannergen().launch(context);
                    }),
                    bankingOption(Banking_ic_Chart, Banking_lbl_Rate_Information, Banking_greenLightColor).onTap(() {
                      BankingRateInfo().launch(context);
                    }),
                    bankingOption(Banking_ic_Pin, Banking_lbl_Location, Banking_greenLightColor).onTap(() {
                      //BankingLocation().launch(context);
                      MyApp().launch(context);
                    }),
                    10.height,
                  ],
                ),
              ),
              16.height,
              Container(
                padding: EdgeInsets.all(8),
                decoration: boxDecorationWithShadow(borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: spacing_middle,
                    ),
                    bankingOption(Banking_ic_TC, Banking_lbl_Term_Conditions, Banking_greenLightColor).onTap(() {
                      BankingTermsCondition().launch(context);
                    }),
                    bankingOption(Banking_ic_Question, Banking_lbl_Questions_Answers, Banking_palColor).onTap(() {
                      BankingQuestionAnswer().launch(context);
                    }),
                    bankingOption(Banking_ic_Call, Banking_lbl_Contact, Banking_blueColor).onTap(() {
                      PurchaseMoreScreen().launch(context);
                      // BankingContact().launch(context);
                    }),
                    SizedBox(
                      height: spacing_middle,
                    ),
                  ],
                ),
              ),
              16.height,
              Container(
                padding: EdgeInsets.all(8),
                decoration: boxDecorationWithShadow(borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: <Widget>[
                    bankingOption(Banking_ic_Logout, Banking_lbl_Logout, Banking_pinkColor).onTap(() {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => CustomDialog(),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}

dialogContent(BuildContext context) {
  final _auth = FirebaseAuth.instance;

  return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10.0, offset: const Offset(0.0, 10.0)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          16.height,
          Text(Banking_lbl_Confirmation_for_logout, style: primaryTextStyle(size: 18)).onTap(() {
            finish(context);
          }).paddingOnly(top: 8, bottom: 8),
          Divider(height: 10, thickness: 1.0, color: Banking_greyColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Cancel", style: primaryTextStyle(size: 18)).onTap(() {
                finish(context);
              }).paddingRight(16),
              Container(width: 1.0, height: 40, color: Banking_greyColor).center(),
              Text("Logout", style: primaryTextStyle(size: 18, color: Banking_Primary)).onTap((
                  ) {
                _auth.signOut();
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('LOG OUT'),
                    content: const Text('SUCCESSFUL'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }).paddingLeft(16)
            ],
          ),
          16.height,
        ],
      ));
}
