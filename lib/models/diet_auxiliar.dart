
class DietAuxiliar{
  String _foodName;
  String _measureUnitName;
  String _dietSchedule;
  String _quantity;
  DietAuxiliar(this._foodName,this._measureUnitName,this._dietSchedule,this._quantity);

  get foodName=>_foodName;
  get measureUnitName=>_measureUnitName;
  get dietSchedule=>_dietSchedule;
  get quantity=>_quantity;
  set foodName(String newName){
    if(newName.length<=255){
      this._foodName=newName;
    }
  }
  set measureUnitName(String newName){
    if(newName.length<=255){
      this._measureUnitName=newName;
    }
  }
  set dietSchedule(String newSchedule){
    if(newSchedule.length<=255){
      this._dietSchedule=newSchedule;
    }
  }
  set quantity(String newQuantity){
    this._quantity=newQuantity;
  }
}