import '/ui/pages/widgets/custom_snackBar.dart';
import '/domain/models/marker_model.dart';
import '/ui/pages/widgets/bottom_navbar.dart';
import '/ui/pages/viewmodel/events_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateEventPage extends StatefulWidget{
  const CreateEventPage({Key? key}) : super(key: key);
  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _maxParticipantsController = TextEditingController(text: '2');

  String? selectedMatchType = '1 vs 1'; // Tipo di match predefinito

  ///Gestione scelta dell'orario di gioco
  DateTime? selectedDateTime;
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
          '${dateTime.hour.toString().padLeft(2, '0')}:'
          '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EventViewModel>();
    final List<String> matchTypes = ['1 vs 1'];
    final markers = viewModel.markers;
    final selectedLocation = viewModel.selectedLocation;

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
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Titolo evento',
                ),
                validator: (value) => value!.isEmpty ? 'Campo obbligatorio' : null,
              ),
                
              ///location  
              DropdownButtonFormField<MarkerData>(
                value: markers.contains(selectedLocation) ? selectedLocation : null,
                items: markers.map((marker) {
                  return DropdownMenuItem<MarkerData>(
                    value: marker,
                    child: Text(marker.nome), // o altro attributo descrittivo
                  );
                }).toList(),
                onChanged: (value) {
                  viewModel.setSelectedLocation(value);
                },
                validator: (value) => value == null ? 'Campo obbligatorio' : null,
                decoration: const InputDecoration(
                  labelText: 'Luogo',
                  border: OutlineInputBorder(),
                ),
              ),

              ///maxParticipants
              TextFormField(
                controller: _maxParticipantsController,
                decoration: InputDecoration(labelText: 'Numero massimo partecipanti'
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Campo obbligatorio' : null,
                enabled: false,
              ),

              ///matchType
              TextFormField(
                initialValue: selectedMatchType,
                decoration: const InputDecoration(
                  labelText: 'Tipo di match',
                  border: OutlineInputBorder(),
                ),
                enabled: false, // 🔒 disabilita modifica
              ),

              ///orario
              ListTile(
                title: Text(
                selectedDateTime != null
                        ? 'Data selezionata: ${_formatDateTime(selectedDateTime!)}'
                        : 'Seleziona data e ora',
                  ),
                  leading: Icon(Icons.calendar_today),
                  trailing: Icon(Icons.access_time),
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          selectedDateTime = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                        });
                      }
                    }
                  },
                ),

            ///creazione evento
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 245, 192, 41)),
                foregroundColor: WidgetStatePropertyAll(Colors.black),
              ),
              onPressed: ()  async{
                if (_formKey.currentState!.validate() &&
                    selectedDateTime != null &&
                    viewModel.selectedLocation != null) {
                    await viewModel.creaEvento(
                      title: _titleController.text,
                      location : viewModel.selectedLocation!,
                      maxParticipants:
                          int.parse(_maxParticipantsController.text),
                      eventType: selectedMatchType!,
                      dataEvento: selectedDateTime!,
                    );
                  CustomSnackBar.show(
                    context,
                    message: "Evento creato con successo",
                    backgroundColor: Colors.green,
                    icon: Icons.check_circle,);
                  Navigator.pop(context);
                  return;
                } else {
                  CustomSnackBar.show(
                    context,
                    message: "Riempi tutti i campi richiesti",
                    backgroundColor: Colors.red,
                    icon: Icons.error_outline_sharp,);
                }
              },
              child: Text('Crea Evento'),
            ),
          ],
          ))
      ),
      bottomNavigationBar: CustomNavBar(),
    );
  }
}