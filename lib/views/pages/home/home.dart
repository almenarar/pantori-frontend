import 'package:pantori/domains/categories/core/category.dart';
import 'package:pantori/domains/goods/core/good.dart';
import 'package:pantori/domains/goods/core/service.dart';
import 'package:pantori/domains/categories/core/service.dart';

import 'package:pantori/views/widgets.dart';
import 'package:pantori/views/pages/category/category.dart';
import 'package:pantori/views/pages/home/grid_items.dart';
import 'package:pantori/views/forms/goods/add_good.dart';
import 'package:pantori/views/forms/goods/filter_goods.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  final GoodService goods;
  final CategoryService categories;

  const HomePage({
    super.key, 
    required this.goods,
    required this.categories
  });

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  List<Category> categoryList = [];
  List<Good> goodList = []; //filtered, what is shown on screen
  List<Good> fullList = []; //all that really are

  String selectedCategory = 'All';
  String selectedDate = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 70,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            localImage('images/raccoon.png', 90, 90),
            space(350, 0),
            regularText(AppLocalizations.of(context)!.appTitle, size: 20)
          ],
        ),
      ),
      //-------------------------------------------------------------------------------------->
      // items grid
      //-------------------------------------------------------------------------------------->
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([widget.goods.listGoods(),widget.categories.list()]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No items available.');
          } else {

            categoryList = snapshot.data![1].cast<Category>();
            fullList = snapshot.data![0].cast<Good>();

            Category selectedCategoryObj = categoryList.firstWhere((element) => element.name == selectedCategory, orElse: () => const Category(id: "All", color: "", name: ""),);
            goodList = widget.goods.filter(fullList, selectedCategoryObj.id, selectedDate);

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                mainAxisExtent: 192,
              ),
              itemCount: goodList.length,
              itemBuilder: (context, index) {
                return GoodListItem(
                  categories: categoryList,
                  good: goodList[index],
                  onReplace: (String newDate) async {
                    await widget.goods.replaceGood(goodList[index],newDate);
                    setState(() {});
                  },
                  onEdit:(Good good) async {
                    await widget.goods.editGood(good);
                    setState(() {});
                  },
                  onDelete: () async {
                    await widget.goods.deleteGood(goodList[index]);
                    setState(() {});
                  },
                );
              },
            );
          }
        },
      ),
      //-------------------------------------------------------------------------------------->
      // main buttom - add item
      //-------------------------------------------------------------------------------------->
      floatingActionButton: SizedBox(
          width: 80,
          height: 80,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF807C7D),
            ),
            child: IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddFoodForm(
                      goods: widget.goods,
                      categories: categoryList,
                    )
                  ),
                );
                setState(() {});
              }, 
              color: Colors.white,
              icon: const Icon(Icons.add)
            )
          )
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //-------------------------------------------------------------------------------------->
      // bottom buttoms
      //-------------------------------------------------------------------------------------->
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFC7C7C7),
        height: 65,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //-------------------------------------------------------------------------------------->
            // filter
            //-------------------------------------------------------------------------------------->
            SizedBox(
              width: 50,
              height: 50,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color:  Color(0xFF807C7D), // Light purple background color
                ),
                child: IconButton(
                  onPressed:  (){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return FilterDialog(
                          goods: widget.goods,
                          categories: categoryList,
                          selectedCategory: selectedCategory,
                          dateFilter: selectedDate,
                          onCategoryChanged: (String category) {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                          onDateFilterChanged: (String interval) {
                            setState(() {
                              selectedDate = interval;
                            });
                          },
                        );
                      },
                    );
                  }, 
                  color: Colors.white,
                  icon: const Icon(Icons.filter_list)
                )
              )
            ),
            //-------------------------------------------------------------------------------------->
            // navigation
            //-------------------------------------------------------------------------------------->
            SizedBox(
              width: 50,
              height: 50,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF807C7D),
                ),
                child: IconButton(
                  onPressed: (){
                    final screenWidth = MediaQuery.of(context).size.width;
                    final screenHeight = MediaQuery.of(context).size.height;
                    final menuPosition = RelativeRect.fromLTRB(
                      screenWidth - 100,
                      screenHeight - (screenHeight/4.2),
                      0,
                      0,
                    );
                    showMenu(
                      context: context, 
                      position: menuPosition,
                      items: <PopupMenuEntry>[
                        PopupMenuItem(
                          value: 'Categories',
                          child: Text(AppLocalizations.of(context)!.navigatorCategories),
                        ),
                        PopupMenuItem(
                          value: 'ShopList',
                          child: Text(AppLocalizations.of(context)!.navigatorShopList),
                        ),
                        PopupMenuItem(
                          value: 'Configurations',
                          child: Text(AppLocalizations.of(context)!.navigatorConfigurations),
                        ),
                      ]
                    ).then((value) async {
                      if (value != null) {
                        switch (value) {
                          case 'Categories':
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoriesPage(
                                  categories: widget.categories,
                                )
                              ),
                            );
                            setState(() {});
                            break;
                          case 'ShopList':
                            break;
                          case 'Configurations':
                            break;
                        }
                      }
                    });
                  }, 
                  color: Colors.white,
                  icon: const Icon(Icons.near_me_rounded)
                )
              )
            ),
          ],
        ),
      ),
    );
  }
}



