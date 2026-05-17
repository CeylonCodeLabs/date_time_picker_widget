import 'package:date_time_picker_widget/src/date_time_picker_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class DateWeekView extends ViewModelWidget<DateTimePickerViewModel> {
  final BoxConstraints constraints;

  const DateWeekView(this.constraints);

  @override
  Widget build(BuildContext context, DateTimePickerViewModel viewModel) {
    var w = ((constraints.biggest.width - 20) - (32 * 7)) / 7;
    w = (w + w / 7).roundToDouble() + 0.3;
    return Container(
      height: 53.0 * viewModel.numberOfWeeksToDisplay,
      child: PageView.builder(
        controller: viewModel.dateScrollController,
        itemCount: ((viewModel.dateSlots?.length ?? 0) /
                viewModel.numberOfWeeksToDisplay)
            .round(),
        itemBuilder: (context, index) {
          return ListView.builder(
              //physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, wIndex) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 53,
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return SizedBox(width: w);
                    },
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        viewModel.dateSlots![wIndex + index]!.days!.length,
                    itemBuilder: (context, i) {
                      final e = viewModel.dateSlots![wIndex + index]!.days![i];

                      return Center(
                        child: InkWell(
                          onTap: !e.enabled
                              ? null
                              : () => viewModel.selectedDateIndex = e.index,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(90),
                              border: Border.all(
                                color: e.index == viewModel.selectedDateIndex
                                    ? Theme.of(context).colorScheme.secondary
                                    : Colors.grey,
                              ),
                              color: e.enabled
                                  ? e.index == viewModel.selectedDateIndex
                                      ? Theme.of(context).colorScheme.secondary
                                      : Colors.white
                                  : Colors.grey.shade300,
                            ),
                            alignment: Alignment.center,
                            width: 32,
                            height: 32,
                            child: Text(
                              '${e.date!.day}',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: e.index == viewModel.selectedDateIndex
                                      ? Colors.white
                                      : Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              itemCount: viewModel.numberOfWeeksToDisplay);
        },
      ),
    );
  }
}
