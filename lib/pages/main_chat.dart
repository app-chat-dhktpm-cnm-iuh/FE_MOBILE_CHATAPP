import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/model/UserToken.dart';
import 'package:fe_mobile_chat_app/services/stomp_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class MainChat extends StatefulWidget {
  final StompManager stompManager;
  const MainChat({super.key, required this.stompManager});

  @override
  State<MainChat> createState() => _MainChatState();
}

class Chat {
  final String sender;
  final String message;
  final DateTime timestamp;

  Chat({required this.sender, required this.message, required this.timestamp});
}

class _MainChatState extends State<MainChat> {
  var _index = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var _tabBodies;

  void onTabTapped(int index) {
    setState(() {
      if (index == 2) {
        _scaffoldKey.currentState?.openEndDrawer();
      } else if (index == 1) {
        _tabBodies = FriendsListWidget();
      } else if (index == 0) {
        _tabBodies = ChatsListWidget();
      }
    });
  }

  Friend? selectedValue;

  List<Friend> friends = [
    Friend(
      userName: 'John',
      imgURL: '',
    ),
    Friend(userName: 'Alice', imgURL: 'assets/images/Ava.png'),
  ];

  List<Friend> searchResults = [];
  bool showResults = false;

  void searchItems(String query) {
    setState(() {
      if (query.isNotEmpty) {
        searchResults = friends
            .where((friend) =>
                friend.userName.toLowerCase().contains(query.toLowerCase()))
            .toList();
        showResults = true;
      } else {
        searchResults.clear();
        showResults = false;
      }
    });
  }

  // void onConnect(StompFrame frame) {
  //   print("connected!!");
  //   try{
  //     stompClient.subscribe(
  //       destination: '/topic/public',
  //       callback: (frame) {
  //         // final message = jsonDecode(frame.body!) ;
  //         // final parseMessage = jsonDecode(message!);
  //         printResult(frame.body);
  //         // print( "/user/public/ subcribe value: ${message}");
  //       },
  //     );
  //   } catch(e) {
  //     print("Error: $e");
  //   }
  //
  // }

  void printResult(dynamic data) {
    print("subscribed");
    final message = jsonDecode(data!);
    print(message);
    // final parseMessage = jsonDecode(message!);
  }


  @override
  void initState() {
    super.initState();
    widget.stompManager.subscribeToDestination("/topic/public").listen((frame) {

      print("Subscribe value: ${frame.body}");
    });
  } // @override
  // void initState() {
  //   super.initState();
  //   // final stompProvider = Provider.of<StompProvider>(context);
  //   // stompProvider.connect();
  //   stompProvider.stompClient?.subscribe(destination: "/topic/public", callback: (frame) {
  //     print("value subscribe: ${frame.body}");
  //   },);
  //   // stompClient = StompClient(
  //   //     config: StompConfig(
  //   //       url: socketUrl,
  //   //       onConnect: onConnect,
  //   //       onWebSocketError: (dynamic error) {
  //   //         print(error.toString());
  //   //       },
  //   //     ));
  //   // stompClient.activate();
  // }
  //
  // @override
  // void dispose() {
  //   // stompClient.deactivate();
  //   final stompProvider = Provider.of<StompProvider>(context);
  //   stompProvider.disconnect();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var user = ModalRoute.of(context)?.settings.arguments as UserToken;
    // final stompProvider = Provider.of<StompProvider>(context);
    print(user.toJson());
    var size = MediaQuery.of(context).size;
    var padding = MediaQuery.of(context).padding;
    _tabBodies ??= ChatsListWidget();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
        title: SvgPicture.asset("assets/images/Smilechat-logo.svg"),
        actions: [
          IconButton(
              onPressed: () {
                // stompClient.send(
                //   destination: '/app/user.userOnline',
                //   body: JsonEncoder().convert(user.user?.toJson()),
                // );
                // stompProvider.stompClient?.send(
                //   destination: '/app/user.userOnline',
                //   body: JsonEncoder().convert(user.user?.toJson()),
                // );
              },
              icon: Icon(
                Icons.add,
                color: darkGreen,
                size: size.height * 0.03,
              ))
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: lightGreen))),
        child: BottomNavigationBar(
          currentIndex: _index,
          iconSize: padding.vertical * 0.6,
          backgroundColor: backgroundColor,
          selectedItemColor: darkGreen,
          unselectedItemColor: lightGreen,
          onTap: (value) {
            setState(() {
              _index = value;
              onTabTapped(value);
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.chat_bubble_fill),
                label: "Trò chuyện"),
            BottomNavigationBarItem(
                icon: Icon(Icons.contacts_rounded), label: "Danh bạ"),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person_fill), label: "Cá nhân"),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: Container(
            color: backgroundColor,
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: size.width * 0.2, bottom: size.width * 0.02),
                    child: CircleAvatar(
                      backgroundImage:
                          const AssetImage("assets/images/Ava.png"),
                      radius: padding.vertical,
                    ),
                  ),
                  Text(
                    "Tên tài khoản",
                    style: TextStyle(fontSize: size.width * 0.04),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: size.width * 0.05, bottom: size.width * 0.03),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(darkGreen),
                          fixedSize: MaterialStateProperty.all(
                              Size(size.width * 0.55, size.height * 0.05))),
                      child: Text(
                        "Hồ sơ cá nhân",
                        style: TextStyle(
                            color: Colors.white, fontSize: size.height * 0.015),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(darkGreen),
                        fixedSize: MaterialStateProperty.all(
                            Size(size.width * 0.55, size.height * 0.05))),
                    child: Text("Đăng xuất",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.015)),
                  )
                ],
              ),
            )),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: padding.vertical * 0.5, bottom: padding.vertical * 0.1),
              child: SizedBox(
                width: size.width * 0.8,
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) {
                        searchItems(value);
                      },
                      style: TextStyle(
                          fontSize: size.height * 0.02,
                          fontWeight: FontWeight.bold,
                          color: lightGreen),
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                            color: greyDark,
                          ),
                          contentPadding: EdgeInsets.all(size.height * 0.01),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Tìm kiếm",
                          hintStyle: TextStyle(
                              fontSize: size.height * 0.02,
                              fontWeight: FontWeight.normal,
                              color: greyDark),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: lightGray),
                            borderRadius: BorderRadius.circular(size.width),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(size.width),
                              borderSide: const BorderSide(color: lightGreen))),
                    ),
                    Visibility(
                      visible: showResults,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: searchResults.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom:
                                              BorderSide(color: lightGreen))),
                                  child: ListTile(
                                    title: Text(searchResults[index].userName),
                                    leading: createAvatar(
                                        searchResults[index].imgURL,
                                        size,
                                        searchResults[index].userName),
                                    trailing: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.person_add_outlined,
                                        color: lightGreen,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            _tabBodies
          ],
        ),
      ),
    );
  }
}

class ChatsListWidget extends StatelessWidget {
  ChatsListWidget({
    super.key,
  });

  final List<Chat> chats = [
    Chat(
      sender: 'John',
      message: 'Hello',
      timestamp: DateTime.now(),
    ),
    Chat(
      sender: 'Alice',
      message: 'Hi there!',
      timestamp: DateTime.now(),
    ),
  ];

  String dateFormat(DateTime date) {
    return '${date.day}-${date.month.toString().padLeft(2, '0')}-${date.year.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: const AssetImage("assets/images/Ava.png"),
                    radius: size.width * 0.05,
                  ),
                  title: Text(
                    chat.sender,
                    style: TextStyle(fontSize: size.width * 0.04),
                  ),
                  subtitle: Text(
                    chat.message,
                    style: TextStyle(
                        color: greyDark, fontSize: size.width * 0.035),
                  ),
                  trailing: Text(
                    dateFormat(chat.timestamp.toLocal()).toString(),
                    style: TextStyle(
                        color: greyDark,
                        fontWeight: FontWeight.normal,
                        fontSize: size.width * 0.035),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FriendsListWidget extends StatelessWidget {
  const FriendsListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Expanded(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: lightGreen))),
              child: TabBar(
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: darkGreen,
                labelStyle: TextStyle(
                    color: lightGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: size.width * 0.04),
                unselectedLabelStyle: TextStyle(
                    color: lightGreen,
                    fontWeight: FontWeight.normal,
                    fontSize: size.width * 0.04),
                tabs: const [
                  Tab(
                    text: 'Bạn bè',
                  ),
                  Tab(
                    text: 'Nhóm',
                  )
                ],
              ),
            ),
            Expanded(
                child: TabBarView(
              children: [FriendsTab(), GroupTab()],
            ))
          ],
        ),
      ),
    );
  }
}

class GroupTab extends StatelessWidget {
  GroupTab({
    super.key,
  });

  final List<Friend> friends = [
    Friend(
      userName: 'Nhóm 1',
      imgURL: '',
    ),
    Friend(userName: 'Nhóm 2', imgURL: 'assets/images/Ava.png'),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0))),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    right: size.width * 0.02,
                    top: size.width * 0.03,
                    bottom: size.width * 0.03,
                    left: size.width * 0.03),
                child: SvgPicture.asset("assets/images/create_group.svg"),
              ),
              Text(
                "Tạo nhóm",
                style:
                    TextStyle(fontSize: size.width * 0.04, color: Colors.black),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    final friend = friends[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: size.width * 0.03),
                      child: ListTile(
                        leading:
                            createAvatar(friend.imgURL, size, friend.userName),
                        title: Text(
                          friend.userName,
                          style: TextStyle(fontSize: size.width * 0.04),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class Friend {
  final String userName;
  final String imgURL;

  Friend({
    required this.userName,
    required this.imgURL,
  });
}

class FriendsTab extends StatelessWidget {
  FriendsTab({
    super.key,
  });

  final List<Friend> friends = [
    Friend(
      userName: 'John',
      imgURL: '',
    ),
    Friend(userName: 'Alice', imgURL: 'assets/images/Ava.png'),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0))),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    right: size.width * 0.02,
                    top: size.width * 0.03,
                    bottom: size.width * 0.03,
                    left: size.width * 0.03),
                child: SvgPicture.asset("assets/images/invites.svg"),
              ),
              Text(
                "Lời mời kết bạn",
                style:
                    TextStyle(fontSize: size.width * 0.04, color: Colors.black),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    final friend = friends[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: size.width * 0.03),
                      child: ListTile(
                        leading:
                            createAvatar(friend.imgURL, size, friend.userName),
                        title: Text(
                          friend.userName,
                          style: TextStyle(fontSize: size.width * 0.04),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

CircleAvatar createAvatar(String imgUrl, Size size, String userName) {
  Color randomColor = getRamdomColor();
  if (imgUrl == null || imgUrl == "") {
    return CircleAvatar(
      radius: size.width * 0.05,
      backgroundColor: randomColor,
      child: Text(
        userName.substring(0, 1),
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: size.width * 0.04),
      ),
    );
  } else {
    return CircleAvatar(
      radius: size.width * 0.05,
      backgroundImage: AssetImage(imgUrl),
    );
  }
}

Color getRamdomColor() {
  Random random = Random();
  return Color.fromARGB(
      255, random.nextInt(256), random.nextInt(256), random.nextInt(256));
}
