import 'package:PongChamp/domain/models/match_model.dart';
import 'package:PongChamp/domain/models/user_models.dart';
import 'package:PongChamp/ui/pages/view/likes_page.dart';
import 'package:PongChamp/ui/pages/view/profile_page.dart';
import 'package:PongChamp/ui/pages/viewmodel/match_view_model.dart';
import 'package:PongChamp/ui/pages/viewmodel/user_view_model.dart';
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
    final matchViewModel = Provider.of<MatchViewModel>(context, listen: false);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
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
                    if (ModalRoute.of(context)?.settings.name != '/profile_${post.idCreator}') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          settings: RouteSettings(name: '/profile_${post.idCreator}'),
                          builder: (_) => ProfilePage(userId: post.idCreator),
                       ),
                      );
                    }
                  },
                  child: FutureBuilder<String?>(
                    future: postViewModel.getCreatorProfileImageUrl(post.idCreator),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircleAvatar(
                          radius: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                        return const CircleAvatar(
                          radius: 24,
                          child: Icon(Icons.person),
                        );
                      } else {
                        return CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(snapshot.data!),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    if (ModalRoute.of(context)?.settings.name != '/profile_${post.idCreator}') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          settings: RouteSettings(name: '/profile_${post.idCreator}'),
                          builder: (_) => ProfilePage(userId: post.idCreator),
                       ),
                      );
                    }
                  },
                  child: FutureBuilder<AppUser?>(

                      future: userViewModel.getUserById(post.idCreator),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // o un placeholder
                        } else if (snapshot.hasError) {
                          return Text('Errore nel caricamento utente');
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return Text('Utente non trovato');
                        }

                        final user = snapshot.data!;



 

                    return Text(
                      user.nickname,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    );
                  },
                ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            LayoutBuilder(
  builder: (context, constraints) {
    final availableWidth = constraints.maxWidth - 100;
    final nicknameWidth = availableWidth / 2 - 16;

    return FutureBuilder<PongMatch?>(
      future: matchViewModel.fetchMatchById(post.idMatch),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Text('Errore nel caricamento del match');
        }

        final match = snapshot.data!;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Giocatore 1
            Flexible(
              child: GestureDetector(
                onTap: () {
                  if (ModalRoute.of(context)?.settings.name != '/profile_${match.matchPlayers[0]}') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: RouteSettings(name: '/profile_${match.matchPlayers[0]}'),
                        builder: (_) => ProfilePage(userId: match.matchPlayers[0]),
                      ),
                    );
                  }
                },
                child: FutureBuilder<AppUser?>(
                  future: userViewModel.getUserById(match.matchPlayers[0]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            child: SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: nicknameWidth,
                            height: 16,
                            child: Container(color: Colors.grey[300]),
                          ),
                        ],
                      );
                    }
                    if (snapshot.hasError || !snapshot.hasData) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            child: Icon(Icons.error),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: nicknameWidth,
                            child: Text(
                              'Errore',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      );
                    }
                    final user = snapshot.data!;
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundImage: user.proPic != null
                              ? NetworkImage(user.profileImage)
                              : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: nicknameWidth,
                          child: Text(
                            user.nickname,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    );
                  },
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
                    match.score1.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '-',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    match.score2.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
            // Giocatore 2
            Flexible(
              child: GestureDetector(
                onTap: () {
                  if (ModalRoute.of(context)?.settings.name != '/profile_${match.matchPlayers[1]}') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: RouteSettings(name: '/profile_${match.matchPlayers[1]}'),
                        builder: (_) => ProfilePage(userId: match.matchPlayers[1]),
                      ),
                    );
                  }
                },
                child: FutureBuilder<AppUser?>(
                  future: userViewModel.getUserById(match.matchPlayers[1]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: nicknameWidth,
                            height: 16,
                            child: Container(color: Colors.grey[300]),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            radius: 12,
                            child: SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ],
                      );
                    }
                    if (snapshot.hasError || !snapshot.hasData) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: nicknameWidth,
                            child: Text(
                              'Errore',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            radius: 12,
                            child: Icon(Icons.error),
                          ),
                        ],
                      );
                    }
                    final user = snapshot.data!;
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: nicknameWidth,
                          child: Text(
                            user.nickname,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                          ),
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          radius: 12,
                          backgroundImage: user.proPic != null
                              ? NetworkImage(user.profileImage)
                              : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  },
),



if (post.image != null && post.image!.isNotEmpty)
  Padding(
    padding: const EdgeInsets.only(top: 16.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        post.image!,
        fit: BoxFit.cover,
        width: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Icon(Icons.broken_image, size: 40));
        },
      ),
    ),
  ),


            const SizedBox(height: 12),


           // Azioni
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    hasLiked ? Icons.favorite : Icons.favorite_border,
                    color: hasLiked ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    if (hasLiked) {
                      postViewModel.removeLikeFromPost(post.id, post.likes);
                    } else {
                      postViewModel.addLikeToPost(post.id, post.likes);
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),



          ],
        ),
      ),
    );
  }
} 