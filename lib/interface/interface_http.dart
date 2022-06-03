import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import '../credentials.dart';
import './interface.dart';
import '../manifest.dart';
import 'package:not_flutter_path/path.dart';
import '../request/request.dart';
import '../response/response.dart';

import '../response/response_exception.dart';

class NotInterfaceHTTP implements NotInterface {
  static Future<NotResponse> requestByDio(
    String baseUrl,
    String path,
    String query,
    Map<String, dynamic> payload,
    Map<String, dynamic> opts,
  ) async {
    try {
      RequestOptions fetchOptions = RequestOptions(
        baseUrl: baseUrl,
        path: path,
        method: (opts['method'] as String),
        data: payload,
        headers: opts['headers'],
      );
      Response res = await Dio().fetch(fetchOptions);
      return NotResponse.fromDioResponse(res);
    } on DioError catch (e) {
      log(e.toString());
      throw NotResponseException.fromDioError(e);
    } on NotResponseException catch (e) {
      log(e.toString());
      rethrow;
    } catch (e) {
      log(e.toString());
      throw NotResponseException.fromException(e);
    }
  }

  static Future<NotResponse> request(
    NotRequest req,
  ) async {
    try {
      Map<String, dynamic> compositeData = {};
      compositeData.addAll(req.getPayload());
      compositeData.addAll(req.getParams());
      Map<String, dynamic> actionData = req.getActionData();
      Map<String, dynamic> requestParams =
          NotInterfaceHTTP.collectRequestData(req, actionData);
      requestParams.addAll(req.getParams());
      String requestParamsEncoded =
          NotInterfaceHTTP.encodeRequest(requestParams);
      String apiServerURL = NotInterfaceHTTP.getServerURL();
      String url = NotInterfaceHTTP.getURL(req);
      Map<String, dynamic> opts = {};
      Map<String, String> headers = {};
      headers.addAll(req.getHeaders());
      headers.addAll(NotManifestCredatials().getHeaders());
      opts['method'] = actionData['method'];
      return NotInterfaceHTTP.requestByDio(
        apiServerURL,
        url,
        requestParamsEncoded,
        req.getPayload(),
        opts,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Map<String, dynamic> collectRequestData(
      NotRequest req, Map<String, dynamic> action) {
    Map<String, dynamic> requestData = {};
    final dataSources = action['data'];
    if (dataSources is List<String>) {
      for (int i = 0; i < dataSources.length; i++) {
        final String dataSource = dataSources[i];
        Map<String, dynamic> requestData = req.getDataFromSource(dataSource),
            res = {};
        if (['pager', 'sorter', 'filter', 'search', 'return']
            .contains(dataSource)) {
          res[dataSource] = requestData;
        } else {
          res = requestData;
        }
        requestData.addAll(res);
      }
    }
    return requestData;
  }

  static String encodeRequest(Map<String, dynamic> data) {
    String p = '?';
    data.forEach((key, value) {
      if (value != null) {
        final partKey = Uri.encodeQueryComponent(key);
        final partValue = Uri.encodeQueryComponent(
            (value is String || value is int) ? value : json.encode(value));
        p += '$partKey=$partValue&';
      }
    });
    return p;
  }

  static String getServerURL() {
    return NotManifest().getServerUrl();
  }

  static String getURL(req) {
    String line = NotInterfaceHTTP.parseLine(req, req.getPrefix());
    if (req.getPostfix() != null) {
      line += NotInterfaceHTTP.parseLine(req, req.getPostfix());
    }
    return line;
  }

  static String parseLine(NotRequest req, String line) {
    line = line.replaceFirst(':modelName', req.getModelName());
    line = line.replaceFirst(':actionName', req.getActionName());
    line =
        NotInterfaceHTTP.parseParams(':record[', ']', line, req.getPayload());
    line = NotInterfaceHTTP.parseParams(':', '?', line, req.getPayload());
    return line;
  }

  static String parseParams(
      String start, String end, String line, Map<String, dynamic> payload) {
    String fieldName = '';
    int len = start.length;
    while (line.contains(start)) {
      int ind = line.indexOf(start);
      int startSlice = ind + len;
      int endSlice = line.indexOf(end);
      fieldName = line.substring(startSlice, endSlice);
      if (fieldName == '') break;
      line = line.replaceFirst(
          start + fieldName + end, NotPath.get(fieldName, payload));
    }
    return line;
  }
}
