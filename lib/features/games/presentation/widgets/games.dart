import 'package:flutter/material.dart';
import 'package:namhockey/features/games/domain/entity/game_entity.dart';

class Games extends StatelessWidget {
  final GameEntity game;

  const Games({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                game.gameDate,
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                game.gameTime,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          Container(
                            height: 30,
                            width: 1,
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  if (game.team1Logo.isNotEmpty)
                    Image.network(
                      game.team1Logo,
                      width: 40,
                      height: 60,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const Icon(Icons.sports, color: Colors.white),
                    ),
                  const SizedBox(width: 8),
                  Text(game.team1, style: TextStyle(color: Colors.white)),
                  const SizedBox(width: 16),
                  Text('vs', style: TextStyle(color: Colors.white)),
                  const SizedBox(width: 16),
                  Text(game.team2, style: TextStyle(color: Colors.white)),
                  const SizedBox(width: 8),
                  if (game.team2Logo.isNotEmpty)
                    Image.network(
                      game.team2Logo,
                      width: 40,
                      height: 60,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const Icon(Icons.sports, color: Colors.white),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
