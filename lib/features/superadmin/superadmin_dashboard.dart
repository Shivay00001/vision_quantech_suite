import 'package:flutter/material.dart';
import '../../core/components/main_layout.dart';

class SuperAdminDashboard extends StatelessWidget {
  const SuperAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      title: 'Platform Overview',
      child: Center(child: Text('Super Admin Dashboard Content')),
    );
  }
}
