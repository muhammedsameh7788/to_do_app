import 'package:flutter/material.dart';

class DialogUtils {
  static void showLoadingDialog ( BuildContext context , String massage){
    showDialog(context: context, builder: (buildContext){
      return AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
          SizedBox(width: 15,),
          Text(massage)
          ],
        ),

      );
    }, barrierDismissible: false,
      );
}
  static void hideDialog (BuildContext context) {
    Navigator.pop(context);
  }
  static void showMessage ( BuildContext context , String massage
  ,{ String? posActionName ,VoidCallback? posAction  ,
        String? negActionName , VoidCallback? negAction   , bool dismissible = false  }
      ){
    List<Widget> action =[];
    if (posActionName!= null){
      action.add(TextButton(onPressed: (){
        Navigator.pop(context);
        posAction?.call();
      }, child: Text(posActionName)));
    }
    if (negActionName!= null){
      action.add(TextButton(onPressed: (){
        Navigator.pop(context);
        negAction?.call();
      }, child: Text(negActionName)));
    }
    showDialog(context: context, builder: (buildContext){
      return  AlertDialog(
        content: Text(massage,),
          actions: action,
      );

    }, barrierDismissible: dismissible );
  }
}