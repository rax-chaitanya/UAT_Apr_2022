<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>LBI__Populate_HoldoutGroupAccountID</fullName>
        <field>LBI__HoldoutGroupAccount__c</field>
        <formula>LBI__Account__c &amp; &quot;~&quot; &amp; IF( LBI__Account__c != null, LBI__Account__c,  LBI__LEAccount__c )</formula>
        <name>Populate HoldoutGroupAccountID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>LBI__Populate HoldoutGroupAccountID%5F%5Fc</fullName>
        <actions>
            <name>LBI__Populate_HoldoutGroupAccountID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
