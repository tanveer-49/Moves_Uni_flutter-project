import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'manage_users.dart';
import 'manage_buses_screen.dart';
import 'manage_routes_screen.dart';
import 'notifications_screen.dart';
import 'admin_login.dart';  // ✅ CHANGE: admin_login import karo

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

                // Manage Users
                ListTile(
                  leading: const Icon(Icons.people, color: Colors.white),
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
                ),

                // Manage Buses
                ListTile(
                  leading: const Icon(Icons.directions_bus, color: Colors.white),
                  title: const Text(
                    'Manage Buses',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ManageBusesScreen(),
                      ),
                    );
                  },
                ),

                // Manage Routes
                ListTile(
                  leading: const Icon(Icons.route, color: Colors.white),
                  title: const Text(
                    'Manage Routes',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ManageRoutesScreen(),
                      ),
                    );
                  },
                ),

                // Notifications
                ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.white),
                  title: const Text(
                    'Notifications',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationsScreen(),
                      ),
                    );
                  },
                ),

                // Logout Option
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Logout'),
                          content: const Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                if (context.mounted) {
                                  // ✅ CHANGE: AdminLoginScreen use karo
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const AdminLoginScreen(),  // Admin login
                                    ),
                                        (route) => false,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Logout'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
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