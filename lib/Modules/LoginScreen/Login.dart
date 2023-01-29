import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../../Components/components.dart';
import '../../layout/Home_Layout/home.dart';
import '../../shared/Cubit/LoginCubit/cubit.dart';
import '../../shared/Cubit/LoginCubit/states.dart';
import '../../shared/Cubit/SettingCubit/cubit.dart';
import '../../shared/http.dart';
import '../../shared/locale/SharedPrefrences/CacheHelper.dart';
import '../../shared/locale/color/color.dart';
import '../RegisterScreen/Register.dart';
import '../forgotPassword/forgotPassword.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  colors color = colors();
  @override
  Widget build(BuildContext context) {
    TextEditingController EmailController = TextEditingController();
    TextEditingController PasswordController = TextEditingController();
    var formkey = GlobalKey<FormState>();
    return BlocProvider(
      create: ((context) => socialLoginCubit()),
      child: BlocConsumer<socialLoginCubit, socialLoginState>(
        listener: (context, state) {
          if (state is socialLoginSuccessState) {
            CacheHelper.saveData(
                    key: 'uId', value: FirebaseAuth.instance.currentUser!.uid.toString())
                .then((value) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomeLayout()),
                  (Route<dynamic> route) => false);
            });
            toastStyle(
                context: context, massege: "تم تسجيل الدخول بنجاح", colortoast: color.colorsgreen);
          }
          if (state is socialLoginErorrState) {
            toastStyle(
                context: context,
                massege: "خطأ في اسم المستخدم او كلمة المرور",
                colortoast: color.colorsred);
          }
        },
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              drawer: Drawer(
                child: Container(
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
                              })
                        ],
                      )
                    ],
                  ),
                ),
              ),
              appBar: AppBar(
                actions: [],
              ),
              body: Container(
                margin: const EdgeInsetsDirectional.all(20),
                child: SingleChildScrollView(
                  child: Form(
                    key: formkey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            "lib/assets/Image/LoginScreen/login.png",
                            height: 200,
                          ),
                        ),
                        const Text(
                          "تسجيل الدخول",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        textFormFiledDefult(
                          paddingcontainer: const EdgeInsets.symmetric(vertical: 10),
                          ispassword: false,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "أدخل البريد الالكتروني";
                            }
                            return null;
                          },
                          FormFielController: EmailController,
                          HintText: "البريد الالكتروني",
                          prefixicon: const Icon(Icons.alternate_email_outlined),
                          typekeyboard: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        textFormFiledDefult(
                            ispassword: socialLoginCubit.get(context).PasswordVisibility,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return "أدخل كلمة المرور";
                              }
                              return null;
                            },
                            FormFielController: PasswordController,
                            prefixicon: const Icon(Icons.lock_outline_rounded),
                            HintText: "كلمة المرور",
                            suffixIcon: MaterialButton(
                              minWidth: 0,
                              height: 0,
                              focusElevation: 10,
                              onPressed: () {
                                socialLoginCubit.get(context).ispassword();
                              },
                              child: Icon(
                                socialLoginCubit.get(context).suffixicon,
                              ),
                            ),
                            typekeyboard: TextInputType.text),
                        const SizedBox(
                          height: 15,
                        ),
                        TextButton(
                          onPressed: () {
                            navigtorPushClick(context, ForgotPassword());
                          },
                          child: const Text(
                            "نسيت كلمة المرور?",
                            style: TextStyle(),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ConditionalBuilder(
                          builder: (context) => materialButtonClick(
                              textbtn: "دخول",
                              clickbtn: () async {
                                if (formkey.currentState!.validate()) {
                                  socialLoginCubit.get(context).userLogin(
                                        email: EmailController.text,
                                        password: PasswordController.text,
                                      );
                                }
                              }),
                          fallback: ((context) => const Center(child: CircularProgressIndicator())),
                          condition: state is! socialLoginLoadingState,
                        ),
                        Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            child: const Center(
                              child: Text(
                                "او ",
                                textAlign: TextAlign.center,
                              ),
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("مستخدم جديد ؟"),
                            TextButton(
                                onPressed: () {
                                  navigtorPushClick(context, Register());
                                },
                                child: const Text("أنشاء حساب"))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
