import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../model/user_model.dart';

class SearchController extends GetxController{
  final Rx<List<User>> _searchUsers = Rx<List<User>>([]);

  List<User> get searchedUsers => _searchUsers.value;

  searchUser(String query) async{
    _searchUsers.bindStream(
        FirebaseFirestore.instance.collection("users")
            .where("name" , isGreaterThanOrEqualTo: query).snapshots()
            .map((QuerySnapshot queryRes){
          List<User> retVal = [];
          for(var element in queryRes.docs ){
            retVal.add(User.fromSnap(element));
          }
          return retVal;

        })
    );
  }
}
