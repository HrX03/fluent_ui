// import 'package:flutter/material.dart' as m;
import 'package:flutter/foundation.dart';

import 'package:fluent_ui/fluent_ui.dart';

import 'theme.dart';

abstract class BaseButton extends StatefulWidget {
  const BaseButton({
    Key? key,
    required this.onPressed,
    required this.onLongPress,
    required this.style,
    required this.focusNode,
    required this.autofocus,
    required this.child,
  }) : super(key: key);

  /// Called when the button is tapped or otherwise activated.
  ///
  /// If this callback and [onLongPress] are null, then the button will be disabled.
  ///
  /// See also:
  ///
  ///  * [enabled], which is true if the button is enabled.
  final VoidCallback? onPressed;

  /// Called when the button is long-pressed.
  ///
  /// If this callback and [onPressed] are null, then the button will be disabled.
  ///
  /// See also:
  ///
  ///  * [enabled], which is true if the button is enabled.
  final VoidCallback? onLongPress;

  /// Customizes this button's appearance.
  ///
  /// Null by default.
  final ButtonStyle? style;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// Typically the button's label.
  final Widget child;

  @protected
  ButtonStyle defaultStyleOf(BuildContext context);

  @protected
  ButtonStyle? themeStyleOf(BuildContext context);

  /// Whether the button is enabled or disabled.
  ///
  /// Buttons are disabled by default. To enable a button, set its [onPressed]
  /// or [onLongPress] properties to a non-null value.
  bool get enabled => onPressed != null || onLongPress != null;

  @override
  _BaseButtonState createState() => _BaseButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(FlagProperty('enabled', value: enabled, ifFalse: 'disabled'));
    properties.add(
        DiagnosticsProperty<ButtonStyle>('style', style, defaultValue: null));
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode,
        defaultValue: null));
  }
}

class _BaseButtonState extends State<BaseButton> {
  double _scaleFactor = 1.0;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    final ThemeData theme = FluentTheme.of(context);

    final ButtonStyle? widgetStyle = widget.style;
    final ButtonStyle? themeStyle = widget.themeStyleOf(context);
    final ButtonStyle defaultStyle = widget.defaultStyleOf(context);

    T? effectiveValue<T>(T? Function(ButtonStyle? style) getProperty) {
      final T? widgetValue = getProperty(widgetStyle);
      final T? themeValue = getProperty(themeStyle);
      final T? defaultValue = getProperty(defaultStyle);
      return widgetValue ?? themeValue ?? defaultValue;
    }

    final double zFactor = effectiveValue<double?>((ButtonStyle? style) =>
            style?.zFactor?.resolve({ButtonStates.pressing})) ??
        1.0;

    final Widget result = HoverButton(
      onLongPress: widget.onLongPress,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      cursor: ButtonState.resolveWith((states) {
        return effectiveValue<MouseCursor?>(
                (style) => style?.cursor?.resolve(states)) ??
            MouseCursor.defer;
      }),
      onTapDown: !widget.enabled
          ? null
          : () {
              if (mounted) setState(() => _scaleFactor = zFactor);
            },
      onLongPressStart: !widget.enabled
          ? null
          : () {
              if (mounted) setState(() => _scaleFactor = zFactor);
            },
      onLongPressEnd: !widget.enabled
          ? null
          : () {
              if (mounted) setState(() => _scaleFactor = 1);
            },
      onPressed: !widget.enabled
          ? null
          : () async {
              widget.onPressed!();
              if (mounted) setState(() => _scaleFactor = zFactor);
              await Future.delayed(Duration(milliseconds: 120));
              if (mounted) setState(() => _scaleFactor = 1);
            },
      builder: (context, states) {
        T? resolve<T>(
            ButtonState<T>? Function(ButtonStyle? style) getProperty) {
          return effectiveValue(
            (ButtonStyle? style) => getProperty(style)?.resolve(states),
          );
        }

        final double? resolvedElevation =
            resolve<double?>((ButtonStyle? style) => style?.elevation);
        final TextStyle? resolvedTextStyle =
            resolve<TextStyle?>((ButtonStyle? style) => style?.textStyle);
        final Color? resolvedBackgroundColor =
            resolve<Color?>((ButtonStyle? style) => style?.backgroundColor);
        final Color? resolvedForegroundColor =
            resolve<Color?>((ButtonStyle? style) => style?.foregroundColor);
        final Color? resolvedShadowColor =
            resolve<Color?>((ButtonStyle? style) => style?.shadowColor);
        final EdgeInsetsGeometry resolvedPadding = resolve<EdgeInsetsGeometry?>(
                (ButtonStyle? style) => style?.padding) ??
            EdgeInsets.zero;
        final BorderSide? resolvedBorder =
            resolve<BorderSide?>((ButtonStyle? style) => style?.border);
        final OutlinedBorder resolvedShape =
            resolve<OutlinedBorder?>((ButtonStyle? style) => style?.shape) ??
                RoundedRectangleBorder();

        final EdgeInsetsGeometry padding = resolvedPadding
            .add(EdgeInsets.symmetric(
              horizontal: theme.visualDensity.horizontal,
              vertical: theme.visualDensity.vertical,
            ))
            .clamp(EdgeInsets.zero, EdgeInsetsGeometry.infinity);
        Widget result = PhysicalModel(
          color: Colors.transparent,
          shadowColor: resolvedShadowColor ?? const Color(4278190080),
          elevation: resolvedElevation ?? 0.0,
          child: AnimatedContainer(
            transformAlignment: Alignment.center,
            transform: Matrix4.diagonal3Values(_scaleFactor, _scaleFactor, 1.0),
            duration: FluentTheme.of(context).fastAnimationDuration,
            curve: FluentTheme.of(context).animationCurve,
            decoration: ShapeDecoration(
              shape: resolvedShape.copyWith(side: resolvedBorder),
              color: resolvedBackgroundColor,
            ),
            padding: padding,
            child: IconTheme.merge(
              data: IconThemeData(color: resolvedForegroundColor),
              child: DefaultTextStyle(
                style: (resolvedTextStyle ?? TextStyle(inherit: true))
                    .copyWith(color: resolvedForegroundColor),
                textAlign: TextAlign.center,
                child: widget.child,
              ),
            ),
          ),
        );
        return FocusBorder(child: result, focused: states.isFocused);
      },
    );

    return Semantics(
      container: true,
      button: true,
      enabled: widget.enabled,
      child: result,
    );
  }
}
