import 'package:pantori/domain/ports.dart';
import 'package:pantori/domain/good.dart';
import 'package:pantori/l10n/categories.dart';
import 'package:pantori/views/widgets.dart';

import '../forms/add_food.dart';
import '../forms/filter.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:intl/intl.dart';
import 'dart:math';

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
                mainAxisExtent: 320,
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
          space(16, 0),
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
  final minWidth = 200.0;

  const GoodListItem({super.key, required this.good, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    Category category =
        CategoryLocalizations.getCategoryByID(context, good.category)!;
    //-------------------------------------------------------------------------------------->
    // full card
    //-------------------------------------------------------------------------------------->
    return Card(
        color: category.color,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              // autosizing magic ---------------------------------------------------------------->
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: max(screenWidth * 0.3, minWidth),
                      ),
                      //-------------------------------------------------------------------------------------->
                      // card info
                      //-------------------------------------------------------------------------------------->
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                good.name,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                category.displayName,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                '${AppLocalizations.of(context)!.itemCardBuyDate} ${convertDateFormat(good.buyDate)}',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                '${AppLocalizations.of(context)!.itemCardExpirationDate} ${convertDateFormat(good.expirationDate)}',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          )),
                          //-------------------------------------------------------------------------------------->
                          // card buttons
                          //-------------------------------------------------------------------------------------->
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: onDelete,
                            iconSize: 20.0,
                          ),
                        ],
                      ))))
        ]));
  }
}

String convertDateFormat(String originalDate) {
  DateTime dateTime = DateTime.parse(originalDate);
  String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
  return formattedDate;
}

Widget cardDefaultImage() {
  return Container(
    width: double.infinity,
    height: 200.0,
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

Widget cardNetworkImage(String link) {
  return Container(
    width: double.infinity,
    height: 200.0,
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
