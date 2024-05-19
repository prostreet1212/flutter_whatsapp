import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';

import '../../../app/global/widgets/profile_widget.dart';


import '../../../app/theme/style.dart';

class MyStatusPage extends StatefulWidget {
  const MyStatusPage({super.key});

  @override
  State<MyStatusPage> createState() => _MyStatusPageState();
}

class _MyStatusPageState extends State<MyStatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Status"),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
         Row(
           children: [
             Container(
               width: 55,
               height: 55,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(30),
               ),
               child: ClipRRect(
                 borderRadius: BorderRadius.circular(30),
                 child: profileWidget(),
               ),
             ),
              const SizedBox(
              width: 15,
            ),
             Expanded(
               child: Text(
                 GetTimeAgo.parse(DateTime.now()
                     .subtract(Duration(seconds: DateTime.now().second))),
                 style:
                 const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
               ),
             ),
             PopupMenuButton<String>(
               icon: Icon(
                 Icons.more_vert,
                 color: greyColor.withOpacity(.5),
               ),
               color: appBarColor,
               iconSize: 28,
               onSelected: (value) {},
               itemBuilder: (context) => <PopupMenuEntry<String>>[
                 PopupMenuItem<String>(
                   value: "Delete",
                   child: GestureDetector(
                     onTap: () {},
                     child: const Text('Delete'),
                   ),
                 ),
               ],
             )
           ],
         )
          ],
        ),
      ),
    );
  }
}
