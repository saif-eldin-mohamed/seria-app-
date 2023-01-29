abstract class socialRegisterState {}

class socialRegisterInitialState extends socialRegisterState {}

class socialRegisterLoadingState extends socialRegisterState {}

class socialRegisterSuccessState extends socialRegisterState {}

class socialRegisterErorrState extends socialRegisterState {
  final Erorr;
  socialRegisterErorrState(this.Erorr);
}

class socialCreateUserSuccessState extends socialRegisterState {}

class socialCreateUserErorrState extends socialRegisterState {
  final Erorr;
  socialCreateUserErorrState(this.Erorr);
}

class socialRegisterChangeOserctorAndIconState extends socialRegisterState {}

class socialRegisterCheckInternet extends socialRegisterState {}

class socialrestPasswordLoadingState extends socialRegisterState {}

class socialrestPasswordSuccessState extends socialRegisterState {}

class socialrestPasswordErorrState extends socialRegisterState {
  final Erorr;
  socialrestPasswordErorrState(this.Erorr);
}
