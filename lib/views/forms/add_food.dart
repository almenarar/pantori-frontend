import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:pantori/l10n/categories.dart';
import 'package:pantori/domains/goods/core/ports.dart';
import 'package:pantori/domains/goods/core/good.dart';
import 'package:pantori/views/widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class FoodForm extends StatelessWidget {
  // update the state on home page
  final Function() onFoodAdded;
  final ServicePort service;

  const FoodForm({super.key, required this.onFoodAdded, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.newItemTitle),
        backgroundColor: Colors.white,
      ),
      resizeToAvoidBottomInset: true,
      body: FoodFormBody(
        onFoodAdded: onFoodAdded,
        service: service,
      ),
    );
  }
}

class FoodFormBody extends StatefulWidget {
  final Function() onFoodAdded;
  final ServicePort service;

  const FoodFormBody(
      {super.key, required this.onFoodAdded, required this.service});

  @override
  State<FoodFormBody> createState() => _FoodFormBodyState();
}

class _FoodFormBodyState extends State<FoodFormBody> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController buyDateController = TextEditingController();
  final TextEditingController expirationDateController =
      TextEditingController();

  List<String> categoryOptions = CategoryLocalizations.listCategories();
  final MultiSelectController _categoriesController = MultiSelectController();

  @override
  Widget build(BuildContext context) {
    //-------------------------------------------------------------------------------------->
    // full form
    //-------------------------------------------------------------------------------------->
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 150.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //-------------------------------------------------------------------------------------->
              // name
              //-------------------------------------------------------------------------------------->
              Container(
                width: 250,
                padding: const EdgeInsets.all(8.0),
                child: textField(
                  nameController,
                  AppLocalizations.of(context)!.newItemName,
                  const Icon(Icons.local_pizza),
                  maxLenth: 34
                )
              ),
              //-------------------------------------------------------------------------------------->
              // category
              //-------------------------------------------------------------------------------------->
              Container(
                width: 250,
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.centerRight,
                child:  MultiSelectDropDown<dynamic>(
                  controller: _categoriesController,
                  borderColor: Colors.black,
                  optionsBackgroundColor: const Color.fromARGB(184, 186, 132, 241),
                  maxItems: 3,
                  onOptionSelected: (List<ValueItem> selectedOptions) {},
                  options: strToValueItem(categoryOptions),
                  selectionType: SelectionType.multi,
                  chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                  dropdownHeight: 300,
                  optionTextStyle: const TextStyle(fontSize: 16),
                  selectedOptionIcon: const Icon(Icons.check_circle),
                ),
             ),
              //-------------------------------------------------------------------------------------->
              // buy date
              //-------------------------------------------------------------------------------------->
              Container(
                width: 250,
                padding: const EdgeInsets.all(8.0),
                child: textField(
                  buyDateController,
                  AppLocalizations.of(context)!.newItemBuyDate,
                    const Icon(Icons.calendar_today), onTap: () {
                    _selectDate(context, buyDateController);
                  }
                )
              ),
              //-------------------------------------------------------------------------------------->
              // expiration date
              //-------------------------------------------------------------------------------------->
              Container(
                width: 250,
                padding: const EdgeInsets.all(8.0),
                child: textField(
                    expirationDateController,
                    AppLocalizations.of(context)!.newItemExpirationDate,
                    const Icon(Icons.calendar_today), onTap: () {
                    _selectDate(context, expirationDateController);
                  }
                )
              ),
              //-------------------------------------------------------------------------------------->
              space(16, 0),
              //-------------------------------------------------------------------------------------->
              // button
              //-------------------------------------------------------------------------------------->
              applyButton(
                (){
                  addFood();
                  Navigator.pop(context);
                }, 
                AppLocalizations.of(context)!.newItemInclude
              )
            ],
          )
        ),
      )
    );
  }

  List<ValueItem> strToValueItem(List<String> itens){
    List<ValueItem> out = [];
    for (final item in itens){
      out.add(ValueItem(label: item, value: item));
    }
    return out;
  }

  Future<void> addFood() async {
    List<String> categories = [];
    for (final item in _categoriesController.selectedOptions) {
      categories.add(item.value);
    }

    final Good good = Good(
      id: "",
      name: nameController.text,
      categories: categories,
      buyDate: buyDateController.text,
      expirationDate: expirationDateController.text,
      imagePath: "",
      createdAt: "",
    );

    await widget.service.createGood(good);
    widget.onFoodAdded();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2045),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        controller.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }
}
