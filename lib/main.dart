import 'package:flutter/material.dart';
import 'package:fluttermvc/fluttermvc.dart';

void main() {
  AddressBookController rootController =
      AddressBookController(title: 'www', cards: [
    CardController('wang1', '13332244432', 'sdf fsd 23.st'),
    CardController('wang2', '13332244432', 'sdf fsd 23.st'),
  ]);
  AddressBookView rootView = AddressBookView(rootController);

//  runApp(MaterialApp(
//    home: WidgetAdaptor(rootView),
//  ));
  runApp(MaterialApp(
    home: WidgetAdaptor(HomeView(EmptyController())),
  ));
}

class AddressBookController extends Controller {
  String title;
  List<CardController> cards;
  int i = 0;

  AddressBookController({this.title, this.cards}) {
    if(cards==null) cards = [];
  }

  void onAddClick() {
    cards.add(CardController('name$i', 'phone$i', 'address$i'));
    i++;
  }
}

class CardController extends Controller {
  String name;
  String phonenumber;
  String address;

  CardController(this.name, this.phonenumber, this.address);

  void onMakeCallClick() {
    print('onmakecall');
  }
}

class HomeView extends View<EmptyController> {
  HomeView(EmptyController controller) : super(controller);

  Color c;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyApp"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          wrapper.expanded(1).apply(WidgetAdaptor(AddressBookView(AddressBookController()))),
          Container(
            decoration: BoxDecoration(color: Colors.black12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      child: Column(
                        children: <Widget>[Icon(Icons.add), Text('Tab1')],
                      ),
                      color: c,
                    ),
                    onTapDown: (a) {
                      c = Colors.red;
                      update();
                    },
                    onTapUp: (a) {
                      c = Colors.transparent;
                      update();
                    },
                  ),
                  flex: 1,
                ),
                wrapper
                    .paddingAll(4)
                    .gesture(onTapDown: (e) => c = Colors.red)
                    .expanded(1)
                    .apply(Column(
                  children: <Widget>[Icon(Icons.receipt), Text('Tab1')],
                )),
                Expanded(
                  child: Container(
                    child: Column(
                      children: <Widget>[Icon(Icons.receipt), Text('Tab1')],
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      children: <Widget>[Icon(Icons.delete), Text('Tab1')],
                    ),
                  ),
                  flex: 1,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

}

class AddressBookView extends View<AddressBookController> {
  AddressBookView(AddressBookController controller) : super(controller);

  @override
  Widget build(BuildContext context) {
    var r = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        RaisedButton(
          onPressed: () {
            dataContext.onAddClick();
            update();
          },
          child: Text('Add Elem'),
        ),
        Expanded(
            child: RefreshIndicator(
              child: ListView(
                children: dataContext.cards
                    .map((card) => buildcontroller(context, CardView(card)))
                    .toList(),
              ),
              onRefresh: () async {
                print('refreshing');
              },
            )),
      ],
    );
    r.children.add(Text('a'));
    return r;
  }
}

class CardView extends View<CardController> {
  CardView(CardController controller) : super(controller);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Row(children: <Widget>[
          wrapper.paddingAll(20).expanded().apply(Column(
            children: <Widget>[
              Text('Name: ${dataContext.name}'),
              Text('Phone: ${dataContext.phonenumber}'),
              Text('Address: ${dataContext.address}'),
            ],
            crossAxisAlignment: CrossAxisAlignment.stretch,
          )),
          Icon(Icons.call)
        ],)
    );
  }

}
