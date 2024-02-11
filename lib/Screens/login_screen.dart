import 'package:chat_app/Logic/Cubit/Authentication/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import '../Logic/Models/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _firstname = TextEditingController();
  final _lastname = TextEditingController();
  final _phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
          backgroundColor: Colors.grey.shade900,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'ChatApp',
                style: TextStyle(
                    shadows: [
                      BoxShadow(
                        // blurRadius: .5,
                        color: Colors.black38,
                        offset: Offset(1, .5),
                      )
                    ],
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                width: 5,
              ),
              Image.asset(
                'images/live-chat.png',
                height: 36,
              ),
            ],
          )),

      // backgroundColor: Colors.grey[900],
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment. d,
            children: [
              const SizedBox(
                height: 140,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade600),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade300,
                ),
                child: TextFormField(
                  cursorColor: Colors.greenAccent,
                  decoration: const InputDecoration(
                    hintText: 'Enter your username',
                    border: InputBorder.none,
                  ),
                  controller: _username,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade600),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade300,
                ),
                child: TextFormField(
                  cursorColor: Colors.greenAccent,
                  decoration: const InputDecoration(
                    hintText: 'Enter your phone',
                    border: InputBorder.none,
                  ),
                  controller: _phone,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade600),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade300,
                ),
                child: TextFormField(
                  cursorColor: Colors.greenAccent,
                  decoration: const InputDecoration(
                    hintText: 'Enter your firstname',
                    border: InputBorder.none,
                  ),
                  controller: _firstname,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade600),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade300,
                ),
                child: TextFormField(
                  cursorColor: Colors.greenAccent,
                  decoration: const InputDecoration(
                    hintText: 'Enter your lastname',
                    border: InputBorder.none,
                  ),
                  controller: _lastname,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () => context.read<AuthCubit>().register(
                      _username.text,
                      _firstname.text,
                      _lastname.text,
                      _phone.text,
                    ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        height: 40,
                        child: const Center(
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
