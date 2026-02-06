import 'package:flutter/material.dart';
import '../../core/components/main_layout.dart';

class EmployeeDashboard extends StatelessWidget {
  const EmployeeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      title: 'My Workspace',
      child: Center(child: Text('Employee Dashboard Content')),
    );
  }
}
