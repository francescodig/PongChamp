import 'package:PongChamp/ui/pages/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {

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
              "Ultimo aggiornamento: 25 Aprile 2025\n\n",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "La privacy dei nostri utenti è una priorità per noi. Questa Privacy Policy spiega come raccogliamo, utilizziamo, e proteggiamo le informazioni personali quando utilizzi la nostra app.\n\n",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "1. Informazioni raccolte",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            SizedBox(height: 8),
            Text(
              "Raccogliamo diverse categorie di informazioni per fornirti un'esperienza migliore:\n"
              "- Informazioni Personali: Nome, indirizzo email e altre informazioni di contatto che fornisci volontariamente durante la registrazione o l'interazione con l'app.\n"
              "- Dati di utilizzo: Raccogliamo informazioni sul modo in cui usi la nostra app, come le pagine visitate e le funzionalità utilizzate. Questi dati sono utilizzati per migliorare l'app e l'esperienza utente.\n"
              "- Informazioni tecniche: Raccogliamo informazioni tecniche relative al dispositivo che utilizzi, inclusi indirizzi IP, tipo di dispositivo, sistema operativo e altre informazioni tecniche per l'analisi e il miglioramento delle performance dell'app.\n\n",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "2. Utilizzo delle informazioni",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            SizedBox(height: 8),
            Text(
              "Le informazioni raccolte vengono utilizzate per:\n"
              "- Fornire, migliorare e personalizzare l'esperienza dell'utente all'interno dell'app.\n"
              "- Rispondere a richieste di supporto e feedback.\n"
              "- Inviare notifiche relative all'app, aggiornamenti o modifiche ai nostri servizi.\n"
              "- Monitorare l'uso dell'app e analizzare i dati per migliorare le prestazioni e risolvere eventuali problemi.\n\n",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "3. Condivisione delle informazioni",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            SizedBox(height: 8),
            Text(
              "Non vendiamo, affittiamo né condividiamo le informazioni personali con terze parti, ad eccezione dei seguenti casi:\n"
              "- Fornitori di servizi: Condivideremo le informazioni con i fornitori di servizi che ci aiutano a operare l'app, ma solo nella misura necessaria per adempiere ai loro compiti.\n"
              "- Requisiti legali: Potremmo divulgare le tue informazioni se richiesto dalla legge o se riteniamo che tale azione sia necessaria per conformarsi a un processo legale, per proteggere i nostri diritti o per proteggere la sicurezza degli utenti.\n\n",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "4. Sicurezza",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            SizedBox(height: 8),
            Text(
              "Adottiamo misure di sicurezza per proteggere le informazioni personali, ma nessun sistema di trasmissione o archiviazione di dati è completamente sicuro. Non possiamo garantire la sicurezza assoluta delle informazioni, quindi l'uso dell'app avviene a tuo rischio.\n\n",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "5. I tuoi diritti",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            SizedBox(height: 8),
            Text(
              "Hai il diritto di:\n"
              "- Accedere, correggere o cancellare le informazioni personali che ci hai fornito.\n"
              "- Richiedere una copia delle tue informazioni personali.\n"
              "- Ritirare il consenso in qualsiasi momento, se il trattamento delle informazioni si basa sul consenso.\n"
              "- Presentare un reclamo all'autorità di protezione dei dati.\n\n"
              "Se desideri esercitare uno di questi diritti, puoi contattarci utilizzando le informazioni di contatto fornite di seguito.\n\n",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "6. Modifiche alla Privacy Policy",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            SizedBox(height: 8),
            Text(
              "Ci riserviamo il diritto di modificare questa Privacy Policy in qualsiasi momento. Eventuali modifiche verranno pubblicate su questa pagina con la data dell'ultimo aggiornamento. Ti invitiamo a visitare questa pagina regolarmente per rimanere informato su come proteggiamo le tue informazioni.\n\n",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "7. Contatti",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            SizedBox(height: 8),
            Text(
              "Per domande relative alla nostra Privacy Policy, puoi contattarci all'indirizzo email: supporto@appname.com\n",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}