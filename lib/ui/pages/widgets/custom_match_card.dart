import '/domain/functions/utility.dart';

import '/domain/models/match_model.dart';
import 'package:flutter/material.dart';

class CustomMatchCard extends StatelessWidget {
  final PongMatch match;
  final VoidCallback? onTap;

  const CustomMatchCard({
    Key? key,
    required this.match,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
        final formattedTime = formatDateTimeManually(match.date);


    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Riga 1: Tipo e Data
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    const Icon(Icons.sports_tennis, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      match.type,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ]),
                  Text(
                    formattedTime,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              /// Riga 2: Partecipanti e punteggio
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Center(
                      child: CircleAvatar(
                        child: Text('1'), // placeholder
                      ),
                    ),
                  ),
                  Text(
                    '${match.score1} - ${match.score2}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Center(
                      child: CircleAvatar(
                        child: Text('2'), // placeholder
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
