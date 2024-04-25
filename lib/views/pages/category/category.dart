import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pantori/domains/categories/core/category.dart';

import 'package:pantori/domains/categories/core/service.dart';
import 'package:pantori/views/forms/categories/add_category.dart';
import 'package:pantori/views/forms/categories/edit_category.dart';
import 'package:pantori/views/widgets.dart';

class CategoriesPage extends StatefulWidget {
  final CategoryService categories;

  const CategoriesPage({
    super.key, 
    required this.categories
  });

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<Category> categoryList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //------------------------------------------------------->
      // header
      //------------------------------------------------------->
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 70,
        title: regularText(AppLocalizations.of(context)!.navigatorCategories, size: 25)
      ),
      //------------------------------------------------------->
      // body
      //------------------------------------------------------->
      body: FutureBuilder<List<Category>>(
        future: widget.categories.list(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text(AppLocalizations.of(context)!.emptyList);
          } else {
            categoryList = snapshot.data!;

            return ListView.separated(
              itemCount: categoryList.length,
              itemBuilder: (context, index) {
                //------------------------------------------------------->
                // items
                //------------------------------------------------------->
                return ListTile(
                  title: regularText(categoryList[index].name),
                  tileColor:Colors.white,
                  dense: true,
                  visualDensity:const VisualDensity(vertical: 2),
                  //------------------------------------------------------->
                  // color container
                  //------------------------------------------------------->
                  leading: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(color: Color(int.parse(categoryList[index].color, radix: 16))),
                  ),
                  //------------------------------------------------------->
                  // buttons
                  //------------------------------------------------------->
                  trailing: SizedBox(
                    height: 350,
                    width: 100,
                    child: Row(
                      children: [
                        //------------------------------------------------------->
                        // edit
                        //------------------------------------------------------->
                        IconButton(
                          onPressed: ()async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditCategoryForm(
                                  categoryService: widget.categories,
                                  currentCategory: categoryList[index],
                                )
                              ),
                            );
                            setState(() {});
                          }, 
                          icon: const Icon(Icons.edit)
                        ),
                        //------------------------------------------------------->
                        // delete
                        //------------------------------------------------------->
                        IconButton(
                          onPressed: (){
                            widget.categories.delete(categoryList[index]);
                            setState(() {});
                          }, 
                          icon: const Icon(Icons.delete)
                        )
                      ]
                    ,)
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider()
            );
          }
        },
      ),
      //------------------------------------------------------->
      // add buttom
      //------------------------------------------------------->
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: ()async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCategoryForm(
                category: widget.categories,
              )
            ),
          );
          setState(() {});
        }
      )
    );
  }
}