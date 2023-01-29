import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';


import '../../../../Components/components.dart';
import '../../../../models/usersModel.dart';
import '../../../../shared/Cubit/AppCubit/cubit.dart';
import '../../../../shared/Cubit/AppCubit/state.dart';
import 'chatsScreen.dart';

class Chats extends StatelessWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: socialCubit()..getUsers(),
      child: BlocConsumer<socialCubit, socialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                  appBar: AppBar(
                    title: Text("المستخدمين"),
                  ),
                  body: ConditionalBuilder(
                    condition: socialCubit.get(context).users.length > 0,
                    fallback: (context) => Center(child: CircularProgressIndicator()),
                    builder: (context) => ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return buildChatItem(socialCubit.get(context).users[index], context);
                        },
                        separatorBuilder: (context, index) {
                          return Container();
                        },
                        itemCount: socialCubit.get(context).users.length),
                  )),
            );
          }),
    );
  }
}

Widget buildChatItem(socialUsersModel model, context) {
  return Card(
      child: InkWell(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => ChatsTakes(
                    model: model,
                  ))));
    },
    child: Padding(
      padding: EdgeInsets.all(15),
      child: Row(children: [
        CircleAvatar(
          radius: 35,
          backgroundImage: NetworkImage('${model.image}'),
        ),
        SizedBox(
          width: 15,
        ),
        Text('${model.name}')
      ]),
    ),
  ));
}
