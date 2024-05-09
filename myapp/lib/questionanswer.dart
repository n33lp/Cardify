/// A class representing a question and its corresponding answer.
class QuestionAnswer {
  /// The question text.
  String question;

  /// The answer text.
  String answer;

  /// Constructs a new [QuestionAnswer] instance.
  ///
  /// Requires a [question] and an [answer] to be provided.
  QuestionAnswer({required this.question, required this.answer});

  /// Creates a new [QuestionAnswer] from a JSON object.
  ///
  /// Useful for serialization and deserialization with APIs.
  factory QuestionAnswer.fromJson(Map<String, dynamic> json) {
    return QuestionAnswer(
      question: json['question'],
      answer: json['answer'],
    );
  }

  /// Converts a [QuestionAnswer] instance to a JSON object.
  ///
  /// Useful for sending data to APIs or storing in databases.
  Map<String, dynamic> toJson() {
    return {
      'question': this.question,
      'answer': this.answer,
    };
  }

  /// A utility method for displaying a formatted question and answer.
  @override
  String toString() {
    return 'Q: $question\nA: $answer';
  }
}


// var qa1 = QuestionAnswer(question: "What is the capital of France?", answer: "Paris");