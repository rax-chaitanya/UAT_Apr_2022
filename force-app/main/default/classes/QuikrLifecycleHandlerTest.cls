@isTest
public class QuikrLifecycleHandlerTest{
 
 

    static testMethod void testDefaultMockValues(){
        // Test handler using the default mock RenderContext Canvas.Test creates
        QuikrLifecycleHandler handler = new QuikrLifecycleHandler();
        Canvas.Test.testCanvasLifecycle(handler,null);
    }

    static testMethod void testOverriddenAppValues(){
        // Test handler with some mock application context values
        Map<String,String> appValues = new Map<String,String>();
        appValues.put(Canvas.Test.KEY_CANVAS_URL,'https://myserver.com:6000/myAppPath');
        appValues.put(Canvas.Test.KEY_VERSION,'3.0');
        
        Canvas.RenderContext mock = Canvas.Test.mockRenderContext(appValues,null);
        QuikrLifecycleHandler handler = new QuikrLifecycleHandler();
        Canvas.Test.testCanvasLifecycle(handler,mock);
         handler.excludeContextTypes();

      
    }

    static testMethod void testOverriddenEnvironmentValues(){
        // Test handler with some mock environment context values
        Map<String,String> envValues = new Map<String,String>();
        envValues.put(Canvas.Test.KEY_DISPLAY_LOCATION,'Chatter');
        envValues.put(Canvas.Test.KEY_LOCATION_URL,
            'https://myinstance.salesforce.com/_ui/core/chatter/ui/ChatterPage');
        QuikrLifecycleHandler handler = new QuikrLifecycleHandler();
           LiveChatVisitor liveChatVisitor = new LiveChatVisitor();
            insert liveChatVisitor;
            LiveChatTranscript liveChatTran = new LiveChatTranscript();
            liveChatTran.LiveChatVisitorId = liveChatVisitor.id;
       //     liveChatTran.status = 'In Progress';
            insert liveChatTran;
        Canvas.RenderContext mock = Canvas.Test.mockRenderContext(null,envValues);
        // Directly update the mock RenderContext and set the custom parameters
        mock.getEnvironmentContext().setParametersAsJSON(
            '{\"one\":1,\"two\":2,\"bool\":true,\"stringVal\":\"some string\"}');
        Canvas.Test.testCanvasLifecycle(handler,mock);
    }

}