import '/ui/pages/viewmodel/events_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateEventPage extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _maxParticipantsController = TextEditingController();


  ///Gestione scelta del matchType
  final ValueNotifier<String?> selectedMatchType = ValueNotifier(null);
  final List<String> matchTypes = ['1 vs 1', 'Torneo'];

  ///Gestione scelta dell'orario di gioco
  final ValueNotifier<DateTime?> selectedDateTime = ValueNotifier(null);
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
          '${dateTime.hour.toString().padLeft(2, '0')}:'
          '${dateTime.minute.toString().padLeft(2, '0')}';
  }


  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 150),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Titolo evento',
              ),
              validator: (value) => value!.isEmpty ? 'Campo obbligatorio' : null,
            ),
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Luogo'
              ),
              validator: (value) => value!.isEmpty ? 'Campo obbligatorio' : null,
            ),
            TextFormField(
              controller: _maxParticipantsController,
              decoration: InputDecoration(labelText: 'Numero massimo partecipanti'
              ),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Campo obbligatorio' : null,
            ),

            ValueListenableBuilder<String?>(
              valueListenable: selectedMatchType,
              builder: (context, value, _) {
                return DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Tipo di match'),
                  value: value,
                  items: matchTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    selectedMatchType.value = newValue;
                  },
                  validator: (value) => value == null ? 'Seleziona il tipo di match' : null,
                );
              },
            ),

            ValueListenableBuilder<DateTime?>(
              valueListenable: selectedDateTime,
              builder: (context, dateTime, _) {
                return ListTile(
                  title: Text(
                    dateTime != null
                        ? 'Data selezionata: ${_formatDateTime(dateTime)}'
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
                        final combined = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                        selectedDateTime.value = combined;
                      }
                    }
                  },
                );
              },
            ),

            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.yellowAccent),
                foregroundColor: WidgetStatePropertyAll(Colors.black),
              ),
              onPressed: () {
                viewModel.creaEvento(
                  title: _titleController.text,
                  location: _locationController.text,
                  orario : selectedDateTime.value!,
                  maxParticipants: int.tryParse(_maxParticipantsController.text) ?? 2,
                  matchType: selectedMatchType.value!,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Evento creato con successo')),
                );
                Navigator.pop(context);
              },
              child: Text('Crea Evento'),
            ),
          ],
        ),
      ),
    );
  }
}