import 'package:chat_app/Logic/Cubit/OnlineStatusCubit/online_status_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chat_app/Logic/Models/user.dart';
import 'package:chat_app/Logic/Network/socket_service.dart';

import '../Logic/Cubit/ConversationsCubit/conversations_cubit.dart';

import '../Logic/Cubit/SocketCubits/socket_connection_cubit.dart';
import '../Logic/Network/network_services.dart';
import '../Providers/provider.dart';
import '../Widgets/chat_bubble.dart';

// import '../Providers/provider.dart';

// import '../Logic/Models/message.dart';

class ChatRoom extends ConsumerStatefulWidget {
  final String conversationId;
  final String username;
  final List<UserModel> users;
  const ChatRoom({
    Key? key,
    required this.conversationId,
    required this.username,
    required this.users,
  }) : super(key: key);

  @override
  ConsumerState<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends ConsumerState<ChatRoom> {
  @override
  void initState() {
    // SocketService().checkStatus(
    //   widget.users[0].id == NetworkServices.id
    //       ? widget.users[1].id
    //       : widget.users[0].id,
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final message0 = TextEditingController();
    ref.watch(providerOfSocket);

    return Scaffold(
        appBar: AppBar(
          // title: Text(widget.username),
          centerTitle: true,
          title: BlocBuilder<SocketConnectionCubit, SocketConnectionState>(
            builder: (context, state) {
              if (state is Connecting) {
                return const Text('Connecting ...');
              }
              if (state is Disconnected) {
                return const Text('Waiting ...');
              }
              return Column(
                children: [
                  Text(widget.username),
                  BlocProvider(
                    create: (context) => OnlineStatusCubit(
                      widget.users[0].id == NetworkServices.id
                          ? widget.users[1].id
                          : widget.users[0].id,
                    ),
                    child: BlocBuilder<OnlineStatusCubit, OnlineStatusState>(
                      builder: (context, state) {
                        print(state);
                        if (state is Online) {
                          return const Text('Online');
                        }
                        return const Text('Offline');
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        body: BlocBuilder<ConversationsCubit, ConversationsState>(
          builder: (context, state) {
            if (state is ConversationsLoaded) {
              final conversation = state.conversations.firstWhere(
                  (conversation) => conversation.id == widget.conversationId);

              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,

                      // itemExtent: 10,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      // shrinkWrap: true,
                      itemCount: conversation.messages.length,
                      itemBuilder: (context, index) {
                        final messages =
                            conversation.messages.reversed.toList();
                        final message = messages[index];

                        return ChatBubble(
                          incoming: message.sender.id == NetworkServices.id
                              ? false
                              : true,
                          message: message,
                        );
                      },
                    ),
                  ),
                  Container(
                      height: 65,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          border: Border(
                              top: BorderSide(color: Colors.grey, width: 1.5))),
                      padding: const EdgeInsets.only(
                          left: 6, bottom: 20, right: 6, top: 12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Container(
                                // margin: EdgeInsets.only(),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade900,
                                  border: Border.all(
                                    color: Colors.blueGrey,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                width: 10,
                                child: TextField(
                                  cursorHeight: 16,
                                  style: const TextStyle(color: Colors.white),
                                  // colo
                                  controller: message0,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.all(12),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: () {
                                print('object');
                                SocketService().sendMessage(
                                  {
                                    "content": message0.text,
                                    "sender": {
                                      "username": widget.users[0].id ==
                                              NetworkServices.id
                                          ? widget.users[0].username
                                          : widget.users[1].username,
                                      "id": widget.conversationId
                                    },
                                    "receiver": {"username": widget.username},
                                    "conversationId": widget.conversationId
                                  },
                                );
                              },
                              child: const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      )),
                ],
              );
            }
            return Container();
          },
        ));
  }
}
