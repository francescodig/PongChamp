import '/ui/pages/view/informazioni_page.dart';
import '/ui/pages/view/legal_notes_page.dart';
import '/ui/pages/view/login_page.dart';
import '/ui/pages/view/privacy_page.dart';
import 'package:flutter/material.dart';
import '/ui/pages/view/profile_page.dart';
import '/ui/pages/widgets/bottom_navbar.dart';
import '/ui/pages/widgets/app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView( // ✅ rende scrollabile il contenuto
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Impostazioni",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildSettingRow(
                    context,
                    label: "Informazioni App",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PrivacyPage()),
                    ),
                  ),
                  _buildSettingRow(
                    context,
                    label: "Modifica Profilo",
                    onTap: () {
                      final userId = FirebaseAuth.instance.currentUser?.uid;
                      if (userId != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ProfilePage(userId: userId)),
                        );
                      }
                    },
                  ),
                  _buildSettingRow(context, label: "Lingua", onTap: () {}),
                  _buildSettingRow(
                    context,
                    label: "Note Legali",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LegalNotesPage()),
                    ),
                  ),
                  _buildSettingRow(
                    context,
                    label: "Privacy",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => InformazioniPage()),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut().then((_) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => LoginPage()),
                          );
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Log out'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(),
    );
  }

  Widget _buildSettingRow(BuildContext context, {required String label, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          IconButton(
            onPressed: onTap,
            icon: const Icon(Icons.arrow_right, size: 30),
          ),
        ],
      ),
    );
  }
}

