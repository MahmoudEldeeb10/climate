import 'package:flutter/material.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 50),
            Center(child: Text('Chat Bot Coming Soon!')),
          ],
        ),
      ),
    );
  }
}
