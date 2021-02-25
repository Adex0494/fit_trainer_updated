class MeasureUnit{
  int _id;
  String _name;

  MeasureUnit(this._name);
  MeasureUnit.withId(this._id,this._name);

  int get id => _id;
  String get name => _name;

  set name(String newName){
    if(newName.length<=255){
      this._name =newName;
    }
  }

  Map<String,dynamic> toMap(){
  Map<String,dynamic> map = Map<String,dynamic>();
  if(_id !=null){
    map['id'] =_id;
  }
  map['name'] =_name;
  return map;
  }

  MeasureUnit.toMeasureUnit(Map<String,dynamic>map){
    this._id = map['id'];
    this._name= map['name'];
  }
  
}