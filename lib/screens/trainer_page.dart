import 'package:fit_trainer_updated/models/subscriber.dart';
import 'package:fit_trainer_updated/models/trainer.dart';
import 'package:fit_trainer_updated/screens/settings_page.dart';
import 'package:fit_trainer_updated/screens/subscriber_page.dart';
import 'package:flutter/material.dart';
import 'add_subscriber_page.dart';
import 'package:fit_trainer_updated/utils/database_helper.dart';

class TrainerPage extends StatefulWidget {
  final int trainerId;
  TrainerPage(this.trainerId);
  @override
  State<StatefulWidget> createState() {
    debugPrint('creating trainerpage state');
    return TrainerPageState(this.trainerId);
    // }
  }
}

class TrainerPageState extends State<TrainerPage> {
  int trainerId;
  TrainerPageState(this.trainerId);
  DatabaseHelper databaseHelper = DatabaseHelper();
  Trainer trainer;
  List<Subscriber> subscriberList;
  int listCount = 0;

  @override
  initState() {
    super.initState();
    _initializeDbVars();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text('Página principal'),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  //When the user presses the back button in AppBAr...
                  moveToLastScreen();
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: (){
                    navigateToSettings();
                  },
                )
              ],
            ),
            backgroundColor: Colors.white,
            body: scaffoldBody(),
            floatingActionButton: FloatingActionButton(
              
              onPressed: () {
                navigateToAddSubscriber(true);
              },
              tooltip: 'Añadir nuevo Suscriptor',
              child: Icon(Icons.add),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            ));
  }

  Widget scaffoldBody() {
    TextStyle titleStyle = Theme.of(context).textTheme.title;
    TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle;
    return Column(children: <Widget>[
      Expanded(
          child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Text(
                      trainerName(),
                      style: titleStyle,
                    )),
                Padding(
                    padding: EdgeInsets.all(3.0),
                    // child: Container(
                    //   height: 150.0,
                    //   width: 150.0,
                    // ),
                    child: FaceIcon()),
                Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Text(
                      'Cantidad de suscriptores: ' + subscriberQuantity(),
                      style: subtitleStyle,
                    ))
              ],
            ),
          )
        ],
      )),
      Expanded(
        child: Column(
          children: <Widget>[
            Text('Suscriptores', style: titleStyle),
            Expanded(
              child: ListView.builder(
                  //shrinkWrap: true,
                  itemCount: listCount,
                  itemBuilder: (BuildContext context, int postition) {
                    return Card(
                      color: Theme.of(context).primaryColorLight,
                      elevation: 2.0,
                      child: ListTile(
                        leading: CircleAvatar(
                          //child: Icon(Icons.person),
                          //backgroundImage:ImageProvider('images/faceIcon.png'),
                          child: FaceIcon(),
                        ),
                        title: Text(
                          subscriberList[postition].name,
                          style: subtitleStyle,
                        ),
                        //subtitle: Text(''),
                        trailing:
                            // GestureDetector(
                            //   child: Icon(Icons.delete, color: Colors.grey),
                            //   onTap: () {
                            //     //When delete button is tapped...
                            //   },
                            // ),
                            trailingButtons(subscriberList[postition]),
                        onTap: () {
                          //When suscriber is tapped...
                          navigateToSubscriberPage(subscriberList[postition]);
                        },
                      ),
                    );
                  }),
            )
          ],
        ),
      )
    ]);
  }

  void moveToLastScreen() {
    Navigator.pop(context,true);
  }

  void navigateToAddSubscriber(bool addSubscriber,
      [Subscriber subscriber]) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      String appBarText;
      if (addSubscriber) {
        appBarText = 'Añadir nuevo Suscriptor';
        return AddSubscriberPage(addSubscriber, appBarText,trainerId);
      } else {
        appBarText = 'Editar Suscriptor';
        return AddSubscriberPage(
          addSubscriber,
          appBarText,
          null,
          subscriber,
        );
      }
    }));
    if (result) {
      updateTrainerAndSubscriberList();
    }
  }

  void navigateToSettings(){
     Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SettingsPage();
    }));
  }

  void updateTrainerAndSubscriberList() async {
    await getTrainer();
    await updateSubscriberList();
  }

  void navigateToSubscriberPage(Subscriber subscriber) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SubscriberPage(subscriber);
    }));
  }

  void getTrainer() async {
    trainer = await databaseHelper.getTrainer(trainerId);
  }

  String trainerName() {
    String name;
    if (trainer == null) {
      name = '';
    } else {
      name = trainer.name;
    }
    return name;
  }

  String subscriberQuantity() {
    String subscriberQuantity;
    if (trainer == null) {
      subscriberQuantity = '';
    } else {
      subscriberQuantity = trainer.subscriberQuantity.toString();
    }
    return subscriberQuantity;
  }

  void updateSubscriberList() async {
    List<Subscriber> theSubscriberList =
        await databaseHelper.getSubscriberList(trainerId);
    setState(() {
      this.subscriberList = theSubscriberList;
      this.listCount = theSubscriberList.length;
    });

    // final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    // dbFuture.then((database){

    //   Future<List<Subscriber>> subscriberListFuture = databaseHelper.getSubscriberList(1);
    //   subscriberListFuture.then((subscriberList){
    //     setState(() {
    //       this.subscriberList = subscriberList;
    //       this.listCount = subscriberList.length;
    //     });
    //   });
    // });
  }

  void _initializeDbVars() async {
    await getTrainer();
    await updateSubscriberList();
  }

  Widget trailingButtons(Subscriber subscriber) {
    return SizedBox(
        width: 96.0,
        child: Row(children: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 0.0),
              child: IconButton(
                icon: Icon(Icons.edit,
                    color: Theme.of(context).primaryColor.withOpacity(0.75)),
                onPressed: () {
                  navigateToAddSubscriber(false, subscriber);
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
                  _showDeleteDialog(subscriber.id);
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

  void _deleteSubscriber(int subscriberId) async {
    await databaseHelper.deleteSubscriberDiet(subscriberId);
    await databaseHelper.deleteSubscriberExercise(subscriberId);
    int result = await databaseHelper.deleteSubscriber(subscriberId);
    if (result != 0) {
      trainer.subscriberQuantity--;
      await databaseHelper.updateTrainer(trainer);
      updateSubscriberList();
      _showAlertDialog('Éxito', 'Eliminación Exitosa');
    } else {
      _showAlertDialog('Error', 'Ocurrió un error al tratar de Eliminar');
    }
  }

  void _showDeleteDialog(int subscriberId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Eliminar"),
          content: Text(
              "¿Desea eliminar al Suscriptor? Si acepta, entonces se dejarán de asociar las Dietas y los Ejercicios con el Suscriptor, y se eliminará el Suscriptor. Sin embargo, las Dietas y los Ejercicios como tal permanecerán."),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 30.0),
                child: FlatButton(
                  child: Text("Aceptar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _deleteSubscriber(subscriberId);
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

class FaceIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage('images/faceIcon.png');
    Image image = Image(
      image: assetImage,
      width: 150.0,
      height: 150.0,
    );
    return Container(
      child: image,
    );
  }
}
