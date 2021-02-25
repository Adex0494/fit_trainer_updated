import 'package:fit_trainer_updated/models/subscriber.dart';
import 'package:fit_trainer_updated/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'subscriber_page.dart';

class Evaluation extends StatefulWidget {
  final Subscriber subscriber;
  Evaluation(this.subscriber);
  @override
  State<StatefulWidget> createState() {
    return EvaluationState(this.subscriber);
  }
}

class EvaluationState extends State<Evaluation> {
  Subscriber subscriber;
  EvaluationState(this.subscriber);
  OverlayState overlayState;
  OverlayEntry overlayEntry;
  bool overlayEntryIsOn = false;
  TextEditingController textController =
      TextEditingController(); //auxiliar text controller to save
  TextEditingController fatTextController = TextEditingController();
  TextEditingController fat2TextController = TextEditingController();
  TextEditingController fat3TextController = TextEditingController();
  TextEditingController fat4TextController = TextEditingController();
  TextEditingController fat5TextController = TextEditingController();
  TextEditingController fat6TextController = TextEditingController();
  TextEditingController distanceTextController = TextEditingController();
  TextEditingController footTextController = TextEditingController();
  TextEditingController inchesTextController = TextEditingController();
  String fatPercentage = '';
  String physicalCondition = '';
  String weight = '';
  String height = '';
  String bodyMassIndex = '';
  String hydrationLevel = '';
  String activityText = '';
  double activityFactor;
  String libras = '';
  double hc;
  double pt;
  double lip;

  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  initState() {
    super.initState();
    if (subscriber.weight != null) libras = ' libras';
    if (subscriber.activityFactor != null) {
      activityFactor = subscriber.activityFactor;

      if (activityFactor == 1.2) {
        activityText = 'Sedentario';
      }
      if (activityFactor == 1.375) activityText = 'Ligero';
      if (activityFactor == 1.55) activityText = 'Moderado';
      if (activityFactor == 1.65) activityText = 'Activo con pesas';
      if (activityFactor == 1.725) activityText = 'Muy activo con pesas';
      if (activityFactor == 1.9) activityText = 'Atleta';
    }
    _getSubscriberEvaluation();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text('Evaluación del Suscriptor'),
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
    TextStyle titleStyle = Theme.of(context).textTheme.title;
    TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle;
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: Container(
          alignment: Alignment.center,
          child: ListView(children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Text(
                    subscriber.name,
                    style: titleStyle,
                  ),
                ),
                Padding(padding: EdgeInsets.all(3.0), child: FaceIcon()),
                Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Container(
                      width: 310,
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Porcentaje de Grasa: $fatPercentage',
                            style: subtitleStyle,
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit,
                                color: Theme.of(context).primaryColor),
                            onPressed: () {
                              if(!overlayEntryIsOn)
                               showFatOverlay(context, 1);
                            },
                            alignment: Alignment.centerRight,
                            tooltip: 'Editar',
                          ),
                        ],
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Container(
                      width: 310,
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Condición física: $physicalCondition',
                            style: subtitleStyle,
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit,
                                color: Theme.of(context).primaryColor),
                            onPressed: () {
                              if(!overlayEntryIsOn)
                                showCooperTestOverlay(context, 6);
                            },
                            alignment: Alignment.centerRight,
                            tooltip: 'Editar',
                          ),
                        ],
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Container(
                      width: 310,
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Nivel de actividad: $activityText',
                            style: subtitleStyle,
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit,
                                color: Theme.of(context).primaryColor),
                            onPressed: () {
                              if(!overlayEntryIsOn)
                                showActivityOverlay(context, 7);
                            },
                            alignment: Alignment.centerRight,
                            tooltip: 'Editar',
                          ),
                        ],
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Container(
                      width: 310,
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Peso: $weight' + '$libras',
                            style: subtitleStyle,
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit,
                                color: Theme.of(context).primaryColor),
                            onPressed: () {
                              if(!overlayEntryIsOn)
                                showOverlay(context, 'Nuevo Peso en libras', 2);
                            },
                            alignment: Alignment.centerRight,
                            tooltip: 'Editar',
                          ),
                        ],
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Container(
                      width: 310,
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Estatura: $height',
                            style: subtitleStyle,
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit,
                                color: Theme.of(context).primaryColor),
                            onPressed: () {
                              if(!overlayEntryIsOn){
                                footTextController.text = '';
                                inchesTextController.text = '';
                                showHeightOverlay(context, 3);
                              }
                            },
                            alignment: Alignment.centerRight,
                            tooltip: 'Editar',
                          ),
                        ],
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Container(
                      width: 310,
                      height: 48,
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Índice de Masa Corporal: $bodyMassIndex',
                            style: subtitleStyle,
                          ),
                          Expanded(
                            child: Container(),
                          ),
                        ],
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Container(
                      width: 310,
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Nivel de Hidratación: $hydrationLevel',
                            style: subtitleStyle,
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit,
                                color: Theme.of(context).primaryColor),
                            onPressed: () {
                              if(!overlayEntryIsOn)
                                showOverlay(
                                    context, 'Nuevo Nivel de Hidratación', 5);
                            },
                            alignment: Alignment.centerRight,
                            tooltip: 'Editar',
                          ),
                        ],
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Container(
                      width: 310,
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Cuadro dietético',
                            style: subtitleStyle,
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          IconButton(
                            icon: Icon(Icons.zoom_in,
                                color: Theme.of(context).primaryColor),
                            onPressed: () {
                              if (subscriber.activityFactor == null ||
                                  subscriber.weight == null) {
                                _showAlertDialog('Error',
                                    'Nivel de actividad indefinido o Peso indefinido');
                              } else {
                                if(!overlayEntryIsOn)
                                {
                                  calculateCalories();
                                  showDietTableOverlay(context);
                                }
                              }
                            },
                            alignment: Alignment.centerRight,
                            tooltip: 'Ver',
                          ),
                        ],
                      )),
                )
              ],
            )
          ]),
        ));
  }

  showOverlay(BuildContext context, String text, int number) {
    textController.text = '';
    overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
            top: (MediaQuery.of(context).size.height / 5.0),
            right: (MediaQuery.of(context).size.width / 2.0) - 112.5,
            child: overlayWidget(text, number)));
    overlayState.insert(overlayEntry);
    overlayEntryIsOn = true;
  }

  showHeightOverlay(BuildContext context, int number) {
    textController.text = '';
    overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
            top: (MediaQuery.of(context).size.height / 5.0),
            right: (MediaQuery.of(context).size.width / 2.0) - 112.5,
            child: heightOverlayWidget(number)));
    overlayState.insert(overlayEntry);
    overlayEntryIsOn = true;
  }

  showFatOverlay(BuildContext context, int number) {
    textController.text = '';
    overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
            top: (MediaQuery.of(context).size.height / 5.0),
            right: (MediaQuery.of(context).size.width / 2.0) - 112.5,
            child: fatOverlayWidget(number)));
    overlayState.insert(overlayEntry);
    overlayEntryIsOn = true;
  }

  showCooperTestOverlay(BuildContext context, int number) {
    overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
            top: (MediaQuery.of(context).size.height / 5.0),
            right: (MediaQuery.of(context).size.width / 2.0) - 112.5,
            child: cooperTestOverlayWidget(number)));
    overlayState.insert(overlayEntry);
    overlayEntryIsOn = true;
  }

  showActivityOverlay(BuildContext context, int number) {
    textController.text = '';
    overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
            top: (MediaQuery.of(context).size.height / 5.0),
            right: (MediaQuery.of(context).size.width / 2.0) - 153,
            child: activityOverlayWidget(number)));
    overlayState.insert(overlayEntry);
    overlayEntryIsOn = true;
  }

  showDietTableOverlay(BuildContext context) {
    overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
            top: (MediaQuery.of(context).size.height / 5.0),
            right: (MediaQuery.of(context).size.width / 2.0) - 120,
            child: dietTableOverlayWidget()));
    overlayState.insert(overlayEntry);
    overlayEntryIsOn = true;
  }

  Widget overlayWidget(String text, int number) {
    TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle;
    return Card(
      elevation: 15.0,
      child: Column(
        children: <Widget>[
          SizedBox(
              width: 225,
              height: 75,
              child: Padding(
                  padding: EdgeInsets.all(7.0),
                  child: TextFormField(
                    style: subtitleStyle,
                    controller: textController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: '$text',
                        labelStyle: subtitleStyle,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                            borderRadius: BorderRadius.circular(5.0))),
                    onChanged: (value) {
                      //When Name Text has changed...
                    },
                  ))),
          Row(
            children: <Widget>[
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
                      _save(number);
                      overlayEntry.remove();
                      overlayEntryIsOn = false;
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
                      'Cancelar',
                      style: TextStyle(color: Colors.white),
                      //textScaleFactor: 1.5,
                    ),
                    onPressed: () {
                      //When the Cancelar button is pressed...
                      overlayEntry.remove();
                      overlayEntryIsOn = false;
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

  Widget fatOverlayWidget(int number) {
    TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle;
    return Card(
      elevation: 15.0,
      child: Column(
        children: <Widget>[
          SizedBox(
              width: 225,
              height: 386,
              child: Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
                          child: TextFormField(
                            style: subtitleStyle,
                            controller: fatTextController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: 'Abdominal',
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
                          padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
                          child: TextFormField(
                            style: subtitleStyle,
                            controller: fat2TextController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: 'Suprailíaco',
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
                          padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
                          child: TextFormField(
                            style: subtitleStyle,
                            controller: fat3TextController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: 'Anterior del muslo',
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
                          padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
                          child: TextFormField(
                            style: subtitleStyle,
                            controller: fat4TextController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: 'Tricipital',
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
                          padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
                          child: TextFormField(
                            style: subtitleStyle,
                            controller: fat5TextController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: 'Medial de la pierna',
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
                          padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
                          child: TextFormField(
                            style: subtitleStyle,
                            controller: fat6TextController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: 'Subescapular',
                                labelStyle: subtitleStyle,
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.redAccent),
                                    borderRadius: BorderRadius.circular(5.0))),
                            onChanged: (value) {
                              //When Name Text has changed...
                            },
                          )),
                    ],
                  ))),
          Row(
            children: <Widget>[
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
                      _save(number);
                      overlayEntry.remove();
                      overlayEntryIsOn = false;
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
                      'Cancelar',
                      style: TextStyle(color: Colors.white),
                      //textScaleFactor: 1.5,
                    ),
                    onPressed: () {
                      //When the Cancelar button is pressed...
                      overlayEntry.remove();
                      overlayEntryIsOn = false;
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

  Widget cooperTestOverlayWidget(int number) {
    TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle;
    return Card(
      elevation: 15.0,
      child: Column(
        children: <Widget>[
          SizedBox(
              width: 225,
              height: 310,
              child: Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
                          child: Text(
                              "Condición física basada en el 'Test de Cooper'",
                              style: TextStyle(fontSize: 18.0))),
                      Padding(
                          padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
                          child: Text(
                            "El 'Test de Cooper' consiste en determinar la condición física de una persona dependiendo de su sexo, su edad y la máxima distancia"
                            " que puede correr en 12 minutos.",
                            style: TextStyle(fontSize: 16.0),
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
                          child: Text('Sexo: ' + subscriber.gender,
                              style: subtitleStyle, textAlign: TextAlign.left)),
                      Padding(
                          padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
                          child: Text(
                              'Edad: ' +
                                  calculateAge(
                                          DateTime.parse(subscriber.birthdate))
                                      .toString(),
                              style: subtitleStyle,
                              textAlign: TextAlign.left)),
                      Padding(
                          padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
                          child: TextFormField(
                            style: subtitleStyle,
                            controller: distanceTextController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: 'Distancia recorrida en metro',
                                labelStyle: subtitleStyle,
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.redAccent),
                                    borderRadius: BorderRadius.circular(5.0))),
                            onChanged: (value) {
                              //When Name Text has changed...
                            },
                          )),
                    ],
                  ))),
          Row(
            children: <Widget>[
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
                      _save(number);
                      overlayEntry.remove();
                      overlayEntryIsOn = false;
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
                      'Cancelar',
                      style: TextStyle(color: Colors.white),
                      //textScaleFactor: 1.5,
                    ),
                    onPressed: () {
                      //When the Cancelar button is pressed...
                      overlayEntry.remove();
                      overlayEntryIsOn = false;
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

  Widget activityOverlayWidget(int number) {
    TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle;
    double radioWidth = 40.0;
    double radioHeight = 40.0;
    double radioTextWidth = 100.0;
    double radioTextHeight = 33.33;
    return Card(
      elevation: 15.0,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                  width: radioWidth,
                  height: radioHeight,
                  child: Radio(
                    value: 1.2,
                    groupValue: activityFactor,
                    onChanged: (value) {
                      activityFactor = value;
                      activityText = 'Sedentario';
                      subscriber.activityFactor = value;
                      overlayEntry.remove();
                      overlayEntryIsOn = false;
                      setState(() {});
                    },
                  )),
              SizedBox(
                width: radioTextWidth * 2.6,
                height: radioTextHeight / 2,
                child: Text('Sedentario',
                    style: subtitleStyle, textAlign: TextAlign.left),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              SizedBox(
                  width: radioWidth,
                  height: radioHeight,
                  child: Radio(
                    value: 1.375,
                    groupValue: activityFactor,
                    onChanged: (value) {
                      activityFactor = value;
                      activityText = 'Ligero';
                      subscriber.activityFactor = value;
                      overlayEntry.remove();
                      overlayEntryIsOn = false;
                      setState(() {});
                    },
                  )),
              SizedBox(
                width: radioTextWidth * 2.6,
                height: radioTextHeight / 2,
                child: Text('Ligero (de 1 a 3 veces a la semana)',
                    style: subtitleStyle, textAlign: TextAlign.left),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              SizedBox(
                  width: radioWidth,
                  height: radioHeight,
                  child: Radio(
                    value: 1.55,
                    groupValue: activityFactor,
                    onChanged: (value) {
                      activityFactor = value;
                      activityText = 'Moderado';
                      subscriber.activityFactor = value;
                      overlayEntry.remove();
                      overlayEntryIsOn = false;
                      setState(() {});
                    },
                  )),
              SizedBox(
                width: radioTextWidth * 2.6,
                height: radioTextHeight / 2,
                child: Text('Moderado (de 4 a 5 veces a la semana)',
                    style: subtitleStyle, textAlign: TextAlign.left),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              SizedBox(
                  width: radioWidth,
                  height: radioHeight,
                  child: Radio(
                    value: 1.65,
                    groupValue: activityFactor,
                    onChanged: (value) {
                      activityFactor = value;
                      activityText = 'Activo con pesas';
                      subscriber.activityFactor = value;
                      overlayEntry.remove();
                      overlayEntryIsOn = false;
                      setState(() {});
                    },
                  )),
              SizedBox(
                width: radioTextWidth * 2.6,
                height: radioTextHeight / 2,
                child: Text('Activo con pesas',
                    style: subtitleStyle, textAlign: TextAlign.left),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              SizedBox(
                  width: radioWidth,
                  height: radioHeight,
                  child: Radio(
                    value: 1.725,
                    groupValue: activityFactor,
                    onChanged: (value) {
                      activityFactor = value;
                      activityText = 'Muy activo con pesas';
                      subscriber.activityFactor = value;
                      overlayEntry.remove();
                      overlayEntryIsOn = false;
                      setState(() {});
                    },
                  )),
              SizedBox(
                width: radioTextWidth * 2.6,
                height: radioTextHeight / 2,
                child: Text('Muy activo con pesas',
                    style: subtitleStyle, textAlign: TextAlign.left),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              SizedBox(
                  width: radioWidth,
                  height: radioHeight,
                  child: Radio(
                    value: 1.9,
                    groupValue: activityFactor,
                    onChanged: (value) {
                      activityFactor = value;
                      activityText = 'Atleta';
                      subscriber.activityFactor = value;
                      overlayEntry.remove();
                      overlayEntryIsOn = false;
                      setState(() {});
                    },
                  )),
              SizedBox(
                width: radioTextWidth * 2.6,
                height: radioTextHeight / 2,
                child: Text('Atleta',
                    style: subtitleStyle, textAlign: TextAlign.left),
              ),
            ],
          ),
          Padding(
              padding: EdgeInsets.all(3.0),
              child: RaisedButton(
                elevation: 3.0,
                color: Theme.of(context).primaryColor,
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white),
                  //textScaleFactor: 1.5,
                ),
                onPressed: () {
                  //When the Cancelar button is pressed...
                  overlayEntry.remove();
                  overlayEntryIsOn = false;
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ))
        ],
      ),
    );
  }

  Widget dietTableOverlayWidget() {
    TextStyle titleStyle = Theme.of(context).textTheme.title;
    TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle;
    return Card(
        elevation: 15.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(3.0),
                child: Text(
                  'CUADRO DIETÉTICO',
                  style: titleStyle,
                  textAlign: TextAlign.center,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Text(
                          '',
                          style: titleStyle,
                        )),
                    Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Text(
                          'HC (carbohidrato)',
                          style: subtitleStyle,
                          textAlign: TextAlign.left,
                        )),
                    Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Text(
                          'PT (proteína)',
                          style: subtitleStyle,
                          textAlign: TextAlign.left,
                        )),
                    Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Text(
                          'LIP (grasa)',
                          style: subtitleStyle,
                          textAlign: TextAlign.left,
                        )),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Text(
                          'KCAL',
                          style: titleStyle,
                          textAlign: TextAlign.left,
                        )),
                    Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Text(
                          '${double.parse((hc).toStringAsFixed(2)).toString()}',
                          style: subtitleStyle,
                          textAlign: TextAlign.left,
                        )),
                    Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Text(
                          '${double.parse((pt).toStringAsFixed(2)).toString()}',
                          style: subtitleStyle,
                          textAlign: TextAlign.left,
                        )),
                    Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Text(
                          '${double.parse((lip).toStringAsFixed(2)).toString()}',
                          style: subtitleStyle,
                          textAlign: TextAlign.left,
                        )),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Text(
                          'GR',
                          style: titleStyle,
                          textAlign: TextAlign.left,
                        )),
                    Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Text(
                          '${double.parse((hc / 4).toStringAsFixed(2)).toString()}',
                          style: subtitleStyle,
                          textAlign: TextAlign.left,
                        )),
                    Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Text(
                          '${double.parse((pt / 4).toStringAsFixed(2)).toString()}',
                          style: subtitleStyle,
                          textAlign: TextAlign.left,
                        )),
                    Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Text(
                          '${double.parse((lip / 9).toStringAsFixed(2)).toString()}',
                          style: subtitleStyle,
                          textAlign: TextAlign.left,
                        )),
                  ],
                ),
              ],
            ),
            Padding(
                padding: EdgeInsets.all(3.0),
                child: RaisedButton(
                  elevation: 3.0,
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'Ocultar',
                    style: TextStyle(color: Colors.white),
                    //textScaleFactor: 1.5,
                  ),
                  onPressed: () {
                    //When the Cancelar button is pressed...
                    overlayEntry.remove();
                    overlayEntryIsOn = false;
                  },
                ))
          ],
        ));
  }

  Widget heightOverlayWidget(int number) {
    TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle;
    return Card(
      elevation: 15.0,
      child: Container(
          width: 240,
          height: 257,
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(
                    7.0,
                  ),
                  child: SizedBox(
                      width: 240,
                      height: 35,
                      child: Text(
                          'Nueva estatura. Ej.: 6 pies 1 pulgada (6´1´´)',
                          style: subtitleStyle,
                          textAlign: TextAlign.center))),
              Padding(
                  padding: EdgeInsets.all(7.0),
                  child: TextFormField(
                    style: subtitleStyle,
                    controller: footTextController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Pies',
                        labelStyle: subtitleStyle,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                            borderRadius: BorderRadius.circular(5.0))),
                    onChanged: (value) {
                      //When Name Text has changed...
                    },
                  )),
              Padding(
                  padding: EdgeInsets.all(7.0),
                  child: TextFormField(
                    style: subtitleStyle,
                    controller: inchesTextController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Pulgadas',
                        labelStyle: subtitleStyle,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                            borderRadius: BorderRadius.circular(5.0))),
                    onChanged: (value) {
                      //When Name Text has changed...
                    },
                  )),
              Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
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
                              //When the Registrar button is pressed..

                              if (int.tryParse(footTextController.text) ==
                                  null) {
                                overlayEntry.remove();
                                overlayEntryIsOn = false;
                                _showAlertDialog('Error',
                                    'Debe digitar una cantidad de pies');
                              } else {
                                if (inchesTextController.text == '')
                                  inchesTextController.text = '0';
                                if (int.tryParse(inchesTextController.text) !=
                                    null) {
                                  if (int.tryParse(inchesTextController.text) >=
                                          12 ||
                                      int.tryParse(inchesTextController.text) <
                                          0 ||
                                      int.tryParse(inchesTextController.text) ==
                                          null) {
                                    overlayEntry.remove();
                                    overlayEntryIsOn = false;
                                    _showAlertDialog('Error',
                                        'La cantidad de pulgadas debe ser mayor o igual que 0 y menor que 12');
                                  } else {
                                    if (int.tryParse(footTextController.text) <
                                            0 ||
                                        int.tryParse(footTextController.text) ==
                                            null) {
                                      overlayEntry.remove();
                                      overlayEntryIsOn = false;
                                      _showAlertDialog('Error',
                                          'La cantidad de pies debe ser un número positivo');
                                    } else {
                                      _save(number);
                                      overlayEntry.remove();
                                      overlayEntryIsOn = false;
                                    }
                                  }
                                } else {
                                  overlayEntry.remove();
                                  overlayEntryIsOn = false;
                                  _showAlertDialog('Error',
                                      'Debe digitar una cantidad de pulgadas');
                                }
                              }
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
                              'Cancelar',
                              style: TextStyle(color: Colors.white),
                              //textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              //When the Cancelar button is pressed...
                              overlayEntry.remove();
                              overlayEntryIsOn = false;
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                          ))
                    ],
                  )),
            ],
          )),
    );
  }

  void _save(number) async {
    switch (number) {
      case 1:
        {
          int f = int.parse(fatTextController.text);
          int f2 = int.parse(fat2TextController.text);
          int f3 = int.parse(fat3TextController.text);
          int f4 = int.parse(fat4TextController.text);
          int f5 = int.parse(fat5TextController.text);
          int f6 = int.parse(fat6TextController.text);
          if (subscriber.gender == 'M')
            subscriber.fatPercentage =
                ((f + f2 + f3 + f4 + f5 + f6) * 0.1051) + 2.585;
          else
            subscriber.fatPercentage =
                ((f + f2 + f3 + f4 + f5 + f6) * 0.1548) + 3.5803;
        }
        break;
      case 2:
        {
          if (double.tryParse(textController.text) == null) {
            _showAlertDialog('Error', 'Debe digitar un valor de peso correcto');
          } else {
            subscriber.weight = double.parse(textController.text).toDouble()*1.00000001;
            libras = ' libras';
            if (subscriber.height != null) {
              updateBodyMassIndex();
            }
          }
        }
        break;
      case 3:
        {
          int cmHeight = 0;
          double cmHeightd = 0;
          cmHeightd = int.parse(footTextController.text) * 30.48;
          cmHeightd += double.parse(inchesTextController.text) * 2.54;
          cmHeight = cmHeightd.round();
          subscriber.height = cmHeight;
          if (subscriber.weight != null) {
            updateBodyMassIndex();
          }
        }
        break;
      case 5:
        {
          subscriber.hydrationLevel = int.parse(textController.text);
        }
        break;
      case 6:
        {
          switch (subscriber.gender) {
            case 'M':
              {
                if (calculateAge(DateTime.parse(subscriber.birthdate)) < 30) {
                  if (int.parse(distanceTextController.text) < 1600)
                    subscriber.physicalCondition = 'Muy mala';
                  else {
                    if (int.parse(distanceTextController.text) < 2220)
                      subscriber.physicalCondition = 'Mala';
                    else {
                      if (int.parse(distanceTextController.text) < 2400)
                        subscriber.physicalCondition = 'Regular';
                      else {
                        if (int.parse(distanceTextController.text) <= 2800)
                          subscriber.physicalCondition = 'Buena';
                        else {
                          subscriber.physicalCondition = 'Excelente';
                        }
                      }
                    }
                  }
                } else {
                  if (calculateAge(DateTime.parse(subscriber.birthdate)) < 40) {
                    if (int.parse(distanceTextController.text) < 1500)
                      subscriber.physicalCondition = 'Muy mala';
                    else {
                      if (int.parse(distanceTextController.text) < 1900)
                        subscriber.physicalCondition = 'Mala';
                      else {
                        if (int.parse(distanceTextController.text) < 2230)
                          subscriber.physicalCondition = 'Regular';
                        else {
                          if (int.parse(distanceTextController.text) <= 2700)
                            subscriber.physicalCondition = 'Buena';
                          else {
                            subscriber.physicalCondition = 'Excelente';
                          }
                        }
                      }
                    }
                  } else {
                    if (calculateAge(DateTime.parse(subscriber.birthdate)) <
                        50) {
                      if (int.parse(distanceTextController.text) < 1400)
                        subscriber.physicalCondition = 'Muy mala';
                      else {
                        if (int.parse(distanceTextController.text) < 1700)
                          subscriber.physicalCondition = 'Mala';
                        else {
                          if (int.parse(distanceTextController.text) < 2100)
                            subscriber.physicalCondition = 'Regular';
                          else {
                            if (int.parse(distanceTextController.text) <= 2500)
                              subscriber.physicalCondition = 'Buena';
                            else {
                              subscriber.physicalCondition = 'Excelente';
                            }
                          }
                        }
                      }
                    } else {
                      if (int.parse(distanceTextController.text) < 1300)
                        subscriber.physicalCondition = 'Muy mala';
                      else {
                        if (int.parse(distanceTextController.text) < 1600)
                          subscriber.physicalCondition = 'Mala';
                        else {
                          if (int.parse(distanceTextController.text) < 2000)
                            subscriber.physicalCondition = 'Regular';
                          else {
                            if (int.parse(distanceTextController.text) <= 2400)
                              subscriber.physicalCondition = 'Buena';
                            else {
                              subscriber.physicalCondition = 'Excelente';
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
              break;
            case 'F':
              {
                if (calculateAge(DateTime.parse(subscriber.birthdate)) < 30) {
                  if (int.parse(distanceTextController.text) < 1500)
                    subscriber.physicalCondition = 'Muy mala';
                  else {
                    if (int.parse(distanceTextController.text) < 1800)
                      subscriber.physicalCondition = 'Mala';
                    else {
                      if (int.parse(distanceTextController.text) < 2200)
                        subscriber.physicalCondition = 'Regular';
                      else {
                        if (int.parse(distanceTextController.text) <= 2700)
                          subscriber.physicalCondition = 'Buena';
                        else {
                          subscriber.physicalCondition = 'Excelente';
                        }
                      }
                    }
                  }
                } else {
                  if (calculateAge(DateTime.parse(subscriber.birthdate)) < 40) {
                    if (int.parse(distanceTextController.text) < 1400)
                      subscriber.physicalCondition = 'Muy mala';
                    else {
                      if (int.parse(distanceTextController.text) < 1700)
                        subscriber.physicalCondition = 'Mala';
                      else {
                        if (int.parse(distanceTextController.text) < 2000)
                          subscriber.physicalCondition = 'Regular';
                        else {
                          if (int.parse(distanceTextController.text) <= 2500)
                            subscriber.physicalCondition = 'Buena';
                          else {
                            subscriber.physicalCondition = 'Excelente';
                          }
                        }
                      }
                    }
                  } else {
                    if (calculateAge(DateTime.parse(subscriber.birthdate)) <
                        50) {
                      if (int.parse(distanceTextController.text) < 1200)
                        subscriber.physicalCondition = 'Muy mala';
                      else {
                        if (int.parse(distanceTextController.text) < 1500)
                          subscriber.physicalCondition = 'Mala';
                        else {
                          if (int.parse(distanceTextController.text) < 1900)
                            subscriber.physicalCondition = 'Regular';
                          else {
                            if (int.parse(distanceTextController.text) <= 2300)
                              subscriber.physicalCondition = 'Buena';
                            else {
                              subscriber.physicalCondition = 'Excelente';
                            }
                          }
                        }
                      }
                    } else {
                      if (int.parse(distanceTextController.text) < 1100)
                        subscriber.physicalCondition = 'Muy mala';
                      else {
                        if (int.parse(distanceTextController.text) < 1400)
                          subscriber.physicalCondition = 'Mala';
                        else {
                          if (int.parse(distanceTextController.text) < 1700)
                            subscriber.physicalCondition = 'Regular';
                          else {
                            if (int.parse(distanceTextController.text) <= 2200)
                              subscriber.physicalCondition = 'Buena';
                            else {
                              subscriber.physicalCondition = 'Excelente';
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
              break;
          }
        }
        break;
      case 7:
        {
          subscriber.activityFactor = activityFactor;
        }
    }
    await databaseHelper.updateSubscriber(subscriber);
    _getSubscriberEvaluation();
  }

  void _getSubscriberEvaluation() {
    setState(() {
      if (subscriber.fatPercentage != null) {
        fatPercentage =
            double.parse((subscriber.fatPercentage).toStringAsFixed(2))
                .toString();
      }

      if (subscriber.physicalCondition != null) {
        physicalCondition = subscriber.physicalCondition;
      }
      if (subscriber.weight != null) {
        weight = subscriber.weight.toStringAsFixed(2);
      }
      if (subscriber.height != null) {
        int cm;
        int feet;
        int inches;
        cm = subscriber.height;
        feet = (cm ~/ 30.48);
        inches = ((cm - feet * 30.48) / 2.54).round();
        if (inches == 12) {
          inches = 0;
          feet++;
        }
        height = '$feet' + '´' + '$inches' + '´´';
      }
      if (subscriber.weight != null && subscriber.height != null) {
        updateBodyMassIndex();
      }
      if (subscriber.hydrationLevel != null) {
        hydrationLevel = subscriber.hydrationLevel.toString();
      }
    });
  }

  void updateBodyMassIndex() {
    double kg;
    double m;
    kg = subscriber.weight / 2.205;
    m = subscriber.height / 100;
    double bmi = kg / (m * m);
    String conclussion;
    if (bmi < 18.5) {
      conclussion = 'Peso bajo';
    } else if (bmi >= 18.5 && bmi < 25)
      conclussion = 'Peso normal';
    else if (bmi >= 25 && bmi < 30)
      conclussion = 'Peso alto';
    else
      conclussion = 'Peso obeso';
    bodyMassIndex = '${bmi.toStringAsFixed(2)} (' + conclussion + ')';
    subscriber.bodyMassIndex = bmi;
  }

  void moveToLastScreen() {
    if (overlayEntryIsOn) {
      overlayEntry.remove();
    }
    Navigator.pop(context,true);
  }

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  void calculateCalories() {
    double mb;
    double mbFactor;
    double totalCaloricValue;

    if (subscriber.gender == 'M')
      mbFactor = 1;
    else
      mbFactor = 0.95;

    mb = (subscriber.weight / 2.205) * mbFactor * 24;
    totalCaloricValue =
        mb * subscriber.activityFactor; // Incremented 10% for mass gain

    hc = totalCaloricValue * 0.6;
    pt = totalCaloricValue * 0.2;
    lip = totalCaloricValue * 0.2;
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
