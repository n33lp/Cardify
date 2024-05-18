class QuestionAnswer {
  String question;

  String answer;

  QuestionAnswer({required this.question, required this.answer});

  factory QuestionAnswer.fromJson(Map<String, dynamic> json) {
    return QuestionAnswer(
      question: json['question'],
      answer: json['answer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
    };
  }

  @override
  String toString() {
    return 'Q: $question\nA: $answer';
  }
}
