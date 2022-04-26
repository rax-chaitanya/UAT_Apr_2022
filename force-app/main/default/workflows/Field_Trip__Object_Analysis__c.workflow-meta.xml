<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Field_Trip__Send_Processing_Complete_Notification2</fullName>
        <description>Send Processing Complete Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Field_Trip__Field_Trip_Postcards/Field_Trip__Processing_Completed</template>
    </alerts>
    <rules>
        <fullName>Field_Trip__Processing Complete</fullName>
        <actions>
            <name>Field_Trip__Send_Processing_Complete_Notification2</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Field_Trip__Last_Analyzed__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
