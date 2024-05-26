
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:bdayapp/src/values/colors.dart';
import 'package:bdayapp/src/config/routes.dart';
import 'package:bdayapp/src/config/application.dart';


class BDayApp extends StatelessWidget {
  const BDayApp({Key? key}) : super(key: key);

  static final ThemeData _defaultTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: scaffoldBgColor,
  );

  void init(){
    final router = FluroRouter();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  @override
  Widget build(BuildContext context) {
    init();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "BDay",
      theme: _defaultTheme,
      onGenerateRoute: Application.router.generator,
    );
  }
}


