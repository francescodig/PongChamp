import 'package:PongChamp/data/services/auth_service.dart';
import 'package:PongChamp/data/services/uploadImage_service.dart';
import 'package:PongChamp/ui/pages/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '/ui/pages/viewmodel/register_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class RegisterPage extends StatefulWidget {


   @override
  _RegisterPageState createState() => _RegisterPageState();

}


class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _profileImageController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  String? selectedSex; // Variabile per memorizzare il sesso selezionato
  File? _image; // Variabile per memorizzare l'immagine selezionata
  bool _obscurePassword = true;
  final ImageService _imageService = ImageService();
  final AuthService _authService = AuthService(); // Inizializza il servizio di autenticazione

  final ImagePicker _picker = ImagePicker(); // Inizializza l'ImagePicker

   // Funzione per selezionare l'immagine dalla galleria
  Future<void> _pickImage() async {
    PermissionStatus permissionStatus; 
    
    
    if(Platform.isIOS){
      permissionStatus = await Permission.photos.request();
     } else{
      permissionStatus = await Permission.storage.request();
    }
    
    if(permissionStatus.isGranted){
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery); // Mostra la galleria per selezionare l'immagine

      if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Aggiorna l'immagine con quella selezionata
      });
        // Carica l'immagine su Firebase Storage e ottieni l'URL
      String? imageUrl = await _imageService.uploadImage(_image!); // Carica l'immagine e ottieni l'URL
      print("URL dell'immagine: $imageUrl"); // Stampa l'URL dell'immagine DEBUG
      if (imageUrl != null) {
        // Aggiorna il controller con l'URL dell'immagine
        _profileImageController.text = imageUrl;
        print("URL dell'immagine caricato: ${_profileImageController.text}"); // Stampa l'URL dell'immagine caricato DEBUG
      } else {
        // Gestisci il caso in cui il caricamento fallisce
        print("Impossibile caricare l'immagine.");
      }

    } else if (permissionStatus.isPermanentlyDenied){
       // Se il permesso è stato negato in modo permanente
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Permesso per accedere alla galleria negato. Abilitalo dalle impostazioni."),
        action: SnackBarAction(
          label: "Apri Impostazioni",
          onPressed: () {
            openAppSettings(); // Apre le impostazioni dell'app
          },
        ),
      ),
    );
  } else {
    // Permesso negato ma non permanente
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Permesso per accedere alla galleria necessario per selezionare un'immagine.")),
    );

    }

    



    }
  }




  





  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegisterViewModel>(context);
    

    return Scaffold(
      appBar: AppBar(
              centerTitle: true,
              toolbarHeight: 130,
              title: Text("PongChamp", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              backgroundColor: Color.fromARGB(255, 245, 192, 41),
            ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("Sign Up", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text("Enter your data to sign up for this app", style: TextStyle(fontSize: 16, color: Colors.grey)),
                SizedBox(height: 15),
                // CircleAvatar cliccabile per la selezione dell'immagine
                GestureDetector(
                  onTap: _pickImage, // Quando l'utente clicca, si apre la galleria
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _image != null ? FileImage(_image!) : AssetImage('assets/default_profile.png') as ImageProvider, // Mostra l'immagine selezionata o quella di default
                    child: _image == null ? Icon(Icons.camera_alt, size: 30, color: Colors.white) : null, // Mostra l'icona se nessuna immagine è selezionata
                  ),
                ),
                SizedBox(height: 15),

                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _surnameController,
                  decoration: InputDecoration(
                    labelText: "Surname",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 15),
                DropdownButtonFormField<String>(
                value: selectedSex, //mostra il valore selezionato attualmente
                onChanged: (String? newValue) {
                  selectedSex = newValue!;
                },
                items: ['Male', 'Female']
                    .map((sex) => DropdownMenuItem(
                          value: sex, //valore che viene passato quando l'elemento viene selezionato
                          child: Text(sex), //testo che viene mostrato nell'elenco a discesa
                        ))
                    .toList(), 
                decoration: InputDecoration(
                  labelText: "Sex",
                  prefixIcon: Icon(Icons.wc),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
                SizedBox(height: 15),
                TextField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    PhoneInputFormatter(), // formatter dinamico internazionale
                  ],
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    prefixIcon: Icon(Icons.phone),
                    hintText: "+39 345 123 4567", // esempio con prefisso
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                  SizedBox(height: 15),
                TextField(
                  controller: _nicknameController,
                  decoration: InputDecoration(
                    labelText: "Nickname",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                controller: _birthdayController,
                readOnly: true, // Impedisce la modifica manuale del campo
                onTap: () async {
                  final DateTime? picked = await showDatePicker( // Mostra il selettore di data
                    context: context, 
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) { // Se una data è stata selezionata
                    _birthdayController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}"; // Formatta la data come stringa
                  }
                },
                decoration: InputDecoration(
                  labelText: "Date of Birth",
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
                SizedBox(height: 15),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),

                SizedBox(height: 15),
                viewModel.isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      if (selectedSex == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please select your sex"))
                        );
                        return;
                      }

                      final success = await viewModel.register(
                        _emailController.text,
                        _passwordController.text,
                        _nameController.text,
                        _surnameController.text,
                        _nicknameController.text,
                        _phoneNumberController.text,
                        selectedSex!,
                        _birthdayController.text,
                        _profileImageController.text,
                      );

                      if (success) {
                        final currentUserId = _authService.currentUserId;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => HomePage(currentUserId: currentUserId)),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text("Sign Up", style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 245, 192, 41))),
                  ),
                if (viewModel.errorMessage != null)...[
                  SizedBox(height: 10),
                  Text(viewModel.errorMessage!, style: TextStyle(color: Colors.red)),
                ],
                SizedBox(height: 20),
                Text(
                  "By clicking continue, you agree to our Terms of Service and Privacy Policy",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

