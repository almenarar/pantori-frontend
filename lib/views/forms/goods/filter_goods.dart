import 'package:pantori/domains/categories/core/category.dart';
import 'package:pantori/domains/goods/core/service.dart';
import 'package:pantori/views/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class FilterDialog extends StatefulWidget {
  final GoodService goods;
  final List<Category> categories;

  String? selectedCategory;
  String? dateFilter;

  final ValueChanged<String> onDateFilterChanged;
  final ValueChanged<String> onCategoryChanged;

  FilterDialog(
      {super.key,
      required this.goods,
      required this.categories,
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

  String translateAllTo(BuildContext context, String value) {
    return value == 'All'
        ? AppLocalizations.of(context)!.categoryAll
        : value;
  }

  List<String> categoriesToDropdownItems(List<Category> itens){
    List<String> out = ["All"];
    for (final item in itens){
      out.add(item.name);
    }
    return out;
  }

  String buildDateText(BuildContext context, String value) {
    return value == 'All'
        ? AppLocalizations.of(context)!.categoryAll
        : _getIntervalByID(context, value)!;
  }

  @override
  Widget build(BuildContext context) {
    List<String> foodCategories = categoriesToDropdownItems(widget.categories);
    List<String> dateFilterOptions = ['All'] + widget.goods.listFilterIntervals();

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
                  widget.selectedCategory, translateAllTo),
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
