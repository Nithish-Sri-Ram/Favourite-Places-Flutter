import 'dart:ffi';
import 'dart:io';

import 'package:favourite_places/Modal/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

//Notifier class with riverpod - with this we can add methods that can manipulate the state that is managed by the provider

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
    },
    version: 1,
  ); //'places.db' This is a database name of our choice - if this db doesn't exist it will create one
  return db;
}

class UserPalcesNotifier extends StateNotifier<List<Place>> {
  //StateNotifier is a geniric class provided by riverpod
  UserPalcesNotifier()
      : super(
            const []); //we add const - because the state manages by riverpod is immutable, must not edit the old state, instead create a new state based on the old state

  //Now that we are done with the storing of the datatbase now we have to load the data from the database and display it in the app
  Future<void> loadPlace() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data.map(
      (row) => Place(       //There is one problem here - the Place() always creates a unique id for each place, but we want to use the id that we stored in the database
        id: row['id'] as String,
        title: row['title'] as String,
        image: File(row['image'] as String),
        location: PlaceLocation(
            latitude: row['lat'] as double,
            longitude: row['lng'] as double,
            address: row['address'] as String),
      ),
    ).toList();

    state=places;   //This will update the state with the places that we loaded from the database
  }

  void addPlace(String title, File image, PlaceLocation location) async {
    //Different OS gives different paths for files and we want to take and store the file location in a permanent way
    final appDir = await syspaths
        .getApplicationDocumentsDirectory(); //This will give us the path to the directory where we can store files that are related to the app
    //This target path where it wants to be copied needs a path along with the file name  - we can use the path package to join the path and the file name
    final fileName = path
        .basename(image.path); //This will give us the file name from the path
    final copiedImage = await image.copy(
        '${appDir.path}/$fileName'); //This will copy the file to the new path

    final newPlace =
        Place(title: title, image: copiedImage, location: location);
    // state = [...state, newPlace]; //To add at the end of the list

    final db = await _getDatabase();
    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    }); //This will insert the data into the database

    state = [newPlace, ...state]; //To add at the start of the list
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPalcesNotifier, List<Place>>(
  //we can take advantage of it's generic nature to provide the type of state it will manage
  (ref) => UserPalcesNotifier(),
);
//This is a provider that will provide the UserPlacesNotifier to the widget tree

//To store date in the device 
//For storing image path we use a package - path provider 
//also include path package - it simplifies the process of working with files and directories
//sqflite - allows to store data in a local database or we could also use shared preferences - though it's not recommended for storing large data and it is very basic compred to sqflite