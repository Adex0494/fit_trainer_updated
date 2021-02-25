class Question{
  int _id;
  String _area;//H for health. HB for Habit
  String _type;//YN for yes no question. MS for multiple selection. OA for open answer
  String _question;
  int _emphasis; //1 if positive answer is dangerous, in YN type
  int _position;
  int _postQuestionId;//A question that depends on this question if answer is yes.

  Question(this._area,this._type,this._question,this._emphasis,this._position,[this._postQuestionId]);
  Question.withId(this._id,this._area,this._type,this._question,this._emphasis,this._position,[this._postQuestionId]);

  int get id=>_id;
  String get area=>_area;
  String get type=>_type;
  String get question=>_question;
  int get emphasis=>_emphasis;
  int get position=>_position;
  int get postQuestionId=>_postQuestionId;

  set area(String newArea){
    this._area=newArea;
  }
  set type(String newType){
    this._type=newType;
  }
  set question(String newQuestion){
    this._question=newQuestion;
  }
  set emphasis(int newInt){
    this._emphasis=newInt;
  }
  set position(int newInt){
    this._position=newInt;
  }
  set postQuestionId(int newId){
    this._postQuestionId=newId;
  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = Map<String,dynamic>();
    if(this._id!=null)
      map['id']=_id;
    map['area']=_area;
    map['type']=_type;
    map['question']=_question;
    map['emphasis']=_emphasis;
    map['position']=_position;
    map['postQuestionId']=_postQuestionId;
    return map;
  }

  Question.toQuestion(Map<String,dynamic> map){
    this._id= map['id'];
    this._area=map['area'];
    this._type= map['type'];
    this._question= map['question'];
    this._emphasis = map['emphasis'];
    this._position=map['position'];
    this._postQuestionId= map['postQuestionId'];
  }
}