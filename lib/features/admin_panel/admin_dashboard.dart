import 'package:flutter/material.dart';

import 'manage_users.dart';
import 'manage_buses_screen.dart';
import 'manage_routes_screen.dart';

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
                ),
                ListTile(
                  leading:
                  const Icon(Icons.directions_bus, color: Colors.white),
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