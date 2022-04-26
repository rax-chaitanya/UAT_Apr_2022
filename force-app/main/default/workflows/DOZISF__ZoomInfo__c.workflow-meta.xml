<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>DOZISF__ZoomInfo_Set_Company_Record_Type</fullName>
        <description>Set ZoomInfo record type to Company.</description>
        <field>RecordTypeId</field>
        <lookupValue>DOZISF__Company</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ZoomInfo Set Company Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>true</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DOZISF__ZoomInfo_Set_Contact_Record_Type</fullName>
        <description>Set ZoomInfo record type to Contact.</description>
        <field>RecordTypeId</field>
        <lookupValue>DOZISF__Contact</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ZoomInfo Set Contact Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>true</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>DOZISF__ZoomInfo Company Created</fullName>
        <actions>
            <name>DOZISF__ZoomInfo_Set_Company_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set ZoomInfo Record Type to Company.</description>
        <formula>NOT( ISNULL( DOZISF__Account__c ) ) &amp;&amp; ISNULL(  RecordTypeId  )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>DOZISF__ZoomInfo Contact Created</fullName>
        <actions>
            <name>DOZISF__ZoomInfo_Set_Contact_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set ZoomInfo Record Type to Contact.</description>
        <formula>(NOT( ISNULL( DOZISF__Contact__c ) )  ||  NOT( ISNULL(  DOZISF__Lead__c  ) ) ) &amp;&amp; ISNULL(  RecordTypeId  )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
