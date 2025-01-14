import 'dart:io';

import 'package:http/http.dart';
import 'package:dio/dio.dart' as Dio;

import '../helper/constants.dart';
import '../helper/enumhoarder.dart';
import '../helper/nothing.dart';



class ServerSettings {


   // live
  static const String live_url =  "https://api.github.com/";


  static var headers = {
    'Accept': '*/*',

  };

  static Map<String , String> headerWithAuth(String bearerToken){
    var headerWithAuth = {

      'Accept': '*/*',

    };
    return headerWithAuth;
  }

  static Map<String , String> dioHeaderWithAuth(String bearerToken){
    var headerWithAuth = {

      "contentType":
      'multipart/form-data',
      "Accept": "application/json",

    };
    return headerWithAuth;
  }

  static Map<String , String> headerWithAuthJson(String bearerToken){
    var headerWithAuth = {

      "contentType":
      'application/x-www-form-urlencoded',
      "Accept": "application/json",

    };
    return headerWithAuth;
  }
}


class NetworkEndPoints {

  /// End Points

  static String getRepositories = 'search/repositories';

}

class networkClient {

  final Client _client;
  final Dio.Dio dio; //= Dio.Dio();
  networkClient(this._client, {required this.dio});

  Future<Response> request({required RequestType requestType,
    required String path,
    required bool headerWithAuth,
    dynamic parameter = Nothing}) async {

    switch(requestType){

      case RequestType.GET:
        print("'${ServerSettings.live_url}$path'");
        print(headerWithAuth == true ? (ServerSettings.headerWithAuth(Constants.TOKEN)) : (ServerSettings.headers));
        return _client.get(Uri.parse('${ServerSettings.live_url}$path'),
            headers: headerWithAuth == true ? (ServerSettings.headerWithAuth(Constants.TOKEN)) : (ServerSettings.headers)

        );
      case RequestType.POST:
        print("'${ServerSettings.live_url}$path'");
        print(headerWithAuth == true ? (ServerSettings.headerWithAuth(Constants.TOKEN)) : (ServerSettings.headers));
        print(parameter);
        return _client.post(Uri.parse('${ServerSettings.live_url}$path'),
            headers: headerWithAuth == true ? ServerSettings.headerWithAuth(Constants.TOKEN) : {},
            body: parameter);
      case RequestType.PUT:
        print("'${ServerSettings.live_url}$path'");
        print(headerWithAuth == true ? (ServerSettings.headerWithAuth(Constants.TOKEN)) : (ServerSettings.headers));
        print(parameter);
        return _client.put(Uri.parse('${ServerSettings.live_url}$path'),
            headers: headerWithAuth == true ? ServerSettings.headerWithAuth(Constants.TOKEN) : ServerSettings.headers,
            body: parameter);
      case RequestType.DELETE:
        print("'${ServerSettings.live_url}$path'");
        print(headerWithAuth == true ? (ServerSettings.headerWithAuth(Constants.TOKEN)) : (ServerSettings.headers));
        return _client.delete(Uri.parse('${ServerSettings.live_url}$path'),
            headers: headerWithAuth == true ? (ServerSettings.headerWithAuth(Constants.TOKEN)) : (ServerSettings.headers));
    }
  }



  Future<Dio.Response> dioRequest({required RequestType requestType,
    required String path,
    required bool headerWithAuth,
    dynamic parameter = Nothing}) async {
    // switch(requestType){
    // case RequestType.POST:
    print("'${ServerSettings.live_url}$path'");
    print(headerWithAuth == true ? (ServerSettings.headerWithAuth(Constants.TOKEN)) : (ServerSettings.headers));
    //print(parameter.postData.fields.toString());
    return dio.post('${ServerSettings.live_url}$path',
        data: parameter,
        options: Dio.Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headerWithAuth == true ? ServerSettings.dioHeaderWithAuth(Constants.TOKEN) : {"contentType": 'multipart/form-data',},
        )
    );
    //}
  }
}
