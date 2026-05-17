import 'package:flutter_test/flutter_test.dart';
import 'package:date_time_picker_widget/src/date_time_picker_view_model.dart';
import 'package:date_time_picker_widget/src/date_time_picker_type.dart';

void main() {
  group('DateTimePickerViewModel - getNextDate', () {
    final startDate = DateTime(2024, 1, 1);
    late DateTimePickerViewModel viewModel;

    setUp(() {
      viewModel = DateTimePickerViewModel(
        null, // initialSelectedDate
        (_) {}, // onDateChanged
        (_) {}, // onTimeChanged
        startDate, // startDate
        null, // endDate
        null, // startTime
        null, // endTime
        const Duration(minutes: 30), // timeInterval
        false, // is24h
        DateTimePickerType.Both, // type
        '', // timeOutOfRangeError
        '', // datePickerTitle
        '', // timePickerTitle
        null, // customStringWeekdays
        1, // numberOfWeeksToDisplay
        null, // locale
      );
    });

    test('getNextDate(0) should return startDate', () {
      expect(viewModel.getNextDate(0), startDate);
    });

    test('getNextDate(1) should return the next day', () {
      expect(viewModel.getNextDate(1), startDate.add(const Duration(days: 1)));
    });

    test('getNextDate(7) should return one week later', () {
      expect(viewModel.getNextDate(7), startDate.add(const Duration(days: 7)));
    });

    test('getNextDate(-1) should return the previous day', () {
      expect(
        viewModel.getNextDate(-1),
        startDate.subtract(const Duration(days: 1)),
      );
    });
  });
}
