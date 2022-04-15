({
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // @developer   :    Diego Castro
    // @date        :    01/08/2018
    // @description :    
    // 					 
    // 					 
    //////////////////////////////////////////////////////////////////////////////////////////////////    
    promise : function(component, helperFunction) {
        return new Promise($A.getCallback(function(resolve, reject) {
            helperFunction(component, resolve, reject);
        }));
    }    })