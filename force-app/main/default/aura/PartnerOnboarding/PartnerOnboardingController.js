({
    closeModal : function(component, event, helper) {
        
        component.set("v.isOpen",false);
        window.self.close();
    },
    
    doInit: function(component,event,helper){
      
        helper.getAccount(component,event);
    },
    switchTab : function(component,event,helper){
        
    },
    nextStep : function(component,event,helper){
        helper.gotoNextStep(component,event);
    },
    needMoreTime: function(component,event,helper){
      
        var confm = false;
        confm = confirm("Click ''OK'' to Logout. Click ''Cancel'' to go back."); 
        if(confm == true){
            
            window.open('/partners/secur/logout.jsp','_top')
        }else{
            component.set("v.onboardStep","agreements");
            component.set("v.stepNum",1);
            component.set("v.showButtons",false); 
        }
    },
    
    previousStep:function(component,event,helper){
        
        helper.gotopreviousStep(component,event);
    },
    agreedTerms : function(component,event,helper){
        helper.agreetToTerms(component,event);
    },
    
    saveAndClose:function(component,event,helper){
        helper.saveAndClose(component,event);
    },
    
    handleswitchEvent : function(component,event,helper){
        component.set("v.onboardStep",event.getParam("onboardStep"));
        component.set("v.stepNum",event.getParam("stepNum"));
        if(event.getParam("stepNum")==7){
            if(component.get("v.company.Partner_Level__c")=="Strategic" || component.get("v.company.Partner_Level__c")=="StrategicEMEA"){
                
            }else{
                component.set("v.showNext",true);
                if(component.get("v.progress") < 100){
            	component.set("v.progress",100);  
                var progressText = document.getElementsByClassName("slds-p-bottom_x-small");
                var progressBar = document.getElementsByClassName("slds-progress-bar");
                for(var i=0; i<progressBar[0].attributes.length;i++){if(progressBar[0].attributes[i].name=="aria-valuenow"){ progressBar[0].attributes[i].value= 100;}}
                var progressBarValue = document.getElementsByClassName("slds-progress-bar__value");
            	for(var i=0; i<progressBarValue[0].attributes.length;i++){if(progressBarValue[0].attributes[i].name=="style"){progressBarValue[0].attributes[i].value= "width: " + 100 + "%;background: #FFDEDF;";}}
                var toFinish = document.getElementsByClassName("slds-button_success");
                toFinish[0].innerHTML="Finish";
                component.set("v.isFinished",true);
            }
            }
        }
        if(event.getParam("stepNum")!=1 && component.get("v.company.Partner_Level__c")=="Sub Agent"){
          component.set("v.showPrevious",false);   
        }
    },
    changeButtons : function(component,event,helper){
        var buttonStatus = component.get("v.showButtons");
        if(buttonStatus == true){
            component.set("v.showButtons",false);
        }
    }
})