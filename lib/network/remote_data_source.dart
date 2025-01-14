import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as Dio;
import '../helper/constants.dart';
import '../helper/enumhoarder.dart';
import '../helper/helper.dart';
import '../helper/network_response.dart';
import '../helper/result.dart';
import '../model/repositories_model.dart';
import 'network.dart';


class RemoteDataSource {
  RemoteDataSource._privateConstructor();

  static final RemoteDataSource _apiResponse =
  RemoteDataSource._privateConstructor();

  factory RemoteDataSource() => _apiResponse;
  networkClient client = networkClient(Client(), dio: Dio.Dio());

  Future<Result> getRepositories({dynamic param}) async {

    final urlString = NetworkEndPoints.getRepositories +
        "?q=${param["q"]}"
            "&sort=${param["sort"]}"
            "&order=${param["order"]}";

    try {
      final response = await client.request(
        requestType: RequestType.GET,
        path: urlString,
        headerWithAuth: false,
        parameter: param,
      );

      // Parse the raw response
      final apiResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body); // Decode JSON here
        print("API Response: ${response.body}");
        // Log parsed data (optional)
        print("Parsed Data: ${data}");

        return Result.success(data);
      }  else {
        return Result.error(apiResponse["message"]);
      }
    } catch (error) {
      print("Error: $error");
      return Result.error(error);
    }
  }

}
