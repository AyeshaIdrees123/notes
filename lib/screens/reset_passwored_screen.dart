import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:notes/models/user.dart';

class ResetPassworedScreen extends StatefulWidget {
  const ResetPassworedScreen({super.key});

  @override
  State<ResetPassworedScreen> createState() => _ResetPassworedScreenState();
}
// comment test

class _ResetPassworedScreenState extends State<ResetPassworedScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();

  bool _isForgotPasswored = true;

  static final _firestore = FirebaseFirestore.instance;
  final _userRef = _firestore.collection("users").withConverter<UserModel>(
      fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
      toFirestore: (user, _) => user.toJson());

  String? _isEmailExist;

  Future<void> _sendEmailResetPassword(String email) async {
    Loader.show(context,
        overlayColor: Colors.grey.withOpacity(0.1),
        progressIndicator: const CircularProgressIndicator());

    try {
      final users =
          await _userRef.where('email', isEqualTo: email).limit(1).get();

      if (users.docs.isEmpty) {
        setState(() {
          _isEmailExist = 'User does not exist';
        });
      } else {
        setState(() {
          _isForgotPasswored = !_isForgotPasswored;
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("User does not exist");
        setState(() {
          _isEmailExist = 'User does not exist';
        });
      }
    }
    Loader.hide();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 100),
              Text(
                "Reset Passwored",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 60),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (_isForgotPasswored)
                      TextFormField(
                        onChanged: (x) {
                          setState(() {
                            _isEmailExist = null;
                          });
                        },
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(13)),
                          ),
                          hintText: "..@gmail.com",
                          hintStyle: TextStyle(
                            color: Color.fromARGB(255, 108, 105, 105),
                          ),
                          label: Text("Email"),
                        ),
                        validator: (value) {
                          if (value == null || value == '') {
                            return 'Please enter your email';
                          } else if (!value.contains('@') ||
                              !value.contains('.')) {
                            return 'Invalid email!';
                          } else {
                            return null;
                          }
                        },
                      ),
                    if (_isEmailExist != null)
                      Column(
                        children: [
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _isEmailExist!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              if (!_isForgotPasswored)
                const Text(
                  'Send a link for reset passwored\n on your email account.',
                ),
              const SizedBox(height: 30),
              if (_isForgotPasswored)
                SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await _sendEmailResetPassword(_emailController.text);
                        }
                      },
                      child: const Text(
                        'send',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    )),
              const SizedBox(height: 10),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Go to Back',
                    style: Theme.of(context).textTheme.titleMedium,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
