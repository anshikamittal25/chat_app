import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clone/data/data.dart';
import 'package:path/path.dart' as Path;

Future uploadImage(File image) async {
  try {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('users/${Path.basename(image.path)}}');

    UploadTask uploadTask = storageReference.putFile(image);

    await uploadTask.whenComplete(() => print('File Uploaded'));
    String fileURL=await storageReference.getDownloadURL();
    print(fileURL);
    return fileURL;
  } catch (e) {
    print(e);
    return '';
  }
}
