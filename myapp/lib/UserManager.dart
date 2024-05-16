class UserManager {
  static final UserManager _instance = UserManager._internal();
  factory UserManager() => _instance;

  UserManager._internal();

  String? userName;
  String? userEmail;
  String? userProfilePicUrl;

  void setUser(
      {required String name, required String email, required String picUrl}) {
    userName = name;
    userEmail = email;
    userProfilePicUrl = picUrl;
  }

  void clearUser() {
    userName = null;
    userEmail = null;
    userProfilePicUrl = null;
  }
}
