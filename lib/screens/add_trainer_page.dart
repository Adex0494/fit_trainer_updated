import 'package:fit_trainer_updated/models/trainer_credentials.dart';
import 'package:fit_trainer_updated/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fit_trainer_updated/models/trainer.dart';

class AddTrainerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddTrainerPageState();
  }
}

class AddTrainerPageState extends State<AddTrainerPage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordController1 = TextEditingController();
  var _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text('Añadir nuevo Entrenador'),
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
                            return 'Introduzca el Nombre del Entrenador';
                          }
                        },
                        decoration: InputDecoration(
                            labelText: 'Nombre',
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
                      child: TextFormField(
                        style: subtitleStyle,
                        controller: usernameController,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Introduzca el Nombre de Usuario del Entrenador';
                          }
                        },
                        decoration: InputDecoration(
                            labelText: 'Nombre de Usuario',
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
                      child: TextFormField(
                        style: subtitleStyle,
                        controller: passwordController,
                        obscureText: true,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Introduzca la Contraseña';
                          } else {
                            if(value !=passwordController1.text)
                            {
                              return 'Las Contraseñas no coinciden';
                            }
                            else
                            if (value.length < 6) {
                              return 'La Contraseña debe tener más de 5 caracteres';
                            }
                          }
                        },
                        decoration: InputDecoration(
                            labelText: 'Contraseña',
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
                      child: TextFormField(
                        style: subtitleStyle,
                        controller: passwordController1,
                        obscureText: true,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Introduzca la Contraseña';
                          } else {
                            if(value !=passwordController.text)
                            {
                              return 'Las Contraseñas no coinciden';
                            }
                            else
                            if (value.length < 6) {
                              return 'La Contraseña debe tener más de 5 caracteres';
                            }
                          }
                        },
                        decoration: InputDecoration(
                            labelText: 'Repita Contraseña',
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
                    child: RaisedButton(
                      elevation: 3.0,
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Registrar Entrenador',
                        style: TextStyle(color: Colors.white),
                        //textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        //When the Registrar button is pressed...
                        if (_formkey.currentState.validate())
                          _validateThenSave();
                        // setState(() {
                        //   debugPrint('Registrar button Pressed');
                        //   Trainer trainer = Trainer(nameController.text,0);
                        //   debugPrint('trainer created');
                        //   _saveTrainer(trainer);
                        // });
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

  void moveToLastScreen() {
    debugPrint('Moving to last Screen');
    Navigator.pop(context,true);
  }

  void _validateThenSave() async {
    TrainerCredentials trainerCredentials =
        await databaseHelper.getTrainerCredentials(usernameController.text);
    if (trainerCredentials != null) {
      _showAlertDialog('Nombre de Usuario',
          'El Nombre de Usuario ya existe. Intente con otro.');
    } else {
      _saveTrainer();
    }
  }

  Future<void> _saveTrainer() async {
    //moveToLastScreen();
    Trainer trainer = Trainer(nameController.text, 0);
    int result;
    result = await databaseHelper.insertTrainer(trainer);
    if (result == 0) {
      _showAlertDialog('Error', 'Ocurrió un error al tratar de Registrar');
    } else {
      int trainerId = await databaseHelper.getTrainerMaxId();
      TrainerCredentials trainerCredentials = TrainerCredentials(
          trainerId, usernameController.text, passwordController.text);
      result =
          await databaseHelper.insertTrainerCredentials(trainerCredentials);
      if (result == 0) {
        _showAlertDialog('Error', 'Ocurrió un error al tratar de Registrar');
      } else {
        moveToLastScreen();
        _showAlertDialog('Éxito', 'Registro exitoso');
        // setState(() {
        //   nameController.text = '';
        //   usernameController.text='';
        //   passwordController.text='';
        //   passwordController1.text=''
        // });
      }
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
