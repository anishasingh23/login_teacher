import 'package:flutter/material.dart';
import 'package:login_teacher/dashboard.dart';
import 'package:login_teacher/login.dart';
import 'package:login_teacher/qr.dart';
import 'package:login_teacher/register.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://dpbchvnpfkjvkjagaqnh.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRwYmNodm5wZmtqdmtqYWdhcW5oIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTEzOTk0OTYsImV4cCI6MjAyNjk3NTQ5Nn0.NSvPVIKngCAEP-YM19KHFwtqsni1YFa-QcAZhCdLrbM',
  );
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      darkTheme: ThemeData(useMaterial3: true),
      routes: {
        'login': (context) => MyLogin(),
        'register': (context) => MyRegister(),
        'dashboard': (context) => MyDashboard(),
        'qr': (context) => qr(),
      }));
}
