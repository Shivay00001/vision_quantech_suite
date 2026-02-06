import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'employee_model.dart';
import 'package:fpdart/fpdart.dart';

final hrRepositoryProvider = Provider((ref) => HrRepository(Supabase.instance.client));

class HrRepository {
  final SupabaseClient _supabase;

  HrRepository(this._supabase);

  Future<List<Employee>> getEmployees() async {
    try {
      final data = await _supabase.from('employees').select().order('created_at');
      return (data as List).map((e) => Employee.fromJson(e)).toList();
    } catch (e) {
      // Return empty list on error for now, or rethrow
      return [];
    }
  }

  Future<Either<String, Employee>> addEmployee(Map<String, dynamic> employeeData) async {
    try {
      final response = await _supabase.from('employees').insert(employeeData).select().single();
      return right(Employee.fromJson(response));
    } catch (e) {
      return left(e.toString());
    }
  }
  
  Stream<List<Employee>> get employeesStream {
     return _supabase.from('employees').stream(primaryKey: ['id']).map((event) 
      => event.map((e) => Employee.fromJson(e)).toList()
    );
  }
}
