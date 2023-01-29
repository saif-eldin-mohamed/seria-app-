import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/shared/Cubit/SettingCubit/state.dart';

import '../../locale/SharedPrefrences/CacheHelper.dart';

class SettingCubit extends Cubit<SettingStates> {
  SettingCubit() : super(IntitialSettingCubit());
  static SettingCubit get(context) => BlocProvider.of(context);

  bool DarkMode = true;
  void toggleTheme({bool? DarkShared}) {
    if (DarkShared != null) {
      DarkMode = DarkShared;
      emit(DarkModeState());
    } else {
      DarkMode = !DarkMode;
      CacheHelper.saveData(key: 'DarkMode', value: DarkMode).then((value) {
        emit(DarkModeState());
      });
    }
  }
  /* dynamic updateState;
  void toggleTheme() {
    if (state.theme == ThemeData.light()) {
      updateState = SettingState(theme: ThemeData.dark());
      emit(updateState);
    } else {
      updateState = SettingState(theme: ThemeData.light());
      emit(updateState);
    }
    CacheHelper.saveData(key: 'isDark', value: updateState).then((value) {
      print(value);
    });
  }*/

  // SettingCubit() : super(InititalsocialAppStates());
  //static socialCubit get(context) => BlocProvider.of(context);

}
