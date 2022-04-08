class TestModel {
  dynamic title, id;
  dynamic version, category;
  dynamic passingMarks;
  List<dynamic> questions;

  TestModel(
      {this.questions,
      this.title,
      this.version,
      this.category,
      this.passingMarks});

  factory TestModel.fromJson(map) => TestModel(
      questions: map['questions'],
      title: map['title'],
      category: map['category'],
      version: map['version'],
      passingMarks: map['passingMarks']);

  Map<String, dynamic> toJson() => {
        'questions': questions,
        'title': title,
        'category': category,
        'version': version,
        'passingMarks': passingMarks
      };
}
