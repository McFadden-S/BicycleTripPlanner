import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


class DatabaseManager {

  //********** Singleton **********
  static final DatabaseManager _databaseManager = DatabaseManager._internal();

  FirebaseDatabase _DBInstance = FirebaseDatabase.instance;
  final _auth = FirebaseAuth.instance;
  factory DatabaseManager() {
    return _databaseManager;
  }

  DatabaseManager._internal();

  //********** Private **********



  //********** Public **********

  Future<bool> addToFavouriteStations(int stationID) async {
    if(_auth.currentUser == null){
      return false;
    }
    var uid = _auth.currentUser?.uid;
    DatabaseReference favouriteStations = _DBInstance.ref('users/$uid/favouriteStations');
    Map<String, int> favorites = {};
    favorites['$stationID'] = stationID;
    await favouriteStations.update(favorites).then((_) {
      // Data saved successfully!
      return true;
    }).catchError((error) {
      // The write failed...
      return false;
    });
    return false;
  }

  Future<List<int>> getFavouriteStations() async {
    List<int> output = [];
    List<DataSnapshot> IDs = [];
    var uid = _auth.currentUser?.uid;

    DatabaseReference favouriteStations = _DBInstance.ref('users/$uid/favouriteStations');
    await favouriteStations.once().then((value) => {
    IDs = value.snapshot.children.toList(growable: true)
    });
    for (var id in IDs) {
     output.add(int.parse(id.value.toString()));
    }
    return output;
  }


  addFavouriteRoute(){

  }

  getFavouriteRoutes(){

  }


}
