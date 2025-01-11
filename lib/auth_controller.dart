import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final RxBool isloading = false.obs;
  final RxBool isAuthenticated = false.obs;

  Future<bool> login(String email, String password) async {
    String url = "https://reqres.in/api/login";
    var uri = Uri.parse(url);
    try {
      var response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        //save  user info
        print("Login Succesfull! Token:${data["token"]}");
        // you can save the token locally using sqflite
        String token = data["token"];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", token);
        isAuthenticated.value = true;
        isloading.value = false;
        return true;
      } else {
        isloading.value = false;
        Get.snackbar('Login Failed', "invalid credentials");
        print("failed to login ${response.statusCode}");

        return false;
      }
    } catch (e) {
      isloading.value = false;
      print("the error is $e");
      Get.snackbar('Error', "error ocurred! please try again later");
      return false;
    }
  }

  Future<void> checkLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    if (token != null) {
      isAuthenticated.value = true;
    }
  }

  Future<void> logoutState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    isAuthenticated.value = false;
  }
}
