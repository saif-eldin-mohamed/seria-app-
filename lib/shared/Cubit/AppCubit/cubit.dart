import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:untitled/shared/Cubit/AppCubit/state.dart';


import '../../../Components/components.dart';
import '../../../layout/Home_Layout/screens/feeds/feeds.dart';
import '../../../layout/Home_Layout/screens/publicPosts/publicPosts.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../../models/chatModel.dart';
import '../../../models/postModel.dart';
import '../../../models/usersModel.dart';

// ignore: camel_case_types
class socialCubit extends Cubit<socialStates> {
  socialCubit() : super(socialInitialState());
  String? currentUid = FirebaseAuth.instance.currentUser!.uid;
  static socialCubit get(context) => BlocProvider.of(context);
  socialUsersModel? model;
  int? postsCount;
  Future getUserData() async {
    emit(socialGetUserLoadingState());

    // snapshots => realtime (upgrade on time )
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUid)
        .snapshots()
        .listen((event) {
      model = socialUsersModel.fromJson(event.data()!);
      emit(socialGetUserSuccessState());
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUid)
        .collection('posts')
        .snapshots()
        .listen((event) {
      postsCount = event.docs.length;
    });
  }

  socialUsersModel? personDetils;
  Future getPersonData(uId) async {
    emit(socialGetUserLoadingState());
    await FirebaseFirestore.instance.collection('users').doc(uId).get().then((event) {
      personDetils = socialUsersModel.fromJson(event.data()!);
      print(personDetils!.name);
      emit(socialGetUserSuccessState());
    });
  }

  List<DropdownMenuItem> dropItem = [
    DropdownMenuItem(
      child: Text('العامة'),
      value: 0,
    ),
    new DropdownMenuItem(
      child: Text('خاص'),
      value: 1,
    ),
  ];
  final items = ['خاص', 'عام'];
  String selectedValue = 'خاص';
  void changeDropItem(String newValue) {
    selectedValue = newValue;
    emit(socialChangedropdownState());
  }

  int currentIndex = 0;
  List<Widget> homeScreen = [
    Feeds(),
    publicPostsScreen(),
  ];
  void changeBottomNav(int? index) {
    currentIndex = index!;
    emit(socialChangebuttomNavState());
  }

  final picker = ImagePicker();
  /*---------------------------SelectProfileImage----------------------------*/
  File? profileimage;
  String? profileImageUrl;
  Future<void> getProfileImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profileimage = File(image.path);

      emit(socialProfileImagePickedSuccessState());
    } else {
      emit(socialProfileImagePickedErorrState());
    }
  }

  /*-------------------Upload ProfileImage And Get Url------------------------*/
  void uploadProfileImage() {
    emit(socialUploadProfileImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
          'users/$currentUid/ProfileImage/${Uri.file(
            profileimage!.path,
          ).pathSegments.last}',
        )
        .putFile(profileimage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUid)
            .update({'image': value}).then((value) {});
        getUserData();
        emit(socialUploadProfileImageSuccessState());
      }).catchError((onError) {
        emit(socialUploadProfileImageErorrState());
      });
    }).catchError((onError) {
      emit(socialUploadProfileImageErorrState());
    });
  }

  /*---------------------------SelectCoverImage-------------------------------*/
  File? coverImage;
  String? coverImageUrl;
  Future<void> getCoverImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      coverImage = File(image.path);
      emit(socialProfileCoverPickedSuccessState());
    } else {
      emit(socialProfileCoverPickedErorrState());
    }
  }

/*---------------------Upload CoverImage And Get Url--------------------------*/
  void uploadCoverImage() {
    emit(socialUploadProfileCoverLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${currentUid}/CoverImage/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        FirebaseFirestore.instance
            .collection("users")
            .doc(currentUid)
            .update({'coverimage': value}).then((value) {
          getUserData();
          emit(socialUploadProfileCoverSuccessState());
        }).catchError((onError) {});
      }).catchError((onError) {
        emit(socialUploadProfileCoverSuccessState());
      });
    }).catchError((onError) {
      emit(socialUploadProfileCoverErorrState());
    });
  }

/*---------------------Update DateUser--------------------------*/
  void updateData(
      {required String? name,
      required String? phone,
      required String? education,
      required String? relationship,
      required String? date,
      required String? bio}) {
    emit(socialUpdateDataLoadingState());
    FirebaseFirestore.instance.collection("users").doc(currentUid).update({
      "name": name,
      "phone": phone,
      "bio": bio,
      "education": education,
      "relationship": relationship,
      "date": date,
    }).then((value) {
      getUserData();
      emit(socialUpdateDataSuccessState());
    });
  }

/*---------------------Update DateUser--------------------------*/

  File? imagePost;
  String? imagePostUrl;
  Future<void> getImagePost() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imagePost = File(image.path);

      emit(socialImagePostPickedSuccessState());
    } else {
      emit(socialImagePostPickedErorrState());
    }
  }

  void deletePostImage() {
    imagePost = null;
    emit(socialDeletePostImageState());
  }

  void uploadPost({
    required String? text,
  }) {
    emit(socialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(imagePost!.path).pathSegments.last}')
        .putFile(imagePost!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createNewPost(
          text: text,
          postImage: value,
        );
      }).catchError((onError) {});
    }).catchError((onError) {});
  }

  void createNewPost({
    required String? text,
    String? postImage,
  }) {
    emit(socialCreatePostLoadingState());
    FirebaseFirestore.instance.collection("users").doc(currentUid).collection('posts').add({
      "name": model!.name,
      "image": model!.image,
      "uId": currentUid,
      "date": Jiffy().format("d MM yyyy, h:mm:ss a"),
      'datedetils': DateTime.now(),
      "text": text,
      "postId": "",
      'Likes': {"Likes": false},
      "postImage": postImage ?? '',
    }).then((value) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(currentUid)
          .collection('posts')
          .doc(value.id)
          .update({"postId": value.id});
      emit(socialCreatePostSuccessState());
    }).catchError((onError) {
      emit(socialCreatePostErorrState());
    });
  }

  void uploadPublicPost({
    required String? text,
  }) {
    emit(socialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(imagePost!.path).pathSegments.last}')
        .putFile(imagePost!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createNewPost(
          text: text,
          postImage: value,
        );
      }).catchError((onError) {});
    }).catchError((onError) {});
  }

  void createPublicNewPost({
    required String? text,
    String? postImage,
  }) {
    emit(socialCreatePostLoadingState());
    FirebaseFirestore.instance.collection('posts').add({
      "name": model!.name,
      "image": model!.image,
      "uId": currentUid,
      "date": Jiffy().format("d MM yyyy, h:mm:ss a"),
      'datedetils': DateTime.now(),
      "text": text,
      "postId": "",
      'Likes': {currentUid: false},
      "postImage": postImage ?? '',
    }).then((value) {
      FirebaseFirestore.instance.collection('posts').doc(value.id).update({"postId": value.id});
      emit(socialCreatePostSuccessState());
    }).catchError((onError) {
      emit(socialCreatePostErorrState());
    });
  }

  void deletePost(String? postId) {
    emit(socialDeletePostLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUid)
        .collection('posts')
        .doc(postId)
        .delete()
        .then((value) {
      emit(socialDeletePostSuccessState());
    }).catchError((onError) {
      emit(socialDeletePostErorrState());
    });
  }

  void deletePublicPost(String? postId) {
    emit(socialDeletePostLoadingState());
    FirebaseFirestore.instance.collection('posts').doc(postId).delete().then((value) {
      emit(socialDeletePostSuccessState());
    }).catchError((onError) {
      emit(socialDeletePostErorrState());
    });
  }

  void editPost(String? postId, {String? postImage, String? text}) {
    emit(socialUPdatePostLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUid)
        .collection('posts')
        .doc(postId)
        .update({'text': text, 'postImage': postImage ?? ''}).then((value) {
      emit(socialUPdatePostSuccessState());
    }).catchError((onError) {
      emit(socialUPdatePostErorrState());
    });
  }

  List posts = [];
  List Likes = [];

  void getPostData() {
    emit(socialGetPostsLoadingState());
    FirebaseFirestore.instance
        .collection("users")
        .doc(currentUid)
        .collection('posts')
        .orderBy('datedetils', descending: true)
        .snapshots()
        .listen((event) {
      posts = [];
      Likes = [];
      event.docs.forEach((element) {
        posts.add(postModel.fromJson(element.data()));
        Likes.add(element.data()['Likes']);
      });
      emit(socialGetPostsSuccessState());
    });
  }

  List<postModel> publicPosts = [];
  List PublicLikes = [];
  void getPublicPostData() {
    emit(socialGetPublicPostsLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('datedetils', descending: true)
        .snapshots()
        .listen((event) {
      publicPosts = [];
      PublicLikes = [];
      print(PublicLikes);
      event.docs.forEach((element) {
        publicPosts.add(postModel.fromJson(element.data()));
        PublicLikes.add(element.data()['Likes']);
      });
      emit(socialGetPublicPostsSuccessState());
    });
  }

  void likePost(String? postId, int index) {
    var postPathid = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUid)
        .collection('posts')
        .doc(postId);
    if (Likes[index][currentUid] == true) {
      postPathid.update({
        'Likes': {currentUid: false}
      }).then((value) {});
      postPathid.collection("likesCount").doc(currentUid).delete();
    } else {
      postPathid.update({
        'Likes': {currentUid: true}
      }).then((value) {});
      postPathid.collection("likesCount").doc(currentUid).set(
        {"${currentUid.toString()}": true},
      );
    }
  }

  void likePublicPost(String? postId, int index) {
    var postPathid = FirebaseFirestore.instance.collection('posts').doc(postId);
    if (PublicLikes[index][currentUid] == true) {
      postPathid.set({
        'Likes': {currentUid: false}
      }, SetOptions(merge: true)).then((value) {});
      postPathid.collection("likesCount").doc(currentUid).delete();
    } else {
      postPathid.set({
        'Likes': {currentUid: true}
      }, SetOptions(merge: true)).then((value) {});
      postPathid.collection("likesCount").doc(currentUid).set(
        {"${currentUid.toString()}": false},
      );
    }
  }

  void addCommentPublicPosts(
    String? postId, {
    String? comment,
    String? name,
    String? image,
  }) {
    print(image);
    FirebaseFirestore.instance.collection("posts").doc('${postId}').collection('comment').add({
      "name": name,
      "uId": currentUid,
      'comment': comment,
      'image': image,
      'dateDitels': DateTime.now(),
      'date': Jiffy().format("d MM yyyy, h:mm:ss a"),
    }).then((value) {
      emit(socialCommentPostSuccessState());
    }).catchError((onError) {
      emit(socialCommentPostErorrState(onError));
    });
  }

  List<commentModel> commentPublic = [];
  List idPublicComment = [];
  int? commentPublicCount = 0;
  int? likePublicCount = 0;
  void getCommentPublicPost(String? postid) {
    DocumentReference pathposts = FirebaseFirestore.instance.collection("posts").doc('${postid}');
    currentUid = FirebaseAuth.instance.currentUser!.uid;
    pathposts.collection('comment').orderBy('date', descending: true).snapshots().listen((event) {
      commentPublicCount;
      commentPublicCount = event.docs.length;
      idPublicComment = [];
      commentPublic = [];
      event.docs.forEach((element) {
        idPublicComment.add(element.id);
        commentPublic.add(commentModel.fromJson(element.data()));
      });
      emit(socialGetCommentPostSuccessState());
    });

    pathposts.collection('likesCount').snapshots().listen((event) {
      likePublicCount;
      likePublicCount = event.docs.length;
      emit(socialGetLikesPostSuccessState());
    });
  }

  void addCommentPost(String? postId, {String? comment, String? name, String? image}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUid)
        .collection("posts")
        .doc('${postId}')
        .collection('comment')
        .add({
      "name": name,
      "uId": currentUid,
      'comment': comment,
      'dateDitels': DateTime.now(),
      'image': image,
      'date': Jiffy().format("d MM yyyy, h:mm:ss a"),
    }).then((value) {
      emit(socialCommentPostSuccessState());
    }).catchError((onError) {
      emit(socialCommentPostErorrState(onError));
    });
  }

  List<commentModel> comment = [];
  List idComment = [];
  int? commentCount = 0;
  int? likeCount = 0;
  void getCommentPost(String? postid) {
    DocumentReference pathposts = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUid)
        .collection("posts")
        .doc('${postid}');
    currentUid = FirebaseAuth.instance.currentUser!.uid;
    pathposts
        .collection('comment')
        .orderBy('dateDitels', descending: true)
        .snapshots()
        .listen((event) {
      commentCount;

      commentCount = event.docs.length;
      idComment = [];
      comment = [];
      event.docs.forEach((element) {
        idComment.add(element.id);
        comment.add(commentModel.fromJson(element.data()));
      });
      emit(socialGetCommentPostSuccessState());
    });

    pathposts.collection('likesCount').snapshots().listen((event) {
      likeCount;
      likeCount = event.docs.length;
      emit(socialGetLikesPrivatePostSuccessState());
    });
  }

  void deleteComment({required String? commentId, required String? postId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUid)
        .collection('posts')
        .doc(postId)
        .collection('comment')
        .doc(commentId!)
        .delete();
  }

  void deletePublicComment({required String? commentId, required String? postId}) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comment')
        .doc(commentId!)
        .delete();
  }

  List<socialUsersModel> users = [];

  void getUsers() {
    emit(socialGetAllUsersLoadingState());
    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
      users = [];
      event.docs.forEach((element) {
        if (element.data()['uId'] != FirebaseAuth.instance.currentUser!.uid) {
          users.add(socialUsersModel.fromJson(element.data()));
        }
        emit(socialGetAllUsersSuccessState());
      });
    });
  }

  void sendMessage({
    required String reciverId,
    String? dateTime,
    String? imageUrl,
    required String text,
  }) {
    MessgeModel model = MessgeModel(
        senderId: currentUid,
        reciverId: reciverId,
        dateditels: DateTime.now().toString(),
        dateTime: Jiffy().format("d MM yyyy, h:mm:ss a"),
        text: text,
        image: imageUrl ?? '');
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUid)
        .collection('chats')
        .doc(reciverId)
        .collection("Messges")
        .add(model.toMap())
        .then((value) {
      emit(socialSendMessgeSuccessState());
    }).catchError((onError) {
      emit(socialSendMessgeErorrState());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(reciverId)
        .collection('chats')
        .doc(currentUid)
        .collection("Messges")
        .add(model.toMap())
        .then((value) {
      emit(socialSendMessgeSuccessState());
    }).catchError((onError) {
      emit(socialSendMessgeErorrState());
    });
  }

  void uploadImageMessage({
    required String reciverId,
    required String text,
  }) {
    emit(socialUploadImageMessageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('MessageImage/${currentUid}/${Uri.file(imagePost!.path).pathSegments.last}')
        .putFile(imagePost!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        sendMessage(
            reciverId: reciverId,
            text: text,
            imageUrl: value,
            dateTime: Jiffy().format("d MM yyyy, h:mm:ss a"));
        deletePostImage();
      });
    }).catchError((onError) {});
  }

  List<MessgeModel> messagesList = [];
  void getMessages({
    required String reciverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUid)
        .collection('chats')
        .doc(reciverId)
        .collection('Messges')
        .orderBy('dateTime', descending: false)
        .snapshots()
        .listen((event) {
      messagesList = [];
      event.docs.forEach((element) {
        print(element.data());
        messagesList.add(MessgeModel.fromJson(element.data()));
      });
      emit(socialGetMessgeSuccessState());
    });
  }
}
