import 'package:chat_app/Logic/Cubit/RegistrationFormCubit/registration_form_cubit.dart';
import 'package:chat_app/Widgets/info_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../Logic/Cubit/Authentication/auth_cubit.dart';
import '../Widgets/custom_button.dart';

class ConfirmationLayout extends StatefulWidget {
  const ConfirmationLayout({super.key});

  @override
  State<ConfirmationLayout> createState() => _ConfirmationLayoutState();
}

class _ConfirmationLayoutState extends State<ConfirmationLayout> {
  final picker = ImagePicker();
  XFile? avatar;
  String imagePath = '';
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationFormCubit, RegistrationFormState>(
      builder: (context, state) {
        if (state is RegistrationFormStepTwo) {
          return Column(
            children: [
              // FloatingActionButton(
              //   onPressed: () {
              //     NetworkServices().uploadAvatar(avatar);
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
                    print(avatar!.path);
                  } else {
                    // Handle the case where no image was picked.
                    print('No image picked');
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
                              backgroundImage: AssetImage(imagePath),
                              backgroundColor: Colors.grey.shade400,
                            )
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
                          avatar,
                        );
                  },
                  label: 'Register',
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
