import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sizer/sizer.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (_, __, ___) {
      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Challenge',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        routeInformationParser: Modular.routeInformationParser,
        routerDelegate: Modular.routerDelegate,
      );
    });
  }
}
