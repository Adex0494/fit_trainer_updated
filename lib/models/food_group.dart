class FoodGroup{
  int _id;
  String _foodGroupName;
  int _prot;
  int _lip;
  int _hc;

  FoodGroup(this._foodGroupName,this._prot,this._lip,this._hc);
  FoodGroup.withId(this._id,this._foodGroupName,this._prot,this._lip,this._hc);

  int get id => _id;
  String get foodGroupName=> _foodGroupName;
  int get prot=>_prot;
  int get lip=>_lip;
  int get hc=>_hc;

  set foodGroupName(String newFoodGroupName){
    this._foodGroupName=newFoodGroupName;
  }

  set prot(int newProt){
    this._prot=newProt;
  }

  set lip (int newLip){
    this._lip=newLip;
  }

  set hc(int newHc){
    this._hc=newHc;
  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = Map<String,dynamic>();
    if(_id !=null){
      map['id'] =_id;
    }
    map['foodGroupName'] =_foodGroupName;
    map['prot']=_prot;
    map['lip']=_lip;
    map['hc']=_hc;
    return map;
  }

  FoodGroup.toFoodGroup(Map<String,dynamic>map){
    this._id = map['id'];
    this._foodGroupName = map['foodGroupName'];
    this._prot= map['prot'];
    this._lip =map['lip'];
    this._hc =map['hc'];
  }
}