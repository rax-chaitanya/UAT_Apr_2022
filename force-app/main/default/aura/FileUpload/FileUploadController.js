({  
    doInit:function(component,event,helper){ 
        //alert('Hi');
       helper.getuploadedFiles(component);
    },      
    
    previewFile :function(component,event,helper){  
        var rec_id = event.currentTarget.id;  
        $A.get('e.lightning:openFiles').fire({ 
            recordIds: [rec_id]
        });  
    },  
    
    UploadFinished : function(component, event, helper) {  
        var uploadedFiles = event.getParam("files");
        console.log('UPLOADED FILE: '+JSON.stringify(uploadedFiles));
        var documentId = uploadedFiles[0].documentId;  
        //var fileName = uploadedFiles[0].name; 
        helper.getuploadedFiles(component, documentId);         
       
    }, 
    
    delFiles:function(component,event,helper){
        component.set("v.Spinner", true); 
        var documentId = event.currentTarget.id;        
        helper.delUploadedfiles(component,documentId);  
    }
 })