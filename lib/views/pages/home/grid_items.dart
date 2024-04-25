import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:pantori/domains/categories/core/category.dart';
import 'package:pantori/domains/goods/core/good.dart';

import 'package:pantori/views/pages/home/cards.dart';
import 'package:pantori/views/pages/home/expanded_card.dart';
import 'package:pantori/views/utils.dart';

class GoodListItem extends StatelessWidget {
  final Good good;
  final List<Category> categories;

  final void Function(String) onReplace;
  final void Function(Good) onEdit;
  final VoidCallback onDelete;

  const GoodListItem({
    super.key, 
    required this.good, 
    required this.onDelete, 
    required this.onReplace, 
    required this.onEdit,
    required this.categories
  });

  @override
  Widget build(BuildContext context) {
    List<Category> goodCategories = categories.where((element) => good.categories.contains(element.id)).toList();
    if (goodCategories.isEmpty) {
      goodCategories.add(Category(id: "", color: "FFC7C7C7", name: AppLocalizations.of(context)!.itemWithoutCategories));
    }

    Color backgroundColor = Color(int.parse(goodCategories[0].color, radix: 16));
    //-------------------------------------------------------------------------------------->
    // full card
    //-------------------------------------------------------------------------------------->
    return Card(
      color: backgroundColor,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return expandedCard(context, good, goodCategories, categories, onDelete, onEdit, onReplace);
            }
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            //-------------------------------------------------------------------------------------->
            // image
            //-------------------------------------------------------------------------------------->
            good.imagePath == "" ? cardDefaultImage() : cardNetworkImage(good.imagePath),
            //-------------------------------------------------------------------------------------->
            // card bottom
            //-------------------------------------------------------------------------------------->
            Padding(
              padding: const EdgeInsets.all(10.0),
              //-------------------------------------------------------------------------------------->
              // card info
              //-------------------------------------------------------------------------------------->
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    good.name,
                    style: TextStyle(
                      fontSize: 13, 
                      fontWeight: FontWeight.bold,
                      color: isDarkColor(backgroundColor) ? Colors.white : Colors.black
                    ),
                  ),
                  Text(
                    '${AppLocalizations.of(context)!.itemCardExpirationDate} ${good.expirationDate}',
                    style: TextStyle(
                      fontSize: 11, 
                      fontWeight: FontWeight.normal,
                      color: isDarkColor(backgroundColor) ? Colors.white : Colors.black
                    ),
                  ),
                ],
              )
            )
          ]
        )
      )
    );
  }
}