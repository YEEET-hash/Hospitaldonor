import 'package:flutter/material.dart';
import 'package:DonorConnect/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  State<MyLogin> createState() => _MyLoginState();
}

//ass
class _MyLoginState extends State<MyLogin> {
  TextEditingController un = TextEditingController();
  TextEditingController ps = TextEditingController();

  Future<void> _loginUser() async {
    String eun = un.text;
    String eps = ps.text;

    if (eun.isNotEmpty && eps.isNotEmpty) {
      try {
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: eun,
          password: eps,
        );

        if (userCredential.user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        // Handle Firebase Authentication errors
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(e.message ?? 'An error occurred'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Handle the case where eun or eps is empty
      print("Email and/or Password is empty");
    }
  }

  Future<void> _resetPassword() async {
    String email = un.text;

    if (email.isNotEmpty) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        // Show a success message or navigate to a success screen.
      } on FirebaseAuthException catch (e) {
        // Handle Firebase Authentication errors
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(e.message ?? 'An error occurred'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Handle the case where the email is empty
      print("Email is empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/heart.gif'),
          fit: BoxFit.fitWidth,
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Center(
                child: Text(
                  'SREC DonorConnect',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.20,
                      right: 35,
                      left: 35,
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: un,
                          decoration: InputDecoration(
                            fillColor: Colors.red.shade300,
                            filled: true,
                            hintText: 'User Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextField(
                          controller: ps,
                          obscureText: true,
                          decoration: InputDecoration(
                            fillColor: Colors.red.shade300,
                            filled: true,
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                          onPressed: _resetPassword,
                          child: Text('Forgot Password?'),
                        ),
                        ElevatedButton(
                          onPressed: _loginUser,
                          child: const Text('Log in'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Powered by GDD",
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
