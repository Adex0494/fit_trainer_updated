import 'package:fit_trainer_updated/models/exercise.dart';
import 'package:fit_trainer_updated/screens/add_subscriber_exercise_page.dart';
import 'package:fit_trainer_updated/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'subscriber_page.dart';

class Exercises extends StatefulWidget {
  final int subscriberId;
  final String subscriberName;
  Exercises(this.subscriberName, this.subscriberId);
  @override
  State<StatefulWidget> createState() {
    return ExercisesState(this.subscriberName, this.subscriberId);
  }
}

class ExercisesState extends State<Exercises> {
  int subscriberId;
  final String subscriberName;
  ExercisesState(this.subscriberName, this.subscriberId);
  // static var _weekDays = [
  //   'Domingo',
  //   'Lunes',
  //   'Martes',
  //   'Miércoles',
  //   'Jueves',
  //   'Viernes',
  //   'Sábado'
  // ];
  String day = 'Domingo';
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Exercise> exerciseList;
  //List<String> exerciseTypeNameList=List<String>();
  int listCount = 0;
  List<String> auxListTileDescription;
  @override
  Widget build(BuildContext context) {
    if (exerciseList == null) {
      _updateExerciseList();
    }
    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Ejercicios del Suscriptor'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                //When the user presses the back button in AppBAr...
                moveToLastScreen();
              },
            ),
          ),
          body: scaffoldBody(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              navigateToAddSubscriberExercisePage(true);
            },
            tooltip: 'Añadir nuevo Ejercicio',
            child: Icon(Icons.add),
          )),
    );
  }

  Widget scaffoldBody() {
    TextStyle titleStyle = Theme.of(context).textTheme.title;
    TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle;
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Column(
        children: <Widget>[
          Expanded(
              child: ListView(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Text(
                      subscriberName,
                      style: titleStyle,
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(3.0), child: FaceIcon()),
                  Row(
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
                                  _updateExerciseList();
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
                                  _updateExerciseList();
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
                                  _updateExerciseList();
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
                                  _updateExerciseList();
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
                                  _updateExerciseList();
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
                                  _updateExerciseList();
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
                                  _updateExerciseList();
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
                                  _updateExerciseList();
                                },
                              ))
                        ],
                      ),
                    ],
                  )
                ],
              )
            ],
          )),
          Expanded(
              child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                    //shrinkWrap: true,
                    itemCount: listCount,
                    itemBuilder: (BuildContext context, int position) {
                      return Card(
                        color: Theme.of(context).primaryColorLight,
                        elevation: 2.0,
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.fitness_center),
                          ),
                          title: Text(
                            auxListTileDescription[position],
                            style: subtitleStyle,
                          ),
                          //subtitle: Text(''),
                          trailing: trailingButtons(exerciseList[position]),
                          onTap: () {
                            //When suscriber is tapped...
                            //navigateToSubscriberPage();
                          },
                        ),
                      );
                    }),
              )
            ],
          ))
        ],
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context);
  }

  void navigateToAddSubscriberExercisePage(bool addExercise,
      [Exercise exercise]) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      String appBarText;
      if (addExercise) {
        appBarText = 'Añadir nuevo Ejercicio';
        return AddSubscriberExercise(addExercise, appBarText, subscriberId);
      } else {
        appBarText = 'Editar Ejercicio';
        return AddSubscriberExercise(addExercise, appBarText, null, exercise);
      }
    }));
    if (result) {
      _updateExerciseList();
    }
  }

  void _updateExerciseList() async {
    //List<String> auxStringList = List<String>();
    List<Exercise> exerciseListAux = List<Exercise>();
    List<String> preAuxDescription = List<String>();
    String timeUnit;
    String timeUnitQuantity;
    int repetitionQuantity;
    String restingTimeUnit;
    String restingTime;
    String auxString;
    String auxStringSufix;

    if (day == 'Todos') {
      exerciseListAux =
          await databaseHelper.getExerciseListofSubscriber(subscriberId);
    } else {
      exerciseListAux = await databaseHelper.getDayExerciseListofSubscriber(
          subscriberId, day);
    }
    int count = exerciseListAux.length;
    for (int c = 0; c < count; c++) {
      List<Map<String, dynamic>> map = await databaseHelper
          .getAnExerciseTypeNameMap(exerciseListAux[c].exerciseTypeId);
      String name = map[0]['name'];
      //auxStringList.add(name);

      if (exerciseListAux[c].restingTimeUnit == 'M') {
        restingTimeUnit = 'm';
      } else {
        restingTimeUnit = 's';
      }

      if (exerciseListAux[c].restingTime % 1 == 0) {
        restingTime = exerciseListAux[c].restingTime.round().toString();
      } else {
        restingTime = exerciseListAux[c].restingTime.toString();
      }

      auxStringSufix = exerciseListAux[c].sessionQuantity.toString() +
          ' Sesiones. Descanso: ' +
          '$restingTime$restingTimeUnit' +
          '. ' +
          exerciseListAux[c].day +
          '.';

      if (exerciseListAux[c].unitType == 'R') {
        repetitionQuantity = exerciseListAux[c].repetitionQuantity;
        auxString = '$repetitionQuantity Repeticiones $name. ' + auxStringSufix;
      } else {
        if (exerciseListAux[c].timeUnitQuantity % 1 == 0) {
          timeUnitQuantity =
              exerciseListAux[c].timeUnitQuantity.round().toString();
        } else {
          timeUnitQuantity = exerciseListAux[c].timeUnitQuantity.toString();
        }
        if (exerciseListAux[c].timeUnit == 'M') {
          timeUnit = 'm';
        } else {
          timeUnit = 's';
        }
        auxString = '$timeUnitQuantity$timeUnit $name. ' + auxStringSufix;
      }
      preAuxDescription.add(auxString);
    }
    setState(() {
      //exerciseTypeNameList = auxStringList;
      this.exerciseList = exerciseListAux;
      this.listCount = exerciseListAux.length;
      this.auxListTileDescription = preAuxDescription;
    });
  }

  Widget trailingButtons(Exercise exercise) {
    return SizedBox(
        width: 96.0,
        child: Row(children: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 0.0),
              child: IconButton(
                icon: Icon(Icons.edit,
                    color: Theme.of(context).primaryColor.withOpacity(0.75)),
                onPressed: () {
                  navigateToAddSubscriberExercisePage(false, exercise);
                },
                alignment: Alignment.centerRight,
                tooltip: 'Editar',
              )),
          Padding(
              padding: EdgeInsets.only(left: 0.0),
              child: IconButton(
                icon: Icon(Icons.delete,
                    color: Theme.of(context).primaryColor.withOpacity(0.75)),
                onPressed: () {
                  _showDeleteDialog(subscriberId, exercise.id);
                },
                alignment: Alignment.centerRight,
                tooltip: 'Eliminar',
              ))
        ]));
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _deleteExercise(int subscriberId, int exerciseId) async {
    int result =
        await databaseHelper.deleteSubscriberExercise(subscriberId, exerciseId);
    if (result != 0) {
      _updateExerciseList();
      _showAlertDialog('Éxito', 'Eliminación Exitosa');
    } else {
      _showAlertDialog('Error', 'Ocurrió un error al tratar de Eliminar');
    }
  }

  void _showDeleteDialog(int subscriberId, int exerciseId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Eliminar"),
          content: Text(
              "¿Desea eliminar el Ejercicio del Suscriptor? Si acepta, entonces se dejará de asociar el Ejercicio con el Suscriptor. Sin embargo, el Ejercicio como tal permanecerá."),
          actions: <Widget>[
            Padding(padding: EdgeInsets.only(right: 30.0),
            child:
            FlatButton(
              child: Text("Aceptar"),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteExercise(subscriberId, exerciseId);
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
}
