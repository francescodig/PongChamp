import 'package:PongChamp/domain/models/event_model.dart';

import '/ui/pages/viewmodel/events_view_model.dart';
import '/ui/pages/widgets/custom_snackBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatePostPage extends StatefulWidget{
  final Event event;
  const CreatePostPage({Key? key, required this.event}) : super(key: key);
  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _player1scoreController = TextEditingController();
  final TextEditingController _player2scoreController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  @override
  Widget build(BuildContext context){
    final viewModel = context.watch<EventViewModel>();
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
        
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ///title
              TextFormField(
                controller: _player1scoreController,
                decoration: InputDecoration(labelText: 'Punteggio Giocatore 1',
                ),
                validator: (value) => value!.isEmpty ? 'Campo obbligatorio' : null,
              ),
              TextFormField(
                controller: _player2scoreController,
                decoration: InputDecoration(labelText: 'Punteggio Giocatore 2',
                ),
                validator: (value) => value!.isEmpty ? 'Campo obbligatorio' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Breve descrizione della partita',
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 245, 192, 41)),
                  foregroundColor: WidgetStatePropertyAll(Colors.black),
                ),
                onPressed: ()  async{
                  if (_formKey.currentState!.validate()) {
                    await viewModel.createPost(
                      event: widget.event,
                      player1score: int.parse(_player1scoreController.text),
                      player2score: int.parse(_player2scoreController.text),
                      description: _descriptionController.text,
                    );
                    CustomSnackBar.show(
                      context,
                      message: "Post creato con successo",
                      backgroundColor: Colors.green,
                      icon: Icons.check_circle,);
                    Navigator.pop(context);
                    return;
                  } else {
                    CustomSnackBar.show(
                      context,
                      message: "Riempi tutti i campi richiesti",
                      backgroundColor: Colors.red,
                      icon: Icons.error_outline_sharp,
                    );
                  }
                },
                child: Text('Crea Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}