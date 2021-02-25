class Answer{
  int _id;
  int _questionId;
  int _subscriberId;
  String _answer;
  String _questionArea;

  Answer(this._questionId,this._subscriberId,this._answer,this._questionArea);
  Answer.withId(this._id,this._questionId,this._subscriberId,this._answer,this._questionArea);

  int get id=>_id;
  int get questionId=>_questionId;
  int get subscriberId=>_subscriberId;
  String get answer=>_answer;
  String get questionArea=>_questionArea;

  set questionId (int newId){
    this._questionId=newId;
  }
  set subscriberId(int newId){
    this._subscriberId=newId;
  } 
  set answer(String newAnswer){
    this._answer=newAnswer;
  }
  set questionArea(String newArea){
    this._questionArea=newArea;
  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map=Map<String,dynamic>();
    if(this._id!=null)
      map['id']=_id;
    map['questionId']=_questionId;
    map['subscriberId']=_subscriberId;
    map['answer']=_answer;
    map['questionArea']=_questionArea;
    return map;
  }

  Answer.toAnswer(Map<String,dynamic>map){
    this._id=map['id'];
    this._questionId=map['questionId'];
    this._subscriberId=map['subscriberId'];
    this._answer=map['answer'];
    this._questionArea=map['questionArea'];
  }
}