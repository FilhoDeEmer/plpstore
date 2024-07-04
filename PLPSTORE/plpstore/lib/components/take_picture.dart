import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

class TakePickture {

  Future<File?> takePicture({bool fromGallery = false}) async {
    final ImagePicker piker = ImagePicker();
    final XFile? imageFile = await piker.pickImage(
      source: fromGallery ? ImageSource.gallery : ImageSource.camera,
      maxHeight: 600,
      );

      if(imageFile == null){
        return null;
      }

      final appDir = await syspath.getApplicationDocumentsDirectory();
      final fileName = path.basename(imageFile.path);
      final savedImage = await File(imageFile.path).copy(
        '${appDir.path}/$fileName',
      );
    return savedImage;
  }
}