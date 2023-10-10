class HelperFunctions {
  //keys
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

// saving the data to SF

//getting the data from SF

  static Future<bool?> getUserLoggedInStatus() async {
    // SharedPreferences sf = await SharedPreferences.getInstance();
    // return await sf.getBool(userLoggedInKey);
    return true;
  }
}
