class Review {
  final int id;
  final String userName;
  final int rating;
  final String comment;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json['id'],
    userName: json['user_name'],
    rating: json['rating'],
    comment: json['comment'],
    createdAt: DateTime.parse(json['created_at']),
  );
}
