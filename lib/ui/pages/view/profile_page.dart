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
    final profileviewmodel = Provider.of<ProfileViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
      profileViewModel.loadProfile(userId);
    });

    return Scaffold(
      appBar: CustomAppBar(),
      body: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return StreamBuilder<List<Post>>(
            stream: Provider.of<ProfileViewModel>(context, listen: false).postStream,
            builder: (context, snapshot) {
              // Stati di caricamento
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // Gestione errori
              if (snapshot.hasError) {
                return Center(child: Text('Errore: ${snapshot.error}'));
              }

              // Se non ci sono dati
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Nessun post pubblicato'));
              }

              // Lista dei post
              final posts = snapshot.data!;
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return PostCard(post: posts[index]);
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: CustomNavBar(),
    );
    }
}
