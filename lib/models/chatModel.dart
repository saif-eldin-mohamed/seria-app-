class MessgeModel {
  String? senderId;
  String? reciverId;
  String? dateTime;
  String? text;
  String? image;
  String? dateditels;
  MessgeModel({
    this.senderId,
    this.reciverId,
    this.dateTime,
    this.text,
    this.image,
    this.dateditels,
  });
  MessgeModel.fromJson(Map<String?, dynamic> json) {
    senderId = json['senderId'];
    reciverId = json['reciverId'];
    dateTime = json['dateTime'];
    text = json['text'];
    image = json['image'];
    dateditels = json['dateditels'];
  }
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'reciverId': reciverId,
      'dateTime': dateTime,
      'text': text,
      'image': image,
      'dateditels': dateditels,
    };
  }
}
