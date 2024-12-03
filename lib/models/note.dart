class Note {
  String id;
  String userId;
  String title;
  String detail;
  Note(
      {required this.id,
      required this.userId,
      required this.title,
      required this.detail});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      title: json['title'],
      detail: json['detail'],
      id: json["id"],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'detail': detail,
      'id': id,
      'userId': userId,
    };
  }
}
