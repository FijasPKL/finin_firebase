import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatelessWidget {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final usernameController = TextEditingController();
  final userEmailController = TextEditingController();
  final userPasswordController = TextEditingController();
  final roleController = TextEditingController();
  final String role;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  ProfileScreen({required this.role});
  // Method to handle password change
  void _changePassword(BuildContext context) async {
    String currentPassword = currentPasswordController.text;
    String newPassword = newPasswordController.text;

    // Password validation: at least 8 chars, 1 uppercase letter, 1 symbol
    if (newPassword.length < 8 ||
        !RegExp(r'[A-Z]').hasMatch(newPassword) ||
        !RegExp(r'[!@#\$&*~]').hasMatch(newPassword)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password must meet the required criteria')),
      );
      return;
    }

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && user.email != null) {
        // Re-authenticate user
        AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!, password: currentPassword);
        await user.reauthenticateWithCredential(credential);
        // Update password
        await user.updatePassword(newPassword);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password changed successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  // Method to handle adding a new user
  void _addUser(BuildContext context) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    String username = usernameController.text;
    String email = userEmailController.text;
    String password = userPasswordController.text;
    String role = roleController.text;

    // Email and password validation
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid email format')),
      );
      return;
    }

    if (password.length < 8 ||
        !RegExp(r'[A-Z]').hasMatch(password) ||
        !RegExp(r'[!@#\$&*~]').hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password must meet the required criteria')),
      );
      return;
    }

    try {
      // Create a new user with Firebase Authentication
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Add user data to Firestore
      await users.add({
        'username': username,
        'email': email,
        'role': role,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User added successfully')),
      );

      // Clear the input fields on success
      usernameController.clear();
      userEmailController.clear();
      userPasswordController.clear();
      roleController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  // Alert dialog for changing password
  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: currentPasswordController,
                decoration: InputDecoration(labelText: 'Current Password'),
                obscureText: true,
              ),
              TextFormField(
                controller: newPasswordController,
                decoration: InputDecoration(labelText: 'New Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Update'),
              onPressed: () {
                _changePassword(context);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Alert dialog for adding a new user
  void _showAddUserDialog(BuildContext context) {
    String selectedRole = 'Viewer';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: userEmailController,
                decoration: InputDecoration(labelText: 'User Email'),
              ),
              TextField(
                controller: userPasswordController,
                decoration: InputDecoration(labelText: 'User Password'),
                obscureText: true,
              ),
              // Dropdown for role selection
              DropdownButtonFormField<String>(
                value: selectedRole,
                items: ['Admin', 'Viewer'].map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    selectedRole = newValue;
                  }
                },
                decoration: InputDecoration(

                  labelText: 'Role(Drop Down)',

                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                roleController.text = selectedRole;
                _addUser(context); // Call the add user function
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.grey,
          title: Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 60,),
              ElevatedButton(
                child: Text('Change Password',style: TextStyle(color: Colors.black),),
                onPressed: () => _showChangePasswordDialog(context),
              ),
              SizedBox(height: 20,),
              if (role != 'Viewer')
              ElevatedButton(
                child: Text('Add User',style: TextStyle(color: Colors.black)),
                onPressed: () => _showAddUserDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
