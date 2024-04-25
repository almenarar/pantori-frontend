import 'package:flutter/material.dart';
import 'package:pantori/domains/categories/core/category.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pantori/domains/categories/core/service.dart';
import 'package:pantori/views/widgets.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class EditCategoryForm extends StatelessWidget {
  final CategoryService categoryService;
  final Category currentCategory;

  const EditCategoryForm({
    super.key, 
    required this.categoryService,
    required this.currentCategory
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editCategoryTitle),
        backgroundColor: Colors.white,
      ),
      resizeToAvoidBottomInset: true,
      body: EditCategoryFormBody(
        categoryService: categoryService,
        defaultCategory: currentCategory,
      ),
    );
  }
}

class EditCategoryFormBody extends StatefulWidget {
  final CategoryService categoryService;
  final Category defaultCategory;

  const EditCategoryFormBody({
    super.key, 
    required this.categoryService, 
    required this.defaultCategory
  });

  @override
  State<EditCategoryFormBody> createState() => _EditCategoryFormBody();
}

class _EditCategoryFormBody extends State<EditCategoryFormBody> {
  TextEditingController nameController = TextEditingController();
  Color colorController = Colors.black;

  @override
  void initState(){
    super.initState();
    nameController = TextEditingController(text: widget.defaultCategory.name);
    colorController = Color(int.parse(widget.defaultCategory.color, radix: 16));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 150.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //-------------------------------------->
              // name
              //-------------------------------------->
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
              space(16, 0),
              //-------------------------------------------------------------------------------------->
              GestureDetector(
                  onTap: () {
                    _showColorPickerDialog(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      regularText(AppLocalizations.of(context)!.categoryChooseAColor),
                      space(0, 16),
                      Container(
                        width: 120.0,
                        height: 70.0,
                        color: colorController,
                      ),
                    ],
                  )
                ),
              //-------------------------------------------------------------------------------------->
              space(30, 0),
              //-------------------------------------------------------------------------------------->
              // button
              //-------------------------------------------------------------------------------------->
              applyButton(
                (){
                  editCategory();
                  Navigator.pop(context);
                }, 
                AppLocalizations.of(context)!.editItemApplyButton
              )
            ]
          )
        )
      )
    );
  }

  Future<void> editCategory() async {
    final Category category = Category(
      id: widget.defaultCategory.id,
      name: nameController.text,
      color: colorController.value.toRadixString(16).padLeft(8, '0').toUpperCase(),
    );

    await widget.categoryService.edit(category);
  }

  void _showColorPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.categoryChooseAColor),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: colorController,
              onColorChanged: (Color color) {
                setState(() {
                  colorController = color;
                });
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.okText),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}