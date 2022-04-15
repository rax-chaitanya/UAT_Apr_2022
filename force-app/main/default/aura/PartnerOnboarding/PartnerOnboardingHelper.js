({
    getAccount : function(cmp,evt) {
        
        var action = cmp.get('c.getPartnerAccount');
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var retVal = response.getReturnValue();
                cmp.set('v.company',retVal);
                cmp.set('v.progress',retVal.Completion_Progress__c);
                if(retVal.Completion_Progress__c==100){
                    cmp.set('v.progressComplete',true); 
                    
                }
                if(retVal.Partner_Level__c == "Strategic" && retVal.Completion_Progress__c <=70
                   && retVal.onboard_step__c != 'onboarding'){
                    cmp.set("v.company.Completion_Progress__c",40);
                    
                }
                
            }else{
                alert('Error while accessing the page. Please contact System Administrator1');
            }
        });
        
        $A.enqueueAction(action);
    },
    gotoNextStep : function(component,event){
        var stepNum = component.get("v.stepNum");
        var onboardstep = component.get("v.onboardStep");
        var partlvl = component.get("v.company.Partner_Level__c");
        var clickAgree = component.get("v.company.Click_To_Agree__c");
        component.set("v.showPrevious",false);
        if(onboardstep == "agreements" && stepNum==1 && ((partlvl=="Strategic" || partlvl=="Master Agent" || partlvl=="Master Agent EMEA") 
                                                         || (partlvl=="StrategicEMEA" && clickAgree == false))){
            component.set("v.stepNum",1);
            component.set("v.onboardStep","payments");
            var ele = document.getElementsByClassName("slds-vertical-tabs__link");            
            for(var j=0; j<ele.length; j++){
                if(ele[j].innerHTML.toUpperCase().includes(component.get("v.onboardStep").toUpperCase())){
                    ele[j].attributes[6].value = "background-color: #EB0000;color: white;width: 200px;";
                }else{
                    ele[j].attributes[6].value = "background-color: #BABEC4; color: black;width: 200px;";
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
            if(component.get("v.progress") < 40){
                component.set("v.progress",40);
                var progressText = document.getElementsByClassName("slds-p-bottom_x-small");
                var progressBar = document.getElementsByClassName("slds-progress-bar");
                for(var i=0; i<progressBar[0].attributes.length;i++){
                    if(progressBar[0].attributes[i].name=="aria-valuenow"){
                        progressBar[0].attributes[i].value= 40;
                    }
                }
                var progressBarValue = document.getElementsByClassName("slds-progress-bar__value");
                for(var i=0; i<progressBarValue[0].attributes.length;i++){
                    if(progressBarValue[0].attributes[i].name=="style"){
                        progressBarValue[0].attributes[i].value= "width: " + 40 + "%;background: #FFDEDF;";
                    }
                }
            }
        }else if(onboardstep == "agreements" && stepNum == 15){
            component.set("v.stepNum",1);
            component.set("v.showButtons",false);        
        }else if(onboardstep == "agreements" && stepNum == 2){
            if(partlvl=="Reseller" || partlvl=="ResellerEMEA"){
                component.set("v.stepNum",1);
                component.set("v.onboardStep","onboarding");
                component.set("v.company.onboard_step__c","onboarding");
                var ele = document.getElementsByClassName("slds-vertical-tabs__link");            
                for(var j=0; j<ele.length; j++){
                    if(ele[j].innerHTML.toUpperCase().includes(component.get("v.onboardStep").toUpperCase())){
                        ele[j].attributes[6].value = "background-color: #EB0000;color: white;width: 200px;";
                    }else{
                        ele[j].attributes[6].value = "background-color: #BABEC4; color: black;width: 200px;";
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
            }
            else{
                component.set("v.stepNum",1);
                component.set("v.onboardStep","payments");
                component.set("v.company.onboard_step__c","payments");
                var ele = document.getElementsByClassName("slds-vertical-tabs__link");            
                for(var j=0; j<ele.length; j++){
                    if(ele[j].innerHTML.toUpperCase().includes(component.get("v.onboardStep").toUpperCase())){
                        ele[j].attributes[6].value = "background-color: #EB0000;color: white;width: 200px;";
                    }else{
                        ele[j].attributes[6].value = "background-color: #BABEC4; color: black;width: 200px;";
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
            }
            
        }else if(onboardstep == "payments" && stepNum == 1){
            component.set("v.stepNum",1);
            component.set("v.onboardStep","onboarding");
            component.set("v.company.onboard_step__c","onboarding");
            var ele = document.getElementsByClassName("slds-vertical-tabs__link");            
            for(var j=0; j<ele.length; j++){
                if(ele[j].innerHTML.toUpperCase().includes(component.get("v.onboardStep").toUpperCase())){
                    ele[j].attributes[6].value = "background-color: #EB0000;color: white;width: 200px;";
                }
                else{
                    ele[j].attributes[6].value = "background-color: #BABEC4; color: black;width: 200px;";
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
            if(component.get("v.progress") < 70){   
                component.set("v.progress",70);
                var progressText = document.getElementsByClassName("slds-p-bottom_x-small");
                var progressBar = document.getElementsByClassName("slds-progress-bar");
                for(var i=0; i<progressBar[0].attributes.length;i++){
                    if(progressBar[0].attributes[i].name=="aria-valuenow"){
                        progressBar[0].attributes[i].value= 70;
                    }
                }
                var progressBarValue = document.getElementsByClassName("slds-progress-bar__value");
                for(var i=0; i<progressBarValue[0].attributes.length;i++){
                    if(progressBarValue[0].attributes[i].name=="style"){
                        progressBarValue[0].attributes[i].value= "width: " + 70 + "%;background: #FFDEDF;";
                    }
                }
            }
        }else if(onboardstep == "onboarding" && stepNum == 7 && (partlvl=="Strategic" || partlvl=="StrategicEMEA")){
            component.set("v.stepNum",8);
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
        }else if(onboardstep == "onboarding" && stepNum == 6 && !(partlvl=="Strategic" || partlvl=="StrategicEMEA")){
            component.set("v.stepNum",7);
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
        }else{
            
            component.set("v.stepNum",stepNum+1);}
    },
    gotopreviousStep : function(component,event){
        var onboardstep = component.get("v.onboardStep");
        var stepNum = component.get("v.stepNum");
        var partlvl = component.get("v.company.Partner_Level__c");
        component.set("v.showNext",false);
        if(stepNum > 1){
            
            if(component.get("v.onboardStep") == "agreements"){
                if(stepNum == 2){
                    component.set("v.company.onboard_step__c","agreements");
                    component.set("v.showButtons",false);  
                }
                
            }else if(component.get("v.onboardStep") == "onboarding"){
                if(stepNum == 2 && partlvl=="Sub Agent"){
                    component.set("v.company.onboard_step__c","agreements");
                    component.set("v.showPrevious",true);
                    component.set("v.stepNum",1);
                }
                
            }
            
            
            
            component.set("v.stepNum",stepNum-1); 
            return;
        }
        
        if(stepNum == 1){
            
            if(onboardstep == "payments" &&
               (partlvl=="Strategic" || partlvl=="Master Agent" || partlvl=="Master Agent EMEA" 
                || (partlvl == "StrategicEMEA" && component.get("v.company.Click_To_Agree__c")==false))){
                stepNum=1;
                onboardstep = "agreements";
                component.set("v.showPrevious",true);
            }
            else if(onboardstep == "payments"){
                stepNum=2;
                onboardstep = "agreements";
                component.set("v.showPrevious",true);
                
            }else if(onboardstep == "onboarding"){
                if(partlvl=="Reseller" || partlvl=="ResellerEMEA"){
                    stepNum = 2;
                    onboardstep = "agreements";
                    component.set("v.showPrevious",true);
                }               
                else{
                    stepNum = 1;
                    onboardstep = "payments";
                }
                
            }else if(onboardstep == "agreements"){
                component.set("v.showPrevious",true);
            }
            
            component.set("v.stepNum",stepNum);
            component.set("v.onboardStep",onboardstep);
            component.set("v.company.onboard_step__c",onboardstep);
            var ele = document.getElementsByClassName("slds-vertical-tabs__link");            
            for(var j=0; j<ele.length; j++){
                if(ele[j].innerHTML.toUpperCase().includes(component.get("v.onboardStep").toUpperCase())){
                    ele[j].attributes[6].value = "background-color: #EB0000;color: white;width: 200px;";
                }else{
                    ele[j].attributes[6].value = "background-color: #BABEC4; color: black;width: 200px;";
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
        }
        
        
        
    },
    agreetToTerms : function(component,event){
        component.set("v.onboardStep","agreements");
        component.set("v.stepNum",2);
        component.set("v.showPrevious",true);
        component.set("v.showButtons",true);
        if(component.get("v.progress") < 40){
            
            component.set("v.progress",40);
            var progressText = document.getElementsByClassName("slds-grid_align-spread");
            //progressText[0].innerHTML = 40 + "% Complete";
            var progressBar = document.getElementsByClassName("slds-progress-bar");
            for(var i=0; i<progressBar[0].attributes.length;i++){
                if(progressBar[0].attributes[i].name=="aria-valuenow"){
                    progressBar[0].attributes[i].value= 40;
                }
            }
            var progressBarValue = document.getElementsByClassName("slds-progress-bar__value");
            for(var i=0; i<progressBarValue[0].attributes.length;i++){
                if(progressBarValue[0].attributes[i].name=="style"){
                    progressBarValue[0].attributes[i].value= "width: " + 40 + "%;background: #FFDEDF;";
                }
            }       
        }
        if(component.get("v.company.Contract_Signed_Date__c")==null){
            var action = component.get("c.setAgreementDate");
            action.setParams({
                
            });
            action.setCallback(this,function(response){
                
                if(response.getState() != 'SUCCESS'){
                    alert('Error while accessing the page. Please contact System Administrator');
                }
            });
            
            $A.enqueueAction(action);
        }
    },
    saveAndClose:function(component,event){
        if(!component.get("v.isFinished")){
            var action = component.get("c.saveProcessAndClose");
            var step = component.get("v.onboardStep");
            action.setParams({
                "progress":step
            });
            action.setCallback(this,function(response){
                if(response.getState() == 'SUCCESS'){
                    alert('Thank you for your interest in the Rackspace Partner Program.');
                    window.open('/'+$A.get("$Label.c.PartnerPortalName")+'/secur/logout.jsp','_top')
                }else if (response.getState() === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                } 
            });
            $A.enqueueAction(action);
        }else{
            var action = component.get("c.saveProcessAndClose");
            action.setParams({
                "progress": "completed"
            });
            action.setCallback(this,function(response){
                if(response.getState() == 'SUCCESS'){
                    window.location.href = '/'+$A.get("$Label.c.PartnerPortalName")+'/s/';
                }else if (response.getState() === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                } 
            });
            $A.enqueueAction(action);
        }
    }
})