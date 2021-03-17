import 'package:fit_trainer_updated/models/subscriber.dart';
import 'package:flutter/material.dart';
import 'package:fit_trainer_updated/screens/settings_page.dart';
import '../screens/diet_page.dart';
import '../screens/exercises_page.dart';
import '../screens/evaluation_page.dart';
import '../screens/question_area.dart';
import '../Providers/subscriber_provider.dart';
import 'package:provider/provider.dart';

class SubscriberDrawer extends StatelessWidget {
  Widget buildListTile(String text, IconData icon, Function tabHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        text,
        style: TextStyle(
          //fontFamily: 'RobotCondensed',
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tabHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    Subscriber subscriber =
        Provider.of<SubscriberProvider>(context, listen: false).subscriber;
    return Drawer(
        child: Column(
      children: [
        Container(
          height: 90,
          width: double.infinity,
          padding: EdgeInsets.all(20),
          alignment: Alignment.centerLeft,
          color: Color.fromRGBO(255, 0, 0, 1),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text('Acciones',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white)),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        buildListTile('Cuestionario', Icons.question_answer, () {}),
        buildListTile('Evaluación', Icons.assessment, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Evaluation(subscriber);
          }));
        }),
        buildListTile('Dieta', Icons.restaurant, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DietPage(subscriber.name, subscriber.id);
          }));
        }),
        buildListTile('Ejercicios', Icons.fitness_center, () {}),
      ],
    ));
  }
}
