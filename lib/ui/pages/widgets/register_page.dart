import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/ui/pages/viewmodel/register_view_model.dart';
import 'login_page.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegisterViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("PongChamp", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.yellow,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        toolbarHeight: 130,
        centerTitle: true,
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
                TextField(
                  decoration: InputDecoration(
                    labelText: "Name",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Surname",
                    prefixIcon: Icon(Icons.person),
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
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () async {
                    final success = await viewModel.register(
                      _emailController.text,
                      _passwordController.text,
                    );
                    if (success) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => LoginPage()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text("Sign Up", style: TextStyle(fontSize: 18, color: Colors.yellow)),
                ),
                if (viewModel.errorMessage != null) ...[
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
