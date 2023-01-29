import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jiffy/jiffy.dart';

import '../../Components/components.dart';
import '../../layout/Home_Layout/home.dart';
import '../../shared/Cubit/RegisterCubit/cubit.dart';
import '../../shared/Cubit/RegisterCubit/states.dart';
import '../LoginScreen/Login.dart';

class Register extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController educController = TextEditingController();
  TextEditingController relController = TextEditingController();
  Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formkey = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => socialRegisterCubit(),
      child: BlocConsumer<socialRegisterCubit, socialRegisterState>(
        listener: (context, state) {
          if (state is socialCreateUserSuccessState) {
            toastStyle(context: context, massege: "تم انشاء حساب بنجاح", colortoast: Colors.blue);
            navigtorPushClick(context, LoginScreen());
          }
        },
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                title: Text("انشاء حساب جديد"),
              ),
              body: Container(
                margin: EdgeInsetsDirectional.all(20),
                child: Form(
                  key: formkey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            "lib/assets/Image/RegisterScreen/register.png",
                            height: 150,
                          ),
                        ),
                        Text("أنشاء حساب"),
                        textFormFiledDefult(
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "أدخل الاسم ";
                            }
                            return null;
                          },
                          FormFielController: nameController,
                          ispassword: false,
                          prefixicon: Icon(Icons.perm_identity),
                          HintText: "الاسم بالكامل",
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        textFormFiledDefult(
                            validate: (value) {
                              if (value!.isEmpty) {
                                return "أدخل البريد الالكتروني ";
                              }
                              return null;
                            },
                            FormFielController: emailController,
                            ispassword: false,
                            prefixicon: Icon(Icons.alternate_email_outlined),
                            HintText: "البريد الالكتروني"),
                        SizedBox(
                          height: 15,
                        ),
                        textFormFiledDefult(
                            validate: (value) {
                              if (value!.isEmpty) {
                                return "أدخل رقم الهاتف ";
                              }
                              return null;
                            },
                            FormFielController: phoneController,
                            ispassword: false,
                            prefixicon: Icon(Icons.phone),
                            HintText: "رقم الهاتف"),
                        SizedBox(
                          height: 15,
                        ),
                        textFormFiledDefult(
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "أدخل رقم كلمة المرور ";
                            }
                            return null;
                          },
                          FormFielController: passwordController,
                          ispassword: socialRegisterCubit.get(context).PasswordVisibility,
                          prefixicon: Icon(Icons.lock_outline_rounded),
                          suffixIcon: MaterialButton(
                            minWidth: 0,
                            height: 0,
                            focusElevation: 10,
                            onPressed: () {
                              socialRegisterCubit.get(context).ispassword();
                            },
                            child: Icon(socialRegisterCubit.get(context).suffixicon),
                          ),
                          HintText: "كلمة المرور",
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text(maxLines: 1, "بالتسجيل أنت توافق على"),

                            TextButton(
                              onPressed: () {},
                              child: Text(
                                maxLines: 1,
                                "سياسة الخصوصية والشروط",
                                style: TextStyle(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ConditionalBuilder(
                          builder: (context) => materialButtonClick(
                              textbtn: "تسجيل",
                              clickbtn: () async {
                                if (formkey.currentState!.validate()) {
                                  socialRegisterCubit.get(context).userRegister(
                                      name: nameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      phone: phoneController.text,
                                      context: context);
                                }
                              }),
                          fallback: ((context) => Center(child: CircularProgressIndicator())),
                          condition: state is! socialRegisterLoadingState,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(" لديك حساب بالفعل ؟"),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("تسجيل الدخول"))
                          ],
                        )
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
