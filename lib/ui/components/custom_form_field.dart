import 'package:flutter/material.dart';
typedef MyValidator = String? Function(String?);

class CustomFormField extends StatelessWidget {

  String label ;
  bool isPassword ;
  TextInputType keyboardType ;
  MyValidator validator ;
  TextEditingController controller ;
  CustomFormField({required this.label, required this.validator, this.isPassword=false,
    this.keyboardType = TextInputType.text ,
  required this.controller
  });



  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
