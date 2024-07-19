class Payment {
  String? courseTitle;
  String? courseId;
  int? coursePrice;
  String? checkImageUri;
  String? authorId;

  Payment({
    this.courseTitle,
    this.courseId,
    this.coursePrice,
    this.checkImageUri,
    this.authorId,
  });

  Map<String, dynamic> toMap() {
    return {
      'courseTitle': courseTitle,
      'courseId': courseId,
      'coursePrice': coursePrice,
      'checkImageUri': checkImageUri,
      'authorId': authorId,
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      courseTitle: map['courseTitle'],
      courseId: map['courseId'],
      coursePrice: map['coursePrice'],
      checkImageUri: map['checkImageUri'],
      authorId: map['authorId'],
    );
  }
}
