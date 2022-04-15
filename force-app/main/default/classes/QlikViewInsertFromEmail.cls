global class QlikViewInsertFromEmail implements Messaging.InboundEmailHandler {
    
    global String DoctoParse;
    global List<List<String> >ParsedDoc;
    
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope env) {
 
        Movers_Shakers_Account__c QVInt = new Movers_Shakers_Account__c();
        QVInt.DDI__c='999999999';
        insert QVInt;
        system.debug('****** QVInt.Id ******* ' + QVInt.Id);
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        
        // Save attachments, if any
        for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
             Attachment attachment = new Attachment();
 
             attachment.Name = tAttachment.fileName;
             attachment.Body = Blob.valueOf(tAttachment.body);
             attachment.ParentId = QVInt.Id;
             insert attachment;
             DoctoParse = attachment.body.toString(); 
             ParsedDoc=parseCSV(DoctoParse,false);
             system.debug('******** Parsed Doc ************ ' + ParsedDoc);
             
        
        Integer CharStart;
        Integer CharEnd;
        Integer LineNumber;
        String  Value1;
        String  tDDI;
        String  tCompany;
        String  tMRR;
        String  tDate;
        Boolean inline;
        String  tPD;
        String  tStatus;
        String  tCountry;
        String  tContactName;
        String  tContactEmail;
        String  tContactPhone;
        String  tTeam;
        String  tAccountMgr;
        String  tflag;
        String  tdelta;
        String  ttotal;
        inline=false;
        List <Movers_Shakers_Account__c> QVtoInsert = new List<Movers_Shakers_Account__c>();
     
             
        for (List<String> PD:ParsedDoc) {
             tPD=PD.get(0);
             system.debug('++++++++ +++++++++ ' + PD.get(0));
             system.debug('++++++++ +++++++++ ' + tPD);
             
             ///beggining of line
             if (tPD.contains('</tr>')) {
                system.debug('tpd contains works 0');
                system.debug('tDDI' + tDDI);
                inline=false;
                // try to create the record
                if (tDDI!=null && tDDI!='' && tddi.length()>0 && tDDI!='DDI') {
                   Movers_Shakers_Account__c QVInt1 = new Movers_Shakers_Account__c();
                   QVInt1.DDI__c=tDDI;
                   system.debug('tMRR' + tMRR);
                   
                   try {
                      QVInt1.MRR__c=Decimal.Valueof(tMRR);
                   }
                    Catch (exception e) {
                      QVInt1.MRR__c=0;
                   }
                   try {
                      QVInt1.Last_Invoice__c=date1(tdate);
                   } catch (exception e) {
                      QVInt1.Last_Invoice__c=null;
                   }
                   try {
                      QVInt1.Status__c=tStatus;
                   } catch (exception e) {
                      QVInt1.Status__c=null;
                      system.debug(e.getmessage());
                   }
                   try {
                      QVInt1.Country__c=tCountry;
                   } catch (exception e) {
                      QVInt1.Country__c=null;
                      system.debug(e.getmessage());
                   }
                   try {
                      QVInt1.Primary_contact_Name__c=tContactName;
                   } catch (exception e) {
                       system.debug(e.getmessage());
                      QVInt1.Primary_contact_Name__c=null;
                   }
                   try {
                      QVInt1.Primary_contact_Email__c=tContactEmail;
                   } catch (exception e) {
                       system.debug(e.getmessage());
                      QVInt1.Primary_contact_Email__c=null;
                   }
                   try {
                      QVInt1.Primary_contact_Phone__c=tContactPhone;
                   } catch (exception e) {
                       system.debug(e.getmessage());
                      QVInt1.Primary_contact_Phone__c=null;
                   }
                   try {
                      QVInt1.team__c=tTeam;
                   } catch (exception e) {
                       system.debug(e.getmessage());
                      QVInt1.team__c=null;
                   }
                   try {
                      QVInt1.Account_Manager__c=tAccountMgr;
                   } catch (exception e) {
                      system.debug(e.getmessage());
                      QVInt1.Account_Manager__c=null;
                   }
                   //Case 58200 - Workflow rule created on Movers/Shakers Details object
                   try {
                      QVInt1.Delta_from_file__c =Decimal.Valueof(tdelta);
                   } catch (exception e) {
                      system.debug(e.getmessage());
                      QVInt1.Delta_from_file__c =null;
                   }
                   //Case 58204 - Update to Integration mapping - Movers/Shakers Details object
                   try {
                      QVInt1.Server_Units__c =Decimal.Valueof(ttotal);
                   } catch (exception e) {
                      system.debug(e.getmessage());
                      QVInt1.Server_Units__c =null;
                   }
                   
                   QVtoInsert.Add(QVInt1);
                   
                }
                inline=false;
             
                
             }
             if (tPD.contains('<tr')) {
                inline=true;
                system.debug('tpd contains works');
                LineNumber=0;
             } 
             if (inline==true) {
               if (tPD.contains('<td')) 
                 system.debug('tpd contains works 2');
                 LineNumber++;
                 CharStart=PD.get(0).indexof('>')+1;
                 Value1=Pd.get(0).substring(CharStart,PD.get(0).length());
                 Value1=Value1.replace('</td>','');
                 system.debug('Value1 +++++ linenumber' + Value1 + linenumber);
                 if (LineNumber==2) {
                     tDDI=Value1;
                 }
                 if (LineNumber==3) {
                     tCompany=Value1;
                 }
                 if (LineNumber==4) { //new
                     tStatus=Value1;
                 }
                 
                 if (LineNumber==6) {
                     tDate=Value1;
                 }
                 if (LineNumber==7) {
                     tMRR=Value1.remove('$');
                 }
                 // case 53353 NEW FIELDS TO MAP: Account Manager, Team, Primary Contact Name, Status, Country
                  
                 if (LineNumber==8) {// new
                     tCountry=Value1;
                 }
                 if (LineNumber==9) { //new
                     tContactName=Value1;
                 }
                 if (LineNumber==10) { //new
                     tContactEmail=Value1;
                 }
                 if (LineNumber==11) { //new
                     tContactPhone=Value1;
                 }
                 if (LineNumber==12) {//new
                     tTeam=Value1;
                 }
                 if (LineNumber==13) {//new 
                     tAccountMgr=Value1;
                 }
                 //Case 58200 - Workflow rule created on Movers/Shakers Details object
                 if (LineNumber==14) {//new not used
                     tflag=Value1;
                 }
                 if (LineNumber==15) {//Delta
                     tdelta=Value1;
                 }
                 //Case 58204 - Update to Integration mapping - Movers/Shakers Details object
                 if (LineNumber==16) {//Initial Server Units
                     ttotal=Value1;
                 }
             }
             }
             try {
                      insert QVtoInsert;
                   } Catch (exception e) {
                      system.debug('exception ' + e);
             }
       
        
        /*for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
             Attachment attachment = new Attachment();
 
             attachment.Name = bAttachment.fileName;
             attachment.Body = bAttachment.body;
             attachment.ParentId = QVInt.Id;
             
             
             insert attachment;
        }*/
        
        }
        
        result.success = true;
        return result;
     
    }
    
    public static List<List<String>> parseCSV(String contents,Boolean skipHeaders) {
    List<List<String>> allFields = new List<List<String>>();

    // replace instances where a double quote begins a field containing a comma
    // in this case you get a double quote followed by a doubled double quote
    // do this for beginning and end of a field
    contents = contents.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
    // now replace all remaining double quotes - we do this so that we can reconstruct
    // fields with commas inside assuming they begin and end with a double quote
    contents = contents.replaceAll('""','DBLQT');
    // we are not attempting to handle fields with a newline inside of them
    // so, split on newline to get the spreadsheet rows
    List<String> lines = new List<String>();
    try {
        lines = contents.split('\n');
    } catch (System.ListException e) {
        System.debug('Limits exceeded?' + e.getMessage());
    }
    Integer num = 0;
    for(String line : lines) {
        // check for blank CSV lines (only commas)
        if (line.replaceAll(',','').trim().length() == 0) break;
        
        List<String> fields = line.split(',');  
        List<String> cleanFields = new List<String>();
        String compositeField;
        Boolean makeCompositeField = false;
        for(String field : fields) {
            if (field.startsWith('"') && field.endsWith('"')) {
                cleanFields.add(field.replaceAll('DBLQT','"'));
            } else if (field.startsWith('"')) {
                makeCompositeField = true;
                compositeField = field;
            } else if (field.endsWith('"')) {
                compositeField += ',' + field;
                cleanFields.add(compositeField.replaceAll('DBLQT','"'));
                makeCompositeField = false;
            } else if (makeCompositeField) {
                compositeField +=  ',' + field;
            } else {
                cleanFields.add(field.replaceAll('DBLQT','"'));
            }
        }
        
        allFields.add(cleanFields);
    }
    if (skipHeaders) allFields.remove(0);
    return allFields;       
}

    
   public Date date1(String tdate) {
        
        String trem;
        Integer pos1 = tdate.indexof('/');
        Integer tmonth=Integer.Valueof(tdate.substring(0,pos1));
        system.debug('month ' + tmonth);

        trem=tdate.substring(pos1+1,tdate.length());
        system.debug('trem' + trem);
        pos1=trem.indexof('/');
        Integer tday=Integer.Valueof(trem.substring(0,pos1));
        system.debug('day ' + tday);
        Integer tyear=Integer.Valueof(trem.substring(pos1+1,trem.length()));
        system.debug('tyear' + tyear);  
        
        Date tdate2 = date.newInstance(tYear, tMonth, tday);
                        
        system.debug(tdate2);
        return tdate2;
                        
        
        }
}