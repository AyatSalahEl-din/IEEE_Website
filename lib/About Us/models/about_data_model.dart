class AboutDataModel {
  final Map<String, dynamic> mainData;
  final List<ValueItem> values;

  AboutDataModel({
    required this.mainData,
    required this.values,
  });

  factory AboutDataModel.fallback() {
    return AboutDataModel(
      mainData: {
        'heroTitle': 'About IEEE PUA',
        'heroSubtitle': 'ADDRESSING GLOBAL CHALLENGES',
        'heroHighlight': 'Advancing Technology for the Benefit of Humanity',
        'missionTitle': 'Our Mission',
        'missionParagraph1': 'IEEE PUA Student Branch (SB)...',
        'missionParagraph2': 'We provide our members...',
        'communityStatement': 'IEEE PUA SB represents...',
        'whatWeDoTitle': 'What We Do',
        'empowermentTitle': 'We empower engineering students',
        'empowermentText': 'Through IEEE-led workshops...',
        'valuesTitle': 'Our Values',
      },
      values: [
        ValueItem(
          icon: 'people',
          title: 'Collaboration',
          description: 'Working together across IEEE...',
        ),
        ValueItem(
          icon: 'lightbulb',
          title: 'Innovation',
          description: 'Constantly seeking creative solutions...',
        ),
        ValueItem(
          icon: 'trending_up',
          title: 'Excellence',
          description: 'Striving for the highest standards...',
        ),
      ],
    );
  }

  String get heroTitle => mainData['heroTitle'] ?? 'About IEEE PUA';
  String get heroSubtitle => mainData['heroSubtitle'] ?? 'ADDRESSING GLOBAL CHALLENGES';
  String get heroHighlight => mainData['heroHighlight'] ?? 'Advancing Technology for the Benefit of Humanity';
  String get missionTitle => mainData['missionTitle'] ?? 'Our Mission';
  String get missionParagraph1 => mainData['missionParagraph1'] ?? '';
  String get missionParagraph2 => mainData['missionParagraph2'] ?? '';
  String get communityStatement => mainData['communityStatement'] ?? '';
  String get whatWeDoTitle => mainData['whatWeDoTitle'] ?? 'What We Do';
  String get empowermentTitle => mainData['empowermentTitle'] ?? '';
  String get empowermentText => mainData['empowermentText'] ?? '';
  String get valuesTitle => mainData['valuesTitle'] ?? 'Our Values';
}

class ValueItem {
  final String icon;
  final String title;
  final String description;

  ValueItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  factory ValueItem.fromMap(Map<String, dynamic> map) {
    return ValueItem(
      icon: map['icon'] ?? 'star',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
    );
  }
}
