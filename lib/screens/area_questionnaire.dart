import 'package:fit_trainer_updated/models/multipleSelection.dart';
import 'package:fit_trainer_updated/models/question.dart';
import 'package:fit_trainer_updated/utils/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AreaQuestionnaire extends StatefulWidget {
  final String appBarText;
  final bool isHealth;
  AreaQuestionnaire(this.appBarText, this.isHealth);
  @override
  State<StatefulWidget> createState() {
    return AreaQuestionnaireState(this.appBarText, this.isHealth);
  }
}

class AreaQuestionnaireState extends State<AreaQuestionnaire> {
  String appBarText;
  bool isHealth;
  AreaQuestionnaireState(this.appBarText, this.isHealth);
  List<String> questionTypeList = ['YN'];
  List<String> questionTextList = ['Pregunta cerrada'];
  List<int> multipleSelectionControlList = [
    0
  ]; // Each int represents the quantity of possible selections of a question. If the question is not a MS, the int is 0.
  List<TextEditingController> allPossibleSelectionControllerList = List<
      TextEditingController>(); //Each possible selection of each MS question, all together
  int possibleSelectionCount = 1; //The count of all possibleSelections.
  int possibleSelectionPrintedCount =
      0; // //The count of all possibleSelections that have been printed
  List<TextEditingController> questionControllerList =
      List<TextEditingController>(); //The controller List of the questions
  //List<Widget> questionWidgetList = List<Widget>();
  int questionCount = 1;
  List<Question> questionList = List<Question>();
  DatabaseHelper databaseHelper = DatabaseHelper();
  var _formkey = GlobalKey<FormState>();
  String area;

  @override
  initState() {
    super.initState();
    _loadVariables();
  }

  @override
  Widget build(BuildContext context) {
    //refreshQuestionWidgetList();
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
    return Container(
        alignment: Alignment.center,
        child: Form(
            key: _formkey,
            child: Scrollbar(
              child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(15.0),
                        child: questionListview()),
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
                              _saveQuestionnaire();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                        ))
                  ],
                )
              ],
            ))));
  }

  Widget questionListview() {
    refreshQuestionWidgetList();
    possibleSelectionPrintedCount = 0;
    Widget widget = Padding(
      padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
      child: Container(
        //child: Scrollbar(
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: questionCount,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int position) {
              return question(position);
            }),
      ),
    );
    return widget;
  }

  Widget question(int questionListPosition) {
    double radioTextWidth = 100.0;
    double radioTextHeight = 33.33;
    double radioWidth = 40.0;
    double radioHeight = 40.0;
    TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle;
    Widget questionWidget = Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Column(
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text(
                '${questionListPosition + 1}',
                style: Theme.of(context).textTheme.title,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 3.0, top: 3.0, right: 3.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: radioTextWidth,
                        height: radioTextHeight,
                        child: Text('Sí-No',
                            style: subtitleStyle, textAlign: TextAlign.center),
                      ),
                      SizedBox(
                          width: radioWidth,
                          height: radioHeight,
                          child: Radio(
                            value: 'YN',
                            groupValue: questionTypeList[questionListPosition],
                            onChanged: (String value) {
                              questionTextList[questionListPosition] =
                                  'Pregunta cerrada';
                              questionTypeList[questionListPosition] = value;
                              if (multipleSelectionControlList[
                                      questionListPosition] !=
                                  0)
                                removeCorrespondingControllers(
                                    questionListPosition);
                              multipleSelectionControlList[
                                  questionListPosition] = 0;
                              setState(() {});
                            },
                          ))
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.only(left: 3.0, top: 3.0, right: 3.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: radioTextWidth,
                        height: radioTextHeight,
                        child: Text('Selección Múltiple',
                            style: subtitleStyle, textAlign: TextAlign.center),
                      ),
                      SizedBox(
                          width: radioWidth,
                          height: radioHeight,
                          child: Radio(
                            value: 'MS',
                            groupValue: questionTypeList[questionListPosition],
                            onChanged: (String value) {
                              questionTextList[questionListPosition] =
                                  'Pregunta de Selección Múltiple';
                              questionTypeList[questionListPosition] = value;

                              multipleSelectionControlList[
                                  questionListPosition] = 1;
                              int count = 0;
                              for (int i = 0; i <= questionListPosition; i++) {
                                count += multipleSelectionControlList[i];
                              }
                              if (count < possibleSelectionCount) {
                                TextEditingController auxController =
                                    TextEditingController();
                                allPossibleSelectionControllerList.insert(
                                    count - 1, auxController);
                              }
                              setState(() {});
                            },
                          ))
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.only(left: 3.0, top: 3.0, right: 3.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: radioTextWidth,
                        height: radioTextHeight,
                        child: Text('Respuesta Abierta',
                            style: subtitleStyle, textAlign: TextAlign.center),
                      ),
                      SizedBox(
                          width: radioWidth,
                          height: radioHeight,
                          child: Radio(
                            value: 'OA',
                            groupValue: questionTypeList[questionListPosition],
                            onChanged: (String value) {
                              questionTextList[questionListPosition] =
                                  'Pregunta abierta';
                              questionTypeList[questionListPosition] = value;
                              if (multipleSelectionControlList[
                                      questionListPosition] !=
                                  0)
                                removeCorrespondingControllers(
                                    questionListPosition);
                              multipleSelectionControlList[
                                  questionListPosition] = 0;
                              setState(() {});
                            },
                          )),
                    ],
                  )),
            ]),
            Row(children: <Widget>[
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.all(3.0),
                      child: TextFormField(
                        style: subtitleStyle,
                        controller:
                            questionControllerList[questionListPosition],
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Digite la Pregunta';
                          } else {
                            if (!verifyQuestionUniqueness(
                                questionListPosition)) {
                              return 'Existe otra pregunta igual';
                            }
                          }
                        },
                        decoration: InputDecoration(
                            labelText: questionTextList[questionListPosition],
                            labelStyle: subtitleStyle,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.redAccent),
                                borderRadius: BorderRadius.circular(5.0))),
                        onChanged: (value) {
                          //When Name Text has changed...
                        },
                      ))),
              Padding(
                  padding: EdgeInsets.all(0.0),
                  child: IconButton(
                    icon:
                        Icon(Icons.add, color: Theme.of(context).primaryColor),
                    onPressed: () {
                      addNewQuestion(questionListPosition);
                    },
                    alignment: Alignment.centerRight,
                    tooltip: 'Añadir otra Pregunta',
                  )),
              Padding(
                  padding: EdgeInsets.all(0.0),
                  child: IconButton(
                    icon: Icon(Icons.delete,
                        color: Theme.of(context).primaryColor),
                    onPressed: () {
                      if (questionCount > 1) {
                        deleteQuestion(questionListPosition);
                      } else
                        questionControllerList[0].text = '';
                    },
                    alignment: Alignment.centerRight,
                    tooltip: 'Eliminar Pregunta',
                  ))
            ]),
            Padding(
                padding: EdgeInsets.all(0.0),
                child: possibleSelectionListview(
                    multipleSelectionControlList[questionListPosition],
                    questionListPosition)),
            Row(children: <Widget>[
              Expanded(
                  child: Container(
                height: 1.0,
                color: Theme.of(context).primaryColorDark,
              ))
            ])
          ],
        ));
    return questionWidget;
  }

  Widget possibleSelectionListview(
      int possibleSelectionQuantity, int questionListPosition) {
    // int auxQuantity = 0;
    // if (questionTypeList[questionListPosition] == 'MS')
    //   auxQuantity = possibleSelectionQuantity;
    Widget widget = Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0),
        child: Container(
          //width: 150,
          //height: 450,
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: possibleSelectionQuantity,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int position) {
                //return contactListWidgets[position]
                return possibleSelectionWidget(
                    questionListPosition, possibleSelectionQuantity, position);
              }),
        ));
    return widget;
  }

  Widget possibleSelectionWidget(
      int questionListPosition, int possibleSelectionQuantity, int position) {
    possibleSelectionPrintedCount++;
    if (allPossibleSelectionControllerList.length < possibleSelectionCount) {
      TextEditingController newController = TextEditingController();
      allPossibleSelectionControllerList.add(newController);
    }
    TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle;
    return Padding(
        padding: EdgeInsets.all(3.0),
        child: Row(children: <Widget>[
          Expanded(
              child: TextFormField(
            style: subtitleStyle,
            controller: allPossibleSelectionControllerList[
                possibleSelectionPrintedCount - 1],
            validator: (String value) {
              if (value.isEmpty) {
                return 'Digite una posible respuesta';
              }
            },
            decoration: InputDecoration(
              labelText: 'Posible respuesta',
              labelStyle: subtitleStyle,
            ),
            onChanged: (value) {
              //When Name Text has changed...
              setState(() {});
            },
          )),
          Padding(
              padding: EdgeInsets.all(0.0),
              child: IconButton(
                icon: Icon(Icons.add, color: Theme.of(context).primaryColor),
                onPressed: () {
                  setState(() {
                    addPossibleSelection(questionListPosition);
                  });
                  //_showLastElementOfListView();
                },
                alignment: Alignment.centerRight,
                tooltip: 'Añadir otra posible respuesta',
              )),
          Padding(
              padding: EdgeInsets.all(0.0),
              child: IconButton(
                icon: Icon(Icons.delete, color: Theme.of(context).primaryColor),
                onPressed: () {
                  setState(() {
                    if (multipleSelectionControlList[questionListPosition] > 1)
                      deletePossibleSelection(questionListPosition, position);
                    else {
                      allPossibleSelectionControllerList[
                              findAllPossibleSelectionPreIndex(
                                  questionListPosition)]
                          .text = '';
                    }
                  });
                  //_showLastElementOfListView();
                },
                alignment: Alignment.centerRight,
                tooltip: 'Eliminar posible respuesta',
              ))
        ]));
  }

  void refreshQuestionWidgetList() {
    if (questionControllerList.length < questionCount) {
      TextEditingController auxController = TextEditingController();
      questionControllerList.add(auxController);
      //questionWidgetList.add(question(questionCount - 1));
    }
  }

  void addNewQuestion(int questionPosition) {
    setState(() {
      questionTypeList.insert(questionPosition + 1, 'YN');
      questionTextList.insert(questionPosition + 1, 'Pregunta cerrada');
      multipleSelectionControlList.insert(questionPosition + 1, 0);
      TextEditingController auxController = TextEditingController();
      questionControllerList.insert(questionPosition + 1, auxController);
      questionCount++;
      possibleSelectionCount++;
    });
  }

  void deleteQuestion(int questionPosition) {
    setState(() {
      questionTypeList.removeAt(questionPosition);
      questionTextList.removeAt(questionPosition);
      questionControllerList.removeAt(questionPosition);
      //questionWidgetList.removeAt(questionPosition);
      removeCorrespondingControllers(questionPosition);
      possibleSelectionCount -= multipleSelectionControlList[questionPosition];
      multipleSelectionControlList.removeAt(questionPosition);
      questionCount--;
    });
  }

  void removeCorrespondingControllers(int questionListPosition) {
    int count = 0;
    if (questionListPosition != 0)
      for (int i = 0; i < questionListPosition; i++) {
        count += multipleSelectionControlList[i];
      }
    for (int w = 0;
        w < multipleSelectionControlList[questionListPosition];
        w++) {
      allPossibleSelectionControllerList.removeAt(count);
      if (w < multipleSelectionControlList[questionListPosition] - 1)
        possibleSelectionCount--;
    }
  }

  addPossibleSelection(int questionListPosition) {
    possibleSelectionCount++;
    multipleSelectionControlList[questionListPosition]++;
    if (questionListPosition < multipleSelectionControlList.length - 1) {
      int count = 0;
      for (int i = 0; i <= questionListPosition; i++) {
        count += multipleSelectionControlList[i];
      }
      TextEditingController auxController = TextEditingController();
      allPossibleSelectionControllerList.insert(count - 1, auxController);
    }
  }

  deletePossibleSelection(int questionListPosition, int position) {
    int count = 0;
    for (int i = 0; i < questionListPosition; i++) {
      count += multipleSelectionControlList[i];
    }
    allPossibleSelectionControllerList.removeAt(count + position);

    possibleSelectionCount--;
    multipleSelectionControlList[questionListPosition]--;
  }

  Future<void> _saveQuestionnaire() async {
    int result = 1;
    int auxResult;
    //int allPossibleSelectionCount = 0;

    //-----------------------------------------------New Code--------------------------------------
    if (questionControllerList.length == 1 &&
        questionControllerList[0].text == '') {
      await databaseHelper.deleteAllMultipleSelections(area);
      await databaseHelper.deleteAllAnswers(area);
      await databaseHelper.deleteAllQuestions(area);
      if (result == 0) {
        _showAlertDialog('Error', 'Ocurrió un error al tratar de Registrar');
      } else {
        moveToLastScreen();
        _showAlertDialog('Éxito', 'Registro exitoso');
      }
    } else if (_formkey.currentState.validate()) {
      //Truncate MultipleSelection Table
      await databaseHelper.deleteAllMultipleSelections(area);

      List<int> newQuestionsControllerList = List<
          int>(); //Control to know each new question index. Index equals to 0 means it.
      for (int a = 0; a < questionControllerList.length; a++)
        newQuestionsControllerList.add(0);
      //Eliminate The original questions that are not in the actual questionControllerList and update the ones that are
      for (int q = 0; q < questionList.length; q++) {
        bool found = false;
        int foundIndex;
        for (int o = 0; o < questionControllerList.length; o++) {
          if (questionControllerList[o].text == questionList[q].question) {
            found = true;
            foundIndex = o;
            newQuestionsControllerList[o] = 1;
            questionList[q].type = questionTypeList[o];
            questionList[q].position = o;
            auxResult = await databaseHelper.updateQuestion(questionList[q]);
            if (auxResult == 0) result = 0;
            o = questionControllerList.length;
          }
        }
        if (!found) {
          auxResult = await databaseHelper.deleteAnswers(questionList[q].id);
          auxResult = await databaseHelper.deleteQuestion(questionList[q].id);
          if (auxResult == 0) result = 0;
          debugPrint('Result of delete: $auxResult');
        } else {
          //-----------------Insert multiple selection--------------------------
          if (questionTypeList[foundIndex] == 'MS') {
            //Find the allPossibleSelectionPreIndex
            int preIndex = findAllPossibleSelectionPreIndex(foundIndex);
            debugPrint(
                'The question pos is: $foundIndex and The PreIndex is: $preIndex');
            for (int m = 0; m < multipleSelectionControlList[foundIndex]; m++) {
              //Insert each possibleSelection of that question
              MultipleSelection multipleSelection = MultipleSelection(
                  questionList[q].id,
                  allPossibleSelectionControllerList[preIndex + m].text,
                  area);
              debugPrint(
                  'The MS in ${preIndex + m} is: ${allPossibleSelectionControllerList[preIndex + m].text}. id: ${questionList[q].id}');
              auxResult = await databaseHelper
                  .insertMultipleSelection(multipleSelection);
              if (auxResult == 0) result = 0;
              debugPrint('Result of insertMS: $auxResult');
            }
          }
        }
      }

      //Insert only new questions-----------------------------------------------
      for (int n = 0; n < newQuestionsControllerList.length; n++) {
        if (newQuestionsControllerList[n] == 0) {
          Question question = Question(
              area, questionTypeList[n], questionControllerList[n].text, 0, n);
          auxResult = await databaseHelper.insertQuestion(question);
          if (auxResult == 0) result = 0;
          debugPrint('Result of insertQ: $auxResult');

          if (questionTypeList[n] == 'MS') {
            //Insert Multiple Selection of new Questions
            int preIndex = findAllPossibleSelectionPreIndex(n);
            debugPrint(
                'The question pos is: $n and The PreIndex is: $preIndex');
            int questionMaxId = await databaseHelper.getQuestionMaxId();
            for (int m = 0; m < multipleSelectionControlList[n]; m++) {
              MultipleSelection multipleSelection = MultipleSelection(
                  questionMaxId,
                  allPossibleSelectionControllerList[preIndex + m].text,
                  area);
              debugPrint(
                  'The MS in ${preIndex + m} is: ${allPossibleSelectionControllerList[preIndex + m].text}. id: $questionMaxId');
              auxResult = await databaseHelper
                  .insertMultipleSelection(multipleSelection);
              if (auxResult == 0) result = 0;
              debugPrint('Result of insertMS: $auxResult');
            }
          }
        }
      }

      //-----------------------------------------------End of New Code--------------------------------------

      // for (int q = 0; q < questionCount; q++) {
      //   Question question =
      //       Question(area, questionTypeList[q], questionControllerList[q].text, 0);
      //   auxResult = await databaseHelper.insertQuestion(question);
      //   if (auxResult == 0) {
      //     result = 0;
      //   } else {
      //     int questionMaxId = await databaseHelper.getQuestionMaxId();

      //     //Insert MultipleSelection
      //     for (int m = 0; m < multipleSelectionControlList[q]; m++) {
      //       MultipleSelection multipleSelection = MultipleSelection(
      //           questionMaxId,
      //           allPossibleSelectionControllerList[allPossibleSelectionCount]
      //               .text);
      //       auxResult =
      //           await databaseHelper.insertMultipleSelection(multipleSelection);
      //       allPossibleSelectionCount++;
      //       if (auxResult == 0) {
      //         result = 0;
      //       }
      //     }
      //   }
      // }

      if (result == 0) {
        _showAlertDialog('Error', 'Ocurrió un error al tratar de Registrar');
      } else {
        moveToLastScreen();
        _showAlertDialog('Éxito', 'Registro exitoso');
      }
    }
  }

  void _loadVariables() async {
    if (isHealth)
      area = 'H';
    else
      area = 'HB';
    List<Question> questionList = await databaseHelper.getQuestionList(area);
    debugPrint('${questionList.length}');
    if (questionList.length > 0) {
      int auxQuestionCount = 0;
      int auxPossibleSelectionCount = 0;
      List<int> auxMultipleSelectionControlList = List<int>();
      List<String> auxQuestionTypeList = List<String>();
      List<TextEditingController> auxQuestionControllerList =
          List<TextEditingController>();
      List<TextEditingController> auxAllPossibleSelectionControllerList =
          List<TextEditingController>();
      List<String> auxQuestionTextList = List<String>();

      for (int q = 0; q < questionList.length; q++) {
        auxQuestionTypeList.add('');
        auxQuestionTypeList[q] = questionList[q].type;
        switch (questionList[q].type) {
          case 'YN':
            auxQuestionTextList.add('Pregunta cerrada');
            break;
          case 'MS':
            auxQuestionTextList.add('Pregunta de Selección Múltiple');
            break;
          case 'OA':
            auxQuestionTextList.add('Pregunta abierta');
            break;
        }
        TextEditingController questionController = TextEditingController();
        auxQuestionControllerList.add(questionController);
        auxQuestionControllerList[q].text = questionList[q].question;
        auxQuestionCount++;
        List<MultipleSelection> multipleSelectionList =
            await databaseHelper.getMultipleSelectionList(questionList[q].id);
        auxMultipleSelectionControlList.add(multipleSelectionList.length);
        auxPossibleSelectionCount++;
        for (int m = 0; m < multipleSelectionList.length; m++) {
          TextEditingController possibleSelectionController =
              TextEditingController();
          possibleSelectionController.text =
              multipleSelectionList[m].possibleSelection;
          auxAllPossibleSelectionControllerList
              .add(possibleSelectionController);
          if (m != 0) auxPossibleSelectionCount++;
        }
      }
      setState(() {
        questionCount = auxQuestionCount;
        possibleSelectionCount = auxPossibleSelectionCount;
        multipleSelectionControlList = auxMultipleSelectionControlList;
        questionTypeList = auxQuestionTypeList;
        questionControllerList = auxQuestionControllerList;
        allPossibleSelectionControllerList =
            auxAllPossibleSelectionControllerList;
        questionTextList = auxQuestionTextList;
        this.questionList = questionList;
      });
    }
  }

  int findAllPossibleSelectionPreIndex(int questionIndex) {
    int count = 0;
    for (int i = 0; i < questionIndex; i++) {
      count += multipleSelectionControlList[i];
    }
    return count;
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  bool verifyQuestionUniqueness(int questionPosition) {
    bool uniqueness = true;
    for (int q = 0; q < questionTextList.length; q++) {
      if (q != questionPosition &&
          questionControllerList[q].text ==
              questionControllerList[questionPosition].text) {
        uniqueness = false;
      }
    }
    return uniqueness;
  }

  void moveToLastScreen() {
    Navigator.pop(context);
  }
}
