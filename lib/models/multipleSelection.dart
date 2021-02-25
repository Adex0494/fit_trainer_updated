class MultipleSelection{
  int _id;
  int _questionId;
  String _possibleSelection;
  String _questionArea;

  MultipleSelection(this._questionId,this._possibleSelection,this._questionArea);
  MultipleSelection.withId(this._id,this._questionId,this._possibleSelection,this._questionArea);

  int get id =>_id;
  int get questionId=>_questionId;
  String get possibleSelection=>_possibleSelection;
  String get questionArea=>_questionArea;

  set questionId(int newId){
    this._questionId=newId;
  }
  set possibleSelection(String newSelection){
    this._possibleSelection=newSelection;
  }
    set questionArea(String newArea){
    this._questionArea=newArea;
  }


  
  Map<String,dynamic> toMap(){
    Map<String,dynamic> map=Map<String,dynamic>();
    if(this._id!=null)
      map['id']=_id;
    map['questionId']=_questionId;
    map['possibleSelection']=_possibleSelection;
    map['questionArea']=_questionArea;
    return map;
  }

    MultipleSelection.toMultipleSelection(Map<String,dynamic>map){
    this._id=map['id'];
    this._questionId=map['questionId'];
    this._possibleSelection=map['possibleSelection'];
    this._questionArea=map['questionArea'];
  }

}