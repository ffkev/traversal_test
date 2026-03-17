// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AccessibilityDropDownItemStruct extends BaseStruct {
  AccessibilityDropDownItemStruct({
    String? label,
    String? value,
  })  : _label = label,
        _value = value;

  // "label" field.
  String? _label;
  String get label => _label ?? '';
  set label(String? val) => _label = val;

  bool hasLabel() => _label != null;

  // "value" field.
  String? _value;
  String get value => _value ?? '';
  set value(String? val) => _value = val;

  bool hasValue() => _value != null;

  static AccessibilityDropDownItemStruct fromMap(Map<String, dynamic> data) =>
      AccessibilityDropDownItemStruct(
        label: data['label'] as String?,
        value: data['value'] as String?,
      );

  static AccessibilityDropDownItemStruct? maybeFromMap(dynamic data) => data
          is Map
      ? AccessibilityDropDownItemStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'label': _label,
        'value': _value,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'label': serializeParam(
          _label,
          ParamType.String,
        ),
        'value': serializeParam(
          _value,
          ParamType.String,
        ),
      }.withoutNulls;

  static AccessibilityDropDownItemStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      AccessibilityDropDownItemStruct(
        label: deserializeParam(
          data['label'],
          ParamType.String,
          false,
        ),
        value: deserializeParam(
          data['value'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'AccessibilityDropDownItemStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AccessibilityDropDownItemStruct &&
        label == other.label &&
        value == other.value;
  }

  @override
  int get hashCode => const ListEquality().hash([label, value]);
}

AccessibilityDropDownItemStruct createAccessibilityDropDownItemStruct({
  String? label,
  String? value,
}) =>
    AccessibilityDropDownItemStruct(
      label: label,
      value: value,
    );
