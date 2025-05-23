import 'package:flutter/material.dart';

class TeamDiscussionPage extends StatelessWidget {
  const TeamDiscussionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Team Discussion')),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 0, // TODO: Replace with actual message count
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: const Text('User Name'),
                  subtitle: const Text('Message content'),
                  trailing: const Text('2:30 PM'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      // TODO: Implement message sending
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    // TODO: Implement message sending
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
