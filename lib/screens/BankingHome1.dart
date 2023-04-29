import 'dart:developer';
import 'utils/BankingModel.dart';
import 'utils/BankingColors.dart';
import 'utils/BankingContants.dart';
import 'utils/BankingDataGenerator.dart';
import 'utils/BankingImages.dart';
import 'utils/BankingWidget.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class BankingHome1 extends StatefulWidget {
  static String tag = '/BankingHome1';

  @override
  BankingHome1State createState() => BankingHome1State();
}

class BankingHome1State extends State<BankingHome1> {

  int currentIndexPage = 0;
  int? pageLength;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late String userName="";
  late String balance="1000";
  late String accountNumber="";
  late final  user;


  late List<BankingHomeModel> mList1;
  late List<BankingHomeModel2> mList2;

  @override
  void initState() {
    getCurrentUser();
    getInformation();
    super.initState();
    currentIndexPage = 0;
    pageLength = 3;
    mList1 = bankingHomeList1();
    mList2 = bankingHomeList2();
  }
  Future<void> getInformation() async {
     await for(var snapshot in _firestore.collection('information').snapshots()){
       for(var snap in snapshot.docs){
         print("printing current user here: "+user.email);
         if(snap.data().values.last == user.email){
           userName = (snap.data()) ['name'];
           balance = (snap.data()) ['balance'];
           print(snap.id+"here is the ID ---------------------------------####################################################");
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
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 330,
              floating: false,
              pinned: true,
              titleSpacing: 0,
              automaticallyImplyLeading: false,
              backgroundColor: innerBoxIsScrolled ? Banking_Primary : Banking_app_Background,
              actionsIconTheme: IconThemeData(opacity: 0.0),
              title: Container(
                padding: EdgeInsets.fromLTRB(16, 42, 16, 32),
                margin: EdgeInsets.only(bottom: 8, top: 8),
                child: Row(
                  children: [
                    CircleAvatar(backgroundImage: AssetImage(Banking_ic_user1), radius: 24),
                    10.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Hello,"+userName, style: primaryTextStyle(color: Banking_TextColorWhite, size: 16, fontFamily: fontRegular)),

                      ],
                    ).expand(),
                    IconButton(
                      icon: const Icon(Icons.restart_alt),
                      tooltip: 'Increase volume by 10',
                      onPressed: () {
                        setState(() {
                          BankingHome1();
                        });
                      },
                    ),
                  ],
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topLeft, colors: <Color>[Banking_Primary, Banking_palColor]),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(16, 80, 16, 8),
                      padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                      decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.circular(10), boxShadow: defaultBoxShadow()),
                      child: Column(
                        children: [
                          Container(
                            height: 130,
                            child: PageView(
                              children: [
                                TopCard(name: userName+" default", acno: accountNumber, bal: balance),
                                TopCard(name: userName+" work", acno: accountNumber, bal: balance),
                                TopCard(name: userName+" Home", acno: accountNumber, bal: balance),
                              ],
                              onPageChanged: (value) {
                                setState(() => currentIndexPage = value);
                              },
                            ),
                          ),
                          8.height,
                          Align(
                            alignment: Alignment.center,
                            child: DotsIndicator(
                              dotsCount: 3,
                              position: currentIndexPage.toDouble(),
                              decorator: DotsDecorator(
                                size: Size.square(8.0),
                                activeSize: Size.square(8.0),
                                color: Banking_view_color,
                                activeColor: Banking_TextColorPrimary,
                              ),
                            ),
                          ),
                          10.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(

                                decoration: boxDecorationWithRoundedCorners(backgroundColor: Banking_Primary, borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.payment),
                                      iconSize: 20,
                                      tooltip: 'add payment',
                                      onPressed: () async {

                                      },
                                    ),

                                    Text('Payment', style: primaryTextStyle(size: 13, color: Banking_TextColorWhite)),
                                  ],
                                ),
                              ).expand(),
                              10.width,
                              Container(
                                padding: EdgeInsets.only(top: 13, bottom: 12),
                                decoration: boxDecorationWithRoundedCorners(backgroundColor: Banking_Primary, borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(Banking_ic_Transfer, color: Banking_TextColorWhite),
                                    10.width,
                                    Text('Transfer', style: primaryTextStyle(size: 16, color: Banking_TextColorWhite)),
                                  ],
                                ),
                              ).expand(),
                            ],
                          ).paddingAll(10)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ];
        },
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            color: Banking_app_Background,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Recently Transaction", style: primaryTextStyle(size: 16, color: Banking_TextColorPrimary, fontFamily: fontRegular)),
                    Text("22 Feb 2020", style: primaryTextStyle(size: 16, color: Banking_TextColorSecondary, fontFamily: fontRegular)),
                  ],
                ),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: mList1.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(top: 8, bottom: 8),
                      decoration: boxDecorationRoundedWithShadow(8, backgroundColor: Banking_whitePureColor, spreadRadius: 0, blurRadius: 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.account_balance_wallet, size: 30, color: mList1[index].color),
                          10.width,
                          Text('${mList1[index].title}', style: primaryTextStyle(size: 16, color: mList1[index].color, fontFamily: fontMedium)).expand(),
                          Text(mList1[index].bal!, style: primaryTextStyle(color: mList1[index].color, size: 16)),
                        ],
                      ),
                    );
                  },
                ),
                16.height,
                Text("22 Feb 2020", style: primaryTextStyle(size: 16, color: Banking_TextColorSecondary, fontFamily: fontRegular)),
                Divider(),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 15,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    BankingHomeModel2 data = mList2[index % mList2.length];
                    return Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(top: 8, bottom: 8),
                      decoration: boxDecorationRoundedWithShadow(8, backgroundColor: Banking_whitePureColor, spreadRadius: 0, blurRadius: 0),
                      child: Expanded(
                        flex: 2,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(data.icon!, height: 30, width: 30, color: index == 2 ? Banking_Primary : Banking_Primary),
                            10.width,
                            Text(data.title!, style: primaryTextStyle(size: 16, color: Banking_TextColorPrimary, fontFamily: fontRegular)).expand(),
                            Align(alignment: Alignment.centerRight, child: Text(data.charge!, style: primaryTextStyle(color: data.color, size: 16)))
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
