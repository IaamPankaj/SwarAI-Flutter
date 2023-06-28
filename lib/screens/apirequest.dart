import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  ApiService._internal();

  Future<http.Response> getRequest(String url, Map<String, String> headers) async {
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<http.Response> postRequest(String url, Map<String, dynamic> data, Map<String, String> headers) async {
    try {

      print(url + " = " + data.toString() + " = " + headers.toString());

      final response = await http.post(Uri.parse(url), body: json.encode(data) , headers: headers);
      print("responseresponseresponseresponseresponseresponse1 ${response}");
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<http.Response> putRequest(String url, Map<String, dynamic> data, Map<String, String> headers) async {
    try {
      final response = await http.put(Uri.parse(url), body: data, headers: headers);
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<http.Response> deleteRequest(String url, Map<String, String> headers) async {
    try {
      final response = await http.delete(Uri.parse(url), headers: headers);
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> uploadFile(File file, String url, Map<String, String> body, Map<String, String> headers) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add file to request
    var fileStream = http.ByteStream(file.openRead());
    var length = await file.length();
    var multipartFile = http.MultipartFile('file', fileStream, length, filename: file.path.split("/").last);
    request.files.add(multipartFile);

    // Add body to request
    request.fields.addAll(body);

    // Send request
    var response = await request.send();
    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      throw Exception('Failed to upload file');
    }
  }

  Future<http.Response> uploadPostRequest(String url, Map<String, dynamic> data, Map<String, String> headers, String file) async {

    try {
    var postUri = Uri.parse(url);
    http.MultipartRequest request = new http.MultipartRequest("POST", postUri);
    request.fields['Language'] = 'en';
    http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'File', file);

    request.files.add(multipartFile);
    http.StreamedResponse response = await request.send();
    // return response;
    final responseString = await response.stream.bytesToString();
    return http.Response(responseString, response.statusCode);
    } catch (e) {
      throw Exception(e.toString());
    }

    // try {
    //
    //   print(url + " = " + data.toString() + " = " + headers.toString());
    //
    //
    //   final response = await http.post(Uri.parse(url), body: json.encode(data) , headers: headers);
    //   return response;
    // } catch (e) {
    //   throw Exception(e.toString());
    // }
  }

  Future<http.Response> uploadFileWithParamsAndHeaders(
      String url,
      String filePath,
      Map<String, dynamic> params,
      Map<String, String> headers,
      ) async {

    // var headers = {
    //   'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTY3ODczNjk3OCwianRpIjoiOWIyZGY0NTUtMjU2OS00MzY4LWJiMDItZjVkZjdiYTQ1NmFmIiwidHlwZSI6ImFjY2VzcyIsInN1YiI6NSwibmJmIjoxNjc4NzM2OTc4LCJleHAiOjE2Nzg3NDA1Nzh9.jk10dKTlcwmNmlPJWKxeQptI6BZA1FSXFg-VGi9BLDI'
    // };
    // var request = http.MultipartRequest('POST', Uri.parse('http://swarapi.cloudstrats.ai:3308/api/shrutlekh/'));
    // request.fields.addAll({
    //   'language': 'en'
    // });
    // request.files.add(await http.MultipartFile.fromPath('audio_file', filePath));
    // request.headers.addAll(headers);
    //
    // http.StreamedResponse response = await request.send();
    //
    // // return response;
    // print(response.statusCode);
    // print(response);
    // if (response.statusCode == 200) {
    //   print(await response.stream.bytesToString());
    // }
    // else {
    //   print(response.reasonPhrase);
    // }

    // Create a multipart request for the file upload
    final request = http.MultipartRequest('POST', Uri.parse(url));

    // Add headers to the request
    headers.forEach((key, value) {
      request.headers[key] = value.toString();
    });

    // Add fields to the request
    params.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // Add the file to the request
    final file = await http.MultipartFile.fromPath('audio_file', filePath);
    request.files.add(file);

    // Send the request and return the response
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return response;

  }




  Future<int> uploadAudioFiles(String url, List<String> audioFiles, Map<String, String> headers, Map<String, dynamic> body) async {
    try {
      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add the headers to the request
      request.headers.addAll(headers);

      // Add the fields to the request body
      body.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Add the audio files to the request
      for (var i = 0; i < audioFiles.length; i++) {
        var file = File(audioFiles[i]);
        var stream = http.ByteStream(file.openRead());
        var length = await file.length();
        var multipartFile = http.MultipartFile('audio_files', stream, length, filename: file.path.split('/').last);
        request.files.add(multipartFile);
      }

      // Send the request and get the response
      var response = await request.send();

      // Check if the response was successful
      if (response.statusCode == 200) {
        print('Audio files uploaded successfully');
      } else {
        print('Failed to upload audio files: ${response.reasonPhrase}');
      }
      return response.statusCode;
    } catch (e) {
      print('Error uploading audio files: $e');
      return 404;
    }
  }



  // Future<http.Response> uploadAudioFiles(String url, List<String> audioFiles, Map<String, String> headers, Map<String, dynamic> body) async {
  //
  //
  //   print("----------------------------");
  //   print(body);
  //
  //   var encodedBody = json.encode(body);
  //
  //   // Create a multipart request
  //     var request = http.MultipartRequest('POST', Uri.parse(url));
  //
  //     // Add the headers to the request
  //     request.headers.addAll(headers);
  //
  //     // Add the fields to the request body
  //     body.forEach((key, value) {
  //       request.fields[key] = value.toString();
  //     });
  //
  //     // encodedBody.forEach((key, value) {
  //     //   request.fields[key] = value.toString();
  //     // });
  //     request.fields['body'] = encodedBody;
  //
  //     // Add the audio files to the request
  //     for (var i = 0; i < audioFiles.length; i++) {
  //       var file = File(audioFiles[i]);
  //       var stream = http.ByteStream(file.openRead());
  //       var length = await file.length();
  //       var multipartFile = http.MultipartFile('audio_files', stream, length, filename: file.path.split('/').last);
  //       request.files.add(multipartFile);
  //     }
  //
  //     // Send the request and get the response
  //     var response = await request.send();
  //
  //     // Convert the response to an http.Response object
  //     var responseString = await response.stream.bytesToString();
  //     var jsonResponse = json.decode(responseString);
  //     var httpResponse = http.Response(jsonResponse, response.statusCode, headers: response.headers);
  //
  //     // Return the response
  //     return httpResponse;
  //
  // }



  Future<http.Response> uploadFilesWithParamsAndHeaders(
      String url,
      List<String> filePath,
      Map<String, dynamic> params,
      Map<String, String> headers,
      ) async {

    // var headers = {
    //   'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTY3ODczNjk3OCwianRpIjoiOWIyZGY0NTUtMjU2OS00MzY4LWJiMDItZjVkZjdiYTQ1NmFmIiwidHlwZSI6ImFjY2VzcyIsInN1YiI6NSwibmJmIjoxNjc4NzM2OTc4LCJleHAiOjE2Nzg3NDA1Nzh9.jk10dKTlcwmNmlPJWKxeQptI6BZA1FSXFg-VGi9BLDI'
    // };
    // var request = http.MultipartRequest('POST', Uri.parse('http://swarapi.cloudstrats.ai:3308/api/shrutlekh/'));
    // request.fields.addAll({
    //   'language': 'en'
    // });
    // request.files.add(await http.MultipartFile.fromPath('audio_file', filePath));
    // request.headers.addAll(headers);
    //
    // http.StreamedResponse response = await request.send();
    //
    // // return response;
    // print(response.statusCode);
    // print(response);
    // if (response.statusCode == 200) {
    //   print(await response.stream.bytesToString());
    // }
    // else {
    //   print(response.reasonPhrase);
    // }

    // Create a multipart request for the file upload
    final request = http.MultipartRequest('POST', Uri.parse(url));

    // Add headers to the request
    headers.forEach((key, value) {
      request.headers[key] = value.toString();
    });

    // Add fields to the request
    params.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // Add the file to the request

    filePath.forEach((value) async {
      // request.fields[key] = value.toString();
      final file = await http.MultipartFile.fromPath('audio_files', value);
      request.files.add(file);
    });

    // final file = await http.MultipartFile.fromPath('audio_files', filePath);
    //

    // Send the request and return the response
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return response;

  }






  // Future<http.Response> uploadFileWithParamsAndHeaders(
  //     File file, Map<String, dynamic> params, Map<String, String> headers) async {
  //
  //   final url = Uri.parse('https://example.com/upload');
  //   final request = http.MultipartRequest('POST', url);
  //
  //   // Set headers
  //   headers.forEach((key, value) {
  //     request.headers[key] = value;
  //   });
  //
  //   // Add the file to the request
  //   final fileStream = http.ByteStream(file.openRead());
  //   final fileLength = await file.length();
  //   final fileName = file.path.split('/').last;
  //   final multipartFile = http.MultipartFile('file', fileStream, fileLength, filename: fileName);
  //   request.files.add(multipartFile);
  //
  //   // Add the parameters to the request
  //   params.forEach((key, value) {
  //     request.fields[key] = value.toString();
  //   });
  //
  //   final response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     // File uploaded successfully
  //     final responseBody = await response.stream.bytesToString();
  //     final json = jsonDecode(responseBody);
  //     // Handle the response JSON here
  //   } else {
  //     // Error uploading file
  //     print('Error uploading file: ${response.statusCode}');
  //   }
  //
  //   return response;
  // }



// Future<http.Response> uploadFileWithParamsAndHeaders(String urls, File file, Map<String, dynamic> params, Map<String, String> headers) async {
  //
  //   final url = Uri.parse(urls);
  //   final request = http.MultipartRequest('POST', url);
  //
  //   // Set headers
  //   headers.forEach((key, value) {
  //     request.headers[key] = value;
  //   });
  //
  //   // Add the file to the request
  //   final fileStream = http.ByteStream(file.openRead());
  //   final fileLength = await file.length();
  //   final fileName = file.path.split('/').last;
  //   final multipartFile = http.MultipartFile('audio_file', fileStream, fileLength, filename: fileName);
  //   request.files.add(multipartFile);
  //
  //   // Add the parameters to the request
  //   params.forEach((key, value) {
  //     request.fields[key] = value.toString();
  //   });
  //
  //   final response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     // File uploaded successfully
  //     final responseBody = await response.stream.bytesToString();
  //     final json = jsonDecode(responseBody);
  //
  //     // return json
  //     // Handle the response JSON here
  //   } else {
  //     // Error uploading file
  //     print('Error uploading file: ${response.statusCode}');
  //   }
  //
  //   return response;
  // }



  // Future<http.Response> uploadFile(String url, String fieldname, File file) async {
  //   try {
  //     final request = http.MultipartRequest('POST', Uri.parse(url));
  //     request.files.add(http.MultipartFile.fromBytes(
  //       fieldname,
  //       await file.readAsBytes(),
  //       filename: file.path.split('/').last,
  //     ));
  //     final response = await request.send();
  //     final responseString = await response.stream.bytesToString();
  //     return http.Response(responseString, response.statusCode);
  //   } catch (e) {
  //     throw Exception(e.toString());
  //   }
  // }



}