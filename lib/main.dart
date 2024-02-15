import 'dart:developer';

import 'package:chat_app/Logic/Cubit/OnlineStatusCubit/online_status_cubit.dart';
import 'package:chat_app/Logic/Cubit/RegistrationFormCubit/registration_form_cubit.dart';
import 'package:chat_app/Logic/Cubit/TypingStatusCubit/typing_status_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat_app/Logic/Cubit/ContactCubit/contact_cubit.dart';
import 'package:chat_app/Logic/Network/network_services.dart';
import 'package:chat_app/Screens/chat_screen.dart';
import 'package:chat_app/Screens/login_screen.dart';
import 'package:chat_app/Theme/theme_cubit.dart';
import 'package:chat_app/Theme/theme_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'Logic/Cubit/Authentication/auth_cubit.dart';
import 'Logic/Cubit/ConversationsCubit/conversations_cubit.dart';
import 'Logic/Cubit/SocketCubits/socket_connection_cubit.dart';
import 'Logic/Network/socket_service.dart';

final conversationsCubit = ConversationsCubit();
final connectionCubit = SocketConnectionCubit();
final onlineStatusCubit = OnlineStatusCubit();
final typingStatusCubit = TypingStatusCubit();
final themeCubit = ThemeCubit();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://qrxbuwdzlubqpatmpjew.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFyeGJ1d2R6bHVicXBhdG1wamV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDc3NDY1MjUsImV4cCI6MjAyMzMyMjUyNX0.nzDWnr2uKG4Oprl3zv1yhqLrh_BA3TrisNP2Kc1Xqv8',
  );

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  final String user = sharedPreferences.get('user').toString();
  // sharedPreferences.clear();

  await NetworkServices.loadTokens();
  log('-----------');
  // print(user == 'null');
  log('-----------');
  if (user != 'null') {
    // print('init');
    // print(user);z
    print('object: User $user');

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
          create: (context) => themeCubit,
        ),
        BlocProvider(
          create: (context) => AuthenticationCubit(),
        ),
        BlocProvider(
          create: (context) => RegistrationFormCubit(),
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
        BlocProvider(
          create: (context) => onlineStatusCubit,
        ),
        BlocProvider(
          create: (context) => typingStatusCubit,
        ),
      ],
      child: BlocBuilder<ThemeCubit, AppTheme>(
        builder: (context, theme) {
          return MaterialApp(
            // themeMode: ThemeMode.system,
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: theme == AppTheme.light
                ? ThemeClass.lightTheme
                : ThemeClass.dark,
            home: BlocConsumer<AuthenticationCubit, AuthenticationState>(
              listener: (context, state) {
                if (state is AuthenticationError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage)));

                  context.read<AuthenticationCubit>().resetInCaseOfError();
                  // context.read<RegistrationFormCubit>().stepOne();
                }
              },
              builder: (context, state) {
                if (state is AuthenticationLoading) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (state is RegisteredUser) {
                  return const ChatScreen();
                } else if (state is NewUser) {
                  return const LoginScreen();
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
