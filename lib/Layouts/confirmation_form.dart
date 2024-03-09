import 'dart:developer';

import 'dart:io';

import 'package:chat_app/Logic/Cubit/RegistrationFormCubit/registration_form_cubit.dart';

import 'package:chat_app/Widgets/info_tile.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../Logic/Cubit/Authentication/auth_cubit.dart';
import '../Widgets/custom_button.dart';

class ConfirmationLayout extends ConsumerStatefulWidget {
  const ConfirmationLayout({super.key});

  @override
  ConsumerState<ConfirmationLayout> createState() => _ConfirmationLayoutState();
}

class _ConfirmationLayoutState extends ConsumerState<ConfirmationLayout> {
  final picker = ImagePicker();
  XFile? avatar;
  String imagePath = '';
  @override
  Widget build(
    BuildContext context,
  ) {
    return BlocBuilder<RegistrationFormCubit, FormData>(
      builder: (context, state) {
        // if (state is RegistrationFormStepTwo) {
        return SingleChildScrollView(
          child: Column(
            children: [
              // FloatingActionButton(
              //   onPressed: () async {
              //     if (avatar != null) {
              //       final downloadUrl =
              //           await FirebaseStorageService.uploadImageToFirebase(
              //         File(avatar!.path),
              //         DateTime.now().toString(),
              //       );
              //       logger.f(downloadUrl);
              //     }
              //   },

              // ),
              GestureDetector(
                onTap: () async {
                  final XFile? imagePicked =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (imagePicked != null) {
                    setState(() {
                      avatar = imagePicked;
                      imagePath = imagePicked.path;
                    });
                    log(avatar!.path);
                  } else {
                    // Handle the case where no image was picked.
                    log('No image picked');
                  }
                },
                child: SizedBox(
                  height: 120,
                  width: 100,
                  // color: Colors.red,
                  child: Column(
                    children: [
                      imagePath.isEmpty
                          ? const Stack(
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.green,
                                  child: Icon(Icons.person_2_rounded),
                                ),
                                SizedBox(
                                  width: 100,
                                  height: 108,
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Icon(
                                      Icons.add_circle,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : CircleAvatar(
                              radius: 60,
                              backgroundImage: FileImage(File(imagePath)),
                              backgroundColor: Colors.grey.shade400,
                            ),

                      // Container(
                      //     height: 100,
                      //     width: 100,

                      //     decoration: BoxDecoration(
                      //       color: Colors.grey.shade400,
                      //       shape: BoxShape.circle,
                      //       image: DecorationImage(
                      //         image: AssetImage(imagePath),
                      //         fit: BoxFit.fill,
                      //       ),
                      //     ),
                      //     // child: Image.file(
                      //     //   File(imagePath),
                      //     //   fit: BoxFit.fill,
                      //     // ),
                      //   ),
                    ],
                  ),
                ),
                // child: imagePath.isEmpty
                //     ? Image.asset(
                //         'Img/photo.png',
                //         height:
                //             MediaQuery.of(context).size.height / 10,
                //       )
                //     : Image.file(
                //         File(imagePath),
                //         fit: BoxFit.cover,
                //       ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    InfoTile(
                        label: 'Username',
                        value: state.username,
                        isLast: false),
                    InfoTile(
                        label: 'Firstname',
                        value: state.firstname,
                        isLast: false),
                    InfoTile(
                        label: 'Last name',
                        value: state.lastname,
                        isLast: false),
                    InfoTile(label: 'Phone', value: state.phone, isLast: true),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {},
                // onTap: () => context.read<AuthenticationCubit>().register(
                //       _username.text,
                //       _firstname.text,
                //       _lastname.text,
                //       _phone.text,
                //     ),
                child: CustomButton(
                  onTap: () {
                    context.read<AuthenticationCubit>().register(
                          state.username,
                          state.firstname,
                          state.lastname,
                          state.phone,
                          File(avatar!.path),
                          // ref,

                          // avatar,
                        );
                  },
                  label: 'Register',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomButton(
                onTap: () async {
                  context.read<RegistrationFormCubit>().previousStep(
                        state.username,
                        state.firstname,
                        state.lastname,
                        state.phone,
                      );
                },
                label: 'Previous',
              ),
            ],
          ),
        );
      },
    );
  }
}
