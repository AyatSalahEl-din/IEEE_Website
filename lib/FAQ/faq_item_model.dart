class FAQItemModel {
  final String question;
  final String answer;
  bool isExpanded;

  FAQItemModel({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });

  factory FAQItemModel.fromFirestore(Map<String, dynamic> data) {
    // Look for both "question" and "question " (with space)
    String question = data['question']?.toString() ??
        data['question ']?.toString() ??
        'No question available';

    // Look for both "answer" and "answer " (with space)
    String answer = data['answer']?.toString() ??
        data['answer ']?.toString() ??
        'No answer available';

    return FAQItemModel(
      question: question,
      answer: answer,
      isExpanded: (data['isExpanded'] is bool) ? data['isExpanded'] : false,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
      'isExpanded': isExpanded,
    };
  }
}

