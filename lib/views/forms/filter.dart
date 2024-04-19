import 'package:pantori/domains/goods/core/ports.dart';
import 'package:pantori/l10n/categories.dart';
import 'package:pantori/views/widgets.dart';

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

  void categoryOnChange(String? value) {
    setState(() {
      widget.selectedCategory = value;
      widget.onCategoryChanged(
          value ?? AppLocalizations.of(context)!.categoryAll);
    });
  }

  void dateOnChange(String? value) {
    setState(() {
      widget.dateFilter = value;
      widget.onDateFilterChanged(
          value ?? AppLocalizations.of(context)!.categoryAll);
    });
  }

  String buildCategoryText(BuildContext context, String value) {
    return value == 'All'
        ? AppLocalizations.of(context)!.categoryAll
        : CategoryLocalizations.getCategoryByID(context, value)!.displayName;
  }

  String buildDateText(BuildContext context, String value) {
    return value == 'All'
        ? AppLocalizations.of(context)!.categoryAll
        : _getIntervalByID(context, value)!;
  }

  @override
  Widget build(BuildContext context) {
    List<String> foodCategories =
        ['All'] + CategoryLocalizations.listCategories();
    List<String> dateFilterOptions =
        ['All'] + widget.service.listFilterIntervals();

    return AlertDialog(
      backgroundColor: Colors.white,
      title: regularText(AppLocalizations.of(context)!.filterTitle),
      //---------------------------------------------------------->
      content: Center(
          heightFactor: 1,
          //---------------------------------------------------------->
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              //---------------------------------------------------------->
              // category filter
              //---------------------------------------------------------->
              regularText(AppLocalizations.of(context)!.filterByCategory),
              dropdown(context, categoryOnChange, foodCategories,
                  widget.selectedCategory, buildCategoryText),
              //---------------------------------------------------------->
              space(16, 0),
              //---------------------------------------------------------->
              // date filter
              //---------------------------------------------------------->
              regularText(AppLocalizations.of(context)!.filterByDate),
              dropdown(context, dateOnChange, dateFilterOptions,
                  widget.dateFilter, buildDateText)
              //---------------------------------------------------------->
            ],
          )),
      actions: [
        //---------------------------------------------------------->
        returnButton(context, AppLocalizations.of(context)!.filterButton)
        //---------------------------------------------------------->
      ],
    );
  }
}
