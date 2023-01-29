import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Components/components.dart';
import '../../../models/usersModel.dart';
import '../../../shared/Cubit/AppCubit/cubit.dart';
import '../../../shared/Cubit/AppCubit/state.dart';

class Postnew extends StatelessWidget {
  Postnew({Key? key, this.model}) : super(key: key);
  final socialUsersModel? model;
  @override
  Widget build(BuildContext context) {
    TextEditingController postController = TextEditingController();
    return BlocProvider.value(
      value: socialCubit()..getUserData(),
      child: BlocConsumer<socialCubit, socialStates>(
        listener: (context, state) {
          if (state is socialCreatePostSuccessState) {
            toastStyle(
              context: context,
              massege: "تم اضافة المنشور",
              colortoast: Colors.green,
            );
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                title: Text("المنشورات"),
              ),
              body: ConditionalBuilder(
                builder: (context) {
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(
                                  '${socialCubit.get(context).model!.image}',
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("${socialCubit.get(context).model!.name}"),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                    DropdownButton<String>(
                                      style: TextStyle(
                                          fontSize: 13, fontFamily: 'Cairo', color: Colors.blue),
                                      value: socialCubit.get(context).selectedValue,
                                      onChanged: (String? newValue) {
                                        socialCubit.get(context).changeDropItem(newValue!);
                                      },

                                      items: socialCubit
                                          .get(context)
                                          .items
                                          .map<DropdownMenuItem<String>>(
                                              (String value) => DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(value),
                                                  ))
                                          .toList(),

                                      // add extra sugar..
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 42,
                                      underline: SizedBox(),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.more_horiz),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: TextFormField(
                              controller: postController,
                              maxLines: 10,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(), hintText: "بم تفكر"),
                            ),
                          ),
                        ),
                        if (socialCubit.get(context).imagePost != null)
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                            padding: EdgeInsets.all(15),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Image(
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 230,
                                      image: FileImage(socialCubit.get(context).imagePost!)),
                                ),
                                CircleAvatar(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.close,
                                    ),
                                    onPressed: () {
                                      socialCubit.get(context).deletePostImage();
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ElevatedButton(
                            onPressed: () {
                              if (socialCubit.get(context).selectedValue == 'خاص') {
                                if (socialCubit.get(context).imagePost == null) {
                                  //add post without Image
                                  socialCubit.get(context).createNewPost(text: postController.text);
                                } else {
                                  //add post with Image
                                  socialCubit.get(context).uploadPost(text: postController.text);
                                }
                              } else {
                                if (socialCubit.get(context).imagePost == null) {
                                  //add post without Image
                                  socialCubit
                                      .get(context)
                                      .createPublicNewPost(text: postController.text);
                                } else {
                                  //add post with Image
                                  socialCubit
                                      .get(context)
                                      .uploadPublicPost(text: postController.text);
                                }
                              }
                            },
                            child: Text("إضافة المنشور")),
                        Row(
                          children: [
                            TextButton(
                                onPressed: () {
                                  socialCubit.get(context).getImagePost();
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.image),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Text("اضافة صورة")
                                  ],
                                ))
                          ],
                        )
                      ],
                    ),
                  );
                },
                fallback: (context) {
                  return LinearProgressIndicator();
                },
                condition: socialCubit.get(context).model != null,
              ),
            ),
          );
        },
      ),
    );
  }
}
