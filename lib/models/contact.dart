class Contact {
  int _id;
  int _subscriberId;
  String _contact;
  String _contactType;//'C' for cell phone. 'T' for telephone. 'W' for work. 'E' for e-mail

  Contact(this._subscriberId,this._contact,this._contactType);
  Contact.withId(this._id,this._contact,this._contactType);

  int get id => _id;
  int get subscriberId => _subscriberId;
  String get contact => _contact;
  String get contactType => _contactType;

  set contact(String newContact){
    if(newContact.length<=255){
      this._contact =newContact;
    }
  }
  set subscriberId(int newId){
    this._subscriberId=newId;
  }
  set contactType(String newContactType){
    if(newContactType =='C'||newContactType =='T'||newContactType =='W'||newContactType =='E'){
      this._contact =newContactType;
    }
  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = Map<String,dynamic>();
    if(_id !=null){
      map['id'] =_id;
    }
    if(_subscriberId !=null){
      map['subscriberId'] =_subscriberId;
    }
    map['contact'] =_contact;
    map['contactType'] =_contactType;
    return map;
  }

  Contact.toContact(Map<String,dynamic>map){
    this._id = map['id'];
    this._subscriberId = map['subscriberId'];
    this._contact= map['contact'];
    this._contactType= map['contactType'];
  }
}