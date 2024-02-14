import 'package:chat_app/Logic/Cubit/Authentication/auth_cubit.dart';
import 'package:chat_app/Theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Logic/Network/network_services.dart';
import '../Widgets/custom_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final picker = ImagePicker();
  XFile? screenShot;
  String imagePath = '';

  final avatar = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        // print(state);
        // log(state.toString());
        return Scaffold(
          appBar: state is AuthenticationLoading
              ? null
              : AppBar(
                  centerTitle: true,
                  title: const Text(
                    'Settings',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
          body: SafeArea(
            bottom: false,
            child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
              builder: (context, state) {
                // final NetworkImage networkImage =
                if (state is RegisteredUser) {
                  // log(state.user.toJson());
                  final user = state.user;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        SizedBox(
                          // color: Colors.red,
                          height: 200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                          ? const Icon(Icons.person_2_rounded)
                                          : null,
                                    ),
                                    SizedBox(
                                      // color: Colors.green,
                                      height: 100,
                                      width: 95,
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: GestureDetector(
                                          onTap: () async {
                                            String imageUrl = state.user.avatar;
                                            print(imageUrl);
                                            Uri uri = Uri.parse(imageUrl);

                                            // Extract the last path segment as the file name
                                            String fileName =
                                                uri.pathSegments.last;

                                            // Include the query (including the token) in the file name
                                            // String filename =
                                            //     '$fileName?${uri.query}';
                                            // print('File name:$filename');

                                            await picker
                                                .pickImage(
                                                    source: ImageSource.gallery)
                                                .then((value) {
                                              if (value != null) {
                                                NetworkServices()
                                                    .editAvatar(value, '');
                                              } else {
                                                print('no image');
                                              }
                                            });

                                            // print('File Name: $fileName');
                                            // print(state.user.avatar);
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
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  value: theme == AppTheme.light ? false : true,
                                  onChanged: (value) {
                                    context.read<ThemeCubit>().toggleTheme();
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
                              _customTile(
                                  const Icon(Icons.phone_android_rounded),
                                  'Phone number'),
                              Divider(
                                thickness: 1,
                                height: 0,
                                color: Colors.grey.shade300,
                              ),
                              _customTile(
                                  const Icon(Icons.phone_android_rounded),
                                  'Phone number'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          color: Theme.of(context).colorScheme.error,
                          label: 'Delete account',
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            prefs.clear();
                            if (context.mounted) {
                              context
                                  .read<AuthenticationCubit>()
                                  .resetInCaseOfError();
                              // context
                              //     .read<AuthenticationCubit>()
                              //     .resetInCaseOfError();
                            }
                          },
                        )
                      ],
                    ),
                  );
                }
                return loadingOverLay();
              },
            ),
          ),
        );
      },
    );
  }

  Container loadingOverLay() {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.transparent,
      child: Center(
        child: Container(
          height: 100,
          width: 100,
          color: Theme.of(context).primaryColor,
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }

  Container _customTile(Icon icon, String label) {
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
