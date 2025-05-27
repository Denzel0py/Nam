import 'package:flutter/material.dart';
import 'package:namhockey/features/games/domain/entity/game_entity.dart';

class Games extends StatelessWidget {
  final GameEntity game;

  const Games({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Date and Time Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                game.gameDate,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                game.gameTime,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Vertical Divider
          Container(
            height: 40,
            width: 1,
            color: Colors.grey[300],
          ),
          const SizedBox(width: 16),
          // Teams and VS
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Team 1
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          game.team1,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (game.team1Logo.isNotEmpty)
                        Image.network(
                          game.team1Logo,
                          width: 32,
                          height: 32,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.sports, color: theme.primaryColor),
                        ),
                    ],
                  ),
                ),
                // VS
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'VS',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Team 2
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      if (game.team2Logo.isNotEmpty)
                        Image.network(
                          game.team2Logo,
                          width: 32,
                          height: 32,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.sports, color: theme.primaryColor),
                        ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          game.team2,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
