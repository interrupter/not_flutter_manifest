import 'dart:async';

import 'filter.dart';
import '../interface/interface_http.dart';
import '../interface/interface_ws.dart';
import '../manifest/model.dart';
import 'pager.dart';
import '../response/response.dart';
import './sorter.dart';
import '../types.dart';

import '../manifest/exceptions.dart';

enum InterfaceTransport { ws, http, offline }

class NotRequest<T> {
  //name of the model
  late final String _modelName;
  //name of the action
  late final String _actionName;
  //url parts
  late final String _prefix;
  //request headers
  Map<String, String> _headers = {};
  //query params and data payload
  Map<String, dynamic> _payload = {};
  Map<String, dynamic> _params = {};
  Map<String, dynamic>? _files;
  //action configuration
  late final Map<String, dynamic> _actionData;

  //search part of query
  String? _search;
  //filter part of query
  NotFilter _filter = NotFilter();
  //pager part of query
  NotPager _pager = NotPager();
  //sorter part of query
  NotSorter _sorter = NotSorter();

  TypeHydrator? _hydrator;

  StreamController<NotResponse> _responseController =
      StreamController<NotResponse>();

  StreamController<T> _resultController = StreamController<T>();

  Stream<NotResponse> getResponseStream() {
    return _responseController.stream;
  }

  Stream<T> getResultStream() {
    return _resultController.stream;
  }

  NotRequest<T> setHydrator(TypeHydrator hydrator) {
    _hydrator = hydrator;
    return this;
  }

  NotRequest<T> setPager(NotPager pager) {
    _pager = pager;
    return this;
  }

  NotRequest<T> firstPage() {
    _pager.first();
    return this;
  }

  NotRequest<T> lastPage() {
    _pager.last();
    return this;
  }

  NotRequest<T> nextPage() {
    _pager.next();
    return this;
  }

  NotRequest<T> prevPage() {
    _pager.prev();
    return this;
  }

  NotRequest<T> setSorter(NotSorter sorter) {
    _sorter = sorter;
    return this;
  }

  NotRequest<T> setFilter(NotFilter filter) {
    _filter = filter;
    return this;
  }

  NotRequest<T> setSearch(String search) {
    _search = search;
    return this;
  }

  NotRequest.fromModel({
    required NotModel notModel,
    required String actionName,
    required dynamic payload,
  }) {
    _modelName = notModel.name;
    _actionName = actionName;
    _actionData = notModel.getAction(actionName).asMap();
    _prefix = notModel.url;
    _payload = payload;
  }

  Future<NotResponse> getResponse() {
    switch (selectTransport()) {
      case InterfaceTransport.ws:
        return NotInterfaceWS.request(this);
      case InterfaceTransport.http:
        return NotInterfaceHTTP.request(this);
      default:
        throw Exception('Application is offline');
    }
  }

  Future<T> getResult() async {
    final response = await getResponse();
    final hydrator = _hydrator;
    if (hydrator != null) {
      final result = hydrator(response.getResult());
      _resultController.add(result);
      return result;
    } else {
      _responseController.add(response);
      throw HydratorNotSet();
    }
  }

  InterfaceTransport selectTransport() {
    if (NotInterfaceWS.isUp(this)) {
      return InterfaceTransport.ws; //for ws/wss
    } else if (actionDataHasHTTPMethod()) {
      return InterfaceTransport.http; //for http/https
    }
    return InterfaceTransport.offline; //for offline
  }

  dynamic getDataFromSource(String source) {
    switch (source.toLowerCase()) {
      case 'pager':
        return _pager.toParams();
      case 'filter':
        return _filter.toParams();
      case 'sorter':
        return _sorter.toParams();
      case 'return':
        return _actionData['return'];
      case 'search':
        return _search;
      default:
        return _payload;
    }
  }

  bool isValidHTTPMethod(dynamic value) {
    if (value != null && value is String && value.isNotEmpty) {
      return ['GET', 'PUT', 'POST', 'DELETE', 'OPTIONS', 'PATCH', 'HEAD']
          .contains(value);
    } else {
      return false;
    }
  }

  bool actionDataHasHTTPMethod() {
    return isValidHTTPMethod(_actionData['method']);
  }

  String getModelName() {
    return _modelName;
  }

  String getActionName() {
    return _actionName;
  }

  String getHTTPMethod() {
    return _actionData['method'];
  }

  String getPrefix() {
    return _prefix;
  }

  String getPostfix() {
    return _actionData['postfix'];
  }

  Map<String, dynamic> getPayload() {
    return _payload;
  }

  Map<String, dynamic> getParams() {
    return _params;
  }

  Map<String, dynamic> getActionData() {
    return _actionData;
  }

  Map<String, String> getHeaders() {
    return _headers;
  }

  NotRequest<T> addParam(String key, String value) {
    _params.addEntries([MapEntry(key, value)]);
    return this;
  }
}
