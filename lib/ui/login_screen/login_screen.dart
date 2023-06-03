import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/ui/components/custom_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app/ui/dialog_utils.dart';
import 'package:to_do_app/ui/register/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String routeName = 'login screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  var passwordController = TextEditingController(text: '1673389');
  var emailController = TextEditingController(text: 'hamo@sameh.com');
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
          title: Text('log in '),
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

                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      login();
                    },
                    child: const Text(
                      'log in',
                      style: TextStyle(fontSize: 24),
                    ),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 8)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context,RegisterScreen.routeName);
                    },
                    child: const Text(
                      'do not have account',
                      style: TextStyle(fontSize: 16,),
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

  Future<void> login() async {
    if (formKey.currentState?.validate() == false) {
      return;
    }

    DialogUtils.showLoadingDialog(context,'loading...');


    //call reg.
    try {
      var result = await authService.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      DialogUtils.hideDialog(context);
      DialogUtils.showMessage(context, 'loged in '
          " ${result.user?.uid}");
    }
    on FirebaseAuthException catch (e) {
      {
        DialogUtils.hideDialog(context);
        DialogUtils.showMessage(context, 'we have wrong ',
            posActionName: 'try again', posAction: (){
              login();
            },negActionName: 'cancel' );
      }

    } catch (e) {

      DialogUtils.hideDialog(context);
      DialogUtils.showMessage(context, 'fe haga kedaa ');
    }
  }
}
