@isTest
Public class CreateAccountContactRole_test{
Static testMethod void createcontact(){
Contact con =New Contact();

Con.Firstname='Test';
//insert con;
try{
CreateAccountContactRole.getDetailsFromContact('');
}catch(exception e){}
}
}