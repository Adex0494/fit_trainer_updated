import 'package:fit_trainer_updated/models/contact.dart';
import 'package:fit_trainer_updated/models/subscriber.dart';
import 'package:fit_trainer_updated/screens/question_area.dart';
import 'package:fit_trainer_updated/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'diet_page.dart';
import 'exercises_page.dart';
import 'evaluation_page.dart';
import '../widgets/faceIcon.dart';
import '../widgets/subscriber_drawer.dart';


class SubscriberPage extends StatefulWidget {
  final Subscriber subscriber;
  SubscriberPage(this.subscriber);
  @override
  State<StatefulWidget> createState() {
    return SubscriberPageState(this.subscriber);
  }
}

class SubscriberPageState extends State<SubscriberPage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  Subscriber subscriber;
  SubscriberPageState(this.subscriber);
  List<Contact> contactList = List<Contact>();
  final double contactWidth=290.0;
  //String contact = '';
  @override
  initState() {
    super.initState();
    _refreshContactList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          endDrawer: SubscriberDrawer(),
          appBar: AppBar(
            title: Text('Datos del Suscriptor'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                //When the user presses the back button in AppBAr...
                moveToLastScreen();
              },
            ),
          ),
          //backgroundColor: Colors.white,
          body: scaffoldBody(),
        ));
  }

  Widget scaffoldBody() {
    TextStyle titleStyle = Theme.of(context).textTheme.headline6;
    TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle2;
    return Container(
        alignment: Alignment.center,
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        subscriber.name,
                        style: titleStyle,
                      ),
                      Padding(padding: EdgeInsets.all(3.0), child: FaceIcon())
                    ],
                  ),
                ),
              ],
            ),
            Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                                  Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Container(
                        width: contactWidth,
                        child: Text(
                            'Fecha de nacimiento: ' + subscriber.birthdate + ' ('+calculateAge(DateTime.parse(subscriber.birthdate)).toString()+' años)',
                            style: subtitleStyle))),
                contactWidgetListview(),
                Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Container(
                        width: contactWidth,
                        child: Text('Dirección: ' + subscriber.address,
                            style: subtitleStyle))),
                Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Container(
                        width: contactWidth,
                        child: Text('Visión: ' + subscriber.objective,
                            style: subtitleStyle))),
                ],)
          ],
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context);
  }

  void navigateToDietaPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DietPage(subscriber.name, subscriber.id);
    }));
  }

  void navigateToExercices() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Exercises(subscriber.name, subscriber.id);
    }));
  }

  void navigateToEvaluation() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Evaluation(subscriber);
    }));
  }

    void navigateToQuestionArea() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return QuestionArea(false,subscriber.id);
    }));
  }

  void _refreshContactList() async {
    contactList = await databaseHelper.getContactList(subscriber.id);
    setState(() {});
  }

  Widget contactWidget(String contactText) {
    TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle;
    return Padding(
        padding: EdgeInsets.all(3.0),
        child: Container(width:contactWidth,
          child: Text(contactText, style: subtitleStyle)));
  }

  Widget contactWidgetListview() {
    List<Widget> contactListWidget = List<Widget>();
    for (int y = 0; y < contactList.length; y++) {
      String contactText;
      switch (contactList[y].contactType) {
        case 'C':
          contactText = 'Número de Celular: ' + contactList[y].contact;
          break;
        case 'T':
          contactText = 'Número de Teléfono: ' + contactList[y].contact;
          break;
        case 'W':
          contactText = 'Número del Trabajo: ' + contactList[y].contact;
          break;
        case 'E':
          contactText = 'Correo Electrónico: ' + contactList[y].contact;
          break;
        default:
      }
      contactListWidget.add(contactWidget(contactText));
    }

    Widget widget = Container(
        width: contactWidth+6.0,
        child:
            //height: 127,
            ListView.builder(
                padding: EdgeInsets.all(0.0),
                itemCount: contactList.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int position) {
                  return contactListWidget[position];
                }));

    return widget;
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
}


