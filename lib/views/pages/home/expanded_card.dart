import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:pantori/domains/categories/core/category.dart';
import 'package:pantori/domains/goods/core/good.dart';

import 'package:pantori/views/forms/goods/edit_good.dart';
import 'package:pantori/views/pages/home/cards.dart';
import 'package:pantori/views/utils.dart';
import 'package:pantori/views/widgets.dart';

Widget expandedCard(BuildContext context, 
                    Good good, 
                    List<Category> categories,
                    List<Category> allCategories,  
                    void Function() delete, 
                    void Function(Good) edit, 
                    void Function(String) replace) {
  return Center(
    child: Dialog(
      child: SingleChildScrollView(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: 350,
            height: 380,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //-------------------------------------------------------------------------------------->
                // image
                //-------------------------------------------------------------------------------------->
                good.imagePath == "" ? cardDefaultImage(height: 170) : cardNetworkImage(good.imagePath, height: 170),
                //-------------------------------------------------------------------------------------->
                // title
                //-------------------------------------------------------------------------------------->
                Padding(
                  padding: const EdgeInsets.only(left: 15,top:10, bottom: 2),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          good.name,
                          softWrap: true,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        )
                      ),
                    ]
                  )
                ),
                //-------------------------------------------------------------------------------------->
                // body
                //-------------------------------------------------------------------------------------->
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //-------------------------------------------------------------------------------------->
                    // infos
                    //-------------------------------------------------------------------------------------->
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: 
                        //-------------------------------------------------------------------------------------->
                        // categories
                        //-------------------------------------------------------------------------------------->
                        getCategoriesList(categories) + [ 
                        //-------------------------------------------------------------------------------------->
                        // buydate
                        //-------------------------------------------------------------------------------------->
                        Text(
                          '${AppLocalizations.of(context)!.itemCardBuyDate} ${good.buyDate}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight:FontWeight.normal
                          ),
                        ),
                        //-------------------------------------------------------------------------------------->
                        // exp date
                        //-------------------------------------------------------------------------------------->
                        Text(
                          '${AppLocalizations.of(context)!.itemCardExpirationDate} ${good.expirationDate}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.normal
                          ),
                        ),
                      ],
                    ),
                    //-------------------------------------------------------------------------------------->
                    // buttons
                    //-------------------------------------------------------------------------------------->
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //-------------------------------------------------------------------------------------->
                        // replace button
                        //-------------------------------------------------------------------------------------->
                        SizedBox(
                          width: 80,
                          child: applyButtonWithIcon(
                            () async {
                              String newDate = "";
                              DateTime selectedDate = DateTime.now();
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                helpText: AppLocalizations.of(context)!.goodReplaceForm,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2045),
                              );
                              if (picked != null) {
                                newDate = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                                replace(newDate);
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                              }
                            },
                            AppLocalizations.of(context)!.homeItemOptionReplace,
                            Icons.copy
                          )
                        ),
                        //-------------------------------------------------------------------------------------->
                        // edit button
                        //-------------------------------------------------------------------------------------->
                        SizedBox(
                          width: 80,
                          child: applyButtonWithIcon(
                            () async {
                             final editedGood = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FoodEditForm(
                                    good: good,
                                    categories: allCategories,
                                  )
                                ),
                              );
                              if (editedGood is Good) {
                                edit(editedGood);
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                              }
                            }, 
                            AppLocalizations.of(context)!.homeItemOptionEdit, 
                            Icons.edit
                          )
                        ),
                        //-------------------------------------------------------------------------------------->
                        // delete button
                        //-------------------------------------------------------------------------------------->
                        SizedBox(
                          width: 80,
                          child: applyButtonWithIcon(
                            (){
                              delete();
                              Navigator.pop(context);
                            }, 
                            AppLocalizations.of(context)!.homeItemOptionDelete, 
                            Icons.delete
                          )
                        )
                      ],
                    ),
                  ],
                ),
              ]
            )
          )
        )
      )
    )
  );
}

List<Widget> getCategoriesList(List<Category> categories){
  List<Widget> out = [];

  for (final category in categories) {
    Color backgroundColor = Color(int.parse(category.color, radix: 16));
    out.add(
      Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: backgroundColor
        ),
        child: Text(
          category.name,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.normal,
            color: isDarkColor(backgroundColor) ? Colors.white : Colors.black
          ),
        )
      ),
    );
  }
  return out;
}