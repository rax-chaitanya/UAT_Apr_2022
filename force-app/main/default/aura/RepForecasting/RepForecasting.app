<aura:application extends="force:slds" implements="force:appHostable">
    <aura:attribute name="rec_id" type="Id"/>
    <c:RepForecastTable aura:id="rep-forecast-table" rec_id="{!v.rec_id}" />
</aura:application>