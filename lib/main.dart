import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat_app/Logic/Cubit/ContactCubit/contact_cubit.dart';
import 'package:chat_app/Logic/Network/network_services.dart';
import 'package:chat_app/Logic/Network/socket_service.dart';
import 'package:chat_app/Screens/chat_screen.dart';
import 'package:chat_app/Screens/login_screen.dart';
import 'package:chat_app/Theme/theme_cubit.dart';
import 'package:chat_app/Theme/theme_data.dart';

import 'Logic/Cubit/Authentication/auth_cubit.dart';
import 'Logic/Cubit/ConversationsCubit/conversations_cubit.dart';
import 'Logic/Cubit/SocketCubits/socket_connection_cubit.dart';

final conversationsCubit = ConversationsCubit();
final connectionCubit = SocketConnectionCubit();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  final String user = sharedPreferences.get('user').toString();

  await NetworkServices.loadTokens();
  // print(user.isNotEmpty);
  if (user.isNotEmpty) {
    // print(user);z
    // print('object: User $user');
    SocketService().initConnection();
  }
  // if
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => conversationsCubit,
        ),
        BlocProvider(
          create: (context) => connectionCubit,
        ),
        BlocProvider(
          create: (context) => ContactCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, AppTheme>(
        builder: (context, theme) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: theme == AppTheme.light
                ? ThemeClass.lightTheme
                : ThemeClass.dark,
            home: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    ),
                  );
                } else if (state is RegisteredUser) {
                  // print(state.user.id);
                  // print(state.user.username);
                  return const ChatScreen();
                } else if (state is NewUser) {
                  return const LoginScreen();
                } else if (state is AuthError) {
                  return const Scaffold(
                    body: Center(
                      child: Text('Authentication Error'),
                    ),
                  );
                } else {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(
                        color: Colors.greenAccent,
                      ),
                    ),
                  );
                }
                // return Container();
              },
            ),
          );
        },
      ),
    );
  }
}
