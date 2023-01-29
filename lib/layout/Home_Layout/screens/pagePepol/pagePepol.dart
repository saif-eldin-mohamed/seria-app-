import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../Components/components.dart';
import '../../../../models/usersModel.dart';
import '../../../../shared/Cubit/AppCubit/cubit.dart';
import '../../../../shared/Cubit/AppCubit/state.dart';
import '../chats/chatsScreen.dart';

class PagePepol extends StatelessWidget {
  PagePepol({Key? key, this.model}) : super(key: key);
  final socialUsersModel? model;
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: socialCubit(),
      child: BlocConsumer<socialCubit, socialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
                appBar: AppBar(),
                body: ConditionalBuilder(
                  condition: model != null,
                  fallback: ((context) => LinearProgressIndicator()),
                  builder: ((context) {
                    return Column(
                      children: [
                        Card(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 0,
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Container(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                height: 250,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: InkWell(
                                            onTap: () {
                                              buildImageView(context,
                                                  imageurl: "${model!.coverimage.toString()}");
                                            },
                                            child: Image(
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: 230,
                                                image: NetworkImage(
                                                    "${model!.coverimage.toString()}")),
                                          ),
                                        ),
                                      ],
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                      radius: 60,
                                      child: Stack(
                                        alignment: AlignmentDirectional.bottomStart,
                                        children: [
                                          SizedBox(
                                            height: 200,
                                            child: InkWell(
                                              onTap: () {
                                                buildImageView(context, imageurl: model!.image);
                                              },
                                              child: CircleAvatar(
                                                radius: 55,
                                                backgroundImage:
                                                    NetworkImage(model!.image.toString()),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                model!.name!,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                model!.bio!,
                                style: Theme.of(context).textTheme.caption,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (model!.education != '')
                                              Column(
                                                children: [
                                                  buildProfileInfo(
                                                      iconData: Icons.leaderboard_rounded,
                                                      text: model!.education),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            if (model!.date != '')
                                              Column(
                                                children: [
                                                  buildProfileInfo(
                                                    iconData: Icons.date_range,
                                                    text: "${model!.date}",
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            if (model!.relationship != '')
                                              Column(
                                                children: [
                                                  buildProfileInfo(
                                                      iconData: Iconsax.chart1,
                                                      text: model!.relationship),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            buildProfileInfo(
                                                iconData: Iconsax.chart1,
                                                text: "انضم في ${model!.joinedis}"),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            buildProfileInfo(
                                                iconData: Iconsax.mobile, text: " ${model!.phone}"),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => ChatsTakes(
                                            model: model!,
                                          ))));
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Iconsax.message1),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("مراسلة"),
                              ],
                            ))
                      ],
                    );
                  }),
                )),
          );
        },
      ),
    );
  }
}
