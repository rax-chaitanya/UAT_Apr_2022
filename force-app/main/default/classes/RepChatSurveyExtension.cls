/**
* File :  RepChatSurveyExtension.cls
* Description :It is StandardController to the RepPostChatSurvey.
* Created Date : 20/Jul/2017 
* Author : RDC
*/

public with sharing class RepChatSurveyExtension {
/*public Rep_Chat_Survey__c survey{get;set;}
public String chatKey {get;set;}
public String transcriptId{get;set;}
Boolean isDisabled = false;


    public RepChatSurveyExtension(ApexPages.StandardController controller) {
    chatKey = ApexPages.CurrentPage().getParameters().get('chatKey');
    transcriptId = ApexPages.CurrentPage().getParameters().get('transcriptId');
    survey = (Rep_Chat_Survey__c)controller.getrecord();
    
    }
public PageReference ReadChatKey(){
      //  chatKey = ApexPages.CurrentPage().getParameters().get('chatKey');
       chatKey = System.currentPagereference().getParameters().get('chatKey');
        survey.ChatKey__c = chatKey;
        survey.CurrencyIsoCode = 'USD';
        return null;
}
    public PageReference save(){
        survey.ChatKey__c = chatKey;
        survey.CurrencyIsoCode = 'USD';
        survey.Live_Chat_Transcript__c = transcriptId;
        insert survey;
        this.isDisabled = true;
        PageReference newPage = Page.RepPostChatSurveySuccesspage;
        // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Feedback is submitted.'));
        
        return newPage;
        
    }
    
    public Boolean getIsDisabled(){
        return this.isDisabled;
    }*/
}