class User1 {
  final String uid;
  final String email;
  final String name;
  final String age;
  // final String profilePic;

  User1({
    required this.uid,
    required this.email,
    required this.name,
    required this.age
    // required this.profilePic,
  });

  factory User1.fromMap(Map<String, dynamic> map) {
    return User1(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      age: map['age'],
      // profilePic: map['profilePic'],
    );
  }
}
