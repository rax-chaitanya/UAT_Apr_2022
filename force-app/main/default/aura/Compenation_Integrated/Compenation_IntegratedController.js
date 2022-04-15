({
    handleChange: function (cmp, event) {
        var changeValue = event.getParam("value");
        cmp.set("v.value",changeValue);
    /*    var eve = cmp.get("v.info");
        if(eve){
            console.log("$$$$$$$$$$$$$",eve);
            cmp.set("v.info",false);
            cmp.set("v.comp",true);

        }
        else{
	        console.log(cmp.get("v.comp")); 
             cmp.set("v.info",true);
            cmp.set("v.comp",false);
        }
       // console.log(event.getParams());
        console.log(changeValue);
    */
    },
    
       
})