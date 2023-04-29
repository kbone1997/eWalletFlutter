import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/screens/BankingDashboard.dart';
// import 'package:login_screen/screens/BankingHome1.dart';
import 'package:login_screen/screens/BankingInvoiceDetail.dart';
import 'package:login_screen/screens/BankingPayment.dart';
import 'package:login_screen/screens/BankingPaymentDetails.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/BankingDashboard.dart';
import 'screens/BankingMenu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black54),
        ),
      ),
      home: WelcomeScreen(),
    );
  }
}
