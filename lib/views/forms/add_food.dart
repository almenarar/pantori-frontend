import 'package:pantori/l10n/categories.dart';
import 'package:pantori/domain/ports.dart';
import 'package:pantori/domain/good.dart';

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
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.newItemTitle),
      ),
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
  // ignore: no_logic_in_create_state
  State<FoodFormBody> createState() => _FoodFormBodyState(service: service);
}

class _FoodFormBodyState extends State<FoodFormBody> {
  final ServicePort service;

  _FoodFormBodyState({required this.service});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController buyDateController = TextEditingController();
  final TextEditingController expirationDateController =
      TextEditingController();

  List<String> categoryOptions = CategoryLocalizations.listCategories();
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    //-------------------------------------------------------------------------------------->
    // full form
    //-------------------------------------------------------------------------------------->
    return Padding(
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
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.newItemName,
                prefixIcon: const Icon(Icons.local_pizza),
                border: const OutlineInputBorder(),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
            ),
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
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.newItemCategory,
                  prefixIcon: const Icon(Icons.kitchen),
                  border: const OutlineInputBorder(),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
                    child: Text(CategoryLocalizations.getCategoryByID(
                            context, category)!
                        .displayName),
                  );
                }).toList(),
              )),
          //-------------------------------------------------------------------------------------->
          // buy date
          //-------------------------------------------------------------------------------------->
          Container(
              width: 250,
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: buyDateController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.newItemBuyDate,
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: const OutlineInputBorder(),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
                onTap: () {
                  _selectDate(context, buyDateController);
                },
              )),
          //-------------------------------------------------------------------------------------->
          // expiration date
          //-------------------------------------------------------------------------------------->
          Container(
              width: 250,
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: expirationDateController,
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)!.newItemExpirationDate,
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: const OutlineInputBorder(),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
                onTap: () {
                  _selectDate(context, expirationDateController);
                },
              )),
          //-------------------------------------------------------------------------------------->
          // space
          //-------------------------------------------------------------------------------------->
          const SizedBox(height: 16),
          //-------------------------------------------------------------------------------------->
          // button
          //-------------------------------------------------------------------------------------->
          ElevatedButton(
            onPressed: () async {
              final Good good = Good(
                  id: "",
                  name: nameController.text,
                  category: selectedCategory!,
                  buyDate: buyDateController.text,
                  expirationDate: expirationDateController.text,
                  imagePath: "");

              await service.createGood(good);
              widget.onFoodAdded();
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.newItemInclude),
          ),
        ],
      )),
    );
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
