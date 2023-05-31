import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AssetsPicker extends StatefulWidget {
  const AssetsPicker({super.key, required this.onPickFile});

  final void Function(File pickedFile) onPickFile;

  @override
  State<AssetsPicker> createState() => _AssetsPickerState();
}

class _AssetsPickerState extends State<AssetsPicker> {
  File? _imageFile;

  void _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg', 'gif']);

    if (result != null) {
      // User picked a file.
      PlatformFile file = result.files.first;

      setState(() {
        _imageFile = File(file.path!);
      });

      widget.onPickFile(_imageFile!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
          child: const Icon(Icons.add_a_photo_outlined),
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.add),
          label: Text(
            'Add Image',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
