import 'package:date_time_picker_widget/src/date.dart';
import 'package:date_time_picker_widget/src/date_time_picker_type.dart';
import 'package:date_time_picker_widget/src/week.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stacked/stacked.dart';

class DateTimePickerViewModel extends BaseViewModel {
  final DateTime? initialSelectedDate;
  final Function(DateTime date)? onDateChanged;
  final Function(DateTime time)? onTimeChanged;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? startTime;
  final DateTime? endTime;
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime? _startTime;
  DateTime? _endTime;
  Duration timeInterval;
  final List<String>? customStringWeekdays;
  final int numberOfWeeksToDisplay;
  final bool is24h;
  final DateTimePickerType type;
  final String timeOutOfRangeError;
  final String datePickerTitle;
  final String timePickerTitle;
  final String? locale;

  final List<Map<String, dynamic>> _weekdays = [
    {'value': DateTime.sunday, 'text': 'S'},
    {'value': DateTime.monday, 'text': 'M'},
    {'value': DateTime.tuesday, 'text': 'T'},
    {'value': DateTime.wednesday, 'text': 'W'},
    {'value': DateTime.thursday, 'text': 'T'},
    {'value': DateTime.friday, 'text': 'F'},
    {'value': DateTime.saturday, 'text': 'S'},
  ];

  List<Map<String, dynamic>> weekdays = [];

  DateTimePickerViewModel(
      this.initialSelectedDate,
      this.onDateChanged,
      this.onTimeChanged,
      this.startDate,
      this.endDate,
      this.startTime,
      this.endTime,
      this.timeInterval,
      // ignore: avoid_positional_boolean_parameters
      this.is24h,
      this.type,
      this.timeOutOfRangeError,
      this.datePickerTitle,
      this.timePickerTitle,
      this.customStringWeekdays,
      this.numberOfWeeksToDisplay,
      this.locale,
      ) {
    _startDate = startDate;
    _startTime = startTime;
    _endDate = endDate;
    _endTime = endTime;

    if(customStringWeekdays != null && customStringWeekdays!.length == 7){
      weekdays = [
        {'value': DateTime.sunday, 'text': customStringWeekdays![0]},
        {'value': DateTime.monday, 'text': customStringWeekdays![1]},
        {'value': DateTime.tuesday, 'text': customStringWeekdays![2]},
        {'value': DateTime.wednesday, 'text': customStringWeekdays![3]},
        {'value': DateTime.thursday, 'text': customStringWeekdays![4]},
        {'value': DateTime.friday, 'text': customStringWeekdays![5]},
        {'value': DateTime.saturday, 'text': customStringWeekdays![6]},
      ];
    }else{
      weekdays = _weekdays;
    }
  }

  int? _selectedWeekday = 0;

  int? get selectedWeekday => _selectedWeekday;

  set selectedWeekday(int? selectedWeekday) {
    _selectedWeekday = selectedWeekday;
    notifyListeners();
  }

  int _numberOfWeeks = 0;

  int get numberOfWeeks => _numberOfWeeks;

  set numberOfWeeks(int numberOfWeeks) {
    _numberOfWeeks = numberOfWeeks;
    notifyListeners();
  }

  int _numberOfDays = 0;

  int get numberOfDays => _numberOfDays;

  set numberOfDays(int numberOfDays) {
    _numberOfDays = numberOfDays;
    notifyListeners();
  }

  DateTime? _selectedDate;

  DateTime? get selectedDate => _selectedDate;

  set selectedDate(DateTime? selectedDate) {
    _selectedDate = selectedDate;
    notifyListeners();
  }

  int _selectedDateIndex = 0;

  int get selectedDateIndex => _selectedDateIndex;

  set selectedDateIndex(int selectedDateIndex) {
    _selectedDateIndex = selectedDateIndex;
    notifyListeners();
    selectedDate = _findDate(selectedDateIndex);
    if (selectedDate != null) {
      selectedWeekday = selectedDate?.weekday;
      onDateChanged!(selectedDate!);
      _fetchTimeSlots(selectedDate);
    }
  }

  List<Week?>? _dateSlots = [];

  List<Week?>? get dateSlots => _dateSlots;

  set dateSlots(List<Week?>? dateSlots) {
    _dateSlots = dateSlots;
    notifyListeners();
  }

  int _selectedTimeIndex = 0;

  int get selectedTimeIndex => _selectedTimeIndex;

  set selectedTimeIndex(int selectedTimeIndex) {
    _selectedTimeIndex = selectedTimeIndex;
    notifyListeners();
    onTimeChanged!(timeSlots![selectedTimeIndex]);
  }

  List<DateTime>? _timeSlots = [];

  List<DateTime>? get timeSlots => _timeSlots;

  set timeSlots(List<DateTime>? timeSlots) {
    _timeSlots = timeSlots;
    notifyListeners();
  }

  final PageController _dateScrollController = PageController();

  PageController get dateScrollController => _dateScrollController;

  final ItemScrollController _timeScrollController = ItemScrollController();

  ItemScrollController get timeScrollController => _timeScrollController;

  final ItemPositionsListener _timePositionsListener =
      ItemPositionsListener.create();

  ItemPositionsListener get timePositionsListener => _timePositionsListener;

  void init() async {
    final currentDateTime = initialSelectedDate ?? DateTime.now();
    final _currentDateTime = DateTime(
        currentDateTime.year, currentDateTime.month, currentDateTime.day);

    //DATE
    _startDate ??= _currentDateTime;
    _startDate = DateTime(_startDate!.year, _startDate!.month, _startDate!.day);

    _endDate ??= _startDate!.add(const Duration(days: 365 * 5));
    _endDate = DateTime(_endDate!.year, _endDate!.month, _endDate!.day);

    numberOfDays = _endDate!.difference(_startDate!).inDays;
    numberOfWeeks = Jiffy.parseFromDateTime(_endDate!)
        .diff(Jiffy.parseFromDateTime(_startDate!), unit: Unit.week)
        .toInt();


    int dateIndex = 0;
    Week? week;

    for (int i = 0; i < numberOfDays; i++) {
      final date = getNextDate(i);
      final w = Jiffy.parseFromDateTime(date).weekOfYear;

      if (i == 0) {
        week = Week(number: w, days: _fillWeek(date, toStart: true));

        dateSlots!.add(week);
      } else if (week!.number != w && week.days!.length == 7) {
        week = Week(number: w, days: []);

        dateSlots!.add(week);
      }

      week.days!.add(Date(index: i, date: date));

      if (date.difference(_currentDateTime).inDays == 0) {
        dateIndex = i;
      }

      if (i + 1 == numberOfDays) {
        week.days!.addAll(_fillWeek(date, toEnd: true));
      }
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      if (type == DateTimePickerType.Both || type == DateTimePickerType.Date) {
        if (dateSlots!.isNotEmpty) {
          selectedDateIndex = dateIndex;
          dateScrollController.animateToPage(
            _findWeekIndex(selectedDateIndex),
            duration: const Duration(seconds: 1),
            curve: Curves.linearToEaseOut,
          );
        } else {
          dateSlots = null;
        }
      }
    });

    if (type == DateTimePickerType.Time) {
      _fetchTimeSlots(currentDateTime);
    }
  }

  List<Date> _fillWeek(DateTime date,
      {bool toStart = false, bool toEnd = false}) {
    final List<Date> dates = [];

    if (toStart) {
      int i = 1;
      while (Jiffy.parseFromDateTime(date.subtract(Duration(days: i)))
              .weekOfYear ==
          Jiffy.parseFromDateTime(date).weekOfYear) {
        dates.insert(
            0,
            Date(
                index: -1,
                date: date.subtract(Duration(days: i)),
                enabled: false));
        i++;
      }
    }

    if (toEnd) {
      int i = 1;
      while (Jiffy.parseFromDateTime(date.add(Duration(days: i))).weekOfYear ==
          Jiffy.parseFromDateTime(date).weekOfYear) {
        dates.add(
            Date(index: -1, date: date.add(Duration(days: i)), enabled: false));
        i++;
      }
    }

    return dates;
  }

  int _findWeekIndex(int dateIndex) {
    if (dateSlots != null && dateSlots!.isNotEmpty) {
      return dateSlots!.indexWhere((w) =>
          w!.days!.where((d) => d.index == dateIndex).toList().isNotEmpty);
    } else {
      return 0;
    }
  }

  DateTime? _findDate(int dateIndex) {
    if (dateSlots != null && dateSlots!.isNotEmpty) {
      final w = dateSlots!
          .where((e) =>
              e!.days!.where((d) => d.index == dateIndex).toList().length == 1)
          .toList();

      if (w.length == 1) {
        return w[0]!.days!.firstWhere((e) => e.index == dateIndex).date;
      }
    }

    return null;
  }

  void _fetchTimeSlots(DateTime? currentDateTime) {
    var _currentDateTime = currentDateTime;
    //TIME
    if (startTime == null) {
      _startTime = DateTime(
        _currentDateTime!.year,
        _currentDateTime.month,
        _currentDateTime.day,
      );
    }
    if (endTime == null) {
      _endTime = DateTime(
        _currentDateTime!.year,
        _currentDateTime.month,
        _currentDateTime.day,
        24,
      );
    }

    if (startTime != null || endTime != null) {
      // current time is not today
      if (_currentDateTime!.day - DateTime.now().day > 0) {
        if (startTime != null) {
          _currentDateTime = _startTime = DateTime(
            _currentDateTime.year,
            _currentDateTime.month,
            _currentDateTime.day,
            startTime!.hour,
            startTime!.minute,
          );
        }
        if (endTime != null) {
          _endTime = DateTime(
            _currentDateTime.year,
            _currentDateTime.month,
            _currentDateTime.day,
            endTime!.hour,
            endTime!.minute,
          );
        }
      } else if (_currentDateTime
          .isBefore(DateTime.now().add(const Duration(seconds: 5)))) {
        // current time is today
        _currentDateTime = _startTime = DateTime(
          _currentDateTime.year,
          _currentDateTime.month,
          _currentDateTime.day,
          DateTime.now().hour,
          DateTime.now().minute,
        );

        if (startTime != null && _currentDateTime.hour < startTime!.hour) {
          _currentDateTime = _startTime = DateTime(
            _currentDateTime.year,
            _currentDateTime.month,
            _currentDateTime.day,
            startTime!.hour,
            startTime!.minute,
          );
        }

        if (endTime != null) {
          _endTime = DateTime(
            _currentDateTime.year,
            _currentDateTime.month,
            _currentDateTime.day,
            endTime!.hour,
            endTime!.minute,
          );
        } else {
          _endTime = DateTime(
            _currentDateTime.year,
            _currentDateTime.month,
            _currentDateTime.day,
            24,
            0,
          );
        }
      }
    }

    int timeIndex = -1;
    timeSlots = [];
    for (int i = 0; i < _getTimeSlotsCount(); i++) {
      final time = _getNextTime(i);
      timeSlots!.add(time);
      if (timeIndex == -1 &&
          (time.difference(_currentDateTime!).inMinutes <=
                  timeInterval.inMinutes ||
              time.difference(_currentDateTime).inMinutes <= 0)) {
        timeIndex = i;
      }
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      if (type == DateTimePickerType.Both || type == DateTimePickerType.Time) {
        if (timeSlots!.isNotEmpty) {
          selectedTimeIndex = timeIndex == -1 ? 0 : timeIndex;
          timeScrollController.scrollTo(
              index: selectedTimeIndex, duration: const Duration(seconds: 1));
        } else {
          timeSlots = null;
        }
      }
    });
  }

  int _getTimeSlotsCount() {
    return (_endTime!.difference(_startTime!).inMinutes ~/
            timeInterval.inMinutes)
        .toInt();
  }

  DateTime _getNextTime(int index) {
    final dt = _startTime!.add(
        Duration(minutes: (60 - _startTime!.minute) % timeInterval.inMinutes));
    return dt.add(Duration(minutes: timeInterval.inMinutes * index));
  }

  DateTime getNextDate(int index) {
    return _startDate!.add(Duration(days: index));
  }

  void onClickNext() {
    final dt = Jiffy.parseFromDateTime(selectedDate!).add(months: 1);
    final diff = dt
        .diff(
          Jiffy.parseFromDateTime(selectedDate!),
          unit: Unit.day,
        )
        .toInt();

    if (numberOfDays < selectedDateIndex + diff) {
      selectedDateIndex = numberOfDays - 1;
    } else {
      selectedDateIndex += diff;
    }

    dateScrollController.animateToPage(_findWeekIndex(selectedDateIndex),
        duration: const Duration(seconds: 1), curve: Curves.linearToEaseOut);
  }

  void onClickPrevious() {
    final dt = Jiffy.parseFromDateTime(selectedDate!).subtract(months: 1);
    final diff =
        Jiffy.parseFromDateTime(selectedDate!).diff(dt, unit: Unit.day).toInt();

    if (selectedDateIndex < diff) {
      selectedDateIndex = 0;
    } else {
      selectedDateIndex -= diff;
    }

    dateScrollController.animateToPage(_findWeekIndex(selectedDateIndex),
        duration: const Duration(seconds: 1), curve: Curves.linearToEaseOut);
  }
}
