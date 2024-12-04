import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:notes/bloc/bloc/block_bloc.dart';
import 'package:notes/models/user.dart';
import 'package:notes/screens/notes_screen.dart';
import 'package:notes/screens/reset_passwored_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserCreds();
  }

  bool _isLogin = true;
  bool _isRememberMeSelected = true;
  final bool _isForgotPasswored = true;
  final _emailKey = 'email';
  final _passKey = 'pass';

  static final _firestore = FirebaseFirestore.instance;
  final _userRef = _firestore.collection("users").withConverter<UserModel>(
      fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
      toFirestore: (user, _) => user.toJson());

  String? _emailServerError;
  String? _loginError;
  String? _emailNotExist;

  void _navigateToDashboard() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const NotesScreen()));
  }

  void _signUp() async {
    Loader.show(context, progressIndicator: const CircularProgressIndicator());

    try {
      UserCredential userCredentials =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      final userId = userCredentials.user?.uid;

      if (userId != null) {
        final userDoc =
            _userRef.doc(userId); //create new if null or else fetches old
        final user = UserModel(
          id: userId,
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );
        Loader.show(context,
            progressIndicator: const CircularProgressIndicator());

        await userDoc.set(user);
        _navigateToDashboard();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      }
      if (e.code == 'email-already-in-use') {
        _emailServerError = 'The account already exists for that email.';
        setState(() {});
      }
    }
    Loader.hide();
  }

  Future<void> _logIn() async {
    Loader.show(context,
        overlayColor: Colors.grey.withOpacity(.1),
        progressIndicator: const CircularProgressIndicator());

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      _navigateToDashboard();
    } catch (e) {
      setState(() {
        _loginError = 'Invalid credentials';
      });
    }
    Loader.hide();
  }

  Future<void> _saveUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_emailKey, _emailController.text);
    prefs.setString(_passKey, _passwordController.text);
  }

  void _getUserCreds() async {
    final prefs = await SharedPreferences.getInstance();
    String email = prefs.getString(_emailKey) ?? '';
    String pass = prefs.getString(_passKey) ?? '';
    _emailController.text = email;
    _passwordController.text = pass;
  }

  final _formKey = GlobalKey<FormState>();

  InputDecoration decoration = const InputDecoration(
    border:
        OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(13))),
    hintStyle: TextStyle(
      color: Color.fromARGB(255, 214, 208, 208),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // BlocBuilder<ThemeBloc, ThemeMode>(
              //   builder: (ctx, state) {
              //     return Switch(
              //       value: state == ThemeMode.dark,
              //       onChanged: (newvalue) {
              //         ctx.read<ThemeBloc>().add(ToggelEvent());
              //       },
              //     );
              //   },
              // ),
              const SizedBox(height: 90),
              Text(
                _isLogin ? "Login" : "Signup",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 10),
              Text(
                _isLogin ? "Welcome back" : "Signup to get started",
              ),
              const SizedBox(height: 60),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // TextField(
                    //   decoration: InputDecoration(
                    //     hintText: 'aaaa',
                    //     labelText: "sss",
                    //     hintStyle: TextStyle(color: Colors.amber),
                    //   ),
                    // ),
                    if (!_isLogin)
                      TextFormField(
                        controller: _nameController,
                        decoration: decoration.copyWith(
                          hintText: 'Name',
                          label: const Text('Name'),
                        ),
                        validator: (value) {
                          if (value == null || value == '') {
                            return "Please enter your Name!";
                          } else if (value.length < 3) {
                            return "Please enter at least 3 letters";
                          } else if (value.length > 10) {
                            return "Not allowed to enter more than 30 letters";
                          } else {
                            return null;
                          }
                        },
                      ),
                    const SizedBox(height: 20),
                    TextFormField(
                      onChanged: (x) {
                        setState(() {
                          _loginError = null;
                          _emailServerError = null;
                        });
                      },
                      controller: _emailController,
                      decoration: decoration.copyWith(
                        hintText: '..@gmail.com',
                        label: const Text('Email'),
                      ),
                      validator: (value) {
                        if (_emailServerError != null) {
                          return _emailServerError;
                        }
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
                    if (_loginError != null)
                      Column(
                        children: [
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _emailNotExist!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    if (_emailServerError != null)
                      Column(
                        children: [
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _emailServerError!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    if (_isForgotPasswored)
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            _loginError = null;
                          });
                        },
                        controller: _passwordController,
                        obscureText: true,
                        decoration: decoration.copyWith(
                          hintText: '*******',
                          label: const Text('Passwored'),
                        ),
                        validator: (value) {
                          if (value == null || value == '') {
                            return 'Please enter your password';
                          }
                          if (value.length < 7) {
                            return 'Please enter atleast 7 digits for password!';
                          } else {
                            return null;
                          }
                        },
                      ),
                  ],
                ),
              ),
              if (_loginError != null)
                Column(
                  children: [
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _loginError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 10),
              if (_isLogin)
                if (_isForgotPasswored)
                  Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15)),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ResetPassworedScreen()));
                      },
                      child: Row(
                        children: [
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 0),
                            child: Text(
                              "Forgot password",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              if (_isForgotPasswored)
                Container(
                  width: 400,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15)),
                  child: TextButton(
                    onPressed: () {
                      _isRememberMeSelected = !_isRememberMeSelected;
                      setState(() {});
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Remember me",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.green),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Checkbox(
                          value: _isRememberMeSelected,
                          activeColor: const Color.fromARGB(255, 52, 131, 55),
                          onChanged: (newVal) {
                            setState(() {
                              _isRememberMeSelected = newVal!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                    style: Theme.of(context).elevatedButtonTheme.style,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_isRememberMeSelected) {
                          await _saveUserCredentials();
                        }

                        if (_isLogin) {
                          {
                            _logIn();
                          }
                        } else {
                          _signUp();
                        }
                      }
                    },
                    child: Text(
                      _isLogin ? "Login" : "Logout",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.white),
                    )),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  _isLogin = !_isLogin;

                  _nameController.clear();
                  _emailController.clear();
                  _passwordController.clear();
                  setState(() {});
                },
                child: InkWell(
                  borderRadius: BorderRadius.circular(13),
                  onTap: () {
                    _isLogin = !_isLogin;

                    _nameController.clear();
                    _emailController.clear();
                    _passwordController.clear();
                    setState(() {});
                  },
                  child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary),
                          borderRadius: BorderRadius.circular(13)),
                      // child: TextButton(
                      //     onPressed: () {
                      // _isLogin = !_isLogin;

                      // _nameController.clear();
                      // _emailController.clear();
                      // _passwordController.clear();
                      // setState(() {});
                      //     },
                      child: Center(
                        child: Text(
                          _isLogin ? "Creat New Account" : "Go back to Login",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 16),
                        ),
                      )),
                ),
              ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
