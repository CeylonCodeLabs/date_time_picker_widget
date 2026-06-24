import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
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

  group('DateTimePickerViewModel - onClickPrevious', () {
    testWidgets('decrements selectedDateIndex by approximately 1 month', (WidgetTester tester) async {
      final startDate = DateTime(2024, 1, 1);
      final viewModel = DateTimePickerViewModel(
        null, // initialSelectedDate
        (_) {}, // onDateChanged
        (_) {}, // onTimeChanged
        startDate, // startDate
        null, // endDate
        null, // startTime
        null, // endTime
        const Duration(minutes: 30), // timeInterval
        false, // is24h
        DateTimePickerType.Date, // type (just Date so we don't need time slots scroll)
        '', // timeOutOfRangeError
        '', // datePickerTitle
        '', // timePickerTitle
        null, // customStringWeekdays
        1, // numberOfWeeksToDisplay
        null, // locale
      );

      // Build a PageView so that the controller is attached
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: PageView.builder(
            controller: viewModel.dateScrollController,
            itemCount: 100,
            itemBuilder: (context, index) => Container(),
          ),
        ),
      ));

      viewModel.init();
      await tester.pumpAndSettle(const Duration(seconds: 1)); // Wait for init delay

      // Set index to roughly 40 days (Feb 10)
      viewModel.selectedDateIndex = 40;
      await tester.pumpAndSettle();

      expect(viewModel.selectedDateIndex, 40);
      expect(viewModel.selectedDate, DateTime(2024, 2, 10));

      viewModel.onClickPrevious();
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Should go back 1 month from Feb 10, which is Jan 10
      // Jan 10 is 9 days after Jan 1 (index 9)
      expect(viewModel.selectedDateIndex, 9);
      expect(viewModel.selectedDate, DateTime(2024, 1, 10));
    });

    testWidgets('clamps selectedDateIndex to 0 when difference is less than 1 month', (WidgetTester tester) async {
      final startDate = DateTime(2024, 1, 1);
      final viewModel = DateTimePickerViewModel(
        null, // initialSelectedDate
        (_) {}, // onDateChanged
        (_) {}, // onTimeChanged
        startDate, // startDate
        null, // endDate
        null, // startTime
        null, // endTime
        const Duration(minutes: 30), // timeInterval
        false, // is24h
        DateTimePickerType.Date, // type
        '', // timeOutOfRangeError
        '', // datePickerTitle
        '', // timePickerTitle
        null, // customStringWeekdays
        1, // numberOfWeeksToDisplay
        null, // locale
      );

      // Build a PageView so that the controller is attached
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: PageView.builder(
            controller: viewModel.dateScrollController,
            itemCount: 100,
            itemBuilder: (context, index) => Container(),
          ),
        ),
      ));

      viewModel.init();
      await tester.pumpAndSettle(const Duration(seconds: 1)); // Wait for init delay

      // Set index to 15 days (Jan 16)
      viewModel.selectedDateIndex = 15;
      await tester.pumpAndSettle();

      expect(viewModel.selectedDateIndex, 15);

      viewModel.onClickPrevious();
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Should try to go back 1 month, but hit 0
      expect(viewModel.selectedDateIndex, 0);
      expect(viewModel.selectedDate, DateTime(2024, 1, 1));
    });
  });
}
