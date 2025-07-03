import 'package:flutter/material.dart';

class CustomToggleSwitch extends StatelessWidget {
  final bool isSecondOption;
  final Widget firstOption;
  final Widget secondOption;
  final VoidCallback onTap;

  const CustomToggleSwitch({
    super.key,
    required this.isSecondOption,
    required this.firstOption,
    required this.secondOption,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(19),
                  bottomLeft: Radius.circular(19),
                ),
                color: !isSecondOption
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
              ),
              child: Center(
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: !isSecondOption
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.4),
                  ),
                  child: IconTheme(
                    data: IconThemeData(
                      color: !isSecondOption
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.4),
                      size: 24,
                    ),
                    child: firstOption,
                  ),
                ),
              ),
            ),
            Container(
              width: 40,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(19),
                  bottomRight: Radius.circular(19),
                ),
                color: isSecondOption
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
              ),
              child: Center(
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: isSecondOption
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.4),
                  ),
                  child: IconTheme(
                    data: IconThemeData(
                      color: isSecondOption
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.4),
                      size: 24,
                    ),
                    child: secondOption,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
