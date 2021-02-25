class DietSchedule{
  int _id;
  String _schedule;

  DietSchedule(this._schedule);
  DietSchedule.withId(this._id,this._schedule);

  int get id => _id;
  String get name => _schedule;

  set name(String newName){
    if(newName.length<=255){
      this._schedule =newName;
    }
  }

  Map<String,dynamic> toMap(){
  Map<String,dynamic> map = Map<String,dynamic>();
  if(_id !=null){
    map['id'] =_id;
  }
  map['schedule'] =_schedule;
  return map;
  }

  DietSchedule.toDietSchedule(Map<String,dynamic>map){
    this._id = map['id'];
    this._schedule= map['schedule'];
  }
}