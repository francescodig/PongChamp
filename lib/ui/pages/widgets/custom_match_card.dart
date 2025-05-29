import 'package:PongChamp/ui/pages/view/create_post_page.dart';

import '/ui/pages/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';
import '/domain/functions/utility.dart';
import '/domain/models/match_model.dart';
import 'package:flutter/material.dart';

class CustomMatchCard extends StatelessWidget {
  final PongMatch match;

  const CustomMatchCard({
    Key? key,
    required this.match,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
        final formattedTime = formatDateTimeManually(match.date);
        final userViewModel = context.watch<UserViewModel>();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (_) => CreatePostPage(match: match,))
        );
      },
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    match.matchTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Center(
                        child: FutureBuilder(
                          future: (userViewModel.getUserById(match.matchPlayers[0])),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || snapshot.data == null) {
                              return CircularProgressIndicator();
                            }
                            final user = snapshot.data!;
                            return Text(
                              user.nickname,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            );
                          },
                        )
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${match.score1} - ${match.score2}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Center(
                        child: FutureBuilder(
                          future: (userViewModel.getUserById(match.matchPlayers[1])),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || snapshot.data == null) {
                              return CircularProgressIndicator();
                            }
                            final user = snapshot.data!;
                            return Text(
                              user.nickname,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            );
                          },
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
