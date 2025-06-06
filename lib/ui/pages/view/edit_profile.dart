import 'dart:io';
import 'package:PongChamp/data/services/auth_service.dart';
import 'package:PongChamp/data/services/uploadImage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '/ui/pages/viewmodel/edit_profile_view_model.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _profileImageController = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();
  final AuthService _authService = AuthService();
  final ImageService _imageService = ImageService();


  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      String? imageUrl = await _imageService.uploadImage(_image!);
      if (imageUrl != null) {
        _profileImageController.text = imageUrl;
      } else {
        print("Impossibile caricare l'immagine.");
      }
    }
  }

  Future<void> _loadUserData() async {
    final viewModel = Provider.of<EditProfileViewModel>(context, listen: false);
    final String userId = _authService.currentUserId!;

    try {
      final data = await viewModel.getDataFromUserDoc(userId);
      setState(() {
        _nameController.text = data['name'] ?? '';
        _surnameController.text = data['surname'] ?? '';
        _phoneNumberController.text = data['phoneNumber'] ?? '';
        _emailController.text = data['email'] ?? '';
        _passwordController.text = data['password'] ?? '';
        _profileImageController.text = data['profileImage'] ?? '';
        _nicknameController.text = data['nickname'] ?? '';
      });
    } catch (e) {
      print("Errore nel caricamento dati utente: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    final EditProfileViewModel _viewModel = Provider.of<EditProfileViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 130,
        title: Text("Edit Profile", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(255, 245, 192, 41),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : (_profileImageController.text.isNotEmpty
                            ? NetworkImage(_profileImageController.text)
                            : AssetImage('assets/default_profile.png')) as ImageProvider,
                    child: _image == null && _profileImageController.text.isEmpty
                        ? Icon(Icons.camera_alt, size: 30, color: Colors.white)
                        : null,
                  ),
                ),
                SizedBox(height: 15),
                buildTextField("Name", _nameController, Icons.person),
                buildTextField("Surname", _surnameController, Icons.person),
                buildTextField("Nickname", _nicknameController, Icons.person),
                buildTextField("Phone Number", _phoneNumberController, Icons.phone),
                buildTextField("Email", _emailController, Icons.email),
                buildTextField("Password", _passwordController, Icons.lock, isPassword: true),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () async {
                    print("Salvo con image URL: ${_profileImageController.text}");

                    final success = await _viewModel.updateUserData(
                      _authService.currentUserId!,
                        _nameController.text,
                        _surnameController.text,
                        _nicknameController.text,
                        _phoneNumberController.text,
                        _emailController.text,
                        _passwordController.text,
                        _profileImageController.text,
                    );

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Profile updated successfully!")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Update failed.")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // ridotto
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Save Changes",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 245, 192, 41),
                  ),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, IconData icon, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }



  
}
