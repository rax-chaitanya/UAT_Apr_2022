<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>PSA_Set_TC_Exclude_from_Billing_True</fullName>
        <field>pse__Exclude_from_Billing__c</field>
        <literalValue>1</literalValue>
        <name>PSA Set TC Exclude from Billing True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>PSA Exclude %240 Billable Amounts on Timecard Splits</fullName>
        <actions>
            <name>PSA_Set_TC_Exclude_from_Billing_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Removes $0 Timecard Splits From Billing Event Generation</description>
        <formula>pse__Total_Billable_Amount__c = 0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
