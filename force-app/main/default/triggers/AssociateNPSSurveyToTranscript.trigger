/**
* File :  AssociateNPSSurveyToTranscript.Apxt
* Description : If Live Chat Transcript was created before Customer submits the survey, 
				this trigger looks up for created Transcript and links it with the post chat survey.
* Created Date : 23/Aug/2017 
* Author : RDC
*/

trigger AssociateNPSSurveyToTranscript on NPS_Survey__c(before insert) {

    
    NPSSurveyToTranscript.beforeInsertEvent(Trigger.New);  
    
}