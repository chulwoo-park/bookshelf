import 'package:bookshelf/feature/book/domain/usecase.dart';
import 'package:flutter/widgets.dart';

class ServiceLocator extends StatefulWidget {
  static Dependencies of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Dependencies>();

  const ServiceLocator({
    Key key,
    @required this.dependencies,
  }) : super(key: key);

  final Dependencies dependencies;

  @override
  _ServiceLocatorState createState() => _ServiceLocatorState();
}

class _ServiceLocatorState extends State<ServiceLocator> {
  @override
  void didUpdateWidget(covariant ServiceLocator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dependencies.updateShouldNotify(oldWidget.dependencies)) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.dependencies;
  }
}

class Dependencies extends InheritedWidget {
  Dependencies({
    Key key,
    @required Widget child,
    @required this.search,
  })  : assert(child != null),
        super(
          key: key,
          child: child,
        );

  final SearchUseCase search;

  @override
  bool updateShouldNotify(Dependencies old) {
    return child != old.child || search != old.search;
  }
}
