import 'dart:developer';

// import 'package:chat_app/Providers/observers.dart';
import 'package:chat_app/Utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat_app/Theme/theme_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'Constants/constants.dart';
import 'Logic/Cubit/Authentication/auth_cubit.dart';
import 'Logic/Cubit/ContactCubit/contact_cubit.dart';
import 'Logic/Cubit/DeleteUser/delete_user_cubit.dart';
import 'Logic/Cubit/RegistrationFormCubit/registration_form_cubit.dart';
import 'Logic/Network/network_services.dart';

import 'Providers/provider.dart';
import 'Screens/chat_screen.dart';
import 'Screens/login_screen.dart';
import 'Theme/theme_data.dart';

void main() async {
  // Hive
  WidgetsFlutterBinding.ensureInitialized();
  PreferenceUtils.init();
  await Supabase.initialize(
    url: 'https://qrxbuwdzlubqpatmpjew.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFyeGJ1d2R6bHVicXBhdG1wamV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDc3NDY1MjUsImV4cCI6MjAyMzMyMjUyNX0.nzDWnr2uKG4Oprl3zv1yhqLrh_BA3TrisNP2Kc1Xqv8',
  );

  socketService.socket.dispose();

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  // sharedPreferences.clear();
  final String user = sharedPreferences.get('user').toString();

  await NetworkServices.loadTokens();
  provider = SocketProvider();
  if (user != 'null') {
    socketService.initConnection();

    log('object: User $user');
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(provider.providerOfSocket);

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
        BlocProvider(
          create: (context) => DeleteUserCubit(),
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
            home: BlocConsumer<AuthenticationCubit, AuthenticationState>(
              listener: (context, state) {
                // print(state);
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
                } else if (state is LoggedOut) {
                  return const LoginScreen();
                } else {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
