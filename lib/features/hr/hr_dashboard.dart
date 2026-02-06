import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'hr_repository.dart';
import 'employee_model.dart';
import '../../core/components/main_layout.dart';
import 'package:data_table_2/data_table_2.dart';

final employeesProvider = StreamProvider((ref) => ref.watch(hrRepositoryProvider).employeesStream);

class HrDashboard extends ConsumerWidget {
  const HrDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeesAsync = ref.watch(employeesProvider);

    return MainLayout(
      title: 'HR Operations',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildKpiCard(context, 'Total Employees', employeesAsync.value?.length.toString() ?? '...'),
                 const SizedBox(width: 16),
                _buildKpiCard(context, 'On Leave', '0'), // Placeholder
              ],
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: employeesAsync.when(
                  data: (employees) {
                    if (employees.isEmpty) {
                      return const Center(child: Text("No employees found."));
                    }
                    return DataTable2(
                      columnSpacing: 12,
                      horizontalMargin: 12,
                      minWidth: 600,
                      columns: const [
                        DataColumn2(label: Text('Name'), size: ColumnSize.L),
                        DataColumn2(label: Text('Role'), size: ColumnSize.M),
                        DataColumn2(label: Text('Department'), size: ColumnSize.M),
                        DataColumn2(label: Text('Status'), size: ColumnSize.S),
                        DataColumn2(label: Text('Joined'), size: ColumnSize.S),
                      ],
                      rows: employees.map((emp) => DataRow(cells: [
                        DataCell(
                          Row(
                            children: [
                              CircleAvatar(child: Text(emp.firstName[0])),
                              const SizedBox(width: 8),
                              Text('${emp.firstName} ${emp.lastName}'),
                            ],
                          )
                        ),
                        DataCell(Text(emp.designation)),
                        DataCell(Text(emp.department)),
                        DataCell(_buildStatusChip(emp.status)),
                        DataCell(Text(emp.joinedAt.toIso8601String().split('T')[0])),
                      ])).toList(),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard(BuildContext context, String title, String value) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatusChip(String status) {
     Color color = Colors.grey;
     if (status == 'active') color = Colors.green;
     if (status == 'terminated') color = Colors.red;
     if (status == 'on_leave') color = Colors.orange;
     
     return Chip(
        label: Text(status.toUpperCase(), style: const TextStyle(fontSize: 10)),
        backgroundColor: color.withOpacity(0.1),
        labelStyle: TextStyle(color: color),
        padding: EdgeInsets.zero,
     );
  }
}
