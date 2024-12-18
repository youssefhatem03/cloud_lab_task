import 'package:cloud_lab_task/ViewModel/group_data_viewmodel.dart';
import 'package:cloud_lab_task/firebase_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'View/send_data_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => GroupDataViewModel()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  final FirebaseApi _firebaseApi = FirebaseApi();

 MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: FirebaseApi.scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      home: const SendDataScreen(),
    );
  }
}
