/**
 * @description       : SFDC Case #00058275
 * @author            : Atheer Bdaiwi
 * @group             : 
 * @last modified on  : 04-28-2021
 * @last modified by  : Atheer Bdaiwi
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   04-19-2021   Atheer Bdaiwi   Initial Version
**/
public with sharing class ContactLeadHistoryController {

    // the Contact record being viewed
    public Contact contact { get; set; }
      
    // the Lead record that created this Contact record
    public Lead convertedLead {
          get {
              if(convertedLead == null) {
                  List<Lead> convertedLeads = [select Id from Lead where ConvertedContactId = :contact.Id];
                  if(!convertedLeads.isEmpty()) convertedLead = convertedLeads[0];
              }
              return convertedLead;
          }
          set;
      }
  
    // the Lead field history data
      public List<LeadHistory> leadHistory {
          get {
              if(leadHistory == null && convertedLead != null) {
                  leadHistory = [select OldValue, NewValue, LeadId, IsDeleted, Id, Field, CreatedDate, CreatedById From LeadHistory where LeadId = :convertedLead.Id order by CreatedDate DESC];
              }
              return leadHistory;
          }
          set;
      }
      
    // the constructor code
      public ContactLeadHistoryController(ApexPages.StandardController controller) {
          contact = (Contact)controller.getRecord();
      }
  }