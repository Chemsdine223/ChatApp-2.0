import 'dart:developer';

// import 'package:chat_app/Providers/observers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
import 'firebase_options.dart';

String token = '';
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: 'https://qrxbuwdzlubqpatmpjew.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFyeGJ1d2R6bHVicXBhdG1wamV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDc3NDY1MjUsImV4cCI6MjAyMzMyMjUyNX0.nzDWnr2uKG4Oprl3zv1yhqLrh_BA3TrisNP2Kc1Xqv8',
  );

  requestPermission();


  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print(
          'Message also contained a notification: ${message.notification!.title!}');
    }
  });

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final String user = sharedPreferences.get('user').toString();
  await NetworkServices.loadTokens();
  provider = SocketProvider();
  socketService.socket.dispose();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  if (user != 'null') {
    socketService.initConnection();

    log('object: User $user');
  }
  runApp(const ProviderScope(child: MyApp()));
}

// ! Set the messages initialization in flutter to init state
// ! Change the consumer to stateful consumer

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async { 
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
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
