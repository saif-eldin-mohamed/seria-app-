import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:search_page/search_page.dart';
import 'package:untitled/layout/Home_Layout/screens/chats/chats.dart';
import 'package:untitled/layout/Home_Layout/screens/feeds/feeds.dart';
import 'package:untitled/layout/Home_Layout/screens/pagePepol/pagePepol.dart';
import 'package:untitled/layout/Home_Layout/screens/postnew.dart';
import 'package:untitled/layout/Home_Layout/screens/publicPosts/publicPosts.dart';

import '../../Components/components.dart';
import '../../Modules/LoginScreen/Login.dart';
import '../../models/usersModel.dart';
import '../../shared/Cubit/AppCubit/cubit.dart';
import '../../shared/Cubit/AppCubit/state.dart';
import '../../shared/locale/SharedPrefrences/CacheHelper.dart';
import '../../shared/locale/color/color.dart';
import '../Profile/editProfile/edit.dart';

class HomeLayout extends StatefulWidget {
  HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> with TickerProviderStateMixin {
  colors color = colors();
  TabController? tabController;
  @override
  void initState() {
    tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return socialCubit()
          ..currentUid = FirebaseAuth.instance.currentUser!.uid
          ..getUserData()
          ..getUsers()
          ..getPostData()
          ..getPublicPostData();
      },
      child: BlocConsumer<socialCubit, socialStates>(listener: (context, state) {
        if (state is socialCommentPostSuccessState) {
          toastStyle(context: context, massege: "تم اضافة التعليق بنجاح", colortoast: Colors.green);
        }
        if (state is socialUploadProfileCoverSuccessState ||
            state is socialUploadProfileImageSuccessState) {
          socialCubit.get(context).profileimage = null;
          socialCubit.get(context).coverImage = null;
          Navigator.of(context).pop();
          toastStyle(context: context, massege: "تم تحديث الصورة بنجاح", colortoast: Colors.green);
        }
        if (state is socialUploadProfileCoverSuccessState) {
          Navigator.of(context).pop();
          toastStyle(context: context, massege: "تم تحديث الصورة بنجاح", colortoast: Colors.green);
        }
      }, builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: ConditionalBuilder(
            condition: socialCubit.get(context).model != null,
            fallback: (context) => Scaffold(
              appBar: AppBar(),
              body: Center(
                child: LoadingAnimationWidget.prograssiveDots(
                  color: const Color(0xFF1A1A3F),
                  size: 50,
                ),
              ),
            ),
            builder: ((context) {
              var cubit = socialCubit.get(context);
              return Scaffold(
                appBar: AppBar(
                  title: Text("TESLAA"),
                  actions: [
                    IconButton(
                        onPressed: () {
                          navigtorPushClick(context, Postnew());
                        },
                        icon: Icon(Iconsax.additem)),
                    IconButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Chats()));
                        },
                        icon: Icon(CupertinoIcons.chat_bubble)),
                    IconButton(
                        onPressed: () {
                          showSearch(
                            context: context,
                            useRootNavigator: true,
                            delegate: SearchPage(
                              searchStyle: TextStyle(),
                              onQueryUpdate: print,
                              items: socialCubit.get(context).users,
                              searchLabel: 'البحث عن اشخاص',
                              suggestion: const Center(
                                child: Text('تصفية الاشخاص بحسب الاسم'),
                              ),
                              failure: const Center(
                                child: Text('لا يوجد احد بهذا السم :('),
                              ),
                              filter: (socialUsersModel? person) => [
                                person!.name!,
                              ],
                              builder: (socialUsersModel? person) => InkWell(
                                onTap: () {
                                  navigtorPushClick(
                                      context,
                                      PagePepol(
                                        model: person,
                                      ));
                                },
                                child: ListTile(
                                  title: Text(person!.name!),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(person.image!),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        icon: Icon(Iconsax.search_normal)),
                  ],
                  bottom: TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: [
                      Container(
                        child: Icon(Iconsax.home),
                        height: 50,
                      ),
                      Container(
                        child: Icon(Iconsax.personalcard),
                        height: 50,
                      )
                    ],
                    controller: tabController,
                  ),
                ),
                drawer: Drawer(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AppBar(
                          actions: [
                            IconButton(
                                onPressed: () {
                                  CacheHelper.clearData(key: "uId").then((value) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (context) => LoginScreen()),
                                        (Route<dynamic> route) => false);
                                  });
                                  uId = '';
                                },
                                icon: Icon(Iconsax.logout))
                          ],
                          leading: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.arrow_back)),
                          automaticallyImplyLeading: true,
                          title: Text(
                            "مرحباً ${cubit.model!.name}",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        BlocConsumer<socialCubit, socialStates>(
                            listener: (context, state) {},
                            builder: (context, state) {
                              return Column(
                                children: [
                                  buildProfile(
                                    context,
                                  ),
                                  buildFollowing(context),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        navigtorPushClick(context, editProfile());
                                      },
                                      child: Text("تعديل الملف الشخصي"),
                                    ),
                                  )
                                ],
                              );
                            }),
                        darkMode(),
                      ],
                    ),
                  ),
                ),
                body: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: TabBarView(controller: tabController, children: [
                        publicPostsScreen(),
                        Feeds(),
                      ]),
                    )
                  ],
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}
