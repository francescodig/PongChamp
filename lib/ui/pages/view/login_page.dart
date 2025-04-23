import 'package:PongChamp/ui/pages/view/map_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/ui/pages/viewmodel/login_view_model.dart';
import '/data/services/auth_service.dart';
import 'register_page.dart';
import 'home_page.dart';
import 'map_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(AuthService()),
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, child) => WillPopScope(
          onWillPop: () async {
            final shouldLeave = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Are you sure?', style: TextStyle(fontSize: 20, color: Colors.yellow)),
                content: Text('Do you want to quit PongChamp?', style: TextStyle(fontSize: 15, color: Colors.yellow)),
                backgroundColor: Colors.black,
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.white)),
                    child: Text('No', style: TextStyle(fontSize: 10, color: Colors.black)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.white)),
                    child: Text('Sì', style: TextStyle(fontSize: 10, color: Colors.black)),
                  ),
                ],
              ),
            );
            return shouldLeave ?? false;
          },
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              toolbarHeight: 130,
              title: Text("PongChamp", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              backgroundColor: Colors.yellow,
            ),
            body: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Login", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text("Enter your email to login for this app", style: TextStyle(fontSize: 16, color: Colors.grey)),
                      SizedBox(height: 30),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          prefixIcon: Icon(Icons.lock),
                        ),
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text("Forgot password?", style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      if (viewModel.errorMessage.isNotEmpty)
                        Text(viewModel.errorMessage, style: TextStyle(color: Colors.red)),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          final success = await viewModel.login(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          );
                          if (success) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => HomePage()),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text("Sign In", style: TextStyle(fontSize: 18, color: Colors.yellow)),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text("Sign Up", style: TextStyle(fontSize: 18, color: Colors.black)),
                      ),
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
          ),
        ),
      ),
    );
  }
}
