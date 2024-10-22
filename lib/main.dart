import 'package:flutter/material.dart';
import 'dart:ui';
import 'ui/auth.dart';
import 'package:purecord/api/apidata.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ApiData(),
      child: PureCord(),
    ),
  );
}

class NoThumbScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };
}

class PureCord extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: NoThumbScrollBehavior().copyWith(scrollbars: false),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,
        bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.black),
      ),
      home: Scaffold(
        body: SafeArea(
          child: AuthPage(),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}