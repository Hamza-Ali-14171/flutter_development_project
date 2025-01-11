import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;

  Future<void> fetchUserData() async {
    String url = "https://reqres.in/api/users/2";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        userData = jsonDecode(response.body)["data"];
      });
    } else {
      Get.snackbar("Error", "Failed to load profile data");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(userData!["avatar"]),
                    radius: 50,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "${userData!["first_name"]} ${userData!["last_name"]}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(userData!["email"]),
                ],
              ),
            ),
    );
  }
}
