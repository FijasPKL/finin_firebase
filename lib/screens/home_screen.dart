import 'package:fininfocom_firebase/screens/login_screen.dart';
import 'package:fininfocom_firebase/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_screen.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class HomeScreen extends StatefulWidget {
  final String role; // Accept role as a parameter

  HomeScreen({required this.role});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserModel> users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    users = await UserService().getUsers();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.grey,
          title: Text('Home')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(child: Text('Navigation', style: TextStyle(fontSize: 20),)),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen(role:widget.role,)));
              },
            ),
            Divider(),
            ListTile(
              title: Text('Logout'),
              onTap: () async {
                await AuthService().signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
            Divider(),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: SingleChildScrollView(
              child: Card(
                child: ListTile(
                  title: Text(users[index].email),
                  subtitle: Text('Role: ${users[index].role}'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
