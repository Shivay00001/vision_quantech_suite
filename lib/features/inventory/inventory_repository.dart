import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'product_model.dart';

final inventoryRepositoryProvider = Provider((ref) => InventoryRepository(Supabase.instance.client));

class InventoryRepository {
  final SupabaseClient _supabase;

  InventoryRepository(this._supabase);

  Stream<List<Product>> get inventoryStream {
     return _supabase.from('products').stream(primaryKey: ['id']).map((event) 
      => event.map((e) => Product.fromJson(e)).toList()
    );
  }

  Future<void> addProduct(Map<String, dynamic> productData) async {
    await _supabase.from('products').insert(productData);
  }
}
