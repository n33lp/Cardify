/*
  This class is used to store the user details after the user logs in.
  It is a singleton class, so that the user details can be accessed from any part of the app.
  The user details are stored in the class variables and can be accessed using the class instance.
  The user details can be set using the setUser method and can be cleared using the clearUser method.

*/

class UserManager {
  static final UserManager _instance = UserManager._internal();
  factory UserManager() => _instance;

  UserManager._internal() : userProfilePicUrl = '';

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
