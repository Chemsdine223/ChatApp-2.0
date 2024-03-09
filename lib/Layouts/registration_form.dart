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
  String phoneError = '';
  String usernameError = '';
  String firstnmaeError = '';
  String lastnameError = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationFormCubit, FormData>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
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
                    style: const TextStyle(color: Colors.black87),
                    initialValue: state.username,
                    cursorColor: Colors.greenAccent,
                    decoration: const InputDecoration(
                      // color
                      hintText: 'Enter your username',
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          usernameError = 'Enter a username';
                        });
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        usernameError = '';
                        state.username = value;
                      });
                    },
                  ),
                ),
                usernameError.isNotEmpty
                    ? _errorText(context, usernameError)
                    : Container(),
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
                    keyboardType: TextInputType.number,
                    maxLength: 8,
                    style: const TextStyle(color: Colors.black87),
                    initialValue: state.phone,
                    cursorColor: Colors.greenAccent,
                    decoration: const InputDecoration(
                      counterText: '',
                      hintText: 'Enter your phone',
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          phoneError = 'Enter a phone number !';
                        });
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        phoneError = '';
                        state.phone = value;
                      });
                    },
                  ),
                ),
                phoneError.isNotEmpty
                    ? _errorText(context, 'Enter your phone number')
                    : Container(),
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
                    style: const TextStyle(color: Colors.black87),
                    initialValue: state.firstname,
                    cursorColor: Colors.greenAccent,
                    decoration: const InputDecoration(
                      hintText: 'Enter your firstname',
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          firstnmaeError = 'Enter your firstname';
                        });
                      }
                      return null;
                    },
                    onChanged: (value) {
                      // print(value);
                      setState(() {
                        firstnmaeError = '';
                        state.firstname = value;
                      });
                      // print(state.)
                    },
                  ),
                ),
                firstnmaeError.isNotEmpty
                    ? _errorText(context, firstnmaeError)
                    : Container(),
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
                    style: const TextStyle(color: Colors.black87),
                    initialValue: state.lastname,
                    cursorColor: Colors.greenAccent,
                    decoration: const InputDecoration(
                      hintText: 'Enter your lastname',
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          lastnameError = 'Enter you lastname';
                        });
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        lastnameError = '';
                        state.lastname = value;
                      });
                    },
                  ),
                ),
                lastnameError.isNotEmpty
                    ? _errorText(context, lastnameError)
                    : Container(),
                const SizedBox(
                  height: 16,
                ),
                CustomButton(
                  // color: Theme.of(context).colorScheme.onError,
                  label: 'Next',
                  onTap: () {
                    // print(state.firstname);
                    if (_formKey.currentState!.validate() &&
                        phoneError.isEmpty &&
                        usernameError.isEmpty &&
                        firstnmaeError.isEmpty &&
                        lastnameError.isEmpty) {
                      context.read<RegistrationFormCubit>().nextStep(
                            state.firstname,
                            state.lastname,
                            state.phone,
                            state.username,
                          );
                    }
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Padding _errorText(BuildContext context, String errorText) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            errorText,
            textAlign: TextAlign.start,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Theme.of(context).colorScheme.error),
          ),
        ],
      ),
    );
  }
}
