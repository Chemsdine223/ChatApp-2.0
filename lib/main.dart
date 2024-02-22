import 'dart:developer';

import 'package:chat_app/Logic/Cubit/OnlineStatusCubit/online_status_cubit.dart';
import 'package:chat_app/Logic/Cubit/TypingStatusCubit/typing_status_cubit.dart';
// import 'package:chat_app/Providers/observers.dart';
import 'package:chat_app/Providers/provider.dart';
import 'package:chat_app/Utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat_app/Theme/theme_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'Logic/Cubit/Authentication/auth_cubit.dart';
import 'Logic/Cubit/ContactCubit/contact_cubit.dart';
import 'Logic/Cubit/ConversationsCubit/conversations_cubit.dart';
import 'Logic/Cubit/DeleteUser/delete_user_cubit.dart';
import 'Logic/Cubit/RegistrationFormCubit/registration_form_cubit.dart';
import 'Logic/Cubit/SocketCubits/socket_connection_cubit.dart';
import 'Logic/Network/network_services.dart';
import 'Logic/Network/socket_service.dart';

import 'Screens/chat_screen.dart';
import 'Screens/login_screen.dart';
import 'Theme/theme_data.dart';

final conversationsCubit = ConversationsCubit();
final connectionCubit = SocketConnectionCubit();
final onlineStatusCubit = OnlineStatusCubit();
final typingStatusCubit = TypingStatusCubit();
final themeCubit = ThemeCubit();
final socketService = SocketService();
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

  final String user = sharedPreferences.get('user').toString();
  final String key = sharedPreferences.get('key').toString();
  final String id = sharedPreferences.get('id').toString();

  log('-----------');
  log('${user == 'null'}');
  log('-----------');

  // log(key);
  if (user != 'null') {
    await NetworkServices.loadTokens();
    socketService.initConnection();
    log('id: $id from main');
    log('key: $key from main');
    log('id: ${NetworkServices.id} from main');
    log('key: ${NetworkServices.key} from main');

    log('object: User $user');
  }
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // SocketService() ;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final message = ref.watch(provider);
    // print(message);

    ref.watch(providerOfSocket);
    // print(str.asData);

    // message.when(
    //   data: (data) {
    //     print('object222');
    //   },
    //   error: (error, stackTrace) {
    //     print(error);
    //     print(stackTrace);
    //   },
    //   loading: () {
    //     print('loading......');
    //   },
    // );
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => themeCubit,
        ),
        BlocProvider(
          create: (context) => AuthenticationCubit(ref),
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
            // themeMode: ThemeMode.system,
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: theme == AppTheme.light
                ? ThemeClass.lightTheme
                : ThemeClass.dark,
            home: BlocConsumer<AuthenticationCubit, AuthenticationState>(
              listener: (context, state) {
                print(state);
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
                  // ref.watch(providerOfSocket);
                  return const ChatScreen();
                } else if (state is NewUser) {
                  return const LoginScreen();
                } else if (state is LoggedOut) {
                  return const LoginScreen();
                } else {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(
                          // color: Colors.greenAccent,
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

// return MaterialApp(
//   home: Scaffold(
//     appBar: AppBar(
//       title: FloatingActionButton(
//         onPressed: () {
//           // Socket socket = IO.io(
//           //     'http://localhost:5000',
//           //     OptionBuilder().setTransports(['websocket']).setExtraHeaders(
//           //       {
//           //         // ignore: unnecessary_string_interpolations
//           //         "id": "22",
//           //         // ignore: unnecessary_string_interpolations
//           //         "key": "22y"
//           //       },
//           //     ));
//           // IO.Socket =
//           socketService.editString('2');

//           // SocketService().disConnectFromSocket();
//         },
//       ),
//     ),
//     floatingActionButton: FloatingActionButton(
//       onPressed: () {
//         // SocketService(IO.io('http://example.com')).socketOptions(IO.io(
//         //     'http://localhost:5000',
//         //     OptionBuilder().setTransports(['websocket']).setExtraHeaders(
//         //       {
//         //         // ignore: unnecessary_string_interpolations
//         //         "id": "55",
//         //         // ignore: unnecessary_string_interpolations
//         //         "key": "$key"
//         //       },
//         //     ).build()));

//         socketService.printerr();

//         // var initialSocket = IO.io('http://example.com');
//         // var socketService = SocketService(initialSocket);

//         // // Accessing the socket
//         // var currentSocket = socketService.socket;

//         // // Updating the socket
//         // var newSocket = IO.io(
//         //     'http://localhost:5000',
//         //     OptionBuilder().setTransports(['websocket']).setExtraHeaders(
//         //       {
//         //         // ignore: unnecessary_string_interpolations
//         //         "id": "55",
//         //         // ignore: unnecessary_string_interpolations
//         //         "key": "$key"
//         //       },
//         //     ).build());
//         // socketService.socket = newSocket;

//         // socketService.connectToSocket();
//       },
//     ),
//   ),
// );
