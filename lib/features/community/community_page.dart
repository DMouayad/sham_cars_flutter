import 'package:flutter/material.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = [Tab(text: 'Q&A'), Tab(text: 'Reviews'), Tab(text: 'Q&A')];
    return Column(
      children: [
        DefaultTabController(
          length: tabs.length,
          child: TabBar(tabs: tabs),
        ),
      ],
    );
  }
}
