import 'package:PongChamp/domain/models/user_models.dart';
import 'package:PongChamp/ui/pages/view/profile_page.dart';
import 'package:PongChamp/ui/pages/viewmodel/post_view_model.dart';
import 'package:PongChamp/ui/pages/widgets/app_bar.dart';
import 'package:PongChamp/ui/pages/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LikesPage extends StatelessWidget {
  final String postId;

  const LikesPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final postViewModel = Provider.of<PostViewModel>(context, listen: false);

    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  'Mi piace',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<AppUser>>(
                future: postViewModel.getUsersWhoLikedPost(postId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Errore nel caricamento. ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Nessun like per questo post. '));
                  }

                  final users = snapshot.data!;
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: user.proPic,
                        ),
                        title: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(userId: user.id),
                              ),
                            );
                          },
                          child: Text(user.nickname),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar()
    );
  }
}
