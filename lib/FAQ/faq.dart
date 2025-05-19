import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../FAQ/faq_item_widget.dart';
import '../FAQ/faq_item_model.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:ieee_website/Widgets/footer.dart';

class FAQ extends StatefulWidget {
  static const String routeName = 'faq';
  final TabController? tabController;
  const FAQ({Key? key, this.tabController}) : super(key: key);

  @override
  _FAQState createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  List<FAQItemModel> faqItems = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchFAQData();
  }

  Future<void> fetchFAQData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('faq').get();

      print("Number of FAQs: ${querySnapshot.docs.length}");

      setState(() {
        faqItems =
            querySnapshot.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              print("Fetching FAQ data: $data");
              return FAQItemModel.fromFirestore(data);
            }).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      print("Error fetching FAQ data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header gradient container
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    WebsiteColors.gradeintBlueColor,
                    WebsiteColors.primaryBlueColor,
                    WebsiteColors.darkBlueColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                padding: const EdgeInsets.fromLTRB(24, 120, 24, 60),
                child: buildTitleSection(),
              ),
            ),

            // Content section with curved top
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  margin: const EdgeInsets.only(top: 40),
                  padding: const EdgeInsets.only(top: 30),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 24,
                        ),
                        child:
                            isLoading
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : hasError
                                ? const Center(
                                  child: Text(
                                    "An error occurred while loading data",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                                : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...faqItems.map(
                                      (item) => Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.05,
                                              ),
                                              blurRadius: 10,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: FAQItemWidget(
                                          item: item,
                                          onExpansionChanged: (expanded) {
                                            setState(() {
                                              item.isExpanded = expanded;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 36),
                                  ],
                                ),
                      ),
                    ),
                  ),
                ),

                // Curve painter positioned at the top
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 70,
                  child: CustomPaint(painter: CurvePainter()),
                ),
              ],
            ),

            // Footer
            if (widget.tabController != null)
              Footer(tabController: widget.tabController!),
          ],
        ),
      ),
    );
  }

  Widget buildTitleSection() {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            children: [const TextSpan(text: "FAQ")],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Here you can find frequently asked questions. We help you to find the answer!",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16),
        ),
      ],
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var gradient = LinearGradient(
      colors: [
        WebsiteColors.gradeintBlueColor,
        WebsiteColors.primaryBlueColor,
        WebsiteColors.darkBlueColor,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    var paint = Paint()..shader = gradient.createShader(rect);

    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height * 0.5);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height,
      size.width,
      size.height * 0.5,
    );
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
