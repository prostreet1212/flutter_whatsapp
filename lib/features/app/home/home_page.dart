import 'package:flutter/material.dart';

import '../theme/style.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text(
        "WhatsApp",
        style: TextStyle(
        fontSize: 20,
        color: greyColor,
        fontWeight: FontWeight.w600),)
        )
    );
  }
}
