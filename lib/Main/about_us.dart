// about_us.dart
import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Budget Buddy App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Hello there! 👋',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Budget Buddy was created by a passionate college student as part of a graduation project. '
              'The goal was to develop a user-friendly and intuitive budget management app to help users '
              'gain control over their finances and work towards financial freedom.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'What we learned:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '- Mobile app development using Flutter framework',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '- State management with Provider package',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '- User interface design and user experience (UI/UX)',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '- Integration of different screens and navigation',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Thank you for using Budget Buddy! We hope it helps you on your journey to financial well-being.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
