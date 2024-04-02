import 'package:attraxiachat/controllers/chat/chat_cubit.dart';
import 'package:attraxiachat/controllers/home/home_cubit.dart';
import 'package:attraxiachat/views/home_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//necessary to initialize firebase with flutter 3.19
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'key',
    appId: 'id',
    messagingSenderId: 'sendid',
    projectId: 'myapp',
    storageBucket: 'myapp-b9yt18.appspot.com',
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeCubit()),
        BlocProvider(create: (context) => ChatCubit()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Attraxia chat app',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade900),
          ),
          home: const HomeView()),
    );
  }
}
