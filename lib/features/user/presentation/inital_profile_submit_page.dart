import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/features/app/home/home_page.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/const/app_const.dart';
import '../../app/global/widgets/profile_widget.dart';
import '../../app/theme/style.dart';

class InitalProfileSubmitPage extends StatefulWidget {
  const InitalProfileSubmitPage({Key? key}) : super(key: key);

  @override
  State<InitalProfileSubmitPage> createState() => _InitalProfileSubmitPageState();
}

class _InitalProfileSubmitPageState extends State<InitalProfileSubmitPage> {

  final TextEditingController _usernameController = TextEditingController();
  File? _image;

  bool _isProfileUpdating = false;

  Future selectImage() async {
    try {
      //final pickedFile = await ImagePicker.platform.getImage(source: ImageSource.gallery);
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print("no image has been selected");
        }
      });

    } catch(e) {
      toast("some error occured $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 30),
        child: Column(
          children: [
            const SizedBox(height: 30,),
            const Center(child: Text("Profile Info", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: tabColor),),),
            const SizedBox(height: 10,),
            const Text("Please provide your name and an optional profile photo", textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
            const SizedBox(height: 30,),
            GestureDetector(
              onTap: selectImage,
              child: SizedBox(
                width: 50,
                height: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: profileWidget(image: _image),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              height: 40,
              margin: const EdgeInsets.only(top: 1.5),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom:
                      BorderSide(color: tabColor, width: 1.5))),
              child: TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                    hintText: "Username",
                    border: InputBorder.none),
              ),
            ),
            const SizedBox(height: 20,),
            GestureDetector(
              onTap: submitProfileInfo,
              child: Container(
                width: 150,
                height: 40,
                decoration: BoxDecoration(
                  color: tabColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Center(
                  child: Text("Next", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void submitProfileInfo() {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
  /*  if(_image != null) {
      StorageProviderRemoteDataSource.uploadProfileImage(
          file: _image!,
          onComplete: (onProfileUpdateComplete) {
            setState(() {
              _isProfileUpdating = onProfileUpdateComplete;
            });
          }
      ).then((profileImageUrl) {
        _profileInfo(
            profileUrl: profileImageUrl
        );
      });
    } else {
      _profileInfo(profileUrl: "");
    }*/
  }
}
