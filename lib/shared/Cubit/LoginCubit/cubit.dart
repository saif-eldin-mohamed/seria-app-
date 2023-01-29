// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/shared/Cubit/LoginCubit/states.dart';

import '../AppCubit/cubit.dart';

class socialLoginCubit extends Cubit<socialLoginState> {
  socialLoginCubit() : super(socialLoginInitialState());
  static socialLoginCubit get(context) => BlocProvider.of(context);

  bool? isConnected;

  void userLogin({
    required String email,
    required String password,
  }) async {
    emit(socialLoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      emit(socialLoginSuccessState(uId: value.user!.uid));
    }).catchError((onError) {
      emit(socialLoginErorrState(onError.toString()));
    });
  }

  bool PasswordVisibility = true;
  IconData suffixicon = Icons.visibility_off_rounded;
  void ispassword() {
    PasswordVisibility = !PasswordVisibility;
    if (PasswordVisibility == true) {
      suffixicon = Icons.visibility_off_rounded;
    } else {
      suffixicon = Icons.visibility;
    }
    emit(socialLoginChangeOserctorAndIconState());
  }
}
