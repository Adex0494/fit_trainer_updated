import 'package:fit_trainer_updated/models/diet.dart';
import 'package:fit_trainer_updated/models/dietSchedule.dart';
import 'package:fit_trainer_updated/models/food.dart';
import 'package:fit_trainer_updated/models/measureUnit.dart';
import 'package:fit_trainer_updated/models/subscriber_diet.dart';
import 'package:fit_trainer_updated/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class AddSubscriberDietPage extends StatefulWidget {
  final int subscriberId;
  final bool addDiet;
  final Diet diet;
  final String appBarText;
  AddSubscriberDietPage(this.addDiet, this.appBarText,
      [this.subscriberId, this.diet]);
  @override
  State<StatefulWidget> createState() {
    return AddSubscriberDietPageState(
        this.addDiet, this.appBarText, this.subscriberId, this.diet);
  }
}

class AddSubscriberDietPageState extends State<AddSubscriberDietPage> {
  int subscriberId;
  bool addDiet;
  Diet diet;
  String appBarText;
  AddSubscriberDietPageState(this.addDiet, this.appBarText,
      [this.subscriberId, this.diet]);
  DatabaseHelper databaseHelper = DatabaseHelper();
  TextEditingController foodController = TextEditingController();
  TextEditingController measureUnitController = TextEditingController();
  TextEditingController scheduleController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  // static var _weekDays = [
  //   'Domingo',
  //   'Lunes',
  //   'Martes',
  //   'Miércoles',
  //   'Jueves',
  //   'Viernes',
  //   'Sábado'
  // ];
  //String theDay = _weekDays[1];
  String day = 'Domingo';
  List<String> _allMeasureUnits = List<String>();
  String theMeasureUnit = '';
  List<String> _allFood = List<String>();
  String theFood = '';
  var _formkey = GlobalKey<FormState>();
  @override
  initState() {
    super.initState();
    if (diet != null) {
      _loadVariables();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_allMeasureUnits.length < 1) {
      _loadMeasureUnits();
    }
    if (_allFood.length < 1) {
      _loadFood();
    }
    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(appBarText),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  //When the user presses the back button in AppBAr...
                  moveToLastScreen();
                },
              ),
            ),
            backgroundColor: Colors.white,
            body: scaffoldBody()));
  }

  Widget scaffoldBody() {
    //TextStyle titleStyle = Theme.of(context).textTheme.title;
    TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle;
    return Container(
      alignment: Alignment.center,
      child: Form(
        key: _formkey,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(left: 3.0, right: 3.0, top: 3.0),
                      child: TextFormField(
                        style: subtitleStyle,
                        controller: foodController,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Introduzca el Nombre del Alimento';
                          }
                        },
                        decoration: InputDecoration(
                            labelText: 'Alimento (Arroz, etc...)',
                            labelStyle: subtitleStyle,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(5.0))),
                        onChanged: (value) {
                          //When Name Text has changed...
                          setState(() {
                            theFood = '';
                            _loadFood();
                          });
                        },
                      )),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 3.0, right: 3.0, bottom: 6.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Filtrar y seleccionar ',
                            style: subtitleStyle,
                          ),
                          DropdownButton(
                            items: _allFood.map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Text(dropDownStringItem),
                              );
                            }).toList(),
                            style: subtitleStyle,
                            value: theFood,
                            icon: Icon(Icons.arrow_downward,
                                color: Theme.of(context).primaryColor),
                            onChanged: (valueSelectedByUser) {
                              setState(() {
                                //debugPrint('User select $valueSelectedByUser');
                                theFood = valueSelectedByUser;
                                foodController.text = theFood;
                                _loadFood();
                              });
                            },
                          )
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(left: 3.0, right: 3.0, top: 3.0),
                      child: TextFormField(
                        style: subtitleStyle,
                        controller: measureUnitController,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Introduzca la Unidad de Medida';
                          }
                        },
                        decoration: InputDecoration(
                            labelText: 'Unidad de Medida (gr,oz,etc...)',
                            labelStyle: subtitleStyle,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(5.0))),
                        onChanged: (value) {
                          //When Name Text has changed...
                          setState(() {
                            theMeasureUnit = '';
                            _loadMeasureUnits();
                          });
                        },
                      )),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 3.0, right: 3.0, bottom: 6.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Filtrar y seleccionar ',
                            style: subtitleStyle,
                          ),
                          DropdownButton(
                            items: _allMeasureUnits
                                .map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Text(dropDownStringItem),
                              );
                            }).toList(),
                            style: subtitleStyle,
                            value: theMeasureUnit,
                            icon: Icon(Icons.arrow_downward,
                                color: Theme.of(context).primaryColor),
                            onChanged: (valueSelectedByUser) {
                              setState(() {
                                //debugPrint('User select $valueSelectedByUser');
                                theMeasureUnit = valueSelectedByUser;
                                measureUnitController.text = theMeasureUnit;
                                _loadMeasureUnits();
                              });
                            },
                          )
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.all(3.0),
                      child: TextFormField(
                        style: subtitleStyle,
                        controller: quantityController,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Introduzca la Cantidad';
                          }
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Cantidad',
                            labelStyle: subtitleStyle,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(5.0))),
                        onChanged: (value) {
                          //When Name Text has changed...
                        },
                      )),
                  basicTimeField(),
                  Padding(
                      padding: EdgeInsets.only(top: 5.0, bottom: 3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text('Do',
                                  style: subtitleStyle,
                                  textAlign: TextAlign.center),
                              SizedBox(
                                  width: 40.0,
                                  height: 40.0,
                                  child: Radio(
                                    value: 'Domingo',
                                    groupValue: day,
                                    onChanged: (String value) {
                                      day = value;
                                      setState(() {});
                                    },
                                  ))
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text('Lu',
                                  style: subtitleStyle,
                                  textAlign: TextAlign.center),
                              SizedBox(
                                  width: 40.0,
                                  height: 40.0,
                                  child: Radio(
                                    value: 'Lunes',
                                    groupValue: day,
                                    onChanged: (String value) {
                                      day = value;
                                      setState(() {});
                                    },
                                  ))
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text('Mar',
                                  style: subtitleStyle,
                                  textAlign: TextAlign.center),
                              SizedBox(
                                  width: 40.0,
                                  height: 40.0,
                                  child: Radio(
                                    value: 'Martes',
                                    groupValue: day,
                                    onChanged: (String value) {
                                      day = value;

                                      setState(() {});
                                    },
                                  ))
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text('Mier',
                                  style: subtitleStyle,
                                  textAlign: TextAlign.center),
                              SizedBox(
                                  width: 40.0,
                                  height: 40.0,
                                  child: Radio(
                                    value: 'Miércoles',
                                    groupValue: day,
                                    onChanged: (String value) {
                                      day = value;

                                      setState(() {});
                                    },
                                  ))
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text('Jue',
                                  style: subtitleStyle,
                                  textAlign: TextAlign.center),
                              SizedBox(
                                  width: 40.0,
                                  height: 40.0,
                                  child: Radio(
                                    value: 'Jueves',
                                    groupValue: day,
                                    onChanged: (String value) {
                                      day = value;

                                      setState(() {});
                                    },
                                  ))
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text('Vier',
                                  style: subtitleStyle,
                                  textAlign: TextAlign.center),
                              SizedBox(
                                  width: 40.0,
                                  height: 40.0,
                                  child: Radio(
                                    value: 'Viernes',
                                    groupValue: day,
                                    onChanged: (String value) {
                                      day = value;

                                      setState(() {});
                                    },
                                  ))
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text('Sa',
                                  style: subtitleStyle,
                                  textAlign: TextAlign.center),
                              SizedBox(
                                  width: 40.0,
                                  height: 40.0,
                                  child: Radio(
                                    value: 'Sábado',
                                    groupValue: day,
                                    onChanged: (String value) {
                                      day = value;

                                      setState(() {});
                                    },
                                  ))
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text('Todos',
                                  style: subtitleStyle,
                                  textAlign: TextAlign.center),
                              SizedBox(
                                  width: 40.0,
                                  height: 40.0,
                                  child: Radio(
                                    value: 'Todos',
                                    groupValue: day,
                                    onChanged: (String value) {
                                      day = value;

                                      setState(() {});
                                    },
                                  ))
                            ],
                          ),
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.all(3.0),
                    child: RaisedButton(
                      elevation: 3.0,
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Registrar',
                        style: TextStyle(color: Colors.white),
                        //textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        //When the Registrar button is pressed...
                        if (_formkey.currentState.validate())
                          _saveDiet(addDiet, subscriberId);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _saveDiet(bool addDiet, [int subscriberId]) async {
      List<Map<String, dynamic>> auxMap;
      Food food;
      MeasureUnit measureUnit;
      DietSchedule dietSchedule;
      int foodId;
      int measureUnitId;
      int dietScheduleId;
      int result;

      auxMap=await databaseHelper.findAFoodIdMap(foodController.text);
      if(auxMap.length==0){
        food = Food(foodController.text);
        await databaseHelper.insertFood(food);
        foodId = await databaseHelper.getFoodMaxId();
      }
      else{
        foodId=auxMap[0]['id'];
      }

      auxMap=await databaseHelper.findAMeasureUnitIdMap(measureUnitController.text);
      if(auxMap.length==0){
        measureUnit = MeasureUnit(measureUnitController.text);
        await databaseHelper.insertMeasureUnit(measureUnit);
        measureUnitId = await databaseHelper.getMeasureUnitMaxId();
      }
      else{
        measureUnitId=auxMap[0]['id'];
      }

      auxMap=await databaseHelper.findADietScheduleIdMap(scheduleController.text);
      if(auxMap.length==0){
        dietSchedule = DietSchedule(scheduleController.text);
        await databaseHelper.insertDietSchedule(dietSchedule);
        dietScheduleId = await databaseHelper.getDietScheduleMaxId();
      }
      else{
        dietScheduleId=auxMap[0]['id'];
      }


      if (addDiet) {
      Diet diet = Diet(foodId, measureUnitId, dietScheduleId,
          double.parse(quantityController.text), day);
      result = await databaseHelper.insertDiet(diet);
      if (result != 0) {
        int maxDietId = await databaseHelper.getDietMaxId();
        SubscriberDiet subscriberDiet = SubscriberDiet(subscriberId, maxDietId);
        result = await databaseHelper.insertSubscriberDiet(subscriberDiet);
        if (result != 0) {
          //moveToLastScreen();
          _showAlertDialog('Éxito', 'Registro exitoso');
          setState(() {
            foodController.text = '';
            measureUnitController.text = '';
            scheduleController.text = '';
            quantityController.text = '';
            _loadMeasureUnits();
            _loadFood();
          });
        } else {
          _showAlertDialog('Error', 'Ocurrió un error al tratar de Registrar');
        }
      } else {
        _showAlertDialog('Error', 'Ocurrió un error al tratar de Registrar');
      }
    }
    else{
      this.diet.foodId=foodId;
      this.diet.measureUnitId=measureUnitId;
      this.diet.scheduleId=dietScheduleId;
      this.diet.quantity=double.parse(quantityController.text);
      this.diet.day=day;
      result=await databaseHelper.updateDiet(diet);
      if (result != 0){
         moveToLastScreen();
        _showAlertDialog('Éxito', 'Registro exitoso');
      }
      else{
        _showAlertDialog('Error', 'Ocurrió un error al tratar de Registrar');
      }
    }
  }

  void moveToLastScreen() {
    debugPrint('Moving to last Screen');
    Navigator.pop(context, true);
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _loadMeasureUnits() async {
    List<MeasureUnit> measureUnitList = List<MeasureUnit>();
    if (measureUnitController.text == '') {
      measureUnitList = await databaseHelper.getMeasureUnitList();
    } else {
      measureUnitList = await databaseHelper
          .getMeasureUnitFilteredList(measureUnitController.text);
    }
    int theListCount = measureUnitList.length;
    List<String> auxList = [''];
    for (int x = 0; x < theListCount; x++) {
      auxList.add(measureUnitList[x].name);
    }
    setState(() {
      _allMeasureUnits = auxList;
    });
  }

  void _loadFood() async {
    List<Food> foodList = List<Food>();
    if (foodController.text == '') {
      foodList = await databaseHelper.getFoodList();
    } else {
      foodList = await databaseHelper.getFoodFilteredList(foodController.text);
    }
    int theListCount = foodList.length;
    List<String> auxList = [''];
    for (int x = 0; x < theListCount; x++) {
      auxList.add(foodList[x].name);
    }
    setState(() {
      _allFood = auxList;
    });
  }

  Widget basicTimeField() {
    final format = DateFormat("hh:mm a");
    TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle;
    return Padding(
        padding: EdgeInsets.all(3.0),
        child: DateTimeField(
          controller: scheduleController,
          validator: (DateTime value) {
            if (value == null) {
              return 'Introduzca la Hora de la Dieta';
            }
          },
          style: subtitleStyle,
          decoration: InputDecoration(
              labelText: 'Hora de la dieta',
              labelStyle: subtitleStyle,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(5.0))),
          format: format,
          onShowPicker: (context, currentValue) async {
            final time = await showTimePicker(
              context: context,
              initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            return DateTimeField.convert(time);
          },
        ));
  }

  void _loadVariables() async {
    List<Map<String, dynamic>> map;
    double number;
    String quantity;
    map = await databaseHelper.getAFoodNameMap(diet.foodId);
    foodController.text = map[0]['name'];
    theFood=foodController.text;
    _loadFood();
    map = await databaseHelper.getAMeasureUnitNameMap(diet.measureUnitId);
    measureUnitController.text = map[0]['name'];
    map = await databaseHelper.getADietScheduleScheduleMap(diet.scheduleId);
    scheduleController.text = map[0]['schedule'];
    number = diet.quantity;
    if (number % 1 == 0) {
      quantity = number.round().toString();
    } else {
      quantity = number.toString();
    }
    quantityController.text = quantity;
    day = diet.day;
    setState(() {});
  }
}
