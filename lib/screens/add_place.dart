import 'dart:io';

import 'package:favourite_places/Modal/place.dart';
import 'package:favourite_places/Providers/user_places.dart';
import 'package:favourite_places/widgets/image_input.dart';
import 'package:favourite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//We need access to riverpod and providers - which we can get by extending consumerStatefulwidger and consumerState
class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void _savePlace() {
    final enteredTitle = _titleController.text;
    if (enteredTitle.isEmpty || _selectedImage == null|| _selectedLocation == null) {
      return;
    }

    //once we have made it consumer State we have a ref property that we can use to access the providers
    ref
        .read(userPlacesProvider.notifier)
        .addPlace(enteredTitle, _selectedImage!, _selectedLocation!);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: _titleController,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(height: 10),
            ImageInput(
              onPickedImage: (image) {
                //we get the image from the newxt screen and save it to the selected screen in this function
                _selectedImage =
                    image; //We are not using set state because we don't need a UI update
              },
            ),
            const SizedBox(height: 10),
            LocationInput(
              onSelectLocation: (location) {
                _selectedLocation = location;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _savePlace,
              icon: const Icon(Icons.add),
              label: const Text('Add Place'),
            ),
          ],
        ),
      ),
    );
  }
}
