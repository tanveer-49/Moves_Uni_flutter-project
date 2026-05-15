import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/admin_panel/admin_login.dart';
import 'features/auth/login_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'University Bus System',
      theme: AppTheme.lightTheme,
      home: kIsWeb
          ? const AdminLoginScreen()
          : const LoginScreen(),
    );
  }
}