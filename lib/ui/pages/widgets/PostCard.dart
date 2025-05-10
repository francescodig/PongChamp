import 'package:PongChamp/ui/pages/view/likes_page.dart';
import 'package:PongChamp/ui/pages/view/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '/ui/pages/viewmodel/post_view_model.dart';
import 'package:provider/provider.dart';
import '/domain/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // per debugPrintStack()

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final postViewModel = Provider.of<PostViewModel>(context, listen: false);
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final hasLiked = post.likedBy.contains(userId);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Intestazione con avatar e nickname
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (ModalRoute.of(context)?.settings.name != '/profile_${post.user.id}') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          settings: RouteSettings(name: '/profile_${post.user.id}'),
                          builder: (_) => ProfilePage(userId: post.user.id!),
                       ),
                      );
                    }
                  },
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: post.user.proPic,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    if (ModalRoute.of(context)?.settings.name != '/profile_${post.user.id}') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          settings: RouteSettings(name: '/profile_${post.user.id}'),
                          builder: (_) => ProfilePage(userId: post.user.id!),
                       ),
                      );
                    }
                  },
                  child: Text(
                    post.user.nickname,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Parte centrale con i giocatori e punteggio (MODIFICATA)
            LayoutBuilder(
              builder: (context, constraints) {
                // Calcoliamo la larghezza disponibile per i nickname
                final availableWidth = constraints.maxWidth - 100; // Sottrai spazio per avatar, punteggio, ecc.
                final nicknameWidth = availableWidth / 2 - 16; // Dividi lo spazio tra i due nickname
                
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Giocatore 1
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          if (ModalRoute.of(context)?.settings.name != '/profile_${post.match.user1.id}') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                settings: RouteSettings(name: '/profile_${post.match.user1.id}'),
                                builder: (_) => ProfilePage(userId: post.match.user1.id!),
                              ),
                            );
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundImage: post.match.user1.proPic,
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: nicknameWidth,
                              child: Text(
                                post.match.user1.nickname,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Punteggio
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            post.match.score1.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '-',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            post.match.score2.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    // Giocatore 2
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          if (ModalRoute.of(context)?.settings.name != '/profile_${post.match.user2.id}') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                settings: RouteSettings(
                                  name: '/profile_${post.match.user2.id}',
                                ),
                                builder: (_) => ProfilePage(userId: post.match.user2.id!),
                              ),
                            );
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: nicknameWidth,
                              child: Text(
                                post.match.user2.nickname,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                              ),
                            ),
                            const SizedBox(width: 8),
                            CircleAvatar(
                              radius: 12,
                              backgroundImage: post.match.user2.proPic,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 30),

            // Immagine del post (se presente)
            if (post.image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image(image: post.postImage),
              ),

            const SizedBox(height: 12),

            // Dettagli della partita
            Text(
              'Tipo: ${post.match.type} • ${post.match.location.name}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),

            const SizedBox(height: 8),

            // Reazioni / Mi piace
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.favorite, color: hasLiked ? Colors.red : Colors.grey),
                  onPressed: () {
                    if (hasLiked) {
                      postViewModel.removeLikeFromPost(post);
                    } else {
                      postViewModel.addLikeToPost(post);
                    }
                  },
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LikesPage(postId: post.id),
                      ),
                    );
                  },
                  child: Text(
                    '${post.likes} likes',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}