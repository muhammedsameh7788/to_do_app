import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:to_do_app/database/model/users.dart';

class MyDataBase{
  static CollectionReference <Users> getUsersCollection (){
    return FirebaseFirestore.instance .collection(Users.collectionName)
        .withConverter<Users>(fromFirestore: (snapshot, option){
          return Users.fromFireStore(snapshot.data()!) ;
    },
    toFirestore: (user,option ){
    return user.toFireStore();
    } );
  }
static Future<void> addUser (Users user){
var collection =getUsersCollection();
return collection.doc(user.id).set(user);

}

}