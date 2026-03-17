// File:  lib/flutter_flow/flutter_flow_drop_down.dart

import 'package:traversal_test/flutter_flow/flutter_flow_theme.dart';

import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'dart:math';
import 'dart:ui';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'form_field_controller.dart';
import 'dart:html' as html;

bool get isShortcutsSupported => kIsWeb || !(isAndroid || isiOS);

/// Finds the <flt-semantics> DOM element matching the given aria-label
/// and calls .focus() on it so the browser's accessibility cursor moves there.
void focusDomSemanticsElement(String ariaLabel) {
  final escaped = ariaLabel.replaceAll('"', r'\"');
  final element = html.document.querySelector(
    'flt-semantics[aria-label="$escaped"]',
  );
  if (element != null) {
    (element as html.HtmlElement).focus();
  }
}

// ============================================================================
// FlutterFlowDropDown — public API wrapper
// ============================================================================

class FlutterFlowDropDown<T> extends StatefulWidget {
  const FlutterFlowDropDown({
    super.key,
    this.controller,
    this.multiSelectController,
    this.hintText,
    this.searchHintText,
    required this.options,
    this.optionLabels,
    this.onChanged,
    this.onMultiSelectChanged,
    this.icon,
    this.width,
    this.height,
    this.maxHeight,
    this.fillColor,
    this.searchHintTextStyle,
    this.searchTextStyle,
    this.searchCursorColor,
    required this.textStyle,
    required this.elevation,
    required this.borderWidth,
    required this.borderRadius,
    required this.borderColor,
    required this.margin,
    this.hidesUnderline = false,
    this.disabled = false,
    this.isOverButton = false,
    this.menuOffset,
    this.isSearchable = false,
    this.isMultiSelect = false,
    this.labelText,
    this.labelTextStyle,
    this.optionsHasValueKeys = false,
    this.focusNode,
    this.focusColor,
  }) : assert(
          isMultiSelect
              ? (controller == null &&
                  onChanged == null &&
                  multiSelectController != null &&
                  onMultiSelectChanged != null)
              : (controller != null &&
                  onChanged != null &&
                  multiSelectController == null &&
                  onMultiSelectChanged == null),
        );

  final FormFieldController<T?>? controller;
  final FormFieldController<List<T>?>? multiSelectController;
  final String? hintText;
  final String? searchHintText;
  final List<T> options;
  final List<String>? optionLabels;
  final Function(T?)? onChanged;
  final Function(List<T>?)? onMultiSelectChanged;
  final Widget? icon;
  final double? width;
  final double? height;
  final double? maxHeight;
  final Color? fillColor;
  final TextStyle? searchHintTextStyle;
  final TextStyle? searchTextStyle;
  final Color? searchCursorColor;
  final TextStyle textStyle;
  final double elevation;
  final double borderWidth;
  final double borderRadius;
  final Color borderColor;
  final EdgeInsetsGeometry margin;
  final bool hidesUnderline;
  final bool disabled;
  final bool isOverButton;
  final Offset? menuOffset;
  final bool isSearchable;
  final bool isMultiSelect;
  final String? labelText;
  final TextStyle? labelTextStyle;
  final bool optionsHasValueKeys;
  final FocusNode? focusNode;
  final Color? focusColor;

  @override
  State<FlutterFlowDropDown<T>> createState() => _FlutterFlowDropDownState<T>();
}

class _FlutterFlowDropDownState<T> extends State<FlutterFlowDropDown<T>> {
  bool get isMultiSelect => widget.isMultiSelect;
  FormFieldController<T?> get controller => widget.controller!;
  FormFieldController<List<T>?> get multiSelectController =>
      widget.multiSelectController!;

  T? get currentValue {
    final value = isMultiSelect
        ? multiSelectController.value?.firstOrNull
        : controller.value;
    return widget.options.contains(value) ? value : null;
  }

  Set<T> get currentValues {
    if (!isMultiSelect || multiSelectController.value == null) {
      return {};
    }
    return widget.options
        .toSet()
        .intersection(multiSelectController.value!.toSet());
  }

  Map<T, String> get optionLabels => Map.fromEntries(
        widget.options.asMap().entries.map(
              (option) => MapEntry(
                option.value,
                widget.optionLabels == null ||
                        widget.optionLabels!.length < option.key + 1
                    ? option.value.toString()
                    : widget.optionLabels![option.key],
              ),
            ),
      );

  late void Function() _listener;

  @override
  void initState() {
    super.initState();
    if (isMultiSelect) {
      _listener =
          () => widget.onMultiSelectChanged!(multiSelectController.value);
      multiSelectController.addListener(_listener);
    } else {
      _listener = () => widget.onChanged!(controller.value);
      controller.addListener(_listener);
    }
  }

  @override
  void dispose() {
    if (isMultiSelect) {
      multiSelectController.removeListener(_listener);
    } else {
      controller.removeListener(_listener);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labels = widget.options.map((o) => optionLabels[o] ?? o.toString()).toList();
    final values = widget.options.map((o) => o.toString()).toList();

    String? initialOption;
    if (isMultiSelect) {
      final selected = currentValues;
      if (selected.isNotEmpty) {
        initialOption = optionLabels[selected.first] ?? selected.first.toString();
      }
    } else if (currentValue != null) {
      initialOption = optionLabels[currentValue] ?? currentValue.toString();
    }

    final keyPrefix = widget.key is ValueKey ? (widget.key as ValueKey).value.toString() : 'ff_dropdown';

    // Phase 5: Multi-select display text
    String? multiSelectDisplayText;
    if (isMultiSelect) {
      final selected = currentValues;
      if (selected.isNotEmpty) {
        multiSelectDisplayText =
            selected.where((v) => optionLabels.containsKey(v)).map((v) => optionLabels[v]).join(', ');
      }
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: GenericDropdownWidget(
        key: ValueKey(keyPrefix),
        keyPrefix: keyPrefix,
        hintText: widget.hintText,
        dropdownLabels: labels,
        dropdownValues: values,
        initialOption: initialOption,
        maxWidth: widget.width ?? 340.0,
        isDisabled: widget.disabled,
        menuMaxHeight: widget.maxHeight ?? 400.0,
        // Phase 1: Focus
        focusNode: widget.focusNode,
        focusColor: widget.focusColor,
        // Phase 3: Styling pass-through
        borderWidth: widget.borderWidth,
        borderRadius: widget.borderRadius,
        borderColor: widget.borderColor,
        fillColor: widget.fillColor,
        elevation: widget.elevation,
        margin: widget.margin,
        icon: widget.icon,
        textStyle: widget.textStyle,
        // Phase 4: Search
        isSearchable: widget.isSearchable,
        searchHintText: widget.searchHintText,
        searchHintTextStyle: widget.searchHintTextStyle,
        searchTextStyle: widget.searchTextStyle,
        searchCursorColor: widget.searchCursorColor,
        // Phase 5: Multi-select
        isMultiSelect: widget.isMultiSelect,
        multiSelectDisplayText: multiSelectDisplayText,
        multiSelectSelectedLabels: isMultiSelect
            ? currentValues.map((v) => optionLabels[v] ?? v.toString()).toSet()
            : null,
        // Phase 6: Label & polish
        labelText: widget.labelText,
        labelTextStyle: widget.labelTextStyle,
        isOverButton: widget.isOverButton,
        menuOffset: widget.menuOffset,
        onSelect: (selectedOption) async {
          if (selectedOption == null) return;
          final selectedValue = selectedOption.value ?? '';
          final index = values.indexOf(selectedValue);
          if (index < 0 || index >= widget.options.length) return;

          if (isMultiSelect) {
            multiSelectController.value ??= [];
            final item = widget.options[index];
            if (multiSelectController.value!.contains(item)) {
              multiSelectController.value!.remove(item);
            } else {
              multiSelectController.value!.add(item);
            }
            multiSelectController.update();
          } else {
            controller.value = widget.options[index];
          }
        },
        // Phase 2: Arrow key callback for value cycling
        onArrowKey: isMultiSelect
            ? null
            : (direction) {
                if (widget.disabled) return;
                final options = widget.options;
                if (options.isEmpty) return;
                final current = controller.value;
                final currentIndex = current != null ? options.indexOf(current) : -1;
                final nextIndex = (currentIndex + direction).clamp(0, options.length - 1);
                if (nextIndex != currentIndex) {
                  controller.value = options[nextIndex];
                }
              },
      ),
    );
  }
}

// ============================================================================
// GenericDropdownWidget — trigger button that opens the menu overlay
// ============================================================================

class GenericDropdownWidget extends StatefulWidget {
  const GenericDropdownWidget({
    super.key,
    required this.keyPrefix,
    this.hintText,
    required this.dropdownLabels,
    required this.dropdownValues,
    this.initialOption,
    double? maxWidth,
    bool? isDisabled,
    double? dropdownMaxHeight,
    double? menuMaxHeight,
    this.onSelect,
    bool? showError,
    this.onClickDropdown,
    // Phase 1: Focus
    this.focusNode,
    this.focusColor,
    // Phase 2: Keyboard
    this.onArrowKey,
    // Phase 3: Styling
    this.borderWidth,
    this.borderRadius,
    this.borderColor,
    this.fillColor,
    this.elevation,
    this.margin,
    this.icon,
    this.textStyle,
    // Phase 4: Search
    bool? isSearchable,
    this.searchHintText,
    this.searchHintTextStyle,
    this.searchTextStyle,
    this.searchCursorColor,
    // Phase 5: Multi-select
    bool? isMultiSelect,
    this.multiSelectDisplayText,
    this.multiSelectSelectedLabels,
    // Phase 6: Label & polish
    this.labelText,
    this.labelTextStyle,
    bool? isOverButton,
    this.menuOffset,
  })  : maxWidth = maxWidth ?? 340.0,
        isDisabled = isDisabled ?? false,
        dropdownMaxHeight = dropdownMaxHeight ?? 400.0,
        menuMaxHeight = menuMaxHeight ?? 400.0,
        showError = showError ?? false,
        isSearchable = isSearchable ?? false,
        isMultiSelect = isMultiSelect ?? false,
        isOverButton = isOverButton ?? false;

  final String? keyPrefix;
  final String? hintText;
  final List<String>? dropdownLabels;
  final List<String>? dropdownValues;
  final String? initialOption;
  final double maxWidth;
  final bool isDisabled;
  final double dropdownMaxHeight;
  final double menuMaxHeight;
  final Future Function(AccessibilityDropDownItemStruct? selectedOption)? onSelect;
  final bool showError;
  final Future Function(bool onMenuOpend)? onClickDropdown;
  // Phase 1
  final FocusNode? focusNode;
  final Color? focusColor;
  // Phase 2
  final void Function(int direction)? onArrowKey;
  // Phase 3
  final double? borderWidth;
  final double? borderRadius;
  final Color? borderColor;
  final Color? fillColor;
  final double? elevation;
  final EdgeInsetsGeometry? margin;
  final Widget? icon;
  final TextStyle? textStyle;
  // Phase 4
  final bool isSearchable;
  final String? searchHintText;
  final TextStyle? searchHintTextStyle;
  final TextStyle? searchTextStyle;
  final Color? searchCursorColor;
  // Phase 5
  final bool isMultiSelect;
  final String? multiSelectDisplayText;
  final Set<String>? multiSelectSelectedLabels;
  // Phase 6
  final String? labelText;
  final TextStyle? labelTextStyle;
  final bool isOverButton;
  final Offset? menuOffset;

  @override
  State<GenericDropdownWidget> createState() => _GenericDropdownWidgetState();
}

class _GenericDropdownWidgetState extends State<GenericDropdownWidget> with TickerProviderStateMixin {
  late GenericDropdownModel _model;

  final animationsMap = <String, AnimationInfo>{};

  // Phase 1: Focus infrastructure
  late FocusNode _internalFocusNode;
  bool _isFocused = false;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode;

  Color get _defaultFocusColor => widget.focusColor ?? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12);

  // Phase 4: Search — no longer owned here; each menu dialog creates its own.

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GenericDropdownModel());

    // Phase 1: Focus setup
    _internalFocusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (widget.initialOption != null && widget.initialOption != '') {
        _model.selectedOptionValue = AccessibilityDropDownItemStruct(
          label: widget.initialOption,
          value: widget.initialOption,
        );
        safeSetState(() {});
      }
    });

    animationsMap.addAll({
      'iconOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          RotateEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 150.0.ms,
            begin: 0.0,
            end: -0.5,
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) => anim.trigger == AnimationTrigger.onActionTrigger || !anim.applyInitialState),
      this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void didUpdateWidget(covariant GenericDropdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync displayed value when parent rebuilds with a new selection
    if (widget.initialOption != oldWidget.initialOption) {
      if (widget.initialOption != null && widget.initialOption != '') {
        _model.selectedOptionValue = AccessibilityDropDownItemStruct(
          label: widget.initialOption,
          value: widget.initialOption,
        );
      }
    }
  }

  // Phase 1: Focus listener
  void _onFocusChange() {
    if (mounted) {
      setState(() => _isFocused = _focusNode.hasFocus);
    }
  }

  // Phase 2: Find popup scope for tab-to-focus
  bool _focusMenuOverlayItem() {
    final myScope = _focusNode.enclosingScope;
    if (myScope == null) return false;

    final viewScope = myScope.enclosingScope;
    if (viewScope == null) return false;

    final popupScope = _findPopupScope(viewScope, myScope);
    if (popupScope == null) return false;

    final focusableNodes = popupScope.traversalDescendants.where((n) => n.canRequestFocus).toList();
    if (focusableNodes.isNotEmpty) {
      focusableNodes[0].requestFocus();
      return true;
    }
    return false;
  }

  FocusScopeNode? _findPopupScope(FocusNode parent, FocusScopeNode exclude) {
    for (final child in parent.children) {
      if (child is FocusScopeNode && child != exclude) {
        return child;
      }
      final result = _findPopupScope(child, exclude);
      if (result != null) return result;
    }
    return null;
  }

  @override
  void dispose() {
    // Phase 1: Focus cleanup
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    _model.maybeDispose();
    super.dispose();
  }

  bool get _useDefaultIcon => widget.icon == null;

  void _animateIconForward() {
    if (!_useDefaultIcon) return;
    final anim = animationsMap['iconOnActionTriggerAnimation'];
    if (anim != null && anim.controller.duration != null) {
      anim.controller.forward(from: 0.0);
    }
  }

  void _animateIconReverse() {
    if (!_useDefaultIcon) return;
    final anim = animationsMap['iconOnActionTriggerAnimation'];
    if (anim != null && anim.controller.duration != null) {
      anim.controller.reverse();
    }
  }

  /// Focuses the first traversable descendant of [_focusNode] (i.e. the
  /// InkWell inside FFFocusIndicator) so the visual focus indicator appears.
  /// Falls back to [_focusNode] itself if no descendant is found.
  void _restoreFocusToTrigger() {
    final target = _firstTraversableDescendant(_focusNode);
    (target ?? _focusNode).requestFocus();
  }

  static FocusNode? _firstTraversableDescendant(FocusNode node) {
    for (final child in node.children) {
      if (child.canRequestFocus && !child.skipTraversal) {
        return child;
      }
      final desc = _firstTraversableDescendant(child);
      if (desc != null) return desc;
    }
    return null;
  }

  Future<void> _openMenu(BuildContext context) async {
    if (widget.isDisabled) return;

    // flip dropdown icon
    _animateIconForward();
    // menu open state update
    _model.isMenuOpen = true;
    safeSetState(() {});

    // Phase 6: isOverButton positioning
    final targetAnchor = widget.isOverButton
        ? AlignmentDirectional(-1.0, 0.0).resolve(Directionality.of(context))
        : AlignmentDirectional(-1.0, 1.0).resolve(Directionality.of(context));
    final followerAnchor = widget.isOverButton
        ? AlignmentDirectional(-1.0, 0.0).resolve(Directionality.of(context))
        : AlignmentDirectional(-1.0, -1.0).resolve(Directionality.of(context));

    // Show Dropdown Menu
    await showAlignedDialog(
      barrierColor: Colors.transparent,
      context: context,
      isGlobal: false,
      avoidOverflow: false,
      targetAnchor: targetAnchor,
      followerAnchor: followerAnchor,
      builder: (dialogContext) {
        return Material(
          color: Colors.transparent,
          child: Transform.translate(
            offset: widget.menuOffset ?? Offset.zero,
            child: _GenericDropDownMenuWidget(
              dropdownOptions: functions.accessibilityCombinedDropDown(
                  widget.dropdownLabels?.toList(), widget.dropdownValues?.toList()),
              menuMaxWidth: widget.maxWidth,
              menuMaxHeight: widget.menuMaxHeight,
              selectedOption: _model.selectedOptionValue?.label,
              keyPrefix: widget.keyPrefix!,
              // Phase 3: Styling
              elevation: widget.elevation,
              menuFillColor: widget.fillColor,
              menuBorderRadius: widget.borderRadius,
              itemTextStyle: widget.textStyle,
              // Phase 4: Search
              isSearchable: widget.isSearchable,
              searchHintText: widget.searchHintText,
              searchHintTextStyle: widget.searchHintTextStyle,
              searchTextStyle: widget.searchTextStyle,
              searchCursorColor: widget.searchCursorColor,
              // Phase 5: Multi-select
              isMultiSelect: widget.isMultiSelect,
              initialSelectedLabels: widget.multiSelectSelectedLabels ?? {},
              onMultiSelectToggle: widget.isMultiSelect
                  ? (item) async {
                      // Callback to parent for multi-select toggle
                      await widget.onSelect?.call(item);
                      safeSetState(() {});
                    }
                  : null,
            ),
          ),
        );
      },
    ).then((value) {
      safeSetState(() => _model.menuSelectedOption = value);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _restoreFocusToTrigger();
      });
    });

    // flip icon back
    _animateIconReverse();
    await widget.onClickDropdown?.call(true);
    // menu close state update
    _model.isMenuOpen = false;
    safeSetState(() {});

    // update selected option (single-select only)
    if (!widget.isMultiSelect) {
      _model.selectedOptionValue =
          _model.menuSelectedOption != null ? _model.menuSelectedOption : _model.selectedOptionValue;
      safeSetState(() {});
      // onSelection Callback
      await widget.onSelect?.call(_model.selectedOptionValue);
      // Restore VoiceOver / screen reader focus after the overlay closes.
      // On Flutter web, requestFocus() only updates Flutter's in-memory
      // focus tree — it does NOT call .focus() on the browser DOM element.
      // VoiceOver follows DOM focus, so we must explicitly call .focus()
      // on the <flt-semantics> element matching this dropdown's aria-label.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _restoreFocusToTrigger();
        final label = _getDisplayText();
        focusDomSemanticsElement(label);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Phase 2: Keyboard handling wrapper
    Widget trigger = Builder(
      builder: (context) => Semantics(
        button: true,
        focusable: true,
        label: _getDisplayText(),
        hint: 'Double tap to open dropdown',
        child: FFFocusIndicator(
          onTap: () async => _openMenu(context),
          border: Border.all(
            color: widget.borderColor ?? FlutterFlowTheme.of(context).primary,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 4.0),
          child: ExcludeSemantics(child: _buildTriggerContainer(context)),
        ),
      ),
    );

    // Phase 6: Label text
    if (widget.labelText != null && widget.labelText!.isNotEmpty) {
      trigger = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              widget.labelText!,
              style: widget.labelTextStyle ?? FlutterFlowTheme.of(context).bodySmall,
            ),
          ),
          trigger,
        ],
      );
    }

    // Phase 1 & 2: Focus + keyboard wrapper
    return Actions(
      actions: <Type, Action<Intent>>{
        if (_model.isMenuOpen) ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) => true),
      },
      child: Focus(
        skipTraversal: true,
        focusNode: _focusNode,
        onKeyEvent: (node, event) {
          if (event is! KeyDownEvent) return KeyEventResult.ignored;
          // Phase 2: Block Space/Enter when menu is open
          if (_model.isMenuOpen &&
              (event.logicalKey == LogicalKeyboardKey.space || event.logicalKey == LogicalKeyboardKey.enter)) {
            return KeyEventResult.handled;
          }
          // Phase 2: Arrow key cycling
          if (_model.isMenuOpen && event.logicalKey == LogicalKeyboardKey.arrowDown) {
            widget.onArrowKey?.call(1);
            return KeyEventResult.handled;
          } else if (_model.isMenuOpen && event.logicalKey == LogicalKeyboardKey.arrowUp) {
            widget.onArrowKey?.call(-1);
            return KeyEventResult.handled;
          }
          // Phase 2: Tab to focus menu items
          if (_model.isMenuOpen && event.logicalKey == LogicalKeyboardKey.tab) {
            if (_focusMenuOverlayItem()) {
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: trigger,
      ),
    );
  }

  Widget _buildTriggerContainer(BuildContext context) {
    final effectiveBorderWidth = widget.borderWidth ?? 1.0;
    final effectiveBorderRadius = widget.borderRadius ?? 4.0;

    return Container(
      constraints: BoxConstraints(
        minHeight: 37.0,
        maxWidth: widget.maxWidth,
        maxHeight: widget.dropdownMaxHeight,
      ),
      decoration: BoxDecoration(
        // Phase 1: Focus background color
        color: _isFocused
            ? _defaultFocusColor
            : valueOrDefault<Color>(
                widget.isDisabled
                    ? FlutterFlowTheme.of(context).accent4
                    : (widget.fillColor ?? FlutterFlowTheme.of(context).secondaryBackground),
                FlutterFlowTheme.of(context).secondaryBackground,
              ),
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        border: Border.all(
          color: valueOrDefault<Color>(
            () {
              if (_model.isMenuOpen) {
                return FlutterFlowTheme.of(context).accent2;
              } else if (widget.showError) {
                return FlutterFlowTheme.of(context).error;
              } else if (widget.isDisabled) {
                return FlutterFlowTheme.of(context).secondaryText;
              } else {
                return widget.borderColor ?? FlutterFlowTheme.of(context).secondary;
              }
            }(),
            FlutterFlowTheme.of(context).secondaryText,
          ),
          width: effectiveBorderWidth,
        ),
      ),
      child: Padding(
        padding: widget.margin ?? EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                _getDisplayText(),
                style: widget.textStyle ??
                    GoogleFonts.notoSans(
                      color: valueOrDefault<Color>(
                        widget.isDisabled
                            ? FlutterFlowTheme.of(context).secondaryText
                            : FlutterFlowTheme.of(context).primaryText,
                        FlutterFlowTheme.of(context).primaryText,
                      ),
                      fontSize: 14.0,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            widget.icon ??
                Icon(
                  Icons.keyboard_arrow_down,
                  color: widget.isDisabled
                      ? FlutterFlowTheme.of(context).secondaryText
                      : FlutterFlowTheme.of(context).primaryText,
                  size: 20.0,
                ).animateOnActionTrigger(
                  animationsMap['iconOnActionTriggerAnimation']!,
                ),
          ],
        ),
      ),
    );
  }

  String _getDisplayText() {
    // Phase 5: Multi-select display
    if (widget.isMultiSelect && widget.multiSelectDisplayText != null) {
      return widget.multiSelectDisplayText!;
    }
    return valueOrDefault<String>(
      _model.selectedOptionValue?.label != null && _model.selectedOptionValue?.label != ''
          ? _model.selectedOptionValue?.label
          : widget.hintText,
      'Please Select',
    );
  }
}

// ============================================================================
// GenericDropdownModel
// ============================================================================

class GenericDropdownModel extends FlutterFlowModel<GenericDropdownWidget> {
  AccessibilityDropDownItemStruct? selectedOptionValue;
  void updateSelectedOptionValueStruct(Function(AccessibilityDropDownItemStruct) updateFn) {
    updateFn(selectedOptionValue ??= AccessibilityDropDownItemStruct());
  }

  bool isMenuOpen = false;
  AccessibilityDropDownItemStruct? menuSelectedOption;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

// ============================================================================
// _GenericDropDownMenuWidget — popup overlay containing the list of items
// ============================================================================

class _GenericDropDownMenuWidget extends StatefulWidget {
  const _GenericDropDownMenuWidget({
    super.key,
    this.dropdownOptions,
    double? menuMaxWidth,
    this.menuMaxHeight,
    this.selectedOption,
    required this.keyPrefix,
    // Phase 3: Styling
    this.elevation,
    this.menuFillColor,
    this.menuBorderRadius,
    this.itemTextStyle,
    // Phase 4: Search
    this.isSearchable = false,
    this.searchHintText,
    this.searchHintTextStyle,
    this.searchTextStyle,
    this.searchCursorColor,
    // Phase 5: Multi-select
    this.isMultiSelect = false,
    this.onMultiSelectToggle,
    this.initialSelectedLabels = const {},
  }) : menuMaxWidth = menuMaxWidth ?? 340.0;

  final List<AccessibilityDropDownItemStruct>? dropdownOptions;
  final double menuMaxWidth;
  final double? menuMaxHeight;
  final String? selectedOption;
  final String? keyPrefix;
  // Phase 3
  final double? elevation;
  final Color? menuFillColor;
  final double? menuBorderRadius;
  final TextStyle? itemTextStyle;
  // Phase 4
  final bool isSearchable;
  final String? searchHintText;
  final TextStyle? searchHintTextStyle;
  final TextStyle? searchTextStyle;
  final Color? searchCursorColor;
  // Phase 5
  final bool isMultiSelect;
  final Future Function(AccessibilityDropDownItemStruct item)? onMultiSelectToggle;
  final Set<String> initialSelectedLabels;

  @override
  State<_GenericDropDownMenuWidget> createState() => _GenericDropDownMenuWidgetState();
}

class _GenericDropDownMenuWidgetState extends State<_GenericDropDownMenuWidget> {
  final _shortcutsFocusNode = FocusNode();
  late final TextEditingController _searchController;
  late Set<String> _selectedLabels;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _selectedLabels = Set<String>.from(widget.initialSelectedLabels);
    if (widget.isSearchable) {
      _searchController.addListener(_onSearchChanged);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  void _onSearchChanged() {
    if (mounted) {
      setState(() {
        _searchQuery = _searchController.text;
      });
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _shortcutsFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.menuBorderRadius ?? 4.0;
    final allOptions = widget.dropdownOptions?.toList() ?? [];

    // Phase 4: Filter options by search
    final options = widget.isSearchable && _searchQuery.isNotEmpty
        ? allOptions.where((item) => (item.label).toLowerCase().contains(_searchQuery.toLowerCase())).toList()
        : allOptions;

    return Shortcuts(
      shortcuts: {
        SingleActivator(LogicalKeyboardKey.escape): VoidCallbackIntent(() {
          Navigator.of(context).pop();
        }),
        SingleActivator(LogicalKeyboardKey.arrowUp): VoidCallbackIntent(() async {
          FocusScope.of(context).previousFocus();
        }),
        SingleActivator(LogicalKeyboardKey.arrowDown): VoidCallbackIntent(() async {
          FocusScope.of(context).nextFocus();
        }),
      },
      child: Actions(
        actions: {
          VoidCallbackIntent: CallbackAction<VoidCallbackIntent>(
            onInvoke: (intent) => intent.callback(),
          ),
        },
        child: Focus(
          autofocus: isShortcutsSupported,
          focusNode: _shortcutsFocusNode,
          skipTraversal: true,
          child: GestureDetector(
            onTap: () => _shortcutsFocusNode.canRequestFocus
                ? FocusScope.of(context).requestFocus(_shortcutsFocusNode)
                : FocusScope.of(context).unfocus(),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
              child: FocusTraversalGroup(
                policy: OrderedTraversalPolicy(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: widget.menuMaxWidth,
                      maxHeight: widget.menuMaxHeight!,
                    ),
                    decoration: BoxDecoration(
                      color: widget.menuFillColor ?? FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: widget.elevation != null ? widget.elevation! * 2.0 : 12.0,
                          color: Colors.black,
                          offset: Offset(0.0, 0.0),
                          spreadRadius: 0.0,
                        )
                      ],
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Phase 4: Search field
                        if (widget.isSearchable)
                          Container(
                              height: 50,
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 4,
                                right: 8,
                                left: 8,
                              ),
                              child: TextField(
                                expands: true,
                                maxLines: null,
                                controller: _searchController,
                                cursorColor: widget.searchCursorColor,
                                style: widget.searchTextStyle,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  hintText: widget.searchHintText ?? 'Search...',
                                  hintStyle: widget.searchHintTextStyle,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              )),
                        // Options list
                        Flexible(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: options.length,
                            itemBuilder: (context, optionsIndex) {
                              final optionsItem = options[optionsIndex];
                              return Semantics(
                                label: optionsItem.label,
                                selected: widget.isMultiSelect
                                    ? _selectedLabels.contains(optionsItem.label)
                                    : optionsItem.label == widget.selectedOption,
                                focusable: true,
                                child: FFFocusIndicator(
                                  onTap: () async {
                                    if (widget.isMultiSelect) {
                                      // Phase 5: Toggle local state and notify parent
                                      final label = optionsItem.label;
                                      if (_selectedLabels.contains(label)) {
                                        _selectedLabels.remove(label);
                                      } else {
                                        _selectedLabels.add(label);
                                      }
                                      await widget.onMultiSelectToggle?.call(optionsItem);
                                      if (mounted) setState(() {});
                                    } else {
                                      // Single-select: close and return value
                                      Navigator.pop(context, optionsItem);
                                    }
                                  },
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(borderRadius),
                                  child: ExcludeSemantics(
                                      child: _GenericDropDownMenuItemWidget(
                                    key: Key('Keyvbp_${optionsIndex}_of_${options.length}'),
                                    keyPrefix: widget.keyPrefix!,
                                    itemLabel: optionsItem.label,
                                    isSelected: widget.isMultiSelect
                                        ? _selectedLabels.contains(optionsItem.label)
                                        : optionsItem.label == widget.selectedOption,
                                    textStyle: widget.itemTextStyle,
                                    // Phase 5: Multi-select checkbox
                                    isMultiSelect: widget.isMultiSelect,
                                  )),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// _GenericDropDownMenuItemWidget — individual menu item with hover effect
// ============================================================================

class _GenericDropDownMenuItemWidget extends StatefulWidget {
  const _GenericDropDownMenuItemWidget({
    super.key,
    required this.keyPrefix,
    required this.itemLabel,
    bool? isSelected,
    this.textStyle,
    bool? isMultiSelect,
  })  : isSelected = isSelected ?? false,
        isMultiSelect = isMultiSelect ?? false;

  final String? keyPrefix;
  final String? itemLabel;
  final bool isSelected;
  final TextStyle? textStyle;
  final bool isMultiSelect;

  @override
  State<_GenericDropDownMenuItemWidget> createState() => _GenericDropDownMenuItemWidgetState();
}

class _GenericDropDownMenuItemWidgetState extends State<_GenericDropDownMenuItemWidget> {
  bool _mouseRegionHovered = false;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.itemLabel != null && widget.itemLabel != '',
      child: MouseRegion(
        opaque: false,
        cursor: MouseCursor.defer,
        onEnter: (event) => setState(() => _mouseRegionHovered = true),
        onExit: (event) => setState(() => _mouseRegionHovered = false),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 45.0),
          decoration: BoxDecoration(
            color: () {
              if (widget.isSelected) {
                return FlutterFlowTheme.of(context).accent2;
              } else if (_mouseRegionHovered) {
                return FlutterFlowTheme.of(context).accent1;
              } else {
                return FlutterFlowTheme.of(context).secondaryBackground;
              }
            }(),
          ),
          child: Align(
            alignment: AlignmentDirectional(-1.0, 0.0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 12.0, 12.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Phase 5: Multi-select checkbox
                  if (widget.isMultiSelect) ...[
                    Icon(
                      widget.isSelected ? Icons.check_box_outlined : Icons.check_box_outline_blank,
                      size: 20.0,
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(
                      widget.itemLabel!,
                      style: widget.textStyle ??
                          GoogleFonts.notoSans(
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 14.0,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
