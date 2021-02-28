import 'package:fit_trainer_updated/screens/add_trainer_page.dart';
import 'package:fit_trainer_updated/utils/database_helper.dart';
import 'package:flutter/material.dart';
import '../models/trainer_credentials.dart';
import '../screens/trainer_page.dart';
import '../widgets/logo.dart';
import '../widgets/textFormFieldPersonalized.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TextStyle titleStyle = Theme.of(context).textTheme.headline6;
    // TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle2;
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
        //backgroundColor: Color.fromRGBO(255, 0, 0, 1),
      ),
      body: scaffoldBody(),
    );
  }

  Widget scaffoldBody() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(child: Logo()),
              Form(
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormFieldPersonalized(
                          controller: usernameController,
                          theLabelText: 'Nombre de Usuario',
                          bottomPadding: 8.0,
                          isTextObscure: false),
                      TextFormFieldPersonalized(
                          controller: passwordControler,
                          theLabelText: 'Contraseña',
                          bottomPadding: 0,
                          isTextObscure: true),
                      FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed: null,
                          child: Text(
                            'Olvidé la contraseña',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Color.fromRGBO(127, 33, 33, 1)),
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: 3, bottom: 3),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            RaisedButton(
                              elevation: 3.0,
                              //color: Color.fromRGBO(242, 36, 36, 1),
                              child: Text(
                                'Iniciar Sesión',
                                style: TextStyle(color: Colors.white),
                                //textScaleFactor: 1.5,
                              ),
                              onPressed: () {
                                //When the Iniciar Sesión button is pressed...
                                _validateThenNavigate();
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                            InkWell(
                              onTap: navigateToAddTrainer,
                              child: Container(
                                padding:
                                    EdgeInsets.only(bottom: 7, left: 30),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    'Registrarse',
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(127, 33, 33, 1),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToPrincipalPage(int trainerId) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TrainerPage(trainerId);
    }));
    if (result) {
      _blankCredentials();
    }
  }

  void navigateToAddTrainer() async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddTrainerPage();
    }));
    if (result) {
      _blankCredentials();
    }
  }

  void _validateThenNavigate() async {
    TrainerCredentials trainerCredentials =
        await databaseHelper.getTrainerCredentials(usernameController.text);
    if (trainerCredentials != null) {
      if (passwordControler.text == trainerCredentials.password) {
        navigateToPrincipalPage(trainerCredentials.trainerId);
      } else {
        _showAlertDialog('Contraseña', 'La Contraseña es incorrecta.');
      }
    } else {
      _showAlertDialog('Nombre de Usuario', 'El Nombre de Usuario no existe.');
    }
  }

  void _blankCredentials() {
    usernameController.text = '';
    passwordControler.text = '';
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
