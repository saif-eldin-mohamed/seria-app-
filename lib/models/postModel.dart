import '../Components/components.dart';

class postModel {
  String? postId;
  String? image;
  String? uId;
  String? date;
  String? text;
  String? name;
  String? postImage;
  dynamic likes;

  postModel(
      {this.postId,
      this.image,
      this.uId,
      this.date,
      this.text,
      this.name,
      this.postImage,
      this.likes});

  postModel.fromJson(Map<String, dynamic> json) {
    postId = json['postId'];
    image = json['image'];
    uId = json['uId'];
    date = json['date'];
    text = json['text'];
    name = json['name'];
    postImage = json['postImage'];
    likes = json['Likes'] != null ? new Likes.fromJson(json['Likes']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postId'] = this.postId;
    data['image'] = this.image;
    data['uId'] = this.uId;
    data['date'] = this.date;
    data['text'] = this.text;
    data['name'] = this.name;
    data['postImage'] = this.postImage;
    if (this.likes != null) {
      data['Likes'] = this.likes!.toJson();
    }
    return data;
  }
}

class Likes {
  bool? uIda;

  Likes({this.uIda});

  Likes.fromJson(Map<String, dynamic> json) {
    uIda = json[uId];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[uId.toString()] = this.uIda;
    return data;
  }
}

class commentModel {
  String? comment;
  String? name;
  String? image;
  String? date;
  String? idComment;
  String? uId;
  commentModel({this.comment, this.name, this.image, this.date, this.idComment, this.uId});
  commentModel.fromJson(Map<String?, dynamic> json) {
    comment = json['comment'];
    name = json['name'];
    image = json['image'];
    date = json['date'];
    idComment = json['idComment'];
    uId = json['uId'];
  }
  Map<String, dynamic> toMap() {
    return {
      'comment': comment,
      'name': name,
      'image': image,
      'date': date,
      'idComment': idComment,
      'uId': uId,
    };
  }
}
