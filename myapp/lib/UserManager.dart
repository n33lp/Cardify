class UserManager {
  static final UserManager _instance = UserManager._internal();
  factory UserManager() => _instance;

  UserManager._internal()
      : userProfilePicUrl =
            ''; // Add an initializer expression for the 'userProfilePicUrl' field.

  String? userName;
  String? userEmail;
  String userProfilePicUrl;
  String? usertoken;
  String? userID;

  void setUser(
      {required String name,
      required String email,
      required String picUrl,
      required String token,
      required String id}) {
    userName = name;
    userEmail = email;
    userProfilePicUrl = picUrl;
    usertoken = token;
    userID = id;
  }

  void clearUser() {
    userName = null;
    userEmail = null;
    userProfilePicUrl = '';
    usertoken = null;
    userID = null;
  }
}
