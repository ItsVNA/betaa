// faq_screen.dart
import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: faqItems
              .map((faqItem) => FaqItemWidget(faqItem: faqItem))
              .toList(),
        ),
      ),
    );
  }
}

class FaqItem {
  final String question;
  final String answer;

  FaqItem({required this.question, required this.answer});
}

class FaqItemWidget extends StatelessWidget {
  final FaqItem faqItem;

  const FaqItemWidget({Key? key, required this.faqItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        title: Text(
          faqItem.question,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              faqItem.answer,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<FaqItem> faqItems = [
  FaqItem(
    question: 'How do I add an expense?',
    answer:
        'Go to the Expenses screen and tap the "+" button. Enter the expense name and amount, then save.',
  ),
  FaqItem(
    question: 'Can I edit an existing expense?',
    answer:
        'Yes, you can. On the Expenses screen, tap the edit icon next to the expense you want to modify. Make your changes and save.',
  ),
  FaqItem(
    question: 'How do I delete an expense?',
    answer:
        'To delete an expense, go to the Expenses screen and tap the delete icon next to the expense you want to remove.',
  ),
  FaqItem(
    question: 'What is the difference between Flexible and Priority expenses?',
    answer:
        'Flexible expenses are non-essential, while Priority expenses are crucial. Budget Buddy helps you differentiate and manage them effectively.',
  ),
  // Add more FAQ items as needed
];
