class Subscriber {
  int _id;
  int _trainerId;
  String _name;
  String _birthdate;
  String _gender;
  String _address;
  String _objective;
  double _weight;// In pounds
  int _height; // Input:foot and inches. Internallly saved in cm.
  double _fatPercentage;
  String _physicalCondition;// Based on Cooper Test
  double _activityFactor; //Level of activity required to determine diet
  int _hydrationLevel;
  double _bodyMassIndex;// Body Mass Index
  String _picturePointer;

  Subscriber(this._trainerId,this._name,this._birthdate,this._gender,this._address,this._objective,
  [this._weight,this._height,this._fatPercentage,this._physicalCondition,this._activityFactor,this._hydrationLevel,
  this._bodyMassIndex,this._picturePointer]);
  Subscriber.withId(this._id,this._trainerId,this._name,this._birthdate,this._gender,this._address,
  [this._objective,this._weight,this._height,this._fatPercentage,this._physicalCondition,this._activityFactor,this._hydrationLevel,
  this._bodyMassIndex,this._picturePointer]);

  int get id => _id;
  int get trainerId => _trainerId;
  String get name => _name;
  String get birthdate => _birthdate;
  String get gender => _gender;
  String get address => _address;
  String get objective => _objective;
  double get weight => _weight;
  int get height => _height;
  double get fatPercentage => _fatPercentage;
  String get physicalCondition=> _physicalCondition;
  double get activityFactor=> _activityFactor;
  int get hydrationLevel => _hydrationLevel;
  double get bodyMassIndex => _bodyMassIndex;
  String get picturePointer => _picturePointer;

  set name (String newName){
    if (newName.length <=255){
      this._name = newName;
    }
  }

  set trainerId(int newId){
    this._trainerId = newId;
  }

  set birthdate(String newbirthdate){
    this._birthdate = newbirthdate;
  }

  set address(String newAddress){
    this._address = newAddress;
  }

  set gender(String newGender){
    this._gender = newGender;
  }


  set objective(String newObjective){
    this._objective = newObjective;
  }

  set weight(double newWeight){
    this._weight = newWeight;
  }

  set height(int newHeight){
    this._height = newHeight;
  }

  set fatPercentage(double newFatPercentage){
    this._fatPercentage = newFatPercentage;
  }

  set hydrationLevel(int newHydrationLevel){
    this._hydrationLevel = newHydrationLevel;
  }

  set physicalCondition(String newPhysicalCondition){
    this._physicalCondition=newPhysicalCondition;
  }

  set activityFactor(double newActivityFactor)
  {
    this._activityFactor=newActivityFactor;
  }

  set bodyMassIndex(double newbodyMassIndex){
    this._bodyMassIndex = newbodyMassIndex;
  }

  set picturePointer(String newPicturePointer){
    this._picturePointer = newPicturePointer;
  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = Map<String,dynamic>();
    if (_id != null){
      map['id'] = _id;
    }
    map['trainerId'] = _trainerId;
    map['name'] = _name;
    map['birthdate'] = _birthdate;
    map['gender'] = _gender; //M for Male. F for Female.
    map['address'] = _address;
    map['objective'] = _objective;
    map['fatPercentage'] = _fatPercentage;
    map['physicalCondition'] = _physicalCondition;
    map['activityFactor'] = _activityFactor;
    map['weight'] = _weight;
    map['height'] = _height;
    map['bodyMassIndex'] = _bodyMassIndex;
    map['hydrationLevel'] = _hydrationLevel;
    map['picturePointer'] = _picturePointer;
    return map;
  }

  Subscriber.toSubscriber(Map<String,dynamic> map){
    this._id = map['id'];
    this._trainerId = map['trainerId'];
    this._name = map['name'];
    this._birthdate = map['birthdate'];
    this._gender = map['gender'];
    this._address = map['address']; 
    this._objective = map['objective']; 
    this._fatPercentage = map['fatPercentage'];
    this._physicalCondition = map['physicalCondition'];
    this._activityFactor=map['activityFactor'];
    this._weight = map['weight'];
    this._height = map['height'];
    this._bodyMassIndex = map['bodyMassIndex']; 
    this._hydrationLevel = map['hydrationLevel']; 
    this._picturePointer = map['picturePointer'];
  }

}