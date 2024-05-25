import 'dart:async';
import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/model/Friend.dart';
import 'package:fe_mobile_chat_app/model/FriendRequest.dart';
import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:fe_mobile_chat_app/model/UserToken.dart';
import 'package:fe_mobile_chat_app/pages/user_detail_page.dart';
import 'package:fe_mobile_chat_app/services/function_service.dart';
import 'package:fe_mobile_chat_app/services/serviceImpls/friend_serviceImpl.dart';
import 'package:fe_mobile_chat_app/services/serviceImpls/user_serviceImpl.dart';
import 'package:fe_mobile_chat_app/services/stomp_manager.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:media_picker_widget/media_picker_widget.dart';
import 'package:page_transition/page_transition.dart';

class UpdateUserDetailsPage extends StatefulWidget {
  final StompManager stompManager;
  final UserToken userToken;
  final List<User> friends;
  final List<FriendRequest> friendRequets;
  const UpdateUserDetailsPage(
      {super.key,
        required this.stompManager,
        required this.userToken,
        required this.friends,
        required this.friendRequets
      });

  @override
  State<UpdateUserDetailsPage> createState() => _UpdateUserDetailsPageState();
}

class _UpdateUserDetailsPageState extends State<UpdateUserDetailsPage> {
  StompManager stompManager = StompManager();
  User currentUser = User();
  UserToken userWithToken = UserToken();
  List<FriendRequest> friendRequests = [];
  List<User> friendListCurrentUser = [];
  bool _selectedOption = false;
  String? _errorName;
  String? _errorBirthDay;
  TextEditingController controllerUserName = TextEditingController();
  TextEditingController controllerDateOfBirth = TextEditingController();

  String? name = '';
  DateTime? dateOfBirth;
  bool? gender;
  dynamic avatarUrl;

  List<Media> mediaList = [];
  bool _isOpenPicker = false;


  void validateUserName(String value) {
    RegExp regexNumber = RegExp(r"[0-9_]");
    RegExp regexSpecialCharacter = RegExp(r'[!@#$%^&*(),.?":{}|<>_=+-;]');
    RegExp regexValidName = RegExp(r'[A-za-z ]{2,40}');
    _errorName = null;

    if(regexNumber.hasMatch(value)) {
      _errorName = "Tên không được chứa số" ;
    } else if (regexSpecialCharacter.hasMatch(value)) {
      _errorName =  "Tên không được chứa kí tự đặc biệt";
    } else if(value == '') {
      _errorName = null;
    } else if (!regexValidName.hasMatch(value)) {
      _errorName = "Tên không hợp lệ. Xin hãy đọc kỹ lưu ý";
    }
  }

  void validateBirthDay(DateTime? birthDay) {
    var age = DateTime.now().year - birthDay!.year;
    if(age < 18) {
      _errorBirthDay = "Ngày sinh phải trên 18 tuổi";
    } else {
      _errorBirthDay = null;
    }
  }

  @override
  void initState() {
    super.initState();
    stompManager = widget.stompManager;
    currentUser = widget.userToken.user!;
    _selectedOption = currentUser.gender!;
    friendRequests = widget.friendRequets;
    friendListCurrentUser = widget.friends;

    controllerUserName = TextEditingController(
        text: currentUser.name
    );

    avatarUrl = currentUser.avatarUrl;
    dateOfBirth = currentUser.dateOfBirth;
    gender = _selectedOption;
    controllerDateOfBirth = TextEditingController(
        text: currentUser.dateOfBirth == null
            ? "20/10/2000"
            : '${currentUser.dateOfBirth!.day}/${currentUser.dateOfBirth!.month}/${currentUser.dateOfBirth!.year}'
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateOfBirth ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != dateOfBirth) {
      setState(() {
        dateOfBirth = picked;
        validateBirthDay(dateOfBirth);
        controllerDateOfBirth.value = TextEditingValue(
            text: '${dateOfBirth!.day}/${dateOfBirth!.month}/${dateOfBirth!.year}'
        );
      });
    }
  }


  Future<void> pickAvatar() async {
    setState(() {
      if (_isOpenPicker == false) {
        _isOpenPicker = true;
      } else {
        _isOpenPicker = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chỉnh sửa thông tin",
          style: TextStyle(color: Colors.white, fontSize: size.width * 0.05),
        ),
        backgroundColor: lightGreen,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(size.height*0.02),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Stack(
                      children: [
                        FunctionService.createAvatar(avatarUrl,
                            size, currentUser.name!, PROFILE),
                        Positioned(
                          top: size.width*0.1,
                          left: size.width*0.12,
                          child: IconButton(
                              onPressed: pickAvatar,
                              icon: const Icon(Icons.photo_camera_rounded, color: darkGreen,),
                              style: IconButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(size.width*0.06),
                                  side: const BorderSide(color: Colors.black26)
                                ),
                                backgroundColor: Colors.white
                              ),
                          ),
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        SizedBox(
                          width: size.width*0.7,
                          child: TextField(
                            controller: controllerUserName,
                            onChanged: (value) => setState(() {
                             validateUserName(value);
                             name = controllerUserName.text;

                             controllerUserName.value = TextEditingValue(
                               text: name.toString()
                             );
                            }),
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(
                                color: darkGreen,
                                fontSize: size.width * 0.043,
                                fontWeight: FontWeight.w400),
                            decoration: InputDecoration(
                                focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: darkGreen)
                                ),
                              hintText: 'Tên tài khoản',
                              errorText: _errorName,
                              errorStyle: TextStyle(
                                  fontSize: size.width*0.035
                              ),
                              suffixIcon: const Icon(Icons.person, color: darkGreen,)
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width*0.7,
                          child: GestureDetector(
                            onTap: () => selectDateOfBirth(context),
                            child: AbsorbPointer(
                              child: TextField(
                                controller: controllerDateOfBirth,
                                style: TextStyle(
                                    color: darkGreen,
                                    fontSize: size.width * 0.043,
                                    fontWeight: FontWeight.w400),
                                decoration: InputDecoration(
                                  focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: darkGreen)
                                  ),
                                    errorText: _errorBirthDay,
                                    errorStyle: TextStyle(
                                        fontSize: size.width*0.035
                                    ),
                                  suffixIcon: const Icon(Icons.cake, color: darkGreen,)
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Radio(
                                      activeColor: darkGreen,
                                      value: true,
                                      groupValue: _selectedOption,
                                      onChanged: (value) {
                                        setState(() {
                                          gender = value;
                                          _selectedOption = value!;
                                        });
                                      },
                                  ),
                                  Text('Nam', style: TextStyle(fontSize: size.width*0.043),)
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Radio(
                                      activeColor: darkGreen,
                                      value: false,
                                      groupValue: _selectedOption,
                                      onChanged: (value) {
                                        setState(() {
                                          gender = value;
                                          _selectedOption = value!;
                                        });
                                      },
                                  ),
                                  Text('Nữ', style: TextStyle(fontSize: size.width*0.043))
                                ],
                              ),
                            ),
                          ],
                        ),

                      ],
                    )),
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  if(_errorName == null) {
                    User user = User();
                    List<Friend> friendList = [];

                    if(mediaList.isNotEmpty) {
                      File? fileImage = mediaList.first.file;
                      String nameFile = fileImage!.path.split('/').last;

                      Reference reference = FirebaseStorage.instance
                          .ref().child('avatarImages/$nameFile');

                      await reference.putFile(fileImage);

                      avatarUrl = await reference.getDownloadURL();
                    }

                    if(name == '') {
                      name = null;
                    }
                    user = user.copyWith(
                        user_id: currentUser.user_id,
                        avatarUrl: avatarUrl,
                        name: name,
                        gender: gender,
                        dateOfBirth: dateOfBirth,
                        friendsList: friendList,
                        role: currentUser.role
                    );
                    await UserServiceImpl.updateUserDetail(user).then((userDetail) => {
                      setState(() {
                        user = userDetail;
                      })
                    });

                    userWithToken = userWithToken.copyWith(user: user, token: widget.userToken.token);
                    Navigator.push(context, PageTransition(child: UserDetailsPage(stompManager: stompManager, userToken: userWithToken, friendRequests: friendRequests, friends: friendListCurrentUser,), type: PageTransitionType.topToBottom));
                  }
                },
                style: ButtonStyle(
                  alignment: Alignment.center,
                  backgroundColor: MaterialStateProperty.all(darkGreen),
                  fixedSize: MaterialStateProperty.all(
                      Size(size.width, size.height*0.05)
                  )
              ),
                child: Text("LƯU", style: TextStyle(fontSize: size.width*0.04, color: Colors.white),),

            ),
          ],
        ),
      ),
      bottomSheet: Visibility(
          visible: _isOpenPicker,
          child: SizedBox(
            height: size.height * 0.6,
            child: MediaPicker(
              mediaList: mediaList,
              mediaCount: MediaCount.single,
              mediaType: MediaType.image,
              onPicked: (selectedList) {
                setState(() {
                  mediaList = selectedList;
                  _isOpenPicker = false;
                  avatarUrl = mediaList.first.thumbnail;
                });
              },
              onCancel: () => {
                setState(() {
                  _isOpenPicker = false;
                })
              },
              decoration: PickerDecoration(
                cancelIcon: const Icon(
                  CupertinoIcons.clear,
                  color: darkGreen,
                ),
                counterBuilder: (context, index) {
                  if (index == null) return const SizedBox();
                  return Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: size.width * 0.001,
                          right: size.width * 0.01),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: lightGreen,
                            shape: BoxShape.circle),
                        padding: EdgeInsets.all(size.width * 0.015),
                        child: Text(
                          "$index",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )),
    );
  }

}
