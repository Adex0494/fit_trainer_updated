class SubscriberExercise{
  int _subscriberId;
  int _exerciseId;

  SubscriberExercise(this._subscriberId,this._exerciseId);

  int get subscriberId => _subscriberId;
  int get exerciseId => _exerciseId;

  
  set subscriberId(int newId){
    this._subscriberId=newId;
  }
  set exerciseId(int newId){
    this._exerciseId=newId;
  }


  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = Map<String,dynamic>();
    if(_subscriberId !=null){
      map['subscriberId'] =_subscriberId;
    }
    if(_exerciseId !=null){
      map['exerciseId'] =_exerciseId;
    }
    return map;
  }

  SubscriberExercise.toSubscriberExercise(Map<String,dynamic>map){
    this._subscriberId = map['subscriberId'];
    this._exerciseId = map['exerciseId'];
  }
}