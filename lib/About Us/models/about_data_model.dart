class AboutDataModel {
  final Map<String, dynamic> mainData;
  final List<ValueItem> values;

  AboutDataModel({
    required this.mainData,
    required this.values,
  });

  // Fallback data when Firebase fetch fails
  factory AboutDataModel.fallback() {
    return AboutDataModel(
      mainData: {
        'heroTitle': 'About IEEE PUA',
        'heroSubtitle': 'ADDRESSING GLOBAL CHALLENGES',
        'heroHighlight': 'Advancing Technology for the Benefit of Humanity',
        'missionTitle': 'Our Mission',
        'missionParagraph1': 'IEEE PUA Student Branch (SB) at Pharos University in Alexandria was established in 2014...',
        'missionParagraph2': 'We provide our members with comprehensive development...',
        'communityStatement': 'IEEE PUA SB represents more than just a student organization...',
        'whatWeDoTitle': 'What We Do',
        'empowermentTitle': 'We empower engineering students',
        'empowermentText': 'Through IEEE-led workshops, hands-on projects...',
        'valuesTitle': 'Our Values',
        'videoTitle': 'IEEE PUA Student Branch',
        'watchVideoText': 'Watch IEEE PUA Student Branch Video',
        'videoLink': 'https://www.youtube.com/@ieeepuasb3956', // New field for video link
      },
      values: [
        ValueItem(
          icon: 'people',
          title: 'Collaboration',
          description: 'Working together across IEEE disciplines to achieve common technological goals',
        ),
        ValueItem(
          icon: 'lightbulb',
          title: 'Innovation',
          description: 'Constantly seeking creative solutions to engineering challenges through IEEE resources',
        ),
        ValueItem(
          icon: 'trending_up',
          title: 'Excellence',
          description: 'Striving for the highest IEEE standards in all our technical endeavors',
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
  String get videoTitle => mainData['videoTitle'] ?? 'IEEE PUA Student Branch';
  String get watchVideoText => mainData['watchVideoText'] ?? 'Watch IEEE PUA Student Branch Video';
  String get videoLink => mainData['videoLink'] ?? 'https://www.youtube.com/@ieeepuasb3956'; // New getter for video link
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