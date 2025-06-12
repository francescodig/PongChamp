import 'package:PongChamp/ui/pages/view/login_page.dart';
import 'package:PongChamp/ui/pages/viewmodel/forgot_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/data/services/auth_service.dart';



class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
   

  @override
  Widget build(BuildContext context) {

    
return ChangeNotifierProvider(
      create: (_) => ForgotPasswordViewModel(AuthService()),
      child: Consumer<ForgotPasswordViewModel>(
        builder: (context, viewModel, child) {
         return Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: 150, // altezza personalizzata della AppBar
                centerTitle: true,
                backgroundColor: Color.fromARGB(255, 245, 192, 41),
                title: SizedBox(
                  height: 100, // altezza del logo
                  child: Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
            ),
            body: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Forgot Password", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text("Enter your email to restore your password", style: TextStyle(fontSize: 16, color: Colors.grey)),
                      SizedBox(height: 30),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      SizedBox(height: 10),
                      if (viewModel.errorMessage != null)
                       Text(
                          viewModel.errorMessage!,
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
        


                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          final success = await viewModel.sendResetEmail(
                            _emailController.text.trim(),
                          );
                          if (success) {
                           Text("Email sent successfully", style: TextStyle(color: Colors.green, fontSize: 16));
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text("Restore Password", style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 245, 192, 41))),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


