({
    getTheTranscripts : function(component) {
        var service = component.find("service");
        service.findChatsWithoutSurveys($A.getCallback(function(error, data) {
            console.log(data.length);
            component.set("v.transcripts", data);
        }));

		
	}
})