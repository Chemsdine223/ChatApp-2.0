import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chat_app/Logic/Cubit/ContactCubit/contact_cubit.dart';
import 'package:chat_app/Logic/Models/conversation.dart';
import 'package:chat_app/main.dart';

class ContactScreen extends StatefulWidget {
  final List<Conversation> conversations;
  const ContactScreen({
    Key? key,
    required this.conversations,
  }) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    // final convoState = context.watch<ConversationsCubit>();
    // log(convoState.state.toString());
    return Scaffold(
        appBar: AppBar(
          title: const Text('Contacts'),
        ),
        body: BlocConsumer<ContactCubit, ContactState>(
          listener: (context, state) {
            if (state is ContactError) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Couldn\'t load contacts')));
            }
          },
          builder: (context, state) {
            if (state is ContactLoaded) {
              return ListView.builder(
                itemCount: state.contacts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      conversationsCubit.createConversation(
                          widget.conversations,
                          state.contacts[index].phones[0].number,
                          context);
                    },
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      child: const Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                    ),
                    title: Text(state.contacts[index].displayName),
                    subtitle: Text(state.contacts[index].phones[0].number),
                  );
                },
              );
            } else if (state is ContactLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Container();
            }
          },
        ));
  }
}
