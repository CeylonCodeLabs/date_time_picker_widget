import 'package:date_time_picker_widget/src/date_time_picker_type.dart';
import 'package:date_time_picker_widget/src/date_time_picker_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

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

  group('DateTimePickerViewModel - onClickNext', () {
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

    test('should increase selectedDateIndex by 1 month of days', () {
      viewModel
        ..init()
        ..selectedDate = DateTime(2024, 1, 1) // January has 31 days
        ..numberOfDays = 100
        ..selectedDateIndex = 0;

      try {
        viewModel.onClickNext();
      // ignore: avoid_catching_errors
      } on AssertionError catch (e) {
        // Ignored: PageController is not attached to a PageView
        expect(e, isA<AssertionError>());
      }

      // Next month from Jan 1 is Feb 1. Diff is 31 days.
      expect(viewModel.selectedDateIndex, 31);
    });

    test('should cap selectedDateIndex to numberOfDays - 1', () {
      viewModel
        ..init()
        ..selectedDate = DateTime(2024, 1, 1)
        ..numberOfDays = 10
        ..selectedDateIndex = 0;

      try {
        viewModel.onClickNext();
      // ignore: avoid_catching_errors
      } on AssertionError catch (e) {
        // Ignored: PageController is not attached to a PageView
        expect(e, isA<AssertionError>());
      }

      // 31 days > 10, so it should cap to numberOfDays - 1 = 9
      expect(viewModel.selectedDateIndex, 9);
    });
  });
}
