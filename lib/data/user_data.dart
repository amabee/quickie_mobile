// ignore_for_file: non_constant_identifier_names

class User {
  final String user_id;
  final String first_name;
  final String last_name;
  final String username;
  final String bio;
  final String profile_image;
  final String email;

  User(this.first_name, this.last_name, this.username, this.bio,
      this.profile_image,
      {required this.user_id, required this.email});
}
