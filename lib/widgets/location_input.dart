import 'dart:convert';

import 'package:favourite_places/Modal/place.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation) onSelectLocation;
  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;

    return 'https://maps.googleapis.com/maps/api/staticmap?center$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=AlzaSyDLcwxUggpPZo81cbH0TB4Crq5SJjtj4ag&signature=YOUR_SIGNATURE';
  }

  void _getCurrentLocation() async {
    //This particular piece of code inside this function was taken from the location package documentation of pub-dev
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData; //This is an object

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location
        .getLocation(); //location data is an object - after checking wether the service is available
    //It might take a while to get the location data - until the we'll show a loading spinner widget

    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AlzaSyDLcwxUggpPZo81cbH0TB4Crq5SJjtj4ag');
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0]['formatted_address'];

    setState(() {
      _pickedLocation =
          PlaceLocation(latitude: lat, longitude: lng, address: address);
      _isGettingLocation = false;
    });

    widget.onSelectLocation(_pickedLocation!);
    // print(locationData.latitude);
    // print(locationData.longitude);
  }

//USe free google maps api
//google maps geo coding api - making latitude and longitude coordinates into a human readable form (we could use reverse coding)
// reverse geocoding documentation - https://developers.google.com/maps/documentation/geocoding/requests-reverse-geocoding
// AlzaSyDLcwxUggpPZo81cbH0TB4Crq5SJjtj4ag  - google maps api key
  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No location choosen',
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onBackground),
    );

    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 179,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get current location'),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.map),
              label: const Text('Selected on map'),
            ),
          ],
        )
      ],
    );
  }
}
