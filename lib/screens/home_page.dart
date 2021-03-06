import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodlab/api/food_api.dart';
import 'package:foodlab/notifier/auth_notifier.dart';
import 'package:foodlab/notifier/food_notifier.dart';
import 'package:foodlab/screens/detail_food_page.dart';
import 'package:foodlab/screens/navigation_bar.dart';
import 'package:foodlab/screens/profile_page.dart';
import 'package:provider/provider.dart';
import 'package:gradient_text/gradient_text.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  signOutUser() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    if (authNotifier.user != null) {
      signOut(authNotifier, context);
    }
  }

  @override
  void initState() {
    FoodNotifier foodNotifier =
        Provider.of<FoodNotifier>(context, listen: false);
    getFoods(foodNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    FoodNotifier foodNotifier =
        Provider.of<FoodNotifier>(context, listen: true);
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 30, left: 10, right: 10),
            child: authNotifier.user != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return NavigationBarPage(selectedIndex: 0);
                              },
                            ),
                          );
                        },
                        child: GradientText(
                          "FoodGram",
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(120, 200, 255, 1),
                              Color.fromRGBO(100, 170, 240, 1),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'MuseoModerno',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          signOutUser();
                        },
                        child: Icon(
                          Icons.exit_to_app,
                        ),
                      ),
                    ],
                  )
                : Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
          ),
          SizedBox(
            height: 20,
          ),
          foodNotifier.foodList.length != 0
              ? Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: foodNotifier.foodList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                foodNotifier.foodList[index]
                                            .profilePictureOfUser !=
                                        null
                                    ? CircleAvatar(
                                        radius: 24.0,
                                        backgroundImage: NetworkImage(
                                            foodNotifier.foodList[index]
                                                .profilePictureOfUser),
                                        backgroundColor: Colors.transparent,
                                      )
                                    : CircleAvatar(
                                        radius: 24.0,
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.grey,
                                        ),
                                        backgroundColor: Colors.transparent,
                                      ),
                                Container(
                                  padding: EdgeInsets.only(bottom: 5, left: 10),
                                  child: Row(
                                    children: <Widget>[
                                      RaisedButton(
                                        onPressed: () {
                                          String _uid = foodNotifier
                                              .foodList[index].userUuidOfPost;
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfilePage(uid: _uid)));
                                        },
                                        color: Colors.white,
                                        child: Text(
                                          foodNotifier.foodList[index].userName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: foodNotifier.foodList[index].img != null
                                    ? GestureDetector(
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Image.network(
                                            foodNotifier.foodList[index].img,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) {
                                                return FoodDetailPage(
                                                    imgUrl: foodNotifier
                                                        .foodList[index].img,
                                                    imageName: foodNotifier
                                                        .foodList[index].name,
                                                    imageCaption: foodNotifier
                                                        .foodList[index]
                                                        .caption,
                                                    userName: foodNotifier
                                                        .foodList[index]
                                                        .userName,
                                                    createdTimeOfPost:
                                                        foodNotifier
                                                            .foodList[index]
                                                            .createdAt
                                                            .toDate(),
                                                    comments: foodNotifier
                                                        .foodList[index]
                                                        .comments,
                                                    documentID: foodNotifier
                                                        .foodList[index]
                                                        .documentID);
                                              },
                                            ),
                                          );
                                        },
                                      )
                                    : CircularProgressIndicator(
                                        backgroundColor:
                                            Color.fromRGBO(255, 63, 111, 1),
                                      ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 5, left: 10),
                              child: Row(
                                children: <Widget>[
                                  IconButton(
                                      icon: Icon(Icons.favorite,
                                          color: foodNotifier.likeColor[index]),
                                      tooltip: 'Like',
                                      onPressed: () {
                                        likePressHandler(
                                            foodNotifier.isLiked[index],
                                            context,
                                            foodNotifier.likeRef[index],
                                            foodNotifier
                                                .foodList[index].documentID,
                                            foodNotifier.nOfLikesList[index],
                                            foodNotifier.likeRef,
                                            index);
                                        setState(() {
                                          if (foodNotifier.isLiked[index]) {
                                            foodNotifier.isLiked[index] = false;
                                            foodNotifier.likeColor[index] =
                                                Colors.grey;
                                            foodNotifier.nOfLikesList[index] -=
                                                1;
                                          } else {
                                            foodNotifier.isLiked[index] = true;
                                            foodNotifier.likeColor[index] =
                                                Colors.red[300];
                                            foodNotifier.nOfLikesList[index] +=
                                                1;
                                          }
                                        });
                                        print('Like na Postagem');
                                      }),
                                  Text(
                                    foodNotifier.nOfLikesList[index].toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(255, 138, 120, 1),
                                    ),
                                  ),
                                  (authNotifier?.user?.uid ==
                                          foodNotifier
                                              .foodList[index].userUuidOfPost)
                                      ? IconButton(
                                          icon: Icon(Icons.edit,
                                              color: Colors.blue[300]),
                                          tooltip: 'Editar',
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FoodDetailPage(
                                                    imgUrl: foodNotifier
                                                        .foodList[index].img,
                                                    imageName: foodNotifier
                                                        .foodList[index].name,
                                                    imageCaption: foodNotifier
                                                        .foodList[index]
                                                        .caption,
                                                    userName: foodNotifier
                                                        .foodList[index]
                                                        .userName,
                                                    createdTimeOfPost:
                                                        foodNotifier
                                                            .foodList[index]
                                                            .createdAt
                                                            .toDate(),
                                                    comments: foodNotifier
                                                        .foodList[index]
                                                        .comments,
                                                    documentID: foodNotifier
                                                        .foodList[index]
                                                        .documentID,
                                                    userUuidOfPost: foodNotifier
                                                        .foodList[index]
                                                        .userUuidOfPost,
                                                    ehEdit: true,
                                                    index: index,
                                                  ),
                                                ));
                                          })
                                      : SizedBox(
                                          height: 0,
                                        ),
                                  (authNotifier?.user?.uid ==
                                          foodNotifier
                                              .foodList[index].userUuidOfPost)
                                      ? IconButton(
                                          icon: Icon(Icons.remove_circle,
                                              color: Colors.red[400]),
                                          tooltip: 'Deletar',
                                          onPressed: () {
                                            print('Deletar Postagem');
                                            deleteFood(context,
                                                aux: foodNotifier
                                                    .foodList[index]
                                                    .documentID);
                                          })
                                      : SizedBox(
                                          height: 0,
                                        ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : Column(
                  children: <Widget>[
                    CircularProgressIndicator(
                      backgroundColor: Color.fromRGBO(255, 63, 111, 1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromRGBO(255, 138, 120, 1),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Loading'),
                  ],
                ),
        ],
      ),
    );
  }
}
