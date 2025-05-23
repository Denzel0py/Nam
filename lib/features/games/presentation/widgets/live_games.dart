import 'package:flutter/material.dart';

class LiveGames extends StatelessWidget {
  final Color containerColor;

  const LiveGames({super.key, required this.containerColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      height: 180,
      width: 120,
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Text(
                  'Live',
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ),
              Spacer(),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/Teamx.jpg',
                  fit: BoxFit.fitHeight,
                ),
              ),

              const SizedBox(width: 10),

              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/Saints.png',
                  fit: BoxFit.fitHeight,
                ),
              ),
            ],
          ),

          SizedBox(height: 10.0),
          Row(
            children: [
              Text(
                'Team X',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
              Spacer(),
              Text('0', style: TextStyle(fontSize: 12, color: Colors.white)),
            ],
          ),

          Row(
            children: [
              Text(
                'Saints',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
              Spacer(),
              Text('1', style: TextStyle(fontSize: 12, color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}
