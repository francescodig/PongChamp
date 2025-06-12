import 'package:PongChamp/data/services/repositories/profile_page_repository.dart';
import 'package:PongChamp/ui/pages/view/match_page.dart';
import 'package:PongChamp/ui/pages/widgets/post_card_profile.dart';
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
    final userPostRepository = Provider.of<ProfilePageRepository>(context, listen: false);
    return ChangeNotifierProvider(
      create: (_) {
        final vm = ProfileViewModel(userPostRepository);
        Future.microtask(() => vm.loadProfile(userId));
        return vm;
      },
      child: _ProfilePageContent(userId: userId),
    );
  }
}

class _ProfilePageContent extends StatelessWidget {
  final String userId;
  const _ProfilePageContent({required this.userId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProfileViewModel>(context);

    return Scaffold(
      appBar: CustomAppBar(),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
             onRefresh: () async {
                await viewModel.loadProfile(userId);
             },
             child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Intestazione profilo
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
                      if (userId == viewModel.userId)
                        IconButton(
                          icon: const Icon(Icons.post_add, size: 30),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MatchPage(),
                              ),
                            );
                          },
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
                            if(userId != viewModel.userId) {
                              return PostCard(post: posts[index]);
                            } else {
                              return PostCardProfile(post: posts[index]);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: CustomNavBar(),
    );
  }
}
