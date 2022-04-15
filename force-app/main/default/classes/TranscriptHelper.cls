public class TranscriptHelper{
    public static void populateLPID(list<livechattranscript>translist, map<id,sobject>translist_old){
        Map<id,String> rackid_map = new Map<id,String>();
        List<Lead> leadsToUpdate = new List<Lead>();
        LiveChatTranscript old_lct = new LiveChatTranscript();
        for(LiveChatTranscript lct : translist){
            old_lct = (LiveChatTranscript)translist_old.get(lct.id);
            if(old_lct.RackUid__c != lct.RackUid__c){
                if(lct.leadid!=null){
                    rackid_map.put(lct.leadid,lct.RackUid__c);
                }
            }
            else if(old_lct.leadid!= lct.leadid){
                    rackid_map.put(lct.leadid,lct.RackUid__c);
            }
        }
        
        list<Lead> lead_list = [select id,LPID__c from Lead where id in :rackid_map.keyset() ];
        if(!lead_list.isEmpty()){
            for(lead l: lead_list){
                l.LPID__c = rackid_map.get(l.id);
                leadsToUpdate.add(l);
            }
        update leadsToUpdate;
        }
    }
    
}