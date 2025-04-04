class UserModel {
  final String id;
  final String username;
  final String email;
  final String createdAt;
  final Map<String, dynamic>? additionalInfo;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.createdAt,
    this.additionalInfo,
  });

  // Convert model to JSON for storing in Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'createdAt': createdAt,
      'additionalInfo': additionalInfo ?? {},
    };
  }

  // Create model from Firestore document
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      createdAt: json['createdAt'] ?? '',
      additionalInfo: json['additionalInfo'],
    );
  }
}