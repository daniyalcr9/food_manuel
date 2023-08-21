import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food_manuel/model.dart';
import 'package:food_manuel/search.dart';
import 'package:http/http.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;
  List<RecipeModel> recipelist = <RecipeModel>[];
  TextEditingController searchController = new TextEditingController();
  List reciptCatList = [
    {
      "imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db",
      "heading": "Chilli Food"
    },
    {
      "imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db",
      "heading": "Chilli Food"
    },
    {
      "imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db",
      "heading": "Chilli Food"
    },
    {
      "imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db",
      "heading": "Chilli Food"
    }
  ];
  getRecipe(String query) async {
    String url =
        "https://api.edamam.com/search?q=$query&app_id=3ab9403d&app_key=58dc629dad42407d5edc84495a42c56b&from=0&to=3";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    // log(data.toString());
    //print(response.body);

    data["hits"].forEach((element) {
      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element["recipe"]);
      recipelist.add(recipeModel);
      setState(() {
        isLoading = false;
      });
      log(recipelist.toString());
    });
    recipelist.forEach((Recipe) {
      print(Recipe.applabel);
      print(Recipe.appcal);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecipe("Biryani");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff213A50), Color(0xff071938)],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SafeArea(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          //search container

                          padding: EdgeInsets.symmetric(horizontal: 8),
                          margin: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25)),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (searchController.text.isEmpty) {
                                    print("Blank search");
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Search(searchController.text)));
                                  }
                                },
                                child: Container(
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.blueAccent,
                                  ),
                                  margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: searchController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Let's try some new recipes!",
                                  ),
                                  onSubmitted: (value) {
                                    getRecipe(value);
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "WHAT DO YOU WANNA COOK TODAY!",
                        style: TextStyle(fontSize: 33, color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Let's try something new!!",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: recipelist.length,
                          itemBuilder: ((context, index) {
                            return InkWell(
                              onTap: () {},
                              child: Card(
                                margin: EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 0.0,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.network(
                                        recipelist[index].appimgurl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 200,
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.black26),
                                        child: Text(
                                          recipelist[index].applabel,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        right: 0,
                                        height: 40,
                                        width: 80,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10))),
                                          child: Center(
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.local_fire_department,
                                                    size: 15,
                                                  ),
                                                  Text(recipelist[index]
                                                      .appcal
                                                      .toString()
                                                      .substring(0, 6)),
                                                ]),
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                ),
                Container(
                    height: 100,
                    child: ListView.builder(
                        itemCount: reciptCatList.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                              child: InkWell(
                                  onTap: () {},
                                  child: Card(
                                      margin: EdgeInsets.all(20),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      elevation: 0.0,
                                      child: Stack(children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            child: Image.network(
                                              reciptCatList[index]["imgUrl"],
                                              fit: BoxFit.cover,
                                              width: 200,
                                              height: 250,
                                            )),
                                        Positioned(
                                            left: 0,
                                            right: 0,
                                            bottom: 0,
                                            top: 0,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 10),
                                              decoration: BoxDecoration(
                                                  color: Colors.black26),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    reciptCatList[index]
                                                        ["heading"],
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 28),
                                                  ),
                                                ],
                                              ),
                                            ))
                                      ]))));
                        }))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
