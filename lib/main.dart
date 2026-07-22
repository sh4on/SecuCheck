import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'my_app.dart';

void main() {
  // ensure flutter binding is initialized before calling any platform channels
  WidgetsFlutterBinding.ensureInitialized();

  // lock the app to portrait orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // configure the status bar to be transparent with light icons for dark theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}
