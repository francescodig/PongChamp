import '/ui/pages/widgets/app_bar.dart';
import '/ui/pages/widgets/bottom_navbar.dart';
import '/ui/pages/viewmodel/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/domain/models/post_model.dart';
import '../widgets/PostCard.dart'; // dove hai il widget PostCard
// il tuo ViewModel

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Otteniamo l’istanza del PostViewModel tramite Provider
    final postViewModel = Provider.of<PostViewModel>(context);

    return Scaffold(
      appBar: CustomAppBar(),
      body: StreamBuilder<List<Post>>(
        // Ascoltiamo lo stream dei post dal ViewModel
        stream: postViewModel.getPostsStream(),
        builder: (context, snapshot) {


          // Mostriamo un indicatore di caricamento finché lo stream non ha dati
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Se c’è un errore nello stream, mostriamo un messaggio di errore
          if (snapshot.hasError) {
            return Center(child: Text('Errore nel caricamento dei post. ${snapshot.error} ${snapshot.data}'));
          }

          // Se i dati sono vuoti, mostriamo un messaggio appropriato
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nessun post disponibile.'));
          }

          // Prendiamo i post dal risultato dello stream
          final posts = snapshot.data!;

          // Visualizziamo i post usando una ListView
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];

              // Usiamo il widget PostCard per mostrare il singolo post
              return PostCard(post: post);
            },
          );
        },
      ),
      bottomNavigationBar: CustomNavBar(
      ),
    );
  }
}
