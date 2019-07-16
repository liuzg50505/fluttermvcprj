import 'package:flutter/widgets.dart';
import 'base.dart';

class WidgetAdaptor extends StatefulWidget {

  View view;

  WidgetAdaptor(this.view);

  @override
  State<StatefulWidget> createState() {
    return WidgetAdaptorState(view);
  }
}

class WidgetAdaptorState extends State<StatefulWidget> {
  View view;

  WidgetAdaptorState(this.view) {
    view.state = this;
  }

  @override
  Widget build(BuildContext context) {
    view.dataContext.buildContext = context;
    var widget = view.build(context);
    return widget;
  }

}