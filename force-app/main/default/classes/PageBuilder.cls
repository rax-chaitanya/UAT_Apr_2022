public class PageBuilder {



    public static Component.Apex.StyleSheet getStyleSheet(Component_Manager__c fm) {
        Component.Apex.StyleSheet sheet = new Component.Apex.StyleSheet();
        if (String.isNotBlank(fm.Expressions_Value__c)) { sheet.expressions.value = fm.Expressions_Value__c;}        
        if (String.isNotBlank(fm.Component_ID__c)) { fm.Id = fm.Component_ID__c; }
        return sheet;
    }
    
    
    public static Component.Apex.IncludeScript getIncludeScript(Component_Manager__c cm) {
        Component.Apex.IncludeScript cmp = new Component.Apex.IncludeScript();
        
        if ( String.isNotBlank( cm.expressions_value__c 	)) 	{ cmp.expressions.value 	= cm.expressions_value__c; 	} 
        else if (String.isNotBlank(cm.value__c)) { cmp.value = cm.value__c; } 
        
                                                                               
        return cmp;
    }
    
    
    
    
    public static Page_Manager__c getPage(String pageName) {
        Page_Manager__c pm = new Page_Manager__c();
        pm = [SELECT Id, Name, Title__c, Page_ID__c, Standard_Stylesheets__c FROM Page_Manager__c 
                WHERE Name = :pageName];
        return pm;
    }
    
    public static List<Section_Manager__c> getSectionsByPageName(String pageName) {
        List<Section_Manager__c>  sm = new list<section_manager__c>();
        sm = [SELECT Id, Name__c, Order__c, Page__c, Rendered__c, Mode__c, styleClass__c, Name,
                (SELECT Id, Name, RecordTypeId, Parent_Query__c, Field_Order__c, Field_Name__c, Is_Hidden__c, Section__c, Component_Type__c, escape__c,
                 Expressions_Title__c, expressions_value__c, Expressions_Action__c, expressions_rendered__c, onClick__c, Action__c, layout__c,
                 Mode__c, Parent_Entry__c, styleClass__c, Component_ID__c, location__c, immediate__c, required__c, Columns__c, dir__c, label__c, 
                 alt__c, disabled__c, reRender__c, onBlur__c, Value__c, Expressions_Label__c, rendered__c, title__c, var__c, facets__c, style__c, expressions_required__c, for__c,
                 event__c, expressions_onclick__c, expressions_onchange__c, onchange__c, onKeyUp__c,Expressions_Disabled__c,
                 description__c, subTitle__c, type__c, onkeyPress__c, headerValue__c, startText__c, stopText__c, onStop__c, expressions_selected__c, selected__c, status__c, size__c, width__c, height__c,
                 expressions_filename__c, expressions_contentType__c, expressions_onComplete__c, onComplete__c FROM Components__r where RecordType.Name = 'Form Entry' AND Active__c = true)                               
                FROM Section_Manager__c WHERE Page__r.Name = :pageName order by Order__c];    
        return sm;
    }
    
    
    
    
    public static ApexPages.Component createSection(Section_Manager__c sm) {
        ApexPages.Component panel = new Component.Apex.OutputPanel();

        Map<String, Map<Integer, Component_Manager__c>> formEntryHierarchy = new Map<String, Map<Integer, Component_Manager__c>>();
        for (Component_Manager__c fm : sm.Components__r) {
            String stringified_parent_entry = String.valueOf(fm.Parent_Entry__c) == null ? 'parent' : String.valueOf(fm.Parent_Entry__c);
            
            //reverse the logic for the if else to pass into the if more often
            if (!formEntryHierarchy.containsKey(stringified_parent_entry)) {
                formEntryHierarchy.put( stringified_parent_entry, new Map<Integer, Component_Manager__c>());
            }
            formEntryHierarchy.get( stringified_parent_entry ).put ( (Integer) fm.Field_Order__c, fm);
        }
        
        string rootid = 'parent';        
        return sectionHelper (panel, rootID, formEntryHierarchy) ;
        
    }
    
   public static Component.Apex.InputFile getInputFile(Component_Manager__c fm) {
        Component.apex.InputFile inp = new Component.Apex.InputFile();


        if (String.isNotBlank(fm.expressions_value__c)) {inp.expressions.value = fm.expressions_value__c; }
        if (String.isNotBlank(fm.expressions_filename__c)) {inp.expressions.filename = fm.expressions_filename__c; }
        if (String.isNotBlank(fm.expressions_contentType__c)) {inp.contentType = fm.expressions_contentType__c; }
        
        if (String.isNotBlank(fm.component_id__c)) {inp.id = fm.component_id__c; }
        
        

        return inp;
    }
        
    
    
    public static Component.Apex.SelectCheckboxes getSelectCheckboxes(Component_Manager__c cm) {
        Component.Apex.SelectCheckboxes component = new Component.Apex.SelectCheckboxes();

        if (String.isNotBlank(cm.expressions_value__c) )  { component.expressions.value = cm.expressions_value__c; }
        
        if (String.isNotBlank(cm.expressions_title__c) )  { component.expressions.title = cm.expressions_title__c; }
        else if (String.isNotBlank(cm.title__c)) 		  { component.title				= cm.title__c; 			   }
        

        
        if (!cm.rendered__c && String.isBlank(cm.expressions_rendered__c) )  { component.rendered = cm.rendered__c; }
        else if (String.isNotBlank(cm.expressions_rendered__c) ) { component.expressions.rendered = cm.expressions_rendered__c; }
        
        return component;
        
    }
    
        
    
    private static ApexPages.Component sectionHelper(
        ApexPages.Component root,            
        String rootID,
        Map<String, Map<Integer, Component_Manager__c>> formEntryHierarchy 
    ) 
    {
        
        if (formEntryHierarchy.containsKey(rootId)) {
            
            List<Integer> order = new List<Integer>(formEntryHierarchy.get(rootID).keySet());
            order.sort();
            
            for (Integer i : order) {
                Component_Manager__c sectionEntry = formEntryHierarchy.get(rootID).get(i);
                Boolean willContinue = true;
                
                ApexPages.Component next;
                if ((sectionEntry.Component_Type__c).equalsIgnoreCase('Command Button')) {
                    next = getCommandButton(sectionEntry);
                } else if ((sectionEntry.Component_Type__c).equalsIgnoreCase('Command Link')) {
                    next = getCommandLink(sectionEntry);
                } else if ((sectionEntry.Component_Type__c).equalsIgnoreCase('Section Header')) {
                    next = getSectionHeader(sectionEntry);
                } else if ((sectionEntry.Component_Type__c).equalsIgnoreCase('Input Hidden')) {
                    next = getInputHidden(sectionEntry);
                } else if ((sectionEntry.Component_Type__c).equalsIgnoreCase('Select List')) {
                    next = getSelectList(sectionEntry);
                } else if ((sectionEntry.Component_Type__c).equalsIgnoreCase('Input Field')) {
                    next = getInputField(sectionEntry);
                } else if ((sectionEntry.Component_Type__c).equalsIgnoreCase('Include Script')) {
                    next = getIncludeScript(sectionEntry);
                }                
                else if ((sectionEntry.Component_Type__c).equalsIgnoreCase('Input Checkbox')) {
                    next = getInputCheckbox(sectionEntry);
                } else if ((sectionEntry.Component_Type__c).equalsIgnoreCase('Input Text')) {
                    next = getInputText(sectionEntry);
                } else if ((sectionEntry.Component_Type__c).equalsIgnoreCase('Form')) {
                    next = getForm(sectionEntry);
                } else if ((sectionEntry.Component_Type__c).equalsIgnoreCase('Input File')) {
                    next = getInputFile(sectionEntry);
                } else if ((sectionEntry.Component_Type__c).equalsIgnoreCase('Input Text Area')) {
                    next = getInputTextArea(sectionEntry);
                } else if ((sectionEntry.Component_Type__c).equalsIgnoreCase('Image')) {
                    next = getImage(sectionEntry);
                } else if ((sectionEntry.Component_Type__c).equalsIgnoreCase('Select Checkboxes')) {
                    next = getSelectCheckboxes(sectionEntry);
                } 
                
                else if ((sectionEntry.Component_Type__c).equalsIgnoreCase('Output Field')) {
                    next = getOutputField(sectionEntry);
                } else if ((sectionEntry.Component_Type__c).equalsIgnoreCase('Output Panel')) {
                    next = getOutputPanel(sectionEntry);
                } else if ((sectionEntry.Component_Type__c).equalsIgnoreCase('Page Block')) {
                    next = getPageBlock(sectionEntry);
                } else if ((sectionEntry.Component_Type__c).equalsIgnoreCase('Output Text')) {
                    next = getOutputText(sectionEntry);
                } else if ((sectionEntry.Component_Type__c).equalsIgnoreCase('Page Messages')) {
                    next = getPageMessages(sectionEntry);
                } else if ((sectionEntry.Component_Type__c).equalsIgnoreCase('Page Block Buttons')) {
                    next = getPageBlockButtons(sectionEntry);
                } else if ((sectionEntry.Component_Type__c).equalsIgnoreCase('Page Block Section')) {
                    next = getPageBlockSection(sectionEntry);
                } else if ((sectionEntry.Component_Type__c).equalsIgnoreCase('Stylesheet')) {
                    next = getStylesheet(sectionEntry);
                } else if ((sectionEntry.Component_Type__c).equalsIgnoreCase('Page Block Table')) {
                    next = getPageBlockTable(sectionEntry);
                } else if ((sectionEntry.Component_Type__c).equalsIgnoreCase('Column')) {
                    next = getColumn(sectionEntry);
                } else if ((sectionEntry.Component_Type__c == 'Page Block Section Item')) {
                    next = getPageBlockSectionitem(sectionEntry);                    
                } else if ((sectionEntry.Component_Type__c == 'Output Label')) {
                    next = getOutputLabel(sectionEntry);                    
                } else if ((sectionEntry.Component_Type__c == 'Select Radio')) {
                    next = getSelectRadio(sectionEntry);
                } else if ((sectionEntry.Component_Type__c == 'Select Option')) {
                    next = getSelectOption(sectionEntry);
                } else if ((sectionEntry.Component_Type__c == 'Select Options')) {
                    next = getSelectOptions(sectionEntry);
                } 
                else if ((sectionEntry.Component_Type__c == 'Action Region')) {
                    next = getActionRegion(sectionEntry);                    
                } else if ((sectionEntry.Component_Type__c == 'Action Support')) {
                    next = getActionSupport(sectionEntry);                  
                } else if ((sectionEntry.Component_Type__c == 'Action Status')) {
                    next = getActionStatus(sectionEntry);                  
                } 
                else {
                    willContinue = false;
                }            
                if (willContinue) {
                    if (sectionEntry.facets__c == 'header' || sectionEntry.facets__c == 'footer') {
                        Component.Apex.Column tmp = (Component.Apex.Column) root;
                        tmp.facets.header = next;
                        root = tmp;
                    } else {
                    root.childComponents.add(next);
                        
                    }
                    sectionHelper( next, String.valueOf(sectionEntry.id), formEntryHierarchy);
                }
            } 
        }
        return root;                                                        
    }
    
    
    public static Component.Apex.SelectRadio getSelectRadio(Component_Manager__c fm) {
        System.debug('getSelectRadio(' + fm.id + ')');
        Component.apex.SelectRadio comp = new Component.Apex.SelectRadio();
        
        if (String.isNotBlank(fm.expressions_value__c)) {comp.expressions.value = fm.expressions_value__c; }
        if (String.isNotBlank(fm.expressions_onchange__c)) {comp.expressions.onchange = fm.expressions_onchange__c; }
        
        return comp;
        
    }
    
    
    public Static Component.Apex.ActionStatus getActionStatus(Component_Manager__c cm) {
        Component.Apex.ActionStatus acs = new Component.Apex.ActionStatus();
        
        
        if (String.isNotBlank(cm.component_id__C)) acs.id = cm.component_id__c;
        if (String.isNotBlank(cm.startText__c)) acs.startText = cm.startText__c;
        if (String.isNotBlank(cm.stopText__c)) acs.stopText = cm.stopText__c;
        if (String.isNotBlank(cm.onStop__c)) acs.onStop = cm.onStop__c;
        
        
        return acs;        
    }
    
    
    public static Component.Apex.InputTextArea getInputTextArea(Component_Manager__c fm) {
        Component.apex.InputTextArea inp = new Component.Apex.InputTextArea();


        if (String.isNotBlank(fm.expressions_value__c)) {inp.expressions.value = fm.expressions_value__c; }
        if (String.isNotBlank(fm.component_id__c)) {inp.id = fm.component_id__c; }
        
        

        return inp;
    }
        
    
    
    //https://developer.salesforce.com/docs/atlas.en-us.pages.meta/pages/pages_compref_commandButton.htm
    public static Component.Apex.CommandButton getCommandButton(Component_Manager__c fm) {
        Component.Apex.CommandButton cmdBtn = new Component.Apex.CommandButton();
        
        //if (String.isNotBlank( fm.Expressions_Label__c  	)) 	{ cmdBtn.expressions.label 		= fm.expressions_label__c;   	}
        if (String.isNotBlank( fm.Expressions_Action__c 	)) 	{ cmdBtn.expressions.action 	= fm.expressions_action__c; 	}
        if (String.isNotBlank( fm.expressions_rendered__c	)) 	{ cmdBtn.expressions.rendered 	= fm.expressions_rendered__c;   }
        if (String.isNotBlank( fm.Expressions_Title__c  	)) 	{ cmdBtn.expressions.title 		= fm.expressions_title__c;   	}
        if (String.isNotBlank( fm.Expressions_Value__c  	)) 	{ cmdBtn.expressions.value 		= fm.expressions_value__c;   	}
        if (String.isNotBlank( fm.Expressions_Disabled__c  	)) 	{ cmdBtn.expressions.disabled 		= fm.expressions_disabled__c;   	}
        
        
        
        if (String.isNotBlank( fm.component_Id__c  	)) 	{ cmdBtn.id 		= fm.component_Id__c;   	}
        if (String.isNotBlank( fm.value__c  	)) 	{ cmdBtn.value 		= fm.value__c;   	}
        if (String.isNotBlank( fm.alt__c  	)) 		{ cmdBtn.alt 		= fm.alt__c;   	}
        if (String.isNotBlank( fm.dir__c  	)) 		{ cmdBtn.dir 		= fm.dir__c;   	}
        if (String.isNotBlank( fm.status__c  	)) 		{ cmdBtn.status 		= fm.status__c;   	}
        
        if (String.isNotBlank( fm.styleClass__c  	)) 		{ cmdBtn.styleClass 		= fm.styleClass__c;   	}
        
        if (String.isNotBlank( fm.title__c  	)) 	{ cmdBtn.title 		= fm.title__c;   	}
        if ( 	fm.disabled__c  	) 				{ cmdBtn.disabled 		= fm.disabled__c;   	}        
        if ( 	fm.immediate__c  	) 				{ cmdBtn.immediate 		= fm.immediate__c;   	}   
        if (String.isNotBlank(fm.reRender__c  	)) 	{ cmdBtn.rerender 		= new Set<String>((fm.ReRender__c.replaceAll( '\\s+', '')).split(','));   	}   
        
        
        if (String.isNotBlank( fm.Expressions_onclick__c  	)) 	{ cmdBtn.expressions.onclick 		= fm.Expressions_onclick__c;   	}
        else if (String.isNotBlank(fm.onClick__c)) {cmdBtn.onClick = fm.onClick__c;}
        
        if (String.isNotBlank( fm.Expressions_onComplete__c  	)) 	{ cmdBtn.expressions.oncomplete 		= fm.Expressions_onComplete__c;   	}
        else if (String.isNotBlank(fm.onComplete__c)) {cmdBtn.onComplete = fm.onComplete__c;}
        
        
        
        //System.debug('commmand button: ' +  cmdBtn.rerender);
        return cmdBtn;
    }
    
    
    
    //https://developer.salesforce.com/docs/atlas.en-us.pages.meta/pages/pages_compref_outputPanel.htm    
    //dir, id, lang, layout, onclick, ondblclick, onkeydown, onkeypress, onkeyup, onmousedown, onmousemove, onmouseout, onmouseover, onmouseup, rendered, style, styleClass, title
    public static Component.Apex.OutputPanel getOutputPanel(Component_Manager__c fm) {
        Component.Apex.OutputPanel op = new Component.Apex.OutputPanel();
        if (String.isNotBlank( fm.dir__c 	)) 	{ op.dir 	= fm.dir__c; 	}
        if (String.isNotBlank( fm.component_id__c 	)) 	{ op.id 	= fm.component_id__c; 	}
        //if (String.isNotBlank( fm.lang__c 	)) 	{ op.lang 	= fm.lang__c; 	}
        if (String.isNotBlank( fm.layout__c 	)) 	{ op.layout 	= fm.layout__c; 	}
        //if (String.isNotBlank( fm.onDblClick__C 	)) 	{ op.onDblClick 	= fm.onDblClick__C; 	}
        //if (String.isNotBlank( fm.onKeyDown__c 	)) 	{ op.onKeyDown 	= fm.onKeyDown__c; 	}
        //if (String.isNotBlank( fm.onKeyPress__c 	)) 	{ op.onKeyPress 	= fm.onKeyPress__c; 	}
        if (String.isNotBlank( fm.onKeyUp__c 	)) 	{ op.onKeyUp 	= fm.onKeyUp__c; 	}
        //if (String.isNotBlank( fm.onMouseDown__c 	)) 	{ op.onMouseDown 	= fm.onMouseDown__c; 	}
        //if (String.isNotBlank( fm.onMouseMove__c 	)) 	{ op.onMouseMove 	= fm.onMouseMove__c; 	}
        //if (String.isNotBlank( fm.onMouseOut__c 	)) 	{ op.onMouseOut 	= fm.onMouseOut__c; 	}
        //if (String.isNotBlank( fm.onMouseOver__c 	)) 	{ op.onMouseOver 	= fm.onMouseOver__c; 	}
        //if (String.isNotBlank( fm.onMouseUp__c 	)) 	{ op.onMouseUp 	= fm.onMouseUp__c; 	}
        if ( !fm.rendered__C 	) 	{ op.expressions.rendered 	= '{!false}';	}
        if ( String.isNotBlank( fm.expressions_rendered__c 	)) 	{ op.expressions.rendered 	= fm.expressions_rendered__c; 	}
        if ( String.isNotBlank( fm.style__c	)) 	{ op.style 	= fm.style__c; 	}
        if ( String.isNotBlank( fm.styleClass__c	)) 	{ op.styleClass 	= fm.styleClass__c; 	}
        
        return op;
    }
    
    //https://developer.salesforce.com/docs/atlas.en-us.pages.meta/pages/pages_compref_inputField.htm    
    // id, label, list, 
    // onblur, onchange, onclick, ondblclick, onfocus, onkeydown, onkeypress, onkeyup, onmousedown, onmousemove, onmouseout, onmouseover, onmouseup, onselect,
    // rendered, required, showDatePicker, style, styleClass, taborderhint, type, value
    
    public static Component.Apex.InputField getInputField(Component_Manager__c fm) {
        //System.debug('getInputField( ' + fm.id + ')');
        Component.Apex.InputField  inputField = new Component.Apex.InputField();
        if ( String.isNotBlank( fm.component_id__c 	)) 	{ inputField.id 	= fm.component_id__c; 	}
        
        if ( String.isNotBlank( fm.expressions_onchange__c 	)) 	{ inputField.expressions.onchange 	= fm.expressions_onchange__c; 	} 
        else if ( String.isNotBlank( fm.onchange__c 	)) 	{ inputField.onchange 	= fm.onchange__c; 	} 

        
        if ( String.isNotBlank( fm.expressions_label__c 	)) 	{ inputField.expressions.label 	= fm.expressions_label__c; 	} 
        else if (String.isNotBlank(fm.label__c)) { inputField.label = fm.label__c; } 
            
        if ( String.isNotBlank( fm.expressions_value__c 	)) 	{ inputField.expressions.value 	= fm.expressions_value__c; 	} 
        else if (String.isNotBlank(fm.value__c)) { inputField.value = fm.value__c; } 
        if (String.isNotBlank(fm.expressions_rendered__c)) {
            inputField.expressions.rendered 	= fm.expressions_rendered__c; 	
        } else if (!fm.rendered__c) {
            inputField.expressions.rendered = '{!false}';
        }
        
        
        if (String.isNotBlank(fm.expressions_required__c)) {
            inputField.expressions.required 	= fm.expressions_required__c; 	
        } else if (fm.required__c) {
            inputField.expressions.required = '{!true}';
        }
                
        if (String.isNotBlank(fm.style__c)) 	{ inputField.style 	= fm.style__c; 	}
        if (String.isNotBlank(fm.styleClass__c)) 	{ inputField.styleClass 	= fm.styleClass__c; 	}
        //if (fm.tabOrderHint__c) 	{ inputField.tabOrderHint 	= fm.tabOrderHint__c; 	}
        if (String.isNotBlank(fm.type__c)) 	{ inputField.type 	= fm.type__c; 	}
        //if (String.isNotBlank( fm.onDblClick__C 	)) 	{ inputField.onDblClick 	= fm.onDblClick__C; 	}
        //if (String.isNotBlank( fm.onKeyDown__c 	)) 	{ inputField.onKeyDown 	= fm.onKeyDown__c; 	}
        if (String.isNotBlank( fm.onKeyPress__c 	)) 	{ inputField.onKeyPress 	= fm.onKeyPress__c; 	}
        if (String.isNotBlank( fm.onKeyUp__c 	)) 	{ inputField.onKeyUp 	= fm.onKeyUp__c; 	}
        if (String.isNotBlank( fm.onBlur__c 	)) 	{ inputField.onBlur 	= fm.onBlur__c; 	}
        if (String.isNotBlank( fm.onClick__c 	)) 	{ inputField.onClick 	= fm.onClick__c; 	} 
        else if (String.isNotBlank(fm.expressions_onclick__c)) inputfield.expressions.onclick = fm.expressions_onclick__c;


        
        
        //if (String.isNotBlank( fm.onMouseDown__c 	)) 	{ inputField.onMouseDown 	= fm.onMouseDown__c; 	}
        //if (String.isNotBlank( fm.onMouseMove__c 	)) 	{ inputField.onMouseMove 	= fm.onMouseMove__c; 	}
        //if (String.isNotBlank( fm.onMouseOut__c 	)) 	{ inputField.onMouseOut 	= fm.onMouseOut__c; 	}
        //if (String.isNotBlank( fm.onMouseOver__c 	)) 	{ inputField.onMouseOver 	= fm.onMouseOver__c; 	}
        //if (String.isNotBlank( fm.onMouseUp__c 	)) 	{ inputField.onMouseUp 	= fm.onMouseUp__c; 	}
        //if (String.isNotBlank( fm.onSelect__c 	)) 	{ inputField.onSelect 	= fm.onSelect__c; 	}
        
        
        //System.debug(inputField.expressions.required);
        
        return inputField;
    }
    
    
    private static String getTrue() {
        return 'true';
    }
    public static Component.Apex.InputText getInputText(Component_Manager__c fm) {
        Component.Apex.InputText inputText = new Component.Apex.InputText();
        return inputText;
    }


	// https://developer.salesforce.com/docs/atlas.en-us.pages.meta/pages/pages_compref_outputField.htm
    public static Component.Apex.OutputField getOutputField(Component_Manager__c fm) {
        Component.Apex.OutputField outputField = new Component.Apex.OutputField();
        // dir, id, label, lang, rendered, style, styleClass, title, value

        if ( String.isNotBlank( fm.dir__c 	)) 	{ outputField.dir 	= fm.dir__c; 	}
        if ( String.isNotBlank( fm.component_id__c 	)) 	{ outputField.id 	= fm.component_id__c; 	}
        if ( String.isNotBlank( fm.label__c 	)) 	{ outputField.label 	= fm.label__c; 	}
        //if ( String.isNotBlank( fm.lang__c 	)) 	{ outputField.lang 	= fm.lang__c; 	}
        if (String.isNotBlank(fm.expressions_rendered__c)) {
            outputField.expressions.rendered 	= fm.expressions_rendered__c; 	            
        } else if (!fm.rendered__c) {
            outputField.rendered = fm.rendered__c;
        }
        if ( String.isNotBlank( fm.style__c 	)) 	{ outputField.style 	= fm.style__c; 	}
        if ( String.isNotBlank( fm.styleClass__c 	)) 	{ outputField.styleClass 	= fm.styleClass__c; 	}
        if ( String.isNotBlank( fm.title__C 	)) 	{ outputField.title 	= fm.title__c; 	}
        
        if (String.isNotBlank(fm.expressions_value__c)) { outputField.expressions.value = fm.expressions_value__c;}
        else if ( String.isNotBlank( fm.value__c 	)) 	{ outputField.value 	= fm.value__c; 	}
        
        return outputField;
    }
    
    
    // https://developer.salesforce.com/docs/atlas.en-us.202.0.pages.meta/pages/pages_compref_pageBlock.htm
    public static Component.Apex.PageBlock getPageBlock(Component_Manager__c fm) {
        Component.Apex.PageBlock pageBlock = new Component.Apex.PageBlock();
        //dir, helpTitle, helpurl, id, lang, mode, onclick, ondblclick, onkeydown, onkeypress, onkeyup, onmousedown, onmousemove, onmouseout, onmouseover, onmouseup, rendered, tabStyle, title
        
        if (String.isNotBlank (fm.dir__c ) ) { pageBlock.dir = fm.dir__c; }
        //if (String.isNotBlank (fm.helpTitle__c ) ) { pageBlock.helpTitle = fm.helpTitle__c; }
        //if (String.isNotBlank (fm.helpURL__c ) ) { pageBlock.helpURL = fm.helpURL__c; }
        if (String.isNotBlank (fm.component_id__c ) ) { pageBlock.id = fm.component_id__c; }
        
        //else if (String.isNotBlank(fm.expressions_id__c) ) { pageBlock.expressions.id = fm.expressions_id__c; }
        
        if (String.isNotBlank (fm.mode__c ) ) { pageBlock.mode = fm.mode__c; }
        //if (String.isNotBlank( fm.onDblClick__C 	)) 	{ inputField.onDblClick 	= fm.onDblClick__C; 	}
        //if (String.isNotBlank( fm.onKeyDown__c 	)) 	{ inputField.onKeyDown 	= fm.onKeyDown__c; 	}
        //if (String.isNotBlank( fm.onKeyPress__c 	)) 	{ inputField.onKeyPress 	= fm.onKeyPress__c; 	}
        //if (String.isNotBlank( fm.onKeyUp__c 	)) 	{ inputField.onKeyUp 	= fm.onKeyUp__c; 	}
        //if (String.isNotBlank( fm.onMouseDown__c 	)) 	{ inputField.onMouseDown 	= fm.onMouseDown__c; 	}
        //if (String.isNotBlank( fm.onMouseMove__c 	)) 	{ inputField.onMouseMove 	= fm.onMouseMove__c; 	}
        //if (String.isNotBlank( fm.onMouseOut__c 	)) 	{ inputField.onMouseOut 	= fm.onMouseOut__c; 	}
        //if (String.isNotBlank( fm.onMouseOver__c 	)) 	{ inputField.onMouseOver 	= fm.onMouseOver__c; 	}
        //if (String.isNotBlank( fm.onMouseUp__c 	)) 	{ inputField.onMouseUp 	= fm.onMouseUp__c; 	}        
        if (!fm.rendered__c && String.isBlank(fm.expressions_rendered__c) )  { pageBlock.rendered = fm.rendered__c; }
        else if (String.isNotBlank(fm.expressions_rendered__c) ) { pageBlock.expressions.rendered = fm.expressions_rendered__c; }

        //if (String.isNotBlank (fm.tabStyle__c ) ) { pageBlock.tabStyle = fm.tabStyle__c; }
        if (String.isNotBlank (fm.expressions_title__c ) ) { pageBlock.expressions.title = fm.expressions_title__c; } 
        else if (String.isNotBlank (fm.title__c ) ) { pageBlock.title = fm.title__c; }
        
        return pageBlock;
    }

public static Component.Apex.SelectList getSelectList(Component_Manager__c fm) {
    Component.Apex.SelectList sl = new Component.Apex.SelectList();
    
    if (String.isNotBlank(fm.expressions_value__c)) sl.expressions.value = fm.expressions_value__c;

    if (fm.size__c != null) sl.size = (Integer) fm.size__c;
    
    return sl;
    
    
}
    
    
public static Component.Apex.SelectOption getSelectOption(Component_Manager__c fm) {
    Component.Apex.SelectOption comp = new Component.Apex.SelectOption();
    if (String.isNotBlank(fm.expressions_value__c)) {
        comp.expressions.itemValue = fm.expressions_value__c;
    } else if (String.isNotBlank(fm.value__c)) {
        comp.itemValue = fm.value__c;
    }
    if (String.isNotBlank(fm.expressions_label__c)) {
        comp.expressions.itemLabel = fm.expressions_label__c;
    } else if (String.isNotBlank(fm.label__c)) {
        comp.itemLabel = fm.label__c;
    }
    
    return comp;
}
    
public static Component.Apex.SelectOptions getSelectOptions(Component_Manager__c fm) {
    Component.Apex.SelectOptions comp = new Component.Apex.SelectOptions();
    if (String.isNotBlank(fm.expressions_value__c)) {
        comp.expressions.value = fm.expressions_value__c;
    } 
    
    return comp;
}
      
    
    
    
    public static Component.Apex.InputHidden getInputHidden(Component_Manager__c cm) {
        System.debug('getInputHidden(' + cm.id + ')');
        Component.Apex.InputHidden c = new Component.apex.InputHidden();
        
        if (String.isNotBlank(cm.component_id__c)) c.id = cm.component_id__c;
        if (cm.immediate__c) c.expressions.immediate = '{!true}';
        if (String.isNotBlank(cm.expressions_rendered__c))  c.expressions.rendered = cm.expressions_rendered__c;
        else if (!cm.rendered__c) c.expressions.rendered = '{!false}';
        
        if (String.isNotBlank(cm.expressions_value__c))  c.expressions.value = cm.expressions_value__c;
        else if (String.IsNotBlank(cm.value__c)) c.value = cm.value__c;
        
        
        if (String.isNotBlank(cm.expressions_required__c))  c.expressions.required = cm.expressions_required__c;
        else if (cm.required__c) c.expressions.required = '{!true}';
        
        System.debug(c.id);
        System.debug(c.expressions.value);
        System.debug(c.rendered);
        
            
        
        
        
        return c;
    }

    
    public static Component.Apex.SectionHeader getSectionHeader(Component_Manager__c fm) {
        System.debug('getSectionHeader()');
        Component.Apex.SectionHeader sectionHeader = new Component.Apex.SectionHeader();
        
        if (string.isnotBlank(fm.Component_ID__c)) sectionHeader.id = fm.Component_ID__c;
        
        if (String.isNotBlank(fm.title__c)) sectionHeader.title = fm.title__c;
        if (String.isNotBlank(fm.subTitle__c)) sectionHeader.subtitle = fm.subTitle__c;
        
        
        if (String.isNotBlank(fm.expressions_rendered__c)) sectionHeader.expressions.rendered = fm.expressions_rendered__c;
        if (String.isNotBlank(fm.description__c)) sectionHeader.description = fm.description__c;
        
        else if (!fm.rendered__c) sectionHeader.expressions.rendered = '{!false}';
        
        
        
        
        return sectionHeader;
    }
    
    
    public static Component.Apex.CommandLink getCommandLink(Component_Manager__c fm) {
        Component.Apex.CommandLink commandLink = new Component.Apex.CommandLink();
        
        // accesskey, action, charset, coords, dir, hreflang, id, immediate, lang
        // onclick, ondblclick, onkeydown, onkeypress, onkeyup, onmousedown, onmousemove, onmouseout, onmouseover, onmouseup        
        // rel, rendered, reRender, rev, shape, status, style, styleClass, tabindex, target, timeoutm title, type, value
        
        //if (String.isNotBlank(fm.accessKey__c)) {commandLink.accesskey = fm.accesskey__c};     
        if (String.isNotBlank( fm.Expressions_Action__c 	)) 	{ commandLink.expressions.action 	= fm.expressions_action__c; 	}
        if (String.isNotBlank( fm.expressions_rendered__c	)) 	{ commandLink.expressions.rendered 	= fm.expressions_rendered__c;   }
        if (String.isNotBlank( fm.expressions_onclick__c	)) 	{ commandLink.expressions.onclick 	= fm.expressions_onclick__c;   }
        
        if (String.isNotBlank( fm.Expressions_Title__c  	)) 	{ commandLink.expressions.title 		= fm.expressions_title__c;   	}
        if (String.isNotBlank( fm.Expressions_Value__c  	)) 	{ commandLink.expressions.title 		= fm.expressions_value__c;   	}
        
        if (String.isNotBlank( fm.component_Id__c  	)) 	{ commandLink.id 		= fm.component_Id__c;   	}
        if (String.isNotBlank( fm.value__c  	)) 	{ commandLink.value 		= fm.value__c;   	}
        if (String.isNotBlank( fm.dir__c  	)) 		{ commandLink.dir 		= fm.dir__c;   	}
        if (String.isNotBlank( fm.styleClass__c  	)) 		{ commandLink.styleClass 		= fm.styleClass__c;   	}
        if (String.isNotBlank( fm.style__c  	)) 		{ commandLink.style 		= fm.style__c;   	}
        
        if (String.isNotBlank( fm.title__c  	)) 	{ commandLink.title 		= fm.title__c;   	}
        if ( 	fm.immediate__c  	) 				{ commandLink.expressions.immediate 		= '{!true}';   	}   
        if (String.isNotBlank(fm.reRender__c  	)) 	{ commandLink.rerender 		= new Set<String>((fm.reRender__c).split(','));   	}   
        return commandLink;
    }
    
    
    //https://developer.salesforce.com/docs/atlas.en-us.202.0.pages.meta/pages/pages_compref_outputText.htm    
    public static Component.Apex.OutputText getOutputText(Component_Manager__c fm) {
        Component.Apex.OutputText outputText = new Component.Apex.OutputText();
        //dir, escape, id, label, lang, rendered, style, styleClass, title, value

        if (String.isNotBlank(fm.dir__c)) { outputText.dir = fm.dir__c; }
        if (!fm.escape__c) { outputText.escape  = false; }
        if (String.isNotBlank(fm.component_id__c)) { outputText.id = fm.component_id__C; }
        if (String.isNotBlank(fm.label__c)) { outputText.label = fm.label__c; }
        //if (String.isNotBlank(fm.lang__c)) { outputText.lang = fm.lang__c; }
        if (!fm.rendered__c && String.isBlank(fm.expressions_rendered__c) )  { outputText.expressions.rendered = '{!false}'; }
        else if (String.isNotBlank(fm.expressions_rendered__c) ) { outputText.expressions.rendered = fm.expressions_rendered__c; }
        //if (String.isNotBlank(fm.style__c)) { outputText.style = fm.style__c; }
        if (String.isNotBlank(fm.styleClass__c)) { outputText.styleClass = fm.styleClass__c; }
        if (String.isNotBlank(fm.title__c)) { outputText.title = fm.title__c; }
        if (String.isNotBlank(fm.expressions_value__c)) { outputText.expressions.value = fm.expressions_value__c;}
        else if ( String.isNotBlank( fm.value__c 	)) 	{ outputText.value 	= fm.value__c; 	}
                
        return outputText;
    }
    
    
    
    public static Component.Apex.ActionSupport getActionSupport(Component_Manager__c fm) {
        
        Component.Apex.ActionSupport actionSupport = new Component.Apex.ActionSupport();
        //assigning merge field val to expressions.action results in null

        if (String.isNotBlank (fm.component_id__c)) { actionSupport.id = fm.component_id__c; } 
        if (String.isNotBlank (fm.expressions_rendered__c)) { actionSupport.expressions.rendered = fm.expressions_rendered__c; } 
        else if (!fm.rendered__C) {actionSupport.expressions.rendered = '{!false}' ;}
        
        
        if (fm.immediate__c) {
            actionSupport.expressions.immediate = '{!true}' ;
        }
        
        if (String.isNotBlank (fm.event__c)) { actionSupport.event = fm.event__c; } 
        if (String.isNotBlank(fm.reRender__c  	)) 	{ actionSupport.rerender 		= new Set<String>((fm.rerender__c.replace(' ', '')).split(','));   	}   
        
        if (String.isNotBlank(fm.expressions_action__c)) {        actionSupport.expressions.action = String.valueOf(fm.expressions_action__c);}

        System.debug('action support:' + actionSupport.rerender);
		return actionSupport;        
    }
    
    
    
    public static Component.Apex.Form getForm(Component_Manager__c fm) {
        Component.Apex.Form form = new Component.Apex.Form();
        if (String.isNotBlank(fm.Component_ID__c)) { form.id = fm.component_id__c; }
        
        return form;
        
        
    }
    
    public static Component.Apex.InputCheckbox getInputCheckBox(Component_Manager__c fm) {
        Component.Apex.InputCheckbox c = new Component.Apex.InputCheckbox();
        
        
        if (String.isNotBlank(fm.expressions_selected__c)) c.expressions.selected = fm.expressions_selected__c;
        else if (fm.selected__c) c.expressions.selected = '{!false}';
        
        if (String.isNotBlank(fm.expressions_onclick__c)) c.expressions.onclick = fm.expressions_onclick__c;
        else if (String.isNotBlank(fm.onclick__c)) c.onclick = fm.onclick__c;
        
        if (String.isNotBlank(fm.expressions_onChange__c)) c.expressions.onChange = fm.expressions_onChange__c;
        //else if (String.isNotBlank(fm.onChange)) c.onChange = fm.onChange__c;
        
        

        

		return c;        
    }
    
    public static Component.Apex.Column getColumn (Component_Manager__c fm) {
        //System.debug('getColumn PARAM 1(' + fm );
        
        Component.Apex.Column column = new Component.Apex.Column();
        
        if (String.isNotBlank(fm.Component_Id__c)) { column.id = fm.component_id__c; }



        if (String.isNotBlank(fm.headerValue__c)) { column.headerValue = fm.headerValue__c; }
        
        if (String.isNotBlank(fm.value__c)) { column.value = fm.Value__C; }
        if (String.isNotBlank(fm.expressions_value__c)) { column.expressions.value = fm.expressions_Value__C; }	 // may cause issue for opp won wizard
        //System.debug(column.expressions.headervalue);
        
        
        return column;
    }
    
    public static Component.Apex.PageBlockTable getPageBlockTable (Component_Manager__c fm) {
        Component.Apex.PageBlockTable pageBlockTable = new Component.Apex.PageBlockTable();
        // align, bgcolor, border, captionClass, captionStyle, cellpadding, cellspacing, columnClasses, columns, columnsWidth, dir, first
        // footerClass, frame, headerClass, id, lang, 
        // onclick, ondblclick, onkeydown, onkeypress, onkeyup, onmousedown, onmousemove, onmouseout, onmouseover, onmouseup, 
        // onRowClick, onRowDblClick, onRowMouseDown, onRowMouseMove, onRowMouseOut, onRowMouseOver, onRowMouseUp,
        // rendered, rowClasses, rows, rules, style, styleClass, summary, title, value, var, width, 
        
        if (String.isNotBlank (fm.component_id__c)) { pageBlockTable.id = fm.Component_ID__c; }
        if (String.isNotBlank (fm.expressions_rendered__c)) { pageBlockTable.expressions.rendered = fm.expressions_rendered__c; } 
        else if (!fm.rendered__C) {pageBlockTable.expressions.rendered = '{!false}' ;}
        
        if (String.isNotBlank (fm.expressions_value__c)) { pageBlockTable.expressions.value = fm.expressions_value__c; } 

        

        if (String.isNotBlank (fm.var__c)) { pageBlockTable.var = fm.var__c; }
        
        
        return pageBlockTable;
        
        
    }
    
    
    
    public static Component.Apex.PageMessages getPageMessages(Component_Manager__c fm) {
        Component.Apex.PageMessages pageMessages= new Component.Apex.PageMessages();
        if (String.isNotBlank(fm.component_id__c)) pageMessages.id = fm.Component_ID__c;
        return pageMessages;
    }
    
    public static Component.Apex.ActionRegion getActionRegion (Component_Manager__c fm) {
        System.debug('Getting action region');
        Component.Apex.ActionRegion actionRegion = new Component.Apex.ActionRegion();
        return actionRegion;
    }
    
    
    public static Component.Apex.OutputLabel getOutputLabel(Component_Manager__c fm) {
        Component.Apex.OutputLabel OutputLabel= new Component.Apex.OutputLabel();
        if (String.isNotBlank(fm.for__c)) {outputLabel.for = fm.for__c; }
        if (String.isNotBlank(fm.expressions_value__c)) {
            OutputLabel.expressions.value 	= fm.expressions_value__c; 	
        } else if (String.isNotBlank(fm.value__c)) {
            OutputLabel.value = fm.value__c;
        }        
        
        if (String.isNotBlank(fm.expressions_title__c)) {
            OutputLabel.expressions.title 	= fm.expressions_title__c; 	
        } else if (String.isNotBlank(fm.title__c)) {
            OutputLabel.title = fm.title__c;
        }        
        
        
        if (String.isNotBlank(fm.expressions_rendered__c)) {
            OutputLabel.expressions.rendered 	= fm.expressions_rendered__c; 	
        } else if (!fm.rendered__c) {
            OutputLabel.expressions.rendered = '{!false}';
        }        
        
        if (!fm.escape__c) outputlabel.expressions.escape = '{!false}';
        
        
        return OutputLabel;
    }    
    
    
    public static Component.Apex.PageBlockButtons getPageBlockButtons(Component_Manager__c fm) {
        Component.Apex.PageBlockButtons PageBlockButtons= new Component.Apex.PageBlockButtons();
        if (String.IsNotBlank(fm.location__c)) {pageBlockButtons.location = fm.location__c;}
        
        if (String.isNotBlank(fm.expressions_rendered__c)) pageBlockButtons.expressions.rendered = fm.expressions_rendered__c;
        return PageBlockButtons;
    }
    
    public static Component.Apex.PageBlockSectionItem getPageBlockSectionitem(Component_Manager__c fm) {
        //System.debug('getPageBlockSectionItem(' + fm.id + ')');
        Component.Apex.PageBlockSectionItem pageBlockSectionitem = new COmponent.Apex.PageBlockSectionItem();
        if (String.isNotBlank(fm.expressions_rendered__c)) pageBlockSectionItem.expressions.rendered = fm.expressions_rendered__c; 
        else if (!fm.rendered__c) pageBlockSectionItem.expressions.rendered = '{!false}';
        return pageBlockSectionItem;
    }
    
    
    public static Component.Apex.PageBlockSection getPageBlockSection(Component_Manager__c fm) {
        //System.debug('getPageBlockSection(' + fm.id + ')');
        
        Component.Apex.PageBlockSection PageBlockSection = new Component.Apex.PageBlockSection();
        if (fm.columns__c != null) { pageBlockSection.columns = Integer.valueOf(fm.Columns__c);}
        if (String.isNotBlank(fm.Title__c)) { pageBlockSection.title = fm.title__c;}
        if (String.isNotBlank(fm.component_id__c)) { pageBlockSection.id = fm.component_id__c;}
        
        
        if (String.isNotBlank (fm.expressions_rendered__c)) { pageBlockSection.expressions.rendered = fm.expressions_rendered__c; } 
        else if (!fm.rendered__C) {pageBlockSection.expressions.rendered = '{!false}' ;}
        
        
        //if (String.isNotBlank(fm.columns__c ) ) { pageBlockSection.columns = Integer.valueOf(fm.columns__c); }
        
        return PageBlockSection;
    }
    
  public static Component.Apex.Image getImage(Component_Manager__c fm) {
        Component.apex.Image img = new Component.Apex.Image();
        
        if (String.isNotBlank(fm.expressions_value__c)) {img.expressions.value = fm.expressions_value__c; }
        if (String.isNotBlank(fm.width__c ) ) {img.width = fm.width__c ;}
        if (String.isNotBlank(fm.height__c ) ) {img.height = fm.height__c ;}
        
        
        
        
        
        
        
        return img;
    }    
    

    
    
    

    
    public Component.Apex.PageBlockButtons createPageBlockButtons(Component_Manager__c fm) {
        Component.Apex.PageBlockButtons pbButtons = new COmponent.Apex.PageBlockButtons();
        pbButtons.location = fm.Location__c;
        pbButtons.id = fm.Component_ID__c;
        pbButtons.onClick = fm.onClick__c;
        pbButtons.styleClass = fm.styleClass__c;
        
        
        return pbButtons;
        
    }
    
    


}