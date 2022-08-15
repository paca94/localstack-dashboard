import 'package:flutter/material.dart';

class ScrollableNavigationRail extends StatelessWidget {
  final int selectedIndex;
  final List<NavigationRailDestination> items;
  final Widget? leading;
  final Color? backgroundColor;

  final Function onSelect;

  const ScrollableNavigationRail(
      {Key? key,
      required this.selectedIndex,
      required this.items,
      this.leading,
      required this.onSelect,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NavigationRailThemeData navigationRailTheme =
        NavigationRailTheme.of(context);
    final NavigationRailThemeData defaults = _TokenDefaultsM3(context);
    // final MaterialLocalizations localizations =
    //     MaterialLocalizations.of(context);

    final Color currentBackgroundColor = backgroundColor ??
        navigationRailTheme.backgroundColor ??
        defaults.backgroundColor!;

    return Material(
      color: currentBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (leading != null) leading!,
          if (leading != null)
            const SizedBox(
              height: 8,
            ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...items.map(
                    (e) => InkWell(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                        child: Column(
                          children: [
                            e.icon,
                            if (selectedIndex == items.indexOf(e))
                              const Icon(Icons.check),
                          ],
                        ),
                      ),
                      onTap: () {
                        final idx = items.indexOf(e);
                        onSelect(idx);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
        ],
      ),
    );
  }
}

class _TokenDefaultsM3 extends NavigationRailThemeData {
  _TokenDefaultsM3(this.context)
      : super(
          elevation: 0.0,
          groupAlignment: -1,
          labelType: NavigationRailLabelType.none,
          useIndicator: true,
          minWidth: 80.0,
          minExtendedWidth: 256,
        );

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  @override
  Color? get backgroundColor => _colors.surface;

  @override
  TextStyle? get unselectedLabelTextStyle {
    return _textTheme.labelMedium!.copyWith(color: _colors.onSurface);
  }

  @override
  TextStyle? get selectedLabelTextStyle {
    return _textTheme.labelMedium!.copyWith(color: _colors.onSurface);
  }

  @override
  IconThemeData? get unselectedIconTheme {
    return IconThemeData(
      size: 24.0,
      color: _colors.onSurfaceVariant,
    );
  }

  @override
  IconThemeData? get selectedIconTheme {
    return IconThemeData(
      size: 24.0,
      color: _colors.onSecondaryContainer,
    );
  }

  @override
  Color? get indicatorColor => _colors.secondaryContainer;
}
