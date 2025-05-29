import 'dart:io';
import 'package:PongChamp/data/services/post_service.dart';
import 'package:PongChamp/data/services/repositories/post_repository.dart';
import 'package:PongChamp/domain/models/match_model.dart';
import 'package:PongChamp/ui/pages/viewmodel/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _imageFile = null;
    });
  }

  Future<void> _submitPost() async {
    setState(() => _isLoading = true);

    try {
      await PostViewModel(PostRepository(PostService())).createPost(match: widget.match,);
      Navigator.pop(context, true); // Ritorna "true" per indicare successo
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crea Post'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _isLoading ? null : _submitPost,
          ),
        ],
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
          ],
        ),
      ),
    );
  }

  Widget _buildPostPreview() {
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
            
            // Dati dell'evento
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                widget.match.matchTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),

            // Partecipanti
            Wrap(
              spacing: 4,
              children: widget.match.matchPlayers
                  .take(3)
                  .map((p) => Chip(
                        label: Text(p),
                        visualDensity: VisualDensity.compact,
                      ))
                  .toList(),
            ),
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

  @override
  void dispose() {
    super.dispose();
  }
}