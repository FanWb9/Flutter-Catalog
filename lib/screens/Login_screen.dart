import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/api_services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dashboard_screen.dart';
import 'Register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiServices apiServices = ApiServices();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId: dotenv.env['GOOGLE_SERVER_CLIENT_ID'],
  );
  bool isLoading = false;
  bool _openPassword = true;
  
  Future<void> _handleGoogleSignIn() async {
  try {
    setState(() => isLoading = true);

    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      print("Google Sign-In dibatalkan oleh pengguna.");
      return;
    }

    print("Google Signed In: ${googleUser.email}, Name: ${googleUser.displayName}");

    final response = await apiServices.googleAPI(
      googleUser.email,
      googleUser.displayName ?? "",
    );

    if (response != null) {
      print("Response dari backend: $response");

      if (response["token"] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", response["token"]);

        print("Token berhasil disimpan: ${response["token"]}");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => DashboardScreen()),
        );
      } else {
        print("Login gagal: Tidak ada token dalam response.");
      }
    } else {
      print("Login gagal: Response dari backend NULL.");
    }
  } catch (error) {
    print("Google Sign-In Error: $error");
  } finally {
    setState(() => isLoading = false);
  }
}

  Future<void> _login() async {
    setState(() => isLoading = true);
    final result = await apiServices.login(
      emailController.text,
      passwordController.text,
    );
    setState(() => isLoading = false);

    if (result != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DashboardScreen()),
      );
    } else {
      print("Login Gagal");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login gagal, periksa kembali email & password"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Welcome Back!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: passwordController,

                    obscureText: _openPassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _openPassword = !_openPassword;
                          });
                        },
                        icon: Icon(
                          _openPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Tombol Login
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 14,
                        ),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child:
                          isLoading
                              ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Garis dengan teks "OR"
                  Row(
                    children: [
                      Expanded(
                        child: Divider(thickness: 1, color: Colors.grey),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "OR",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(thickness: 1, color: Colors.grey),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Tombol Google Sign-In
                    Align(
                    alignment: Alignment.center,
                    child: SignInButton(
                      Buttons.Google,
                      text: "Sign in with Google",
                      onPressed: _handleGoogleSignIn,
                    ),
                    ),

                  SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Belum punya akun?", style: TextStyle(fontSize: 14)),
                      TextButton(
                        onPressed:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RegisterScreen(),
                              ),
                            ),
                        child: Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
