import 'dart:convert';

class NetworkResponse {
  final int? status_code;
  final bool? status;
  final String? message;
  final String? result;
  final dynamic data;
  final dynamic error;
  final dynamic errors;

  NetworkResponse({required this.status_code, required this.message, required this.result, this.data, this.error, this.errors, this.status});

  factory NetworkResponse.fromRawJson(String str) {
    return NetworkResponse.fromJson(json.decode(str));
  }

  factory NetworkResponse.fromJson(Map<String, dynamic> json) {
    print("NetworkResponse.fromJson $json");
    return NetworkResponse(
        status_code: json["status_code"], message: json["message"], result: json["result"], data: json["data"], error: json["error"],  errors: json["errors"], status: json["status"]);
  }

  Map<String, dynamic> toJson() =>
      {"status_code": status_code, "message": message, "result": result, "data": data, "error" : error, "errors" : errors, "status" : status};


  Map<String, dynamic> toMap() => {
    "status_code": status_code,
    "message": message,
    "result": result,
    "data": data?.toMap(),
    "error": error.toMap(),
    "errors": errors?.toMap(),
    "status": status
  };
}
