import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/database/model/my_datebase.dart';
import 'package:to_do_app/database/model/users.dart'as MyUser ;
import 'package:to_do_app/ui/components/custom_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app/ui/dialog_utils.dart';
import 'package:to_do_app/ui/home/home_screen.dart';
import 'package:to_do_app/ui/login_screen/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var nameController = TextEditingController(text: 'hamo');

  var passwordController = TextEditingController(text: '1673389');

  var emailController = TextEditingController(text: 'hamo@sameh.com');

  var passwordConfirmationController = TextEditingController(text: '1673389');

  var formKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFDFECDB),
        image: DecorationImage(
          image: AssetImage('assets/images/auth_batern.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: Container(
          padding: EdgeInsets.all(22),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .2,
                  ),
                  CustomFormField(
                    label: 'full name ',
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return "please enter your name ";
                      }
                      return null;
                    },
                    controller: nameController,
                  ),
                  CustomFormField(
                    label: 'email ',
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return "please enter your email ";
                      }
                      var regex = RegExp(
                          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?"
                          r"(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
                      if (!regex.hasMatch(text)) {
                        return "email format not valid";
                      }
                      return null;
                    },
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  CustomFormField(
                    label: 'password ',
                    isPassword: true,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return "please enter your password ";
                      }
                      if (text.length < 6) {
                        return 'password should be at least 6 chars';
                      }
                      return null;
                    },
                    controller: passwordController,
                  ),
                  CustomFormField(
                    label: 'password confirmation ',
                    isPassword: true,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return "please enter your password ";
                      }
                      if (passwordController.text != text) {
                        return " password doesn't match";
                      }
                      return null;
                    },
                    controller: passwordConfirmationController,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      register();
                    },
                    child: const Text(
                      'register',
                      style: TextStyle(fontSize: 24),
                    ),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 8)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                    },
                    child: const Text(
                      'already have account',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 8)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  FirebaseAuth authService = FirebaseAuth.instance;

  Future<void> register() async {
    if (formKey.currentState?.validate() == false) {
      return;
    }

    DialogUtils.showLoadingDialog(context,'loading...');


    //call reg.
    try {
      var result = await authService.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      var myUser = MyUser.Users(
        id: result.user?.uid,
        name: nameController.text,
        email: emailController.text
      );

     await MyDataBase.addUser(myUser);

      DialogUtils.hideDialog(context);
      DialogUtils.showMessage(context, 'user register succesfully',
        posActionName: 'ok',
        posAction: (){
        Navigator.pushReplacementNamed(context, HomeScreen.routeName) ;
        }
      );
    }
    on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        DialogUtils.hideDialog(context);
        DialogUtils.showMessage(context, 'weak password',
            posActionName: 'try again', posAction: (){
          register();
        },negActionName: 'cancel' );
      }
      else if (e.code == 'email-already-in-use') {
        DialogUtils.hideDialog(context);
        DialogUtils.showMessage(context,
          'The account already exists for that email.',
            negActionName: 'cancel',
        );

      }

    }
    catch (e) {

      DialogUtils.hideDialog(context);
      DialogUtils.showMessage(context, 'we have wrong ', negActionName: 'cancel');
   }
   }
}
