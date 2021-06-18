import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';

Future uploadVideo(File video) async {
  try {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('uploads/${Path.basename(video.path)}}');
    UploadTask uploadTask =
        ref.putFile(video, SettableMetadata(contentType: 'video/mp4'));

    await uploadTask.whenComplete(() => print('Video Uploaded'));
    String fileURL=await ref.getDownloadURL();
    print(fileURL);
    return fileURL;
  } catch (error) {
    print(error);
    return '';
  }
}
