({
    rerender : function(component, helper) {
       
   		this.superRerender();
        var once = component.get("v.staticImp");
        var companyval = component.get("v.company");
        if(once==1){
            if(component.get("v.company.Partner_Level__c")=='Sub Agent'){
                component.set("v.onboardStep","onboarding");
			    component.set("v.stepNum",1);
                component.set("v.showButtons",true);
                component.set("v.showPrevious",true);
                var element = document.getElementById("savebutton");
    			element.parentNode.removeChild(element); 
                var ele = document.getElementsByClassName("slds-vertical-tabs__link");            
                for(var j=0; j<ele.length; j++){
                    if(ele[j].innerHTML.toUpperCase().includes(component.get("v.onboardStep").toUpperCase())){
                      console.log(ele[j].attributes[6].value);
                        ele[j].attributes[6].value = "background-color: #EB0000;color: white;width: 200px;";
                    }
                }
                component.set("v.staticImp",2);
                 
            }else if(companyval.onboard_step__c!="completed"){
                component.set("v.staticImp",2);
                component.set("v.onboardStep",companyval.onboard_step__c);
                component.set("v.progress",companyval.Completion_Progress__c);
                if(component.get("v.company.Partner_Level__c").includes("Master") == true 
                   && component.get("v.stepNum") == 1
                  && companyval.onboard_step__c=="agreements"){
                   component.set("v.showButtons",true);
                    component.set("v.progress",40);
                    companyval.Completion_Progress__c=40;
                }
                var ele = document.getElementsByClassName("slds-vertical-tabs__link");            
                for(var j=0; j<ele.length; j++){
                    if(ele[j].innerHTML.toUpperCase().includes(component.get("v.onboardStep").toUpperCase())){
                        ele[j].attributes[6].value = "background-color: #EB0000;color: white;width: 200px;";
                    }
                }
                    var elements = document.getElementsByClassName("slds-vertical-tabs__nav-item");
                for (var i=0; i<elements.length; i++) {
                    if(elements[i].attributes[2].value == component.get("v.onboardStep")){
                        elements[i].classList.add("slds-is-active");
                    }
                    else{
                        elements[i].classList.remove("slds-is-active");     
                    }        
                }
                var progressText = document.getElementsByClassName("slds-p-bottom_x-small");
                var progressBar = document.getElementsByClassName("slds-progress-bar");
                for(var i=0; i<progressBar[0].attributes.length;i++){
                    if(progressBar[0].attributes[i].name=="aria-valuenow"){
                        progressBar[0].attributes[i].value= companyval.Completion_Progress__c;
                    }
                }
                var progressBarValue = document.getElementsByClassName("slds-progress-bar__value");
                for(var i=0; i<progressBarValue[0].attributes.length;i++){
                    if(progressBarValue[0].attributes[i].name=="style"){
                        progressBarValue[0].attributes[i].value= "width: " + companyval.Completion_Progress__c + "%;background: #FFDEDF";
                    }
                }
                if(component.get("v.onboardStep")!='agreements'){
                    component.set("v.showPrevious",false);
                  
                }else if(companyval.Contract_Signed_Date__c!=null && (companyval.Partner_Level__c!="Strategic" && companyval.Partner_Level__c != "Master Agent"
          && companyval.Partner_Level__c!="Master Agent EMEA" && companyval.Partner_Level__c!="StrategicEMEA" )){
                         component.set("v.stepNum",2);
                }else if(companyval.Partner_Level__c=="StrategicEMEA" && companyval.Click_To_Agree__c == true && companyval.Contract_Signed_Date__c!=null){
                    component.set("v.stepNum",2);
                }else if(companyval.Partner_Level__c=="StrategicEMEA" && companyval.Click_To_Agree__c == true && companyval.Contract_Signed_Date__c==null){
                    component.set("v.stepNum",1);
                }
                    else if(companyval.Partner_Level__c=="StrategicEMEA" && companyval.Click_To_Agree__c == false){
                    component.set("v.stepNum",1);
                }
                
                 if(component.get("v.onboardStep") =='agreements' && component.get("v.stepNum") == 2){
                        component.set("v.showButtons",true);
                 }
                
            
                   
            }else{
                if(companyval.Partner_Level__c=="Strategic" || companyval.Partner_Level__c == "Master Agent"
          || companyval.Partner_Level__c=="Master Agent EMEA" || (companyval.Partner_Level__c=="StrategicEMEA" && companyval.Click_To_Agree__c == false)){
                    component.set("v.stepNum",1);
                var element = document.getElementById("savebutton");
    			element.parentNode.removeChild(element);
                var ele = document.getElementsByClassName("slds-vertical-tabs__link");            
                for(var j=0; j<ele.length; j++){
                    if(ele[j].innerHTML.toUpperCase().includes(component.get("v.onboardStep").toUpperCase())){
                      console.log(ele[j].attributes[6].value);
                        ele[j].attributes[6].value = "background-color: #EB0000;color: white;width: 200px;";
                    }
                }                 
                component.set("v.staticImp",2);
                }
                else{ 
                    component.set("v.stepNum",2);
                var element = document.getElementById("savebutton");
    			element.parentNode.removeChild(element);
                var ele = document.getElementsByClassName("slds-vertical-tabs__link");            
                for(var j=0; j<ele.length; j++){
                    if(ele[j].innerHTML.toUpperCase().includes(component.get("v.onboardStep").toUpperCase())){
                      console.log(ele[j].attributes[6].value);
                        ele[j].attributes[6].value = "background-color: #EB0000;color: white;width: 200px;";
                    }
                }                 
                component.set("v.staticImp",2);
}
               
                }
        }
    }
    
})