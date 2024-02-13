import 'package:chat_app/Logic/Cubit/Authentication/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final picker = ImagePicker();
  XFile? screenShot;
  String imagePath = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
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
                  // log(state.user.avatar);
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
                                const SizedBox(height: 10),
                                Text(user.username),
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
                            Switch(
                              activeColor: Colors.red,
                              value: true,
                              onChanged: (value) {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            color: Colors.amber,
                            child: Column(
                              children: [
                                _customTile(
                                    const Icon(Icons.phone_android_rounded),
                                    'Phone number'),
                                Divider(
                                  thickness: 1.5,
                                  height: 0,
                                  color: Colors.grey.shade300,
                                ),
                                _customTile(
                                    const Icon(Icons.phone_android_rounded),
                                    'Phone number'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                  // print(user.username);
                  // return Column(
                  //   children: [
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         user.avatar.isNotEmpty
                  //             ? CircleAvatar(
                  //                 radius: 50,
                  //                 backgroundImage: NetworkImage(
                  //                   user.avatar,
                  //                 ),
                  //               )
                  //             : GestureDetector(
                  //                 onTap: () async {
                  //                   final XFile? imagePicked = await picker
                  //                       .pickImage(source: ImageSource.gallery);
                  //                   if (imagePicked != null) {
                  //                     setState(() {
                  //                       screenShot = imagePicked;
                  //                       imagePath = imagePicked.path;
                  //                     });
                  //                     print(screenShot!.path);
                  //                   } else {
                  //                     // Handle the case where no image was picked.
                  //                     print('No image picked');
                  //                   }
                  //                 },
                  //                 child: SizedBox(
                  //                   height: 120,
                  //                   width: 100,
                  //                   // color: Colors.red,
                  //                   child: Column(
                  //                     children: [
                  //                       imagePath.isEmpty
                  //                           ? const Stack(
                  //                               children: [
                  //                                 CircleAvatar(
                  //                                   radius: 60,
                  //                                   backgroundColor:
                  //                                       Colors.green,
                  //                                   child: Icon(
                  //                                       Icons.person_2_rounded),
                  //                                 ),
                  //                                 SizedBox(
                  //                                   width: 100,
                  //                                   height: 108,
                  //                                   child: Align(
                  //                                     alignment:
                  //                                         Alignment.bottomRight,
                  //                                     child: Icon(
                  //                                       Icons.add_circle,
                  //                                       color: Colors.black,
                  //                                     ),
                  //                                   ),
                  //                                 ),
                  //                               ],
                  //                             )
                  //                           : Image.file(
                  //                               File(imagePath),
                  //                               fit: BoxFit.cover,
                  //                             ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ),
                  //         // GestureDetector(
                  //         //   onTap: () {},
                  //         //   child: const SizedBox(
                  //         //     height: 120,
                  //         //     width: 100,
                  //         //     // color: Colors.red,
                  //         //     child: Column(
                  //         //       children: [
                  //         //         Stack(
                  //         //           children: [
                  //         //             CircleAvatar(
                  //         //               radius: 60,
                  //         //               backgroundColor: Colors.green,
                  //         //               child: Icon(Icons.person_2_rounded),
                  //         //             ),
                  //         //             SizedBox(
                  //         //               width: 100,
                  //         //               height: 108,
                  //         //               child: Align(
                  //         //                 alignment: Alignment.bottomRight,
                  //         //                 child: Icon(
                  //         //                   Icons.add_circle,
                  //         //                   color: Colors.black,
                  //         //                 ),
                  //         //               ),
                  //         //             ),
                  //         //           ],
                  //         //         ),
                  //         //       ],
                  //         //     ),
                  //         //   ),
                  //         // ),
                  //       ],
                  //     ),
                  //     Text(
                  //       user.username,
                  //       style: const TextStyle(
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //     ),
                  //   ],
                  // );
                }
                return Container();
              },
            ),
          ),
        );
      },
    );
  }

  Container _customTile(Icon icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 16,
      ),
      color: Colors.grey.shade100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Row(
            children: [
              icon,
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey.shade500,
              ),
            ],
          )
        ],
      ),
    );
  }
}
