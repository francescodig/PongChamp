import 'package:PongChamp/ui/pages/view/forgot_password_page.dart';
import 'package:PongChamp/ui/pages/viewmodel/register_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/ui/pages/viewmodel/login_view_model.dart';
import '/data/services/auth_service.dart';
import 'register_page.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  AuthService _authService = AuthService();

  late final String currentUserId;


  Future<bool> _onWillPop() async {
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?', style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 245, 192, 41))),
        content: Text('Do you want to quit PongChamp?', style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 245, 192, 41))),
        backgroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.white)),
            child: Text('No', style: TextStyle(fontSize: 12, color: Colors.black)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.white)),
            child: Text('Sì', style: TextStyle(fontSize: 12, color: Colors.black)),
          ),
        ],
      ),
    );
    return shouldLeave ?? false;
  }

  Future<void> _handleLogin(LoginViewModel viewModel) async {
    setState(() => _isLoading = true);
    
    final success = await viewModel.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    
    if (mounted) {
      setState(() => _isLoading = false);
      
      if (success) {

        currentUserId = _authService.currentUserId!;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(currentUserId: currentUserId)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(AuthService()),
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, child) => WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 150,
              centerTitle: true,
              backgroundColor: Color.fromARGB(255, 245, 192, 41),
              title: SizedBox(
                height: 100,
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
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                            );
                          },
                          child: Text("Forgot/Reset password", style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      if (viewModel.errorMessage.isNotEmpty)
                        Text(viewModel.errorMessage, style: TextStyle(color: Colors.red)),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isLoading ? null : () => _handleLogin(viewModel),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: _isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 245, 192, 41)),
                              ),
                            )
                          : Text("Sign In", style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 245, 192, 41))),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChangeNotifierProvider(
                                      create: (_) => RegisterViewModel(),
                                      child: RegisterPage(),
                                    ),
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 245, 192, 41),
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