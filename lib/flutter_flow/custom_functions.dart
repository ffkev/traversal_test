import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/schema/structs/index.dart';

List<AccessibilityDropDownItemStruct>? accessibilityCombinedDropDown(
  List<String>? dropdownLabels,
  List<String>? dropdownValues,
) {
  if (dropdownLabels == null || dropdownValues == null) return null;
  if (dropdownLabels.length != dropdownValues.length) return null;

  return List.generate(
    dropdownLabels.length,
    (index) => AccessibilityDropDownItemStruct(
      label: dropdownLabels[index],
      value: dropdownValues[index],
    ),
  );
}
