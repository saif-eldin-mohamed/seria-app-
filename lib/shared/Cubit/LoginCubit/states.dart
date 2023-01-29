abstract class socialLoginState {}

class socialLoginInitialState extends socialLoginState {}

class socialLoginLoadingState extends socialLoginState {}

class socialLoginSuccessState extends socialLoginState {
  final String? uId;
  socialLoginSuccessState({this.uId});
}

class socialLoginErorrState extends socialLoginState {
  final String? Erorr;
  socialLoginErorrState(this.Erorr);
}

class socialLoginChangeOserctorAndIconState extends socialLoginState {}
