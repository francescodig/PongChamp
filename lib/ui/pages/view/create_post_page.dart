import 'dart:io';
import 'package:PongChamp/domain/models/user_models.dart';
import 'package:PongChamp/ui/pages/viewmodel/user_view_model.dart';
import 'package:permission_handler/permission_handler.dart';

import '/domain/models/match_model.dart';
import '/ui/pages/viewmodel/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreatePostPage extends StatefulWidget {
  final PongMatch match;

  const CreatePostPage({
    Key? key,
    required this.match,
  }) : super(key: key);

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  File? _imageFile;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        actionsPadding: EdgeInsets.all(10),
        toolbarHeight: 80,
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 245, 192, 41),
        title: Text("PongChamp", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Anteprima del Post
            _buildPostPreview(),
            const SizedBox(height: 20),
            // Sezione immagine opzionale
            _buildImageSection(),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 245, 192, 41)),
                foregroundColor: WidgetStatePropertyAll(Colors.black),
              ),
              onPressed: _isLoading ? null : _submitPost,
              child: Text('Crea Post'),
            ),
          ],
        ),
      ),
    );
  }

  //Funzioni di costruzione
  Widget _buildPostPreview() {
    final userViewModel = context.watch<UserViewModel>();
    String score="";
    if (widget.match.score1 != null && widget.match.score2 != null) {
      score = "${widget.match.score1} - ${widget.match.score2}";}
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Anteprima immagine
            if (_imageFile != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _imageFile!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            // Titolo match
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.match.matchTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  score.isNotEmpty ? Text(score, style: Theme.of(context).textTheme.titleMedium,) : Text(""),
                ],
              )
            ),
            // Partecipanti
            FutureBuilder<List<AppUser?>>(
              future: _fetchAllUsers(userViewModel),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Text('Errore nel caricamento');
                }
                final users = snapshot.data!.whereType<AppUser>().toList();
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(users[index].profileImage),
                      ),
                      title: Text(users[index].nickname),
                    );
                  },
                );
              },
            ),
            FutureBuilder<AppUser?>(
              future: userViewModel.getUserById(widget.match.winnerId), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Text('Errore nel caricamento');
                }
                final winner = snapshot.data!.nickname;
                return Text("Vincitore: $winner", style: Theme.of(context).textTheme.titleMedium,);
              },)
          ],
        ),
      ),
    );
  }
  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Immagine (opzionale)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (_imageFile == null)
          OutlinedButton.icon(
            icon: const Icon(Icons.add_photo_alternate),
            label: const Text('Aggiungi immagine'),
            onPressed: _pickImage,
          )
        else
          Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _imageFile!,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black54,
                ),
                onPressed: _removeImage,
              ),
            ],
          ),
      ],
    );
  }

  //Funzioni di gestione anteprima immagine 
  Future<void> _pickImage() async {
    PermissionStatus permissionStatus;
    if(Platform.isIOS){
      permissionStatus = await Permission.photos.request();
    } else {
      permissionStatus = await Permission.storage.request();
    }
    if(permissionStatus.isGranted){
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      } else if (permissionStatus.isPermanentlyDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Permesso per accedere alla galleria negato. Abilitalo dalle impostazioni."),
            action: SnackBarAction(
              label: "Apri Impostazioni",
              onPressed: () {
                openAppSettings();
              },
            ),
          ),
        );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Permesso per accedere alla galleria necessario per selezionare un'immagine.")),
    );
  }
    }
    
  }
  void _removeImage() {
    setState(() {
      _imageFile = null;
    });
  }

  //Funzione per il caricamento dei players
  Future<List<AppUser?>> _fetchAllUsers(UserViewModel viewModel) async {
    try {
      return await Future.wait(
        widget.match.matchPlayers.map((id) => viewModel.getUserById(id)),
      );
    } catch (e) {
      debugPrint('Error fetching users: $e');
      return [];
    }
  }

  //Funzione per la creazione del Post
  Future<void> _submitPost() async {
    setState(() => _isLoading = true);
    final postViewModel = Provider.of<PostViewModel>(context, listen: false);
    try {
      await postViewModel.createPost(
        match: widget.match,
        image: _imageFile != null ? XFile(_imageFile!.path) : null,
      );
      Navigator.pop(context, true); // Ritorna "true" per indicare successo
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

}