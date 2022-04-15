public class  DPQuotesetupfee  {
public static void DPQuoteSetupfee(){
if(Dpquote.Istrue=true)
{

  
  Set<ID> quoteID = new Set<ID>();
  string quoteIsocode = null;
  Set<string> quoteOppID = new Set<string>();
  Double Setupfee =0.00;
  Double conversionrate;
  String ISocode;
   Map<ID, ID> oppMap = new Map<ID, ID>();
   boolean QSync;   
   
   List<Quote> Q1 = new List<Quote>();
        for(Quote q :(List<Quote>)Trigger.New)
        {
            quoteID.add(q.ID);
            quoteisocode = q.DP_Currency_code__C;
              quoteOppID.add(q.Opportunityid); 
            setupfee=q.dp_total_setup_fee__C;
            QSync=q.QuoteSynced__C;
         
          }
          List<Opportunity> updateOppList = new List<Opportunity>();
       
        if(quoteisocode!='USD'&& quoteisocode!= null)
        {
        for(CurrencyType c : [SELECT id,ISOCode, ConversionRate FROM CurrencyType WHERE IsActive=true  and ISOCode = :Quoteisocode  limit 1])
        { conversionrate = c.ConversionRate;
         Isocode=c.isocode;
         }
           
      }  
        
    List<Opportunity> OppList = [select Id, setup_fee__C,currencyisocode from Opportunity where ID IN : quoteOppID limit 1];
    
    if(QSync && Opplist[0].setup_fee__C!=setupfee && setupfee!=0.00 ){
         
      for(Opportunity o: Opplist){
         
        if(o.id!= null  && QuoteISOCODE ==o.currencyisocode )
        {
         o.setup_fee__C =setupfee;
        }
        
        if(o.id!= null && setupfee !=0.00 && o.setup_fee__C !=setupfee && o.currencyisocode != isocode && conversionrate!= null )
        {
        
          o.setup_fee__C= SetUpfee / conversionrate;
        }
        
        updateOppList.add(o);
       }
       }//if Qsync
       
        if(!QSync && Opplist[0].setup_fee__C!=0.00 && Opplist[0].setup_fee__C==setupfee){    
    
        for(Opportunity o: Opplist){          
         o.setup_fee__C =null;                
         updateOppList.add(o);
        }
       }//if Qsync
       
     
    Dpquote.Istrue=false;
    if(updateOpplist.size()>0){
        update updateOppList;}
        }
}
}