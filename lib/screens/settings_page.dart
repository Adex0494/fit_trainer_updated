import 'package:fit_trainer_updated/screens/question_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text('Configuración'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                moveToLastScreen();
              },
            )),
        backgroundColor: Colors.white,
        body: scaffoldBody(),
      ),
    );
  }

  Widget scaffoldBody() {
    TextStyle titleStyle = Theme.of(context).textTheme.title;
    return Center(
        //heightFactor:2.0 ,
        //widthFactor: 2.0,
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Cuestionario del Suscriptor',
          style: titleStyle,
        ),
        SizedBox(
            width: 260,
            height: 250,
            child: FlatButton(
                //icon: Icon(Icons.question_answer),
                onPressed: () {
                  navigateToQuestionArea();
                },
                child: Image.asset('images/cuestionario.jpg')
                //tooltip: 'Configurar cuestionario del Suscriptor',
                ))
      ],
    ));
  }

  void navigateToQuestionArea() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return QuestionArea(true);
    }));
  }

  void moveToLastScreen() {
    Navigator.pop(context);
  }
}
