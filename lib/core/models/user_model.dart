class UserProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String role;
  final String? organizationId;
  final String? email;

  UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.organizationId,
    this.email,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      role: json['role'] as String? ?? 'employee',
      organizationId: json['organization_id'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
      'organization_id': organizationId,
      'email': email,
    };
  }
}

enum UserRole {
  developer,
  org_admin,
  employee,
  crm_manager,
  hr_manager,
  finance_manager,
  inventory_manager;

  static UserRole fromString(String role) {
    return UserRole.values.firstWhere(
      (e) => e.name == role,
      orElse: () => UserRole.employee,
    );
  }
}
