class Exercise {
  int _id;
  int _exerciseTypeId;
  int _sessionQuantity;
  String _unitType; //'T' for time. 'R' for repetitions
  String _restingTimeUnit;
  double _restingTime; //in seconds or minutes
  String _day;
  String _timeUnit; //'S' for seconds. 'M' for minutes
  double _timeUnitQuantity; //Quantity of seconds or minutes
  int _repetitionQuantity;
 

  Exercise(this._exerciseTypeId,this._sessionQuantity,this._unitType,this._restingTimeUnit, this._restingTime,
  this._day,[this._timeUnit,this._timeUnitQuantity,this._repetitionQuantity]);
  Exercise.withId(this._id,this._sessionQuantity,this._unitType,this._restingTimeUnit,this._restingTime,
  this._day,[this._timeUnit,this._timeUnitQuantity,this._repetitionQuantity]);

  int get id => _id;
  int get exerciseTypeId => _exerciseTypeId;
  int get sessionQuantity => _sessionQuantity;
  String get unitType => _unitType;
  String get restingTimeUnit=>_restingTimeUnit;
  double get restingTime => _restingTime;
  String get day => _day;
  String get timeUnit => _timeUnit;
  double get timeUnitQuantity => _timeUnitQuantity;
  int get repetitionQuantity => _repetitionQuantity;

  set exerciseTypeId(int newId){
    this._exerciseTypeId=newId;
  }
  set sessionQuantity(int newQuantity){
    this._sessionQuantity = newQuantity;
  }
  set unitType (String newUnit){
    if (newUnit == 'T' || newUnit == 'R'){
      this._unitType = newUnit;
    }
  }
  set restingTimeUnit (String newUnit){
    if (newUnit == 'M' || newUnit == 'S'){
      this._restingTimeUnit = newUnit;
    }
  }
  set restingTime(double newTime){
    this._restingTime = newTime;
  }
  set day(String newDay){
    this._day = newDay;
  }
  set timeUnit(String newUnit){
    if(newUnit =='M' || newUnit =='S'){
      this._timeUnit = newUnit;
    }
  }
  set timeUnitQuantity(double newQuantity){
    this._timeUnitQuantity = newQuantity;
  }
  set repetitionQuantity(int newQuantity){
    this._repetitionQuantity = newQuantity;
  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = Map<String,dynamic>();
    if (_id != null){
      map['id'] = _id;
    }
     if (_exerciseTypeId != null){
      map['exerciseTypeId'] = _exerciseTypeId;
    }
    map['sessionQuantity'] = _sessionQuantity;
    map['unitType'] =_unitType;
    map['timeUnit'] = _timeUnit;
    map['timeUnitQuantity'] = _timeUnitQuantity;
    map['repetitionQuantity'] = _repetitionQuantity;
    map['restingTimeUnit'] = _restingTimeUnit;
    map['restingTime'] = _restingTime;
    map['day'] = _day;
    return map;
  }

  Exercise.toExercise(Map<String,dynamic> map){
    this._id = map['id'];
    this._exerciseTypeId = map['exerciseTypeId'];
    this._sessionQuantity = map['sessionQuantity'];
    this._unitType = map['unitType'];
    this._timeUnit = map['timeUnit'];
    this._timeUnitQuantity = map['timeUnitQuantity'];
    this._repetitionQuantity = map['repetitionQuantity'];
    this._restingTimeUnit= map['restingTimeUnit'];
    this._restingTime = map['restingTime'];
    this._day = map['day'];
  }
}