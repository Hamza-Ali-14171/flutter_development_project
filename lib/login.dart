import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_screen.dart';
import 'auth_controller.dart';

//use the credentials for login
//"email": "eve.holt@reqres.in",
//  "password": "cityslicka"

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final _formkey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final controller = Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "LOGIN HERE",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
        )),
        backgroundColor: Colors.blueGrey.withOpacity(0.3),
      ),
      body: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(10),
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: Colors.grey, blurRadius: 10, spreadRadius: 2)
                ]),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: "Enter Email",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please enter your email";
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: "Enter password",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please enter your password";
                      }
                      if (value.length < 4) {
                        return 'Password must be at least 4 characters long';
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Obx(() {
                  return controller.isloading.value
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              controller.isloading.value = true;
                              final email = emailController.text.trim();
                              final password = passwordController.text.trim();
                              final success =
                                  await controller.login(email, password);
                              controller.isloading.value = false;

                              if (success) {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        transitionDuration:
                                            Duration(milliseconds: 800),
                                        pageBuilder: (_, __, ___) =>
                                            HomeScreen(),
                                        transitionsBuilder:
                                            (_, animation, __, child) {
                                          const begin = Offset(1, 0);
                                          const end = Offset.zero;
                                          const curve = Curves.bounceInOut;
                                          var inBetween = Tween(
                                                  begin: begin, end: end)
                                              .chain(CurveTween(curve: curve));
                                          var transition =
                                              animation.drive(inBetween);
                                          return SlideTransition(
                                            position: transition,
                                            child: child,
                                          );
                                        }));
                              }
                            }
                          },
                          child: Text("login"));
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
