class User {
  final String username;
  final String password;
  String sessionToken = "";

  User({
    required this.username,
    required this.password
  });
}