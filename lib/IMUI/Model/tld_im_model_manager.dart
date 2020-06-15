

import 'dart:io';
import 'dart:typed_data';

import 'package:dragon_sword_purse/Base/tld_base_request.dart';
import 'package:dragon_sword_purse/CommonFunction/tld_common_function.dart';

class TLDIMModelManager{
  void uploadImageInservice(File image,Function(String) success,Function(TLDError) failure)async{
    String fileBase64 = await imageFile2Base64(image);
    success(fileBase64);
  }
}