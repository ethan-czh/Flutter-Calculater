import 'package:flutter/material.dart';

const _regExpUnexpectCharCombining = "(^(×|÷)\\d)|([\\+\\-×÷]{2})";
const _regExpSpecialNumber = "(^0\\d)|(\\D0\\d)";
const _regExpCharMDFormula = "(^\\-|^\\+)?\\d+(\\.\\d+)?[×÷]\\d+(\\.\\d+)?";
const _regExpCharASFormula = "(^\\-|^\\+)?\\d+(\\.\\d+)?[\\+\\-]\\d+(\\.\\d+)?";
const _regExpCharMD = "(?<=\\d)[×÷]";
const _regExpCharAS = "(?<=\\d)[\\+\\-]";
enum Buttons {
  zero,
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  equal,
  add,
  substract,
  multiply,
  divide,
  delete,
  cancel
}

const buttonTips = {
  Buttons.zero: '0',
  Buttons.one: '1',
  Buttons.two: '2',
  Buttons.three: '3',
  Buttons.four: '4',
  Buttons.five: '5',
  Buttons.six: '6',
  Buttons.seven: '7',
  Buttons.eight: '8',
  Buttons.nine: '9',
  Buttons.equal: '=',
  Buttons.add: '+',
  Buttons.substract: '-',
  Buttons.multiply: '×',
  Buttons.divide: '÷',
  Buttons.delete: '←',
  Buttons.cancel: 'c',
};
//['0','1','2','3','4','5','6','7','8','9','=','+','-','×','÷','←','c'];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculater',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Calculater'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _formulaText = "";
  var _resultText = "";

  String _calculate(String fText) {
    //to do 增加计算方法
    String calTemp = "";
    if (_checkText(fText)) {
      calTemp = "Error";
    } else {
      calTemp = _doAMutiplyOrDivide(fText);
      calTemp = _doAAddOrSubstract(calTemp);
    }
    return calTemp;
  }

  String _doAMutiplyOrDivide(String fText) {
    String strTemp = RegExp(_regExpCharMDFormula).stringMatch(fText);
    String result = fText;
    if (null != strTemp) {
      List<String> argList = strTemp.split(new RegExp(_regExpCharMD));
      if (argList.length == 2) {
        double argFirst = double.parse(argList[0]);
        double argSecond = double.parse(argList[1]);
        double calTemp = 0;
        if (strTemp.contains(buttonTips[Buttons.multiply])) {
          calTemp = argFirst * argSecond;
        } else {
          calTemp = argFirst / argSecond;
        }
        result = _doAMutiplyOrDivide(
            fText.replaceFirst(strTemp, calTemp.toString()));
      }
    }
    return result;
  }

  String _doAAddOrSubstract(String fText) {
    String strTemp = RegExp(_regExpCharASFormula).stringMatch(fText);
    String result = fText;
    if (null != strTemp) {
      List<String> argList = strTemp.split(new RegExp(_regExpCharAS));
      if (argList.length == 2) {
        double argFirst = double.parse(argList[0]);
        double argSecond = double.parse(argList[1]);
        double calTemp = 0;
        if (strTemp.contains(buttonTips[Buttons.add])) {
          calTemp = argFirst + argSecond;
        } else {
          calTemp = argFirst - argSecond;
        }
        result =
            _doAAddOrSubstract(fText.replaceFirst(strTemp, calTemp.toString()));
      }
    }
    return result;
  }

  bool _checkText(String fText) {
    bool ret = false;
    if (null != fText) {
      if (RegExp(_regExpSpecialNumber).firstMatch(fText) != null) {
        ret = true;
      }
      if (RegExp(_regExpUnexpectCharCombining).firstMatch(fText) != null) {
        ret = true;
      }
    }

    return ret;
  }

  String _fixFormulaText(String fText) {
    if (_checkText(fText)) {
      String lastChar = fText.substring(fText.length - 1);
      return fText.substring(0, fText.length - 2) + lastChar;
    } else {
      return fText;
    }
  }

  void _buttonTap(result) {
    var textTemp = _formulaText;
    var resultTemp = "";
    if (Buttons.equal == result) {
      resultTemp = _calculate(textTemp);
    } else if (Buttons.delete == result) {
      if (textTemp.length > 0) {
        textTemp = textTemp.length > 1
            ? textTemp.substring(0, textTemp.length - 1)
            : "";
      }
    } else if (Buttons.cancel == result) {
      textTemp = "";
    } else {
      textTemp += buttonTips[result];
      textTemp = _fixFormulaText(textTemp);
    }
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _formulaText = textTemp;
      _resultText = resultTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.all(10),
                child: new Text(
                  '$_formulaText',
                  style: Theme.of(context).textTheme.headline3,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.all(10),
                child: new Text(
                  '$_resultText',
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: new BoxDecoration(
                            border: new Border.all(
                                width: 0.0, color: Colors.greenAccent)),
                        height: double.infinity,
                        // padding: EdgeInsets.all(10.0),
                        child: RaisedButton(
                          onPressed: () {
                            _buttonTap(Buttons.cancel);
                          },
                          child: new Text(buttonTips[Buttons.cancel]),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        child: RaisedButton(
                          onPressed: () {
                            _buttonTap(Buttons.divide);
                          },
                          child: new Text(buttonTips[Buttons.divide]),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        child: RaisedButton(
                          onPressed: () {
                            _buttonTap(Buttons.multiply);
                          },
                          child: new Text(buttonTips[Buttons.multiply]),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        child: RaisedButton(
                          onPressed: () {
                            _buttonTap(Buttons.delete);
                          },
                          child: new Text(buttonTips[Buttons.delete]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      child: RaisedButton(
                        onPressed: () {
                          _buttonTap(Buttons.seven);
                        },
                        child: new Text(buttonTips[Buttons.seven]),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    height: double.infinity,
                    child: RaisedButton(
                      onPressed: () {
                        _buttonTap(Buttons.eight);
                      },
                      child: new Text(buttonTips[Buttons.eight]),
                    ),
                  )),
                  Expanded(
                      child: Container(
                    height: double.infinity,
                    child: RaisedButton(
                      onPressed: () {
                        _buttonTap(Buttons.nine);
                      },
                      child: new Text(buttonTips[Buttons.nine]),
                    ),
                  )),
                  Expanded(
                      child: Container(
                    height: double.infinity,
                    child: RaisedButton(
                      onPressed: () {
                        _buttonTap(Buttons.substract);
                      },
                      child: new Text(buttonTips[Buttons.substract]),
                    ),
                  )),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                    height: double.infinity,
                    child: RaisedButton(
                      onPressed: () {
                        _buttonTap(Buttons.four);
                      },
                      child: new Text(buttonTips[Buttons.four]),
                    ),
                  )),
                  Expanded(
                      child: Container(
                    height: double.infinity,
                    child: RaisedButton(
                      onPressed: () {
                        _buttonTap(Buttons.five);
                      },
                      child: new Text(buttonTips[Buttons.five]),
                    ),
                  )),
                  Expanded(
                      child: Container(
                    height: double.infinity,
                    child: RaisedButton(
                      onPressed: () {
                        _buttonTap(Buttons.six);
                      },
                      child: new Text(buttonTips[Buttons.six]),
                    ),
                  )),
                  Expanded(
                      child: Container(
                    height: double.infinity,
                    child: RaisedButton(
                      onPressed: () {
                        _buttonTap(Buttons.add);
                      },
                      child: new Text(buttonTips[Buttons.add]),
                    ),
                  )),
                ],
              ),
            ),
            Expanded(
                flex: 2,
                child: Row(children: [
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                  child: Container(
                                height: double.infinity,
                                child: RaisedButton(
                                  onPressed: () {
                                    _buttonTap(Buttons.one);
                                  },
                                  child: new Text(buttonTips[Buttons.one]),
                                ),
                              )),
                              Expanded(
                                  child: Container(
                                height: double.infinity,
                                child: RaisedButton(
                                  onPressed: () {
                                    // _buttonTap(Buttons.cancel);
                                  },
                                  // child: new Text(buttonTips[Buttons.cancel]),
                                ),
                              )),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(children: [
                            Expanded(
                                child: Container(
                              height: double.infinity,
                              child: RaisedButton(
                                onPressed: () {
                                  _buttonTap(Buttons.two);
                                },
                                child: new Text(buttonTips[Buttons.two]),
                              ),
                            )),
                            Expanded(
                                child: Container(
                              height: double.infinity,
                              child: RaisedButton(
                                onPressed: () {
                                  _buttonTap(Buttons.zero);
                                },
                                child: new Text(buttonTips[Buttons.zero]),
                              ),
                            )),
                          ]),
                        ),
                        Expanded(
                            child: Column(children: [
                          Expanded(
                              child: Container(
                            height: double.infinity,
                            child: RaisedButton(
                              onPressed: () {
                                _buttonTap(Buttons.three);
                              },
                              child: new Text(buttonTips[Buttons.three]),
                            ),
                          )),
                          Expanded(
                              child: Container(
                            height: double.infinity,
                            child: RaisedButton(
                              onPressed: () {
                                // _buttonTap(Buttons.multiply);
                              },
                              // child: new Text(buttonTips[Buttons.multiply]),
                            ),
                          )),
                        ])),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: RaisedButton(
                        onPressed: () {
                          _buttonTap(Buttons.equal);
                        },
                        child: new Text(buttonTips[Buttons.equal]),
                      ),
                    ),
                  ),
                ]))
          ],
        ),
      ),
    );
  }
}
