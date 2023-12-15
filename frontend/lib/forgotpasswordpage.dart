import 'package:flutter/material.dart';
import 'package:frontend/loginPage.dart';
import 'package:velocity_x/velocity_x.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;
  //late SharedPreferences prefs;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Color.fromARGB(255, 150, 125, 241)),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                HeightBox(10),
                "Email Sign-In".text.size(22).yellow100.make(),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Email",
                    errorText: _isNotValidate ? "Enter Proper Info" : null,
                    prefixIcon: Icon(Icons.email, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ).p4().px24(),
                TextField(
                  controller: passwordController,
                  obscureText: !_isPasswordVisible,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Password",
                    errorText: _isNotValidate ? "Enter Proper Info" : null,
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ).p4().px24(),
                GestureDetector(
                  onTap: () {
                    print('tapped');
                  },
                  child: HStack([
                    VxBox(
                      child: "Login".text.black.makeCentered().p16(),
                    )
                        .white
                        .roundedLg
                        .border(
                            color: const Color.fromARGB(255, 241, 240, 240),
                            width: 1.5)
                        .width(300)
                        .make()
                        .px(16)
                        .py(16),
                  ]),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to the forgot password page
                    // Implement the ForgotPasswordPage to handle the password reset logic
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage()),
                    );
                  },
                  child: "Forgot Password?".text.white.make(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
