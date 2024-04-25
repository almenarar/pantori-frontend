import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:pantori/domains/categories/core/category.dart';
import 'package:pantori/domains/goods/core/good.dart';
import 'package:pantori/domains/goods/core/service.dart';
import 'package:pantori/views/widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class AddFoodForm extends StatelessWidget {
  final GoodService goods;
  final List<Category> categories;

  const AddFoodForm({
    super.key, 
    required this.goods,
    required this.categories
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.newItemTitle),
        backgroundColor: Colors.white,
      ),
      resizeToAvoidBottomInset: true,
      body: AddFoodFormBody(
        goods: goods,
        categories: categories,
      ),
    );
  }
}

class AddFoodFormBody extends StatefulWidget {
  final GoodService goods;
  final List<Category> categories;

  const AddFoodFormBody({
    super.key, 
    required this.goods,
    required this.categories
  });

  @override
  State<AddFoodFormBody> createState() => _AddFoodFormBodyState();
}

class _AddFoodFormBodyState extends State<AddFoodFormBody> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController buyDateController = TextEditingController();
  final TextEditingController expirationDateController = TextEditingController();

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
                  options: categoriesToValueItem(widget.categories),
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
                () async {
                  await addFood();
                  // ignore: use_build_context_synchronously
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

  List<ValueItem> categoriesToValueItem(List<Category> itens){
    List<ValueItem> out = [];
    for (final item in itens){
      out.add(ValueItem(label: item.name, value: item));
    }
    return out;
  }

  Future<void> addFood() async {
    List<String> categories = [];
    for (final item in _categoriesController.selectedOptions) {
      Category category = item.value;
      categories.add(category.id);
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

    await widget.goods.createGood(good);
    return;
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
    return;
  }
}
