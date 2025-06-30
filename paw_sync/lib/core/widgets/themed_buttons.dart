// lib/core/widgets/themed_buttons.dart

import 'package:flutter/material.dart';
// No direct import of AppColors needed if we rely on Theme.of(context)

/// A primary action button, typically an ElevatedButton using theme's primary color.
class PrimaryActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? iconData;
  final bool isLoading; // To show a loading indicator

  const PrimaryActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.iconData,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = Theme.of(context).elevatedButtonTheme.style?.copyWith(
      // You could use AppColors.highlight here if primary is too muted for main CTAs
      // backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
      // foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onPrimary),
    );

    Widget buttonChild = Text(text);
    if (iconData != null && !isLoading) {
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, size: Theme.of(context).textTheme.labelLarge?.fontSize), // Match text size
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }
    if (isLoading) {
      buttonChild = SizedBox(
        width: Theme.of(context).textTheme.labelLarge?.fontSize, // Square shape for spinner
        height: Theme.of(context).textTheme.labelLarge?.fontSize,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.onPrimary),
        ),
      );
    }

    return ElevatedButton(
      style: buttonStyle,
      onPressed: isLoading ? null : onPressed, // Disable button when loading
      child: buttonChild,
    );
  }
}

/// A secondary action button, typically an OutlinedButton or TextButton.
class SecondaryActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? iconData;

  const SecondaryActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    // Using OutlinedButton as an example for secondary actions
    final buttonStyle = Theme.of(context).outlinedButtonTheme.style?.copyWith(
      // Potentially use secondary color for border/text if desired:
      // side: MaterialStateProperty.all(BorderSide(color: Theme.of(context).colorScheme.secondary)),
      // foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
    );

    if (iconData != null) {
      return OutlinedButton.icon(
        style: buttonStyle,
        icon: Icon(iconData, size: Theme.of(context).textTheme.labelLarge?.fontSize),
        label: Text(text),
        onPressed: onPressed,
      );
    }
    return OutlinedButton(
      style: buttonStyle,
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

/// A destructive action button, typically styled with the theme's error color.
class DestructiveActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? iconData;
  final bool isLoading;

  const DestructiveActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.iconData,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Using TextButton for a less prominent destructive action, or ElevatedButton for more emphasis
    final buttonStyle = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.error,
      // If using ElevatedButton:
      // backgroundColor: Theme.of(context).colorScheme.error,
      // foregroundColor: Theme.of(context).colorScheme.onError,
      textStyle: Theme.of(context).textTheme.labelLarge, // Ensure consistency
    );

    Widget buttonChild = Text(text);
    if (iconData != null && !isLoading) {
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, size: Theme.of(context).textTheme.labelLarge?.fontSize),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }
     if (isLoading) {
      buttonChild = SizedBox(
        width: Theme.of(context).textTheme.labelLarge?.fontSize,
        height: Theme.of(context).textTheme.labelLarge?.fontSize,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.error),
        ),
      );
    }

    return TextButton( // Or ElevatedButton
      style: buttonStyle,
      onPressed: isLoading ? null : onPressed,
      child: buttonChild,
    );
  }
}
