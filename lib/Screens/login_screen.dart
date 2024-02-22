import 'dart:developer';

import 'package:chat_app/Layouts/confirmation_form.dart';
import 'package:chat_app/Layouts/registration_form.dart';
import 'package:chat_app/Logic/Cubit/RegistrationFormCubit/registration_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../Providers/provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final picker = ImagePicker();
  XFile? screenShot;
  String imagePath = '';

  // final sr = SocketService();

  // @override
  // void initState() {
  //   SocketService().disconnectSocket();
  //   super.initState();
  // }

  // int currentState = 0;

  @override
  Widget build(BuildContext context) {
    ref.watch(provider.providerOfSocket);

    // ref.watch(provider);
    // final prov = ref.watch(streamRepositoryProvider);
    // print(prov);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'ChatApp',
            ),
            const SizedBox(
              width: 5,
            ),
            Image.asset(
              'images/live-chat.png',
              height: 36,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<RegistrationFormCubit, FormData>(
          builder: (context, state) {
            log(state.step.toString());
            if (state.step == 1) {
              return const ConfirmationLayout();
            } else if (state.step == 0) {
              return const RegistrationForm();
            }
            return Container();
          },
        ),
      ),
    );
  }
}
