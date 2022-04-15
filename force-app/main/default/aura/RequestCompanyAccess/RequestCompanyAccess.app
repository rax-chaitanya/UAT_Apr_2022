<aura:application access="global" extends="force:slds" implements="force:appHostable,flexipage:availableForRecordHome,flexipage:availableForAllPageTypes,forceCommunity:availableForAllPageTypes,force:hasRecordId" controller="RequestCompanyAccessController">
    <aura:attribute name="recordId" type="Id"/>
    <aura:attribute name="inConsole" type="Boolean" default="false"/>
    <aura:attribute name="record" type="Object" />
    <aura:attribute name="userRecordAccess" type="Object" />
    <aura:attribute name="pendingAP" type="Object" description="If a pending approval process, it will be in this attribute"/>
    
    <aura:attribute name="pressed" type="Boolean" default="false"/>
    <aura:handler name="init" action="{!c.doInit}" value="{!this}"/>
    
    
    
    <div class="slds-grid slds-wrap">
        <div class="slds-col slds-size--1-of-1">
            <div class="slds-page-header" role="banner">
                <div class="slds-media">
                    <div class="slds-media__figure">
                    </div>
                    
                    <div class="slds-media__body">
                        <p class="slds-page-header__title slds-truncate slds-align-middle"
                           title="Face Detection App"> {!v.record.Name}
                        </p>
                        
                        <p class="slds-text-body--small slds-page-header__info">Request Company Access
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>    
    
    
    <div aura:id="div1"></div>
    
    
    <div class="slds-grid slds-wrap slds-grid">
        <div class="slds-col--padded  slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--4-of-6">
            <div class="slds-grid slds-box">
                <div class="slds-col">
                    <form class="slds-form slds-form_stacked">
                        <div class="slds-form-element">
                            <label class="slds-form-element__label" for="input-id-01">Company Owner Name</label>
                            <div class="slds-form-element__control">
                                <ui:outputText value="{!v.record.Owner.Name}"/>
                            </div>
                        </div>
                        
                        <aura:if isTrue="{! !empty(v.record.Owner.Manager.Name)}">
                            <div class="slds-form-element">
                                <label class="slds-form-element__label" for="input-id-02">Owner's Manager</label>
                                <div class="slds-form-element__control">
                                    <ui:outputText value="{!v.record.Owner.Manager.Name}"/>
                                </div>
                            </div>
                        </aura:if>
                        
                                                
                        <lightning:button label="Request Access" class="slds-m-top--medium" variant="brand" disabled="{!or(v.userRecordAccess.HasEditAccess, v.pressed)}" onclick="{!c.handleSubmit}"/> 
                        <aura:if isTrue="{! !(v.inConsole)}">
                        <lightning:button label="Go Back" class="slds-m-top--medium" variant="neutral" onclick="{!c.goToURL}"/>  
                        </aura:if>
                        <aura:if isTrue="{!(v.inConsole)}">
                            <lightning:button label="Close" class="slds-m-top--medium" variant="neutral" onclick="{!c.close}"/> 
                            </aura:if>
                    </form>  
                </div>
            </div>
        </div>
    </div>
    
</aura:application>