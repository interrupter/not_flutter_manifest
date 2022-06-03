import 'action.dart';
import 'exceptions.dart';
import 'field.dart';
import '../request/request.dart';

class NotModel {
  late final String name;
  late final String url;
  Map<String, NotField> fields = {};
  Map<String, NotAction> actions = {};

  NotAction getAction(String name) {
    final action = actions[name];
    if (action is NotAction) {
      return action;
    } else {
      throw NotModelActionIsNotExists();
    }
  }

  NotModel.fromJSON(Map<String, dynamic> json) {
    name = json['model'] as String;
    url = json['url'] as String;
    if (json['fields'] is Map<String, dynamic>) {
      (json['fields'] as Map<String, dynamic>).forEach((key, value) {
        fields.addEntries([MapEntry(key, NotField.fromJSON(value))]);
      });
    }
    if (json['actions'] is Map<String, dynamic>) {
      (json['actions'] as Map<String, dynamic>).forEach((key, value) {
        actions.addEntries([MapEntry(key, NotAction.fromJSON(value))]);
      });
    }
  }

  NotRequest<T> request<T>(
    String actionName,
    Map<String, dynamic> payload,
  ) {
    return NotRequest<T>.fromModel(
      notModel: this,
      actionName: actionName,
      payload: payload,
    );
  }
}
