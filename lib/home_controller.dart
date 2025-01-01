import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  List serviceProvider = <Map<String, dynamic>>[].obs;
  final RxString searchText = ''.obs;
  final RxBool isSearchActive = false.obs; // Add this variable

  Future<void> getdata() async {
    String url = "https://jsonplaceholder.typicode.com/posts";
    var uri = Uri.parse(url);
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data is List) {
          serviceProvider.assignAll(
              data.map((e) => Map<String, dynamic>.from(e)).toList());
        } else {
          print("Data is in unexpected format");
        }
      } else {
        print("failed to load Data ${response.statusCode}");
      }
    } catch (e) {
      print("the error is $e");
    }
  }

  void onInit() {
    super.onInit();
    getdata();
  }
}
