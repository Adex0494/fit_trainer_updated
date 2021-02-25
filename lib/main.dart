import 'package:fit_trainer_updated/screens/add_trainer_page.dart';
import 'package:fit_trainer_updated/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'models/trainer_credentials.dart';
import 'screens/trainer_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: 'Fit Trainer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        textTheme: TextTheme(
            title: TextStyle(color: Colors.blue),
            subtitle: TextStyle(color: Colors.blueAccent)),
        hintColor: Colors.white,
        canvasColor: Colors.white,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordControler = TextEditingController();


  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = Theme.of(context).textTheme.title;
    TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle;
    return Scaffold(
      appBar: AppBar(title: Text('Inicio')),
      backgroundColor: Colors.white,
      body: scaffoldBody(subtitleStyle, titleStyle),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToAddTrainer();
        },
        tooltip: 'Añadir nuevo Entrenador',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget scaffoldBody(TextStyle subtitleStyle, TextStyle titleTextStyle) {
    return Container(
      alignment: Alignment.center,
      child: Form(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    style: subtitleStyle,
                    controller: usernameController,
                    decoration: InputDecoration(
                        labelText: 'Nombre de Usuario',
                        labelStyle: subtitleStyle,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent),
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                    onChanged: (value) {
                      //when Usuario text changes...
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 3, bottom: 3),
                    child: TextFormField(
                      style: subtitleStyle,
                      controller: passwordControler,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'Contraseña',
                          labelStyle: subtitleStyle,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                      onChanged: (value) {
                        //when Usuario text changes...
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 3, bottom: 3),
                    child: Row(
                      children: <Widget>[
                        RaisedButton(
                          elevation: 3.0,
                          color: Theme.of(context).primaryColor,
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
                        )
                      ],
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

  void navigateToPrincipalPage(int trainerId) async{
   bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TrainerPage(trainerId);
    }));
    if (result) {
      _blankCredentials();
    }
  }

  void navigateToAddTrainer() async{
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

 void _blankCredentials(){
   usernameController.text='';
   passwordControler.text='';
 }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
