public without sharing class RepPostChatSurveyController {
    @AuraEnabled
    public static Integer getSurveyCount(String recordId) {
        return [Select COUNT() from Rep_Chat_Survey__c where Live_Chat_Transcript__c = :recordId];
    }

    
    @AuraEnabled
    public static String saveSurvey(Rep_Chat_Survey__c survey) {
        System.debug('survey: ' + survey);
        insert survey;
        return survey.Id;
        
    }
}