import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/widgets/team_member.dart';

class TeamMember {
  final String imagePath;
  final String name;
  final String jobTitle;

  TeamMember({
    required this.imagePath,
    required this.name,
    required this.jobTitle,
  });
}

class OurTeamSection extends StatelessWidget {
  final List<List<TeamMember>> teamGroups = [
    [
      TeamMember(
        imagePath: 'assets/images/hozaifa.png',
        name: "Hozaifa Mostafa",
        jobTitle: 'Chairman',
      ),
    ],
    [
      TeamMember(
        imagePath: 'assets/images/aosama.png',
        name: "Ahmed Osama",
        jobTitle: 'Vice',
      ),
      TeamMember(
        imagePath: 'assets/images/tarek.png',
        name: "Mohamed Tarek",
        jobTitle: 'Treasure',
      ),
    ],
    [
      TeamMember(
        imagePath: 'assets/images/hana.png',
        name: "Hana Amin",
        jobTitle: 'Head of HR',
      ),
      TeamMember(
        imagePath: 'assets/images/mariam.png',
        name: "Mariem Essam",
        jobTitle: 'Head of PR',
      ),
      TeamMember(
        imagePath: 'assets/images/zyad.png',
        name: "Zyad Elattar",
        jobTitle: 'Head of Publicity',
      ),
    ],
    [
      TeamMember(
        imagePath: 'assets/images/omani.png',
        name: "Mohamed Hossam",
        jobTitle: 'Head of Technical Section',
      ),
      TeamMember(
        imagePath: 'assets/images/hamshary.png',
        name: "Esraa Hamshary",
        jobTitle: 'Head of Robotics Committee',
      ),
      TeamMember(
        imagePath: 'assets/images/esmail.png',
        name: "Esmail Mohamed",
        jobTitle: 'Vice of Robotics Committee',
      ),
      TeamMember(
        imagePath: 'assets/images/marchelino.jpg',
        name: "Marchelino Joseph",
        jobTitle: 'Head of Security Committee',
      ),
    ],
    [
      TeamMember(
        imagePath: 'assets/images/ayat2.jpg',
        name: "Ayat SalahEldin",
        jobTitle: 'Head of Web Committee',
      ),
      TeamMember(
        imagePath: 'assets/images/nadia.jpg',
        name: "Nadia Hossny",
        jobTitle: 'Vice of Web Committee',
      ),
      TeamMember(
        imagePath: 'assets/images/menna.jpg',
        name: "Menna Allah Rabei",
        jobTitle: 'Web Developer',
      ),
      TeamMember(
        imagePath: 'assets/images/shahd.jpg',
        name: "Shahd Dbian",
        jobTitle: 'Web Developer',
      ),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 200.sp),
        Text("Meet Our Team", style: Theme.of(context).textTheme.bodyLarge),
        SizedBox(height: 40.sp),
        ...teamGroups.map(
          (group) => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    group
                        .map(
                          (member) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.sp),
                            child: TeamMemberCard(
                              imagePath: member.imagePath,
                              name: member.name,
                              jobTitle: member.jobTitle,
                            ),
                          ),
                        )
                        .toList(),
              ),
              SizedBox(height: 40.sp),
            ],
          ),
        ),
      ],
    );
  }
}
