import 'package:fininfocom_firebase/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyBecsUW-trxqaWcZsvvQlv4QH98Z5uMdhs',
        appId: '1:684725960733:android:f99c375ed27293748546f4',
        messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
        projectId: 'fininfocom-cb77a',
        storageBucket: 'YOUR_STORAGE_BUCKET',
      )
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
    );
  }
}
