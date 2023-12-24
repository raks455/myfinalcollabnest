class User {
  final String id;
  final String email;
  final String userid;
  final String fullname;
  final String organization;

  User({
    required this.id,
    required this.email,
    required this.userid,
    required this.fullname,
    required this.organization,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      email: json['email'],
      userid: json['username'],
      fullname: json['fullname'],
      organization: json['organization'],
    );
  }
}
