import 'package:fit_trainer_updated/models/answer.dart';
import 'package:fit_trainer_updated/models/multipleSelection.dart';
import 'package:fit_trainer_updated/models/question.dart';
import 'package:fit_trainer_updated/utils/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnswersPage extends StatefulWidget {
  final int subscriberId;
  final String appBarText;
  final String area;
  AnswersPage(this.appBarText, this.area, this.subscriberId);
  @override
  State<StatefulWidget> createState() {
    return AnswersPageState(this.appBarText, this.area, this.subscriberId);
  }
}

class AnswersPageState extends State<AnswersPage> {
  String appBarText;
  String area;
  int subscriberId;
  AnswersPageState(this.appBarText, this.area, this.subscriberId);
  List<Question> questionList = List<Question>();
  DatabaseHelper databaseHelper = DatabaseHelper();
  int ynCount = 0;
  int msCount = 0;
  int oaCount = 0;
  //List<String> ynAnswers=List<String>();
  //List<String> msAnswers=List<String>();
  //List<String> oaAnswers=List<String>();
  List<String> answersList = List<String>();
  List<TextEditingController> oaControllers = List<TextEditingController>();
  List<int> msControlList = List<
      int>(); // Each int represents the quantity of possible selections of a question. If the question is not a MS, the int is 0.
  List<String> msList = List<
      String>(); //Each possible selection of each MS question, all together

  @override
  initState() {
    super.initState();
    _loadQuestions();
  }

  @override
  Widget build(BuildContext context) {
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
                moveToLastScreen();
              },
            )),
        backgroundColor: Colors.white,
        body: scaffoldBody(),
      ),
    );
  }

  Widget scaffoldBody() {
    ynCount = 0;
    msCount = 0;
    oaCount = 0;
    return Container(
        child: Scrollbar(
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.all(15.0), child: questionListview()),
                    Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Container(
                          width: 120,
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
                              _saveAnswers();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                        ))
                  ],
                )
              ],
    )));
  }

  void _loadQuestions() async {
    List<Question> auxListQuestion = await databaseHelper.getQuestionList(area);
    for (int q = 0; q < auxListQuestion.length; q++) {
      List<Answer> foundAnswer = await databaseHelper.getAnAnswerByQuestionId(
          subscriberId, auxListQuestion[q].id);
      if (foundAnswer.length > 0) {
        answersList.add(foundAnswer[0].answer);
      } else
        answersList.add('');

      switch (auxListQuestion[q].type) {
        case 'YN':
          //ynAnswers.add('');
          msControlList.add(0);
          break;
        case 'MS':
          //msAnswers.add('');
          List<MultipleSelection> msAuxList = await databaseHelper
              .getMultipleSelectionList(auxListQuestion[q].id);
          for (int m = 0; m < msAuxList.length; m++) {
            msList.add(msAuxList[m].possibleSelection);
          }
          msControlList.add(msAuxList.length);
          break;
        case 'OA':
          //oaAnswers.add('');
          msControlList.add(0);
          TextEditingController auxController = TextEditingController();
          auxController.text = answersList[q];
          oaControllers.add(auxController);
          break;
      }
    }
    setState(() {
      this.questionList = auxListQuestion;
      this.msCount = 0;
    });
  }

  Widget questionListview() {
    TextStyle titleStyle = Theme.of(context).textTheme.title;
    //TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle;
    Widget widget = Padding(
      padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
      child: Container(
        child: ListView.builder(
            itemCount: questionList.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int position) {
              return Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.all(3.0),
                                  child: Container(
                                    child: Text('${position + 1}. ',
                                        style: titleStyle),
                                  )),
                              Container(
                                width: 275.0,
                                child: Text(
                                  questionList[position].question,
                                  style: titleStyle,
                                ),
                              ),
                            ],
                          )),
                      Padding(
                        padding: EdgeInsets.all(3.0),
                        child: answerWidget(position),
                      ),
                    ],
                  ));
            }),
      ),
    );
    return widget;
  }

  Widget answerWidget(int questionIndex) {
    Widget widget;
    switch (questionList[questionIndex].type) {
      case 'YN':
        widget = ynRadioButtons(questionIndex);
        break;
      case 'MS':
        widget = msListview(questionIndex);
        break;
      case 'OA':
        widget = oaInput(questionIndex, oaCount);
        break;
    }
    return widget;
  }

  Widget ynRadioButtons(int questionIndex) {
    ynCount++;
    double radioTextWidth = 100.0;
    double radioTextHeight = 33.33;
    double radioWidth = 40.0;
    double radioHeight = 40.0;
    TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle;
    return Row(
      children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(
              width: radioTextWidth,
              height: radioTextHeight / 2,
              child:
                  Text('Sí', style: subtitleStyle, textAlign: TextAlign.center),
            ),
            SizedBox(
                width: radioWidth,
                height: radioHeight,
                child: Radio(
                  value: 'Sí',
                  groupValue: answersList[questionIndex],
                  onChanged: (String value) {
                    setState(() {
                      answersList[questionIndex] = value;
                    });
                  },
                ))
          ],
        ),
        Column(
          children: <Widget>[
            SizedBox(
              width: radioTextWidth,
              height: radioTextHeight / 2,
              child:
                  Text('No', style: subtitleStyle, textAlign: TextAlign.center),
            ),
            SizedBox(
                width: radioWidth,
                height: radioHeight,
                child: Radio(
                  value: 'No',
                  groupValue: answersList[questionIndex],
                  onChanged: (String value) {
                    answersList[questionIndex] = value;
                    setState(() {});
                  },
                ))
          ],
        )
      ],
    );
  }

  Widget msListview(int questionIndex) {
    msCount++;
    // double radioTextWidth = 100.0;
    // double radioTextHeight = 33.33;
    double radioWidth = 40.0;
    double radioHeight = 40.0;
    //TextStyle titleStyle = Theme.of(context).textTheme.title;
    TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle;
    int preIndex = findAllPossibleSelectionPreIndex(questionIndex);
    Widget widget = Padding(
      padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
      child: Container(
        child: ListView.builder(
            itemCount: msControlList[questionIndex],
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int position) {
              return Row(
                children: <Widget>[
                  SizedBox(
                      width: radioWidth,
                      height: radioHeight,
                      child: Radio(
                        value: msList[preIndex + position],
                        groupValue: answersList[questionIndex],
                        onChanged: (String value) {
                          answersList[questionIndex] = value;
                          setState(() {});
                        },
                      )),
                  //SizedBox(
                  //width: radioTextWidth/2,
                  //height: radioTextHeight/2,
                  //child:
                  Text(msList[preIndex + position],
                      style: subtitleStyle, textAlign: TextAlign.start),
                  //)
                ],
              );
            }),
      ),
    );
    return widget;
  }

  Widget oaInput(int questionIndex, int controllerPosition) {
    oaCount++;
    TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle;
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: TextFormField(
        controller: oaControllers[controllerPosition],
        style: subtitleStyle,
        decoration: InputDecoration(
          labelText: 'Digite respuesta',
          labelStyle: subtitleStyle,
        ),
        onChanged: (value) {
          //When Name Text has changed...
          answersList[questionIndex] = oaControllers[controllerPosition].text;
        },
      ),
    );
  }

  int findAllPossibleSelectionPreIndex(int questionIndex) {
    int count = 0;
    for (int i = 0; i < questionIndex; i++) {
      count += msControlList[i];
    }
    return count;
  }

  void _saveAnswers() async {
    int result = 1;
    int auxResult;
    for (int q = 0; q < questionList.length; q++) {
      List<Answer> foundAnswer = await databaseHelper.getAnAnswerByQuestionId(
          subscriberId, questionList[q].id);
      if (foundAnswer.length > 0) {
        Answer answer = foundAnswer[0];
        answer.answer = answersList[q];
        auxResult = await databaseHelper.updateAnswer(answer);
        if (auxResult == 0) result = 0;
      } else {
        Answer answer =
            Answer(questionList[q].id, subscriberId, answersList[q], area);
        auxResult = await databaseHelper.insertAnswer(answer);
        if (auxResult == 0) result = 0;
      }
    }
    if (result == 0) {
      _showAlertDialog('Error', 'Ocurrió un error al tratar de Registrar');
    } else {
      moveToLastScreen();
      _showAlertDialog('Éxito', 'Registro exitoso');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void moveToLastScreen() {
    Navigator.pop(context);
  }
}
