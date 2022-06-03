class NotAction {
  bool _ws = false;
  String? _method;
  String? _postfix;
  String? _title;
  List<String>? _fields;
  List<String>? _data;
  bool? _isArray;

  NotAction.fromJSON(Map<String, dynamic> json) {
    if (json['method'] != null) {
      _method = json['method'] as String;
    }

    if (json['postfix'] != null) {
      _postfix = json['postfix'] as String;
    } else if (json['postFix'] != null) {
      _postfix = json['postFix'] as String;
    }

    if (json['title'] != null) {
      _title = json['title'] as String;
    }

    if (json['isArray'] != null) {
      _isArray = json['isArray'] as bool;
    }

    if (json['ws'] != null) {
      _ws = json['ws'] as bool;
    }

    if (json['data'] != null && json['data'] is List<String>) {
      _data = json['data'] as List<String>;
    }

    if (json['fields'] != null && json['fields'] is List<String>) {
      _fields = json['fields'] as List<String>;
    } else if (json['fields'] != null &&
        json['fields'] is Map<String, Map<String, List<String>>>) {
      final fieldsProp = json['fields'] as Map<String, dynamic>;
      _fields = fieldsProp.entries.first as List<String>;
    }
  }

  Map<String, dynamic> asMap() {
    return {
      'method': _method?.toUpperCase(),
      'postfix': _postfix ?? '',
      'ws': _ws,
      'title': _title ?? '',
      'data': _data ?? [],
      'fields': _fields,
    };
  }
}
