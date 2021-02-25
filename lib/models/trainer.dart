class Trainer {
  int _id;
  String _name;
  int _subscriberQuantity;
  String _picturePointer;

  Trainer(this._name,this._subscriberQuantity,[this._picturePointer]);
  Trainer.withId(this._id,this._name,this._subscriberQuantity,[this._picturePointer]);

  int get id =>_id;
  String get name => _name;
  int get subscriberQuantity => _subscriberQuantity;
  String get picturePointer => _picturePointer;

   set name(String newName){
    if (newName.length <= 255){
      this._name = newName;
    }
  }

  set subscriberQuantity(int newQuantity){
    this._subscriberQuantity = newQuantity;
  }

  set picturePointer(String newPicturePointer){
    this._picturePointer = newPicturePointer;
  }

  //Convert a Trainer object into a Map object
  Map<String,dynamic> toMap(){
    Map<String, dynamic> map = Map<String, dynamic>();
    if (_id !=null){
      map['id'] = _id;
    }
    map['name'] = _name;
    map['subscriberQuantity'] = _subscriberQuantity;
    map['picturePointer'] = _picturePointer;
    return map;
  }

  //Convert a Map Object into a Trainer
  Trainer.toTrainer(Map<String,dynamic>map){
    this._id = map['id'];
    this._name = map['name'];
    this._subscriberQuantity = map['subscriberQuantity'];
    this._picturePointer = map['picturePointer'];
  }
}