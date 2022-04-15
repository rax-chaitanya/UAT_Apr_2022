/**********************************************************************************

Author: Thirupathi Aeneni
Date:[4/26/2018]
Description: To resolve eSig Issue - Update AccountId on Contact in NA34 if it is blank

**********************************************************************************/
public class AccountContactRoleHelper {

    public static void updateContactwithCompany(List<Account_Contact_Role__c> acrs){
     
        Map<Id, Contact> updateContacts = new Map<Id, Contact>();
        for(Account_Contact_Role__c acr : acrs){
            if(String.isBlank(acr.ConCompId__c) && String.isNotBlank(acr.AccCompId__c))
               updateContacts.put(acr.Contact__c, new Contact(Id=acr.Contact__c,AccountId = acr.AccCompId__c)) ;
        }
        if(!updateContacts.isEmpty())
        update updateContacts.values();
    }
    
    Public static void updateIsAddressVerified(){
    
    for(Account_contact_role__c acr:(List<Account_contact_role__c>)Trigger.new){
        list<Account_contact_role__c> acrold=trigger.old;
    if(acr.Mailing_Street__c!=acrold[0].Mailing_Street__c){
    //acr.Mailing_Address_Verified__c=false;
    }
    }
    
    }
    
     /********************SFDC-3974 Start - Anitha *********************/
    
    Public Static void copyAccountAddress(){
        system.debug('inside');
        List<Account_Contact_Role__c> updateConRols = new List<Account_Contact_Role__c>();
        set<id> accids = new set<id>();
        map<id, Accounts__c> accMap = new map<id, Accounts__c>();
        for (Account_Contact_Role__c contRole : (List<Account_Contact_Role__c>) Trigger.new){
            if(contRole.Copy_Billing_Address_from_Account__c == true || contRole.Copy_Primary_Address_from_Account__c==true ){
                accids.add(contRole.Account__c);
            }
        }
        system.debug('accids>>>>>>>'+accids);
        
        for(Accounts__c ac: [SELECT id, name,Shipping_Country__c,Shipping_Street__c,Shipping_City__c,Shipping_State_Province__c,Shipping_Zip_Postal_Code__c ,Billing_Street__c,Billing_City__c,Billing_State_Province__c,Billing_Country__c,Billing_Zip_Postal_Code__c FROM Accounts__c WHERE id =: accids]){
            accMap.put(ac.id, ac);
        }
        system.debug('accMap>>>>>>>' +accMap);
        
        for(Account_Contact_Role__c contRole : (List<Account_Contact_Role__c>) Trigger.new){
            if(accMap.containsKey(contRole.Account__c)){
             system.debug('contRole.Copy_Billing_Address_from_Account__c>>>>>>>' +contRole.Copy_Billing_Address_from_Account__c);
                 system.debug('contRole.Copy_Primary_Address_from_Account__c >>>>>>>' +contRole.Copy_Primary_Address_from_Account__c );
                Accounts__c a = accMap.get(contRole.Account__c);
                
               if(contRole.Copy_Billing_Address_from_Account__c == true && contRole.Copy_Primary_Address_from_Account__c==true &&(a.Billing_Street__c==null && a.Billing_City__c==null && a.Billing_State_Province__c==null&&a.Billing_Country__c==null && a.Billing_Zip_Postal_Code__c==null && a.Shipping_Country__c == null && a.Shipping_Street__c == null && a.Shipping_City__c == null && a.Shipping_State_Province__c == null && a.Shipping_Zip_Postal_Code__c == null )){
                    contRole.adderror(Label.ACR_Billing_Primary_Addres_Not_Availble);
                    
                }
               
                else if(contRole.Copy_Primary_Address_from_Account__c==true && contRole.Copy_Billing_Address_from_Account__c!=true &&(a.Shipping_Country__c == null && a.Shipping_Street__c == null && a.Shipping_City__c == null && a.Shipping_State_Province__c == null && a.Shipping_Zip_Postal_Code__c == null)){
                  contRole.adderror(Label.ACR_Primary_Addres_Not_Availble);
                    
                }
                else if(contRole.Copy_Billing_Address_from_Account__c == true&&contRole.Copy_Primary_Address_from_Account__c!= true&& (a.Billing_Street__c==null && a.Billing_City__c==null && a.Billing_State_Province__c==null&&a.Billing_Country__c==null && a.Billing_Zip_Postal_Code__c==null  )){
                   contRole.adderror(Label.ACR_Billing_Addres_Not_Availble);
                    
                } 
                
               
                else if(contRole.Copy_Billing_Address_from_Account__c == true&& contRole.Copy_Primary_Address_from_Account__c==true&&(a.Billing_Street__c==null && a.Billing_City__c==null && a.Billing_State_Province__c==null&&a.Billing_Country__c==null && a.Billing_Zip_Postal_Code__c==null ))
                 {
                   contRole.adderror(Label.ACR_Billing_Addres_Not_Availble);
                 }
                                 
                 else if(contRole.Copy_Billing_Address_from_Account__c == true&& contRole.Copy_Primary_Address_from_Account__c==true&&(a.Shipping_Country__c == null && a.Shipping_Street__c == null && a.Shipping_City__c == null && a.Shipping_State_Province__c == null && a.Shipping_Zip_Postal_Code__c == null )){            
                                 
                          contRole.adderror(Label.ACR_Primary_Addres_Not_Availble);
                             
                 }
                
                
                  else
                  {
               
                    if(contRole.Copy_Billing_Address_from_Account__c== true && contRole.Copy_Primary_Address_from_Account__c==true){ 
                  system.debug('Inside both');
                      contRole.Shipping_Country__c = a.Billing_Country__c ;
                        contRole.Shipping_Street__c = a.Billing_Street__c;
                        contRole.Shipping_City__c = a.Billing_City__c;
                        contRole.Shipping_State__c = a.Billing_State_Province__c;
                        contRole.Shipping_Postal_Code__c =a.Billing_Zip_Postal_Code__c;
                         contRole.Mailing_Street__c=a.Shipping_Street__c;
                        contRole.Mailing_City__c=a.Shipping_City__c;
                        contRole.Mailing_State__c=a.Shipping_State_Province__c;
                        contRole.Mailing_Country__c=a.Shipping_Country__c;
                        contRole.Mailing_Postal_Code__c=a.Shipping_Zip_Postal_Code__c;   
                        
                
        
      }
         if(contRole.Copy_Billing_Address_from_Account__c== true && contRole.Copy_Primary_Address_from_Account__c!=true){
                        
                        contRole.Shipping_Country__c = a.Billing_Country__c ;
                        contRole.Shipping_Street__c = a.Billing_Street__c;
                        contRole.Shipping_City__c = a.Billing_City__c;
                        contRole.Shipping_State__c = a.Billing_State_Province__c;
                        contRole.Shipping_Postal_Code__c =a.Billing_Zip_Postal_Code__c;
                       // system.debug('$$$$$$$$'+a.Territory__c);
                    //  contRole.Territory__c=a.Territory__c;
                        
                    }
                    
                 if(contRole.Copy_Primary_Address_from_Account__c== true && contRole.Copy_Billing_Address_from_Account__c!=true){ {
                        contRole.Mailing_Street__c=a.Shipping_Street__c;
                        contRole.Mailing_City__c=a.Shipping_City__c;
                        contRole.Mailing_State__c=a.Shipping_State_Province__c;
                        contRole.Mailing_Country__c=a.Shipping_Country__c;
                        contRole.Mailing_Postal_Code__c=a.Shipping_Zip_Postal_Code__c;                       
                      
                        
                    }
                        
                }

            system.debug('updateConRols>>>>>>>'+updateConRols);
            
        }
        }
        }
        }
        /********************SFDC-3974 End - Anitha *********************/
   }