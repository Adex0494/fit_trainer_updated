import 'package:fit_trainer_updated/models/diet.dart';
//import 'package:fit_trainer_updated/models/diet_auxiliar.dart';
import 'package:fit_trainer_updated/models/food_group.dart';
import 'package:fit_trainer_updated/models/food_portion.dart';
import 'package:fit_trainer_updated/models/subscriber.dart';
import 'package:fit_trainer_updated/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'add_subscriber_diet_page.dart';
import 'evaluation_page.dart';
import '../widgets/faceIcon.dart';

class DietPage extends StatefulWidget {
  final String subscriberName;
  final int subscriberId;
  DietPage(this.subscriberName, this.subscriberId);
  @override
  State<StatefulWidget> createState() {
    return DietPageState(this.subscriberName, this.subscriberId);
  }
}

class DietPageState extends State<DietPage> {
  String subscriberName;
  int subscriberId;
  DietPageState(this.subscriberName, this.subscriberId);
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Diet> dietList;
  //List<DietAuxiliar> auxiliarDietList;
  List<FoodPortion> auxiliarFoodPortionList;
  int listCount = 0;
  String day = 'Domingo';
  int hcGoalCal = 0;
  int ptGoalCal = 0;
  int lipGoalCal = 0;
  int hcGoal = 0;
  int ptGoal = 0;
  int lipGoal = 0;
  int hcAcc = 0;
  int ptAcc = 0;
  int lipAcc = 0;
  int hcAccCal = 0;
  int ptAccCal = 0;
  int lipAccCal = 0;
  int ptP = 0;
  int hcP = 0;
  int lipP = 0;
  int caloriesSelected =0;
  double totalCaloricValue = 0;
  List<int> caloriesPerFoodPortion = List<int>();
  int caloriesAcc = 0;
  OverlayState overlayState;
  OverlayEntry overlayEntry;
  bool overlayEntryIsOn = false;
  bool foodPortionOverlayEntryIsOn = false;
  Subscriber subscriber;
  List<FoodGroup> foodGroupList = List<FoodGroup>();
  List<FoodPortion> foodPortionList = List<FoodPortion>();
  List<List<FoodPortion>> foodPortionListList =
      List<List<FoodPortion>>(); //List of foodPortions by foodGroup
  List<int> foodPortionIndexList =
      List<int>(); //List of next selectable indexes of foodPortion
  List<int> foodGroupQuantity = List<
      int>(); //List of quantity of times a foodGroup has been the best option.
  List<int> foodPortionQuantity =
      List<int>(); //List of quantity of times a foodPortion has been selected.
  List<int> auxiliarFoodPortionQuantity = List<int>();
  List<int> maxFoodPortionQuantity = List<
      int>(); //List of maximum foodportions from a foodGroup that can be in a daily diet.
  List<int> obligatoryFoodPortionQuantity = List<
      int>(); //List that contains the obligatory quantity of portions of a food group
  List<int> maxMultiplierInFoodGroup = List<
      int>(); //List of the highest multiplier of a food portion that a food group can have.
  List<Widget> foodCards = List<Widget>();
  List<FoodPortionModel> foodPortionModels =
      List<FoodPortionModel>(); // Food portions that have not been assigned
  String dragTargetText = 'Nothing';
  bool breakfastHover = false;
  bool mealHover = false;
  bool dinnerHover = false;
  int breakfastQ = 0;
  int mealQ = 0;
  int dinnerQ = 0;
  List<FoodPortionModel> breakfastList = List<FoodPortionModel>();
  List<FoodPortionModel> mealList = List<FoodPortionModel>();
  List<FoodPortionModel> dinnerList = List<FoodPortionModel>();
  List<FoodPortionModel> auxiliarShowableFoodPortionList = List<
      FoodPortionModel>(); //Food portions to show (breakfast, meal, dinner, foodPortionModels)
  int foodPortionsOnView =
      0; //0=foodPortionModels,1=breakfastList,2=mealList,3=dinnerList
  List<FoodPortion> substitutingFoodPortionList;

  @override
  initState() {
    super.initState();
    getSubscriber();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text('Dieta del Suscriptor'),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  //When the user presses the back button in AppBAr...
                  moveToLastScreen();
                },
              ),
            ),
            backgroundColor: Colors.white,
            body: scaffoldBody(),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                navigateToAddSubscriberDietPage(true);
              },
              tooltip: 'Añadir nueva Dieta',
              child: Icon(Icons.add),
            )));
  }

  Widget scaffoldBody() {
    TextStyle titleStyle = Theme.of(context).textTheme.headline6;
    TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle2;
    return Column(
      children: <Widget>[
        Expanded(
            child: ListView(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Text(subscriberName, style: titleStyle),
                    ),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.all(3.0), child: FaceIcon()),
                        Center(child: Text('$caloriesSelected / ${totalCaloricValue.round()} calorías',style: titleStyle,))
                      ],
                    ),
                    Text('TC: ${totalCaloricValue.round()}'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('PtGC: $ptGoalCal ($ptGoal) '),
                        Text('HcGC: $hcGoalCal ($hcGoal) '),
                        Text('LipGC: $lipGoalCal ($lipGoal)')
                      ],
                    ),
                    Text('TCA: $caloriesAcc '),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('PtAC: $ptAccCal ($ptAcc) '),
                          Text('HcAC: $hcAccCal ($hcAcc) '),
                          Text('LipAC: $lipAccCal ($lipAcc)')
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('PtP: ${(ptP * 4).round()} ($ptP) '),
                          Text('HcP: ${(hcP * 4).round()} ($hcP) '),
                          Text('LipP: ${(lipP * 9).round()} ($lipP)')
                        ])
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text('Do',
                        style: subtitleStyle, textAlign: TextAlign.center),
                    SizedBox(
                        width: 40.0,
                        height: 40.0,
                        child: Radio(
                          value: 'Domingo',
                          groupValue: day,
                          onChanged: (String value) {
                            day = value;
                            _updateDietList();
                          },
                        ))
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('Lu',
                        style: subtitleStyle, textAlign: TextAlign.center),
                    SizedBox(
                        width: 40.0,
                        height: 40.0,
                        child: Radio(
                          value: 'Lunes',
                          groupValue: day,
                          onChanged: (String value) {
                            day = value;
                            _updateDietList();
                          },
                        ))
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('Mar',
                        style: subtitleStyle, textAlign: TextAlign.center),
                    SizedBox(
                        width: 40.0,
                        height: 40.0,
                        child: Radio(
                          value: 'Martes',
                          groupValue: day,
                          onChanged: (String value) {
                            day = value;
                            _updateDietList();
                          },
                        ))
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('Mier',
                        style: subtitleStyle, textAlign: TextAlign.center),
                    SizedBox(
                        width: 40.0,
                        height: 40.0,
                        child: Radio(
                          value: 'Miércoles',
                          groupValue: day,
                          onChanged: (String value) {
                            day = value;
                            _updateDietList();
                          },
                        ))
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('Jue',
                        style: subtitleStyle, textAlign: TextAlign.center),
                    SizedBox(
                        width: 40.0,
                        height: 40.0,
                        child: Radio(
                          value: 'Jueves',
                          groupValue: day,
                          onChanged: (String value) {
                            day = value;
                            _updateDietList();
                          },
                        ))
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('Vier',
                        style: subtitleStyle, textAlign: TextAlign.center),
                    SizedBox(
                        width: 40.0,
                        height: 40.0,
                        child: Radio(
                          value: 'Viernes',
                          groupValue: day,
                          onChanged: (String value) {
                            day = value;
                            _updateDietList();
                          },
                        ))
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('Sa',
                        style: subtitleStyle, textAlign: TextAlign.center),
                    SizedBox(
                        width: 40.0,
                        height: 40.0,
                        child: Radio(
                          value: 'Sábado',
                          groupValue: day,
                          onChanged: (String value) {
                            day = value;
                            _updateDietList();
                          },
                        ))
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('Todos',
                        style: subtitleStyle, textAlign: TextAlign.center),
                    SizedBox(
                        width: 40.0,
                        height: 40.0,
                        child: Radio(
                          value: 'Todos',
                          groupValue: day,
                          onChanged: (String value) {
                            day = value;
                            _updateDietList();
                          },
                        ))
                  ],
                ),
              ],
            )
          ],
        )),
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(right: 5, left: 5),
                      child: Column(children: <Widget>[
                        RaisedButton(
                          elevation: 3.0,
                          padding: EdgeInsets.all(0),
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            'Desayuno',
                            style: TextStyle(color: Colors.white),
                            //textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            //When the Dieta button is pressed...
                            setState(() {
                              foodPortionsOnView = 1;
                              auxiliarShowableFoodPortionList = breakfastList;
                            });
                          },
                        ),
                        DragTarget<FoodPortionModel>(
                            onAccept: (receivedItem) {
                              setState(() {
                                breakfastHover = false;
                                breakfastQ++;
                                breakfastList.add(receivedItem);
                                switch (foodPortionsOnView) {
                                  case 0:
                                    foodPortionModels.remove(receivedItem);
                                    auxiliarShowableFoodPortionList =
                                        foodPortionModels;
                                    caloriesSelected += receivedItem.calories;
                                    break;
                                  case 1:
                                    breakfastList.remove(receivedItem);
                                    auxiliarShowableFoodPortionList =
                                        breakfastList;
                                    breakfastQ--;
                                    break;
                                  case 2:
                                    mealList.remove(receivedItem);
                                    auxiliarShowableFoodPortionList = mealList;
                                    mealQ--;
                                    break;

                                  case 3:
                                    dinnerList.remove(receivedItem);
                                    auxiliarShowableFoodPortionList =
                                        dinnerList;
                                    dinnerQ--;
                                    break;
                                  default:
                                }
                              });
                            },
                            onWillAccept: (receivedItem) {
                              breakfastHover = true;
                              return true;
                            },
                            onLeave: (receivedItem) {
                              breakfastHover = false;
                            },
                            builder: (context, acceptedItems, rejectedItems) =>
                                Container(
                                  width: 95,
                                  height: 95,
                                  margin: EdgeInsets.all(5),
                                  decoration: breakfastHover
                                      ? BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 5,
                                          ),
                                        )
                                      : null,
                                  child: Image.asset('images/breakfast2.jpg'),
                                )),
                        Text('$breakfastQ', style: subtitleStyle),
                      ]))),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(right: 5, left: 5),
                      child: Column(children: <Widget>[
                        RaisedButton(
                          elevation: 3.0,
                          padding: EdgeInsets.all(0),
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            'Almuerzo',
                            style: TextStyle(color: Colors.white),
                            //textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            //When the Dieta button is pressed...
                            setState(() {
                              foodPortionsOnView = 2;
                              auxiliarShowableFoodPortionList = mealList;
                            });
                          },
                        ),
                        DragTarget<FoodPortionModel>(
                            onAccept: (receivedItem) {
                              setState(() {
                                mealQ++;
                                mealHover = false;
                                mealList.add(receivedItem);
                                switch (foodPortionsOnView) {
                                  case 0:
                                    foodPortionModels.remove(receivedItem);
                                    auxiliarShowableFoodPortionList =
                                        foodPortionModels;
                                    caloriesSelected += receivedItem.calories;
                                    break;
                                  case 1:
                                    breakfastList.remove(receivedItem);
                                    auxiliarShowableFoodPortionList =
                                        breakfastList;
                                    breakfastQ--;
                                    break;
                                  case 2:
                                    mealList.remove(receivedItem);
                                    auxiliarShowableFoodPortionList = mealList;
                                    mealQ--;
                                    break;

                                  case 3:
                                    dinnerList.remove(receivedItem);
                                    auxiliarShowableFoodPortionList =
                                        dinnerList;
                                    dinnerQ--;
                                    break;
                                  default:
                                }
                              });
                            },
                            onWillAccept: (receivedItem) {
                              mealHover = true;
                              return true;
                            },
                            onLeave: (receivedItem) {
                              mealHover = false;
                            },
                            builder: (context, acceptedItems, rejectedItems) =>
                                Container(
                                  width: 95,
                                  height: 95,
                                  margin: EdgeInsets.all(5),
                                  decoration: mealHover
                                      ? BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 5,
                                          ),
                                        )
                                      : null,
                                  child: Image.asset('images/meal2.jpg'),
                                )),
                        Text('$mealQ', style: subtitleStyle),
                      ]))),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(right: 5, left: 5),
                      child: Column(
                        children: <Widget>[
                          RaisedButton(
                            elevation: 3.0,
                            padding: EdgeInsets.all(0),
                            color: Theme.of(context).primaryColor,
                            child: Text(
                              'Cena',
                              style: TextStyle(color: Colors.white),
                              //textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              //When the Dieta button is pressed...
                              setState(() {
                                foodPortionsOnView = 3;
                                auxiliarShowableFoodPortionList = dinnerList;
                              });
                            },
                          ),
                          DragTarget<FoodPortionModel>(
                              onAccept: (receivedItem) {
                                setState(() {
                                  dinnerQ++;
                                  dinnerHover = false;
                                  dinnerList.add(receivedItem);

                                  switch (foodPortionsOnView) {
                                    case 0:
                                      foodPortionModels.remove(receivedItem);
                                      auxiliarShowableFoodPortionList =
                                          foodPortionModels;
                                      caloriesSelected += receivedItem.calories;
                                      break;
                                    case 1:
                                      breakfastList.remove(receivedItem);
                                      auxiliarShowableFoodPortionList =
                                          breakfastList;
                                      breakfastQ--;
                                      break;
                                    case 2:
                                      mealList.remove(receivedItem);
                                      auxiliarShowableFoodPortionList =
                                          mealList;
                                      mealQ--;
                                      break;

                                    case 3:
                                      dinnerList.remove(receivedItem);
                                      auxiliarShowableFoodPortionList =
                                          dinnerList;
                                      dinnerQ--;
                                      break;
                                    default:
                                  }
                                });
                              },
                              onWillAccept: (receivedItem) {
                                dinnerHover = true;
                                return true;
                              },
                              onLeave: (receivedItem) {
                                dinnerHover = false;
                              },
                              builder: (context, acceptedItems,
                                      rejectedItems) =>
                                  Container(
                                    width: 95,
                                    height: 95,
                                    //padding: EdgeInsets.all(20),
                                    margin: EdgeInsets.all(5),
                                    decoration: dinnerHover
                                        ? BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 5,
                                            ),
                                          )
                                        : null,
                                    child: Image.asset('images/dinner2.jpg'),
                                  )),
                          Text('$dinnerQ', style: subtitleStyle),
                        ],
                      ))),
            ],
          ),
        ),
        RaisedButton(
          elevation: 3.0,
          padding: EdgeInsets.all(0),
          color: Theme.of(context).primaryColor,
          child: Text(
            'Por asignar',
            style: TextStyle(color: Colors.white),
            //textScaleFactor: 1.5,
          ),
          onPressed: () {
            //When the Dieta button is pressed...
            setState(() {
              foodPortionsOnView = 0;
              auxiliarShowableFoodPortionList = foodPortionModels;
            });
          },
        ),
        Expanded(
          child: Scrollbar(
              child: ListView(
                  padding: const EdgeInsets.all(8.0),
                  shrinkWrap: true,
                  children: <Widget>[
                Column(
                    children: auxiliarShowableFoodPortionList.map((foodPortion) {
                  return Container(
                      margin: const EdgeInsets.all(8.0),
                      child: Draggable<FoodPortionModel>(
                          data: foodPortion,

                          ///feedbackOffset: Offset(100,100),
                          dragAnchor: DragAnchor.pointer,
                          childWhenDragging: Card(
                              color: Colors.white,
                              elevation: 2.0,
                              child: SizedBox(
                                width: 337,
                                height: 55,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColorLight,
                                    child: Icon(Icons.restaurant_menu,
                                        color: Colors.white),
                                  ),
                                  title: Text(
                                    foodPortion.foodPortionName,
                                    style: subtitleStyle,
                                  ),
                                  //subtitle: Text(''),
                                  //trailing: trailingButtons(dietList[position]),
                                  onTap: () {
                                    //When suscriber is tapped...
                                    //navigateToSubscriberPage();
                                  },
                                ),
                              )),
                          feedback: CircleAvatar(
                            radius: 35,
                            child: Icon(Icons.restaurant_menu),
                          ),
                          child: Card(
                              color: Theme.of(context).primaryColorLight,
                              elevation: 2.0,
                              child: SizedBox(
                                width: 337,
                                height: 55,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: Icon(Icons.restaurant_menu),
                                  ),
                                  title: Text(
                                    foodPortion.foodPortionName,
                                    style: subtitleStyle,
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.edit,
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.75)),
                                    onPressed: () async{
                                      if (!foodPortionOverlayEntryIsOn)
                                      {
                                        substitutingFoodPortionList = await databaseHelper.getFoodPortionByFoodGroupIdList(foodPortion.foodGroupId);
                                        showFoodPortionsOverlay(context,foodPortion);
                                      }
                                    },
                                    alignment: Alignment.centerRight,
                                    tooltip: 'Editar',
                                  ),
                                  onTap: () {},
                                ),
                              ))));
                }).toList())
              ])),
        )
      ],
    );
  }

  showOverlay(BuildContext context) {
    overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
            top: (MediaQuery.of(context).size.height / 6) + 100,
            right: (MediaQuery.of(context).size.width / 1.1) - 305,
            child: overlayWidget()));
    overlayState.insert(overlayEntry);
    overlayEntryIsOn = true;
  }

  showFoodPortionsOverlay(BuildContext context, FoodPortionModel foodPortion) {
    overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
            top: (MediaQuery.of(context).size.height / 6) + 270,
            right: (MediaQuery.of(context).size.width / 1.1) - 320,
            child: overlayFoodPortions(foodPortion)));
    overlayState.insert(overlayEntry);
    foodPortionOverlayEntryIsOn = true;
  }

  Widget overlayWidget() {
    //TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle2;
    return Card(
      elevation: 15.0,
      child: Column(
        children: <Widget>[
          SizedBox(
              width: 300,
              height: 105,
              child: Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Para preparar la dieta se requieren el peso y el nivel de actividad física del suscriptor. Vaya a Evaluación para completar estos datos.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.left,
                  ))),
          Row(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(3.0),
                  child: RaisedButton(
                    elevation: 3.0,
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      'Ir a Evaluación',
                      style: TextStyle(color: Colors.white),
                      //textScaleFactor: 1.5,
                    ),
                    onPressed: () async {
                      //When the button is pressed...
                      overlayEntry.remove();
                      overlayEntryIsOn = false;
                      navigateToEvaluation();
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  )),
              Padding(
                  padding: EdgeInsets.all(3.0),
                  child: RaisedButton(
                    elevation: 3.0,
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      'Atrás',
                      style: TextStyle(color: Colors.white),
                      //textScaleFactor: 1.5,
                    ),
                    onPressed: () {
                      //When the button is pressed...
                      overlayEntry.remove();
                      overlayEntryIsOn = false;
                      moveToLastScreen();
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ))
            ],
          ),
        ],
      ),
    );
  }

  Widget overlayFoodPortions (FoodPortionModel originalFoodPortion) {
    TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle2;
    return Container(
        //color: Colors.white,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.75),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 1,
          ),
        ),
        height: 250,
        width: 345,
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(3),
                child: Text("Seleccione la porción alimenticia sustituta",
                textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0, color: Colors.black,decoration: null))),
            Expanded(
                child: Scrollbar(
                    child: ListView(
                        padding: const EdgeInsets.all(8.0),
                        shrinkWrap: true,
                        children: <Widget>[
                  Column(
                      children: substitutingFoodPortionList.map((foodPortion) {
                    return Container(
                        margin: const EdgeInsets.all(8.0),
                        child: Card(
                            color: Theme.of(context).primaryColorLight,
                            elevation: 2.0,
                            child: SizedBox(
                              width: 337,
                              height: 55,
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Icon(Icons.restaurant_menu),
                                ),
                                title: Text(
                                  originalFoodPortion.quantity.toString()+'x '+foodPortion.foodPortionName+'(${originalFoodPortion.calories}k)',
                                  style: subtitleStyle,
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.edit,
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.75)),
                                  onPressed: () {
                                    // if (!foodPortionOverlayEntryIsOn)
                                    //   showFoodPortionsOverlay(context);
                                  },
                                  alignment: Alignment.centerRight,
                                  tooltip: 'Editar',
                                ),
                                onTap: () {
                                  FoodPortionModel foodPortionModel = FoodPortionModel(foodPortion.foodGroupId, originalFoodPortion.quantity.toString()+
                                    'x '+foodPortion.foodPortionName+'(${originalFoodPortion.calories}k)', originalFoodPortion.quantity,originalFoodPortion.calories);
                                  switch (foodPortionsOnView) {
                                  case 0:
                                    foodPortionModels.insert(foodPortionModels.indexOf(originalFoodPortion), foodPortionModel);
                                    foodPortionModels.remove(originalFoodPortion);
                                    auxiliarShowableFoodPortionList =
                                        foodPortionModels;
                                    break;
                                  case 1:
                                    breakfastList.insert(breakfastList.indexOf(originalFoodPortion), foodPortionModel);
                                    breakfastList.remove(originalFoodPortion);
                                    auxiliarShowableFoodPortionList =
                                        breakfastList;
                                    break;
                                  case 2:
                                    mealList.insert(mealList.indexOf(originalFoodPortion), foodPortionModel);
                                    mealList.remove(originalFoodPortion);
                                    auxiliarShowableFoodPortionList = mealList;
                                    break;

                                  case 3:
                                    dinnerList.insert(dinnerList.indexOf(originalFoodPortion), foodPortionModel);
                                    dinnerList.remove(originalFoodPortion);
                                    auxiliarShowableFoodPortionList =
                                        dinnerList;
                                    break;
                                  default:
                                }

                                    setState(() {
                                      overlayEntry.remove();
                                      foodPortionOverlayEntryIsOn = false;
                                    });
                                },
                              ),
                            )));
                  }).toList())
                ])))
          ],
        ));
  }

  double caloricPunctuation(
      FoodGroup foodGroup, int ptGr, int lipGr, int hcGr) {
    double ptPercentage;
    double lipPercentage;
    double hcPercentage;

    double punctuation;
    double ptPunctuation;
    double lipPunctuation;
    double hcPunctuation;

    double thePtPercentage;
    double theLipPercentage;
    double theHcPercentage;

    int totalDesiredGr = ptGr + lipGr + hcGr;
    ptPercentage = ptGr / totalDesiredGr;
    lipPercentage = lipGr / totalDesiredGr;
    hcPercentage = hcGr / totalDesiredGr;

    int totalGr = foodGroup.prot + foodGroup.lip + foodGroup.hc;

    thePtPercentage = foodGroup.prot / totalGr;
    theLipPercentage = foodGroup.lip / totalGr;
    theHcPercentage = foodGroup.hc / totalGr;

    if (thePtPercentage <= ptPercentage)
      ptPunctuation = thePtPercentage;
    else
      ptPunctuation = 2 * ptPercentage - thePtPercentage;

    if (theLipPercentage <= lipPercentage)
      lipPunctuation = theLipPercentage;
    else
      lipPunctuation = 2 * lipPercentage - theLipPercentage;

    if (theHcPercentage <= hcPercentage)
      hcPunctuation = theHcPercentage;
    else
      hcPunctuation = 2 * hcPercentage - theHcPercentage;

    punctuation = ptPunctuation + lipPunctuation + hcPunctuation;
    return punctuation;
  }

  void calculateCalories() async {
    double mb;
    double mbFactor;

    if (subscriber.gender == 'M')
      mbFactor = 1;
    else
      mbFactor = 0.95;

    mb = (subscriber.weight / 2.205) * mbFactor * 24;
    totalCaloricValue =
        mb * subscriber.activityFactor; // Incremented 10% for mass gain

    hcGoalCal = (totalCaloricValue * 0.6).round();
    ptGoalCal = (totalCaloricValue * 0.2).round();
    lipGoalCal = (totalCaloricValue * 0.2).round();
    hcGoal = (hcGoalCal / 4).round();
    ptGoal = (ptGoalCal / 4).round();
    lipGoal = (lipGoalCal / 9).round();
  }

  void addBestNextFoodPortion() {
    List<double> foodGroupPunctuationList = List<double>();
    int maxPunctuationIndex;
    double maxPunctuation = -100;
    for (int i = 0;
        i < foodGroupList.length;
        i++) //Improve logic; foodGroup Id not necessarily is sequential
    {
      foodGroupPunctuationList.add(caloricPunctuation(
          foodGroupList[i],
          (ptGoalCal / 4).round() - ptAcc,
          (lipGoalCal / 9).round() - lipAcc,
          (hcGoalCal / 4).round() - hcAcc));
      //debugPrint('The punctuation of ' +
          //foodGroupList[i].foodGroupName +
          //': ${foodGroupPunctuationList[i]}');
      if (foodGroupPunctuationList[i] > maxPunctuation &&
          maxFoodPortionQuantity[i] > 0 &&
          foodGroupQuantity[i] <
              (maxFoodPortionQuantity[i] * maxMultiplierInFoodGroup[i])) {
        maxPunctuationIndex = i;
        maxPunctuation = foodGroupPunctuationList[i];
      }
    }
    //debugPrint(maxPunctuationIndex.toString());
    //debugPrint('The max punctuation food group is ' +
        //foodGroupList[maxPunctuationIndex].foodGroupName +
        //' (${foodGroupPunctuationList[maxPunctuationIndex]})');
    //debugPrint('(${foodGroupPunctuationList[maxPunctuationIndex]})');

    //select best foodportion and make sure not to repeat previous one
    //foodPortionList.add(foodPortionListList[maxPunctuationIndex][foodPortionIndexList[maxPunctuationIndex]]);
    foodGroupQuantity[maxPunctuationIndex]++;

    // if(foodPortionIndexList[maxPunctuationIndex] == foodPortionListList[maxPunctuationIndex].length-1)
    //   {foodPortionIndexList[maxPunctuationIndex]=0;}
    // else {foodPortionIndexList[maxPunctuationIndex]++;}


    caloriesAcc += foodGroupList[maxPunctuationIndex].prot * 4 +
        foodGroupList[maxPunctuationIndex].hc * 4 +
        foodGroupList[maxPunctuationIndex].lip * 9;
    ptP = foodGroupList[maxPunctuationIndex].prot;
    hcP = foodGroupList[maxPunctuationIndex].hc;
    lipP = foodGroupList[maxPunctuationIndex].lip;
    ptAcc += ptP;
    hcAcc += hcP;
    lipAcc += lipP;
    ptAccCal = ptAcc * 4;
    hcAccCal = hcAcc * 4;
    lipAccCal = lipAcc * 9;
  }

  void addObligatoryFoodPortions() {
    for (int i = 0; i < obligatoryFoodPortionQuantity.length; i++) {
      if (obligatoryFoodPortionQuantity[i] > 0) {
        foodGroupQuantity[i] = obligatoryFoodPortionQuantity[i];
        caloriesAcc += (foodGroupList[i].prot * 4 +
                foodGroupList[i].hc * 4 +
                foodGroupList[i].lip * 9) *
            obligatoryFoodPortionQuantity[i];
        ptP = (foodGroupList[i].prot) * obligatoryFoodPortionQuantity[i];
        hcP = (foodGroupList[i].hc) * obligatoryFoodPortionQuantity[i];
        lipP = (foodGroupList[i].lip) * obligatoryFoodPortionQuantity[i];
        ptAcc += ptP;
        hcAcc += hcP;
        lipAcc += lipP;
        ptAccCal = ptAcc * 4;
        hcAccCal = hcAcc * 4;
        lipAccCal = lipAcc * 9;
      }
    }
  }

  void _updateDietList() async {
    // if (totalCaloricValue == 0)
    //   calculateCalories();

    if (foodGroupList.length == 0)
      foodGroupList = await databaseHelper.getFoodGroupList();

    if (foodPortionListList.length == 0) {
      for (int i = 0; i < foodGroupList.length; i++) {
        List<FoodPortion> theFoodPortionList =
            await databaseHelper.getFoodPortionByFoodGroupIdList(i +
                1); //Improve logic; foodGroup Id not necessarily is sequential
        foodPortionListList.add(theFoodPortionList);
        foodGroupQuantity.add(0);
        //foodPortionIndexList.add(0);
      }
    }

    addObligatoryFoodPortions();

    while (caloriesAcc < totalCaloricValue) {
      addBestNextFoodPortion();
    }

    //Logic to add different food portions from the food groups selected

    int foodPortionQuantityLastIndex = 0;
    for (int i = 0; i < foodGroupQuantity.length; i++) {

      if (maxFoodPortionQuantity[i] > 0) {
        int t = foodGroupQuantity[i] ~/ maxFoodPortionQuantity[i];
        int r = foodGroupQuantity[i] % maxFoodPortionQuantity[i];

        if (t > 0) {
          for (int j = 0; j < maxFoodPortionQuantity[i]; j++) {
            foodPortionList.add(foodPortionListList[i][j]);
            foodPortionQuantity.add(t);
            caloriesPerFoodPortion.add(foodGroupList[foodPortionListList[i][j].foodGroupId-1].prot*4 +foodGroupList[foodPortionListList[i][j].foodGroupId-1].hc*4 +
                foodGroupList[foodPortionListList[i][j].foodGroupId-1].lip*9);
          }
          for (int j = 0; j < r; j++) {
            foodPortionQuantity[foodPortionQuantityLastIndex + j]++;
          }
        } else {
          for (int j = 0; j < r; j++) {
            foodPortionList.add(foodPortionListList[i][j]);
            foodPortionQuantity.add(1);
            caloriesPerFoodPortion.add(foodGroupList[foodPortionListList[i][j].foodGroupId-1].prot*4 +foodGroupList[foodPortionListList[i][j].foodGroupId-1].hc*4 +
                foodGroupList[foodPortionListList[i][j].foodGroupId-1].lip*9);
          }
        }

        foodPortionQuantityLastIndex = foodPortionQuantity.length;
      }

    }
    for(int i=0;i<caloriesPerFoodPortion.length;i++)
      {
        caloriesPerFoodPortion[i] *= foodPortionQuantity[i]; //Multiplying calories of food portion per quantity of portions to get total calories
      }
    setState(() {
      auxiliarFoodPortionList = foodPortionList;
      listCount = foodPortionList.length;
      auxiliarFoodPortionQuantity = foodPortionQuantity;
      fillFoodPortionTexts();
    });

  }

  void fillFoodPortionTexts() {
    //TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle2;
    for (int position = 0;
        position < foodPortionList.length;
        position++) {
          FoodPortionModel foodPortionModel=FoodPortionModel(auxiliarFoodPortionList[position].foodGroupId,auxiliarFoodPortionQuantity[position].toString() +
          'x ' +
          auxiliarFoodPortionList[position].foodPortionName 
          +'(${caloriesPerFoodPortion[position]}k)' ,auxiliarFoodPortionQuantity[position],caloriesPerFoodPortion[position]);
      foodPortionModels.add(foodPortionModel);  
    }
    auxiliarShowableFoodPortionList = foodPortionModels;
  }

  navigateToAddSubscriberDietPage(bool addDiet, [Diet diet]) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      String appBarText;
      if (addDiet) {
        appBarText = 'Añadir nueva Dieta';
        return AddSubscriberDietPage(addDiet, appBarText, subscriberId);
      } else {
        appBarText = 'Editar Dieta';
        return AddSubscriberDietPage(addDiet, appBarText, null, diet);
      }
    }));
    if (result) {
      _updateDietList();
    }
  }

  void moveToLastScreen() {
    if (foodPortionOverlayEntryIsOn) {
      overlayEntry.remove();
      foodPortionOverlayEntryIsOn = false;
    } else {
      if (overlayEntryIsOn) {
        overlayEntry.remove();
        overlayEntryIsOn = false;
      }
      Navigator.pop(context);
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _deleteDiet(int subscriberId, int dietId) async {
    int result =
        await databaseHelper.deleteSubscriberDiet(subscriberId, dietId);
    if (result != 0) {
      _updateDietList();
      _showAlertDialog('Éxito', 'Eliminación Exitosa');
    } else {
      _showAlertDialog('Error', 'Ocurrió un error al tratar de Eliminar');
    }
  }

  void _showDeleteDialog(int subscriberId, int dietId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Eliminar"),
          content: Text(
              "¿Desea eliminar la Dieta del Suscriptor? Si acepta, entonces se dejará de asociar la Dieta con el Suscriptor. Sin embargo, la Dieta como tal permanecerá."),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 30.0),
                child: FlatButton(
                  child: Text("Aceptar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _deleteDiet(subscriberId, dietId);
                  },
                )),
            FlatButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void navigateToEvaluation() async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Evaluation(subscriber);
    }));
    if (result) {
      if (subscriber.activityFactor == null || subscriber.weight == null)
        showOverlay(context);
      else
        _updateDietList();
    }
  }

  void getSubscriber() async {
    subscriber = await databaseHelper.getSubscriberById(subscriberId);
    if (subscriber.activityFactor == null || subscriber.weight == null)
      showOverlay(context);
    else {
      maxFoodPortionQuantity = [0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 3, 1, 4, 2, 2, 1];
      obligatoryFoodPortionQuantity = [
        0,
        0,
        0,
        0,
        0,
        2,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
        0
      ];
      maxMultiplierInFoodGroup = [
        2,
        2,
        2,
        2,
        2,
        4,
        4,
        4,
        4,
        4,
        4,
        4,
        4,
        4,
        4,
        4
      ];
      calculateCalories();
      _updateDietList();
    }
  }
}

class FoodPortionModel
{
  int foodGroupId;
  String foodPortionName;
  int quantity;
  int calories;

  FoodPortionModel(this.foodGroupId,this.foodPortionName,this.quantity,this.calories);
}

