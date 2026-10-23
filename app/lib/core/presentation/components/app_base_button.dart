import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBaseButton extends StatefulWidget {
  final Widget child;
  final String? tooltip;
  final SystemMouseCursor? systemMouseCursor;
  final void Function()? onTap;
  final void Function()? onHoverIn;
  final void Function()? onHoverOut;

  const AppBaseButton({
    super.key,
    this.tooltip,
    required this.child,
    this.systemMouseCursor,
    this.onTap,
    this.onHoverIn,
    this.onHoverOut,
  });

  @override
  _AppBaseButtonState createState() => _AppBaseButtonState();
}

class _AppBaseButtonState extends State<AppBaseButton> {
  late GlobalKey _key;

  @override
  void initState() {
    super.initState();

    this._key = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return this._tooltip(
      child: MouseRegion(
        key: this._key,
        onHover: (event) {
          this.widget.onHoverIn?.call();
        },
        onExit: (event) {
          this.widget.onHoverOut?.call();
        },
        cursor: this.widget.onTap == null
            ? MouseCursor.defer
            : this.widget.systemMouseCursor ?? SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            this.widget.onTap?.call();
          },
          behavior: HitTestBehavior.opaque,
          child: this.widget.child,
        ),
      ),
    );
  }

  Widget _tooltip({required Widget child}) {
    if (this.widget.tooltip != null) {
      return Tooltip(
        waitDuration: const Duration(seconds: 2),
        preferBelow: false,
        verticalOffset: 10,
        message: this.widget.tooltip,
        child: child,
      );
    }
    return child;
  }
}
