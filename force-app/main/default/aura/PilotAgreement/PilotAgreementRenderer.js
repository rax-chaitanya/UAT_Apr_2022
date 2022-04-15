({
    render: function(component,helper) {
        
        //var toAgreeAgreementsSize=0;
       // var AgreedagreementsSize=0;
        helper.getToAgreeUrls(component, event);
        helper.getAgreedUrls(component, event);
        
        return this.superRender();
        
    },
    /*rerender: function(component,helper){
        var toSize = component.get("v.toAgreesize")
        var agSize = component.get("v.agreedSize")
        var staticVar = component.get("v.static");
        if(staticVar == 1){
            if(toSize == 1 && agSize == 1 ){
                helper.disableTab(component);
            }
            component.set("v.static",2)
        }
        return this.superRerender();
    }*/
})