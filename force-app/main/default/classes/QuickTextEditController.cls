/**
* File :QuickTextEditController.cls
* Description :It implements the logic to modify the QuickText object records.
* Created Date : 14/Jul/2017
* Author : RDC
*/

public with sharing class QuickTextEditController {
    
    public string quickText{set;get;}
    public string quickTextId{set;get;}
    public List<SelectOption> quickList {get;set;}
    public List<QuickText> quickTextList{set;get;}
    public String message{get;set;}
    public String category{get;set;}
    public QuickTextEditController(){
        quickList = new List<SelectOption>();
        quickTextList  = [SELECT Id,Name FROM QuickText];
        quickList.add(new SelectOption('None','None'));
        for(QuickText temp : quickTextList){
            quickTextId = temp.id;
            quickList.add(new SelectOption(temp.Id, temp.Name));   
        }
        if(quickText == null ){
            quickText = 'None';
            updateList();
        }
        
    }
    public PageReference updateList() {
        getprops();
        return null;
    }
    public void getProps() {
        if(quickText != 'None'){
            QuickText quickTextRecord = [Select Id,Name,Message,Category From QuickText where Id =: quickText ];
            message = quickTextRecord.Message;
            category = quickTextRecord.Category;
        }
        else{
            message='';
            category='Greetings'; 
        }
    } 
    public List<SelectOption> getCategories() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Greetings','Greetings'));
        options.add(new SelectOption('FAQ','FAQ'));
        options.add(new SelectOption('Closings','Closings'));
        return options;
    }
    public PageReference save(){
        try{
        if(quickText == 'None'){
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Error, 'Please select a QuickText to edit.') );
        }
        else{
            QuickText quickTextRecord = [Select Id,Name,Message,Category From QuickText where Id =: quickText ];
            quickTextRecord.Message = message;
            quickTextRecord.Category = category;
            update quickTextRecord;
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Confirm, 'Quick Text is updated') );
        }
        }catch (Exception e) {
            ExceptionHandler.postToAll(e, true);
        }
        
        return null;
    }
    public PageReference cancel(){
        Updatelist();
        return null;
    }
    
}