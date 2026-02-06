class Employee {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String department;
  final String designation; // e.g. Senior Dev, HR Manager
  final String status; // active, on_leave, terminated
  final double salary;
  final DateTime joinedAt;
  final String organizationId;

  Employee({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.department,
    required this.designation,
    required this.status,
    required this.salary,
    required this.joinedAt,
    required this.organizationId,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      department: json['department'] ?? 'Unassigned',
      designation: json['designation'] ?? 'Employee',
      status: json['status'] ?? 'active',
      salary: (json['salary'] as num?)?.toDouble() ?? 0.0,
      joinedAt: DateTime.parse(json['joined_at'] ?? DateTime.now().toIso8601String()),
      organizationId: json['organization_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'department': department,
      'designation': designation,
      'status': status,
      'salary': salary,
      'joined_at': joinedAt.toIso8601String(),
    };
  }
}
