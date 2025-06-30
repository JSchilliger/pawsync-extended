// lib/core/widgets/styled_card.dart

import 'package:flutter/material.dart';

/// A wrapper around the standard [Card] widget that applies default styling
/// from the application's theme and allows for common overrides.
///
/// This helps maintain a consistent card appearance throughout the app.
class StyledCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding; // Padding inside the card, around the child
  final double? elevation;
  final Color? backgroundColor; // Overrides CardTheme.color
  final ShapeBorder? shape;     // Overrides CardTheme.shape
  final Clip? clipBehavior;
  final VoidCallback? onTap; // Optional: to make the card tappable

  const StyledCard({
    super.key,
    required this.child,
    this.margin,
    this.padding, // Default padding can be applied if null
    this.elevation,
    this.backgroundColor,
    this.shape,
    this.clipBehavior,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardTheme = Theme.of(context).cardTheme;

    final effectiveBackgroundColor = backgroundColor ?? cardTheme.color ?? Theme.of(context).colorScheme.surface;
    final effectiveElevation = elevation ?? cardTheme.elevation ?? 2.0; // Default elevation if not in theme
    final effectiveShape = shape ?? cardTheme.shape ?? RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Default shape if not in theme
    );
    final effectiveMargin = margin ?? cardTheme.margin ?? const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0);
    final effectiveClipBehavior = clipBehavior ?? cardTheme.clipBehavior ?? Clip.none;

    final effectivePadding = padding ?? const EdgeInsets.all(16.0); // Default internal padding

    Widget cardContent = Padding(
      padding: effectivePadding,
      child: child,
    );

    if (onTap != null) {
      return Card(
        margin: effectiveMargin,
        elevation: effectiveElevation,
        color: effectiveBackgroundColor,
        shape: effectiveShape,
        clipBehavior: effectiveClipBehavior,
        child: InkWell( // Make the card tappable
          onTap: onTap,
          borderRadius: _getBorderRadius(effectiveShape), // Match InkWell radius to card shape
          child: cardContent,
        ),
      );
    }

    return Card(
      margin: effectiveMargin,
      elevation: effectiveElevation,
      color: effectiveBackgroundColor,
      shape: effectiveShape,
      clipBehavior: effectiveClipBehavior,
      child: cardContent,
    );
  }

  /// Helper to extract BorderRadius from ShapeBorder for InkWell
  BorderRadius? _getBorderRadius(ShapeBorder shape) {
    if (shape is RoundedRectangleBorder && shape.borderRadius is BorderRadius) {
      return shape.borderRadius as BorderRadius;
    }
    return null; // Or a default BorderRadius if preferred
  }
}
