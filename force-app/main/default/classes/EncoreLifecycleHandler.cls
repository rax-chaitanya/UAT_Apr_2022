/**
* File : EncoreLifecycleHandler.cls
* Description : CanvasLifecycleHandler interface implementation for Encore Canvas App.
* Created Date : 13/AUG/2018
* @author : RDC 
*/
public class EncoreLifecycleHandler implements Canvas.CanvasLifecycleHandler {
public Set<Canvas.ContextTypeEnum> excludeContextTypes(){
// Set<Canvas.ContextTypeEnum> excluded = new Set<Canvas.ContextTypeEnum>();
// Code goes here to add items to excluded list
// that should be excluded from Context data
// return excluded;
return null;
}

public void onRender(Canvas.RenderContext renderContext) {
// Get the Application and Environment context from the RenderContext
Canvas.ApplicationContext app = renderContext.getApplicationContext();
Canvas.EnvironmentContext env = renderContext.getEnvironmentContext();
// Override app URL, replacing portion after domain with '/alternatePath'
// app.setCanvasUrlPath('/alternatePath');
// get the current custom params
Map<String, Object> params ;
params = (Map<String, Object>) JSON.deserializeUntyped(env.getParametersAsJSON());
String tId;
tid = String.valueOf((String)params.get('tId'));

List<LiveChatTranscript> lcts;
lcts = new List<LiveChatTranscript>();
lcts = [SELECT Id,Account_Number__c,DDI__c FROM LiveChatTranscript WHERE Id = :tId];
String queryStrings = '';
String updatedURL = '/details/account/MANAGED_HOSTING/';

if(!lcts.isEmpty()) {
if(lcts.get(0).Account_Number__c !=null){

queryStrings = System.Label.GTS_Encore_DDI +lcts.get(0).Account_Number__c;
}

else if(lcts.get(0).DDI__c !=null){

  queryStrings = System.Label.GTS_Encore_Account_Number +lcts.get(0).DDI__c;        
}

updatedURL = queryStrings;
}  

app.setCanvasUrlPath(updatedURL);
}
}