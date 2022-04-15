/**
* File :  AssociateRepSurveyToTranscript.Apxt
* Description : If Live Chat Transcript was created before Customer submits the survey, 
                this trigger looks up for created Transcript and links it with the Rep chat survey.
* Created Date : 23/Aug/2017 
* Author : RDC
*/

trigger AssociateRepSurveyToTranscript on Rep_Chat_Survey__c (before insert) {
  //  RepSurveyToTranscript obj = new RepSurveyToTranscript(trigger.new);
}