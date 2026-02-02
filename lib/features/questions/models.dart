class Question {
  final int id;
  final String userName;
  final String title;
  final String body;
  final int answersCount;
  final DateTime createdAt;
  final List<Answer> answers;

  const Question({
    required this.id,
    required this.userName,
    required this.title,
    required this.body,
    required this.answersCount,
    required this.createdAt,
    this.answers = const [],
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json['id'],
    userName: json['user_name'],
    title: json['title'],
    body: json['body'],
    answersCount: json['answers_count'] ?? 0,
    createdAt: DateTime.parse(json['created_at']),
    answers:
        (json['answers'] as List?)?.map((e) => Answer.fromJson(e)).toList() ??
        [],
  );
}

class Answer {
  final int id;
  final String userName;
  final String body;
  final DateTime createdAt;

  const Answer({
    required this.id,
    required this.userName,
    required this.body,
    required this.createdAt,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
    id: json['id'],
    userName: json['user_name'],
    body: json['body'],
    createdAt: DateTime.parse(json['created_at']),
  );
}
