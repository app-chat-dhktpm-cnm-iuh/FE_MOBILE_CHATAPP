import 'dart:async';

import 'package:fe_mobile_chat_app/constants.dart';
import 'package:fe_mobile_chat_app/model/User.dart';
import 'package:fe_mobile_chat_app/pages/user_detail_page.dart';
import 'package:fe_mobile_chat_app/services/function_service.dart';
import 'package:fe_mobile_chat_app/services/stomp_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';

class UpdateUserDetailsPage extends StatefulWidget {
  final StompManager stompManager;
  final User user;
  const UpdateUserDetailsPage(
      {super.key, required this.stompManager, required this.user});

  @override
  State<UpdateUserDetailsPage> createState() => _UpdateUserDetailsPageState();
}

class _UpdateUserDetailsPageState extends State<UpdateUserDetailsPage> {
  StompManager stompManager = StompManager();
  User currentUser = User();
  bool _selectedOption = false;
  @override
  void initState() {
    super.initState();
    stompManager = widget.stompManager;
    currentUser = widget.user;
    _selectedOption = widget.user.gender!;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final _controllerUserName = TextEditingController(
      text: currentUser.name
    );
    final _controllerDateOfBirth = TextEditingController();
    DateTime? dateOfBirth = currentUser.dateOfBirth;
    print(currentUser);

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
        });
      }
    }

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
                        FunctionService.createAvatar(currentUser.avatarUrl,
                            size, currentUser.name!, PROFILE),
                        Positioned(
                          top: size.width*0.1,
                          left: size.width*0.12,
                          child: IconButton(
                              onPressed: () { },
                              icon: const Icon(Icons.photo_camera_rounded, color: lightGreen,),
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
                            controller: _controllerUserName,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(
                                color: darkGreen,
                                fontSize: size.width * 0.043,
                                fontWeight: FontWeight.w400),
                            decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: darkGreen)
                                ),
                              suffixIcon: Icon(Icons.person, color: lightGreen,)
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width*0.7,
                          child: GestureDetector(
                            onTap: () => selectDateOfBirth(context),
                            child: AbsorbPointer(
                              child: TextField(
                                controller: TextEditingController(
                                  text: currentUser.dateOfBirth == null
                                      ? "10/10/2000"
                                      : '${currentUser.dateOfBirth!.day}/${currentUser.dateOfBirth!.month}/${currentUser.dateOfBirth!.year}'
                                ),
                                style: TextStyle(
                                    color: darkGreen,
                                    fontSize: size.width * 0.043,
                                    fontWeight: FontWeight.w400),
                                decoration: const InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: darkGreen)
                                  ),
                                  suffixIcon: Icon(Icons.cake, color: lightGreen,)
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
                                      activeColor: lightGreen,
                                      value: true,
                                      groupValue: _selectedOption,
                                      onChanged: (value) {

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
                                      activeColor: lightGreen,
                                      value: false,
                                      groupValue: _selectedOption,
                                      onChanged: (value) {

                                      },
                                  ),
                                  Text('Nữ', style: TextStyle(fontSize: size.width*0.043))
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
              ],
            ),
            ElevatedButton(
                onPressed: () {},
                child: Text("LƯU", style: TextStyle(fontSize: size.width*0.04, color: Colors.white),),
                style: ButtonStyle(
                  alignment: Alignment.center,
                  backgroundColor: MaterialStateProperty.all(lightGreen),
                  fixedSize: MaterialStateProperty.all(
                      Size(size.width, size.height*0.05)
                  )
              ),

            ),
          ],
        ),
      ),
    );
  }

}
