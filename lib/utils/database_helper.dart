import 'dart:io';
import 'package:fit_trainer_updated/models/answer.dart';
import 'package:fit_trainer_updated/models/food_group.dart';
import 'package:fit_trainer_updated/models/food_portion.dart';
import 'package:fit_trainer_updated/models/multipleSelection.dart';
import 'package:fit_trainer_updated/models/question.dart';
import 'package:fit_trainer_updated/models/trainer_credentials.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:fit_trainer_updated/models/diet.dart';
import 'package:fit_trainer_updated/models/dietSchedule.dart';
import 'package:fit_trainer_updated/models/exercise.dart';
import 'package:fit_trainer_updated/models/exerciseType.dart';
import 'package:fit_trainer_updated/models/food.dart';
import 'package:fit_trainer_updated/models/measureUnit.dart';
import 'package:fit_trainer_updated/models/subscriber_diet.dart';
import 'package:fit_trainer_updated/models/subscriber_exercise.dart';
import 'package:fit_trainer_updated/models/subscriber.dart';
import 'package:fit_trainer_updated/models/trainer.dart';
import 'package:fit_trainer_updated/models/contact.dart';
import 'package:flutter/material.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;
  bool doOnce=true;

  //trainerCredentials table columns
  String trainerCredentialsTable = 'trainer_credentials_table';
  String colUsername = 'username';
  String colPassword = 'password';

  //trainer table columns
  String trainerTable = 'trainer_table';
  String colId = 'id';
  String colName = 'name';
  String colSubscriberQuantity = 'subscriberQuantity';
  String colPicturePointer = 'picturePointer';

  //subscriber table columns
  String subscriberTable = 'subscriber_table';
  String colTrainerId = 'trainerId';
  //String subscriberColId='subscriber_id';
  //String subscriberColName='subscriber_name';
  String colBirthdate = 'birthdate';
  String colGender = 'gender';
  String colAddress = 'address';
  String colObjective = 'objective';
  String colWeight = 'weight';
  String colHeight = 'height';
  String colFatPercentage = 'fatPercentage';
  String colPhysicalCondition ='physicalCondition';
  String colActivityFactor= 'activityFactor';
  String colHydrationLevel = 'hydrationLevel';
  String colbodyMassIndex = 'bodyMassIndex';
  //String colPicturePointer='subscriber_picPointer';

  //Contact table columns
  String contactTable = 'contact_table';
  String colSubscriberId = 'subscriberId';
  //String colId='contact_id';
  String colContact = 'contact';
  String colContactType = 'contactType';

  //Food table columns
  String foodTable = 'food_table';
  //String foodColId='food_id';
  //String foodColName='food_name';

  //MeasureUnit table columns
  String measureUnitTable = 'measureUnit_table';
  //String measureUnitColId='measureUnit_id';
  //String measureUnitColName='measureUnit_name';

  //DietSchedule table columns
  String dietScheduleTable = 'dietSchedule_table';
  //String dietScheduleColId='dietSchedule_id';
  String colSchedule = 'schedule';

  //Diet table columns
  String dietTable = 'diet_table';
  //String dietColId='diet_id';
  String colFoodId = 'foodId';
  String colMeasureUnitId = 'measureUnitId';
  String colScheduleId = 'scheduleId';
  String colQuantity = 'quantity';
  String colDay = 'day';

  //Subscriber_diet table columns
  String subscriberDietTable = 'subscriber_diet_table';
  //String subscriberDietColId='subscriberDiet_Id';
  String colDietId = 'dietId';

  //ExerciseType table columns
  String exerciseTypeTable = 'exerciseType_table';
  //String exerciseTypeColId='exerciseType_id';
  //String exerciseTypeColName='exerciseType_name';

  //Exercise table columns
  String exerciseTable = 'exercise_table';
  //String exerciseColId='exercise_id';
  String colExerciseTypeId = 'exerciseTypeId';
  String colSessionQuantity = 'sessionQuantity';
  String colUnitType = 'unitType'; //'T' for time. 'R' for repetitions
  String colRestingTimeUnit = 'restingTimeUnit';
  String colRestingTime = 'restingTime'; //in seconds
  //String colDay='exercise_day';
  String colTimeUnit = 'timeUnit'; //'S' for seconds. 'M' for minutes
  String colTimeUnitQuantity =
      'timeUnitQuantity'; //Quantity of seconds or minutes
  String colRepetitionQuantity = 'repetitionQuantity';

  //Subscriber_exercise table columns
  String subscriberExerciseTable = 'Subscriber_exercise_table';
  //String subscriberExerciseColId ='subscriberExercise_Id';
  String colExerciseId = 'exerciseId';

  //Question table columns
  String questionTable='question_table';
  String colArea='area';
  String colType='type';
  String colQuestion='question';
  String colEmphasis='emphasis';
  String colPosition='position';
  String colPostQuestionId='postQuestionId';

  //Answer table columns
  String answerTable='answer_table';
  String colQuestionId='questionId';
  String colAnswer='answer';
  String colQuestionArea='questionArea';

  //Possible selection table columns
  String multipleSelectionTable='multipleSelection_table';
  String colPossibleSelection='possibleSelection';

  //Food Group name
  String foodGroupTable = 'foodGroup_table';
  String colFoodGroupName = 'foodGroupName';
  String colProt='prot';
  String colLip = 'lip';
  String colHc = 'hc';

  // Food Portion table columns
  String foodPortionTable = 'foodPortion_table';
  String colFoodGroupId = 'foodGroupId';
  String colFoodPortionName = 'foodPortionName';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    //debugPrint('Getting database');
    if (_database == null) {
      debugPrint('Initializing database');
      _database = await initializeDatabase();
    }
    if (doOnce)
    {
      doOnce=false;
      List<Map<String, dynamic>> aMap = await getAFoodGroupMapById(1);
      if (aMap.length==0)
        await _insertFoodData();
    }

    //debugPrint('returning database');
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'fitTrainer.db';
    debugPrint('Opening database');
    var fitTrainerDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return fitTrainerDatabase;
  }

  //Creating all tables
  void _createDb(Database db, int newVersion) async {
    debugPrint('Creating database');
    await db.execute(
        'CREATE TABLE $trainerCredentialsTable($colUsername TEXT PRIMARY KEY,'
        '$colTrainerId INTEGER,$colPassword TEXT NOT NULL,'
        'FOREIGN KEY ($colTrainerId) REFERENCES $trainerTable ($colId))');
    await db.execute(
        'CREATE TABLE $trainerTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colName TEXT NOT NULL,'
        '$colSubscriberQuantity INTEGER,$colPicturePointer TEXT)');
    await db.execute(
        'CREATE TABLE $subscriberTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colTrainerId INTEGER,'
        '$colName TEXT NOT NULL,'
        '$colBirthdate TEXT NOT NULL,$colGender TEXT NOT NULL, $colAddress TEXT,$colObjective TEXT,'
        '$colFatPercentage INTEGER, $colPhysicalCondition TEXT, $colActivityFactor INTEGER, $colWeight INTEGER,$colHeight INTEGER,'
        '$colbodyMassIndex INTEGER,$colHydrationLevel INTEGER,$colPicturePointer TEXT,'
        'FOREIGN KEY ($colTrainerId) REFERENCES $trainerTable ($colId))');
    await db.execute(
        'CREATE TABLE $contactTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colSubscriberId INTEGER,'
        '$colContact TEXT NOT NULL,$colContactType TEXT NOT NULL,'
        'FOREIGN KEY ($colSubscriberId) REFERENCES $subscriberTable ($colId))');
    await db.execute(
        'CREATE TABLE $foodTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$colName TEXT NOT NULL)');
    await db.execute(
        'CREATE TABLE $measureUnitTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$colName TEXT NOT NULL)');
    await db.execute(
        'CREATE TABLE $dietScheduleTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$colSchedule TEXT NOT NULL)');
    await db.execute(
        'CREATE TABLE $dietTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colFoodId INTEGER,'
        '$colMeasureUnitId INTEGER,$colScheduleId,'
        '$colQuantity REAL NOT NULL,$colDay TEXT NOT NULL,'
        'FOREIGN KEY ($colFoodId) REFERENCES $foodTable ($colId),'
        'FOREIGN KEY ($colMeasureUnitId) REFERENCES $measureUnitTable ($colId),'
        'FOREIGN KEY ($colScheduleId) REFERENCES $dietScheduleTable ($colId))');
    await db.execute(
        'CREATE TABLE $subscriberDietTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colSubscriberId INTEGER,'
        '$colDietId INTEGER,'
        'FOREIGN KEY ($colDietId) REFERENCES $dietTable ($colId),'
        'FOREIGN KEY ($colSubscriberId) REFERENCES $subscriberTable ($colId))');
    await db.execute(
        'CREATE TABLE $exerciseTypeTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$colName TEXT NOT NULL)');
    await db.execute(
        'CREATE TABLE $exerciseTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colExerciseTypeId INTEGER,'
        '$colSessionQuantity INTEGER NOT NULL, $colUnitType TEXT NOT NULL,'
        '$colDay TEXT NOT NULL,$colTimeUnit TEXT, $colTimeUnitQuantity REAL, $colRepetitionQuantity INTEGER,'
        '$colRestingTimeUnit TEXT, $colRestingTime REAL,'
        'FOREIGN KEY ($colExerciseTypeId) REFERENCES $exerciseTypeTable ($colId))');
    await db.execute(
        'CREATE TABLE $subscriberExerciseTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colSubscriberId INTEGER,'
        '$colExerciseId INTEGER,'
        'FOREIGN KEY ($colSubscriberId) REFERENCES $subscriberTable ($colId),'
        'FOREIGN KEY ($colExerciseId) REFERENCES $exerciseTable ($colId))');
    await db.execute(
      'CREATE TABLE $questionTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colArea TEXT NOT NULL,'
      '$colType TEXT NOT NULL,$colQuestion TEXT NOT NULL, $colEmphasis INTEGER NOT NULL,$colPosition INTEGER NOT NULL,$colPostQuestionId INTEGER,'
      'FOREIGN KEY ($colPostQuestionId) REFERENCES $questionTable ($colId))');
    await db.execute(
      'CREATE TABLE $answerTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colQuestionId INTEGER NOT NULL,'
      '$colSubscriberId INTEGER NOT NULL,$colAnswer TEXT NOT NULL,$colQuestionArea TEXT NOT NULL,'
      'FOREIGN KEY ($colQuestionId) REFERENCES $questionTable ($colId),'
      'FOREIGN KEY ($colSubscriberId) REFERENCES $subscriberTable ($colId),'
      'FOREIGN KEY ($colQuestionArea) REFERENCES $questionTable ($colArea))');
    await db.execute(
      'CREATE TABLE $multipleSelectionTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,'
      '$colQuestionId INTEGER NOT NULL,$colPossibleSelection TEXT NOT NULL,$colQuestionArea TEXT NOT NULL,'
      'FOREIGN KEY ($colQuestionId) REFERENCES $questionTable ($colId),'
      'FOREIGN KEY ($colQuestionArea) REFERENCES $questionTable ($colArea))');
    await db.execute(
      'CREATE TABLE $foodGroupTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,'
      '$colFoodGroupName TEXT NOT NULL,$colProt INTEGER NOT NULL,$colLip INTEGER NOT NULL, $colHc INTEGER NOT NULL'
      ')');
     await db.execute(
       'CREATE TABLE $foodPortionTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,'
       '$colFoodPortionName TEXT NOT NULL,$colFoodGroupId INTEGER NOT NULL,'
       'FOREIGN KEY ($colFoodGroupId) REFERENCES $foodGroupTable ($colId))');
    debugPrint('Database Created');
  }

  //---------------------------------Insert Food Data-----------------------------
    Future<void> _insertFoodData() async{
    //----------------Inserting FoodGroup
    List<FoodGroup> foodGroupList = List<FoodGroup>();
    foodGroupList.add(FoodGroup('Leche Entera 3%',8,8,12));
    foodGroupList.add(FoodGroup('Leche Semidescremada 2%',8,5,12));
    foodGroupList.add(FoodGroup('Leche Semidescremada 1%',8,2,12));
    foodGroupList.add(FoodGroup('Leche Descremada',8,0,12));
    foodGroupList.add(FoodGroup('Leche con Azucar',8,5,30));
    foodGroupList.add(FoodGroup('Carne Muy Magra',7,1,0));
    foodGroupList.add(FoodGroup('Carne Magra',7,3,0));
    foodGroupList.add(FoodGroup('Carne Moderadamente Magra',7,5,0));
    foodGroupList.add(FoodGroup('Carne Alta en Grasa',7,8,0));
    foodGroupList.add(FoodGroup('Leguminosas',7,1,15));
    foodGroupList.add(FoodGroup('Cereales sin Grasa',2,1,15));
    foodGroupList.add(FoodGroup('Cereales con Grasa',2,5,15));
    foodGroupList.add(FoodGroup('Verduras',2,0,5));
    foodGroupList.add(FoodGroup('Frutas',0,0,15));
    foodGroupList.add(FoodGroup('Grasas',0,5,0));
    foodGroupList.add(FoodGroup('Accesorios',0,0,10));

    for (int l=0;l<foodGroupList.length;l++)
    {
      await insertInitialFoodGroup(foodGroupList[l]);
    }

    //----------------------Inserting Food
    List<FoodPortion> foodPortionList = List<FoodPortion>();

    //----------------------Leche entera 3%
    foodPortionList.add(FoodPortion(1,'1 taza (8oz) de leche'));
    foodPortionList.add(FoodPortion(1,'1 taza (8oz) de yogurt'));
    foodPortionList.add(FoodPortion(1,'1 taza (8oz) de boruga'));
    foodPortionList.add(FoodPortion(1,'1/2 taza de leche evaporada'));
    foodPortionList.add(FoodPortion(1,'1/3 taza (3 cdas) de leche en polvo'));

    
    //----------------------Leche semidescremada 2%
        foodPortionList.add(FoodPortion(2,'8 oz de leche semidescremada 2%'));

    //----------------------Leche semidescremada 1%
    foodPortionList.add(FoodPortion(3,'8 oz de leche semidescremada 1%'));

    //----------------------Leche descremada 
        foodPortionList.add(FoodPortion(4,'8 oz de leche descremada'));

    //---------------------Leche con azucar
    foodPortionList.add(FoodPortion(5,'1 taza (240ml) de leche con chocolate'));
    foodPortionList.add(FoodPortion(5,'1 taza (240ml) de leche con vainilla'));
    foodPortionList.add(FoodPortion(5,'1 taza (240ml) de leche malteada saborizada'));
    foodPortionList.add(FoodPortion(5,'3/4 taza (175 ml) yougurt de frutas'));
    foodPortionList.add(FoodPortion(5,'3/4 taza (175 ml) yougurt de vainilla'));

    
    //---------------------Carne muy magra
    foodPortionList.add(FoodPortion(6,'1 oz de pechuga de pollo'));
    foodPortionList.add(FoodPortion(6,'1 oz pechuga de pavo sin piel'));
    foodPortionList.add(FoodPortion(6,'1 oz de carne de res deshebrada'));
    foodPortionList.add(FoodPortion(6,'1 onza de bacalao fresco'));
    foodPortionList.add(FoodPortion(6,'1 onza de atún'));
    foodPortionList.add(FoodPortion(6,'1 onza de trucha'));
    foodPortionList.add(FoodPortion(6,'1 onza de almeja'));
    foodPortionList.add(FoodPortion(6,'1 onza de camarón'));
    foodPortionList.add(FoodPortion(6,'1 onza de langosta'));
    foodPortionList.add(FoodPortion(6,'2 claras de huevo'));
    foodPortionList.add(FoodPortion(6,'1/4 taza de queso cottage sin grasa'));

    //---------------------Carne magra
    foodPortionList.add(FoodPortion(7,'1 oz de cerdo para asar (solomillo)'));
    foodPortionList.add(FoodPortion(7,'1 oz de jamón fresco o enlatado'));
    foodPortionList.add(FoodPortion(7,'1 oz de muslo de pollo'));
    foodPortionList.add(FoodPortion(7,'1 oz de muslo de pavo'));
    foodPortionList.add(FoodPortion(7,'1 oz de carne de pato sin piel'));
    foodPortionList.add(FoodPortion(7,'1 oz de hígado'));
    foodPortionList.add(FoodPortion(7,'1 oz de corazón'));
    foodPortionList.add(FoodPortion(7,'1 oz de arenque'));
    foodPortionList.add(FoodPortion(7,'1 oz de queso con 3 gramos o menos de grasa'));
    foodPortionList.add(FoodPortion(7,'1/4 taza queso cottage con 4-5% de grasa'));
    foodPortionList.add(FoodPortion(7,'1 oz de atún en aceite drenado (enlatado)'));

    //---------------------Carne moderadamente magra
    foodPortionList.add(FoodPortion(8,'1 oz Carne de res mechada'));
    foodPortionList.add(FoodPortion(8,'1 oz de chuleta'));
    foodPortionList.add(FoodPortion(8,'1 oz de lomo de cerdo'));
    foodPortionList.add(FoodPortion(8,'1 oz de carne oscura de pollo sin piel'));
    foodPortionList.add(FoodPortion(8,'1 oz de queso mozzarella'));
    foodPortionList.add(FoodPortion(8,'1 huevo hervido'));
    foodPortionList.add(FoodPortion(8,'1 oz de salchicha con 5 gramos o menos de grasa'));
    foodPortionList.add(FoodPortion(8,'1 oz de pescado o producto de pescado frito'));
    foodPortionList.add(FoodPortion(8,'1 de taza de fórmula de soya'));
    foodPortionList.add(FoodPortion(8,'1/2 de taza de tofu (112 g)'));
    foodPortionList.add(FoodPortion(8,'2 oz de queso ricotta (1/4 taza)'));

    //---------------------Carne alta en grasa
    foodPortionList.add(FoodPortion(9,'1 oz de carne molida de 2da o 3ra'));
    foodPortionList.add(FoodPortion(9,'1 oz de chorizo'));
    foodPortionList.add(FoodPortion(9,'1 oz de riñón'));
    foodPortionList.add(FoodPortion(9,'1 oz de mondongo'));
    foodPortionList.add(FoodPortion(9,'1 oz de salchicha para hot dog de pavo'));
    foodPortionList.add(FoodPortion(9,'1 oz de salchicha para hot dog de pollo'));
    foodPortionList.add(FoodPortion(9,'1 oz de salchicha para hot dog de res'));
    foodPortionList.add(FoodPortion(9,'1 oz de salchicha para hot dog de cerdo'));
    foodPortionList.add(FoodPortion(9,'1 oz de salami'));
    foodPortionList.add(FoodPortion(9,'1 oz de longaniza'));
    foodPortionList.add(FoodPortion(9,'1 oz de queso amarillo'));
    foodPortionList.add(FoodPortion(9,'1 oz de queso suizo'));
    foodPortionList.add(FoodPortion(9,'1 oz de queso americano'));
    foodPortionList.add(FoodPortion(9,'2 cdas. (10-15 gramos) de mantequilla de maní'));

    //---------------------Leguminosas 
    foodPortionList.add(FoodPortion(10,'1/2 taza de habichuelas'));
    foodPortionList.add(FoodPortion(10,'1/2 taza de garbanzos'));
    foodPortionList.add(FoodPortion(10,'1/2 taza de guandules'));
    foodPortionList.add(FoodPortion(10,'1/2 taza de lentejas'));
    foodPortionList.add(FoodPortion(10,'1/2 taza de chicharros'));
    foodPortionList.add(FoodPortion(10,'2/3 taza de habas'));
    foodPortionList.add(FoodPortion(10,'3 cdas. Miso'));
  

    //---------------------Cereales sin grasa
    foodPortionList.add(FoodPortion(11,'1/2 taza de avena'));
    foodPortionList.add(FoodPortion(11,'1/2 taza de trigo sin grasa'));
    foodPortionList.add(FoodPortion(11,'1/2 taza de maicena'));
    foodPortionList.add(FoodPortion(11,'1/2 taza de cereal'));
    foodPortionList.add(FoodPortion(11,'1/2 taza de pasta sin grasa'));
    foodPortionList.add(FoodPortion(11,'3 cdas. de germen de trigo'));
    foodPortionList.add(FoodPortion(11,'1/2 taza de arroz blanco sin grasa'));
    foodPortionList.add(FoodPortion(11,'1/2 taza de plátano'));
    foodPortionList.add(FoodPortion(11,'1/2 taza de yuca'));
    foodPortionList.add(FoodPortion(11,'1/2 taza de ñame'));
    foodPortionList.add(FoodPortion(11,'1/2 taza de yautía'));
    foodPortionList.add(FoodPortion(11,'1/2 taza de mapuey'));
    foodPortionList.add(FoodPortion(11,'4 guineo verde pequeño'));
    foodPortionList.add(FoodPortion(11,'6 galletitas de soda'));
    foodPortionList.add(FoodPortion(11,'6 galletitas saladas'));
    foodPortionList.add(FoodPortion(11,'1 rebanada (30 g) de pan de trigo'));
    foodPortionList.add(FoodPortion(11,'30 g de pasta de centeno'));
    foodPortionList.add(FoodPortion(11,'1/2 pieza de pan pita (15 cms de ancho)'));
    foodPortionList.add(FoodPortion(11,'1 oz (30 g) pan de agua'));
    foodPortionList.add(FoodPortion(11,'1 oz (30 g) pan sobado'));
    foodPortionList.add(FoodPortion(11,'3 tazas de palomitas de maíz sin grasa'));

    //---------------------Cereales con grasa
    foodPortionList.add(FoodPortion(12,'1/2 taza de trigo con grasa'));
    foodPortionList.add(FoodPortion(12,'1/2 taza de pasta con grasa'));
    foodPortionList.add(FoodPortion(12,'1/2 taza de arroz blanco con grasa'));
    foodPortionList.add(FoodPortion(12,'1/2 taza de plátano'));
    foodPortionList.add(FoodPortion(12,'3 tazas de palomitas de maíz con grasa'));

    //---------------------Verduras
    foodPortionList.add(FoodPortion(13,'1 taza de repollo crudo'));
    foodPortionList.add(FoodPortion(13,'1 taza de repollo hervido'));
    foodPortionList.add(FoodPortion(13,'1 taza de lechuga'));
    foodPortionList.add(FoodPortion(13,'1 taza de espinaca'));
    foodPortionList.add(FoodPortion(13,'1 taza de apio'));
    foodPortionList.add(FoodPortion(13,'1 taza de pepino'));
    foodPortionList.add(FoodPortion(13,'1 taza de rábano'));
    foodPortionList.add(FoodPortion(13,'1 taza de tomate'));
    foodPortionList.add(FoodPortion(13,'1/2 taza de brócoli hervido'));
    foodPortionList.add(FoodPortion(13,'1/2 taza de coliflor hervido'));
    foodPortionList.add(FoodPortion(13,'1/2 taza de zanahoria hervida'));
    foodPortionList.add(FoodPortion(13,'1/2 taza de champiñones hervidos'));
    foodPortionList.add(FoodPortion(13,'1/2 taza de jugo de verduras'));


    //---------------------Frutas
    foodPortionList.add(FoodPortion(14,'1/2 taza de frutas frescas enlatadas o jugo de frutas'));
    foodPortionList.add(FoodPortion(14,'1/4 de taza de fruta fresca (melón, piña, lechosa, mamey, zapote, guanábana o tamarindo'));
    foodPortionList.add(FoodPortion(14,'1 naranja pequeña'));
    foodPortionList.add(FoodPortion(14,'1 mandarina mediana'));
    foodPortionList.add(FoodPortion(14,'1 manzana'));
    foodPortionList.add(FoodPortion(14,'1 guineo pequeño'));
    foodPortionList.add(FoodPortion(14,'2 guayabas pequeñas'));
    foodPortionList.add(FoodPortion(14,'3 limones agrios'));
    foodPortionList.add(FoodPortion(14,'2 granadas'));
    foodPortionList.add(FoodPortion(14,'6 panes de fruta'));
    foodPortionList.add(FoodPortion(14,'1 pera pequeña'));
    foodPortionList.add(FoodPortion(14,'12 uvas'));
    foodPortionList.add(FoodPortion(14,'2 ciruelas pasa'));
    foodPortionList.add(FoodPortion(14,'1 higo grande'));

    
    //---------------------Grasas
    foodPortionList.add(FoodPortion(15,'1 cdta aceita vegetal'));
    foodPortionList.add(FoodPortion(15,'1 cdta de margarina'));
    foodPortionList.add(FoodPortion(15,'1 cdta de aderezo regular'));
    foodPortionList.add(FoodPortion(15,'1 cdta de mayonesa'));
    foodPortionList.add(FoodPortion(15,'2 cdtas de mantequilla de maní'));
    foodPortionList.add(FoodPortion(15,'10 gramos de maní'));
    foodPortionList.add(FoodPortion(15,'4 nueces'));
    foodPortionList.add(FoodPortion(15,'6 almendras'));
    foodPortionList.add(FoodPortion(15,'1 cda de semillas de ajonjoli'));
    foodPortionList.add(FoodPortion(15,'1 cda de aderezo para ensalada regular'));
    foodPortionList.add(FoodPortion(15,'2 cdas de coco rallado'));
    foodPortionList.add(FoodPortion(15,'30 gramos de aguacate'));
    foodPortionList.add(FoodPortion(15,'8 aceitunas'));

    //---------------------Accesorios
    foodPortionList.add(FoodPortion(16,'2 cdtas de miel'));
    foodPortionList.add(FoodPortion(16,'2 cdtas de mermelada'));
    foodPortionList.add(FoodPortion(16,'2 cdtas de melaza'));
    foodPortionList.add(FoodPortion(16,'2 cdtas de azucar'));
    foodPortionList.add(FoodPortion(16,'3 oz de bebida gaseosa '));


    for (int l=0;l<foodPortionList.length;l++)
    {
      await insertInitialFoodPortion(foodPortionList[l]);
    }
    
  }

  //----------------------------------Select queries-------------------------------
  //Get all trainer credentials
  Future<List<Map<String, dynamic>>> getTrainerCredentialsMapList() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM $trainerCredentialsTable ORDER BY $colId ASC');
    return result;
  }

  //Get a trainer's credentials
  Future<Map<String, dynamic>> getATrainerCredentialsMap(
      String username) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT * FROM $trainerCredentialsTable WHERE $colUsername = '$username'");
    List<Map<String, dynamic>> trainerCredential = result;
    Map<String, dynamic> map;
    if (trainerCredential.length!=0)
      map=result[0];
    return map;
  }

  //Get all trainers
  Future<List<Map<String, dynamic>>> getTrainerMapList() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM $trainerTable ORDER BY $colId ASC');
    return result;
  }

  //Get a trainer
  Future<Map<String, dynamic>> getATrainerMap(int id) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT * FROM $trainerTable WHERE $colId = $id ORDER BY $colId ASC');
    Map<String, dynamic> trainer = result[0];
    return trainer;
  }

  //Get the trainer max id
  Future<int> getTrainerMaxId() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT MAX($colId) FROM $trainerTable');
    int maxId = Sqflite.firstIntValue(result);
    return maxId;
  }

  //Get Subscribers by trainer id
  Future<List<Map<String, dynamic>>> getSubscriberMapList(int trainerId) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT * FROM $subscriberTable WHERE $colTrainerId=$trainerId ORDER BY $colId ASC');
    return result;
  }

    Future<Map<String, dynamic>> getSubscriberByIdMap(int subscriberId) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT * FROM $subscriberTable WHERE $colId=$subscriberId');
        Map<String, dynamic> subscriber =result[0];
    return subscriber;
  }

  

  //Get Subscriber max id
  Future<int> getSubscriberMaxId() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT MAX($colId) FROM $subscriberTable');
    int maxId = Sqflite.firstIntValue(result);
    return maxId;
  }

  //Get Contacts by subscriber id
  Future<List<Map<String, dynamic>>> getContactMapList(int subscriberId) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT * FROM $contactTable WHERE $colSubscriberId=$subscriberId ORDER BY $colId ASC');
    return result;
  }

  //Get Diet by diet id
  Future<List<Map<String, dynamic>>> getDietMap(int dietId) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM $dietTable WHERE $colId=$dietId');
    return result;
  }

  //Get all Diet rows
  Future<List<Map<String, dynamic>>> getDietMapList() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM $dietTable ORDER BY $colId ASC');
    return result;
  }

  //Get entire Subscriber Diet
  Future<List<Map<String, dynamic>>> getSubscriberDietMapList(
      int subscriberId) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT * FROM $subscriberDietTable WHERE $colSubscriberId=$subscriberId ORDER BY $colId ASC');
    return result;
  }

  //Get Diet max id
  Future<int> getDietMaxId() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT MAX($colId) FROM $dietTable');
    int maxId = Sqflite.firstIntValue(result);
    return maxId;
  }

  //Get Exercise by exercise id
  Future<List<Map<String, dynamic>>> getExerciseMap(int exerciseId) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM $exerciseTable WHERE $colId=$exerciseId');
    return result;
  }

  //Get All Exercise rows
  Future<List<Map<String, dynamic>>> getExerciseMapList() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM $exerciseTable ORDER BY $colId ASC');
    return result;
  }

  //Get Exercise max id
  Future<int> getExerciseMaxId() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT MAX($colId) FROM $exerciseTable');
    int maxId = Sqflite.firstIntValue(result);
    return maxId;
  }

  //Get entire Subscriber Exercises
  Future<List<Map<String, dynamic>>> getSubscriberExerciseMapList(
      int subscriberId) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT * FROM $subscriberExerciseTable WHERE $colSubscriberId=$subscriberId ORDER BY $colId ASC');
    return result;
  }

  //Get all Food
  Future<List<Map<String, dynamic>>> getFoodMapList() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM $foodTable ORDER BY $colId ASC');
    return result;
  }

  //Get Food filtered
  Future<List<Map<String, dynamic>>> getFoodFilteredMapList(
      String filter) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT * FROM $foodTable WHERE $colName LIKE '%$filter%' ORDER BY $colId ASC");
    return result;
  }

  //Get a Food Name
  Future<List<Map<String, dynamic>>> getAFoodNameMap(int id) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT $colName FROM $foodTable WHERE $colId = $id');
    return result;
  }

  //Get a Food
  Future<List<Map<String, dynamic>>> getAFoodMap(int id) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM $foodTable WHERE $colId = $id');
    return result;
  }

  //Get Food max id
  Future<int> getFoodMaxId() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT MAX($colId) FROM $foodTable');
    int maxId = Sqflite.firstIntValue(result);
    return maxId;
  }

  //Get all Measure Units
  Future<List<Map<String, dynamic>>> getMeasureUnitMapList() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM $measureUnitTable ORDER BY $colId ASC');
    return result;
  }

  //Get Measure Units filtered
  Future<List<Map<String, dynamic>>> getMeasureUnitFilteredMapList(
      String filter) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT * FROM $measureUnitTable WHERE $colName LIKE '%$filter%' ORDER BY $colId ASC");
    return result;
  }

  //Get a MeasureUnit Name
  Future<List<Map<String, dynamic>>> getAMeasureUnitNameMap(int id) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT $colName FROM $measureUnitTable WHERE $colId = $id');
    return result;
  }

  //Get a MeasureUnit
  Future<List<Map<String, dynamic>>> getAMeasureUnitMap(int id) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM $measureUnitTable WHERE $colId = $id');
    return result;
  }

  //Get MeasureUnit max id
  Future<int> getMeasureUnitMaxId() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT MAX($colId) FROM $measureUnitTable');
    int maxId = Sqflite.firstIntValue(result);
    return maxId;
  }

  //Get all Diet Schedule
  Future<List<Map<String, dynamic>>> getDietScheduleMapList() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM $dietScheduleTable ORDER BY $colId ASC');
    return result;
  }

  //Get a Diet Schedule schedule
  Future<List<Map<String, dynamic>>> getADietScheduleScheduleMap(int id) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT $colSchedule FROM $dietScheduleTable WHERE $colId = $id');
    return result;
  }

  //Get a Diet Schedule
  Future<List<Map<String, dynamic>>> getADietScheduleMap(int id) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM $dietScheduleTable WHERE $colId = $id');
    return result;
  }

  //Get DietSchedule max id
  Future<int> getDietScheduleMaxId() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT MAX($colId) FROM $dietScheduleTable');
    int maxId = Sqflite.firstIntValue(result);
    return maxId;
  }

  //Get all Exercise Types
  Future<List<Map<String, dynamic>>> getExerciseTypeMapList() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM $exerciseTypeTable ORDER BY $colId ASC');
    return result;
  }

  //Get Exercise Types filtered
  Future<List<Map<String, dynamic>>> getExerciseTypeFilteredMapList(
      String filter) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT * FROM $exerciseTypeTable WHERE $colName LIKE '%$filter%' ORDER BY $colId ASC");
    return result;
  }

  //Get an Exercise Type Name
  Future<List<Map<String, dynamic>>> getAnExerciseTypeNameMap(int id) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT $colName FROM $exerciseTypeTable WHERE $colId = $id');
    return result;
  }

  //Get Exercise Type max id
  Future<int> getExerciseTypeMaxId() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT MAX($colId) FROM $exerciseTypeTable');
    int maxId = Sqflite.firstIntValue(result);
    return maxId;
  }

    //Get all Questions by area
  Future<List<Map<String, dynamic>>> getQuestionMapList(String area) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db
        .rawQuery("SELECT * FROM $questionTable WHERE $colArea = '$area' ORDER BY $colPosition ASC");
    return result;
  }

    //Get the question max id
  Future<int> getQuestionMaxId() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT MAX($colId) FROM $questionTable');
    int maxId = Sqflite.firstIntValue(result);
    return maxId;
  }

  
    //Get all MultipleSelections by questionId
  Future<List<Map<String, dynamic>>> getMultipleSelectionMapList(int questionId) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM $multipleSelectionTable WHERE $colQuestionId = $questionId ORDER BY $colId ASC');
    return result;
  }

     //Get answers by subscriberId and Area
  Future<List<Map<String, dynamic>>> getAnswersMapListByArea(int subscriberId,String area) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db
        .rawQuery("SELECT * FROM $answerTable WHERE $colSubscriberId=$subscriberId AND $colArea='$area' ORDER BY $colId ASC");
    return result;
  }

     //Get answer by subscriberId and questionId
  Future<List<Map<String, dynamic>>> getAnswersMapByQuestionId(int subscriberId,int questionId) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db
        .rawQuery("SELECT * FROM $answerTable WHERE $colSubscriberId=$subscriberId AND $colQuestionId=$questionId ORDER BY $colId ASC");
    return result;
  }  

    
    //Get all Food Group Map List
  Future<List<Map<String, dynamic>>> getFoodGroupMapList() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM $foodGroupTable ORDER BY $colId ASC');
    return result;
  }

  //Get a Food Group Map List
  Future<List<Map<String, dynamic>>> getAFoodGroupMapById(int id) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM $foodGroupTable WHERE $colId = id');

    return result;
  }

  //Get all Food Portion Map List
  Future<List<Map<String, dynamic>>> getFoodPortionMapList() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM $foodPortionTable ORDER BY $colId ASC');
    return result;
  }

    //Get Food Portion Map List by group id
  Future<List<Map<String, dynamic>>> getFoodPortionByFoodGroupIdMapList(int id) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM $foodPortionTable WHERE $colFoodGroupId = $id ORDER BY $colId ASC');
    return result;
  }

  //Get a Food Portion Map List
  Future<List<Map<String, dynamic>>> getAFoodPortionMapById(int id) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM $foodPortionTable WHERE $colId = id');

    return result;
  }

  //Get count of Food Portion List by FoodGroup Id
    Future<int> getFoodPortionCountByFoodGroupId(int id) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT COUNT($colId) FROM $foodPortionTable WHERE $colFoodGroupId = $id');
    int maxId = Sqflite.firstIntValue(result);
    return maxId;
  }
  //----------------------------------Inserts-------------------------------------
  //Insert trainer credentials
  Future<int> insertTrainerCredentials(
      TrainerCredentials trainerCredentials) async {
    Database db = await this.database;
    int result =
        await db.insert(trainerCredentialsTable, trainerCredentials.toMap());
    return result;
  }

  //Insert Trainer
  Future<int> insertTrainer(Trainer trainer) async {
    Database db = await this.database;
    int result = await db.insert(trainerTable, trainer.toMap());
    return result;
  }

  //Insert Subscriber
  Future<int> insertSubscriber(Subscriber subscriber) async {
    Database db = await this.database;
    int result = await db.insert(subscriberTable, subscriber.toMap());
    return result;
  }

  //Insert Contact
  Future<int> insertContact(Contact contact) async {
    Database db = await this.database;
    int result = await db.insert(contactTable, contact.toMap());
    return result;
  }

  //Insert Food
  Future<int> insertFood(Food food) async {
    Database db = await this.database;
    int result = await db.insert(foodTable, food.toMap());
    return result;
  }

  //Insert MeasureUnit
  Future<int> insertMeasureUnit(MeasureUnit measureUnit) async {
    Database db = await this.database;
    int result = await db.insert(measureUnitTable, measureUnit.toMap());
    return result;
  }

  //Insert DietSchedule
  Future<int> insertDietSchedule(DietSchedule dietSchedule) async {
    Database db = await this.database;
    int result = await db.insert(dietScheduleTable, dietSchedule.toMap());
    return result;
  }

  //Insert Diet
  Future<int> insertDiet(Diet diet) async {
    Database db = await this.database;
    int result = await db.insert(dietTable, diet.toMap());
    return result;
  }

  //Insert SubscriberDiet
  Future<int> insertSubscriberDiet(SubscriberDiet subscriberdiet) async {
    Database db = await this.database;
    int result = await db.insert(subscriberDietTable, subscriberdiet.toMap());
    return result;
  }

  //Insert ExerciseType
  Future<int> insertExerciseType(ExerciseType exerciseType) async {
    Database db = await this.database;
    int result = await db.insert(exerciseTypeTable, exerciseType.toMap());
    return result;
  }

  //Insert Exercise
  Future<int> insertExercise(Exercise exercise) async {
    Database db = await this.database;
    int result = await db.insert(exerciseTable, exercise.toMap());
    return result;
  }

  //Insert SubscriberExercise
  Future<int> insertSubscriberExercise(
      SubscriberExercise subscriberExercise) async {
    Database db = await this.database;
    int result =
        await db.insert(subscriberExerciseTable, subscriberExercise.toMap());
    return result;
  }
  
    //Insert question
  Future<int> insertQuestion(
      Question question) async {
    Database db = await this.database;
    int result =
        await db.insert(questionTable, question.toMap());
    return result;
  }

      //Insert MultipleSelection
  Future<int> insertMultipleSelection(
      MultipleSelection multipleSelection) async {
    Database db = await this.database;
    int result =
        await db.insert(multipleSelectionTable, multipleSelection.toMap());
    return result;
  }

        //Insert Answer
  Future<int> insertAnswer(Answer answer) async {
    Database db = await this.database;
    int result =
        await db.insert(answerTable, answer.toMap());
    return result;
  }

    //Insert Food Group at first use
  Future<int> insertInitialFoodGroup(FoodGroup foodGroup) async {
    int result =
        await _database.insert(foodGroupTable, foodGroup.toMap());
    return result;
  }

  //Insert Food Group
  Future<int> insertFoodGroup(FoodGroup foodGroup) async {
    Database db = await this.database;
    int result =
        await db.insert(foodGroupTable, foodGroup.toMap());
    return result;
  }

      //Insert Food Portion at firstUse
  Future<int> insertInitialFoodPortion(FoodPortion foodPortion) async {
    int result =
        await _database.insert(foodPortionTable, foodPortion.toMap());
    return result;
  }

    //Insert Food Group
  Future<int> insertFoodPortion(FoodPortion foodPortion) async {
    Database db = await this.database;
    int result =
        await db.insert(foodPortionTable, foodPortion.toMap());
    return result;
  }
  //----------------------------------Updates-------------------------------------
  //Update Trainer
  Future<int> updateTrainer(Trainer trainer) async {
    Database db = await this.database;
    int result = await db.update(trainerTable, trainer.toMap(),
        where: '$colId = ?', whereArgs: [trainer.id]);
    return result;
  }

  //Update Subscriber
  Future<int> updateSubscriber(Subscriber subscriber) async {
    Database db = await this.database;
    int result = await db.update(subscriberTable, subscriber.toMap(),
        where: '$colId = ?', whereArgs: [subscriber.id]);
    return result;
  }

  //Update Contact
  Future<int> updateContact(Contact contact) async {
    Database db = await this.database;
    int result = await db.update(contactTable, contact.toMap(),
        where: '$colId = ?', whereArgs: [contact.id]);
    return result;
  }

  //Update Food
  Future<int> updateFood(Food food) async {
    Database db = await this.database;
    int result = await db.update(foodTable, food.toMap(),
        where: '$colId = ?', whereArgs: [food.id]);
    return result;
  }

  //Update MeasureUnit
  Future<int> updateMeasureUnit(MeasureUnit measureUnit) async {
    Database db = await this.database;
    int result = await db.update(measureUnitTable, measureUnit.toMap(),
        where: '$colId = ?', whereArgs: [measureUnit.id]);
    return result;
  }

  //Update DietSchedule
  Future<int> updateDietSchedule(DietSchedule dietSchedule) async {
    Database db = await this.database;
    int result = await db.update(dietScheduleTable, dietSchedule.toMap(),
        where: '$colId = ?', whereArgs: [dietSchedule.id]);
    return result;
  }

  //Update Diet
  Future<int> updateDiet(Diet diet) async {
    Database db = await this.database;
    int result = await db.update(dietTable, diet.toMap(),
        where: '$colId = ?', whereArgs: [diet.id]);
    return result;
  }

  //Update ExerciseType
  Future<int> updateExerciseType(ExerciseType exerciseType) async {
    Database db = await this.database;
    int result = await db.update(exerciseTypeTable, exerciseType.toMap(),
        where: '$colId = ?', whereArgs: [exerciseType.id]);
    return result;
  }

  //Update Exercise
  Future<int> updateExercise(Exercise exercise) async {
    Database db = await this.database;
    int result = await db.update(exerciseTable, exercise.toMap(),
        where: '$colId = ?', whereArgs: [exercise.id]);
    return result;
  }

    //Update Question
  Future<int> updateQuestion(Question question) async {
    Database db = await this.database;
    int result = await db.update(questionTable, question.toMap(),
        where: '$colId = ?', whereArgs: [question.id]);
    return result;
  }

      //Update MultipleSelection
  Future<int> updateMultipleSelection(MultipleSelection multipleSelection) async {
    Database db = await this.database;
    int result = await db.update(multipleSelectionTable, multipleSelection.toMap(),
        where: '$colId = ?', whereArgs: [multipleSelection.id]);
    return result;
  }

      //Update answer
  Future<int> updateAnswer(Answer answer) async {
    Database db = await this.database;
    int result = await db.update(answerTable, answer.toMap(),
        where: '$colId = ?', whereArgs: [answer.id]);
    return result;
  }

  //Update Food Group
  Future<int> updateFoodGroup(FoodGroup foodGroup) async {
    Database db = await this.database;
    int result = await db.update(foodGroupTable, foodGroup.toMap(),
        where: '$colId = ?', whereArgs: [foodGroup.id]);
    return result;
  }

    //Update Food Portion
  Future<int> updateFoodPortion(FoodPortion foodPortion) async {
    Database db = await this.database;
    int result = await db.update(foodPortionTable, foodPortion.toMap(),
        where: '$colId = ?', whereArgs: [foodPortion.id]);
    return result;
  }

  //----------------------------------Deletes-------------------------------------
  //Delete Trainer
  Future<int> deleteTrainer(int id) async {
    Database db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $trainerTable WHERE $colId = $id');
    return result;
  }

  //Delete Subscriber
  Future<int> deleteSubscriber(int id) async {
    Database db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $subscriberTable WHERE $colId = $id');
    return result;
  }

  //Delete Contact
  Future<int> deleteContact(int id) async {
    Database db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $contactTable WHERE $colId = $id');
    return result;
  }

  //Delete Contact
  Future<int> deleteContactsBySubscriberId(int subscriberId) async {
    Database db = await this.database;
    int result = await db.rawDelete(
        'DELETE FROM $contactTable WHERE $colSubscriberId = $subscriberId');
    return result;
  }

  //Delete Food
  Future<int> deleteFood(int id) async {
    Database db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $foodTable WHERE $colId = $id');
    return result;
  }

  //Delete MeasureUnit
  Future<int> deleteMeasureUnit(int id) async {
    Database db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $measureUnitTable WHERE $colId = $id');
    return result;
  }

  //Delete DietSchedule
  Future<int> deleteDietSchedule(int id) async {
    Database db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $dietScheduleTable WHERE $colId = $id');
    return result;
  }

  //Delete Diet
  Future<int> deleteDiet(int id) async {
    Database db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $dietTable WHERE $colId = $id');
    return result;
  }

  //Delete SubscriberDiet
  Future<int> deleteSubscriberDiet(int subscriberId, [int dietId]) async {
    Database db = await this.database;
    int result;
    if (dietId != null)
      result = await db.rawDelete(
          'DELETE FROM $subscriberDietTable WHERE $colSubscriberId = $subscriberId AND $colDietId = $dietId');
    else {
      result = await db.rawDelete(
          'DELETE FROM $subscriberDietTable WHERE $colSubscriberId = $subscriberId');
    }
    return result;
  }

  //Delete ExerciseType
  Future<int> deleteExerciseType(int id) async {
    Database db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $exerciseTypeTable WHERE $colId = $id');
    return result;
  }

  //Delete Exercise
  Future<int> deleteExercise(int id) async {
    Database db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $exerciseTable WHERE $colId = $id');
    return result;
  }

  //Delete SubscriberExercise
  Future<int> deleteSubscriberExercise(int subscriberId,
      [int exerciseId]) async {
    Database db = await this.database;
    int result;
    if (exerciseId != null)
      result = await db.rawDelete(
          'DELETE FROM $subscriberExerciseTable WHERE $colSubscriberId = $subscriberId AND $colExerciseId = $exerciseId');
    else {
      result = await db.rawDelete(
          'DELETE FROM $subscriberExerciseTable WHERE $colSubscriberId = $subscriberId');
    }
    return result;
  }

    //Delete Question
  Future<int> deleteQuestion(int id) async {
    Database db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $questionTable WHERE $colId = $id');
    return result;
  }

      //Delete all Questions by area
  Future<int> deleteAllQuestions(String area) async {
    Database db = await this.database;
    int result =
        await db.rawDelete("DELETE FROM $questionTable WHERE $colArea = '$area'");
    return result;
  }

  

      //Delete MultipleSelection by id
  Future<int> deleteMultipleSelection(int id) async {
    Database db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $multipleSelectionTable WHERE $colId = $id');
    return result;
  }

  //Delete all MultipleSelections 
  Future<int> deleteAllMultipleSelections(String area) async {
    Database db = await this.database;
    int result =
        await db.rawDelete("DELETE FROM $multipleSelectionTable WHERE $colQuestionArea='$area'");
    return result;
  }

      //Delete answers by questionID
  Future<int> deleteAnswers(int questionId) async {
    Database db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $answerTable WHERE $colQuestionId = $questionId');
    return result;
  }

  //Delete all answers
  Future<int> deleteAllAnswers(String area) async {
    Database db = await this.database;
    int result =
        await db.rawDelete("DELETE FROM $answerTable WHERE $colQuestionArea='$area'");
    return result;
  }

  //Delete Food Group by id
  Future<int> deleteFoodGroup(int foodGroupId) async {
    Database db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $foodGroupTable WHERE $colId = $foodGroupId');
    return result;
  }

    //Delete Food Portion by id
  Future<int> deleteFoodPortion(int foodPortionId) async {
    Database db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $foodPortionTable WHERE $colId = $foodPortionId');
    return result;
  }

//----------------------------------Getting each Object List from Map List-------------------------------------
  //Get Trainer List
  Future<List<Trainer>> getTrainerList() async {
    List<Map<String, dynamic>> mapList = await getTrainerMapList();
    int count = mapList.length;
    List<Trainer> objectList = List<Trainer>();
    for (int i = 0; i < count; i++) {
      objectList.add(Trainer.toTrainer(mapList[i]));
    }
    return objectList;
  }

  //Get Trainer Credentials
  Future<TrainerCredentials> getTrainerCredentials(String username) async {
    Map<String, dynamic> trainerCredentialsMap =
        await getATrainerCredentialsMap(username);
    TrainerCredentials trainerCredentials;
    if(trainerCredentialsMap!=null)
        trainerCredentials=TrainerCredentials.toTrainerCredentials(trainerCredentialsMap);
    return trainerCredentials;
  }

  //Get a Trainer
  Future<Trainer> getTrainer(int id) async {
    Map<String, dynamic> trainerMap = await getATrainerMap(id);
    Trainer trainer = Trainer.toTrainer(trainerMap);
    return trainer;
  }

  //Get Subscriber List
  Future<List<Subscriber>> getSubscriberList(int trainerId) async {
    List<Map<String, dynamic>> mapList = await getSubscriberMapList(trainerId);
    int count = mapList.length;
    List<Subscriber> objectList = List<Subscriber>();
    for (int i = 0; i < count; i++) {
      objectList.add(Subscriber.toSubscriber(mapList[i]));
    }
    return objectList;
  }

    //Get a Subscriber by Id
  Future<Subscriber> getSubscriberById(int subscriberId) async {
    Map<String, dynamic> subscriberMap = await getSubscriberByIdMap(subscriberId);
    Subscriber subscriber = Subscriber.toSubscriber(subscriberMap);
    return subscriber;
  }

  //Get Contact List
  Future<List<Contact>> getContactList(int subscriberId) async {
    List<Map<String, dynamic>> mapList = await getContactMapList(subscriberId);
    int count = mapList.length;
    List<Contact> objectList = List<Contact>();
    for (int i = 0; i < count; i++) {
      objectList.add(Contact.toContact(mapList[i]));
    }
    return objectList;
  }

  //Get Food List
  Future<List<Food>> getFoodList() async {
    List<Map<String, dynamic>> mapList = await getFoodMapList();
    int count = mapList.length;
    List<Food> objectList = List<Food>();
    for (int i = 0; i < count; i++) {
      objectList.add(Food.toFood(mapList[i]));
    }
    return objectList;
  }

  //Get a Food object
  Future<Food> getAFood(int id) async {
    List<Map<String, dynamic>> mapList = await getAFoodMap(id);
    Food object = Food.toFood(mapList[0]);
    return object;
  }

  //Get MeasureUnit List
  Future<List<MeasureUnit>> getMeasureUnitList() async {
    List<Map<String, dynamic>> mapList = await getMeasureUnitMapList();
    int count = mapList.length;
    List<MeasureUnit> objectList = List<MeasureUnit>();
    for (int i = 0; i < count; i++) {
      objectList.add(MeasureUnit.toMeasureUnit(mapList[i]));
    }
    return objectList;
  }

  //Get a MeasureUnit object
  Future<MeasureUnit> getAMeasureUnit(int id) async {
    List<Map<String, dynamic>> mapList = await getAMeasureUnitMap(id);
    MeasureUnit object = MeasureUnit.toMeasureUnit(mapList[0]);
    return object;
  }

  //Get MeasureUnit Filtered List
  Future<List<MeasureUnit>> getMeasureUnitFilteredList(String filter) async {
    List<Map<String, dynamic>> mapList =
        await getMeasureUnitFilteredMapList(filter);
    int count = mapList.length;
    List<MeasureUnit> objectList = List<MeasureUnit>();
    for (int i = 0; i < count; i++) {
      objectList.add(MeasureUnit.toMeasureUnit(mapList[i]));
    }
    return objectList;
  }

  //Get Food Filtered List
  Future<List<Food>> getFoodFilteredList(String filter) async {
    List<Map<String, dynamic>> mapList = await getFoodFilteredMapList(filter);
    int count = mapList.length;
    List<Food> objectList = List<Food>();
    for (int i = 0; i < count; i++) {
      objectList.add(Food.toFood(mapList[i]));
    }
    return objectList;
  }

  //Get DietSchedule List
  Future<List<DietSchedule>> getDietScheduleList() async {
    List<Map<String, dynamic>> mapList = await getDietScheduleMapList();
    int count = mapList.length;
    List<DietSchedule> objectList = List<DietSchedule>();
    for (int i = 0; i < count; i++) {
      objectList.add(DietSchedule.toDietSchedule(mapList[i]));
    }
    return objectList;
  }

  //Get a DietSchedule object
  Future<DietSchedule> getADietSchedule(int id) async {
    List<Map<String, dynamic>> mapList = await getADietScheduleMap(id);
    DietSchedule object = DietSchedule.toDietSchedule(mapList[0]);
    return object;
  }

  //Get Diet List
  Future<List<Diet>> getDietList() async {
    List<Map<String, dynamic>> mapList = await getDietMapList();
    int count = mapList.length;
    List<Diet> objectList = List<Diet>();
    for (int i = 0; i < count; i++) {
      objectList.add(Diet.toDiet(mapList[i]));
    }
    return objectList;
  }

  //Get Diet List of a specific Subscriber
  Future<List<Diet>> getDietListofSubscriber(int subscriberId) async {
    List<Map<String, dynamic>> theSubscriberDietMapList =
        await getSubscriberDietMapList(subscriberId);
    int count = theSubscriberDietMapList.length;
    List<Diet> dietListOfSubscriber = List<Diet>();
    List<Map<String, dynamic>> diet;
    int id;
    for (int i = 0; i < count; i++) {
      id = theSubscriberDietMapList[i]['dietId'];
      diet = await getDietMap(id);
      dietListOfSubscriber.add(Diet.toDiet(diet[0]));
    }
    return dietListOfSubscriber;
  }

  //Get Diet List of a specific Subscriber by Day
  Future<List<Diet>> getDayDietListofSubscriber(
      int subscriberId, String day) async {
    List<Map<String, dynamic>> theSubscriberDietMapList =
        await getSubscriberDietMapList(subscriberId);
    int count = theSubscriberDietMapList.length;
    List<Diet> dietListOfSubscriber = List<Diet>();
    List<Map<String, dynamic>> diet;
    int id;
    for (int i = 0; i < count; i++) {
      id = theSubscriberDietMapList[i]['dietId'];
      diet = await getDietMap(id);
      if (diet[0]['day'] == day || diet[0]['day'] == 'Todos') {
        dietListOfSubscriber.add(Diet.toDiet(diet[0]));
      }
    }
    return dietListOfSubscriber;
  }

  //Get SubscriberDiet
  Future<List<SubscriberDiet>> getSubscriberDietList(int subscriberId) async {
    List<Map<String, dynamic>> mapList =
        await getSubscriberDietMapList(subscriberId);
    int count = mapList.length;
    List<SubscriberDiet> objectList = List<SubscriberDiet>();
    for (int i = 0; i < count; i++) {
      objectList.add(SubscriberDiet.toSubscriberDiet(mapList[i]));
    }
    return objectList;
  }

  //Get ExerciseType List
  Future<List<ExerciseType>> getExerciseTypeList() async {
    List<Map<String, dynamic>> mapList = await getExerciseTypeMapList();
    int count = mapList.length;
    List<ExerciseType> objectList = List<ExerciseType>();
    for (int i = 0; i < count; i++) {
      objectList.add(ExerciseType.toExerciseType(mapList[i]));
    }
    return objectList;
  }

  //Get ExerciseType List filtered
  Future<List<ExerciseType>> getExerciseTypeFilteredList(String filter) async {
    List<Map<String, dynamic>> mapList =
        await getExerciseTypeFilteredMapList(filter);
    int count = mapList.length;
    List<ExerciseType> objectList = List<ExerciseType>();
    for (int i = 0; i < count; i++) {
      objectList.add(ExerciseType.toExerciseType(mapList[i]));
    }
    return objectList;
  }

  //Get Exercise List
  Future<List<Exercise>> getExerciseList() async {
    List<Map<String, dynamic>> mapList = await getExerciseMapList();
    int count = mapList.length;
    List<Exercise> objectList = List<Exercise>();
    for (int i = 0; i < count; i++) {
      objectList.add(Exercise.toExercise(mapList[i]));
    }
    return objectList;
  }

  //Get Exercise List of a specific Subscriber
  Future<List<Exercise>> getExerciseListofSubscriber(int subscriberId) async {
    List<Map<String, dynamic>> theSubscriberExerciseMapList =
        await getSubscriberExerciseMapList(subscriberId);
    int count = theSubscriberExerciseMapList.length;
    List<Exercise> exerciseListOfSubscriber = List<Exercise>();
    List<Map<String, dynamic>> exercise;
    int id;
    for (int i = 0; i < count; i++) {
      id = theSubscriberExerciseMapList[i]['exerciseId'];
      exercise = await getExerciseMap(id);
      exerciseListOfSubscriber.add(Exercise.toExercise(exercise[0]));
    }
    return exerciseListOfSubscriber;
  }

  //Get Exercise List of a specific Subscriber by day
  Future<List<Exercise>> getDayExerciseListofSubscriber(
      int subscriberId, String day) async {
    List<Map<String, dynamic>> theSubscriberExerciseMapList =
        await getSubscriberExerciseMapList(subscriberId);
    int count = theSubscriberExerciseMapList.length;
    List<Exercise> exerciseListOfSubscriber = List<Exercise>();
    List<Map<String, dynamic>> exercise;
    int id;
    for (int i = 0; i < count; i++) {
      id = theSubscriberExerciseMapList[i]['exerciseId'];
      exercise = await getExerciseMap(id);
      if (exercise[0]['day'] == day || exercise[0]['day'] == 'Todos') {
        exerciseListOfSubscriber.add(Exercise.toExercise(exercise[0]));
      }
    }
    return exerciseListOfSubscriber;
  }

  //Get SubscriberExercise
  Future<List<SubscriberExercise>> getSubscriberExerciseList(
      int subscriberId) async {
    List<Map<String, dynamic>> mapList =
        await getSubscriberExerciseMapList(subscriberId);
    int count = mapList.length;
    List<SubscriberExercise> objectList = List<SubscriberExercise>();
    for (int i = 0; i < count; i++) {
      objectList.add(SubscriberExercise.toSubscriberExercise(mapList[i]));
    }
    return objectList;
  }

  //Get question List by area 
  Future<List<Question>> getQuestionList(String area) async {
    List<Map<String, dynamic>> mapList = await getQuestionMapList(area);
    int count = mapList.length;
    List<Question> objectList = List<Question>();
    for (int i = 0; i < count; i++) {
      objectList.add(Question.toQuestion(mapList[i]));
    }
    return objectList;
  }

    //Get MultipleSelection by question Id List
  Future<List<MultipleSelection>> getMultipleSelectionList(int questionId) async {
    List<Map<String, dynamic>> mapList = await getMultipleSelectionMapList(questionId);
    int count = mapList.length;
    List<MultipleSelection> objectList = List<MultipleSelection>();
    for (int i = 0; i < count; i++) {
      objectList.add(MultipleSelection.toMultipleSelection(mapList[i]));
    }
    return objectList;
  }

    //Get Answers by subscriber Id and Area
  Future<List<Answer>> getAnswerListByArea(int subscriberId,String area) async {
    List<Map<String, dynamic>> mapList = await getAnswersMapListByArea(subscriberId,area);
    int count = mapList.length;
    List<Answer> objectList = List<Answer>();
    for (int i = 0; i < count; i++) {
      objectList.add(Answer.toAnswer(mapList[i]));
    }
    return objectList;
  }

    //Get Answer by subscriberId and questionId
  Future<List<Answer>> getAnAnswerByQuestionId(int subscriberId,int questionId) async {
    List<Map<String, dynamic>> mapList = await getAnswersMapByQuestionId(subscriberId,questionId);
    List<Answer> objectList = List<Answer>();
    int count = mapList.length;
    for (int i = 0; i < count; i++) {
      objectList.add(Answer.toAnswer(mapList[i]));
    }
    return objectList;
  }

    //Get Food Group List
  Future<List<FoodGroup>> getFoodGroupList() async {
    List<Map<String, dynamic>> mapList = await getFoodGroupMapList();
    int count = mapList.length;
    List<FoodGroup> objectList = List<FoodGroup>();
    for (int i = 0; i < count; i++) {
      objectList.add(FoodGroup.toFoodGroup(mapList[i]));
    }
    return objectList;
  }

  //Get a Food Group object
  Future<FoodGroup> getAFoodGroup(int id) async {
    List<Map<String, dynamic>> mapList = await getAFoodGroupMapById (id);
    FoodGroup object = FoodGroup.toFoodGroup(mapList[0]);
    return object;
  }

  //Get Food Portion List
  Future<List<FoodPortion>> getFoodPortionList() async {
    List<Map<String, dynamic>> mapList = await getFoodPortionMapList();
    int count = mapList.length;
    List<FoodPortion> objectList = List<FoodPortion>();
    for (int i = 0; i < count; i++) {
      objectList.add(FoodPortion.toFoodPortion(mapList[i]));
    }
    return objectList;
  }

    //Get Food Portion List by FoodGroup Id
  Future<List<FoodPortion>> getFoodPortionByFoodGroupIdList(int id) async {
    List<Map<String, dynamic>> mapList = await getFoodPortionByFoodGroupIdMapList(id);
    int count = mapList.length;
    List<FoodPortion> objectList = List<FoodPortion>();
    for (int i = 0; i < count; i++) {
      objectList.add(FoodPortion.toFoodPortion(mapList[i]));
    }
    return objectList;
  }

  //Get a Food Portion object
  Future<FoodPortion> getAFoodPortion(int id) async {
    List<Map<String, dynamic>> mapList = await getAFoodPortionMapById (id);
    FoodPortion object = FoodPortion.toFoodPortion(mapList[0]);
    return object;
  }

//----------------------------------------Find-------------------------------------------------
  //Find a Food by Name
  Future<List<Map<String, dynamic>>> findAFoodIdMap(String name) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db
        .rawQuery("SELECT $colId FROM $foodTable WHERE $colName='$name'");
    return result;
  }

  //Find a MeasureUnit by Name
  Future<List<Map<String, dynamic>>> findAMeasureUnitIdMap(String name) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT $colId FROM $measureUnitTable WHERE $colName='$name'");
    return result;
  }

  //Find a Schedule by Schedule
  Future<List<Map<String, dynamic>>> findADietScheduleIdMap(
      String schedule) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT $colId FROM $dietScheduleTable WHERE $colSchedule='$schedule'");
    return result;
  }

  //Find an ExerciseType by Name
  Future<List<Map<String, dynamic>>> findAnExerciseTypeIdMap(
      String name) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT $colId FROM $exerciseTypeTable WHERE $colName='$name'");
    return result;
  }
}
