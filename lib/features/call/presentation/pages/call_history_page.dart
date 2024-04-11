import 'package:flutter/material.dart';

import '../../../app/global/date/date_formats.dart';
import '../../../app/global/widgets/profile_widget.dart';
import '../../../app/theme/style.dart';

class CallHistoryPage extends StatelessWidget {
  const CallHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              "Recent",
              style: const TextStyle(
                  fontSize: 15, color: greyColor, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: 20,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
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
                  title: Text(
                    "username",
                    style: const TextStyle(fontSize: 16),
                  ),
                  subtitle: Row(
                    children: [
                      Icon(
                        Icons.call_made,
                        color: Colors.green,
                        size: 19,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(formatDateTime(DateTime.now())),
                    ],
                  ),
                  trailing: const Icon(
                    Icons.call,
                    color: tabColor,
                  ),
                );
              })
        ],
      ),
    ));
  }
}
