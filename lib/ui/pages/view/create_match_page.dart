import '/ui/pages/viewmodel/user_view_model.dart';
import '/ui/pages/viewmodel/match_view_model.dart';
import '/domain/models/event_model.dart';
import '/ui/pages/widgets/custom_snackBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateMatchPage extends StatefulWidget{
  final Event event;
  const CreateMatchPage({Key? key, required this.event}) : super(key: key);
  @override
  State<CreateMatchPage> createState() => _CreateMatchPageState();
}

class _CreateMatchPageState extends State<CreateMatchPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _player1scoreController = TextEditingController();
  final TextEditingController _player2scoreController = TextEditingController();
  String? _selectedWinnerId;

  @override
  Widget build(BuildContext context){
    final matchViewModel = context.watch<MatchViewModel>();
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

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

              if (widget.event.eventType == "1 vs 1") ...[
                ///title
                TextFormField(
                  controller: _player1scoreController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Punteggio Giocatore 1',
                  ),
                  validator: (value) => value!.isEmpty ? 'Campo obbligatorio' : null,
                ),
                TextFormField(
                  controller: _player2scoreController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Punteggio Giocatore 2',
                  ),
                  validator: (value) => value!.isEmpty ? 'Campo obbligatorio' : null,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 245, 192, 41)),
                    foregroundColor: WidgetStatePropertyAll(Colors.black),
                  ),
                  onPressed: ()  async{
                    if (_formKey.currentState!.validate()) {
                      await matchViewModel.createSingleMatch(
                        event: widget.event,
                        score1: int.parse(_player1scoreController.text),
                        score2: int.parse(_player2scoreController.text),
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
                  child: Text('Crea Match'),
                ),
              ] //costrutto if per gestire match 1vs1

              else ...[
                DropdownButtonFormField<String>(
                  value: _selectedWinnerId,
                  decoration: InputDecoration(labelText: 'Vincitore Torneo'),
                  items: widget.event.participantIds.map((player) {
                    return DropdownMenuItem(
                      value: player,
                      child:
                        FutureBuilder(
                          future: userViewModel.getUserById(player),
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
                    );
                  }).toList(),
                  validator: (value) => value == null ? 'Seleziona un vincitore' : null,
                  onChanged: (value) => setState(() => _selectedWinnerId = value),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 245, 192, 41)),
                    foregroundColor: WidgetStatePropertyAll(Colors.black),
                  ),
                  onPressed: ()  async{
                    if (_formKey.currentState!.validate()) {
                      await matchViewModel.createTournamentMatch(
                        event: widget.event,
                        winnerId: _selectedWinnerId!,
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
                  child: Text('Crea Match'),
                ),
              ] //costrutto else per gestire match Torneo
            ],
          ),
        ),
      ),
    );
  }
}