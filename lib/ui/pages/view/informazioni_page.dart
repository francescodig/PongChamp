import 'package:PongChamp/ui/pages/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class InformazioniPage extends StatelessWidget {

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
              "Informazioni sull'App",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            SizedBox(height: 16),
            Text(
              "Nome dell'app: PongChamp\n",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "Versione: 1.0.0\n",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "Descrizione dell'App:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            SizedBox(height: 8),
            Text(
              "PongChamp è un'applicazione che ti permette di sfidare i tuoi amici a ping pong nei migliori centri della tua città, "
              "con l'aggiunta di funzionalità social per condividere i punteggi e le vittorie. "
              "È progettata per offrire un'esperienza di gioco divertente e coinvolgente per tutti.\n",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "Sviluppatore:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            SizedBox(height: 8),
            Text(
              "Sviluppato da: Team PongChamp\n",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "Contatto supporto: supporto@pongchamp.com\n",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "Licenza:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            SizedBox(height: 8),
            Text(
              "Quest'applicazione è open source. Puoi visualizzare il codice sorgente su GitHub e contribuire allo sviluppo.\n",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "Disclaimer:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            SizedBox(height: 8),
            Text(
              "Tutti i diritti sono riservati. PongChamp non è responsabile per danni o malfunzionamenti derivanti dall'utilizzo dell'app. "
              "L'uso dell'app è soggetto ai Termini e Condizioni e alla Privacy Policy."
              "\n\n"
              "L'applicazione potrebbe ricevere aggiornamenti periodici per miglioramenti delle funzionalità o correzioni di bug.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}