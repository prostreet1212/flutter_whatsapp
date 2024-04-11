import 'package:flutter/material.dart';

import '../../../app/global/widgets/profile_widget.dart';
import '../../../app/theme/style.dart';

class CallContactsPage extends StatefulWidget {
  const CallContactsPage({super.key});

  @override
  State<CallContactsPage> createState() => _CallContactsPageState();
}

class _CallContactsPageState extends State<CallContactsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('select contacts'),
      ),
      body: ListView.builder(
          itemCount: 20,
          itemBuilder: (context,index){
            return ListTile(
              leading: SizedBox(
                width: 50,
                height: 50,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: profileWidget()
                ),
              ),
              title: Text('username'),
              subtitle: Text('hey there! i\'m using whatsApp'),
              trailing: Wrap(
                children: [
                  Icon(Icons.call, color: tabColor, size: 22,),
                  SizedBox(width: 15,),
                  Icon(Icons.videocam_rounded, color: tabColor, size: 25,),
                ],
              ),

            );
          }),
    );
  }
}
