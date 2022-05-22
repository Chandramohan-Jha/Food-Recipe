import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:foody/model.dart';
import 'package:foody/recipeview.dart';
import 'package:http/http.dart';

class Search extends StatefulWidget {
  late String query;
  Search(this.query);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool isLoading = true;
  TextEditingController search_controller = TextEditingController();
  List<Model> recipList = <Model>[];
  List recipCatList = [
    {
      'imgurl':
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8Zm9vZHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
      'heading': 'Pizza'
    },
    {
      'imgurl':
          'https://media.istockphoto.com/photos/piece-of-sachertorte-sachr-cake-on-white-plate-top-view-copy-space-picture-id1296474411?b=1&k=20&m=1296474411&s=170667a&w=0&h=KwzSC3hrY3ZE07GJ3P08E5WZO72eHqqe7XKxUmX8Pk4=',
      'heading': 'Cake'
    },
    {
      'imgurl':
          'https://media.istockphoto.com/photos/hot-chineese-food-with-chopped-parslye-on-top-picture-id1390908290?b=1&k=20&m=1390908290&s=170667a&w=0&h=_Z2ZHC3FXva_C1Bh90l2CpsXtBpMjRV3P4PJXqZBat0=',
      'heading': 'Chineese'
    },
    {
      'imgurl':
          'https://images.unsplash.com/photo-1576506295286-5cda18df43e7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8aWNlJTIwY3JlYW18ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60',
      'heading': 'Ice-cream'
    },
    {
      'imgurl':
          'https://media.istockphoto.com/photos/close-up-of-freshly-baked-cakes-and-cupcakes-in-a-row-at-food-market-picture-id916575452?b=1&k=20&m=916575452&s=170667a&w=0&h=2uDakwN9tV2NcUQWsTezDBEI_nKNNqO0Jj-Ydulryns=',
      'heading': 'Dessert'
    }
  ];

  void getRecipe(String query) async {
    String url =
        "https://api.edamam.com/search?q=$query&app_id=5286a9ef&app_key=dafc2b09eabef7ee810a6e71f51c1bb1";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    data["hits"].forEach((element) {
      Model recipemodel = Model();
      recipemodel = Model.fromMap(element["recipe"]);
      recipList.add(recipemodel);
    });

    setState(() {
      isLoading = false;
    });
    recipList.forEach((recipe) {
      print(recipe.applabel);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecipe(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff213A50), Color(0xff071938)]),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SafeArea(
                  //*=======================Search bar=====================================*/
                  child: Container(
                    // Search wala container
                    // color: Colors.grey,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if ((search_controller.text).replaceAll(" ", "") ==
                                "") {
                            } else {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          Search(search_controller.text))));
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(7, 0, 8, 0),
                            child: const Icon(
                              Icons.search,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            onSubmitted: (value) {
                              if ((value).replaceAll(" ", "") == "") {
                              } else {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            Search(search_controller.text))));
                              }
                            },
                            controller: search_controller,
                            enableSuggestions: true,
                            autocorrect: true,
                            decoration: const InputDecoration(
                                hintText: "Search", border: InputBorder.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: isLoading
                      ? const SpinKitFadingCircle(
                          color: Colors.white,
                          size: 60.0,
                        )
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: recipList.length,
                          itemBuilder: ((context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RecipeView(
                                            recipList[index].appurl)));
                              },
                              child: Card(
                                margin: const EdgeInsets.all(8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 0.0,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        recipList[index].appimgurl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 200,
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        decoration: const BoxDecoration(
                                            color: Colors.black26),
                                        child: Text(
                                          recipList[index].applabel,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      width: 90,
                                      height: 30,
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(0, 4, 4, 0),
                                        decoration: const BoxDecoration(
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
                                              const Icon(
                                                Icons.local_fire_department,
                                                size: 15,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                recipList[index]
                                                    .appcalories
                                                    .toStringAsFixed(2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          })),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
