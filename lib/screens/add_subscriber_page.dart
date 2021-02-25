import 'package:fit_trainer_updated/models/contact.dart';
import 'package:fit_trainer_updated/models/subscriber.dart';
import 'package:fit_trainer_updated/models/trainer.dart';
import 'package:fit_trainer_updated/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class AddSubscriberPage extends StatefulWidget {
  final Subscriber subscriber;
  final String appBarText;
  final bool addSubscriber;
  final int trainerId;
  AddSubscriberPage(this.addSubscriber, this.appBarText,
      [this.trainerId, this.subscriber]);
  @override
  State<StatefulWidget> createState() {
    return AddSubscriberPageState(
        this.addSubscriber, this.appBarText, this.trainerId, this.subscriber);
  }
}

class AddSubscriberPageState extends State<AddSubscriberPage> {
  Subscriber subscriber;
  String appBarText;
  bool addSubscriber;
  int trainerId;
  AddSubscriberPageState(this.addSubscriber, this.appBarText,
      [this.trainerId, this.subscriber]);
  DatabaseHelper databaseHelper = DatabaseHelper();
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController objectiveController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  List<String> contactTypeList = ['C'];
  List<String> contactTextList = ['Número de Celular'];
  int contactListCount = 1;
  String gender='M';
  List<TextEditingController> contactControllerList =
      List<TextEditingController>();
  List<Widget> contactListWidgets = List<Widget>();
  var _formkey = GlobalKey<FormState>();
  //ScrollController _scrollController = new ScrollController();
  @override
  initState() {
    super.initState();
    if (subscriber != null) {
      gender = subscriber.gender;
      nameController.text = subscriber.name;
      _loadContactListVariables();
      addressController.text = subscriber.address;
      objectiveController.text = subscriber.objective;
      birthDateController.text = subscriber.birthdate;
    }
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
        child: Scrollbar(
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
                            return 'Introduzca el Nombre del Suscriptor';
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
                    child: genderWidget(),
                  ),
                  basicTimeField(),
                  contactListview(),
                  Padding(
                      padding: EdgeInsets.all(3.0),
                      child: TextFormField(
                        style: subtitleStyle,
                        controller: addressController,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Introduzca la Dirección del Suscriptor';
                          }
                        },
                        decoration: InputDecoration(
                            labelText: 'Dirección',
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
                        controller: objectiveController,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Introduzca el Objetivo del Suscriptor';
                          }
                        },
                        decoration: InputDecoration(
                            labelText: 'Objetivo',
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
                        'Registrar',
                        style: TextStyle(color: Colors.white),
                        //textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        //When the Registrar button is pressed...
                        if (_formkey.currentState.validate()) {
                          _saveSubscriber();
                        }
                        // setState(() {
                        //   _saveSubscriber();
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
        )),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  Future<void> _saveSubscriber() async {
    //moveToLastScreen();
    int result;
    if (addSubscriber) {
      Trainer trainer = await databaseHelper.getTrainer(trainerId);
      trainer.subscriberQuantity++;
      await databaseHelper.updateTrainer(trainer);
      Subscriber subscriber = Subscriber(
          trainer.id,
          nameController.text,
          birthDateController.text,
          gender,
          addressController.text,
          objectiveController.text);
      result = await databaseHelper.insertSubscriber(subscriber);
      if (result == 0) {
        _showAlertDialog('Error', 'Ocurrió un error al tratar de Registrar');
      } else {
        moveToLastScreen();
        _showAlertDialog('Éxito', 'Registro exitoso');
        int maxId = await databaseHelper.getSubscriberMaxId();
        for (int c = 0; c < contactListCount; c++) {
          Contact contact =
              Contact(maxId, contactControllerList[c].text, contactTypeList[c]);
          await databaseHelper.insertContact(contact);
        }
        //subscriber=databaseHelper.

        // setState(() {
        //   nameController.text = '';
        //   birthDateController.text = '';
        //   addressController.text = '';
        //   objectiveController.text = '';
        //   contactController.text = '';
        //   contactTypeList = ['C'];
        //   contactTextList = ['Número de Celular'];
        //   contactListCount = 1;
        //   contactControllerList = List<TextEditingController>();
        //   contactListWidgets = List<Widget>();
        // });
      }
    } else {
      this.subscriber.name = nameController.text;
      this.subscriber.birthdate = birthDateController.text;
      this.subscriber.gender=gender;
      this.subscriber.address = addressController.text;
      this.subscriber.objective = objectiveController.text;
      result = await databaseHelper.updateSubscriber(this.subscriber);
      if (result == 0) {
        _showAlertDialog('Error', 'Ocurrió un error al tratar de Registrar');
      } else {
        moveToLastScreen();
        _showAlertDialog('Éxito', 'Registro exitoso');
        await databaseHelper.deleteContactsBySubscriberId(this.subscriber.id);
        for (int c = 0; c < contactListCount; c++) {
          Contact contact = Contact(this.subscriber.id,
              contactControllerList[c].text, contactTypeList[c]);
          await databaseHelper.insertContact(contact);
        }
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

  void refreshContactList() {
    List<Widget> auxContactListWidgets = List<Widget>();
    List<String> auxStringList = List<String>();
    List<String> auxContactTypeList = List<String>();
    if (contactControllerList.length < contactListCount) {
      for (int c = contactControllerList.length; c < contactListCount; c++) {
        TextEditingController controller = TextEditingController();
        contactControllerList.add(controller);
      }
    }
    for (int c = 0; c < contactListCount; c++) {
      if (contactTypeList.length - 1 >= c) {
        auxStringList.add(contactTextList[c]);

        auxContactTypeList.add(contactTypeList[c]);
      } else {
        auxStringList.add('Número de Celular');
        auxContactTypeList.add('C');
      }
    }
    contactTextList = auxStringList;
    contactTypeList = auxContactTypeList;
    for (int c = 0; c < contactListCount; c++) {
      auxContactListWidgets.add(contact(c));
    }
    contactListWidgets = auxContactListWidgets;
  }

  Widget contact(int contactListPosition) {
    TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle;
    Widget contactWidget = Padding(
        padding: EdgeInsets.only(top: 6.0),
        child: Column(
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 3.0, top: 3.0, right: 3.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: 70.0,
                        child: Text('Celular ',
                            style: subtitleStyle, textAlign: TextAlign.center),
                      ),
                      SizedBox(
                          width: 40.0,
                          height: 40.0,
                          child: Radio(
                            value: 'C',
                            groupValue: contactTypeList[contactListPosition],
                            onChanged: (String value) {
                              contactTextList[contactListPosition] =
                                  'Número de Celular';
                              contactTypeList[contactListPosition] = value;
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
                        width: 70.0,
                        child: Text('Teléfono ',
                            style: subtitleStyle, textAlign: TextAlign.center),
                      ),
                      SizedBox(
                          width: 40.0,
                          height: 40.0,
                          child: Radio(
                            value: 'T',
                            groupValue: contactTypeList[contactListPosition],
                            onChanged: (String value) {
                              contactTextList[contactListPosition] =
                                  'Número de Teléfono';
                              contactTypeList[contactListPosition] = value;
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
                        width: 70.0,
                        child: Text('Trabajo ',
                            style: subtitleStyle, textAlign: TextAlign.center),
                      ),
                      SizedBox(
                          width: 40.0,
                          height: 40.0,
                          child: Radio(
                            value: 'W',
                            groupValue: contactTypeList[contactListPosition],
                            onChanged: (String value) {
                              contactTextList[contactListPosition] =
                                  'Número de Trabajo';
                              contactTypeList[contactListPosition] = value;
                              setState(() {});
                            },
                          )),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.only(left: 3.0, top: 3.0, right: 3.0),
                  child: Column(children: <Widget>[
                    SizedBox(
                      width: 70.0,
                      child: Text('Correo',
                          style: subtitleStyle, textAlign: TextAlign.center),
                    ),
                    SizedBox(
                        width: 40.0,
                        height: 40.0,
                        child: Radio(
                          value: 'E',
                          groupValue: contactTypeList[contactListPosition],
                          onChanged: (String value) {
                            contactTextList[contactListPosition] =
                                'Correo electrónico';
                            contactTypeList[contactListPosition] = value;
                            setState(() {});
                          },
                        ))
                  ])),
            ]),
            Row(children: <Widget>[
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.all(3.0),
                      child: TextFormField(
                        style: subtitleStyle,
                        controller: contactControllerList[contactListPosition],
                        validator: (String value) {
                          // if (contactTypeList[contactListPosition] != 'E') {
                          //   Pattern pattern = r'/^(?:[+0]9)?[0-9]{10}$/';
                          //   RegExp regex = new RegExp(pattern);
                          //   if (!regex.hasMatch(value)) {
                          //     return 'Introduzca un Número válido';
                          //   }
                          // }
                          if (value.isEmpty) {
                            return 'Introduzca el ' +
                                contactTextList[contactListPosition];
                          }
                        },
                        decoration: InputDecoration(
                            labelText: contactTextList[contactListPosition],
                            labelStyle: subtitleStyle,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.redAccent),
                                borderRadius: BorderRadius.circular(5.0))),
                        onChanged: (value) {
                          //When Name Text has changed...
                        },
                      ))),
              Padding(
                  padding: EdgeInsets.all(3.0),
                  child: IconButton(
                    icon:
                        Icon(Icons.add, color: Theme.of(context).primaryColor),
                    onPressed: () {
                      setState(() {
                        contactListCount++;
                      });
                      //_showLastElementOfListView();
                    },
                    alignment: Alignment.centerRight,
                    tooltip: 'Añadir otro contacto',
                  ))
            ]),
          ],
        ));
    return contactWidget;
  }

  Widget genderWidget() {
    TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Padding(
          padding: EdgeInsets.only(left: 3.0, top: 3.0, right: 3.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                width: 70.0,
                child: Text('Masculino',
                    style: subtitleStyle, textAlign: TextAlign.center),
              ),
              SizedBox(
                  width: 40.0,
                  height: 40.0,
                  child: Radio(
                    value: 'M',
                    groupValue: gender,
                    onChanged: (String value) {
                      gender = value;
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
                width: 70.0,
                child: Text('Femenino',
                    style: subtitleStyle, textAlign: TextAlign.center),
              ),
              SizedBox(
                  width: 40.0,
                  height: 40.0,
                  child: Radio(
                    value: 'F',
                    groupValue: gender,
                    onChanged: (String value) {
                      gender = value;
                      setState(() {});
                    },
                  ))
            ],
          ))
    ]);
  }

  Widget contactListview() {
    refreshContactList();
    Widget widget = Padding(
        padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
        child: Container(
          // width: 150,
          //height: 127,
          child: ListView.builder(
              itemCount: contactListCount,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int position) {
                return contactListWidgets[position];
              }),
        ));
    return widget;
  }

  Widget basicTimeField() {
    //final format = DateFormat("HH:mm");
    final format = DateFormat("yyyy-MM-dd");
    TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle;
    return Padding(
        padding: EdgeInsets.all(3.0),
        child: DateTimeField(
          controller: birthDateController,
          validator: (value) {
            //Check when subscriber is being edited
            if (birthDateController.text.isEmpty) {
              return 'Introduzca la Fecha de Nacimiento del Suscriptor';
            }
          },
          style: subtitleStyle,
          decoration: InputDecoration(
              labelText: 'Fecha de Nacimiento',
              labelStyle: subtitleStyle,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(5.0))),
          format: format,
          onShowPicker: (context, currentValue) async {
            final DateTime picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1919),
                lastDate: DateTime(2100)
                //TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                );
            return picked;
          },
        ));
  }

  void _loadContactListVariables() async {
    List<String> contactTypeList = List<String>();
    List<String> contactTextList = List<String>();
    List<TextEditingController> contactControllerList =
        List<TextEditingController>();
    List<Contact> contactList =
        await databaseHelper.getContactList(subscriber.id);
    int contactListCount = contactList.length;
    String contactText;
    for (int g = 0; g < contactList.length; g++) {
      switch (contactList[g].contactType) {
        case 'C':
          contactText = 'Número de Celular';
          break;
        case 'T':
          contactText = 'Número de Teléfono';
          break;
        case 'W':
          contactText = 'Número del Trabajo';
          break;
        case 'E':
          contactText = 'Correo Electrónico';
          break;
        default:
      }
      TextEditingController controller = TextEditingController();
      contactTypeList.add(contactList[g].contactType);
      controller.text = contactList[g].contact;
      contactControllerList.add(controller);
      contactTextList.add(contactText);
    }
    setState(() {
      this.contactTypeList = contactTypeList;
      this.contactControllerList = contactControllerList;
      this.contactTextList = contactTextList;
      this.contactListCount = contactListCount;
    });
  }

}
