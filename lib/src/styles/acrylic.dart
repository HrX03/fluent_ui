import 'dart:ui' show ImageFilter;

import 'package:flutter/foundation.dart';

import 'package:fluent_ui/fluent_ui.dart';

final kDefaultAcrylicFilter = ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0);

/// Value eyballed from Windows 10 v10.0.19041.928
const double kDefaultAcrylicOpacity = 0.8;

/// Acrylic is a type of Brush that creates a translucent texture.
/// You can apply acrylic to app surfaces to add depth and help
/// establish a visual hierarchy.
///
/// ![Acrylic Example](https://docs.microsoft.com/en-us/windows/uwp/design/style/images/acrylic_lighttheme_base.png)
class Acrylic extends StatelessWidget {
  /// The [color] and [decoration] arguments can not be both supplied.
  const Acrylic({
    Key? key,
    this.color,
    this.decoration,
    this.filter,
    this.child,
    this.opacity = kDefaultAcrylicOpacity,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.shadowColor,
    this.elevation = 0.0,
  })  : assert(elevation >= 0, 'The elevation can NOT be negative'),
        assert(opacity >= 0, 'The opacity can NOT be negative'),
        assert(
          elevation == 0.0 || opacity == 1.0,
          'You can NOT provide both opacity and elevation',
        ),
        super(key: key);

  /// The color to fill the background of the box.
  ///
  /// If [decoration] and this is null, [ThemeData.acrylicBackgroundColor]
  /// is used.
  final Color? color;

  /// The decoration to paint behind the [child].
  ///
  /// Use the [color] property to specify a simple solid color.
  final BoxDecoration? decoration;

  /// The opacity applied to the [color] from 0.0 to 1.0. If [enabled] is `false`,
  /// this has no effect
  final double opacity;

  /// The image filter to apply to the existing painted content before painting the
  /// child. If null, [kDefaultAcrylicFilter] is used. If [enabled] if `false`, this
  /// has no effect.
  ///
  /// For example, consider using [ImageFilter.blur] to create a backdrop blur effect.
  final ImageFilter? filter;

  /// The child contained by this box
  final Widget? child;

  /// The width of the box
  final double? width;

  /// The height of the box
  final double? height;

  /// Empty space to inscribe inside the [decoration].
  /// The [child], if any, is placed inside this padding.
  final EdgeInsetsGeometry? padding;

  /// Empty space to surround the [decoration] and [child].
  final EdgeInsetsGeometry? margin;

  /// The color of the elevation
  final Color? shadowColor;

  /// The z-coordinate relative to the parent at which to place this physical object.
  ///
  /// The value is non-negative.
  final double elevation;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
    properties.add(DiagnosticsProperty<Decoration>('decoration', decoration));
    properties.add(DoubleProperty('opacity', opacity));
    properties.add(DiagnosticsProperty<ImageFilter>('filter', filter));
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('height', height));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('margin', margin));
    properties.add(ColorProperty('shadowColor', shadowColor));
    properties.add(DoubleProperty('elevation', elevation));
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    final style = FluentTheme.of(context);
    final color = AccentColor.resolve(
      this.color ?? style.acrylicBackgroundColor,
      context,
    );

    final enabled = NoAcrylicBlurEffect.of(context) == null;
    final opacity = enabled ? this.opacity : 1.0;
    Widget result = SizedBox(
      width: width,
      height: height,
      child: () {
        Widget container = Container(
          padding: padding,
          decoration: () {
            if (decoration != null) {
              Color? color = decoration!.color ?? this.color;
              if (color != null) color = color.withOpacity(opacity);
              return decoration!.copyWith(color: color);
            }
            return BoxDecoration(color: color.withOpacity(opacity));
          }(),
          child: child,
        );
        if (enabled)
          return ClipRect(
            child: BackdropFilter(
              filter: filter ?? kDefaultAcrylicFilter,
              child: container,
            ),
          );
        return container;
      }(),
    );
    if (elevation > 0) {
      result = PhysicalModel(
        color: Colors.transparent,
        shadowColor: shadowColor ?? FluentTheme.of(context).shadowColor,
        shape: BoxShape.rectangle,
        borderRadius: () {
          final radius = decoration?.borderRadius;
          if (radius == null) return BorderRadius.zero;
          if (radius is BorderRadius) return radius;
          return BorderRadius.zero;
        }(),
        elevation: elevation,
        child: result,
      );
    }
    if (margin != null) result = Padding(padding: margin!, child: result);
    return result;
  }
}

class AnimatedAcrylic extends ImplicitlyAnimatedWidget {
  const AnimatedAcrylic({
    Key? key,
    this.color,
    this.decoration,
    this.filter,
    this.child,
    this.opacity = kDefaultAcrylicOpacity,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.shadowColor,
    this.elevation = 0.0,
    Curve curve = Curves.linear,
    required Duration duration,
  }) : super(key: key, curve: curve, duration: duration);

  /// The color to fill the background of the box.
  ///
  /// If [decoration] and this is null, [ThemeData.acrylicBackgroundColor]
  /// is used.
  final Color? color;

  /// The decoration to paint behind the [child].
  ///
  /// Use the [color] property to specify a simple solid color.
  final BoxDecoration? decoration;

  /// The opacity applied to the [color] from 0.0 to 1.0. If [enabled] is `false`,
  /// this has no effect
  final double opacity;

  /// The image filter to apply to the existing painted content before painting the
  /// child. If null, [kDefaultAcrylicFilter] is used. If [enabled] if `false`, this
  /// has no effect.
  ///
  /// For example, consider using [ImageFilter.blur] to create a backdrop blur effect.
  final ImageFilter? filter;

  /// The child contained by this box
  final Widget? child;

  /// The width of the box
  final double? width;

  /// The height of the box
  final double? height;

  /// Empty space to inscribe inside the [decoration].
  /// The [child], if any, is placed inside this padding.
  final EdgeInsetsGeometry? padding;

  /// Empty space to surround the [decoration] and [child].
  final EdgeInsetsGeometry? margin;

  /// The color of the elevation
  final Color? shadowColor;

  /// The z-coordinate relative to the parent at which to place this physical object.
  ///
  /// The value is non-negative.
  final double elevation;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
    properties.add(DiagnosticsProperty<Decoration>('decoration', decoration));
    properties.add(DoubleProperty('opacity', opacity));
    properties.add(DiagnosticsProperty<ImageFilter>('filter', filter));
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('height', height));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('margin', margin));
    properties.add(ColorProperty('shadowColor', shadowColor));
    properties.add(DoubleProperty('elevation', elevation));
  }

  @override
  _AnimatedAcrylicState createState() => _AnimatedAcrylicState();
}

class _AnimatedAcrylicState extends AnimatedWidgetBaseState<AnimatedAcrylic> {
  EdgeInsetsGeometryTween? _padding;
  EdgeInsetsGeometryTween? _margin;
  DecorationTween? _decoration;
  ColorTween? _color;
  Tween<double?>? _height;
  Tween<double?>? _width;
  ColorTween? _elevationColor;
  Tween<double?>? _opacity;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _padding = visitor(
            _padding,
            widget.padding,
            (dynamic value) =>
                EdgeInsetsGeometryTween(begin: value as EdgeInsetsGeometry))
        as EdgeInsetsGeometryTween?;
    _margin = visitor(
            _margin,
            widget.margin,
            (dynamic value) =>
                EdgeInsetsGeometryTween(begin: value as EdgeInsetsGeometry))
        as EdgeInsetsGeometryTween?;
    _decoration = visitor(_decoration, widget.decoration,
            (dynamic value) => DecorationTween(begin: value as Decoration))
        as DecorationTween?;
    _color = visitor(_color, widget.color,
        (dynamic value) => ColorTween(begin: value as Color)) as ColorTween?;
    _height = visitor(_height, widget.height,
            (dynamic value) => Tween<double>(begin: value as double))
        as Tween<double>?;
    _width = visitor(_width, widget.width,
            (dynamic value) => Tween<double>(begin: value as double))
        as Tween<double>?;
    _elevationColor = visitor(_elevationColor, widget.shadowColor,
        (dynamic value) => ColorTween(begin: value as Color)) as ColorTween?;
  }

  @override
  Widget build(BuildContext context) {
    return Acrylic(
      padding: _padding?.evaluate(animation),
      margin: _margin?.evaluate(animation),
      decoration: _decoration?.evaluate(animation) as BoxDecoration?,
      color: _color?.evaluate(animation),
      height: _height?.evaluate(animation),
      width: _width?.evaluate(animation),
      opacity: _opacity?.evaluate(animation) ?? kDefaultAcrylicOpacity,
      shadowColor: _elevationColor?.evaluate(animation),
      filter: widget.filter,
      child: widget.child,
    );
  }
}

/// A widget that can disable the acrylic blur effect if wrapped above
/// an Acrylic.
///
/// {@toolsnippet}
///
/// The following code shows how to disable the acrylic blur effect on
/// the whole app:
///
/// ```dart
/// runApp(NoAcrylicBlurEffect(child: MyApp()));
/// ```
///
/// {@end-tool}
///
/// See also:
///   * [Acrylic], the widget that can apply a blurred background on its child
///   * [Container], a widget similar to acrylic, but with less options
class NoAcrylicBlurEffect extends InheritedWidget {
  /// Creates a widget that disable the acrylic blur effect in its tree
  const NoAcrylicBlurEffect({
    Key? key,
    required this.child,
  }) : super(key: key, child: child);

  final Widget child;

  static NoAcrylicBlurEffect? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NoAcrylicBlurEffect>();
  }

  @override
  bool updateShouldNotify(NoAcrylicBlurEffect oldWidget) {
    return true;
  }
}
