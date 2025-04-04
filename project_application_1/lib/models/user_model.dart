class UserModel {
  final String id;
  final String username;
  final String email;
  final String createdAt;
  final Map<String, dynamic>? additionalInfo;
  final List<String> savedRecipes;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.createdAt,
    this.additionalInfo,
    this.savedRecipes = const [], // default empty if not present
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'createdAt': createdAt,
      'additionalInfo': additionalInfo ?? {},
      'savedRecipes': savedRecipes,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      createdAt: json['createdAt'] ?? '',
      additionalInfo: json['additionalInfo'],
      savedRecipes: List<String>.from(json['savedRecipes'] ?? []),
    );
  }
}
