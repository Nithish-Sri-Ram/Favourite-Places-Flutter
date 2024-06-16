import 'package:favourite_places/Modal/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//Notifier class with riverpod - with this we can add methods that can manipulate the state that is managed by the provider

class UserPalcesNotifier extends StateNotifier<List<Place>> {
  //StateNotifier is a geniric class provided by riverpod
  UserPalcesNotifier()
      : super(
            const []); //we add const - because the state manages by riverpod is immutable, must not edit the old state, instead create a new state based on the old state

  void addPlace(String title) {
    final newPlace = Place(title: title);
    // state = [...state, newPlace]; //To add at the end of the list
    state = [newPlace, ...state]; //To add at the start of the list
  }
}

final userPlacesProvider = StateNotifierProvider(
  (ref) => UserPalcesNotifier(),
);
//This is a provider that will provide the UserPlacesNotifier to the widget tree