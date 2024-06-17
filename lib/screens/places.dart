import 'package:favourite_places/Providers/user_places.dart';
import 'package:favourite_places/screens/add_place.dart';
import 'package:favourite_places/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//consumer widget is the statelss widget that can listen to the providers - it is provided by riverpod
class PlacesScreen extends ConsumerWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //when we make a widget consumer widget we get a ref property that we can use to access the providers- it is mandatory to use ref in the build method
    final userPlaces = ref.watch(
        userPlacesProvider); //This is to watch the provider - this will make the widget rebuild whenever the provider changes
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const AddPlaceScreen()));
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: Padding(  
        padding: const EdgeInsets.all(8.0),
        child: PlacesList(places: userPlaces),
      ),
    );
  }
}
