import 'package:flutter/material.dart';
import 'package:music_player_tutorial/homePage.dart';
import 'services/service_locator.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
