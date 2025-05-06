import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:PongChamp/domain/models/post_model.dart';
import 'package:PongChamp/ui/pages/widgets/app_bar.dart';
import 'package:PongChamp/ui/pages/widgets/bottom_navbar.dart';
import 'package:PongChamp/ui/pages/viewmodel/profile_view_model.dart';
import 'package:PongChamp/ui/pages/widgets/PostCard.dart';

class ProfilePage extends StatelessWidget {
  final String userId;

  const ProfilePage({required this.userId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileViewModel.loadProfile(userId);
    });

    return Scaffold(
      appBar: CustomAppBar(),
      body: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Intestazione profilo con immagine e nome
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(viewModel.profileImageUrl ?? ''),
                      backgroundColor: Colors.grey[300],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        viewModel.userName ?? 'Utente',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(),

              // Elenco post
              Expanded(
                child: StreamBuilder<List<Post>>(
                  stream: viewModel.postStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Errore: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Nessun post pubblicato'));
                    }

                    final posts = snapshot.data!;
                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return PostCard(post: posts[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: CustomNavBar(),
    );
  }
}

