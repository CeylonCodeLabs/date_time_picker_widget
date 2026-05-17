import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(title: 'Date Time Picker Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

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
  Color _color = Colors.blue;
  String _d1 = '', _d2 = '';
  String _t1 = '', _t2 = '';
  bool _material3 = true;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _color,
          primary: _color,
          secondary: _color,
        ),
        useMaterial3: _material3,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 24),
                  CheckboxListTile(
                    value: _material3,
                    title: Text(
                      'Use Material 3',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _material3 = value ?? true;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Color Pallet',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  _colorPallet(),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),
                  _dateTimePicker(),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),
                  _datePicker(),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),
                  _timePicker(),
                  const Divider(),
                  const SizedBox(height: 24),
                  _newDatetimePicker(),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _newDatetimePicker(){
    final dt = DateTime.now();
    final dtMin = DateTime.now().add(const Duration(hours: 1, minutes: 0));
    final dtMax = dtMin.add(const Duration(
      days: 4,
    ));
    debugPrint('dt: ${dt.toString()}');
    debugPrint('dtMin: ${dtMin.toString()}');
    debugPrint('dtMax: ${dtMax.toString()}');

    return Container(
        child: DateTimePicker(
          initialSelectedDate: dtMin,
          startDate: dtMin,
          //.subtract(const Duration(days: 1)),
          endDate: dtMax,
          startTime: dt,
          endTime: dtMax,
          timeInterval: const Duration(minutes: 15),
          datePickerTitle: 'Pick your preferred date',
          timePickerTitle: 'Pick your preferred time',
          timeOutOfRangeError: 'Sorry shop is closed now',
          is24h: false,
          numberOfWeeksToDisplay: 1,
          locale: 'es',
          customStringWeekdays: const ['D', 'L', 'M', 'X', 'J', 'V', 'S'],
          onDateChanged: (date) {
            setState(() {
              _d1 = DateFormat('dd MMM, yyyy').format(date);
            });
          },
          onTimeChanged: (time) {
            setState(() {
              _t1 = DateFormat('hh:mm:ss aa').format(time);
            });
          },
        ) /*DateTimePicker(
        /*initialSelectedDate: dtMin.add(const Duration(minutes: 5)),
        startDate: dtMin,
        endDate: dtMax,
        startTime: dtMin,
        endTime: dtMax,//DateTime(dt.year, dt.month, dt.day, 18),
        timeInterval: interval,*/
        initialSelectedDate: dt,
        startDate: dt.subtract(const Duration(days: 1)),
        endDate: dt.add(const Duration(days: 60)),
        startTime: DateTime(dt.year, dt.month, dt.day, 6),
        endTime: DateTime(dt.year, dt.month, dt.day, 18),
        timeInterval: const Duration(minutes: 15),
        datePickerTitle: 'Elige la fecha',
        timePickerTitle: 'Elige la hora',
        timeOutOfRangeError: 'Fuera del rango',
        is24h: true,
        locale: "es",
        customStringWeekdays: ["D", "L", "M", "X", "J", "V", "S"],
        onDateChanged: (date) {
          //setState(() {
          final _d1 = DateFormat('dd MMM, yyyy').format(date);
          debugPrint("onDateChanged d1: $_d1");
          //});
        },
        onTimeChanged: (time) {
          //setState(() {
          final _t1 = DateFormat('hh:mm:ss aa').format(time);
          debugPrint("onDateChanged t1: $_t1");
          //});
        },
      ),*/
    );
  }

  Widget _dateTimePicker() {
    final dt = DateTime.now();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Date & Time Picker',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'Date: $_d1  Time: $_t1',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        DateTimePicker(
          initialSelectedDate: dt,
          startDate: dt.subtract(const Duration(days: 1)),
          endDate: dt.add(const Duration(days: 60)),
          startTime: DateTime(dt.year, dt.month, dt.day, 6),
          endTime: DateTime(dt.year, dt.month, dt.day, 18),
          timeInterval: const Duration(minutes: 15),
          datePickerTitle: 'Pick your preferred date',
          timePickerTitle: 'Pick your preferred time',
          timeOutOfRangeError: 'Sorry shop is closed now',
          is24h: false,
          numberOfWeeksToDisplay: 4,
          onDateChanged: (date) {
            setState(() {
              _d1 = DateFormat('dd MMM, yyyy').format(date);
            });
          },
          onTimeChanged: (time) {
            setState(() {
              _t1 = DateFormat('hh:mm:ss aa').format(time);
            });
          },
        )
      ],
    );
  }

  Widget _datePicker() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Date Picker',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'Date: $_d2',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        DateTimePicker(
          type: DateTimePickerType.Date,
          onDateChanged: (date) {
            setState(() {
              _d2 = DateFormat('dd MMM, yyyy').format(date);
            });
          },
        )
      ],
    );
  }

  Widget _timePicker() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Time Picker',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'Time: $_t2',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        DateTimePicker(
          type: DateTimePickerType.Time,
          timeInterval: const Duration(minutes: 30),
          onTimeChanged: (time) {
            setState(() {
              _t2 = DateFormat('hh:mm:ss aa').format(time);
            });
          },
        )
      ],
    );
  }

  Widget _colorPallet() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _color = Colors.amber;
            });
          },
          child: Container(
            width: 24,
            height: 24,
            color: Colors.amber,
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              _color = Colors.green;
            });
          },
          child: Container(
            width: 24,
            height: 24,
            color: Colors.green,
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              _color = Colors.blue;
            });
          },
          child: Container(
            width: 24,
            height: 24,
            color: Colors.blue,
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              _color = Colors.deepPurple;
            });
          },
          child: Container(
            width: 24,
            height: 24,
            color: Colors.deepPurple,
          ),
        ),
      ],
    );
  }
}
