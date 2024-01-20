import 'package:pantori/domain/ports.dart';
import 'package:pantori/l10n/categories.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class FilterDialog extends StatefulWidget {
  final ServicePort service;

  String? selectedCategory;
  String? dateFilter;

  final ValueChanged<String> onDateFilterChanged;
  final ValueChanged<String> onCategoryChanged;

  FilterDialog(
      {super.key,
      required this.service,
      required this.selectedCategory,
      required this.dateFilter,
      required this.onDateFilterChanged,
      required this.onCategoryChanged});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String? _getIntervalByID(BuildContext context, String id) {
    Map<String, String> catalog = {
      '3 days': AppLocalizations.of(context)!.interval3Days,
      '1 week': AppLocalizations.of(context)!.interval1Week,
      '2 weeks': AppLocalizations.of(context)!.interval2Weeks,
      '1 month': AppLocalizations.of(context)!.interval1Month,
      '3 months': AppLocalizations.of(context)!.interval3Months,
    };

    return catalog[id];
  }

  @override
  Widget build(BuildContext context) {
    List<String> foodCategories =
        ['All'] + CategoryLocalizations.listCategories();
    List<String> dateFilterOptions =
        ['All'] + widget.service.listFilterIntervals();
    //-------------------------------------------------------------------------------------->
    // full filter
    //-------------------------------------------------------------------------------------->
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(AppLocalizations.of(context)!.filterTitle),
      content: Center(
          heightFactor: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              //-------------------------------------------------------------------------------------->
              // category filter
              //-------------------------------------------------------------------------------------->
              Text(AppLocalizations.of(context)!.filterByCategory),
              DropdownButton<String>(
                value: widget.selectedCategory,
                menuMaxHeight: 250,
                onChanged: (String? newValue) {
                  setState(() {
                    widget.selectedCategory = newValue;
                    widget.onCategoryChanged(
                        newValue ?? AppLocalizations.of(context)!.categoryAll);
                  });
                },
                items: foodCategories
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value == 'All'
                            ? AppLocalizations.of(context)!.categoryAll
                            : CategoryLocalizations.getCategoryByID(
                                    context, value)!
                                .displayName),
                      ),
                    )
                    .toList(),
              ),
              //-------------------------------------------------------------------------------------->
              // space
              //-------------------------------------------------------------------------------------->
              const SizedBox(height: 16),
              //-------------------------------------------------------------------------------------->
              // date filter
              //-------------------------------------------------------------------------------------->
              Text(AppLocalizations.of(context)!.filterByDate),
              DropdownButton<String>(
                value: widget.dateFilter,
                menuMaxHeight: 250,
                onChanged: (String? newValue) {
                  setState(() {
                    widget.dateFilter = newValue;
                    widget.onDateFilterChanged(
                        newValue ?? AppLocalizations.of(context)!.categoryAll);
                  });
                },
                items: dateFilterOptions
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value == 'All'
                            ? AppLocalizations.of(context)!.categoryAll
                            : _getIntervalByID(context, value)!),
                      ),
                    )
                    .toList(),
              ),
            ],
          )),
      //-------------------------------------------------------------------------------------->
      // filter button
      //-------------------------------------------------------------------------------------->
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context)!.filterButton),
        ),
      ],
    );
  }
}
