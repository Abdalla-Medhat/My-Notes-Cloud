import 'dart:io';
import 'package:path/path.dart';
import 'package:http/http.dart';
import 'dart:convert';

mixin class Crud {
  // Basic Authuntication header
  // Headers مع User-Agent و Accept JSON
  Map<String, String> get myheaders => {
    // 'authorization': _basicAuth,
    'API-KEY': 'example',
    'Accept': 'application/json',
    'User-Agent': 'FlutterApp/1.0',
  };

  Future getRequest(String url) async {
    try {
      Response response = await get(Uri.parse(url), headers: myheaders);
      if (response.statusCode == 200) {
        dynamic responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        print("Status code error=============================> ");
        print(response.statusCode);
        print("Status code error=============================> ");
        return {"status": "error", "message": "HTTP ${response.statusCode}"};
      }
    } catch (e) {
      print("Error=============================>$e");
      return {"status": "error", "message": e.toString()};
    }
  }

  Future postRequest(String url, Map data) async {
    try {
      Response response = await post(
        Uri.parse(url),
        body: data,
        headers: myheaders,
      );
      if (response.statusCode == 200) {
        dynamic responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        print("Status code error=============================> ");
        print(response.statusCode);
        print("Status code error=============================> ");
        return {"status": "error", "message": "HTTP ${response.statusCode}"};
      }
    } catch (e) {
      print("Error=============================>$e");
      return {"status": "error", "message": e.toString()};
    }
  }

  Future postRequestWithFile(String url, Map data, File file) async {
    try {
      var request = MultipartRequest("POST", Uri.parse(url));
      var length = await file.length();
      var stream = ByteStream(file.openRead());
      var multipartFile = MultipartFile(
        "image",
        stream,
        length,
        filename: basename(file.path),
      );
      request.headers.addAll(myheaders);
      request.files.add(multipartFile);
      data.forEach((key, value) {
        request.fields[key] = value.toString();
      });
      var myRequest = await request.send();
      var response = await Response.fromStream(myRequest);
      if (myRequest.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Status code error=============================> ");
        print(myRequest.statusCode);
        print("Status code error=============================> ");
      }
    } catch (e) {
      print("Error=============================>$e");
    }
  }
}
