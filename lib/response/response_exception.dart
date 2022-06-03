import 'package:dio/dio.dart';

const responseStatusError = 'error';
const unknownErrorMessage = '\0/ unkwnown error';

class NotResponseException implements Exception {
  late final String status;
  late final int? statusCode;
  late final String? statusMessage;
  bool _errorsInFields = false;
  Map<String, List<String>> errors = {};

  late final String? message;

  NotResponseException.fromJSON(dynamic response) {
    if (response['status'] != null) {
      status = response['status'] as String;
    }

    if (response['errors'] is Map<String, List<String>>) {
      errors = response['errors'] as Map<String, List<String>>;
    }

    if (response['message'] != null) {
      message = response['message'] as String;
    } else {
      message = unknownErrorMessage;
    }
  }

  NotResponseException.fromDioResponse(Response res) {
    statusCode = res.statusCode;
    statusMessage = res.statusMessage ?? '';
  }

  NotResponseException.fromDioError(DioError err) {
    statusMessage = err.message;
    message = err.message;
    final res = err.response;
    if (res != null) {
      Map<String, dynamic> data = res.data ?? {};
      if (data['errors'] != null && data['errors']['clean'] == false) {
        Map<String, dynamic> fieldsErrors = data['errors']['fields'];
        fieldsErrors.forEach((key, value) {
          if (value is List) {
            List<String> recasted = [];
            value.forEach((val) {
              recasted.add(val);
              _errorsInFields = true;
            });
            errors.addEntries([MapEntry(key, recasted)]);
          }
        });
      }
      statusCode = res.statusCode;
    }
  }

  NotResponseException.fromException(dynamic exception) {
    statusMessage = exception is String ? exception : exception.toString();
    message = statusMessage;
  }

  bool fieldsHasErrors() {
    return _errorsInFields;
  }
}
