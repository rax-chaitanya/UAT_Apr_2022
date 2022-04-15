({
    CSV_COLUMNS : ["Account_Number", "New_Owner_Id", "Request_Reason"],
    CSV_DATA : ["1234XXX", "005XXXXXXX", "New Rep"],
    INVALID_FILE_ERROR : "The uploaded file is invalid, Please refer to sample template for reference.",
    INVALID_DATA_ERROR : "The uploaded file has invalid data. Please validate the uploaded file and try again",
    
    save : function(component) {
        var fileInput = component.find("file").getElement();
        var files = fileInput.files;
        var self = this;
        for(var i = 0; i<files.length; i++){
            var file = files[i];
            if(file.name != null){
                readFile(file, this);
            }
        }
        function readFile(file, self){
            
            var fr = new FileReader();
            fr.file = file;
            var self = self;
            fr.onload = $A.getCallback(function() {
                var fileContents = fr.result;
                self.getRecordDetails(component, fileContents);
            });
            fr.readAsArrayBuffer(fr.file);
        }
        
    },
    
    getRecordDetails: function(component, fileContents) {
        
        var result = this.xlsxToJSON(component, fileContents);
        if(!result){
            return;
        }
        var action = component.get("c.getUploadedFileDetails");
        action.setParams({
            "dataString" : JSON.stringify(result)
        });
        action.setCallback(this, function(response){
            component.set("v.showSpinner", false);
            if(response.getState() === 'SUCCESS'){
                var returnValue = response.getReturnValue();
                
                if($A.util.isEmpty(response.getReturnValue())){
                    var message = 'No accounts found with your file, please try again with different file';
                    this.showMessage(component, message);
                }
                else{
                    component.set("v.Show_Result",true);
                    component.set("v.resultList",returnValue.result);
                    component.set("v.resultCount",returnValue.count);
                    component.set("v.missingAccounts", returnValue.missingAccounts);
                    
                    var selectAll = component.get("v.selectAll");
                    $A.enqueueAction(selectAll);
                }
            }
            else{
                this.showMessage(component, this.INVALID_DATA_ERROR);
            }
        });
        
        $A.enqueueAction(action);
        component.set("v.showSpinner", true);
    },
    
    xlsxToJSON : function(component, fileContents){
        var arraybuffer = fileContents;
        
        /* convert data to binary string */
        var data = new Uint8Array(arraybuffer);
        var arr = new Array();
        for(var i = 0; i != data.length; ++i) arr[i] = String.fromCharCode(data[i]);
        var bstr = arr.join("");
        
        /* Call XLSX */
        var workbook = XLSX.read(bstr, {type:"binary"});
        
        /* DO SOMETHING WITH workbook HERE */
        var first_sheet_name = workbook.SheetNames[0];
        /* Get worksheet */
        var worksheet = workbook.Sheets[first_sheet_name];
        var result = XLSX.utils.sheet_to_json(worksheet,{raw:false});
        console.log(result);
        return result;
    },
    
    csvStringToJSON : function(component, strData){
        var arrData = this.csvStringToArray(component, strData);
        var jsonData = this.arrayToJSON(component, arrData);
        return jsonData;
    },
    
    arrayToJSON : function(component, arrData){
        try{
            var jsonData = [];
            var properties = arrData[0];
            for(var propertyIndex in this.CSV_COLUMNS){
                var property = properties[propertyIndex];
                if(property == null || (property !=null && property.toUpperCase() != this.CSV_COLUMNS[propertyIndex].toUpperCase())){
                    this.showMessage(component, this.INVALID_FILE_ERROR);
                    return;
                }
            }
            
            properties = this.CSV_COLUMNS;
            
            for(var row=1; row<arrData.length; row++){
                var rowData = {};
                for(var propertyIndex in arrData[row]){
                    rowData[properties[propertyIndex]] = arrData[row][propertyIndex];
                }
                jsonData.push(rowData);
            }
            return jsonData;
        }
        catch(err){
            this.showMessage(component, this.INVALID_FILE_ERROR);
        }
    },
    
    csvStringToArray : function(component, strData){
        try{
            const objPattern = new RegExp(("(\\,|\\r?\\n|\\r|^)(?:\"([^\"]*(?:\"\"[^\"]*)*)\"|([^\\,\\r\\n]*))"),"gi");
            let arrMatches = null, arrData = [[]];
            while (arrMatches = objPattern.exec(strData)){
                if (arrMatches[1].length && arrMatches[1] !== ",")arrData.push([]);
                arrData[arrData.length - 1].push(arrMatches[2] ? 
                                                 arrMatches[2].replace(new RegExp( "\"\"", "g" ), "\"") :
                                                 arrMatches[3]);
            }
            
            return arrData;
        }
        catch(err){
            this.showMessage(component, this.INVALID_FILE_ERROR);
        }
    },
    
    showMessage : function(component, msg){
        $A.createComponent(
            "c:GAR_Notice",
            {
                "message": msg
            },
            function(newNotice, status, errorMessage){
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
    }
})