import 'package:pantori/l10n/categories.dart';
import 'package:pantori/domain/good.dart';
import 'package:pantori/views/widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class FoodEditForm extends StatelessWidget {
  final Good good;
  const FoodEditForm({super.key, required this.good});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editItemTitle),
      ),
      resizeToAvoidBottomInset: true,
      body: FoodFormBody(good: good,),
    );
  }
}

class FoodFormBody extends StatefulWidget {
  final Good good;
  const FoodFormBody({super.key, required this.good});

  @override
  // ignore: no_logic_in_create_state
  State<FoodFormBody> createState() => _FoodFormBodyState(good: good);
}

class _FoodFormBodyState extends State<FoodFormBody> {
  final Good good;
  final TextEditingController nameController;
  //final TextEditingController categoryController;
  final TextEditingController buyDateController;
  final TextEditingController expirationDateController;
  String? selectedCategory;

  _FoodFormBodyState({required this.good}) : 
    nameController = TextEditingController(text: good.name),
    //categoryController = TextEditingController(text: good.category),
    buyDateController = TextEditingController(text: good.buyDate),
    expirationDateController = TextEditingController(text: good.expirationDate);
    //selectedCategory = good.category;
  
  List<String> categoryOptions = CategoryLocalizations.listCategories();

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
                child: DropdownButtonFormField<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  menuMaxHeight: 250,
                  // DropdownButton don`t have this field, can`t use my widgets lib
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.newItemCategory,
                    prefixIcon: const Icon(Icons.kitchen),
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15, 
                      horizontal: 10
                    ),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    size: 24,
                    color: Colors.black,
                  ),
                  items: categoryOptions.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(
                        CategoryLocalizations.getCategoryByID(
                          context, 
                          category
                        )!.displayName
                      ),
                    );
                  }).toList(),
                )
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
                {final Good editedGood = Good(
                    id: good.id,
                    name: nameController.text,
                    categories: const [],
                    buyDate: buyDateController.text,
                    expirationDate: expirationDateController.text,
                    imagePath: good.imagePath ,
                    createdAt: good.createdAt
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
