// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:pet_adoption_system/shared/constants.dart';

class petImage extends StatefulWidget {
  File? selectImage;
  petImage({Key? key, this.selectImage}) : super(key: key);

  @override
  State<petImage> createState() => _petImageState();
}

class _petImageState extends State<petImage> {
  File? _imageFile;
  final ImagePicker imagePicker = ImagePicker();
  bool isLoading = false;
  bool isFirstLoad = true;
  final isSelected = <bool>[false, false, false];

  @override
  Widget build(BuildContext context) {
    if (isFirstLoad && widget.selectImage != null) {
      setState(() {
        _imageFile = widget.selectImage;
        isFirstLoad = false;
      });
    }
    return isLoading
        ? loadingIndicator()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                  widget.selectImage == null
                      ? 'Select Pet Image'
                      : 'Change Pet Image',
                  style: const TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0)),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context, widget.selectImage);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.indigo),
              ),
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  //for rounded rectangle clip
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.85,
                      width: double.infinity,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.indigo)),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: _imageFile == null
                                            ? const Center(
                                                child: Text('Select Your Image'))
                                            : Image.file(_imageFile!,
                                                fit: BoxFit.contain)),
                                    ToggleButtons(
                                        isSelected: isSelected,
                                        children: [
                                          ElevatedButton(
                                              style: buildButtonStyle(context),
                                              onPressed: () =>
                                                  imagePickerFunction(
                                                      ImageSource.gallery),
                                              child: buildButtonIcon(
                                                  Icons.image, 'Image')),
                                          ElevatedButton(
                                              style: buildButtonStyle(context),
                                              onPressed: () =>
                                                  imagePickerFunction(
                                                      ImageSource.camera),
                                              child: buildButtonIcon(
                                                  Icons.camera_outlined,
                                                  'Camera')),
                                          
                                        ]),
                                    ElevatedButton(
                                        onPressed: () async {
                                          if (_imageFile != null) {
                                            setState(() => isLoading = true);
                                            Navigator.pop(context, _imageFile);
                                          } else {
                                            showFailedSnackBar(
                                                "Select Image First", context);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              45),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                        ),
                                        child: const Text('Upload Image')),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  ButtonStyle buildButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      minimumSize: Size(MediaQuery.of(context).size.width * 0.27, 50),
    );
  }

  Column buildButtonIcon(IconData iconData, String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Icon(iconData), Text(text)],
    );
  }

  Future imagePickerFunction(ImageSource imageSource) async {
    final XFile? pickedImage = await imagePicker.pickImage(source: imageSource);
    setState(() {
      if (pickedImage != null) {
        setState(() {
          _imageFile = File(pickedImage.path);
        });
      } else {
        _imageFile == null
            ? showFailedSnackBar('No File Selected', context)
            : null;
      }
    });
  }


}
