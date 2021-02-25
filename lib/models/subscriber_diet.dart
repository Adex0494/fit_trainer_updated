class SubscriberDiet{
  int _id;
  int _subscriberId;
  int _dietId;

  SubscriberDiet(this._subscriberId,this._dietId);
  SubscriberDiet.withId(this._id,this._subscriberId,this._dietId);

  int get id=>_id;
  int get subscriberId => _subscriberId;
  int get dietId => _dietId;

  set subscriberId(int newId){
    this._subscriberId=newId;
  }
  set dietId(int newId){
    this._dietId=newId;
  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = Map<String,dynamic>();
    if(_id !=null){
      map['id'] =_id;
    }    
    if(_subscriberId !=null){
      map['subscriberId'] =_subscriberId;
    }
    if(_dietId !=null){
      map['dietId'] =_dietId;
    }
    return map;
  }

  SubscriberDiet.toSubscriberDiet(Map<String,dynamic>map){
    this._id =map['id'];
    this._subscriberId= map['subscriberId'];
    this._dietId= map['dietId'];
  }
}