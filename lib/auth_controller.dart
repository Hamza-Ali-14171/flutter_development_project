import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  final RxBool isloading = false.obs;

  Future<bool> login(String email, String password) async {
    String url = "https://jsonplaceholder.typicode.com/posts";
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
        print("user login info : $data");
        return true;
      } else {
        print("failed to login ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("the error is $e");
      Get.snackbar('Error', "error ocurred! please try again later");
      return false;
    }
  }
}
