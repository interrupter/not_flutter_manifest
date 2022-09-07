import 'package:dio/dio.dart';

import 'response_exception.dart';

const responseStatusError = 'error';
const responseStatusSuccess = 'ok';

class NotResponse {
  late final String status;
  late final int? statusCode;
  late final String? statusMessage;
  late final bool isSuccess;
  late final bool isRedirect;

  late final String? message;
  late final dynamic result;

  NotResponse.fromJSON(dynamic response) {
    if (response['status'] != null) {
      status = response['status'] as String;
      isSuccess = status == responseStatusSuccess;
    }

    if (response['message'] != null) {
      message = response['message'] as String;
    }

    if (response['result'] != null) {
      result = response['result'];
    }
  }

  NotResponse.fromDioResponse(Response res) {
    statusCode = res.statusCode;
    statusMessage = res.statusMessage;

    if (res.statusCode == 200) {
      isRedirect = res.isRedirect ?? false;
      if (res.data != null) {
        status = res.data['status'];
        message = res.data['message'];
        isSuccess = status == responseStatusSuccess;
        if (isSuccess) {
          result = res.data['result'];
          return;
        }
      }
    }
    throw NotResponseException.fromDioResponse(res);
  }

  dynamic getResult() {
    return result;
  }
}
