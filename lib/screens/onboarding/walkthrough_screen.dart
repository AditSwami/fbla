import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalkthroughScreen extends StatefulWidget {
  @override
  _WalkthroughScreenState createState() => _WalkthroughScreenState();
}

class _WalkthroughScreenState extends State<WalkthroughScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final List<WalkthroughItem> items = [
    WalkthroughItem(
      title: "Welcome to StudyBuddy",
      description: "Your personal learning assistant for FBLA success",
      image: "assets/images/welcome.png",
    ),
    WalkthroughItem(
      title: "Join Classes",
      description: "Connect with your peers and join study groups",
      image: "assets/images/classes.png",
    ),
    WalkthroughItem(
      title: "Create Study Sets",
      description: "Make and share flashcards and study materials",
      image: "assets/images/study.png",
    ),
    WalkthroughItem(
      title: "Track Progress",
      description: "Monitor your learning journey and achievements",
      image: "assets/images/progress.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: items.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return WalkthroughPage(item: items[index]);
            },
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    items.length,
                    (index) => buildDot(index: index),
                  ),
                ),
                SizedBox(height: 20),
                if (_currentPage == items.length - 1)
                  ElevatedButton(
                    onPressed: () => _completeWalkthrough(context),
                    child: Text("Get Started"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot({required int index}) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      height: 10,
      width: _currentPage == index ? 20 : 10,
      decoration: BoxDecoration(
        color: _currentPage == index ? Theme.of(context).primaryColor : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Future<void> _completeWalkthrough(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_walkthrough', true);
    Navigator.pushReplacementNamed(context, '/home');
  }
}

class WalkthroughItem {
  final String title;
  final String description;
  final String image;

  WalkthroughItem({
    required this.title,
    required this.description,
    required this.image,
  });
}

class WalkthroughPage extends StatelessWidget {
  final WalkthroughItem item;

  const WalkthroughPage({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            item.image,
            height: 300,
          ),
          SizedBox(height: 40),
          Text(
            item.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text(
            item.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}