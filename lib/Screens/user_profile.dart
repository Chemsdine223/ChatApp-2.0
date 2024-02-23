import 'package:chat_app/Models/user.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  final UserModel userModel;
  const UserProfile({super.key, required this.userModel});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with TickerProviderStateMixin {
  // SlidableController controller = SlidableController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Contact info',
            style: Theme.of(context).textTheme.headlineSmall!
            // .copyWith(color: Colors.white),
            ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 16,
            ),
            CircleAvatar(
              radius: 46,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.person_rounded),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '${widget.userModel.firstname} ${widget.userModel.lastname}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Center(
              child: Text(
                widget.userModel.username,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).disabledColor,
                    ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).canvasColor,
                ),
                padding: const EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width,

                // height: 100,
                child: const Text('Profile description'))
          ],
        ),
      ),
    );
  }
}
