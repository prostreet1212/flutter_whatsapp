import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_whatsapp/features/call/presentation/pages/call_history_page.dart';
import 'package:flutter_whatsapp/features/chat/presentation/pages/chat_page.dart';
import 'package:flutter_whatsapp/features/status/presentation/pages/status_page.dart';
import 'package:flutter_whatsapp/features/user/presentation/cubit/get_single_user/get_single_user_cubit.dart';

import '../../user/domain/entities/user_entity.dart';
import '../../user/presentation/cubit/user/user_cubit.dart';
import '../const/page_const.dart';
import '../theme/style.dart';
import 'contacts_page.dart';

class HomePage extends StatefulWidget {
  final String uid;
  final int? index;

  const HomePage({Key? key, required this.uid, this.index}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController? _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(uid: widget.uid);
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(() {
      setState(() {
        _currentTabIndex = _tabController!.index;
      });
    });

   /* if (widget.index != null) {
      setState(() {
        _currentTabIndex = widget.index!;
        _tabController!.animateTo(1);
      });
    }*/
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController!.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        BlocProvider.of<UserCubit>(context)
            .updateUser(user: UserEntity(uid: widget.uid, isOnline: true));
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        BlocProvider.of<UserCubit>(context)
            .updateUser(user: UserEntity(uid: widget.uid, isOnline: false));
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
        builder: (context, state) {
      if (state is GetSingleUserLoaded) {
        final currentUser = state.singleUser;
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "WhatsApp",
              style: TextStyle(
                  fontSize: 20, color: greyColor, fontWeight: FontWeight.w600),
            ),
            actions: [
              Row(
                children: [
                  const Icon(
                    Icons.camera_alt_outlined,
                    color: greyColor,
                    size: 28,
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  const Icon(Icons.search, color: greyColor, size: 28),
                  const SizedBox(
                    width: 10,
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.more_vert,
                      color: greyColor,
                      size: 28,
                    ),
                    color: appBarColor,
                    iconSize: 28,
                    onSelected: (value) {},
                    itemBuilder: (context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: "Settings",
                        child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, PageConst.settingsPage,
                                  arguments: widget.uid);
                            },
                            child: const Text('Settings')),
                      ),
                    ],
                  ),
                ],
              ),
            ],
            bottom: TabBar(
              labelColor: tabColor,
              unselectedLabelColor: greyColor,
              indicatorColor: tabColor,
              controller: _tabController,
              tabs: const [
                Tab(
                  child: Text(
                    "Chats",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Tab(
                  child: Text(
                    "Status",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Tab(
                  child: Text(
                    "Calls",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton:
              switchFloatingActionButtonOnTabIndex(_currentTabIndex),
          body: TabBarView(
            controller: _tabController,
            children: [
              ChatPage(
                uid: widget.uid,
              ),
               StatusPage(
                currentUser: currentUser,
              ),
              CallHistoryPage(),
            ],
          ),
        );
      }
      return const Center(
        child: CircularProgressIndicator(
          color: tabColor,
        ),
      );
    });
  }

  switchFloatingActionButtonOnTabIndex(int index) {
    switch (index) {
      case 0:
        {
          return FloatingActionButton(
            backgroundColor: tabColor,
            onPressed: () {
              Navigator.pushNamed(context, PageConst.contactUsersPage,
                  arguments: widget.uid);
            },
            child: const Icon(
              Icons.message,
              color: Colors.white,
            ),
          );
        }
      case 1:
        {
          return FloatingActionButton(
            backgroundColor: tabColor,
            onPressed: () {
              /*selectMedia().then(
                    (value) {
                  if (_selectedMedia != null && _selectedMedia!.isNotEmpty) {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      isDismissible: false,
                      enableDrag: false,
                      context: context,
                      builder: (context) {
                        return ShowMultiImageAndVideoPickedWidget(
                          selectedFiles: _selectedMedia!,
                          onTap: () {
                            _uploadImageStatus(currentUser);
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  }
                },
              );*/
            },
            child: const Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
          );
        }
      case 2:
        {
          return FloatingActionButton(
            backgroundColor: tabColor,
            onPressed: () {
              Navigator.pushNamed(context, PageConst.callContactsPage);
            },
            child: const Icon(
              Icons.add_call,
              color: Colors.white,
            ),
          );
        }
      default:
        {
          return FloatingActionButton(
            backgroundColor: tabColor,
            onPressed: () {},
            child: const Icon(
              Icons.message,
              color: Colors.white,
            ),
          );
        }
    }
  }
}
