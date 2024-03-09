import 'dart:developer';
import 'dart:io';

import 'package:chat_app/Constants/constants.dart';
import 'package:chat_app/Logic/Cubit/Authentication/auth_cubit.dart';
import 'package:chat_app/Logic/Cubit/ConversationsCubit/conversations_cubit.dart';
import 'package:chat_app/Logic/Cubit/DeleteUser/delete_user_cubit.dart';
import 'package:chat_app/Network/firebase_storage_service.dart';
import 'package:chat_app/Theme/theme_cubit.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../Logic/Cubit/RegistrationFormCubit/registration_form_cubit.dart';
import '../Network/network_services.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/overlay.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final picker = ImagePicker();
  XFile? avatar;
  String imagePath = '';

  UploadTask? uploadTask;

  String usernameError = '';
  String phone = '';

  String title = 'Settings';
  bool isBottomSheetShowing = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        logger.d(state);
        // log(state.toString());
        return BlocBuilder<DeleteUserCubit, DeleteUserState>(
          builder: (context, state) {
            logger.d(state);
            return Stack(
              children: [
                Scaffold(
                  appBar: state is AuthenticationLoading
                      ? null
                      : AppBar(
                          automaticallyImplyLeading:
                              isBottomSheetShowing ? false : true,
                          // state is AuthenticationLoading ? false : true,
                          // leading: state is AuthenticationLoading
                          //     ? null
                          //     : Container(),
                          actions: isBottomSheetShowing
                              ? [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        setState(() {
                                          title = 'Settings';
                                          isBottomSheetShowing = false;
                                        });
                                      },
                                      icon: const Icon(Icons.close))
                                  // Icon(Icons.close),
                                ]
                              : null,
                          centerTitle: true,
                          title: Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                  body: Stack(
                    children: [
                      SafeArea(
                        bottom: false,
                        child: BlocBuilder<AuthenticationCubit,
                            AuthenticationState>(
                          builder: (context, state) {
                            if (state is RegisteredUser) {
                              final user = state.user;
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      // color: Colors.red,
                                      height: 200,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Stack(
                                              children: [
                                                Container(
                                                  height: 100,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    shape: BoxShape.circle,
                                                    image: user.avatar.isEmpty
                                                        ? null
                                                        : DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: NetworkImage(
                                                              user.avatar,
                                                            ),
                                                          ),
                                                  ),
                                                  child: user.avatar.isEmpty
                                                      ? const Icon(Icons
                                                          .person_2_rounded)
                                                      : null,
                                                ),
                                                SizedBox(
                                                  height: 100,
                                                  width: 95,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        final XFile?
                                                            imagePicked =
                                                            await picker.pickImage(
                                                                source:
                                                                    ImageSource
                                                                        .gallery);
                                                        if (imagePicked !=
                                                            null) {
                                                          setState(() {
                                                            avatar =
                                                                imagePicked;
                                                            imagePath =
                                                                imagePicked
                                                                    .path;
                                                          });
                                                          if (context.mounted) {
                                                            context
                                                                .read<
                                                                    AuthenticationCubit>()
                                                                .editProfilePhoto(
                                                                    File(
                                                                        imagePath),
                                                                    context);
                                                          }
                                                        } else {
                                                          // Handle the case where no image was picked.
                                                          log('No image picked');
                                                        }
                                                      },
                                                      child: const CircleAvatar(
                                                          radius: 12,
                                                          child: Icon(
                                                            Icons.edit,
                                                            size: 16,
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              user.username,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'App theme',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        BlocBuilder<ThemeCubit, AppTheme>(
                                          builder: (context, theme) {
                                            return Switch(
                                              value: theme == AppTheme.light
                                                  ? false
                                                  : true,
                                              onChanged: (value) {
                                                context
                                                    .read<ThemeCubit>()
                                                    .toggleTheme();
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Column(
                                        children: [
                                          _changePhone(context),
                                          Divider(
                                            thickness: 1,
                                            height: 0,
                                            color: Colors.grey.shade300,
                                          ),
                                          customTile(
                                              const Icon(
                                                Icons.phone_android_rounded,
                                              ),
                                              'Phone number'),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    BlocListener<DeleteUserCubit,
                                        DeleteUserState>(
                                      listener: (context, state) {
                                        if (state is DeleteUserSuccess) {
                                          Navigator.pop(context);

                                          context
                                              .read<AuthenticationCubit>()
                                              .deleteAccount();
                                          context
                                              .read<RegistrationFormCubit>()
                                              .resetForm();
                                        }
                                      },
                                      child: CustomButton(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        label: 'Delete account',
                                        onTap: () async {
                                          if (context.mounted) {
                                            context
                                                .read<DeleteUserCubit>()
                                                .deleteAccount();

                                            context
                                                .read<ConversationsCubit>()
                                                .resetConvos();
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const OverLay();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                state is DeleteUserLoading ? const OverLay() : Container(),
                state is AuthenticationLoading ? const OverLay() : Container(),
              ],
            );
          },
        );
      },
    );
  }

  GestureDetector _changePhone(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          title = 'Change phone';
          isBottomSheetShowing = true;
        });
        // print('Edit me');
        showBottomSheet(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0))),
          backgroundColor: Theme.of(context).canvasColor,
          enableDrag: false,
          context: context,
          builder: (context) {
            return BlocBuilder<AuthenticationCubit, AuthenticationState>(
              builder: (context, state) {
                if (state is RegisteredUser) {
                  phone = state.user.phone;
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    color: Theme.of(context).canvasColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          const Text('Old phone number'),
                          buildtextField(context, state.user.phone, true),
                          const SizedBox(height: 16),
                          const Text('New phone number'),
                          buildtextField(context, state.user.phone, false),
                          const SizedBox(height: 16),
                          CustomButton(
                              onTap: () {
                                logger.e('tap');
                                context
                                    .read<AuthenticationCubit>()
                                    .editPhoneNumber(phone, context);
                                setState(() {
                                  isBottomSheetShowing = false;
                                  title = 'Settings';
                                });
                              },
                              label: 'Edit phone'),
                        ],
                      ),
                    ),
                  );
                } else if (state is AuthenticationLoading) {
                  return const OverLay();
                }

                return Container();
              },
            );
          },
        );
      },
      child:
          customTile(const Icon(Icons.phone_android_rounded), 'Phone number'),
    );
  }

  Container buildtextField(
      BuildContext context, String initialValue, bool readOnly) {
    return Container(
      height: MediaQuery.of(context).size.height / 16,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade600),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade300,
      ),
      child: TextFormField(
        readOnly: readOnly,
        initialValue: initialValue,
        cursorColor: Colors.greenAccent,
        decoration: const InputDecoration(
          hintText: 'Enter your username',
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
            phone = value;
            usernameError = '';
            // print(phone);
          });
        },
      ),
    );
  }

  Container customTile(Icon icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 16,
      ),
      color: Theme.of(context).canvasColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Row(
            children: [
              icon,
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
              ),
            ],
          )
        ],
      ),
    );
  }
}
