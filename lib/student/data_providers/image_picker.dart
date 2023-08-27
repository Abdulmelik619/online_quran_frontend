import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

class UploadImage {
  static Future<String?> pickImage() async {
    FilePickerResult? result;
    try {
      result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      print("this is it: ${result}");
    } catch (e) {
      throw Exception(e);
    }

    if (result != null) {
      Uint8List? uploadfile = result.files.single.bytes;
      String filename = basename(result.files.single.name);
      return await uploadImage(uploadfile, filename);
    }
    return null;
  }

  static Future<String?> uploadImage(Uint8List? file, String filename) async {
    if (file != null) {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({
        "key": "13b897bcd803fd950bff64338f161de8",
        "image": await MultipartFile.fromBytes(
          file,
          filename: filename,
        ),
        "name": filename,
      });
      var response = await dio.post(
        "https://api.imgbb.com/1/upload",
        data: formData,
        onSendProgress: ((count, total) {
          stdout.write("$count , $total");
        }),
      );
      print(response.data);
      String avatarUrl = response.data["data"]["url"];
      print(avatarUrl);
      return avatarUrl;
    } else {
      return null;
    }
  }
}
