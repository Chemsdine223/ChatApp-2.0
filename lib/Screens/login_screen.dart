import 'dart:developer';

import 'package:chat_app/Layouts/confirmation_form.dart';
import 'package:chat_app/Layouts/registration_form.dart';
import 'package:chat_app/Logic/Cubit/RegistrationFormCubit/registration_form_cubit.dart';
import 'package:chat_app/Logic/Network/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../Providers/provider.dart';

// import '../Logic/Models/user.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final picker = ImagePicker();
  XFile? screenShot;
  String imagePath = '';

  final sr = SocketService();

  // @override
  // void initState() {
  //   SocketService().disconnectSocket();
  //   super.initState();
  // }

  // int currentState = 0;

  @override
  Widget build(BuildContext context) {
    ref.watch(providerOfSocket);

    // ref.watch(provider);
    // final prov = ref.watch(streamRepositoryProvider);
    // print(prov);

    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     // SocketService.socket = null;
      //     // sr.initOrResetSocket('3', '5');
      //     // socketService.socket.clearListeners();
      //     // IO.Socket socket = IO.io(
      //     //     'http://localhost:5000',
      //     //     OptionBuilder().setTransports(['websocket']).setExtraHeaders(
      //     //       {
      //     //         // ignore: unnecessary_string_interpolations
      //     //         "id": "22",
      //     //         // ignore: unnecessary_string_interpolations
      //     //         "key": "22"
      //     //       },
      //     //     ).build());

      //     // // SocketService.socket = socket;

      //     // socketService.updateSocket(socket);

      //     // NetworkServices.id = '6';
      //     // print('initial ${MyClass.s}');
      //     // // MyClass.s;
      //     // NetworkServices.id = '4';
      //     // print(NetworkServices.id); // This will print '3'.
      //     // print('Latest ${MyClass.s}');
      //     // print(MyClass.s);
      //     // print(NetworkServices.id);
      //     // print(s);

      //     // s = 'hello';
      //     // // print(s);
      //     // s = 'hi1';
      //     // print(s);
      //     // SocketService().initConnection();
      //     // final id = PreferenceUtils.getString('key');
      //     // log(id);
      //     // context.read<RegistrationFormCubit>().resetForm();

      //     // preferences.clear();
      //   },
      // ),
      // backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        // backgroundColor: Colors.grey.shade900,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // FloatingActionButton(
            //   onPressed: () {
            //     // sr.resetSocket();
            //   },
            // ),
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

      // backgroundColor: Colors.grey[900],
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
