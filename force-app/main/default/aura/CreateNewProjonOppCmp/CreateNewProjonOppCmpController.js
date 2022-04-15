({
 doInit: function(component, event, helper) {
      //call the helper function with pass [component, Controller field and Dependent Field] Api name 
     
      helper.fetchListOfRecordTypes(component, event, helper);
    
      
   },
   /* On the component Load this function call the apex class method, 
    * which is return the list of RecordTypes of object 
    * and set it to the lstOfRecordType attribute to display record Type values
    * on ui:inputSelect component. */
 
   
 
   /* In this "createRecord" function, first we have call apex class method 
    * and pass the selected RecordType values[label] and this "getRecTypeId"
    * apex method return the selected recordType ID.
    * When RecordType ID comes, we have call  "e.force:createRecord"
    * event and pass object API Name and 
    * set the record type ID in recordTypeId parameter. and fire this event
    * if response state is not equal = "SUCCESS" then display message on various situations.
    */
  
 
   closeModal: function(component, event, helper) {
      // set "isOpen" attribute to false for hide/close model box 
      component.set("v.isOpen", false);
   },
 
   openModal: function(component, event, helper) {
      // set "isOpen" attribute to true to show model box
      component.set("v.isOpen", true);
   },
     createRecord: function(component, event, helper) {
         helper.createRecord(component, event ,helper);
          
   },
    
})