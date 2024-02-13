import 'package:chat_app/Layouts/confirmation_form.dart';
import 'package:chat_app/Layouts/registration_form.dart';
import 'package:chat_app/Logic/Cubit/RegistrationFormCubit/registration_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

// import '../Logic/Models/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final picker = ImagePicker();
  XFile? screenShot;
  String imagePath = '';

  // int currentState = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     SocketService().initConnection();
      //   },
      // ),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<RegistrationFormCubit, RegistrationFormState>(
          builder: (context, state) {
            if (state is RegistrationFormStepTwo) {
              return const ConfirmationLayout();
            } else {
              return const RegistrationForm();
            }
          },
        ),
      ),
    );
  }
}
