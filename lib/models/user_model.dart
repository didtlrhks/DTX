class User {
  final int? id;
  final String username;
  final String email;
  final String patientId;
  final Map<String, dynamic>? emrData;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.patientId,
    this.emrData,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      patientId: json['patient_id'],
      emrData: json['emr_data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'patient_id': patientId,
      'emr_data': emrData,
    };
  }
}
