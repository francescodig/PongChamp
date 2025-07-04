import '/ui/pages/widgets/app_bar.dart';
import '/ui/pages/widgets/bottom_navbar.dart';
import '/ui/pages/viewmodel/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/domain/models/post_model.dart';
import '../widgets/PostCard.dart'; 


class HomePage extends StatelessWidget {

  final String? currentUserId;
  const HomePage({Key? key, this.currentUserId}) : super(key: key);

  Future <bool> _onWillPop(BuildContext context) async {
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sei sicuro di voler uscire?'),
        content: const Text('Se esci ora da PongChamp, potresti perderti dei post importanti.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'No',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Sì',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
    return shouldLeave ?? false;
  }


  @override
  Widget build(BuildContext context) {
    
    final postViewModel = Provider.of<PostViewModel>(context, listen: false);
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
      appBar: CustomAppBar(),
      body: StreamBuilder<List<Post>>(
       
        stream: postViewModel.getFeed(currentUserId!),
        builder: (context, snapshot) {


          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

      
          if (snapshot.hasError) {
            return Center(child: Text('Errore nel caricamento dei post. ${snapshot.error} ${snapshot.data}'));
          }

       
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nessun post disponibile.'));
          }

          final posts = snapshot.data!;

     
          return RefreshIndicator(
            onRefresh: () async {
              // Ricarichiamo i post quando l'utente tira per aggiornare
              await postViewModel.refreshPosts();

            },
            
              child: ListView.separated(
              itemCount: posts.length,
              addAutomaticKeepAlives: false, // Disabilitiamo il keep alive automatico per migliorare le performance
              cacheExtent: 1000, // ad esempio, precarica l'equivalente di ~2-3 post fuori schermo
              separatorBuilder: (_, __) => SizedBox(height: 12), //Per migliorare visivamente la separazione tra i post
              itemBuilder: (context, index) {
                final post = posts[index];

                return PostCard(post: post);
              },
            ),
          );
        },
      ),
      bottomNavigationBar: CustomNavBar(
      ),
      ),
    );
  }
}
