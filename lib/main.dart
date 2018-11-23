import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization_black_screen/l10n/localizations.dart';
import 'package:rxdart/rxdart.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  BehaviorSubject<String> dataController = BehaviorSubject<String>();

  Future<void> _fetchData() async {
    String data = await Future.delayed(Duration(seconds: 3), () => "Data");
    dataController.add(data);
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: dataController.stream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
          snapshot.hasData
              ? DataProvider(
                  data: snapshot.data,
                  child: MaterialApp(
                    localizationsDelegates: const <
                        LocalizationsDelegate<dynamic>>[
                      AppLocalizationsDelegate(),
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                    ],
                    supportedLocales: const <Locale>[
                      Locale('en', ''),
                    ],
                    title: 'Flutter Demo',
                    theme: ThemeData(
                      primarySwatch: Colors.blue,
                    ),
                    home: MyHomePage(),
                  ),
                )
              : MaterialApp(
                  localizationsDelegates: const <
                      LocalizationsDelegate<dynamic>>[
                    AppLocalizationsDelegate(),
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  supportedLocales: const <Locale>[
                    Locale('en', ''),
                  ],
                  title: 'Flutter Demo',
                  theme: ThemeData(
                    primarySwatch: Colors.red,
                  ),
                  home: SplashPage(dataStream: dataController.stream),
                ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Container(),
    );
  }
}

class SplashPage extends StatelessWidget {
  final Stream<String> dataStream;

  const SplashPage({Key key, this.dataStream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: StreamBuilder(
          stream: dataStream,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
              snapshot.hasError
                  ? Container(
                      color: Colors.red,
                    )
                  : Center(child: CircularProgressIndicator())),
    );
  }
}

class DataProvider extends StatelessWidget {
  final String data;

  final Widget child;

  const DataProvider({@required this.child, this.data});

  static DataProvider of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedDataProvider)
            as _InheritedDataProvider)
        .data;
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedDataProvider(data: this, child: child);
  }
}

class _InheritedDataProvider extends InheritedWidget {
  final DataProvider data;

  const _InheritedDataProvider(
      {Key key, @required this.data, @required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
