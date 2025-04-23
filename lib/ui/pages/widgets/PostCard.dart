import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '/ui/pages/viewmodel/post_view_model.dart';
import 'package:provider/provider.dart';

import '/domain/models/post_model.dart';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({required this.post});

  @override
  Widget build(BuildContext context) {

    final postViewModel = Provider.of<PostViewModel>(context, listen: false);
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final hasLiked = post.likedBy.contains(userId); // Controlla se l'utente ha già messo "mi piace"


   return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🧑‍🎤 Intestazione con avatar e nickname
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: post.user.proPic,
                ),
                const SizedBox(width: 12),
                Text(
                  post.user.nickname,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 🖼️ Immagine del post (se presente)
            if (post.image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image(image: post.postImage),
              ),

            const SizedBox(height: 12),

            // 🏓 Dettagli della partita
            Text(
              '${post.match.user1.nickname} ${post.match.score1} - ${post.match.score2} ${post.match.user2.nickname}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Tipo: ${post.match.type} • ${post.match.location.name}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),

            const SizedBox(height: 8),

            // ❤️ Reazioni / Mi piace
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon:  Icon(Icons.thumb_up, color: hasLiked ? Colors.blue : Colors.grey),
                  onPressed: () {
                    if (hasLiked) {
                      postViewModel.removeLikeFromPost(post);
                      // Rimuovi il like se l'utente ha già messo "mi piace"
                    } else {
                      postViewModel.addLikeToPost(post);
                      // Aggiungi il like se l'utente non ha ancora messo "mi piace"
                    }
                  },
                ),
                Text(
                  '${post.likes} likes',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
