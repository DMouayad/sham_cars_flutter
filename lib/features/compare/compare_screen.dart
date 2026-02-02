import 'package:flutter/material.dart';

class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('المقارنة')),
      body: Center(child: Text('المقارنة (لاحقاً: local state + add/remove)')),
    );
  }
}
