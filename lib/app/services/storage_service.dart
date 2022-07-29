import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_challenge/app/services/client_service.dart';
import 'package:path_provider/path_provider.dart';

abstract class StorageService {
  Future<File> getCachedImageFile(final String imageId);
}

class FirebaseStorageService implements StorageService {
  final ClientService clientService;
  const FirebaseStorageService({required this.clientService});

  @override
  Future<File> getCachedImageFile(final String imageId) async {
    final Directory temp = await getTemporaryDirectory();
    final String fullPathName = '${temp.path}/images_temp2/$imageId';
    final File imageFile = File(fullPathName);
    if (await imageFile.exists() == false) {
      try {
        String imgUrl = await FirebaseStorage.instance
            .ref()
            .child(imageId)
            .getDownloadURL();
        String response = await clientService.get(imgUrl);
        await imageFile.create(recursive: true);
        await imageFile.writeAsBytes(Uint8List.fromList(response.codeUnits));
        return imageFile;
      } on Exception catch (exception) {
        throw 'could not write image $exception';
      }
    } else {}
    return imageFile;
  }
}

class LocalStorageService implements StorageService {
  @override
  Future<File> getCachedImageFile(final String imageId) async {
    final Directory temp = await getTemporaryDirectory();
    final String fullPathName = '${temp.path}/images_temp2/$imageId';
    final File imageFile = File(fullPathName);

    if (await imageFile.exists() == false) {
      try {
        String assetImage = "assets/images/$imageId";
        final byteData = await rootBundle.load(assetImage);
        await imageFile.create(recursive: true);
        await imageFile.writeAsBytes(byteData.buffer
            .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      } catch (e) {
        throw 'could not write image $e';
      }
    }
    return imageFile;
  }
}
