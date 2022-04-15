/**
 * File : QuikrLifecycleHandler.cls
 * Description : CanvasLifecycleHandler interface implementation for Quikr Canvas App.
 * Created Date : 23/OCT/2017
 * @author : RDC (JY)
 */
public class QuikrLifecycleHandler implements Canvas.CanvasLifecycleHandler {
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
    system.debug('App URL at beginning : ' + app.getCanvasUrl());
    Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(env.getParametersAsJSON());
    system.debug('Params are : ' + params);
    String tId = String.valueOf((String)params.get('tId'));
    
    List<LiveChatTranscript> lcts = new List<LiveChatTranscript>();
    lcts = [SELECT Id, First_Name__c, Last_Name__c, Account_Number__c, Email__c, SecurityToken__c
                  FROM LiveChatTranscript WHERE Id = :tId];
    String queryStrings = '';
    String updatedURL = '/quikr';
    if(!lcts.isEmpty()) {
      queryStrings = 'FirstName=' + lcts.get(0).First_Name__c + '&LastName=' + lcts.get(0).Last_Name__c + 
          '&AccountNumber=' + lcts.get(0).Account_Number__c + '&EmailAddress=' + lcts.get(0).Email__c +
          '&SecurityToken=' + lcts.get(0).SecurityToken__c + '&LiveAgentChatID=' + lcts.get(0).Id;
      updatedURL = '/quikr?' + queryStrings;
    }
    system.debug('App URL before : ' + app.getCanvasUrl());    
    app.setCanvasUrlPath(updatedURL);
    system.debug('App URL after : ' + app.getCanvasUrl());
  }
}