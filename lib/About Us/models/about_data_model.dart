class AboutDataModel {
  final Map<String, dynamic> mainData;
  final List<ValueItem> values;
  final String videoUrl;

  AboutDataModel({
    required this.mainData,
    required this.values,
    required this.videoUrl,
  });

  // Fallback data when Firebase fetch fails
  factory AboutDataModel.fallback() {
    return AboutDataModel(
      mainData: {
        'heroTitle': 'About IEEE PUA',
        'heroSubtitle': 'ADDRESSING GLOBAL CHALLENGES',
        'heroHighlight': 'Advancing Technology for the Benefit of Humanity',
        'missionTitle': 'Our Mission',
        'missionParagraph1': 'IEEE PUA Student Branch (SB) at Pharos University in Alexandria was established in 2014 as a premier platform for aspiring engineers, innovators, and technology enthusiasts. Our core mission is to bridge the gap between academic knowledge and industry requirements, creating an environment where technical skills, creative thinking, and leadership capabilities can flourish.',
        'missionParagraph2': 'We provide our members with comprehensive development through technical workshops, professional events, and hands-on project experiences. Our specialized committees span diverse technical domains including Artificial Intelligence, Data Science, Cybersecurity, and Robotics, offering targeted training programs and collaborative opportunities that translate theoretical concepts into practical applications.',
        'communityStatement': 'IEEE PUA SB represents more than just a student organization—it embodies a community of future tech leaders committed to innovation, professional excellence, and positive societal impact. Our members collaborate across disciplines to develop solutions for real-world challenges, gaining invaluable experience that prepares them for successful careers.',
        'whatWeDoTitle': 'What We Do',
        'empowermentTitle': 'We empower engineering students',
        'empowermentText': 'Through IEEE-led workshops, hands-on projects, and mentorship programs, we help students develop practical skills that complement their academic education in electrical and electronic engineering.',
        'valuesTitle': 'Our Values',
        'videoTitle': 'IEEE PUA Student Branch',
        'watchVideoText': 'Watch IEEE Video',
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
      videoUrl: 'assets/video/IEEE_Video.mp4',
    );
  }

  String get heroTitle => mainData['heroTitle'] ?? 'About IEEE PUA';
  String get heroSubtitle => mainData['heroSubtitle'] ?? 'ADDRESSING GLOBAL CHALLENGES';
  String get heroHighlight => mainData['heroHighlight'] ?? 'Advancing Technology for the Benefit of Humanity';
  String get missionTitle => mainData['missionTitle'] ?? 'Our Mission';
  String get missionParagraph1 => mainData['missionParagraph1'] ?? 'IEEE PUA Student Branch (SB) at Pharos University in Alexandria was established in 2014...';
  String get missionParagraph2 => mainData['missionParagraph2'] ?? 'We provide our members with comprehensive development...';
  String get communityStatement => mainData['communityStatement'] ?? 'IEEE PUA SB represents more than just a student organization...';
  String get whatWeDoTitle => mainData['whatWeDoTitle'] ?? 'What We Do';
  String get empowermentTitle => mainData['empowermentTitle'] ?? 'We empower engineering students';
  String get empowermentText => mainData['empowermentText'] ?? 'Through IEEE-led workshops, hands-on projects...';
  String get valuesTitle => mainData['valuesTitle'] ?? 'Our Values';
  String get videoTitle => mainData['videoTitle'] ?? 'IEEE PUA Student Branch';
  String get watchVideoText => mainData['watchVideoText'] ?? 'Watch IEEE Video';
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