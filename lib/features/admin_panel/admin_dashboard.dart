import 'package:flutter/material.dart';

import 'manage_users.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 250,
            color: Colors.green,
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Admin Panel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                ListTile(
                  leading:
                  const Icon(Icons.people, color: Colors.white),
                  title: const Text(
                    'Manage Users',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ManageUsersScreen(),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Welcome Admin',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}