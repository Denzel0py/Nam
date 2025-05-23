import 'package:flutter/material.dart';

class LeagueFilter extends StatelessWidget {
  const LeagueFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
              child: Image.asset(
                'assets/images/realmadridlogo.png', // You'll need to add these images
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}
