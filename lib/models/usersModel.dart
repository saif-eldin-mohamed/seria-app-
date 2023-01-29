class socialUsersModel {
  String? name;
  String? email;
  String? phone;
  String? uId;
  bool? isEmailVerified;
  String? image;
  String? coverimage;
  String? bio;
  String? relationship;
  String? education;
  String? date;
  String? joinedis;
  socialUsersModel({
    this.name,
    this.email,
    this.phone,
    this.uId,
    this.isEmailVerified,
    this.image,
    this.coverimage,
    this.bio,
    this.relationship,
    this.education,
    this.date,
    this.joinedis,
  });
  socialUsersModel.fromJson(Map<String?, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    uId = json['uId'];
    isEmailVerified = json['isEmailVerified'];
    image = json['image'];
    coverimage = json['coverimage'];
    bio = json['bio'];
    relationship = json['relationship'];
    education = json['education'];
    date = json['date'];
    joinedis = json['joinedis'];
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uId': uId,
      'isEmailVerified': isEmailVerified,
      'image': image,
      'coverimage': coverimage,
      'bio': bio,
      'education': education,
      'relationship': relationship,
      'date': date,
      'joinedis': joinedis,
    };
  }
}
