


import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/features/app/const/page_const.dart';
import 'package:flutter_whatsapp/features/app/home/contacts_page.dart';
import 'package:flutter_whatsapp/features/status/presentation/pages/my_status_page.dart';

import '../features/app/settings/settings_page.dart';
import '../features/call/presentation/pages/call_contacts_page.dart';
import '../features/chat/presentation/pages/single_chat_page.dart';

class OnGenerateRoute{
  static Route<dynamic>? route(RouteSettings  settings){
    final args=settings.arguments;
    final name=settings.name;

    switch (name) {
      case PageConst.contactUsersPage:
        {
          return materialPageBuilder(ContactsPage());
        }
      case PageConst.settingsPage:
        {
          if(args is String){
            return materialPageBuilder(SettingsPage(uid: args,));
          }else{
            return materialPageBuilder(const ErrorPage());
          }

        }
      case PageConst.callContactsPage: {
        return materialPageBuilder(const CallContactsPage());
      }
      case PageConst.myStatusPage:
        {
          return materialPageBuilder(MyStatusPage());
        }
      case PageConst.singleChatPage: {
          return materialPageBuilder(SingleChatPage());
        }
    }
  }
}

dynamic materialPageBuilder(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Error"),
      ),
      body: const Center(
        child: Text("Error"),
      ),
    );
  }
}