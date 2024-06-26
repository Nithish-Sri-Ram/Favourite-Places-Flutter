import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class PlaceLocation {
  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
  final double latitude;
  final double longitude;
  final String
      address; //This is the address that we will get from the google maps api
}

class Place {
  Place({
    required this.title,
    required this.image,
    required this.location,
    String? id,
  }) : id = id ??
            uuid.v4(); //Here we are deriving the id from the uuid package dynamically - but when we are deriving from the database we use the alderady existing id
  //The id will be autogenerated
  final String title;
  final String id;
  final File image;
  final PlaceLocation location;
}
