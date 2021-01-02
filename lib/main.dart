import 'dart:async';

import 'package:MarsTime/rover.dart';
import 'package:MarsTime/time.dart';
import 'package:flutter/material.dart';

// mainly boiler plate code

void main() {
  runApp(MarsClock());
}

class MarsClock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mars Time',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Clock(title: 'Mars Time'),
    );
  }
}

// the Clock widget, which is essentially abstract until represented by a state
class Clock extends StatefulWidget {
  Clock({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ClockState createState() => _ClockState();
}

// the Clock state which will update repeatedly
class _ClockState extends State<Clock> {
  Map<String, Rover> _roverData = {};
  static const duration = const Duration(seconds: 1);
  Timer timer;

  @override
  void initState() {
    super.initState();
    // use a timer to repeatedly update the clock state
    if (timer == null)
      timer = Timer.periodic(duration, (Timer t) {
        _update();
      });
  }

  void _update() {
    // when the state gets set, it triggers a widget update
    setState(() {
      _roverData = getTimes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Mars time:',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '${_roverData.values.join("\n\n")}',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
      // for manual updates only
      floatingActionButton: FloatingActionButton(
        onPressed: _update,
        tooltip: 'manual update',
        child: Icon(Icons.add),
      ),
    );
  }
}
