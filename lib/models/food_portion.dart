class FoodPortion{
  int _id;
  int _foodGroupId;
  String _foodPortionName;
 

  FoodPortion(this._foodGroupId,this._foodPortionName,);
  FoodPortion.withId(this._id,this._foodGroupId,this._foodPortionName,);

  int get id => _id;
  int get foodGroupId=>_foodGroupId;
  String get foodPortionName=> _foodPortionName;

  set foodGroupId(int newId){
    this._foodGroupId=newId;
  }

  set foodPortionName(String newFoodPortionName){
    this._foodPortionName=newFoodPortionName;
  }


  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = Map<String,dynamic>();
    if(_id !=null){
      map['id'] =_id;
    }
    map['foodGroupId'] =_foodGroupId;
    map['foodPortionName'] =_foodPortionName;

    return map;
  }

  FoodPortion.toFoodPortion(Map<String,dynamic>map){
    this._id = map['id'];
    this._foodGroupId = map['foodGroupId'];
    this._foodPortionName = map['foodPortionName'];

  }
}