import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jiffy/jiffy.dart';

import 'package:photo_view/photo_view.dart';

import '../../../../models/chatModel.dart';
import '../../../../models/usersModel.dart';
import '../../../../shared/Cubit/AppCubit/cubit.dart';
import '../../../../shared/Cubit/AppCubit/state.dart';

class ChatsTakes extends StatefulWidget {
  ChatsTakes({Key? key, required this.model}) : super(key: key);
  final socialUsersModel model;

  @override
  State<ChatsTakes> createState() => _ChatsTakesState();
}

class _ChatsTakesState extends State<ChatsTakes> {
  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();
    return Builder(builder: (context) {
      ScrollController controller = ScrollController();

      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (controller.hasClients) controller.jumpTo(controller.position.maxScrollExtent);
        controller.jumpTo(controller.position.extentAfter);
      });
      socialCubit.get(context).getMessages(reciverId: widget.model.uId.toString());
      return BlocConsumer<socialCubit, socialStates>(listener: (context, state) {
        if (state is socialGetMessgeSuccessState) {
          controller.animateTo(controller.position.maxScrollExtent,
              duration: Duration(milliseconds: 300), curve: Curves.easeOutSine);
        }
      }, builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.model.image.toString()),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(widget.model.name.toString())
                ],
              ),
            ),
            body: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Expanded(
                    child: CupertinoScrollbar(
                      controller: controller,
                      child: ListView.builder(
                          controller: controller,
                          itemCount: socialCubit.get(context).messagesList.length,
                          itemBuilder: (context, index) {
                            return buildMessage(context,
                                message: socialCubit.get(context).messagesList[index],
                                currentuId: socialCubit.get(context).currentUid!);
                          }),
                    ),
                  ),
                  if (socialCubit.get(context).imagePost != null)
                    Container(
                      height: 200,
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            child: Image(
                              image: FileImage(socialCubit.get(context).imagePost!),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(25)),
                            child: IconButton(
                                onPressed: () {
                                  socialCubit.get(context).deletePostImage();
                                },
                                icon: Icon(Iconsax.close_circle)),
                          ),
                        ],
                      ),
                    ),
                  Container(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[700],
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          child: Row(children: [
                            Expanded(
                                child: TextFormField(
                              controller: messageController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: "Send a message...",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none,
                              ),
                            )),
                            const SizedBox(
                              width: 12,
                            ),
                            IconButton(
                                onPressed: () {
                                  socialCubit.get(context).getImagePost();
                                },
                                icon: Icon(CupertinoIcons.camera)),
                            state is socialUploadImageMessageLoadingState
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    child: IconButton(
                                      padding: EdgeInsets.all(10),
                                      onPressed: () {
                                        if (socialCubit.get(context).imagePost == null) {
                                          if (messageController.text != '') {
                                            socialCubit.get(context).sendMessage(
                                                dateTime: Jiffy().format("d MM yyyy, h:mm:ss a"),
                                                reciverId: widget.model.uId.toString(),
                                                text: messageController.text);
                                          }
                                          messageController.text = '';
                                        } else if (socialCubit.get(context).imagePost != null) {
                                          socialCubit.get(context).uploadImageMessage(
                                              reciverId: widget.model.uId.toString(),
                                              text: messageController.text);

                                          messageController.text = '';
                                        }
                                      },
                                      icon: Icon(
                                        CupertinoIcons.chat_bubble_text,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                          ]))),
                ],
              ),
            ),
          ),
        );
      });
    });
  }

  Widget buildMessage(
    context, {
    required MessgeModel message,
    required String currentuId,
  }) {
    return Container(
      padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: message.senderId == currentuId ? 0 : 24,
          right: message.senderId == currentuId ? 24 : 0),
      alignment: message.senderId == currentuId ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: message.senderId == currentuId
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding: const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: message.senderId == currentuId
                ? const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
            color:
                message.senderId == currentuId ? Theme.of(context).primaryColor : Colors.grey[700]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.senderId == currentuId
                  ? widget.model.name.toString()
                  : widget.model.name.toString(),
              textAlign: TextAlign.start,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5),
            ),
            const SizedBox(
              height: 8,
            ),
            if (message.text != '')
              Text(message.text.toString(),
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontSize: 16, color: Colors.white)),
            SizedBox(
              height: 10,
            ),
            if (message.image != '')
              InkWell(
                  onTap: () {
                    PhotoView(imageProvider: NetworkImage(message.image.toString()));
                  },
                  child: Image(image: NetworkImage(message.image!)))
          ],
        ),
      ),
    );
  }
}
