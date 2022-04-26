<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>PSA_Misc_Adjustment_Approved_False</fullName>
        <field>pse__Approved__c</field>
        <literalValue>0</literalValue>
        <name>PSA Misc Adjustment Approved False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSA_Misc_Adjustment_Approved_True</fullName>
        <field>pse__Approved__c</field>
        <literalValue>1</literalValue>
        <name>PSA Misc Adjustment Approved True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSA_Misc_Adjustment_IFF_False</fullName>
        <field>pse__Include_In_Financials__c</field>
        <literalValue>0</literalValue>
        <name>PSA Misc Adjustment IFF False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSA_Misc_Adjustment_IFF_True</fullName>
        <field>pse__Include_In_Financials__c</field>
        <literalValue>1</literalValue>
        <name>PSA Misc Adjustment IFF True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>PSA Misc Adjustment Approved False</fullName>
        <actions>
            <name>PSA_Misc_Adjustment_Approved_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PSA_Misc_Adjustment_IFF_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Triggers when a Misc Adjustment is changed to a status that is NOT approved</description>
        <formula>NOT(ISPICKVAL(pse__Status__c,&apos;Approved&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PSA Misc Adjustment Approved True</fullName>
        <actions>
            <name>PSA_Misc_Adjustment_Approved_True</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PSA_Misc_Adjustment_IFF_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>pse__Miscellaneous_Adjustment__c.pse__Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>Triggers when a Misc Adjustment&apos;s Status is marked as Approved</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
