<aura:application extends="ltng:outApp" implements="force:appHostable,flexipage:availableForAllPageTypes">
    <lightning:icon iconName="standard:task" alternativeText="Task" /> 
   <!-- <aura:handler name="init" value="{!this}" action="{!c.doInit}"/>-->
    <aura:attribute name="label" type="String" />
    <aura:dependency resource="c:CreateLatticeTask"/>
</aura:application>