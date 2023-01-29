import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';

import '../../../Components/components.dart';
import '../../../shared/Cubit/AppCubit/cubit.dart';
import '../../../shared/Cubit/AppCubit/state.dart';

class editProfile extends StatefulWidget {
  editProfile({Key? key}) : super(key: key);

  @override
  State<editProfile> createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  @override
  Widget build(BuildContext context) {
    final updateFormKey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController();
    TextEditingController bioController = TextEditingController();
    TextEditingController relationshipController = TextEditingController();
    TextEditingController educationController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController dateController = TextEditingController();

    return Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider.value(
          value: socialCubit()..getUserData(),
          child: BlocConsumer<socialCubit, socialStates>(
            listener: (context, state) {
              if (state is socialUpdateDataSuccessState) {
                toastStyle(
                    context: context, massege: "تم تحديث البيانات بنجاح", colortoast: Colors.blue);
              }
            },
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  titleSpacing: 0.0,
                  title: Text(
                    "تعديل الملف الشخصي",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                body: state is socialGetUserLoadingState
                    ? LinearProgressIndicator()
                    : Container(
                        padding: EdgeInsets.all(15),
                        child: SingleChildScrollView(
                          child: Form(
                            key: updateFormKey,
                            child: Builder(builder: (context) {
                              socialCubit cubit = socialCubit.get(context);
                              nameController.text = cubit.model!.name!;
                              bioController.text = cubit.model!.bio!;
                              relationshipController.text = cubit.model!.relationship!;
                              educationController.text = cubit.model!.education!;
                              phoneController.text = cubit.model!.phone!;
                              dateController.text = cubit.model!.date!;
                              return Column(
                                children: [
                                  editProfileForm(
                                      name: "الاسم",
                                      controller: nameController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'الرجاء ادخال الاسم';
                                        }
                                        return null;
                                      }),
                                  editProfileForm(
                                      name: "رقم الهاتف",
                                      controller: phoneController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'الرجاء ادخال رقم الهاتف';
                                        }
                                        return null;
                                      }),
                                  editProfileForm(
                                    name: "السيرة",
                                    controller: bioController,
                                  ),
                                  editProfileForm(
                                    name: "الحالة الاجتماعية",
                                    controller: relationshipController,
                                  ),
                                  Card(
                                    child: GestureDetector(
                                      onTap: () async {
                                        DateTime? selectedDate;
                                        final DateTime? picked = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1901, 1),
                                            lastDate: DateTime.now());

                                        selectedDate = picked;
                                        dateController.value = TextEditingValue(
                                            text:
                                                Jiffy("${picked}", "yyyy-MM-dd").yMMMMd.toString());
                                      },
                                      child: AbsorbPointer(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                          child: Row(
                                            children: [
                                              Text("تاريخ الميلاد"),
                                              Expanded(
                                                child: TextFormField(
                                                  controller: dateController,
                                                  keyboardType: TextInputType.datetime,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    suffixIcon: Icon(
                                                      Icons.date_range_rounded,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  editProfileForm(
                                    name: "التعليم",
                                    controller: educationController,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  state is socialUpdateDataLoadingState
                                      ? Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text("جاري تحديث البيانات"),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              CircularProgressIndicator(),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: MaterialButton(
                                                  color: Theme.of(context).primaryColor,
                                                  padding: EdgeInsets.all(10),
                                                  onPressed: () {
                                                    if (updateFormKey.currentState!.validate()) {
                                                      socialCubit.get(context).updateData(
                                                            name: nameController.text,
                                                            relationship:
                                                                relationshipController.text,
                                                            date: dateController.text,
                                                            education: educationController.text,
                                                            phone: phoneController.text,
                                                            bio: bioController.text,
                                                          );
                                                    }
                                                  },
                                                  child: Text(
                                                    "تحديث",
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Expanded(
                                                child: MaterialButton(
                                                  color: Colors.redAccent,
                                                  padding: EdgeInsets.all(10),
                                                  onPressed: () {
                                                    nameController.text = cubit.model!.name!;
                                                    bioController.text = cubit.model!.bio!;
                                                    relationshipController.text =
                                                        cubit.model!.relationship!;
                                                    educationController.text =
                                                        cubit.model!.education!;
                                                    phoneController.text = cubit.model!.phone!;
                                                    dateController.text = cubit.model!.date!;
                                                  },
                                                  child: Text(
                                                    "استعادة",
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
              );
            },
          ),
        ));
  }
}
