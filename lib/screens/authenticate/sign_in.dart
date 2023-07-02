// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:pet_adoption_system/services/auth.dart';
import 'package:pet_adoption_system/shared/constants.dart';

class SignIn extends StatefulWidget {
  final toggleView;

  const SignIn({Key? key, this.toggleView}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final textFieldFocusNode = FocusNode();
  bool isLoading = false;
  bool isObsure = true;

  //text field state
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String error = '';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return isLoading
        ? loadingIndicator()
        : Scaffold(
            backgroundColor: Colors.indigo[200],
            body: Stack(
              fit: StackFit.passthrough,
              children: <Widget>[
                // Max Size Widget
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/background.png"),
                      opacity: 0.6,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                    right: 150.0,
                    top: 150.0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(450),
                            topRight: Radius.circular(250),
                            bottomLeft: Radius.circular(200),
                            bottomRight: Radius.circular(550)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.white,
                              offset: Offset(3.0, 2.0),
                              blurRadius: 10.0),
                        ],
                      ),
                      height: deviceSize.width,
                      width: deviceSize.height - 500,
                    )),
                Positioned(
                    right: 0.0,
                    top: 350.0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          bottomLeft: Radius.circular(50),
                        ),
                      ),
                      height: 150,
                      width: deviceSize.width - 300,
                      child: Center(
                        child: Text(
                          'Pet Adoption System',
                          style: //customize textStyle in theme() method
                              Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(color: Colors.white),
                        ),
                      ),
                    )),

                Positioned(
                    top: 220.0,
                    left: 20.0,
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    )),
                Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(250),
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(1.1, 1.1),
                              blurRadius: 10.0),
                        ],
                      ),
                      width: deviceSize.width - 50,
                      height: deviceSize.height - 550,
                      child: Stack(children: [
                        Positioned(
                          top: 530.0,
                          left: 100.0,
                          child: Image.asset(
                            'assets/images/dogtop.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(80.0),
                              child: Text(
                                "Log In ",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 500,
                                    child: buildEmailForm(
                                        emailController, 'Email'),
                                  ),
                                  const SizedBox(height: 20.0),
                                  SizedBox(
                                    width: 500,
                                    child: buildPasswordForm(
                                        passwordController, 'Password'),
                                  ),
                                  const SizedBox(height: 20.0),
                                  Text(
                                    error,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 14.0),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() => isLoading = true);
                                        dynamic result = await _auth
                                            .signInWithEmailAndPassword(
                                                emailController.text,
                                                passwordController.text);
                                        if (result == null) {
                                          setState(() {
                                            error =
                                                'Could not sign in with those credentials';
                                            isLoading = false;
                                          });
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      fixedSize: Size(
                                          MediaQuery.of(context).size.width /4,
                                          45),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                    ),
                                    child: const Text(
                                      'Log In',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  const SizedBox(height: 50.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Text(
                                        "Don't have an account ? ",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          widget.toggleView();
                                        },
                                        child: Text(
                                          "Sign Up",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6!
                                              .copyWith(color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  TextFormField buildEmailForm(
      TextEditingController controller, String hintText) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: controller,
      textInputAction: TextInputAction.next,
      validator: emailValidator,

      onSaved: (value) {
        controller.text = value!;
      },
      style:
          const TextStyle(color: Colors.white), // Set input text color to white
      decoration: const InputDecoration(
        enabled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        labelText: 'Email',
        labelStyle: TextStyle(color: Colors.white),
        prefixIcon: Icon(
          Icons.email,
          color: Colors.white,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  TextFormField buildPasswordForm(
      TextEditingController controller, String hintText) {
    return TextFormField(
      controller: controller,
      obscureText: isObsure,
      textInputAction: TextInputAction.done,
      validator: passwordValidator,
      onSaved: (value) {
        controller.text = value!;
      },
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: const TextStyle(color: Colors.white),
          enabled: true,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          prefixIcon: const Align(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: Icon(
              Icons.vpn_key_sharp,
              color: Colors.white,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                isObsure = !isObsure;
                if (textFieldFocusNode.hasPrimaryFocus) return;
                textFieldFocusNode.canRequestFocus = false;
              });
            },
            child: Icon(
              isObsure ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ),
          )),
    );
  }
}
