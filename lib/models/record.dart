class RecordModel {
  int attempts, score, questions, passingMarks;
  String testTitle, testCategory, version;
  RecordModel(
      {this.attempts,
      this.score,
      this.questions,
      this.testCategory,
      this.testTitle,
      this.passingMarks,
      this.version});

  factory RecordModel.fromJson(map) => RecordModel(
      attempts: map['attempts'],
      score: map['score'],
      questions: map['questions'],
      testCategory: map['testCategory'],
      testTitle: map['testTitle'],
      passingMarks: map['passingMarks'],
      version: map['version']);

  Map<String, dynamic> toJson() => {
        'attempts': attempts,
        'score': score,
        'questions': questions,
        'passingMarks': passingMarks,
        'testCategory': testCategory,
        'testTitle': testTitle,
        'version': version
      };
}
