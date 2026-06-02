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
        photoUrl: map['photoUrl'],
        preferredLanguage: map['preferredLanguage'] ?? 'en',
        isPremium: map['isPremium'] ?? false,
        createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
        'preferredLanguage': preferredLanguage,
        'isPremium': isPremium,
        'createdAt': createdAt.toIso8601String(),
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
