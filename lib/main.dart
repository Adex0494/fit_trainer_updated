import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: 'Fit Trainer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
         primarySwatch: Colors.red,
         appBarTheme: AppBarTheme(color: Color.fromRGBO(255, 0, 0, 1)),
         scaffoldBackgroundColor: Color.fromRGBO(255, 227, 227, 1),
         buttonColor: Color.fromRGBO(242, 36, 36, 1),
      //   textTheme: TextTheme(
      //       headline6: TextStyle(color: Colors.blue),
      //       subtitle2: TextStyle(color: Colors.blueAccent)),
      //   hintColor: Colors.white,
      //   canvasColor: Colors.white,
       ),
      home: LoginScreen(),
    );
  }
}

