class QuestionModel {
  dynamic question, correct, image, explanation;
  List<dynamic> options;

  QuestionModel(
      {this.question,
      this.options,
      this.explanation,
      this.correct,
      this.image});

  factory QuestionModel.fromJson(map) => QuestionModel(
        question: map['question'],
        explanation: map['explanation'],
        options: map['options'],
        correct: map['correct'],
        image: map['image'],
      );

  Map<String, dynamic> toJson() => {
        'question': question,
        'explanation': explanation,
        'options': options,
        'correct': correct,
        'image': image,
      };
}
