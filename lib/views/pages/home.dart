import 'package:pantori/domains/goods/core/good.dart';
import 'package:pantori/domains/goods/core/service.dart';
import 'package:pantori/l10n/categories.dart';
import 'package:pantori/views/forms/edit_food.dart';
import 'package:pantori/views/widgets.dart';

import '../forms/add_food.dart';
import '../forms/filter.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  final GoodService goods;

  const HomePage({super.key, required this.goods});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
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
            localImage('images/raccoon.png', 75, 75),
            space(350, 0),
            regularText(AppLocalizations.of(context)!.appTitle, size: 18)
          ],
        ),
      ),
      //-------------------------------------------------------------------------------------->
      // items grid
      //-------------------------------------------------------------------------------------->
      body: FutureBuilder<List<Good>>(
        future: widget.goods.listGoods(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No items available.');
          } else {
            fullList = snapshot.data!;
            goodList = widget.goods.filter(fullList, selectedCategory, selectedDate);
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
      // bottom buttons
      //-------------------------------------------------------------------------------------->
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //-------------------------------------------------------------------------------------->
          // filter button
          //-------------------------------------------------------------------------------------->
          FloatingActionButton(
            heroTag: 'bt2',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return FilterDialog(
                    service: widget.goods,
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
            child: const Icon(Icons.filter_list),
          ),
          //-------------------------------------------------------------------------------------->
          space(0, 16),
          //-------------------------------------------------------------------------------------->
          // add button
          //-------------------------------------------------------------------------------------->
          FloatingActionButton(
            heroTag: 'bt1',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoodForm(
                    onFoodAdded: _updateState,
                    service: widget.goods,
                  )
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  void _updateState() {
    setState(() {});
  }
}

class GoodListItem extends StatelessWidget {
  final Good good;
  final void Function(String) onReplace;
  final void Function(Good) onEdit;
  final VoidCallback onDelete;
  const GoodListItem({super.key, required this.good, required this.onDelete, required this.onReplace, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    List<Category> categories = [];
    for (final category in good.categories) {
      categories.add(CategoryLocalizations.getCategoryByID(context, category)!);
    }
    //Category category = CategoryLocalizations.getCategoryByID(context, good.categories[0])!;
    //-------------------------------------------------------------------------------------->
    // full card
    //-------------------------------------------------------------------------------------->
    return Card(
      color: categories[0].color,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return expandedCard(context, good, categories, onDelete, onEdit, onReplace);
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
                    style: const TextStyle(
                      fontSize: 13, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    '${AppLocalizations.of(context)!.itemCardExpirationDate} ${good.expirationDate}',
                    style: const TextStyle(
                      fontSize: 11, 
                      fontWeight: FontWeight.normal
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

Widget cardDefaultImage({double height = 100}) {
  return Container(
    width: double.infinity,
    height: height,
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10), topRight: Radius.circular(10)
      ),
      image: DecorationImage(
        image: AssetImage('images/default_card.png'),
        fit: BoxFit.fill,
      ),
    ),
  );
}

Widget cardNetworkImage(String link, {double height = 100}) {
  return Container(
    width: double.infinity,
    height: height,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10), topRight: Radius.circular(10)
      ),
      image: DecorationImage(
        image: NetworkImage(link),
        fit: BoxFit.fill,
      ),
    ),
  );
}

Widget expandedCard(BuildContext context, 
                    Good good, 
                    List<Category> categories, 
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
    out.add(
      Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: category.color
        ),
        child: Text(
          category.displayName,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.normal
          ),
        )
      ),
    );
  }
  return out;
}