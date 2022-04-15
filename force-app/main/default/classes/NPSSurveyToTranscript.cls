/**
* File :  NPSSurveyToTranscript.cls
* Description :It handles the beforeInsertEvent to the AssociateNPSSurveyToTranscript Trigger
* Created Date : 23/Aug/2017 
* Author : RDC
*/

Public class NPSSurveyToTranscript {

    public static void beforeInsertEvent(List<NPS_Survey__c> newList){
        List<NPS_Survey__c> surveys=newList;
        List<LiveChatTranscript> Transcripts= new List<LiveChatTranscript>();
        List<NPS_Survey__c> surveystoUpdate= new List<NPS_Survey__c>();
        List<String> chatKeys= new List<String>();
            for(NPS_Survey__c rec: surveys){
                if(String.isNotBlank(rec.chatkey__c)){
                chatKeys.add(rec.chatkey__c);
                }
        }
        if(chatKeys.size()>0)
            Transcripts=[select id, chatkey from LiveChatTranscript Where chatkey IN: chatKeys];
        if(Transcripts.size()>0){ // if Transcript was created before Survey was submitted
            for(NPS_Survey__c rec:surveys){
                for(livechatTranscript LScript: Transcripts){
                    if(rec.chatkey__c== LScript.chatkey){
                        rec.Live_Chat_Transcript__c=Lscript.id;
                        surveystoUpdate.add(rec);
                        }
                }
            }
        }
        if(surveystoUpdate.size()>0){
                
        }
    }
}