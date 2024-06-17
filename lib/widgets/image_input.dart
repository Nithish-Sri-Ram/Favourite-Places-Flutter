//There is no inbuilt feature in flutter to take an input
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickedImage});

  final void Function(File image) onPickedImage;    //function to send the image to the addPlaces screen
  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage; //it could be null so we indicate it with question mark
  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);
    //THe user might open camera and might exit without clicking any image
    if (pickedImage == null) {
      return;
    }
    //It is in x-file format which we are converting to the file format
    
    setState((){
    _selectedImage = File(pickedImage.path);
    });

    widget.onPickedImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
        onPressed: _takePicture,
        icon: const Icon(Icons.camera),
        label: const Text('Take picture'));

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          // width: double.infinity,
          // height: double.infinity,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
      ),
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}
