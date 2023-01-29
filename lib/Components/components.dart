import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jiffy/jiffy.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:photo_view/photo_view.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../layout/Profile/editProfile/edit.dart';
import '../shared/Cubit/AppCubit/cubit.dart';
import '../shared/Cubit/AppCubit/state.dart';
import '../shared/Cubit/SettingCubit/cubit.dart';
import '../shared/Cubit/SettingCubit/state.dart';
import '../shared/locale/SharedPrefrences/CacheHelper.dart';

String? uId;
Widget textFormFiledDefult({
  Icon? prefixicon,
  required String HintText,
  MaterialButton? suffixIcon,
  TextInputType? typekeyboard,
  TextEditingController? FormFielController,
  String? Function(String?)? validate,
  EdgeInsetsGeometry? paddingcontainer,
  required bool ispassword,
  bool? readonly,
}) =>
    TextFormField(
      readOnly: readonly ?? false,
      keyboardType: typekeyboard,
      controller: FormFielController,
      validator: validate,
      obscureText: ispassword,
      decoration: InputDecoration(
        prefixIcon: prefixicon,
        hintText: HintText,
        suffixIcon: suffixIcon,
      ),
    );
Widget materialButtonClick({
  required String textbtn,
  VoidCallback? clickbtn,
}) =>
    MaterialButton(
      color: Color.fromARGB(255, 50, 158, 133),
      padding: const EdgeInsets.all(10),
      minWidth: double.infinity,
      onPressed: clickbtn,
      child: Text(
        textbtn,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
void navigtorPushClick(context, Widget) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (contex) => Widget,
    ));

void toastStyle({
  required context,
  String? massege,
  Color? colortoast,
}) =>
    showToast(massege,
        context: context,
        animation: StyledToastAnimation.slideFromLeft,
        reverseAnimation: StyledToastAnimation.fade,
        position: StyledToastPosition.top,
        animDuration: Duration(seconds: 1),
        duration: Duration(seconds: 4),
        curve: Curves.elasticOut,
        reverseCurve: Curves.linear,
        backgroundColor: colortoast);

Widget darkMode() => BlocConsumer<SettingCubit, SettingStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Text("الوضع الليلي"),
                  const SizedBox(
                    width: 15,
                  ),
                  FlutterSwitch(
                      value: SettingCubit.get(context).DarkMode,
                      padding: 8.0,
                      showOnOff: true,
                      onToggle: (value) {
                        SettingCubit.get(context).toggleTheme();
                      }),
                ],
              ),
            ],
          ),
        );
      },
    );

// ignore: slash_for_doc_comments
/****************************Home Layout */
Widget buildProfile(context) => BlocProvider.value(
      value: socialCubit()..getUserData(),
      child: Card(
        color: Theme.of(context).scaffoldBackgroundColor,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 0,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              height: 250,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: InkWell(
                          onTap: () {
                            buildImageView(context,
                                imageurl: socialCubit.get(context).model!.coverimage);
                          },
                          child: Image(
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 230,
                              image: NetworkImage("${socialCubit.get(context).model!.coverimage}")),
                        ),
                      ),
                      CircleAvatar(
                        radius: 20,
                        child: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => BlocConsumer<socialCubit, socialStates>(
                                listener: (context, state) {
                                  if (state is socialUploadProfileCoverSuccessState) {
                                    socialCubit.get(context).coverImage = null;
                                    Navigator.of(context).pop();
                                    socialCubit.get(context).getUserData();
                                    toastStyle(
                                        context: context,
                                        massege: "تم تحديث الصورة بنجاح",
                                        colortoast: Colors.green);
                                  }
                                },
                                builder: (context, state) {
                                  return state is socialUploadProfileCoverLoadingState
                                      ? Center(
                                          child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: const [
                                            CircularProgressIndicator(),
                                            Text("جار رفع صورة الغلاف برجاء الانتظار")
                                          ],
                                        ))
                                      : AlertDialog(
                                          content: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text("تحميل صورة الغلاف"),
                                                ConditionalBuilder(
                                                  condition:
                                                      socialCubit.get(context).coverImage != null,
                                                  builder: (context) => Image(
                                                    image: FileImage(
                                                        socialCubit.get(context).coverImage!),
                                                  ),
                                                  fallback: (context) => const Text("اختر الصورة"),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    socialCubit.get(context).getCoverImage();
                                                  },
                                                  icon: const Icon(Icons.camera),
                                                ),
                                                Row(
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        socialCubit.get(context).uploadCoverImage();
                                                      },
                                                      child: const Text("رفع"),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        socialCubit.get(context).coverImage = null;

                                                        Navigator.of(context).pop();
                                                      },
                                                      child: const Text("الغاء"),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                },
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.photo_camera,
                          ),
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    radius: 60,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomStart,
                      children: [
                        SizedBox(
                          height: 200,
                          child: InkWell(
                            onTap: () {
                              buildImageView(context,
                                  imageurl: socialCubit.get(context).model!.image);
                            },
                            child: CircleAvatar(
                              radius: 55,
                              backgroundImage: NetworkImage(
                                '${socialCubit.get(context).model!.image}',
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => BlocConsumer<socialCubit, socialStates>(
                                listener: (context, state) {
                                  if (state is socialUploadProfileImageSuccessState) {
                                    socialCubit.get(context).profileimage = null;

                                    Navigator.of(context).pop();
                                    socialCubit.get(context).getUserData();
                                    toastStyle(
                                        context: context,
                                        massege: "تم تحديث الصورة بنجاح",
                                        colortoast: Colors.green);
                                  }
                                },
                                builder: (context, state) {
                                  return state is socialUploadProfileImageLoadingState
                                      ? Center(
                                          child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: const [
                                            CircularProgressIndicator(),
                                            Text("جار رفع الصورة برجاء الانتظار")
                                          ],
                                        ))
                                      : AlertDialog(
                                          content: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text("تحميل الصورة"),
                                                ConditionalBuilder(
                                                  condition:
                                                      socialCubit.get(context).profileimage != null,
                                                  builder: (context) => Image(
                                                    image: FileImage(
                                                        socialCubit.get(context).profileimage!),
                                                  ),
                                                  fallback: (context) => const Text("اختر الصورة"),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    socialCubit.get(context).getProfileImage();
                                                  },
                                                  icon: const Icon(Icons.camera),
                                                ),
                                                Row(
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        socialCubit
                                                            .get(context)
                                                            .uploadProfileImage();
                                                      },
                                                      child: const Text("رفع"),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        socialCubit.get(context).profileimage =
                                                            null;
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: const Text("الغاء"),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                },
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.photo_camera,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "${socialCubit.get(context).model!.name}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            if (socialCubit.get(context).model!.bio != '')
              Text(
                "${socialCubit.get(context).model!.bio}",
                style: Theme.of(context).textTheme.caption,
              ),
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (socialCubit.get(context).model!.education != '')
                        Column(
                          children: [
                            buildProfileInfo(
                                iconData: Icons.leaderboard_rounded,
                                text: socialCubit.get(context).model!.education),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      if (socialCubit.get(context).model!.date != '')
                        Column(
                          children: [
                            buildProfileInfo(
                              iconData: Icons.date_range,
                              text: "${socialCubit.get(context).model!.date}",
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      if (socialCubit.get(context).model!.relationship != '')
                        Column(
                          children: [
                            buildProfileInfo(
                                iconData: Iconsax.chart1,
                                text: socialCubit.get(context).model!.relationship),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      buildProfileInfo(
                          iconData: Iconsax.chart1,
                          text: "انضممت في ${socialCubit.get(context).model!.joinedis}"),
                      const SizedBox(
                        height: 10,
                      ),
                      buildProfileInfo(
                          iconData: Iconsax.mobile,
                          text: " ${socialCubit.get(context).model!.phone}"),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
Widget buildProfileInfo({IconData? iconData, String? text}) => Row(
      children: [
        Icon(iconData),
        SizedBox(
          width: 15,
        ),
        Text(text!)
      ],
    );
buildImageView(context, {String? imageurl}) => showDialog(
      context: context,
      builder: (context) => Container(
          child: PhotoView(
        imageProvider: NetworkImage("${imageurl}"),
      )),
    );
Widget buildFollowing(context) => Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {},
              child: Column(
                children: [
                  Text('${socialCubit.get(context).postsCount}'),
                  Text(
                    "Private Posts",
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );

/****************************Home Layout */

/**********************************ProfileEdit */
Widget editProfileForm(
    {String? name,
    TextEditingController? controller,
    String? Function(String?)? validator,
    int? length,
    Widget? suffix,
    Widget? suffixicon,
    VoidCallback? onTap}) {
  return Card(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(padding: EdgeInsetsDirectional.only(start: 10, end: 10), child: Text(name!)),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                decoration: InputDecoration(
                    border: InputBorder.none, suffix: suffix, suffixIcon: suffixicon),
                controller: controller,
                validator: validator,
                maxLength: length,
                maxLines: 1,
                onTap: onTap,
              ),
            ),
          ),
        )
      ],
    ),
  );
}

/**********************************ProfileEdit */