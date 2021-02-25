import 'package:flutter/material.dart';
import 'answers_page.dart';
import 'area_questionnaire.dart';

class QuestionArea extends StatefulWidget {
  final bool
      ask; //if true, go to edit questionnaire. If not, go to answer questionnaire
  final int subscriberId;
  QuestionArea(this.ask, [this.subscriberId]);
  @override
  State<StatefulWidget> createState() {
    return QuestionAreaState(this.ask, this.subscriberId);
  }
}

class QuestionAreaState extends State<QuestionArea> {
  bool ask;
  int subscriberId;
  QuestionAreaState(this.ask, [this.subscriberId]);
  String appBarText;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text('Seleccionar Área'),
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

        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Text(
              'Salud',
              style: titleStyle,
            ),
            Padding(
              padding: EdgeInsets.all(3.0),
              child: Container(
                  //width: ,
                  height: 200,
                  child: FlatButton(
                      //icon: Icon(Icons.favorite),
                      onPressed: () {
                        if (ask)
                          navigateToHealthQuestionnaire();
                        else {
                          navigateToAnswersPage('H');
                          appBarText = 'Cuestionario de Salud';
                        }
                      },
                      child: Image.asset('images/corazon.png')
                      //tooltip: 'Cuestionario de Salud',
                      )),
            )
          ],
        )),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Hábitos',
              style: titleStyle,
            ),
            Padding(
              padding: EdgeInsets.all(3.0),
              child: Container(
                  //width: 250,
                  height: 200,
                  child: FlatButton(
                      //icon: Icon(Icons.schedule),
                      onPressed: () {
                        if (ask)
                          navigateToHabitsQuestionnaire();
                        else {
                          navigateToAnswersPage('HB');
                          appBarText = 'Cuestionario de Hábitos';
                        }
                      },
                      child: Image.asset('images/habits.jpg')
                      //tooltip: 'Cuestionario de Hábitos',
                      )),
            )
          ],
        ))
      ],
    ));
  }

  void navigateToHealthQuestionnaire() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AreaQuestionnaire('Cuestionario de Salud', true);
    }));
  }

  void navigateToHabitsQuestionnaire() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AreaQuestionnaire('Cuestionario de Hábitos', false);
    }));
  }

  void navigateToAnswersPage(String area) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AnswersPage(appBarText, area, subscriberId);
    }));
  }

  void moveToLastScreen() {
    Navigator.pop(context);
  }
}
