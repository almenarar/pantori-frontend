import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:pantori/domains/categories/core/category.dart';
import 'package:pantori/domains/goods/core/good.dart';
import 'package:pantori/views/widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class FoodEditForm extends StatelessWidget {
  final Good good;
  final List<Category> categories;

  const FoodEditForm({super.key, required this.good, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editItemTitle),
        backgroundColor: Colors.white,
      ),
      resizeToAvoidBottomInset: true,
      body: FoodFormBody(good: good,categories: categories,),
    );
  }
}

class FoodFormBody extends StatefulWidget {
  final Good good;
  final List<Category> categories;

  const FoodFormBody({super.key, required this.good,required this.categories});

  @override
  State<FoodFormBody> createState() => _FoodFormBodyState();
}

class _FoodFormBodyState extends State<FoodFormBody> {
  final MultiSelectController _categoriesController = MultiSelectController();
  TextEditingController nameController = TextEditingController();
  TextEditingController buyDateController = TextEditingController();
  TextEditingController expirationDateController = TextEditingController();

  @override
  void initState(){
    super.initState();
    nameController = TextEditingController(text: widget.good.name);
    buyDateController = TextEditingController(text: widget.good.buyDate);
    expirationDateController = TextEditingController(text: widget.good.expirationDate);
    setState(() {});
  }
  
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
                  const Icon(Icons.calendar_today), 
                  onTap: () {
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
                  const Icon(Icons.calendar_today), 
                  onTap: () {
                    _selectDate(context, expirationDateController);
                  }
                )
              ),
              //-------------------------------------------------------------------------------------->
              space(16, 0),
              //-------------------------------------------------------------------------------------->
              // button
              //-------------------------------------------------------------------------------------->
              applyButton(()
                {
                  List<String> categories = [];
                  for (final item in _categoriesController.selectedOptions) {
                    Category category = item.value;
                    categories.add(category.id);
                  }
                  
                  final Good editedGood = Good(
                    id: widget.good.id,
                    name: nameController.text,
                    categories: categories,
                    buyDate: buyDateController.text,
                    expirationDate: expirationDateController.text,
                    imagePath: widget.good.imagePath ,
                    createdAt: widget.good.createdAt
                  );
                Navigator.pop(context, editedGood);
                }, 
                AppLocalizations.of(context)!.editItemApplyButton
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

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
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
