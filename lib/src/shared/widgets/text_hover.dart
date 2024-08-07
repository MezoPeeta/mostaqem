import 'package:flutter/material.dart';

import 'package:mostaqem/src/shared/widgets/hover_builder.dart';

class TextHover extends StatelessWidget {
  const TextHover({
    required this.text, super.key,
    this.onTap,
  });

  final String text;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return HoverBuilder(builder: (isHovered) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Text(
            text,
            style: TextStyle(
                decoration:
                    isHovered ? TextDecoration.underline : TextDecoration.none,
                color: isHovered
                    ? Theme.of(context).colorScheme.onSecondaryContainer
                    : Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer
                        .withOpacity(0.5),),
          ),
        ),
      );
    },);
  }
}
