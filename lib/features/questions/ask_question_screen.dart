import 'package:flutter/material.dart';

class AskQuestionScreen extends StatelessWidget {
  const AskQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('اسأل سؤالاً')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'عنوان السؤال'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: bodyController,
            maxLines: 6,
            decoration: const InputDecoration(labelText: 'التفاصيل'),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              // later call API
              Navigator.pop(context);
            },
            child: const Text('نشر'),
          ),
        ],
      ),
    );
  }
}
