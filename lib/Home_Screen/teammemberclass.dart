import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ieee_website/Home_Screen/layout_config.dart';
import 'package:ieee_website/widgets/team_member.dart';

class TeamMember {
  final String pic;
  final String name;
  final String position;
  final int number;

  TeamMember({
    required this.pic,
    required this.name,
    required this.position,
    required this.number,
  });

  // Convert Firestore document to TeamMember object
  factory TeamMember.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    String picUrl = data['pic'] ?? '';

    print("Fetched Image URL: $picUrl");

    return TeamMember(
      pic: picUrl,
      name: data['name'] ?? 'Unknown',
      position: data['position'] ?? 'Member',
      number: (data['number'] ?? 9999).toInt(),
    );
  }
}

class OurTeamSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 200.sp),
        Text(
          "Meet Our Team",
          style: Theme.of(context).textTheme.bodyLarge,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 40.sp),

        // Fetch members from Firestore in real-time, ordered by number (ascending)
        StreamBuilder(
          stream:
              FirebaseFirestore.instance
                  .collection('teamLayoutConfig')
                  .doc('rowSizes')
                  .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> layoutSnapshot) {
            if (!layoutSnapshot.hasData) {
              return CircularProgressIndicator();
            }

            LayoutConfig config = LayoutConfig.fromFirestore(
              layoutSnapshot.data!,
            );

            // Now fetch members
            return StreamBuilder(
              stream:
                  FirebaseFirestore.instance
                      .collection('Members')
                      .orderBy('number', descending: false)
                      .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> memberSnapshot) {
                if (!memberSnapshot.hasData) {
                  return CircularProgressIndicator();
                }

                List<TeamMember> members =
                    memberSnapshot.data!.docs
                        .map((doc) => TeamMember.fromFirestore(doc))
                        .toList();

                // Triangle layout with dynamic rows
                List<List<TeamMember>> pyramidRows = [];
                int startIndex = 0;
                for (int size in config.rowSizes) {
                  if (startIndex >= members.length) break;
                  int endIndex =
                      (startIndex + size > members.length)
                          ? members.length
                          : startIndex + size;
                  pyramidRows.add(members.sublist(startIndex, endIndex));
                  startIndex = endIndex;
                }

                return Column(
                  children:
                      pyramidRows.map((group) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:
                                  group.map((member) {
                                    return Padding(
                                      padding: EdgeInsets.all(10.sp),
                                      child: TeamMemberCard(
                                        imagePath: member.pic,
                                        name: member.name,
                                        jobTitle: member.position,
                                      ),
                                    );
                                  }).toList(),
                            ),
                            SizedBox(height: 20.sp),
                          ],
                        );
                      }).toList(),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
