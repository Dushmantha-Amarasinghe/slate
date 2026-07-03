import 'package:flutter/material.dart';

import 'toolbar_chip.dart';

/// A [ToolbarChip] that opens a dropdown menu anchored under itself when
/// tapped — for any picker that reads better as "tap for a short menu"
/// than a full-screen dialog or a long row of standalone chips (Search's
/// filter chips, the task editor's tag picker once there are too many
/// tags to lay out as a chip row). Handles the anchor-position math so
/// callers don't need a GlobalKey.
class DropdownChip<T> extends StatelessWidget {
  const DropdownChip({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.itemBuilder,
    required this.onSelected,
    this.onClear,
  });

  final Widget icon;
  final String label;
  final bool selected;
  final List<PopupMenuEntry<T>> Function(BuildContext context) itemBuilder;
  final ValueChanged<T> onSelected;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext anchorContext) {
        return ToolbarChip(
          icon: icon,
          label: label,
          selected: selected,
          onClear: onClear,
          onTap: () async {
            final RenderBox button = anchorContext.findRenderObject()! as RenderBox;
            final RenderBox overlay =
                Overlay.of(anchorContext).context.findRenderObject()! as RenderBox;
            final RelativeRect position = RelativeRect.fromRect(
              Rect.fromPoints(
                button.localToGlobal(Offset.zero, ancestor: overlay),
                button.localToGlobal(button.size.bottomLeft(Offset.zero), ancestor: overlay),
              ),
              Offset.zero & overlay.size,
            );
            final T? picked = await showMenu<T>(
              context: anchorContext,
              position: position,
              items: itemBuilder(anchorContext),
            );
            if (picked != null) onSelected(picked);
          },
        );
      },
    );
  }
}
