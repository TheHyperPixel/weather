import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/core/presentation/styles/app_colors_delegate.dart';
import 'package:provider/provider.dart';

class AppScreen extends StatefulWidget {
  final Widget child;
  final bool systemBackEnabled;
  final List<DeviceOrientation> preferredOrientations;
  final bool? resizeToAvoidBottomInset;
  final bool topSafeArea;
  final bool bottomSafeArea;
  final Color? backgroundColor;

  const AppScreen({
    Key? key,
    required this.child,
    this.systemBackEnabled = true,
    this.preferredOrientations = const [DeviceOrientation.portraitUp],
    this.topSafeArea = false,
    this.bottomSafeArea = false,
    this.resizeToAvoidBottomInset,
    this.backgroundColor,
  }) : super(key: key);

  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> with RouteAware {
  late RouteObserver _routeObserver;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations(this.widget.preferredOrientations);
  }

  @override
  void didPopNext() {
    super.didPopNext();

    SystemChrome.setPreferredOrientations(this.widget.preferredOrientations);
  }

  @override
  void didChangeDependencies() {
    this._routeObserver = Provider.of<RouteObserver>(context);
    this._routeObserver.subscribe(this, ModalRoute.of(context)!);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _routeObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      backgroundColor:
          this.widget.backgroundColor ?? AppColorsDelegate.of(context).dust,
      resizeToAvoidBottomInset: this.widget.resizeToAvoidBottomInset,
      body: SafeArea(
        top: this.widget.topSafeArea,
        bottom: this.widget.bottomSafeArea,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: this.widget.child,
        ),
      ),
    );

    if (this.widget.systemBackEnabled) {
      return scaffold;
    } else {
      return WillPopScope(
        onWillPop: () => Future.value(false),
        child: scaffold,
      );
    }
  }
}
