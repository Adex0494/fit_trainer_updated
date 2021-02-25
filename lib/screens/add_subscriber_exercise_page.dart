import 'package:fit_trainer_updated/models/exercise.dart';
import 'package:fit_trainer_updated/models/exerciseType.dart';
import 'package:fit_trainer_updated/models/subscriber_exercise.dart';
import 'package:fit_trainer_updated/utils/database_helper.dart';
import 'package:flutter/material.dart';

class AddSubscriberExercise extends StatefulWidget {
  final int subscriberId;
  final bool addExercise;
  final Exercise exercise;
  final String appBarText;
  AddSubscriberExercise(this.addExercise, this.appBarText,
      [this.subscriberId, this.exercise]);
  @override
  State<StatefulWidget> createState() {
    return AddSubscriberExerciseState(
        this.addExercise, this.appBarText, this.subscriberId, this.exercise);
  }
}

class AddSubscriberExerciseState extends State<AddSubscriberExercise> {
  int subscriberId;
  bool addExercise;
  Exercise exercise;
  String appBarText;
  AddSubscriberExerciseState(this.addExercise, this.appBarText,
      [this.subscriberId, this.exercise]);
  DatabaseHelper databaseHelper = DatabaseHelper();
  TextEditingController nameController = TextEditingController();
  TextEditingController sessionQuantityController = TextEditingController();
  TextEditingController timeUnitQuantityController = TextEditingController();
  TextEditingController repetitionController = TextEditingController();
  TextEditingController restingTimeController = TextEditingController();
  List<String> _allExerciseTypes = List<String>();
  String theExerciseType = '';
  String day = 'Domingo';
  String unitType = 'R'; //'R' for Repetitions. 'T' for Time
  String timeUnit =
      'M'; //'M' for Minute. 'S' for Second. Used when unitType equals 'T'.
  String minuteOrSecond = 'Minutos'; //For the Resting Time label.
  String restingTimeUnit = 'M'; //'M' for Minute. 'S' for Second.
  var _formkey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    if (exercise != null) {
      _loadVariables();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_allExerciseTypes.length < 1) {
      _loadExerciseTypes();
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
                      padding: EdgeInsets.all(3.0),
                      child: TextFormField(
                        style: subtitleStyle,
                        controller: nameController,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Introduzca el Nombre del Ejercicio';
                          }
                        },
                        decoration: InputDecoration(
                            labelText: 'Nombre del Ejercicio',
                            labelStyle: subtitleStyle,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.redAccent),
                                borderRadius: BorderRadius.circular(5.0))),
                        onChanged: (value) {
                          //When Name Text has changed...
                          theExerciseType='';
                          _loadExerciseTypes();
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
                            items: _allExerciseTypes
                                .map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Text(dropDownStringItem),
                              );
                            }).toList(),
                            style: subtitleStyle,
                            value: theExerciseType,
                            icon: Icon(Icons.arrow_downward,
                                color: Theme.of(context).primaryColor),
                            onChanged: (valueSelectedByUser) {
                              setState(() {
                                //debugPrint('User select $valueSelectedByUser');
                                theExerciseType = valueSelectedByUser;
                                nameController.text = theExerciseType;
                                _loadExerciseTypes();
                              });
                            },
                          )
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.all(3.0),
                      child: TextFormField(
                        style: subtitleStyle,
                        controller: sessionQuantityController,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Introduzca la cantidad de Sesiones';
                          }
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Cantidad de Sesiones',
                            labelStyle: subtitleStyle,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.redAccent),
                                borderRadius: BorderRadius.circular(5.0))),
                        onChanged: (value) {
                          //When Name Text has changed...
                        },
                      )),
                  Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Tipo de Medición: ',
                              style: subtitleStyle,
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 3.0, top: 3.0, right: 3.0),
                                child: Column(
                                  children: <Widget>[
                                    Text('Por Repetición ',
                                        style: subtitleStyle,
                                        textAlign: TextAlign.center),
                                    SizedBox(
                                        width: 40.0,
                                        height: 40.0,
                                        child: Radio(
                                          value: 'R',
                                          groupValue: unitType,
                                          onChanged: (String value) {
                                            unitType = value;
                                            setState(() {});
                                          },
                                        ))
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 3.0, top: 3.0, right: 3.0),
                                child: Column(
                                  children: <Widget>[
                                    Text('Por Tiempo',
                                        style: subtitleStyle,
                                        textAlign: TextAlign.center),
                                    SizedBox(
                                        width: 40.0,
                                        height: 40.0,
                                        child: Radio(
                                          value: 'T',
                                          groupValue: unitType,
                                          onChanged: (String value) {
                                            unitType = value;
                                            setState(() {});
                                          },
                                        ))
                                  ],
                                ))
                          ])),
                  timeOrRepetitionBody(),
                  Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Row(
                        children: <Widget>[
                          //Padding(
                          //padding: EdgeInsets.all(3.0),
                          Expanded(

                              //width: 100.0,
                              child: TextFormField(
                            style: subtitleStyle,
                            controller: restingTimeController,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Introduzca el Tiempo de Descanso';
                              }
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: 'Tiempo de Descanso ',
                                labelStyle: subtitleStyle,
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.redAccent),
                                    borderRadius: BorderRadius.circular(5.0))),
                            onChanged: (value) {
                              //When Name Text has changed...
                            },
                          )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 3.0, top: 3.0, right: 3.0),
                              child: Column(
                                children: <Widget>[
                                  Text('En Minuto ',
                                      style: subtitleStyle,
                                      textAlign: TextAlign.center),
                                  SizedBox(
                                      width: 40.0,
                                      height: 40.0,
                                      child: Radio(
                                        value: 'M',
                                        groupValue: restingTimeUnit,
                                        onChanged: (String value) {
                                          restingTimeUnit = value;
                                          setState(() {});
                                        },
                                      ))
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 3.0, top: 3.0, right: 3.0),
                              child: Column(
                                children: <Widget>[
                                  Text('En Segundo',
                                      style: subtitleStyle,
                                      textAlign: TextAlign.center),
                                  SizedBox(
                                      width: 40.0,
                                      height: 40.0,
                                      child: Radio(
                                        value: 'S',
                                        groupValue: restingTimeUnit,
                                        onChanged: (String value) {
                                          restingTimeUnit = value;
                                          setState(() {});
                                        },
                                      ))
                                ],
                              ))
                        ],
                      )),
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
                          _saveExercise(addExercise, subscriberId);
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

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _saveExercise(bool addEcercise, [int subscriberId]) async {
    List<Map<String, dynamic>> auxMap;
    ExerciseType exerciseType;
    int exerciseTypeId;
    auxMap = await databaseHelper.findAnExerciseTypeIdMap(nameController.text);
    if (auxMap.length == 0) {
      exerciseType = ExerciseType(nameController.text);
      await databaseHelper.insertExerciseType(exerciseType);
      exerciseTypeId = await databaseHelper.getExerciseTypeMaxId();
    } else {
      exerciseTypeId = auxMap[0]['id'];
    }
    String auxTimeUnit;
    double auxTimeUnitQuantity;
    int auxRepetition;
    if (unitType == 'T') {
      auxTimeUnit = timeUnit;
      auxTimeUnitQuantity = double.parse(timeUnitQuantityController.text);
    } else {
      auxRepetition = int.parse(repetitionController.text);
    }
    int result;
    if (addExercise) {
      Exercise exercise = Exercise(
          exerciseTypeId,
          int.parse(sessionQuantityController.text),
          unitType,
          restingTimeUnit,
          double.parse(restingTimeController.text),
          day,
          auxTimeUnit,
          auxTimeUnitQuantity,
          auxRepetition);
      result = await databaseHelper.insertExercise(exercise);

      if (result != 0) {
        int exerciseId = await databaseHelper.getExerciseMaxId();
        SubscriberExercise subscriberExercise =
            SubscriberExercise(subscriberId, exerciseId);
        result =
            await databaseHelper.insertSubscriberExercise(subscriberExercise);
        if (result != 0) {
          _showAlertDialog('Éxito', 'Registro exitoso');
          setState(() {
            nameController.text = '';
            sessionQuantityController.text = '';
            timeUnitQuantityController.text = '';
            repetitionController.text = '';
            restingTimeController.text = '';
            _loadExerciseTypes();
          });
        } else {
          _showAlertDialog('Error', 'Ocurrió un error al tratar de Registrar');
        }
      } else {
        _showAlertDialog('Error', 'Ocurrió un error al tratar de Registrar');
      }
    } else {
      exercise.exerciseTypeId = exerciseTypeId;
      exercise.sessionQuantity = int.parse(sessionQuantityController.text);
      exercise.unitType = unitType;
      exercise.restingTimeUnit = restingTimeUnit;
      exercise.restingTime = double.parse(restingTimeController.text);
      exercise.day = day;
      exercise.timeUnit = auxTimeUnit;
      exercise.timeUnitQuantity = auxTimeUnitQuantity;
      exercise.repetitionQuantity = auxRepetition;
      result = await databaseHelper.updateExercise(exercise);
      if (result != 0) {
        moveToLastScreen();
        _showAlertDialog('Éxito', 'Registro exitoso');
      } else {
        _showAlertDialog('Error', 'Ocurrió un error al tratar de Registrar');
      }
    }
  }

  void moveToLastScreen() {
    debugPrint('Moving to last Screen');
    Navigator.pop(context, true);
  }

  void _loadExerciseTypes() async {
    List<ExerciseType> exerciseTypeList = List<ExerciseType>();
    if (nameController.text == '') {
      exerciseTypeList = await databaseHelper.getExerciseTypeList();
    } else {
      exerciseTypeList =
          await databaseHelper.getExerciseTypeFilteredList(nameController.text);
    }
    int theListCount = exerciseTypeList.length;
    List<String> auxList = [''];
    for (int x = 0; x < theListCount; x++) {
      auxList.add(exerciseTypeList[x].name);
    }
    setState(() {
      _allExerciseTypes = auxList;
    });
  }

  Widget timeOrRepetitionBody() {
    TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle;
    Widget theWidget;
    if (unitType == 'R') {
      theWidget = Padding(
          padding: EdgeInsets.all(3.0),
          child: TextFormField(
            style: subtitleStyle,
            controller: repetitionController,
            validator: (String value) {
              if (value.isEmpty) {
                return 'Introduzca la Cantidad de Repeticiones';
              }
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: 'Cantidad de Repeticiones',
                labelStyle: subtitleStyle,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent),
                    borderRadius: BorderRadius.circular(5.0))),
            onChanged: (value) {
              //When Name Text has changed...
            },
          ));
    } else {
      theWidget = Column(children: <Widget>[
        Padding(
            padding: EdgeInsets.all(3.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Unidad de Tiempo: ',
                    style: subtitleStyle,
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 3.0, top: 3.0, right: 3.0),
                      child: Column(
                        children: <Widget>[
                          Text('Minuto ',
                              style: subtitleStyle,
                              textAlign: TextAlign.center),
                          SizedBox(
                              width: 40.0,
                              height: 40.0,
                              child: Radio(
                                value: 'M',
                                groupValue: timeUnit,
                                onChanged: (String value) {
                                  minuteOrSecond = 'Minutos';
                                  timeUnit = value;
                                  setState(() {});
                                },
                              ))
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(left: 3.0, top: 3.0, right: 3.0),
                      child: Column(
                        children: <Widget>[
                          Text('Segundo',
                              style: subtitleStyle,
                              textAlign: TextAlign.center),
                          SizedBox(
                              width: 40.0,
                              height: 40.0,
                              child: Radio(
                                value: 'S',
                                groupValue: timeUnit,
                                onChanged: (String value) {
                                  minuteOrSecond = 'Segundos';
                                  timeUnit = value;
                                  setState(() {});
                                },
                              ))
                        ],
                      ))
                ])),
        Padding(
            padding: EdgeInsets.all(3.0),
            child: TextFormField(
              style: subtitleStyle,
              controller: timeUnitQuantityController,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Introduzca la Cantidad de $minuteOrSecond';
                }
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Cantidad de $minuteOrSecond',
                  labelStyle: subtitleStyle,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.redAccent),
                      borderRadius: BorderRadius.circular(5.0))),
              onChanged: (value) {
                //When Name Text has changed...
              },
            ))
      ]);
    }
    return theWidget;
  }

  void _loadVariables() async {
    double number;
    String quantity;
    List<Map<String, dynamic>> map;
    map = await databaseHelper.getAnExerciseTypeNameMap(exercise.exerciseTypeId);
    nameController.text = map[0]['name'];
    theExerciseType=nameController.text;
    _loadExerciseTypes();
    sessionQuantityController.text = exercise.sessionQuantity.toString();
    day = exercise.day;
    unitType = exercise.unitType;
    if (exercise.timeUnitQuantity != null) {
      timeUnit = exercise.timeUnit;
      number = exercise.timeUnitQuantity;
      if (number % 1 == 0) {
        quantity = number.round().toString();
      } else {
        quantity = number.toString();
      }
      timeUnitQuantityController.text = quantity;
    }
    if (exercise.repetitionQuantity != null) {
      repetitionController.text = exercise.repetitionQuantity.toString();
    }
    restingTimeUnit = exercise.restingTimeUnit;
    number = exercise.restingTime;
    if (number % 1 == 0) {
      quantity = number.round().toString();
    } else {
      quantity = number.toString();
    }
    restingTimeController.text = quantity;
    setState(() {
      if(timeUnit=='S'){
        minuteOrSecond='Segundos';
      }
    });
  }
}
