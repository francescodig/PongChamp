import 'package:PongChamp/ui/pages/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class LegalNotesPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(  
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); 
              },
            ),
            SizedBox(height: 16), 
            Text(
              "Note Legali",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),  
            ),
            SizedBox(height: 16),
            Text(
              "Questa applicazione è fornita così com'è, senza alcuna garanzia implicita o esplicita. "
              "Tutti i contenuti, i dati e i servizi forniti attraverso l'app sono da considerarsi a puro scopo informativo. "
              "L'utente si assume ogni responsabilità per l'uso dell'app e delle informazioni in essa contenute.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "Diritti e Responsabilità",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            SizedBox(height: 8),
            Text(
              "L'uso dell'app implica l'accettazione delle condizioni d'uso e della politica sulla privacy. "
              "L'autore non è responsabile per eventuali danni diretti o indiretti derivanti dall'utilizzo dell'app.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "Contatti",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            SizedBox(height: 8),
            Text(
              "Per segnalazioni o richieste di supporto, puoi contattare il team di sviluppo all'indirizzo email: supporto@appname.com",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}