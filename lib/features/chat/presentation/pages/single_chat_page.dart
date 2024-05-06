import 'dart:io';

import 'package:agora_uikit/agora_uikit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_whatsapp/features/app/const/message_type_const.dart';
import 'package:flutter_whatsapp/features/app/global/widgets/show_image_picked_widget.dart';
import 'package:flutter_whatsapp/features/app/global/widgets/show_video_picked_widget.dart';
import 'package:flutter_whatsapp/features/chat/domain/entities/chat_entity.dart';
import 'package:flutter_whatsapp/features/chat/domain/entities/message_entity.dart';
import 'package:flutter_whatsapp/features/chat/presentation/cubit/message/message_cubit.dart';
import 'package:flutter_whatsapp/features/chat/presentation/pages/message_widgets/message_type_widget.dart';
import 'package:flutter_whatsapp/features/user/presentation/widgets/chat_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../../storage/storage_provider.dart';
import '../../../app/const/app_const.dart';
import '../../../app/global/widgets/dialog_widget.dart';
import '../../../app/theme/style.dart';

class SingleChatPage extends StatefulWidget {
  final MessageEntity message;

  const SingleChatPage({super.key, required this.message});

  @override
  State<SingleChatPage> createState() => _SingleChatPageState();
}

class _SingleChatPageState extends State<SingleChatPage> {
  final TextEditingController _textMessageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isDisplaySendButton = false;
  bool _isShowAttachWindow = false;

  FlutterSoundRecorder? _soundRecorder;
  bool _isRecording = false;
  bool _isRecordInit = false;

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    _openAudioRecording();
    BlocProvider.of<MessageCubit>(context).getMessages(
        message: MessageEntity(
      senderUid: widget.message.senderUid,
      recipientUid: widget.message.recipientUid,
    ));
  }

  Future<void> _scrollToBottom() async {
    if (_scrollController.hasClients) {
      await Future.delayed(const Duration(milliseconds: 100));
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _openAudioRecording() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed!');
    }
    await _soundRecorder!.openRecorder();
    _isRecordInit = true;
  }

  File? _image;

  Future selectImage() async {
    setState(() => _image = null);
    try {
      final pickedFile =
          //await ImagePicker.platform.getImage(source: ImageSource.gallery);
          await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print("no image has been selected");
        }
      });
    } catch (e) {
      toast("some error occured $e");
    }
  }

  File? _video;

  Future selectVideo() async {
    setState(() => _image = null);
    try {
      final pickedFile =
          //await ImagePicker.platform.pickVideo(source: ImageSource.gallery);
          await ImagePicker().pickVideo(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _video = File(pickedFile.path);
        } else {
          print("no image has been selected");
        }
      });
    } catch (e) {
      toast("some error occured $e");
    }
  }

  @override
  void dispose() {
    _textMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text('${widget.message.recipientName}'),
            Text(
              'Online',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        actions: [
          const Icon(
            Icons.videocam_rounded,
            size: 25,
          ),
          const SizedBox(
            width: 25,
          ),
          const Icon(
            Icons.call,
            size: 22,
          ),
          const SizedBox(
            width: 25,
          ),
          const Icon(
            Icons.more_vert,
            size: 22,
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: BlocBuilder<MessageCubit, MessageState>(
        builder: (context, state) {
          if (state is MessageLoaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });
            List<MessageEntity> messages = state.messages;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _isShowAttachWindow = false;
                });
              },
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: Image.asset("assets/whatsapp_bg_image.png",
                        fit: BoxFit.cover),
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            var message = messages[index];
                            if (message.senderUid == widget.message.senderUid) {
                              return _messageLayout(
                                messageType: message.messageType,
                                  message: message.message,
                                  alignment: Alignment.centerRight,
                                  createAt: message.createdAt,
                                  isSeen: message.isSeen,
                                  isShowTick: true,
                                  messageBgColor: messageColor,
                                  onLongPress: () {
                                    displayAlertDialog(
                                        context,
                                        onTap: () {
                                          BlocProvider.of<MessageCubit>(context).deleteMessage(message: MessageEntity(
                                              senderUid: widget.message.senderUid,
                                              recipientUid: widget.message.recipientUid,
                                              messageId: message.messageId
                                          ));
                                          Navigator.pop(context);
                                        },
                                        confirmTitle: "Delete",
                                        content: "Are you sure you want to delete this message?"
                                    );
                                  },
                                  onSwipe: () {
                                  });
                            } else {
                              return _messageLayout(
                                  messageType: message.messageType,
                                  message: message.message,
                                  alignment: Alignment.centerLeft,
                                  createAt: message.createdAt,
                                  isSeen: message.isSeen,
                                  isShowTick: false,
                                  messageBgColor: senderMessageColor,
                                  onLongPress: () {
                                    displayAlertDialog(
                                        context,
                                        onTap: () {
                                          BlocProvider.of<MessageCubit>(context).deleteMessage(message: MessageEntity(
                                              senderUid: widget.message.senderUid,
                                              recipientUid: widget.message.recipientUid,
                                              messageId: message.messageId
                                          ));
                                          Navigator.pop(context);
                                        },
                                        confirmTitle: "Delete",
                                        content: "Are you sure you want to delete this message?"
                                    );
                                  },
                                  onSwipe: () {});
                            }
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    color: appBarColor,
                                    borderRadius: BorderRadius.circular(25)),
                                height: 50,
                                child: TextField(
                                  onTap: () {
                                    setState(() {
                                      _isShowAttachWindow = false;
                                    });
                                  },
                                  controller: _textMessageController,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      setState(() {
                                        _textMessageController.text = value;
                                        _isDisplaySendButton = true;
                                      });
                                    } else {
                                      setState(() {
                                        _isDisplaySendButton = false;
                                        _textMessageController.text = value;
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    prefixIcon: Icon(Icons.emoji_emotions,
                                        color: greyColor),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Wrap(
                                        children: [
                                          Transform.rotate(
                                            angle: -0.5,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _isShowAttachWindow =
                                                      !_isShowAttachWindow;
                                                });
                                              },
                                              child: const Icon(
                                                Icons.attach_file,
                                                color: greyColor,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              selectImage().then((value) {
                                                if (_image != null) {
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (timeStamp) {
                                                    showImagePickedBottomModalSheet(
                                                        context,
                                                        recipientName: widget
                                                            .message
                                                            .recipientName,
                                                        file: _image,
                                                        onTap: () {
                                                      _sendImageMessage();
                                                      Navigator.pop(context);
                                                    });
                                                  });
                                                }
                                              });
                                            },
                                            child: const Icon(
                                              Icons.camera_alt,
                                              color: greyColor,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                    hintText: 'Message',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                _sendTextMessage();
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: tabColor),
                                child: Center(
                                  child: Icon(
                                    _isDisplaySendButton
                                        ? Icons.send_outlined
                                        : _isRecording
                                            ? Icons.close
                                            : Icons.mic,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  _isShowAttachWindow == true
                      ? Positioned(
                          bottom: 65,
                          top: 320,
                          left: 15,
                          right: 15,
                          child: Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.width * 0.20,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 20),
                            decoration: BoxDecoration(
                              color: bottomAttachContainerColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _attachWindowItem(
                                      icon: Icons.document_scanner,
                                      color: Colors.deepPurpleAccent,
                                      title: "Document",
                                    ),
                                    _attachWindowItem(
                                        icon: Icons.camera_alt,
                                        color: Colors.pinkAccent,
                                        title: "Camera",
                                        onTap: () {}),
                                    _attachWindowItem(
                                        icon: Icons.image,
                                        color: Colors.purpleAccent,
                                        title: "Gallery"),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _attachWindowItem(
                                        icon: Icons.headphones,
                                        color: Colors.deepOrange,
                                        title: "Audio"),
                                    _attachWindowItem(
                                        icon: Icons.location_on,
                                        color: Colors.green,
                                        title: "Location"),
                                    _attachWindowItem(
                                        icon: Icons.account_circle,
                                        color: Colors.deepPurpleAccent,
                                        title: "Contact"),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _attachWindowItem(
                                      icon: Icons.bar_chart,
                                      color: tabColor,
                                      title: "Poll",
                                    ),
                                    _attachWindowItem(
                                        icon: Icons.gif_box_outlined,
                                        color: Colors.indigoAccent,
                                        title: "Gif",
                                        onTap: () {
                                          _sendGifMessage();
                                        }),
                                    _attachWindowItem(
                                        icon: Icons.videocam_rounded,
                                        color: Colors.lightGreen,
                                        title: "Video",
                                        onTap: () {
                                          selectVideo().then((value) {
                                            if (_video != null) {
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback(
                                                      (timeStamp) {
                                                    showVideoPickedBottomModalSheet(
                                                        context,
                                                        recipientName: widget
                                                            .message
                                                            .recipientName,
                                                        file: _video,
                                                        onTap: () {
                                                          _sendVideoMessage();
                                                          Navigator.pop(context);
                                                        });
                                                  });
                                            }
                                          });
                                          setState(() {
                                            _isShowAttachWindow = false;
                                          });
                                        }),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            );
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

  _messageLayout({
    Color? messageBgColor,
    Alignment? alignment,
    Timestamp? createAt,
    VoidCallback? onSwipe,
    String? message,
    String? messageType,
    bool? isShowTick,
    bool? isSeen,
    VoidCallback? onLongPress,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: SwipeTo(
        onRightSwipe: (details) {
          onSwipe;
        },
        child: GestureDetector(
          onLongPress: onLongPress,
          child: Container(
            alignment: alignment,
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: EdgeInsets.only(
                            left: 5, right: messageType == MessageTypeConst.textMessage ? 88 : 5, top: 5, bottom: 5),
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.80),
                        decoration: BoxDecoration(
                            color: messageBgColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: MessageTypeWidget(
                          message: message,
                            type: messageType,
                        )
                    ),
                    const SizedBox(height: 3),
                  ],
                ),
                Positioned(
                  bottom: 4,
                  right: 10,
                  child: Row(
                    children: [
                      Text(DateFormat.jm().format(createAt!.toDate()),
                          style:
                              const TextStyle(fontSize: 12, color: greyColor)),
                      const SizedBox(
                        width: 5,
                      ),
                      isShowTick == true
                          ? Icon(
                              isSeen == true ? Icons.done_all : Icons.done,
                              size: 16,
                              color: isSeen == true ? Colors.blue : greyColor,
                            )
                          : Container()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _attachWindowItem(
      {IconData? icon, Color? color, String? title, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 55,
            height: 55,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40), color: color),
            child: Icon(icon),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "$title",
            style: const TextStyle(color: greyColor, fontSize: 13),
          ),
        ],
      ),
    );
  }

  _sendTextMessage() async {
    if (_isDisplaySendButton) {
      _sendMessage(
        message: _textMessageController.text,
        type: MessageTypeConst.textMessage,
      );
    } else {
      final temporaryDir = await getTemporaryDirectory();
      final audioPath = '${temporaryDir.path}/flutter_sound.aac';
      if (!_isRecordInit) {
        return;
      }
      if (_isRecording == true) {
        await _soundRecorder!.stopRecorder();
        StorageProviderRemoteDataSource.uploadMessageFile(
          file: File(audioPath),
          onComplete: (value) {},
          uid: widget.message.senderUid,
          otherUid: widget.message.recipientUid,
          type: MessageTypeConst.audioMessage,
        ).then((audioUrl) {
          _sendMessage(message: audioUrl, type: MessageTypeConst.audioMessage);
        });
      } else {
        await _soundRecorder!.startRecorder(
          toFile: audioPath,
        );
      }
      setState(() {
        _isRecording = !_isRecording;
      });
    }
  }

  void _sendImageMessage() {
    StorageProviderRemoteDataSource.uploadMessageFile(
      file: _image!,
      onComplete: (value) {},
      uid: widget.message.senderUid,
      otherUid: widget.message.recipientUid,
      type: MessageTypeConst.photoMessage,
    ).then((photoImageUrl) {
      _sendMessage(message: photoImageUrl, type: MessageTypeConst.photoMessage);
    });
  }

  void _sendVideoMessage() {
    StorageProviderRemoteDataSource.uploadMessageFile(
      file: _video!,
      onComplete: (value) {},
      uid: widget.message.senderUid,
      otherUid: widget.message.recipientUid,
      type: MessageTypeConst.videoMessage,
    ).then((videoUrl) {
      _sendMessage(message: videoUrl, type: MessageTypeConst.videoMessage);
    });
  }

  Future _sendGifMessage() async {
    final gif = await pickGIF(context);
    if (gif != null) {
      String fixedUrl = "https://media.giphy.com/media/${gif.id}/giphy.gif";
      _sendMessage(message: fixedUrl, type: MessageTypeConst.gifMessage);
    }
  }

  void _sendMessage(
      {required String message,
      required String type,
      String? repliedMessage,
      String? repliedTo,
      String? repliedMessageType}) {
    _scrollToBottom();
    ChatUtils.sendMessage(
      context,
      messageEntity: widget.message,
      message: message,
      type: type,
      repliedTo: repliedTo,
      repliedMessageType: repliedMessageType,
      repliedMessage: repliedMessage,
    ).then((value) {
      setState(() {
        _textMessageController.clear();
      });
      _scrollToBottom();
    });
  }
}
