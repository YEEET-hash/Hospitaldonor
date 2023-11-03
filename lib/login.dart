import 'package:flutter/material.dart';
import 'package:DonorConnect/home.dart';
import 'main.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  TextEditingController un = TextEditingController();
  TextEditingController ps = TextEditingController();

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
              // padding: const EdgeInsets.only(left: 37, top: 130),
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
                // Wrap SingleChildScrollView with Expanded
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
                          height: 120,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            String eun = un.text;
                            String eps = ps.text;

                            if (eun == 'admin' && eps == 'srec@123') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Home(),
                                ),
                              );
                            } else {
                              // Display an error message
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Error'),
                                    content:
                                        Text('Username/Password is wrong.'),
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
                          },
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
