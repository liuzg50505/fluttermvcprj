import 'package:flutter/widgets.dart';
import 'package:fluttermvc/src/adaptor.dart';

/**
 * 元数据定义
 */
abstract class MetaObjectData {
  /**
   * 获取属性property的值
   * property: 属性名
   * return: 返回属性property的值
   */
  Object get(String property);

  /**
   * 设置属性property的值
   * property: 属性名
   * value: 属性值
   */
  void set(String property, Object value);

  /// 获取全部的属性名称
  Set<String> get properties;

  /// 获取全部的方法名称
  Set<String> get methods;

  /// 创建一个对象实例
  Object newinstance();
}

/**
 * 元数据
 */
abstract class MetaObject {
  /// 获取对象的元数据定义
  MetaObjectData getMetaData();
}


class MetaObjectWrapper extends MetaObject {

  MetaObject metaObject;
  Map<String, Object> mapdata;
  bool shadowFirst;

  MetaObjectWrapper(this.metaObject, {this.shadowFirst=true}){
    mapdata = Map();
  }

  @override
  MetaObjectData getMetaData() {
    return MetaObjectDataWrapper(this);
  }

}

class MetaObjectDataWrapper extends MetaObjectData {

  MetaObjectWrapper metaObjectWrapper;
  MetaObjectDataWrapper(this.metaObjectWrapper);

  @override
  Object get(String property) {
    if(metaObjectWrapper.shadowFirst) {
      if(metaObjectWrapper.mapdata.containsKey(property)) {
        return metaObjectWrapper.mapdata[property];
      }else{
        return metaObjectWrapper.metaObject.getMetaData().get(property);
      }
    }else{
      if(metaObjectWrapper.metaObject.getMetaData().properties.contains(property)) {
        return metaObjectWrapper.metaObject.getMetaData().get(property);
      }else if(metaObjectWrapper.metaObject.getMetaData().methods.contains(property)) {
        return metaObjectWrapper.metaObject.getMetaData().get(property);
      } else{
        return metaObjectWrapper.mapdata[property];
      }
    }
  }

  @override
  Set<String> get methods => getmethodnames();

  Set<String> getmethodnames() {
    Set<String> methodnames = Set();
    methodnames.addAll(metaObjectWrapper.metaObject.getMetaData().methods);
    for (String key in metaObjectWrapper.mapdata.keys){
      if(metaObjectWrapper.mapdata[key] is Function) {
        methodnames.add(key);
      }
    }
    return methodnames;
  }

  Set<String> getpropertynames() {
    Set<String> propertynames = Set();
    propertynames.addAll(metaObjectWrapper.metaObject.getMetaData().properties);
    for (String key in metaObjectWrapper.mapdata.keys){
      if(!(metaObjectWrapper.mapdata[key] is Function)) {
        propertynames.add(key);
      }
    }
    return propertynames;
  }

  @override
  Object newinstance() {
    return MetaObjectWrapper(metaObjectWrapper.metaObject.getMetaData().newinstance());
  }

  @override
  Set<String> get properties => getpropertynames();

  @override
  void set(String property, Object value) {
    if(metaObjectWrapper.metaObject.getMetaData().properties.contains(property)){
      metaObjectWrapper.metaObject.getMetaData().set(property, value);
    }else if(metaObjectWrapper.metaObject.getMetaData().properties.contains(property)){
      metaObjectWrapper.metaObject.getMetaData().set(property, value);
    }else{
      metaObjectWrapper.mapdata[property] = value;
    }
  }

}

abstract class Controller {
  BuildContext buildContext;
}

abstract class View<T > {
  View(this.dataContext, [this.state]);

  T dataContext;
  State state;

  Widget build(BuildContext context);

  update() {
    state.setState((){});
  }

  Widget buildcontroller(BuildContext context, View view) {
    return view.build(context);
  }

  WrapperBuilder get wrapper => WrapperBuilder();

}

class EmptyController extends Controller{

}

abstract class MetaController extends Controller implements MetaObject {

}

class WrapperBuilder {

  WrapperBuilder prebuilder_;
  Function applyfunc_;

  WrapperBuilder({this.prebuilder_, this.applyfunc_});

  WrapperBuilder paddingAll(double p) {
    var applyfunc = (targetwidget) => Padding(padding: EdgeInsets.all(p), child: targetwidget,);
    return WrapperBuilder(prebuilder_: this, applyfunc_: applyfunc);
  }

  WrapperBuilder expanded([int flex = 1]) {
    var applyfunc = (targetwidget) => Expanded(flex: flex, child: targetwidget,);
    return WrapperBuilder(prebuilder_: this, applyfunc_: applyfunc);
  }

  WrapperBuilder gesture({GestureTapDownCallback onTapDown, GestureTapUpCallback onTapUp}){
    var applyfunc = (targetwidget) => GestureDetector(onTapDown: onTapDown,onTapUp: onTapUp, child: targetwidget,);
    return WrapperBuilder(prebuilder_: this, applyfunc_: applyfunc);
  }

  Widget apply(Widget target) {
    var applyfuncs = [];
    var cur = this;
    while(cur!=null) {
      applyfuncs.add(cur.applyfunc_);
      cur = cur.prebuilder_;
    }
    Widget curwidget = target;
    for(var applyfunc in applyfuncs.reversed){
      if (applyfunc!=null) {
        curwidget = applyfunc(curwidget);
      }
    }
    return curwidget;
  }
}
