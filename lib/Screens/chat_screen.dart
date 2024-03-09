import 'dart:developer';

import 'package:chat_app/Widgets/avatar_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:chat_app/Logic/Cubit/OnlineStatusCubit/online_status_cubit.dart';
import 'package:chat_app/Network/network_services.dart';
import 'package:chat_app/Providers/provider.dart';
import 'package:chat_app/Screens/chat_room.dart';
import 'package:chat_app/Screens/contacts_screen.dart';
import 'package:chat_app/Screens/settings_screen.dart';

import '../Logic/Cubit/ConversationsCubit/conversations_cubit.dart';
import '../Logic/Cubit/SocketCubits/socket_connection_cubit.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    ref.watch(provider.providerOfSocket);

    return Scaffold(
      floatingActionButton: Builder(builder: (context) {
        return BlocBuilder<ConversationsCubit, ConversationsState>(
          builder: (context, state) {
            return FloatingActionButton(
              child: const Icon(Icons.message),
              onPressed: () {
                if (state is ConversationsLoaded) {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return ContactScreen(
                        conversations: state.conversations,
                      );
                    },
                  ));
                }
              },
            );
          },
        );
      }),
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 20,
            ),
            BlocBuilder<SocketConnectionCubit, SocketConnectionState>(
              builder: (context, state) {
                if (state is Connecting) {
                  return const Text('Connecting ...');
                }
                if (state is Disconnected) {
                  return const Text('Waiting ...');
                }
                return Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'ChatApp',
                        style: TextStyle(shadows: [
                          BoxShadow(
                            color: Colors.black38,
                            offset: Offset(1, .5),
                          )
                        ], fontSize: 26, fontWeight: FontWeight.w700),
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
                );
              },
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  )),
              child: Image.asset(
                'images/settings.png',
                height: 24,
                // color: Colors.red
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: BlocBuilder<ConversationsCubit, ConversationsState>(
          builder: (context, state) {
            // logger.d(state);
            if (state is ConversationsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ConversationsLoaded) {
              log(state.conversations.length.toString());
              if (state.conversations.isEmpty) {
                return const Center(
                  child: Text('No conversations yet'),
                );
              }
              return SafeArea(
                child: SlidableAutoCloseBehavior(
                  child: ListView.builder(
                    itemCount: state.conversations.length,
                    itemBuilder: (context, index) {
                      final conversation = state.conversations[index];
                      final otherUser =
                          state.conversations[index].users[0].id ==
                                  NetworkServices.id
                              ? state.conversations[index].users[1]
                              : state.conversations[index].users[0];
                      return Slidable(
                        endActionPane: ActionPane(
                          key: ValueKey(index),
                          motion: const StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                context
                                    .read<ConversationsCubit>()
                                    .deleteConversation(
                                        state.conversations[index].id,
                                        NetworkServices.id,
                                        context);
                              },
                              backgroundColor:
                                  Theme.of(context).colorScheme.errorContainer,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: ListTile(
                          trailing: state.conversations[index].messages
                                  .where((message) =>
                                      message.isSeen == false &&
                                      message.receiver.id == NetworkServices.id)
                                  .toList()
                                  .isEmpty
                              ? const Text('')
                              : CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.blueAccent,
                                  child: Text(
                                    state.conversations[index].messages
                                        .where(
                                          (message) =>
                                              message.isSeen == false &&
                                              message.receiver.id ==
                                                  NetworkServices.id,
                                        )
                                        .toList()
                                        .length
                                        .toString(),
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                          leading: SizedBox(
                            height: 40,
                            width: 40,
                            child: Stack(
                              children: [
                                AvatarImage(image: otherUser.avatar),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: BlocBuilder<OnlineStatusCubit,
                                      OnlineStatusState>(
                                    builder: (context, state) {
                                      if (state is OnlineStatus) {
                                        List<String> stringList =
                                            state.onlineUsers
                                                .map(
                                                  (dynamicItem) =>
                                                      dynamicItem.toString(),
                                                )
                                                .toList();

                                        return Icon(Icons.circle,
                                            color: stringList.contains(
                                              (conversation.users[0].id ==
                                                      NetworkServices.id
                                                  ? conversation.users[1].id
                                                  : conversation.users[0].id),
                                            )
                                                ? Colors.green
                                                : Colors.grey.shade600,
                                            size: 12);
                                      }
                                      return const Text('Unknown');
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatRoom(
                                  conversationId: state.conversations[index].id,
                                  username:
                                      state.conversations[index].users[0].id ==
                                              NetworkServices.id
                                          ? state.conversations[index].users[1]
                                              .username
                                          : state.conversations[index].users[0]
                                              .username,
                                  users: state.conversations[index].users,
                                ),
                              ),
                            );
                          },
                          title: Text(
                            state.conversations[index].users[0].id ==
                                    NetworkServices.id
                                ? state.conversations[index].users[1].username
                                : state.conversations[index].users[0].username,
                            // style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          // tileColor: Colors.white,
                          subtitle: Text(
                            state.conversations[index].messages.isNotEmpty
                                ? state
                                    .conversations[index].messages.last.content
                                : '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            } else if (state is ConversationsError) {
              return Text(state.errorMessage);
            }
            return Text(state.toString());
          },
        ),
      ),
    );
  }
}
