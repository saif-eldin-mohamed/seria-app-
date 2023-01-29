import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:untitled/shared/Cubit/AppCubit/cubit.dart';
import 'package:untitled/shared/Cubit/SettingCubit/cubit.dart';
import 'package:untitled/shared/Cubit/SettingCubit/state.dart';
import 'package:untitled/shared/locale/SharedPrefrences/CacheHelper.dart';
import 'package:untitled/shared/locale/blocObserver/blocObserver.dart';

import 'Components/components.dart';
import 'Modules/LoginScreen/Login.dart';
import 'layout/Home_Layout/home.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await Firebase.initializeApp(
    // Replace with actual values
    // options: FirebaseOptions(
    //   apiKey: "AIzaSyAaaptUKMt1xnyecbVetsqp3MhgCE74gCk",
    //   appId: "1:31298725941:android:de04892eba691d6dbfa97c",
    //   messagingSenderId: "31298725941",
    //   projectId: "sochial-website",
    // ),
  );
  HttpOverrides.global = MyHttpOverrides();
  bool? darkMode = CacheHelper.GetSaveData(key: 'DarkMode');
  uId = CacheHelper.GetSaveData(key: 'uId');
  Widget? widget;
  Bloc.observer = MyBlocObserver();
  if (uId != null) {
    widget = HomeLayout();
  } else {
    widget = LoginScreen();
  }
  runApp(Main(darkMode ?? false, widget));
}

class Main extends StatelessWidget {
  final Widget startWidget;
  final bool darkMode;
  const Main(this.darkMode, this.startWidget, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SettingCubit()..toggleTheme(DarkShared: darkMode),
        ),
        BlocProvider(
            create: (context) => socialCubit()..currentUid = FirebaseAuth.instance.currentUser!.uid)
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocBuilder<SettingCubit, SettingStates>(
          builder: (context, state) => MaterialApp(
            title: "Social App",
            themeMode: SettingCubit.get(context).DarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData.light(
              useMaterial3: true,
            ).copyWith(
              cardTheme: CardTheme(color: Color.fromARGB(255, 200, 216, 224)),
              tabBarTheme: const TabBarTheme(
                labelColor: Color.fromARGB(255, 0, 0, 0),
                labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)), // color for text
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.blue,
              ),
              textTheme: ThemeData.light().textTheme.apply(
                    fontFamily: "Cairo",
                  ),
            ),
            darkTheme: ThemeData.dark(
              useMaterial3: true,
            ).copyWith(
              tabBarTheme: const TabBarTheme(
                labelColor: Color.fromARGB(255, 255, 255, 255),
                labelStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)), // color for text
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.teal,
              ),
              textTheme: ThemeData.dark().textTheme.apply(
                    fontFamily: "Cairo",
                  ),
            ),
            home: Directionality(textDirection: TextDirection.rtl, child: startWidget),
            debugShowCheckedModeBanner: false,
          ),
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
