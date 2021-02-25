class TrainerCredentials{
  int _trainerId;
  String _username;
  String _password;

  TrainerCredentials(this._trainerId,this._username,this._password);

  int get trainerId=>_trainerId;
  String get username=>_username;
  String get password=>_password;

  set trainerId(int newTrainerID){
    this._trainerId=newTrainerID;
  }
  set username(String newUsername){
    this._username=newUsername;
  }
  set password(String newPassword){
    this._password=newPassword;
  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = Map<String,dynamic>();
    map['trainerId']=_trainerId;
    map['username']=_username;
    map['password']=_password;
    return map;
  }

  TrainerCredentials.toTrainerCredentials(Map<String,dynamic> map){
    this._trainerId=map['trainerId'];
    this._username=map['username'];
    this._password=map['password'];
  }
}