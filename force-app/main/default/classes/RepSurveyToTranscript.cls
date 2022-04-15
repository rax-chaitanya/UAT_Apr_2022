/**
* File :  RepSurveyToTranscript.cls
* Description :It handles the beforeInsertEvent to the AssociateRepSurveyToTranscript Trigger
* Created Date : 23/Aug/2017 
* Author : RDC
*/

public class RepSurveyToTranscript{
   /*
     public RepSurveyToTranscript(List<Rep_Chat_Survey__c> surveys ){
        List<LiveChatTranscript> Transcripts= new List<LiveChatTranscript>();
        List<Rep_Chat_Survey__c> surveystoUpdate= new List<Rep_Chat_Survey__c>();
        List<String> chatKeys= new List<String>();
 
        for(Rep_Chat_Survey__c rec: surveys){
            chatKeys.add(rec.chatkey__c);      
        }
 
        if(chatKeys.size()>0)
            Transcripts=[select id, chatkey from LiveChatTranscript Where chatkey IN: chatKeys]; // Look for transcripts created with the chat keys
 
        List<Rep_Chat_Survey__c> existingSurvey= [Select id, Live_Chat_Transcript__r.id,Live_Chat_Transcript__r.chatkey from Rep_Chat_Survey__c where Live_Chat_Transcript__r.id IN:transcripts ];   
        List<Rep_Chat_Survey__c> FinalSurveys=new List<Rep_Chat_Survey__c>();
 
        if(existingSurvey.size()>0){
            for(Rep_Chat_Survey__c existingrec: existingSurvey){
                for(Rep_Chat_Survey__c recs:surveys){
                    if(existingrec.Live_Chat_Transcript__r.chatkey != recs.chatkey__c){
                        FinalSurveys.add(recs);
                    }
                }
            }
        } 
        else{
            finalSurveys=Surveys; 
        }
       
        if(Transcripts.size()>0 && FinalSurveys.size()>0){ 
            for(Rep_Chat_Survey__c rec:FinalSurveys){           
                for(livechatTranscript LScript: Transcripts){
                    if(rec.chatkey__c== LScript.chatkey){
                        rec.Live_Chat_Transcript__c=Lscript.id;
                        surveystoUpdate.add(rec);
                    }
                }
             }
        }
    }
    */
}