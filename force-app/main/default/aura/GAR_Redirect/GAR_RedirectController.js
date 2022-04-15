({
    openGAR : function(component, event, helper){
        var newwindow = window.open('/c/GlobalAccountRealignment.app','GAR');
        if (window.focus) {newwindow.focus()}
        
        if (!newwindow.closed) {newwindow.focus()}
        return false;
    },
})