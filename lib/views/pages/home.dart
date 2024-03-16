import 'package:pantori/domain/ports.dart';
import 'package:pantori/domain/good.dart';
import 'package:pantori/l10n/categories.dart';
import 'package:pantori/views/widgets.dart';

import '../forms/add_food.dart';
import '../forms/filter.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  final ServicePort service;

  const HomePage({super.key, required this.service});

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
      appBar: AppBar(
        toolbarHeight: 70,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            localImage('images/raccoon.png', 75, 75),
            space(350, 0),
            regularText(AppLocalizations.of(context)!.appTitle)
          ],
        ),
      ),
      //-------------------------------------------------------------------------------------->
      // items grid
      //-------------------------------------------------------------------------------------->
      body: FutureBuilder<List<Good>>(
        future: widget.service.listGoods(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No items available.');
          } else {
            fullList = snapshot.data!;
            goodList =
                widget.service.filter(fullList, selectedCategory, selectedDate);
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                mainAxisExtent: 182,
              ),
              itemCount: goodList.length,
              itemBuilder: (context, index) {
                return GoodListItem(
                  good: goodList[index],
                  onDelete: () async {
                    await widget.service.deleteGood(goodList[index]);
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
                    service: widget.service,
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
                          service: widget.service,
                        )),
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
  final VoidCallback onDelete;
  const GoodListItem({super.key, required this.good, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    Category category =
        CategoryLocalizations.getCategoryByID(context, good.category)!;
    //-------------------------------------------------------------------------------------->
    // full card
    //-------------------------------------------------------------------------------------->
    return Card(
        color: category.color,
        child: InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return expandedCard(context, good, category.displayName);
                  });
            },
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //-------------------------------------------------------------------------------------->
              // image
              //-------------------------------------------------------------------------------------->

              good.imagePath == ""
                  ? cardDefaultImage()
                  : cardNetworkImage(good.imagePath),

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
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${AppLocalizations.of(context)!.itemCardExpirationDate} ${good.expirationDate}',
                        style: const TextStyle(
                            fontSize: 11, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ))
            ])));
  }
}

Widget cardDefaultImage({double height = 100}) {
  return Container(
    width: double.infinity,
    height: height,
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10)),
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
          topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      image: DecorationImage(
        image: NetworkImage(link),
        fit: BoxFit.fill,
      ),
    ),
  );
}

Widget expandedCard(BuildContext context, Good good, String category) {
  return Center(
      child: Dialog(
          child: SingleChildScrollView(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                      width: 350,
                      height: 350,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            good.imagePath == ""
                                ? cardDefaultImage(height: 170)
                                : cardNetworkImage(good.imagePath, height: 170),
                             Padding(
                              padding: const EdgeInsets.only(left: 15,top:10, bottom: 10),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      category,
                                      style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight:
                                      FontWeight.normal),
                                    ),
                                    Text(
                                      '${AppLocalizations.of(context)!.itemCardBuyDate} ${good.buyDate}',
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight:
                                              FontWeight.normal),
                                    ),
                                    Text(
                                      '${AppLocalizations.of(context)!.itemCardExpirationDate} ${good.expirationDate}',
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight:
                                              FontWeight.normal),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child:
                                          applyButtonWithIcon(() { }, "replace", Icons.copy)
                                    ),
                                    space(10, 0),
                                    SizedBox(
                                      width: 120,
                                      child: applyButtonWithIcon(() { }, "edit", Icons.edit)
                                    ),
                                    space(10, 0),
                                    SizedBox(
                                      width: 120,
                                      child:
                                        applyButtonWithIcon(() { }, "delete", Icons.delete)
                                        
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
