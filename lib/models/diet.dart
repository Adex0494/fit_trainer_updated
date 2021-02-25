

class Diet{
  int _id;
  int _foodId;
  double _quantity;
  String _day;
  int _measureUnitId;
  int _scheduleId;

  Diet(this._foodId,this._measureUnitId,this._scheduleId,this._quantity,this._day);
  Diet.withId(this._id,this._quantity,this._day);

  int get id => _id;
  int get foodId => _foodId;
  double get quantity => _quantity;
  String get day => _day;
  int get measureUnitId => _measureUnitId;
  int get scheduleId => _scheduleId;

  set quantity (double newQuantity){
    this._quantity = newQuantity;
  }
  set day (String newDay){
    this._day = newDay;
  }
    set foodId(int newId){
    this._foodId=newId;
  }
    set measureUnitId(int newId){
    this._measureUnitId=newId;
  }
    set scheduleId(int newId){
    this._scheduleId=newId;
  }


  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = Map<String,dynamic>();
    if(_id !=null){
      map['id'] =_id;
    }
    if(_foodId !=null){
      map['foodId'] =_foodId;
    }
    if(_measureUnitId !=null){
      map['measureUnitId'] =_measureUnitId;
    }
    if(_scheduleId !=null){
    map['scheduleId'] =_scheduleId;
    }
    map['quantity'] =_quantity;
    map['day'] =_day;
    return map;
  }


  Diet.toDiet(Map<String,dynamic>map){
    this._id = map['id'];
    this._foodId= map['foodId'];
    this._measureUnitId=map['measureUnitId'];
    this._scheduleId=map['scheduleId'];
    this._quantity =map['quantity'];
    this._day=map['day'];
  }
}