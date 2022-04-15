public class DPNewConfigurationDocumentController {    

    /* wrapper / inner classes */    
    public class TemplateWrapper{
        public APXTConga4__Conga_Template__c theTemplate {get;set;}
        public Boolean checked {get;set;}
        public Integer index {get;set;}
    }
    
    public class TemplateRow{
        public List<TemplateWrapper> wrapperList {get;set;}
        public TemplateRow(){
            wrapperList = new List<TemplateWrapper>();
        }
    }
    
    public class excludeWrapper{
        public QuoteLineItem theQuoteLineItem {get;set;}
        public String Name {get;set;}                    
        public Boolean checked {get;set;}
        public Boolean hideChildPrice {get;set;}
        public Boolean showDescription {get;set;}
    }            
    
    public Quote theQuote {get;set;}
   //  public List<QuoteLineItem> QuotelineItems=new List<QuoteLineItem>();   
     public Integer page {get;set;}
    
    public Boolean showMainError {get;set;}
     public Boolean showProdInactiveError {get;set;}
    
    public String selectedTemplates {get;set;}
    public String hiddenSendMap {get;set;}
    public String approvalRequest {get;set;}
    
    public List<TemplateWrapper> templateList {get;set;}
    public List<TemplateRow> templateRowList {get;set;}           
    public List<String> templateIdList {get;set;}
    public List<ExcludeWrapper> excludeWrapperList {get;set;}
    
    Boolean firstRun;
        
    public Set<Id> collapseSet {get;set;}
    public Set<Id> hideChildPriceSet {get;set;}
    public Set<Id> showDescriptionSet {get;set;}
            
    public Map<Id,String> parentItemMap {get;set;}
    public Map<Id,Decimal> parentPriceMap {get;set;}    
    public Map<String,String> globalizeMap {get;set;}
    public Map<Id,Id> thumbnailIdMap {get;set;}    
    
    public DPNewConfigurationDocumentController(){
        showMainError = false;
        showProdInactiveError =false;
        approvalRequest = '';
        globalizeMap = new Map<String,String>();
        firstRun = true;
        parentPriceMap = new Map<Id,Decimal>();
        hideChildPriceSet = new Set<Id>();
        showDescriptionSet = new Set<Id>();
        try{
            //theQuote = [select DP_Approval_Comments__c,DP_Asset_Change__c, DP_Asset_Change_Approved__c, DP_Extension_Date__c, DP_Extension_Date_Approved__c, DP_Display_Term__c, DP_generating_proposal__c,DP_Go_Live_Override__c,DP_Total_Setup_Fee__c,DP_Total_mrr__c,DP_term__c,Name,Id,DP_Formatted_Quote__c,isSyncing,DP_Exception_Lines__c,DP_Discount_Override__c,DP_Currency_Code__c from Quote where Id = :getRecordId()];
            theQuote = [select DP_generating_proposal__c,DP_Go_Live_Override__c,DP_Total_Setup_Fee__c,DP_Total_mrr__c,DP_term__c,Name,Id,DP_Formatted_Quote__c,isSyncing,DP_Exception_Lines__c,DP_Discount_Override__c,DP_Currency_Code__c from Quote where Id = :getRecordId()];
        
         // system.debug('after quote query '+theQuote);          
          }
catch(Exception e){
           
            theQuote = null;
            showMainError = true;
        }
        Map<Id,QuoteLineitem> theQuotelineitems = new  Map<Id,QuoteLineitem>( [SELECT Id,pricebookentry.product2.name FROM QuoteLineItem WHERE Quote.IsSyncing = true and Quoteid = :theQuote.id  
                             and pricebookentry.product2.Isactive=false]);
       
          
         if( theQuote != null && theQuotelineitems.size() > 0 )  {
          //system.debug('after quoteline  query ,inthe if condition'+theQuotelineitems);
            showProdInactiveError =true;
         for(QuoteLineITem Qli: theQuotelineitems.values())
         {
          
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Product ' +'"'+ Qli.pricebookentry.product2.name +'"'+' is Inactive');//Same old drama 
            ApexPages.addMessage(myMsg);
           // system.debug('after quoteline  query ,in the for condition'+showProdInactiveError);
            
           
        } // showProdInactiveError =true;
          }
        
    
       
        if(theQuote != null && theQuotelineitems.size() == 0){
          
        
            templateList = new List<TemplateWrapper>();
            templateRowList = new List<TemplateRow>();
            Set<Id> thumbnailIds = new Set<Id>();
            thumbnailIdMap = new Map<Id,Id>();
            page = 1;
            Integer counter = 1;
            TemplateRow tr = new TemplateRow();
            Boolean needToAddStill = true;
            for(APXTConga4__Conga_Template__c conga : [select Id,(select id from template_thumbnails__r),APXTConga4__Name__c,selected_by_default__c from APXTConga4__Conga_Template__c WHERE Document_Type__c = 'Proposal' order by Template_Order__c asc]){
              //  system.debug('counter: '+counter);
                TemplateWrapper tw = new TemplateWrapper();
                tw.theTemplate = conga;
              //  system.debug('tw:thetemplate:'+conga);
                tw.checked = conga.selected_by_default__c;
                templateList.add(tw);
                system.debug('TEmplatelist:'+templateList);
                
                if(conga.template_thumbnails__r.size() > 0)
                    thumbnailIds.add(conga.template_thumbnails__r[0].id);
                
                tr.wrapperList.add(tw);
                needToAddStill = true;
                if(math.mod(counter,3) == 0 && counter != 1){
                    system.debug('adding template row');
                    templateRowList.add(tr);
                    tr = new TemplateRow();       
                    needToAddStill = false;         
                }
                counter++;
            }
            system.debug('needToAddStill '+needToAddStill);
            if(needToAddStill){
                templateRowList.add(tr);
                system.debug('adding final template row');
            }
            
            Map<Id,Id> thumbnailAttachmentMap = new Map<Id,Id>();
            for(Attachment a : [select Id,ParentId from Attachment where parentId in :thumbnailIds])               
              {
                thumbnailAttachmentMap.put(a.parentId,a.Id); 
            //    system.debug('thumbnailids:'+a );       
            
            }
            for(APXTConga4__Conga_Template__c conga : [select Id,(select id from template_thumbnails__r),APXTConga4__Name__c,selected_by_default__c from APXTConga4__Conga_Template__c order by Template_Order__c asc]){            
                if(conga.template_thumbnails__r.size() > 0 && thumbnailAttachmentMap.containsKey(conga.template_thumbnails__r[0].id)){
                    thumbnailIdMap.put(conga.id,thumbnailAttachmentMap.get(conga.template_thumbnails__r[0].id));
                     }
            }        
            system.debug(thumbnailIdMap);
            
            indexWrappers();
            collapseSet = new Set<Id>();
            buildFormattedQuoteString();
        }
       
        
       
    }
    
  
        
    /* getters for url params / lists */
    
    public String getSessionId(){
        
       // return ApexPages.currentPage().getParameters().get('SessionId');
        
        
        String v = UserInfo.getSessionId().substring(15);
         system.debug('sessionid userInfo.getsessionid():'+ v);
        
        return v;

       
        
        /*
        System.debug('going to print out param: ' + param);
        if (String.isBlank(param) || param == 'SESSION_ID_REMOVED' ) {
            System.debug('param is blank or org = SESSION_ID_REMOVED');
            String var = UserInfo.getSessionId().substring(15);
            return var;
        } else {
            System.debug('its fine');
            return param;
        }
*/

    }
    public String getServerURL(){
    system.debug('SERVERURL:'+ApexPages.currentPage().getParameters().get('ServerUrl'));
        return ApexPages.currentPage().getParameters().get('ServerUrl');
        
    }
    public String getRecordId(){
        return ApexPages.currentPage().getParameters().get('Id');
    }
    
    public List<QuoteLineItem> getExceptionQuoteLineItems(){
        return [select PricebookEntry.Name, Quantity, DP_Discount__c,DP_MRR__c, DP_Max_Discount__c
                from QuoteLineItem where QuoteId = :theQuote.Id and (DP_Exception__c = 'true' or DP_discount_exception__c = true)];               
    }
    
    public String getFormattedQuote(){
        return theQuote.DP_Formatted_Quote__c;
    }
    
    public String getSerializedGlobalizeMap(){
    System.debug(' 174 line JSON.Serialize(globalizeMap):::'+JSON.Serialize(globalizeMap));
        return JSON.serialize(globalizeMap);
    }    
             
    
    /*
    @Name   : indexWrappers
    @Description : Indexes Template wrappers to assist with jQuery highlighting functionality
    */
             
    public void indexWrappers(){
        Integer index = 0;
        for(TemplateRow tr : TemplateRowList){
            for(TemplateWrapper tw : tr.wrapperList){
                tw.index = index;
                index++;    
            }
            
        }
    }  
    
    public PageReference submitForApproval(){
        if(approvalRequest.length() < 1){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Approval Request Comments are required.'));
            return null;
        }
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments(approvalRequest );
        
        theQuote.DP_Approval_Comments__c = approvalRequest;
        update theQuote;
        
        req1.setObjectId(theQuote.id);
        
        // Submit the approval request
        Approval.ProcessResult result = Approval.process(req1);
        try{
            System.assert(result.isSuccess());
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
        }
        return new PageReference('/' + theQuote.Id);
    }
    /*
    @Name   : processGlobalizeMap
    @Description : Process the map that comes in from the page as a result of using jQuery.Globalize
    */
    
    public void processGlobalizeMap(){
        globalizeMap = (Map<String,String>)JSON.deserialize(hiddenSendMap, Map<String,String>.class);
        system.debug('globalizeMap::::'+ globalizeMap);
    }
    
    /*
    @Name   : buildTemplateString
    @Description :Builds template Id string for Conga integration 
    */  
            
    public void buildTemplateString(){
        templateIDList = new List<String>();
        for(TemplateWrapper tw : templateList){
            if(tw.checked){
                templateIdList.add(tw.theTemplate.Id);
            }
        } 
        selectedTemplates = String.join(templateIdList,',');   
    }                          

    public String getRole(QuoteLineItem qliIn, List<QuoteLineItem> listIn){
        Boolean moreThanOne = false; 
        
        List<QuoteLineItem> qlis = new List<QuoteLineItem>();
        for(QuoteLineItem qli : listIn){
            if(qli.DP_Parent_Quote_Line__c == qliIn.Id){
                qlis.add(qli);
            }
        }
        
        if(qliIn.quantity > 1) moreThanOne = true;
        
        String returnString = '';
        
        for(QuoteLineItem qli : qlis){
            if((qli.Pricebookentry.Product2.DP_Product_Type__c == 'Role') || (qli.Pricebookentry.Product2.DP_Product_Type__c == 'Header')){
                returnString = qli.Pricebookentry.Name;         
            }
        }
        
        if(returnString != ''){
            String temp = returnString;
            returnString = '<b>';
            returnString += temp;
            if(moreThanOne)
                returnString += 's';
            returnString += '</b>';    
            returnString += '<br/>';    
        }
        
        return returnString;
    }

    
    public String getRole(List<QuoteLineItem> listIn){
        return getRole(listIn, true);
    }
    public String getRole(List<QuoteLineItem> listIn, Boolean addBR){
        
        String returnString = '';
        Boolean moreThanOne = false;
        for(QuoteLineItem qli : listIn){
            if(qli.DP_parent_quote_line__c == null){
                if(Integer.valueOf(qli.Quantity) > 1){
                    moreThanOne = true; 
                }
            }
        }
        for(QuoteLineItem qli : listIn){
           // system.debug(qli.id + ' ' + qli.Pricebookentry.Product2.DP_Product_Type__c + ' name:' +  qli.Pricebookentry.Name);
            if((qli.Pricebookentry.Product2.DP_Product_Type__c == 'Role') || (qli.Pricebookentry.Product2.DP_Product_Type__c == 'Header')){
                returnString = qli.Pricebookentry.Name;         
            }
            
        }
        if(returnString != ''){
            String temp = returnString;
            returnString = '<b>';
            returnString += temp;
            if(moreThanOne)
                returnString += 's';
            returnString += '</b>';    
            if(addBR){
                returnString += '<br/>';   
            }            
        }
        return returnString;
    }
    
     
    /*
    @Name   : buildFormattedQuoteString
    @Description : Builds formatted HTML for display in Rich Text Area
    */
    
    /*public void buildFormattedQuoteString(){
        if(ApexPages.currentPage().getParameters().get('version') != 'old'){
            buildFormattedQuoteString_newversion();
        } else {
            buildFormattedQuoteString_oldversion();
        }
    }*/
    
    public void buildFormattedQuoteString(){
                  
        parentItemMap = new Map<Id,String>();
        
        List<QuoteLineItem> lstQLI = [SELECT DP_MRR__c,Id,DP_Parent_Quote_Line__c,PricebookEntry.Product2.Description,
                PricebookentryId,Pricebookentry.Name,DP_Quote_Group__c, CurrencyIsoCode,
                DP_Quote_Group__r.Name,Quantity,UnitPrice,
                PricebookEntry.Product2.DP_Formatted_Quantity__c,
                PricebookEntry.Product2.DP_Formatted_Quantity_Descriptor__c,
                PricebookEntry.Product2.Name,
                PricebookEntry.Product2.DP_Product_Type__c
                FROM QuoteLineItem 
                WHERE QuoteId = :theQuote.Id
                ORDER BY DP_Quote_Group__r.DP_Order__c, DP_Index__c, PricebookEntry.product2.DP_Type_order__c
            ];
        system.debug('lstQli:'+lstQli);
        //lstQLI = DatapipeUtility.sortLstQLIByProdType(lstQLI);
        
        Map<Id,QuoteLineItem> qliMap2 = new Map<Id,QuoteLineItem>();               
        
        for(QuoteLineItem qli : lstQLI){
            qliMap2.put(qli.Id,qli);
        }
        
        List<String> orderList = new List<String>();
        
        Map<String,List<QuoteLineItem>> qliMap = new Map<String,List<QuoteLineItem>>();
        for(QuoteLineItem qli : lstQLI){
            if(qliMap.get(qli.DP_Quote_Group__r.Name) == null){
                List<QuoteLineItem> lst = new List<QuoteLineItem>();
                lst.add(qli);               
                qliMap.put(qli.DP_Quote_Group__r.Name,lst);
                orderList.add(qli.DP_Quote_Group__r.Name);
            } else {
                qliMap.get(qli.DP_Quote_Group__r.Name).add(qli);
            }
            
        }
        
        system.debug(qliMap);
    
        // open list 
        String formattedQuote = '<table cellpadding="0" cellspacing="0" width="100%">';
        
        Set<Id> parentIds = new Set<Id>();
        Map<Id,List<QuoteLineItem>> parentMap = new Map<Id,List<QuoteLineItem>>();
        for(String s : qliMap.keySet()){
            for(QuoteLineItem qli : qliMap.get(s)){
                if(qli.DP_Parent_Quote_Line__c == null){
                    parentIds.add(qli.Id);
                    parentItemMap.put(qli.Id, qli.PriceBookEntry.Name);
                    parentMap.put(qli.Id, new List<QuoteLineItem>());
                }
            }
        }
         
        
        for(String s : qliMap.keySet()){
            system.debug('*** ' + s);
            for(QuoteLineItem qli : qliMap.get(s)){
                if(qli.DP_Parent_Quote_Line__c != null){
                    parentMap.get(qli.DP_Parent_Quote_Line__c).add(qli);
                }
            }
        }
        
        Map<String,Decimal> priceMap = new Map<String,Decimal>();
        for(String s : qliMap.keySet()){
            Decimal d = 0;
            for(QuoteLineItem qli : qliMap.get(s)){
                if(qli.DP_mrr__c != null){                     
                    d += qli.DP_mrr__c;
                }
            }
            priceMap.put(s,d);
        }
        system.debug('Pricemap:'+pricemap);
        
        
        if(!globalizeMap.containsKey(String.valueOf(theQuote.DP_total_mrr__c))){
        system.debug('thequote.DP_Total_MRR__C:'+theQuote.DP_total_mrr__c);
        
            globalizeMap.put(String.valueOf(theQuote.DP_total_mrr__c), '');
        }

        if(!globalizeMap.containsKey(String.valueOf(theQuote.DP_total_setup_fee__c))){
            globalizeMap.put(String.valueOf(theQuote.DP_total_setup_fee__c), '');
            system.debug('theQuote.DP_total_setup_fee__c ' +theQuote.DP_total_setup_fee__c);
        }
        
        if(excludeWrapperList == null){
            excludeWrapperList = new List<ExcludeWrapper>();
        }
        
        //for (String s : qliMap.keySet()) {
        system.debug('orderlist:'+orderlist);
        
        for(String s : orderList){
            system.debug('****');
            system.debug(s);
            if(s == null) s = '';
            
            // group header 'NETWORKING'
            formattedQuote += '<tr><td colspan="2"><span style="font-size:18px"><b>' + s.toUpperCase() + '</b></span></td></tr>';
            formattedQuote += '<tr><td colspan="2"></td></tr>';
            
            // group pricing
            if(!globalizeMap.containsKey(String.valueOf( pricemap.get(s) ))){
                globalizeMap.put(String.valueOf(pricemap.get(s)),'');
            }
            
            Integer count = 0;
            Integer childCount = 0;
            Boolean hadRole = false;
            
            // iterate products 
            for(QuoteLineItem qli : qliMap.get(s)){
            system.debug('quotelineitems:'+qli);

                childCount = 0;

                if(qli.DP_parent_quote_line__c == null){

                    Decimal d = qli.DP_mrr__c;
                    if(!collapseSet.contains(qli.Id)){
                        for(QuoteLineItem qli2 : parentMap.get(qli.Id)){
                            d += qli2.DP_mrr__c;
                        }
                    }
                    if(!parentPriceMap.containsKey(qli.Id)){
                        parentPriceMap.put(qli.id,d);
                          system.debug('parentpricemap :::'+d);
                      
                    }
                    
                    if(!globalizeMap.containsKey(String.valueOf(parentPriceMap.get(qli.id)))){
                         system.debug('parentpricemap :::'+ String.valueOf(parentPriceMap.get(qli.id)));
                        globalizeMap.put(String.valueOf(parentPriceMap.get(qli.id)),''); 
                    }
                    
                    if(!globalizeMap.containsKey( DPNewConfigurationDocumentController.getGroupPrice( qliMap.get(s)) ) ){
                        globalizeMap.put(DPNewConfigurationDocumentController.getGroupPrice( qliMap.get(s)) ,''); 
                    }
                    
                    // parent opener & role specification 
                    String roleName = getRole(qli, qliMap.get(s));
                    if (roleName != '') {
                        if (!formattedQuote.endsWith('<tr><td colspan="2"></td></tr>')) {
                            formattedQuote += '<tr><td colspan="2"></td></tr>';
                        }
                        // group header 'MANAGED NETWORK SETTINGS'
                        formattedQuote += '<tr><td><span style="font-size:15px">' + roleName.toUpperCase() + '</span>';
                        hadRole = true;
                    }
                    else {
                        formattedQuote += '<tr><td>';
                        hadRole = false;
                    }
                    
                    // parent cell 
                    if(qli.Pricebookentry.Product2.DP_formatted_quantity__c == null){
                        formattedQuote += Integer.valueOf(qli.Quantity)+'x ' + qli.Pricebookentry.Name;
                    } else {
                        Integer descriptiveQuantity = Integer.valueOf(qli.Quantity * qli.Pricebookentry.Product2.DP_formatted_quantity__c);
                        if (descriptiveQuantity == 0) {
                            formattedQuote += qli.Pricebookentry.Product2.DP_formatted_quantity_descriptor__c;
                            system.debug('formattedquote:parentcell:'+formattedquote);
                    
                        } else {
                            formattedQuote += descriptiveQuantity + ' ' + qli.Pricebookentry.Product2.DP_formatted_quantity_descriptor__c;
                            system.debug('formattedquote:descriptiveqty:'+formattedquote);
                    
                        }
                        system.debug('formattedquote:parentcell:'+formattedquote);
                    }
                    
                    // parent cell closer
                    formattedQuote += '</td><td>' + globalizeMap.get(String.valueOf(parentPriceMap.get(qli.id)))+'</td>'; //+ getCurrencySymbolFromIso(qli.CurrencyIsoCode)
                    
                    // pricing cell 
                    if(!hideChildPriceSet.contains(qli.Id)){
                        //formattedQuote += '<td align="right" valign="top">' + globalizeMap.get(String.valueOf(parentPriceMap.get(qli.id))) + '</td>';
                    } else {
                        //formattedQuote += '<td> </td>';
                    }
                    
                    // parent row closer
                    formattedQuote += '</tr>';
                    
                    // parent product description
                    if(showDescriptionSet.contains(qli.Id) && qli.PricebookEntry.Product2.Description != null){
                        formattedQuote += '<tr><td colspan="2" style="padding-left:5pt;"><font style="font-size:11pt;">' + qli.PricebookEntry.Product2.Description + '</font></td></tr>';
                    system.debug('formattedquote:showdescriptionset:'+formattedquote);
                    
                    }
                    
                    ExcludeWrapper ew = new ExcludeWrapper();
                    system.debug('enter wrapper');
                    ew.checked = false;
                    ew.Name = qli.Pricebookentry.Name;
                    ew.theQuoteLineItem = qli;
                    if(firstRun) {
                        system.debug('ew::'+ew);
                        excludeWrapperList.add(ew);                        
                    }
                    
                    if(!collapseSet.contains(qli.Id)){
                    system.debug('enter not collapseset::'+qli.id);
                    

                        for(QuoteLineItem qli2 : parentMap.get(qli.Id)){
                            
                            // child product 
                            if((qli2.Pricebookentry.Product2.DP_Product_Type__c != 'Role') && (qli2.Pricebookentry.Product2.DP_Product_Type__c != 'Header')){ // do not show Role or Header type products in quote
                                
                                // child product opener 
                                formattedQuote += '<tr><td colspan="2">';
                                system.debug('formattedQuote::'+formattedQuote);
                    
                                
                                if(qli2.Pricebookentry.Product2.DP_formatted_quantity__c == null){
                                    formattedQuote += Integer.valueOf(qli2.Quantity)+'x ' + qli2.Pricebookentry.Name + '<br />';
                                } else {
                                    Integer descriptiveQuantity = Integer.valueOf(qli2.Quantity * qli2.Pricebookentry.Product2.DP_formatted_quantity__c);
                                    if (descriptiveQuantity == 0) {
                                        formattedQuote += qli2.Pricebookentry.Product2.DP_formatted_quantity_descriptor__c;
                                         system.debug('formattedquote:parentcell:'+formattedquote);
                    
                                    } else {
                                        formattedQuote += descriptiveQuantity + ' ' + qli2.Pricebookentry.Product2.DP_formatted_quantity_descriptor__c;
                                         system.debug('formattedquote:parentcell:'+formattedquote);
                    
                                    }
                                    formattedQuote += '<br />';
                                     system.debug('formattedquote:parentcell:'+formattedquote);
                    
                                }
                                
                                // child product closer 
                                formattedQuote += '</td></tr>';
                                
                                childCount++;
                                                                
                            }
                            
                        }
                        /*
                        formattedQuote += ' <tr><td>' +
                            '<b> <p style="text-align: right">' +
                            //hacky hacky - remove br from rolename
                            roleName.replace('<br/>','').replace('<b>','').replace('</b>','').toUpperCase() + ' MONTHLY COST &nbsp;&nbsp;</p></b></td><td><b><p>' + 
                            globalizeMap.get(String.valueOf(parentPriceMap.get(qli.id))) 
                            + '</p> </b>'
                            + '</td></tr>';
                        */
                    }
                    
                }
                /*
                // if we had a role or children, we need a spacer 
                if (((hadRole) || (childCount > 0)) && (!formattedQuote.endsWith('<tr><td colspan="2"></td></tr>'))) {
                    formattedQuote += '<tr><td colspan="2"></td></tr>';
                }
                */
                count++;
                
            }

            // we need a spacer before the group total 
            if (!formattedQuote.endsWith('<tr><td colspan="2"></td></tr>')) {
                formattedQuote += '<tr><td colspan="2"></td></tr>';
            }
            
            formattedQuote += '<tr>';
            formattedQuote += '<td><b><p style="text-align: right;">' + s.toUpperCase() + ' MONTHLY COST &nbsp;&nbsp;</p></b></td>';
            formattedQuote += '<td><b><p>' + globalizeMap.get(DPNewConfigurationDocumentController.getGroupPrice(qliMap.get(s))) + '</p></b></td>';
            formattedQuote += '</tr>';
            formattedQuote += '<tr><td colspan="2"><hr/></td>';
            //formattedQuote += '<tr><td colspan="2"></td></tr>';
            
             system.debug('formatted Quote ' +  formattedQuote ); 
        }

        // pricing summary 
        if(globalizeMap.containsKey(String.valueOf(theQuote.DP_total_mrr__c) ) ){
         
         system.debug('pricing summary:'+theQuote.DP_total_mrr__c);
                    
      
            // pricing summary header
            formattedQuote += '<tr >';
            formattedQuote += '<td style="height:20;" colspan="2"><b><p style="font-size:14pt;">MANAGED SOLUTION PRICING SUMMARY</b>&nbsp;';
            if (theQuote.DP_Term__c != null){
                formattedQuote += '<span style="font-size:11px">(Based on ' + theQuote.DP_Term__c + ' month commitment)</span></p></td>';
                system.debug('formatted Quote ' +  formattedQuote ); 
                
            } else {
                formattedQuote += '<span style="font-size:11px">(Based on __ month commitment)</span></p></td>';
                system.debug('formatted Quote ' +  formattedQuote ); 
            }    
                
            formattedQuote += '</tr>';
            // monthly cost
            formattedQuote += '<tr height="20">';
            formattedQuote += '<td><p style="text-align: right"><b>TOTAL MONTHLY COST &nbsp;&nbsp;</b></p></td>';
            formattedQuote += '&nbsp;&nbsp;<td><p><b>' + globalizeMap.get(String.valueOf(theQuote.DP_total_mrr__c)) + '</b></p></td>';
            formattedQuote += '</tr>';
            // setup fee 
            formattedQuote += '<tr>';
            formattedQuote += '<td> <p style="text-align: right"><b>TOTAL SETUP FEE &nbsp;&nbsp;</b></p></td>';
            formattedQuote += '&nbsp;&nbsp;<td><p><b>' + globalizeMap.get(String.valueOf(theQuote.DP_total_setup_fee__c)) + '</b></p></td>';
            formattedQuote += '</tr>';
            
            system.debug(' formattedQuote prcing summary::'+  formattedQuote);

        }
        
        formattedQuote += '</table>';
        system.debug('formattedQuote::'+formattedquote);
        
        theQuote.DP_Generating_Proposal__c = true;
        theQuote.DP_Formatted_Quote__c = formattedQuote;
        firstRun = false;

    }    
    
    /*public void buildFormattedQuoteString_oldversion(){
                  
        parentItemMap = new Map<Id,String>();
        
        List<QuoteLineItem> lstQLI = [SELECT DP_MRR__c,Id,DP_Parent_Quote_Line__c,PricebookEntry.Product2.Description,
                PricebookentryId,Pricebookentry.Name,DP_Quote_Group__c,
                Quote_Group__r.Name,Quantity,UnitPrice,
                PricebookEntry.Product2.DP_Formatted_Quantity__c,
                PricebookEntry.Product2.DP_Formatted_Quantity_Descriptor__c,
                PricebookEntry.Product2.Name,
                PricebookEntry.Product2.DP_Product_Type__c
                FROM QuoteLineItem 
                WHERE QuoteId = :theQuote.Id
                ORDER BY Quote_Group__r.DP_Order__c, DP_Index__c, PricebookEntry.product2.DP_Type_order__c
            ];
        
        //lstQLI = DatapipeUtility.sortLstQLIByProdType(lstQLI);
        
        Map<Id,QuoteLineItem> qliMap2 = new Map<Id,QuoteLineItem>();               
        
        for(QuoteLineItem qli : lstQLI){
            qliMap2.put(qli.Id,qli);
        }
        
        List<String> orderList = new List<String>();
        
        Map<String,List<QuoteLineItem>> qliMap = new Map<String,List<QuoteLineItem>>();
        for(QuoteLineItem qli : lstQLI){
            if(qliMap.get(qli.Quote_Group__r.Name) == null){
                List<QuoteLineItem> lst = new List<QuoteLineItem>();
                lst.add(qli);               
                qliMap.put(qli.Quote_Group__r.Name,lst);
                orderList.add(qli.Quote_Group__r.Name);
            } else {
                qliMap.get(qli.Quote_Group__r.Name).add(qli);
            }
            
        }
        
        system.debug(qliMap);
    
        /* open list 
        String formattedQuote = '<table cellpadding="0" cellspacing="0">';
        
        Set<Id> parentIds = new Set<Id>();
        Map<Id,List<QuoteLineItem>> parentMap = new Map<Id,List<QuoteLineItem>>();
        for(String s : qliMap.keySet()){
            for(QuoteLineItem qli : qliMap.get(s)){
                if(qli.DP_Parent_Quote_Line__c == null){
                    parentIds.add(qli.Id);
                    parentItemMap.put(qli.Id, qli.PriceBookEntry.Name);
                    parentMap.put(qli.Id, new List<QuoteLineItem>());
                }
            }
        }
         
        
        for(String s : qliMap.keySet()){
            system.debug('*** ' + s);
            for(QuoteLineItem qli : qliMap.get(s)){
                if(qli.DP_Parent_Quote_Line__c != null){
                    parentMap.get(qli.DP_Parent_Quote_Line__c).add(qli);
                }
            }
        }
        
        Map<String,Decimal> priceMap = new Map<String,Decimal>();
        for(String s : qliMap.keySet()){
            Decimal d = 0;
            for(QuoteLineItem qli : qliMap.get(s)){
                if(qli.DP_mrr__c != null){                     
                    d += qli.DP_mrr__c;
                }
            }
            priceMap.put(s,d);
        }
        
        if(!globalizeMap.containsKey(String.valueOf(theQuote.DP_total_mrr__c))){
            globalizeMap.put(String.valueOf(theQuote.DP_total_mrr__c), '');
        }

        if(!globalizeMap.containsKey(String.valueOf(theQuote.DP_total_setup_fee__c))){
            globalizeMap.put(String.valueOf(theQuote.DP_total_setup_fee__c), '');
        }
        
        if(excludeWrapperList == null){
            excludeWrapperList = new List<ExcludeWrapper>();
        }
        
        //for (String s : qliMap.keySet()) {
        for(String s : orderList){
            system.debug('****');
            system.debug(s);
            if(s == null) s = '';
            
            /* group header 
            formattedQuote += '<tr><td colspan="2"><font style="font-size:14pt;"><b>' + s.toUpperCase() + '</b></font></td></tr>';
            formattedQuote += '<tr><td colspan="2"></td></tr>';
            
            /* group pricing
            if(!globalizeMap.containsKey(String.valueOf( pricemap.get(s) ))){
                globalizeMap.put(String.valueOf(pricemap.get(s)),'');
            }
            
            Integer count = 0;
            Integer childCount = 0;
            Boolean hadRole = false;
        
            /* iterate products 
            for(QuoteLineItem qli : qliMap.get(s)){

                childCount = 0;

                if(qli.DP_parent_quote_line__c == null){

                    Decimal d = qli.DP_mrr__c;
                    if(!collapseSet.contains(qli.Id)){
                        for(QuoteLineItem qli2 : parentMap.get(qli.Id)){
                            d += qli2.DP_mrr__c;
                        }
                    }
                    if(!parentPriceMap.containsKey(qli.Id)){
                        parentPriceMap.put(qli.id,d);
                    }
                    
                    if(!globalizeMap.containsKey(String.valueOf(parentPriceMap.get(qli.id)))){
                        globalizeMap.put(String.valueOf(parentPriceMap.get(qli.id)),''); 
                    }
                    
                    if(!globalizeMap.containsKey( NewConfigurationDocumentController.getGroupPrice( qliMap.get(s)) ) ){
                        globalizeMap.put(NewConfigurationDocumentController.getGroupPrice( qliMap.get(s)) ,''); 
                    }
                    
                    /* parent opener & role specification 
                    String roleName = getRole(qli, qliMap.get(s));
                    if (roleName != '') {
                        if (!formattedQuote.endsWith('<tr><td colspan="2"></td></tr>')) {
                            formattedQuote += '<tr><td colspan="2"></td></tr>';
                        }
                        formattedQuote += '<tr><td>' + roleName;
                        hadRole = true;
                    }
                    else {
                        formattedQuote += '<tr><td>';
                        hadRole = false;
                    }
                    
                    /* parent cell 
                    if(qli.Pricebookentry.Product2.DP_formatted_quantity__c == null){
                        formattedQuote += Integer.valueOf(qli.Quantity)+'x ' + qli.Pricebookentry.Name;
                    } else {
                        Integer descriptiveQuantity = Integer.valueOf(qli.Quantity * qli.Pricebookentry.Product2.DP_formatted_quantity__c);
                        if (descriptiveQuantity == 0) {
                            formattedQuote += qli.Pricebookentry.Product2.DP_formatted_quantity_descriptor__c;
                        } else {
                            formattedQuote += descriptiveQuantity + ' ' + qli.Pricebookentry.Product2.DP_formatted_quantity_descriptor__c;
                        }
                    }
                    
                    /* parent cell closer 
                    formattedQuote += '</td>';
                    
                    /* pricing cell 
                    if(!hideChildPriceSet.contains(qli.Id)){
                        formattedQuote += '<td align="right" valign="top">' + globalizeMap.get(String.valueOf(parentPriceMap.get(qli.id))) + '</td>';
                    } else {
                        formattedQuote += '<td> </td>';
                    }
                    
                    formattedQuote += '</tr>';
                    
                    /* parent product description 
                    if(showDescriptionSet.contains(qli.Id) && qli.PricebookEntry.Product2.Description != null){
                        formattedQuote += '<tr><td colspan="2" style="padding-left:5pt;"><font style="font-size:10pt;">' + qli.PricebookEntry.Product2.Description + '</font></td></tr>';
                    }
                    
                    ExcludeWrapper ew = new ExcludeWrapper();
                    ew.checked = false;
                    ew.Name = qli.Pricebookentry.Name;
                    ew.theQuoteLineItem = qli;
                    if(firstRun)
                        excludeWrapperList.add(ew);                        
                    
                    if(!collapseSet.contains(qli.Id)){

                        for(QuoteLineItem qli2 : parentMap.get(qli.Id)){
                            
                            /* child product 
                            if((qli2.Pricebookentry.Product2.DP_Product_Type__c != 'Role') && (qli2.Pricebookentry.Product2.DP_Product_Type__c != 'Header')){ // do not show Role or Header type products in quote
                                
                                /* child product opener 
                                formattedQuote += '<tr><td colspan="2">';
                                
                                if(qli2.Pricebookentry.Product2.DP_formatted_quantity__c == null){
                                    formattedQuote += Integer.valueOf(qli2.Quantity)+'x ' + qli2.Pricebookentry.Name + '<br />';
                                } else {
                                    Integer descriptiveQuantity = Integer.valueOf(qli2.Quantity * qli2.Pricebookentry.Product2.DP_formatted_quantity__c);
                                    if (descriptiveQuantity == 0) {
                                        formattedQuote += qli2.Pricebookentry.Product2.DP_formatted_quantity_descriptor__c;
                                    } else {
                                        formattedQuote += descriptiveQuantity + ' ' + qli2.Pricebookentry.Product2.DP_formatted_quantity_descriptor__c;
                                    }
                                    formattedQuote += '<br />';
                                }
                                
                                /* child product closer 
                                formattedQuote += '</td></tr>';
                                
                                childCount++;
                                                                
                            }
                            
                        }

                    }
                    
                }
                
                /* if we had a role or children, we need a spacer *
                if (((hadRole) || (childCount > 0)) && (!formattedQuote.endsWith('<tr><td colspan="2"></td></tr>'))) {
                    formattedQuote += '<tr><td colspan="2"></td></tr>';
                }

                count++;
                
            }

            /* we need a spacer before the group total 
            if (!formattedQuote.endsWith('<tr><td colspan="2"></td></tr>')) {
                formattedQuote += '<tr><td colspan="2"></td></tr>';
            }
            
            formattedQuote += '<tr>';
            formattedQuote += '<td align="right"><b>' + s + ' Monthly Cost</b>&nbsp;&nbsp;</td>';
            formattedQuote += '<td align="right">&nbsp;&nbsp;<b>' + globalizeMap.get(DPNewConfigurationDocumentController.getGroupPrice(qliMap.get(s))) + '</b></td>';
            formattedQuote += '</tr>';
            formattedQuote += '<tr><td colspan="2"><hr/></td>';
            //formattedQuote += '<tr><td colspan="2"></td></tr>';
            
        }

        /* pricing summary 
        if(globalizeMap.containsKey(String.valueOf(theQuote.DP_total_mrr__c) ) ){
      
            /* pricing summary header 
            formattedQuote += '<tr>';
            formattedQuote += '<td colspan="2"><font style="font-size:14pt;"><b>MANAGED SOLUTION PRICING SUMMARY</b></font>&nbsp;<font style="font-size:10pt;">(Based on ' + theQuote.DP_Term__c + ' month commitment)</font></td>';
            formattedQuote += '</tr>';
            /* monthly cost 
            formattedQuote += '<tr>';
            formattedQuote += '<td width="90%" align="right"><b>Total Monthly Cost</b>&nbsp;&nbsp;</td>';
            formattedQuote += '<td width="10%" align="right">&nbsp;&nbsp;<b>' + globalizeMap.get(String.valueOf(theQuote.DP_total_mrr__c)) + '</b></td>';
            formattedQuote += '</tr>';
            /* setup fee 
            formattedQuote += '<tr>';
            formattedQuote += '<td align="right"><b>Total Setup Fee</b>&nbsp;&nbsp;</td>';
            formattedQuote += '<td align="right">&nbsp;&nbsp;<b>' + globalizeMap.get(String.valueOf(theQuote.DP_total_setup_fee__c)) + '</b></td>';
            formattedQuote += '</tr>';

        }
        
        formattedQuote += '</table>';
        
        theQuote.DP_Generating_Proposal__c = true;
        theQuote.DP_Formatted_Quote__c = formattedQuote;
        firstRun = false;

    } */
                                                                               
                                                                     
    public static String getGroupPrice(List<QuoteLineItem> qliList){
        String returnString = '';
            Double total = 0;
            for(QuoteLineItem qli : qliList){
                total += qli.DP_mrr__c;
            }
        
         system.debug('returnString :::' + returnString);
        returnString = String.valueOf(total);
         system.debug('returnString :::' + returnString);
        return returnString;
       
       
    }
    
    
    public static String getCurrencySymbolFromIso(String Iso) {
         String currencySymbol; 
          if ('USD' == Iso) currencySymbol = '$';
          if ('CAD' == Iso) currencySymbol = '$'; 
          if ('EUR' == Iso) currencySymbol = '€';
          if ('GBP' == Iso) currencySymbol = '£'; 
          if ('JPY' == Iso) currencySymbol = '¥';
          if ('KRW' == Iso) currencySymbol = '₩';
          if ('CNY' == Iso) currencySymbol = '元';

            system.debug('CurrencySymbol ::::'+CurrencySymbol);
           return currencySymbol;
          
    }
      
        
    /* Page Action methods
        Handles user actions
     */
    
    public PageReference editQuote(){
        return new PageReference('/'+theQuote.Id+'/e');
    }        
    
    public void previousPage(){
        page--;
    }   
    
    public PageReference cancel(){
        PageReference p = new PageReference('/'+getRecordId());        
        return p;
    }
    
    public PageReference home(){        
        return new PageReference('/');
    }
    
    /*
    @Name   : nextPage
    @Description : Method for handling nextPage clicks
    */
    
    
    public PageReference nextPage3() {
        page++;
      //  String[] strings = new List<String>{UserInfo.getSessionId().substring(15), getserverUrl(), selectedTemplates, getrecordId(), theQuote.Name, theQuote.Id};
         //   System.debug(String.format('https://www.appextremes.com/apps/Conga/Composer.aspx?SessionId={0}&ServerUrl={1}&TemplateId={2}&AWD=1&id={3}&DS7=13&OFN={4}&LG4=1&LG3=1&LG1=Proposal+Generated&MFTSId0={5}&MFTS0=DP_Generating_Proposal__c&MFTSValue0=false', strings ));           
           
        String[] lst = new String[]{APIParameterController.serviceUrlApi, theQuote.Id, selectedTemplates, getrecordId(), theQuote.Name, theQuote.Id};
            
        //String url = '/apex/CM8ConsoleLauncher?serverURL={0}&Id={1}';
        String url = '/apex/APXTConga4__Conga_Composer?SolMgr=1&serverUrl={0}&Id={1}';
        PageReference p = new PageReference((String.format(url + '&TemplateId={2}&AWD=1&id={3}&DS7=0&OFN={4}&LG4=1&LG3=1&LG1=Proposal+Generated&MFTSId0={5}&MFTS0=DP_Generating_Proposal__c&MFTSValue0=false', lst)));
        System.debug('PageReference: ' + p);
        p.setRedirect(false);
        
        doUpdate();
        return p;
    }
    
    
    public void nextPage(){
        page++;
        if(page == 2){
        system.debug('in page==2');
            buildTemplateString();  
            system.debug('afterbuildtempatestring');    
            processGlobalizeMap();
            system.debug('afterprocessGlobalizeMap');    
            
            collapseSet = new Set<Id>();
            system.debug('afterbuildcollapseset');    
            
            buildFormattedQuoteString();    
            system.debug('afterbuildformattedQuotestring');    
                
        }
        if(page == 3){
            System.debug('testing: ' + APIParameterController.serviceUrlApi);
            String[] strings = new List<String>{getSessionId(), getserverUrl(), selectedTemplates, getrecordId(), theQuote.Name, theQuote.Id};
            system.debug('inPage 3'+strings);    
            
            System.debug(String.format('https://www.appextremes.com/apps/Conga/Composer.aspx?SessionId={0}&ServerUrl={1}&TemplateId={2}&AWD=1&id={3}&DS7=13&OFN={4}&LG4=1&LG3=1&LG1=Proposal+Generated&MFTSId0={5}&MFTS0=DP_Generating_Proposal__c&MFTSValue0=false', strings ));           
           
           doUpdate();
        }
    }
    
    /*
    @Name   : updateCollapse 
    @Description : Updates Rich Text box as a result of collapse boxes being checked / unchecked
    */
    
     public PageReference updateCollapse(){
        system.debug('Collapseset()'+Collapseset);
        
        collapseSet.clear();
        system.debug('Collapseset()'+Collapseset);
        hideChildPriceSet.clear();
        showDescriptionSet.clear();
        for(ExcludeWrapper ew : ExcludeWrapperList){
            if(ew.checked ){
                   collapseSet.add(ew.theQuoteLineItem.Id);
             }    
            if(ew.hideChildPrice){
                hideChildPriceSet.add(ew.theQuoteLineItem.Id);
            }
            if(ew.showDescription){
                showDescriptionSet.add(ew.theQuoteLineItem.Id);
            }
            
        }
        buildFormattedQuoteString();
        return null;
    }
   
    
    
    public PageReference hideChildPriceAll() {
        for(ExcludeWrapper ew : ExcludeWrapperList){
            ew.hideChildPrice = true;
        }
        updateCollapse();
        return null;
    }


    public PageReference collapseQuoteLineAll() {
        for(ExcludeWrapper ew : ExcludeWrapperList){
            ew.checked = true;
        }
        updateCollapse();
        return null;
    }
    public void doUpdate(){
        update theQuote;
    }
    
    public static String formatCurrency(Decimal i) {
        if (i == null || Math.abs(i) < 0.005) return '$0.00';
        String s = (i.setScale(2) + (i >= 0 ? 0.001 : -0.001)).format();
        return s.substring(0, s.length() - 1);
    }

}