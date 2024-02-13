import 'package:chat_app/Logic/Cubit/RegistrationFormCubit/registration_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Widgets/custom_button.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _firstname = TextEditingController();
  final _lastname = TextEditingController();
  final _phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
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
          CustomButton(
            label: 'Next',
            onTap: () {
              context.read<RegistrationFormCubit>().stepTwo(
                  _firstname.text, _lastname.text, _phone.text, _username.text);
            },
          )
        ],
      ),
    );
  }
}
