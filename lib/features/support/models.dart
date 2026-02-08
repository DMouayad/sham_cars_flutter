class AppSupport {
  final String? contactPhone;
  final String? contactEmail;
  final String? contactAddress;
  final List<FaqItem> faq;

  AppSupport({
    required this.contactPhone,
    required this.contactEmail,
    required this.contactAddress,
    required this.faq,
  });

  factory AppSupport.fromJson(Map<String, dynamic> json) {
    return AppSupport(
      contactPhone: json['contact_phone'] as String?,
      contactEmail: json['contact_email'] as String?,
      contactAddress: json['contact_address'] as String?,
      faq: (json['faq'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(FaqItem.fromJson)
          .toList(),
    );
  }
}

class FaqItem {
  final String question;
  final String answer;

  FaqItem({required this.question, required this.answer});

  factory FaqItem.fromJson(Map<String, dynamic> json) {
    return FaqItem(
      question: (json['question'] as String?) ?? '',
      answer: (json['answer'] as String?) ?? '',
    );
  }
}
