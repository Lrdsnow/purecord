import 'package:flutter/material.dart';
import 'package:blur/blur.dart';
import 'package:purecord/api/api.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 80,
        flexibleSpace: Stack(
          children: [
            Blur(
              blur: 15.0,
              blurColor: Colors.black,
              colorOpacity: 0.5,
              child: Container(
                color: Colors.transparent,
              ),
            ),
            SafeArea(child: Container(
              alignment: Alignment.center,
              child: const Text(
                "Settings",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            )),
          ],
        ),
      ),
      body: Center(child: 
        Column(children: 
          [
            const Text("No Settings Yet"), 
            GestureDetector(
              onTap: () {
                Api.setToken(null);
              }, 
              child: const Text("Press Here to Logout"),
            )
          ]
        )
      ),
    );
  }
}
