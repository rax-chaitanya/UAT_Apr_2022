/**********************************************************************************

Author: Pradeep Guttha
Description: This apex class is created to reparent QuoteLines to a Dummy Opportunity Stored in 
Label.QLDeleteOppID. In this way Quote Lines can be removed from the Original Opportunity and then deleted 
through a batch process or weekly cleanup.
**********************************************************************************/
public class DeleteOppQuoteLines
{
    public static void DeleteQuoteLines()
    {     
      
      Map<String,Set<Id>> OppMap = new Map<String,Set<Id>>();

          for(Opportunity opp : (List<Opportunity>)Trigger.new)
          {
              if(String.isNotBlank(opp.Delete_QL__c) && ((Map<Id, Opportunity>)Trigger.oldMap).get(opp.Id).Delete_QL__c != opp.Delete_QL__c)
              {                  
                  if(OppMap.get(opp.Delete_QL__c) != null)
                    OppMap.get(opp.Delete_QL__c).add(opp.Id);  
                  else
                    OppMap.put(opp.Delete_QL__c,new Set<Id>{opp.Id});
              }       
          } 

          if(OppMap.size() > 0)
          {
          if(OppMap.get('All') != null)
          {
              
              List<Quote_Line__c > sfdcList = new List<Quote_Line__c >();
              
              for(Quote_Line__c dev:[SELECT Id, Opportunity_Quote__c FROM Quote_Line__c  WHERE Opportunity_Quote__c IN : OppMap.get('All')])
              {
                dev.Opportunity_Quote__c = Label.QLDeleteOppID;
                sfdcList.add(dev);
              }
              
              if(sfdcList.size() > 0)
                update sfdcList;
          }
          else if(OppMap.get('Migrate') != null)
          {   
              
              List<Quote_Line__c> sfdcList = new List<Quote_Line__c >();
              
              for(Quote_Line__c dev:[SELECT Id, Opportunity_Quote__c FROM Quote_Line__c  WHERE Opportunity_Quote__c IN : OppMap.get('Migrate') AND Migration_Device__c = true])
              {
                dev.Opportunity_Quote__c = Label.QLDeleteOppID;
                sfdcList.add(dev);
              }
              
              if(sfdcList.size() > 0)
                update sfdcList;
          }
          else if(OppMap.get('Line_Item') != null)
          {
              
              List<Quote_Line__c> sfdcList = new List<Quote_Line__c>();
              
              for(Quote_Line__c dev:[SELECT Id, Opportunity_Quote__c FROM Quote_Line__c  WHERE Opportunity_Quote__c IN : OppMap.get('Line_Item') AND Migration_Device__c = false])
              {
                dev.Opportunity_Quote__c = Label.QLDeleteOppID;
                sfdcList.add(dev);
              }
              
              if(sfdcList.size() > 0)
                update sfdcList;
          }
      }
    }
}