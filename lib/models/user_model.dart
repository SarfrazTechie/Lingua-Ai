class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final String preferredLanguage;
  final bool isPremium;
  final DateTime createdAt;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    this.preferredLanguage = 'en',
    this.isPremium = false,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        uid: map['uid'] ?? '',
        name: map['name'] ?? '',
        email: map['email'] ?? '',
        photoUrl: map['photo_url'],                                    // ← fix
        preferredLanguage: map['preferred_language'] ?? 'en',         // ← fix
        isPremium: map['is_premium'] ?? false,                        // ← fix
        createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(), // ← fix
      );

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'email': email,
        'photo_url': photoUrl,                   // ← fix
        'preferred_language': preferredLanguage, // ← fix
        'is_premium': isPremium,                 // ← fix
        'created_at': createdAt.toIso8601String(), // ← fix
      };

  UserModel copyWith({
    String? name,
    String? photoUrl,
    String? preferredLanguage,
    bool? isPremium,
  }) =>
      UserModel(
        uid: uid,
        name: name ?? this.name,
        email: email,
        photoUrl: photoUrl ?? this.photoUrl,
        preferredLanguage: preferredLanguage ?? this.preferredLanguage,
        isPremium: isPremium ?? this.isPremium,
        createdAt: createdAt,
      );
}