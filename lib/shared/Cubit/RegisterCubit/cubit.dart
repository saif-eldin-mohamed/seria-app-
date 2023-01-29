// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/shared/Cubit/RegisterCubit/states.dart';

import '../../../Components/components.dart';
import '../../../models/usersModel.dart';



class socialRegisterCubit extends Cubit<socialRegisterState> {
  socialRegisterCubit() : super(socialRegisterInitialState());
  static socialRegisterCubit get(context) => BlocProvider.of(context);

  void userRegister(
      {required String name,
      required String email,
      required String phone,
      required String password,
      required context}) async {
    emit(socialRegisterLoadingState());

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      userCreate(
        email: email,
        name: name,
        phone: phone,
        uId: value.user!.uid.toString(),
      );
    }).catchError((onError) {
      if (onError.toString() ==
          '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
        toastStyle(context: context, massege: "هذا البريد الالكتروني مسجل من قبل");
      }
      emit(socialRegisterErorrState(onError));
    });
  }

  void userCreate({
    required String? name,
    required String? email,
    required String? phone,
    required String? uId,
  }) {
    socialUsersModel? model = socialUsersModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      isEmailVerified: false,
      joinedis: DateTime.now().year.toString(),
      coverimage:
          'https://png.pngtree.com/background/20210709/original/pngtree-pure-watercolor-gradient-colorful-background-picture-image_964413.jpg',
      image:
          'https://png.pngtree.com/png-clipart/20190619/original/pngtree-profile-line-black-icon-png-image_4008155.jpg',
      bio: '',
      education: '',
      relationship: '',
      date: '',
    );
    FirebaseFirestore.instance.collection('users').doc(uId).set(model.toMap()).then((value) {
      emit(socialCreateUserSuccessState());
    }).catchError((onError) {
      emit(socialCreateUserErorrState(onError));
      print(onError.toString());
    });
  }

  bool PasswordVisibility = true;
  IconData? suffixicon = Icons.visibility_off_rounded;
  void ispassword() {
    PasswordVisibility = !PasswordVisibility;
    if (PasswordVisibility == true) {
      suffixicon = Icons.visibility_off_rounded;
    } else {
      suffixicon = Icons.visibility;
    }

    emit(socialRegisterChangeOserctorAndIconState());
  }

  Future forgotPassword(String? email, context) async {
    emit(socialrestPasswordLoadingState());
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email!);
      toastStyle(
          context: context,
          massege: "تم ارسال رابط تغيير كلمة المرور الخاصة بك الي  ${email}",
          colortoast: Colors.blue);
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.toString() ==
          '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.') {
        toastStyle(
            context: context,
            massege: "هذا البريد الالكتروني غير مسجل لدينا",
            colortoast: Colors.amber[900]);
      } else if (e.toString() ==
          '[firebase_auth/invalid-email] The email address is badly formatted.') {
        toastStyle(
            context: context,
            massege: "صيغة البريد الالكتروني هذه غير صحيحة",
            colortoast: Colors.red);
      } else if (e.toString() ==
              '[firebase_auth/network-request-failed] A network error (such as timeout, interrupted connection or unreachable host) has occurred.' ||
          e.toString() ==
              '[firebase_auth/unknown] com.google.firebase.FirebaseException: An internal error has occurred. [ Connection closed by peer ]') {
        toastStyle(context: context, massege: "تأكد من اتصال الانترنت ", colortoast: Colors.red);
      }
    }
  }
}
