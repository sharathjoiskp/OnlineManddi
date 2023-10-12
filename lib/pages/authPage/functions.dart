import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserData(String accType, bool isLoggedIn,
    {required String uid}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('accType', accType);
  await prefs.setBool('isLoggedIn', isLoggedIn);
  await prefs.setString('uid', uid);
}
