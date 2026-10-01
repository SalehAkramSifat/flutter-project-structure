import 'package:flutter/material.dart';
import 'package:flutter_project_structure/app.dart';
import 'package:flutter_project_structure/core/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.init();
  runApp(const MyApp());
}

