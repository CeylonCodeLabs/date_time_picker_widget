import 'package:date_time_picker_widget/src/date_time_picker_type.dart';
import 'package:date_time_picker_widget/src/date_time_picker_view.dart';
import 'package:date_time_picker_widget/src/date_time_picker_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DateTimePicker constructor checks properties correctly',
      (tester) async {
    await tester.pumpWidget(Container());
    final BuildContext context = tester.element(find.byType(Container));
    final DateTimePickerViewModel viewModel = DateTimePickerViewModel(
      null, null, null, null, null, null, null, const Duration(minutes: 1),
      false, DateTimePickerType.Both, '', '', '', null, 1, null,
    );

    expect(
        () => const DateTimePicker(type: DateTimePickerType.Both)
            .builder(context, viewModel, null),
        throwsArgumentError);
    expect(
        () => const DateTimePicker(type: DateTimePickerType.Date)
            .builder(context, viewModel, null),
        throwsArgumentError);
    expect(
        () => const DateTimePicker(type: DateTimePickerType.Time)
            .builder(context, viewModel, null),
        throwsArgumentError);
  });
}
