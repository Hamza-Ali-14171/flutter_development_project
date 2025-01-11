import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:week_1_project/auth_controller.dart';
import 'package:week_1_project/home_controller.dart';
import 'package:week_1_project/login.dart';
import 'package:week_1_project/profile.dart';
import 'package:week_1_project/to_do_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    TextEditingController searchController = TextEditingController();
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          // if issearch is active then give text feild in which the searchText is store in onchenged value
          if (controller.isSearchActive.value) {
            return TextField(
              autofocus: true,
              controller: searchController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                hintText: "search with id....",
              ),
              onChanged: (value) {
                controller.searchText.value = value; // Update the search text
              },
            );
          }
          //if issearch is not active give me this text
          else {
            return Text("DATA from Api",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.indigo));
          }
        }),
        actions: [
          Obx(() {
            return IconButton(
              icon: controller.isSearchActive.value
                  ? Icon(Icons.close)
                  : Icon(Icons.search),
              onPressed: () {
                // when user press search button text feild will appear for searching and close button will appear to exit
                if (controller.isSearchActive.value) {
                  controller.isSearchActive.value = false;
                  controller.searchText.value = '';
                  searchController.clear();
                } else {
                  controller.isSearchActive.value = true;
                }
              },
            );
          }),
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                authController.logoutState();
                Get.offAll(Login());
              }),
          IconButton(
              onPressed: () {
                Navigator.push((context),
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
              icon: Icon(Icons.person_2_rounded)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    (context),
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 800),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          ToDoList(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ));
              },
              icon: Icon(Icons.task))
        ],
      ),
      body: Obx(() {
        // this is a function for searchin through the data that we get from api
        final displayList = controller.searchText.value.isEmpty
            ? controller.serviceProvider
            : controller.serviceProvider.where((item) {
                final searchedId = item["id"].toString().toLowerCase();
                return searchedId
                    .contains(controller.searchText.value.toLowerCase());
              }).toList();
        if (displayList.isEmpty) {
          return const Center(child: Text('No results found'));
        }
        return LayoutBuilder(builder: (context, constraints) {
          final screenwidth = constraints.maxWidth > 600;
          return ListView.builder(
              itemCount: displayList.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final item = displayList[index];
                return Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey, blurRadius: 5, spreadRadius: 2)
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: screenwidth
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "ID: ${item["id"].toString()}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "USER ID: ${item["userId"].toString()}"),
                                    const SizedBox(height: 5),
                                    Text("TITLE:  ${item["title"].toString()}"),
                                    const SizedBox(height: 5),
                                    Text("BODY:  ${item["body"].toString()}"),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ID: ${item["id"].toString()}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text("USER ID: ${item["userId"].toString()}"),
                              SizedBox(
                                height: 5,
                              ),
                              Text("TITLE:  ${item["title"].toString()}"),
                              SizedBox(
                                height: 5,
                              ),
                              Text("BODY:  ${item["body"].toString()}")
                            ],
                          ),
                  ),
                );
              });
        });
      }),
    );
  }
}
