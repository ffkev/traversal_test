import '/components/country_drop2_widget.dart';
import '/components/country_drop_widget.dart';
import '/components/email_field_widget.dart';
import '/components/full_name_field_widget.dart';
import '/components/language_drop_widget.dart';
import '/components/multi_drop_widget.dart';
import '/components/password_field_widget.dart';
import '/components/phone_field_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'form_page_widget.dart' show FormPageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FormPageModel extends FlutterFlowModel<FormPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for fullNameField component.
  late FullNameFieldModel fullNameFieldModel;
  // Model for emailField component.
  late EmailFieldModel emailFieldModel;
  // Model for passwordField component.
  late PasswordFieldModel passwordFieldModel;
  // Model for phoneField component.
  late PhoneFieldModel phoneFieldModel;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // Model for countryDrop component.
  late CountryDropModel countryDropModel;
  // Model for countryDrop2 component.
  late CountryDrop2Model countryDrop2Model;
  // Model for multiDrop component.
  late MultiDropModel multiDropModel;
  // Model for languageDrop component.
  late LanguageDropModel languageDropModel;
  // State field(s) for Checkbox widget.
  bool? checkboxValue1;
  // State field(s) for Checkbox widget.
  bool? checkboxValue2;
  // State field(s) for Checkbox widget.
  bool? checkboxValue3;
  // State field(s) for Checkbox widget.
  bool? checkboxValue4;
  // State field(s) for Checkbox widget.
  bool? checkboxValue5;
  // State field(s) for Switch widget.
  bool? switchValue1;
  // State field(s) for Switch widget.
  bool? switchValue2;
  // State field(s) for Switch widget.
  bool? switchValue3;

  @override
  void initState(BuildContext context) {
    fullNameFieldModel = createModel(context, () => FullNameFieldModel());
    emailFieldModel = createModel(context, () => EmailFieldModel());
    passwordFieldModel = createModel(context, () => PasswordFieldModel());
    phoneFieldModel = createModel(context, () => PhoneFieldModel());
    countryDropModel = createModel(context, () => CountryDropModel());
    countryDrop2Model = createModel(context, () => CountryDrop2Model());
    multiDropModel = createModel(context, () => MultiDropModel());
    languageDropModel = createModel(context, () => LanguageDropModel());
  }

  @override
  void dispose() {
    fullNameFieldModel.dispose();
    emailFieldModel.dispose();
    passwordFieldModel.dispose();
    phoneFieldModel.dispose();
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    countryDropModel.dispose();
    countryDrop2Model.dispose();
    multiDropModel.dispose();
    languageDropModel.dispose();
  }
}
