import 'package:sham_cars/features/community/models.dart';

class Question implements CommunityItem {
  @override
  final DateTime createdAt;
  final int id;
  final String userName;
  final String title;
  final String body;
  final int answersCount;
  final List<Answer> answers;
  final int? trimId;
  final int? modelId;
  final String? trimName;
  final String? modelName;
  final String? makeName;
  final String? trimImageUrl;
  final String? trimRange;

  const Question({
    required this.id,
    required this.userName,
    required this.title,
    required this.body,
    required this.answersCount,
    required this.createdAt,
    this.answers = const [],
    this.modelId,
    this.trimId,
    this.trimName,
    this.modelName,
    this.makeName,
    this.trimImageUrl,
    this.trimRange,
  });
  Question copyWith({String? userName}) {
    return Question(
      id: id,
      trimId: trimId,
      makeName: makeName,
      answers: answers,
      modelId: modelId,
      modelName: modelName,
      trimName: trimName,
      trimRange: trimRange,
      trimImageUrl: trimImageUrl,
      userName: userName ?? this.userName,
      title: title,
      body: body,
      answersCount: answersCount,
      createdAt: createdAt,
    );
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    final vehicle = json['vehicle'];
    return Question(
      id: json['id'],
      modelId: json['car_model_id'],
      trimId: json['car_trim_id'],
      modelName: json['model_name'],
      trimName: json['trim_name']?.toString(),
      userName: json['user_name']?.toString() ?? '',
      title: json['title'],
      body: json['body'],
      answersCount: json['answers_count'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      answers:
          (json['answers'] as List?)?.map((e) => Answer.fromJson(e)).toList() ??
          [],
      makeName: vehicle?['make_name'],
      trimImageUrl: vehicle?['image_url'],
      trimRange: vehicle?['range']?['display'],
    );
  }

  String? get trimFullName {
    if (makeName == null || modelName == null || trimName == null) {
      return null;
    }
    return '$makeName $modelName $trimName'.trim();
  }

  String? get trimDisplayName {
    if (modelName == null || trimName == null) {
      return null;
    }
    return '$modelName $trimName'.trim();
  }
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
