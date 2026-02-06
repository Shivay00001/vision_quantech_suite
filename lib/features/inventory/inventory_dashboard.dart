import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'inventory_repository.dart';
import 'product_model.dart';
import '../../core/components/main_layout.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart for future graphical dashboard

final inventoryProvider = StreamProvider((ref) => ref.watch(inventoryRepositoryProvider).inventoryStream);

class InventoryDashboard extends ConsumerWidget {
  const InventoryDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryAsync = ref.watch(inventoryProvider);

    return MainLayout(
      title: 'Inventory & Stock',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildKpiCard(context, 'Total Products', inventoryAsync.value?.length.toString() ?? '...'),
                const SizedBox(width: 16),
                _buildKpiCard(context, 'Low Stock Alerts', 
                    inventoryAsync.value?.where((p) => p.needsRestock).length.toString() ?? '...'),
              ],
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: inventoryAsync.when(
                  data: (products) {
                    if (products.isEmpty) {
                      return const Center(child: Text("No products in inventory."));
                    }
                    return DataTable2(
                       minWidth: 800,
                      columns: const [
                        DataColumn2(label: Text('Product'), size: ColumnSize.L),
                        DataColumn2(label: Text('SKU')),
                        DataColumn2(label: Text('Stock'), numeric: true),
                        DataColumn2(label: Text('Price'), numeric: true),
                        DataColumn2(label: Text('Status')),
                      ],
                      rows: products.map((p) => DataRow(cells: [
                        DataCell(Text(p.name)),
                        DataCell(Text(p.sku)),
                        DataCell(Text(p.stockQuantity.toString())),
                        DataCell(Text('\$${p.price}')),
                        DataCell(_buildStockStatus(p)),
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

  Widget _buildStockStatus(Product p) {
    if (p.needsRestock) {
      return Chip(
        label: const Text('LOW STOCK'),
        backgroundColor: Colors.red.withOpacity(0.1),
        labelStyle: const TextStyle(color: Colors.red),
      );
    }
    return const Chip(
      label: Text('IN STOCK'),
      backgroundColor: Colors.greenAccent, 
      // Using a simpler color here for now, or use withOpacity
    );
  }
}
