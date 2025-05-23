import 'package:flutter/material.dart';

class PlayerRegistrationPage extends StatelessWidget {
  const PlayerRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join a Team'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Teams',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 0, // TODO: Replace with actual team count
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.group),
                      ),
                      title: const Text('Team Name'),
                      subtitle: const Text('Coach: John Doe'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // TODO: Implement join team request
                        },
                        child: const Text('Request to Join'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} 