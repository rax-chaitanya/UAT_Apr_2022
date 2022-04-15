({
	showMessage : function(component,type,title,msg){
       // alert(msg);
        /*try{
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": msg
        });
        toastEvent.fire();
        }catch(error){
            alert(msg);
        }*/
        $A.createComponent(
            "c:GAR_Notice",
            {
                "message": msg
            },
            function(newNotice, status, errorMessage){
                console.log('message success');
                //Add the new button to the body array
                if (status === "SUCCESS") {
                    var notice = component.find('notice');
                    var body = notice.get("v.body");
                    while(body.length>0){
                        var cmp = body.pop();
                        cmp.destroy();
                    }
                    body.push(newNotice);
                    notice.set("v.body", body);
                }
            }
        );
    },
})