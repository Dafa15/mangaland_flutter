import 'package:flutter/material.dart';
import 'package:mangaland_flutter/constant/color_constant.dart';
import 'package:mangaland_flutter/constant/text_style_constant.dart';
import 'package:mangaland_flutter/page/home/home_page.dart';
import 'package:mangaland_flutter/page/login/login_view_model.dart';
import 'package:mangaland_flutter/page/global_widget/text_form_field_widget.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passwordToggle = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    passwordController.dispose();
    userNameController.dispose();
    super.dispose();
  }

  void resetVariable() {
    userNameController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Consumer<LoginViewModel>(
                  builder:
                      (BuildContext context, LoginViewModel viewModel, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        Image.asset(
                          "assets/mangaland_logo.png",
                          width: 300,
                          height: 200,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Username",
                            style: TextStyleConstant.header2,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormFieldCustom(
                          key: const Key("Username"),
                          formController: userNameController,
                          formName: "Username",
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Password",
                            style: TextStyleConstant.header2,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormFieldCustom(
                          key: const Key("Password"),
                          formName: "Password",
                          formController: passwordController,
                          iconToggle: passwordToggle,
                          suffixButton: IconButton(
                            icon: Icon(
                              passwordToggle
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                passwordToggle = !passwordToggle;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                          key: const Key("LoginButton"),
                          style: ButtonStyle(
                            fixedSize: const MaterialStatePropertyAll(
                              Size(double.infinity, 50),
                            ),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            backgroundColor: MaterialStatePropertyAll(
                              ColorConstant.colorSecondary,
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final isSuccess = await viewModel.postLogin(
                                userName: userNameController.text,
                                password: passwordController.text,
                              );
                              if (isSuccess) {
                                resetVariable();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(
                                      index: 0,
                                    ),
                                  ),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Login Error"),
                                      content: const Text(
                                        "Failed to login. Please check your credentials.",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("OK"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          },
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyleConstant.header2,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          Consumer<LoginViewModel>(
            builder: (BuildContext context, LoginViewModel viewModel, child) {
              return viewModel.isLoading
                  ? Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
