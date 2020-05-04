import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('images/FinalIcon.ico'),
          ),
          title: Text('Salary Calculator'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.people,
                color: Colors.white,
              ),
              onPressed: () {
                Alert(
                  context: _scaffoldKey.currentContext,
                  title: "Verma Software",
                  desc:
                      "This app is created by SKVERMA. Contact skverma31@gmail.com for more!",
                ).show();
              },
            ),
          ],
          backgroundColor: Colors.teal.shade400,
        ),
        body: MainBodyScreen(),
      ),
    );
  }
}

class MainBodyScreen extends StatefulWidget {
  @override
  _MainBodyScreenState createState() => _MainBodyScreenState();
}

class _MainBodyScreenState extends State<MainBodyScreen> {
  final _text = TextEditingController();
  bool _validate = false;
  bool _tapped = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> stackChildren = [
      SizedBox.expand(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    style: TextStyle(
                      fontSize: 22.0,
                    ),
                    keyboardType: TextInputType.number,
                    controller: _text,
                    decoration: InputDecoration(
                      labelText: 'Enter Gross Salary',
                      errorText: _validate ? 'enter valid input' : null,
                    ),
                    onTap: () {
                      setState(() {
                        _text.clear();
                        _tapped = true;
                      });
                    },
                  ),
                  Divider(),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        if (_text.text.isEmpty ||
                            double.tryParse(_text.text) == null) {
                          _validate = true;
                        } else {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          _validate = false;
                        }
                      });
                    },
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Calculate',
                        style: TextStyle(
                          fontSize: 22.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      //_buildDraggableScrollableSheet(),
    ];

    if (_validate == false) {
      if (_tapped == true) {
        if (stackChildren.length > 1) stackChildren.removeAt(1);
        _tapped = false;
      }
      if (_text.text.length > 0)
        stackChildren.insert(
            1, _buildDraggableScrollableSheet(double.tryParse(_text.text)));
    } else {
      if (stackChildren.length > 1) stackChildren.removeAt(1);
    }

    return Stack(
      children: stackChildren,
    );
  }
}

ListTile createTile(String label, double amount) {
  return ListTile(
    title: Chip(
      backgroundColor: Colors.black,
      padding: EdgeInsets.all(10.0),
      label: Text(
        '$label: $amount',
        style: TextStyle(
          fontSize: 20.0,
          wordSpacing: 5.0,
          color: Colors.white,
        ),
      ),
    ),
  );
}

DraggableScrollableSheet _buildDraggableScrollableSheet(double cGross) {
  double cBasic = (cGross > 25000)
      ? ((cGross * 60) / 100)
      : (cGross > 15999
              ? 16000
              : (cGross > 15000
                  ? (cGross * 100) / 100
                  : (cGross > 9400 ? 9400 : (cGross * 100) / 100)))
          .roundToDouble();

  double cDA = 0.0;

  double cHRA = (cGross > 15000
          ? (cGross - cBasic > (cBasic * 40) / 100
              ? (cBasic * 40) / 100
              : cGross - cBasic)
          : cGross - cBasic)
      .roundToDouble();

  double cMedical = cGross > 25000 ? 1250 : 0;

  double cTransport = cGross > 25000 ? 800 : 0;

  double cSpecial = cGross - (cBasic + cDA + cHRA + cMedical + cTransport);

  double cPF = (cGross > 15000 ? 0 : (cBasic * 12) / 100).roundToDouble();

  double cGratuity = ((cBasic * 15 / 26) / 12).roundToDouble();

  double cCTC = cGross + cPF + cGratuity;

  List<String> _labels = [
    'Basic',
    'DA',
    'HRA',
    'Medical',
    'Special',
    'Transport',
    'GrossPay',
    'PF',
    'Gratuity/month',
    'CTC',
  ];

  List<double> _values = [
    cBasic,
    cDA,
    cHRA,
    cMedical,
    cSpecial,
    cTransport,
    cGross,
    cPF,
    cGratuity,
    cCTC
  ];

  List<Widget> tiles = [];
  for (int i = 0; i < 10; i++) {
    tiles.add(
      createTile(_labels[i], _values[i]),
    );
  }

  return DraggableScrollableSheet(
    initialChildSize: 0.2,
    minChildSize: 0.2,
    maxChildSize: 0.8,
    builder: (BuildContext context, ScrollController scrollController) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        child: ListView(
          controller: scrollController,
          children: tiles,
        ),
      );
    },
  );
}
