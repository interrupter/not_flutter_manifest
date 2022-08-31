import 'request/request.dart';
import 'response/response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'manifest/model.dart';

class NotManifest {
  String _path = '/api/manifest';
  String _serverUrl = '';
  String _token = '';
  Map<String, NotModel> _models = {};

  static final NotManifest _shared = NotManifest._sharedInstance();
  NotManifest._sharedInstance();
  factory NotManifest() => _shared;

  NotManifest setServerUrl(String serverUrl) {
    _serverUrl = serverUrl;
    return this;
  }

  String getServerUrl() {
    return _serverUrl;
  }

  NotManifest setManifestPath(String path) {
    _path = path;
    return this;
  }

  String getManifestPath() {
    return _path;
  }

  void setToken(String token) {
    _token = token;
  }

  String getToken() {
    return _token;
  }

  Future<void> update() async {
    try {
      final response = await http.get(Uri.parse('$_serverUrl$_path'));
      reset();
      _fromJSON(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }

  void _fromJSON(Map<String, dynamic> json) {
    json.forEach((key, value) {
      _models.addEntries([MapEntry(key, NotModel.fromJSON(value))]);
    });
  }

  void reset() {
    _models.clear();
  }

  NotModel getModel(String name) {
    final model = _models[name];
    if (model is NotModel) {
      return model;
    } else {
      throw Exception('Model $name is not exists');
    }
  }

  ///Shortcut for getting data without extra control over request process
  Future<NotResponse> fetch<T>(
    String modelName,
    String actionName,
    Map<String, dynamic> payload,
  ) {
    return getModel(modelName).request<T>(actionName, payload).getResponse();
  }

  ///Shortcut for getting request routine
  NotRequest<T> request<T>(
    String modelName,
    String actionName,
    Map<String, dynamic> payload,
  ) {
    return getModel(modelName).request<T>(actionName, payload);
  }
}
