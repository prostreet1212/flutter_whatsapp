import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_whatsapp/features/app/theme/style.dart';
import 'package:flutter_whatsapp/features/user/presentation/cubit/get_device_number/get_device_number_cubit.dart';

import '../global/widgets/profile_widget.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetDeviceNumberCubit>(context).getDeviceNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('select contacts'),
      ),
      body: BlocBuilder<GetDeviceNumberCubit, GetDeviceNumberState>(
        builder: (context, state) {
          if(state is GetDeviceNumberLoaded){
            final contacts=state.contacts;
            return ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact=contacts[index];
                  return ListTile(
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.memory(contact.photo??Uint8List(0),
                          errorBuilder: (context,error,s){
                            return Image.asset('assets/profile_default.png');
                          },)
                          //profileWidget()
                      ),
                    ),
                    title: Text('${contact.name!.first} ${contact.name!.last}'),
                    subtitle: Text('hey there! i\'m using whatsApp'),
                  );
                });
          }
          return Center(
            child: CircularProgressIndicator(
              color: tabColor,
            ),
          );

        },
      ),
    );
  }
}
