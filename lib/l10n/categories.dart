import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class Category {
  final String displayName;
  final Color color;

  Category({this.displayName = '', this.color = Colors.black});
}

class CategoryLocalizations {
  static Category? getCategoryByID(BuildContext context, String id) {
    Map<String, Category> catalog = {
      'categoryFrozen': Category(
        displayName: AppLocalizations.of(context)!.categoryFrozen,
        color: const Color(0xFFB3E0FF), // Light Baby Blue
      ),
      'categoryCandy': Category(
        displayName: AppLocalizations.of(context)!.categoryCandy,
        color: const Color(0xFFFFC0CB), // Light Baby Blue
      ),
      'categoryCookie': Category(
        displayName: AppLocalizations.of(context)!.categoryCookie,
        color: const Color(0xFFFFD700), // Light Baby Blue
      ),
      'categoryDrink': Category(
        displayName: AppLocalizations.of(context)!.categoryDrink,
        color: const Color(0xFF00CED1), // Light Baby Blue
      ),
      'categoryDairy': Category(
        displayName: AppLocalizations.of(context)!.categoryDairy,
        color: const Color(0xFFFFE4B5), // Light Baby Blue
      ),
      'categoryPasta': Category(
        displayName: AppLocalizations.of(context)!.categoryPasta,
        color: const Color(0xFF8A2BE2), // Light Baby Blue
      ),
      'categoryGrain': Category(
        displayName: AppLocalizations.of(context)!.categoryGrain,
        color: const Color(0xFFDEB887), // Light Baby Blue
      ),
      'categoryLeftover': Category(
        displayName: AppLocalizations.of(context)!.categoryLeftover,
        color: const Color(0xFF2E8B57), // Light Baby Blue
      ),
      'categoryOthers': Category(
        displayName: AppLocalizations.of(context)!.categoryOthers,
        color: const Color(0xFFC0C0C0), // Light Baby Blue
      ),
    };
    return catalog[id];
  }

  static List<String> listCategories() {
    return [
      'categoryFrozen',
      'categoryCandy',
      'categoryCookie',
      'categoryDrink',
      'categoryDairy',
      'categoryPasta',
      'categoryGrain',
      'categoryLeftover',
      'categoryOthers'
    ];
  }
}
