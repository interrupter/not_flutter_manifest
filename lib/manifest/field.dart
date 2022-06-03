class NotField {
  String? component;
  String? label;
  String? placeholder;
  bool? readonly;
  bool? disabled;

  NotField.fromJSON(Map<String, dynamic> json) {
    if (json['component'] != null) {
      component = json['component'] as String;
    }

    if (json['label'] != null) {
      label = json['label'] as String;
    }

    if (json['placeholder'] != null) {
      placeholder = json['placeholder'] as String;
    }

    if (json['readonly'] != null) {
      readonly = json['readonly'] as bool;
    }

    if (json['disabled'] != null) {
      disabled = json['disabled'] as bool;
    }
  }
}
