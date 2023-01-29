import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/Cubit/RegisterCubit/cubit.dart';
import '../../shared/Cubit/RegisterCubit/states.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    return BlocProvider(
      create: (context) => socialRegisterCubit(),
      child: BlocConsumer<socialRegisterCubit, socialRegisterState>(
          listener: (context, state) {},
          builder: ((context, state) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                  appBar: AppBar(
                    title: Text("استعادة كلمة المرور"),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(children: [
                      Image(
                        height: 200,
                        image: AssetImage('lib/assets/Image/forgotPass/6321600.png'),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                          "استعادة كلمة المرور عن طريق البريد الالكتروني المسجل في قاعدة البيانات"),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), hintText: "البريد الالكتروني"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "رجاء قم بإدخال البريد الالكتروني ";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            socialRegisterCubit
                                .get(context)
                                .forgotPassword(emailController.text, context);
                          },
                          child: Text("ارسال"))
                    ]),
                  )),
            );
          })),
    );
  }
}
