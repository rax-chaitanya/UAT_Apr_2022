<aura:application extends="force:slds" implements="force:appHostable,flexipage:availableForRecordHome,force:hasRecordId" controller="RevenueForecastController">
    <aura:attribute name="recordId" type="Id"/>
    

     <c:RevenueInvoiceInformation recordId="{!v.recordId}"/> 
	
</aura:application>