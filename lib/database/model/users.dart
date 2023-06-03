import 'package:firebase_auth/firebase_auth.dart';

class Users {
  static const String collectionName = 'users';
  String ? name ;
  String? id ;
  String ? email ;

  Users({this.name, this.id,this.email });
  Users.fromFireStore(Map <String,dynamic> data){
    id = data[id];
    name = data[name];
    email = data[email];
  }
  Map<String,dynamic> toFireStore(){
    return{
      'id': id,
      'name': name,
      'email': email,
    };
  }

}