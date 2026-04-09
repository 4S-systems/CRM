package com.maintenance.common;

import java.util.Hashtable;
import java.util.*;

public class AppConstants {
    private Hashtable equipmentHeaders = new Hashtable();
    private Hashtable itemHeaders = new Hashtable();
    
    public AppConstants(){
        setEquipmentHeaders();
        setItemHeaders();
    }
    
    private void setEquipmentHeaders(){
        equipmentHeaders.put("AttUNIT_NAME", "unitName");
        equipmentHeaders.put("EnUNIT_NAME", "Eqipment Name");
        equipmentHeaders.put("ArUNIT_NAME", "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;");
        
        equipmentHeaders.put("AttUNIT_NO", "unitNo");
        equipmentHeaders.put("EnUNIT_NO", "Eqipment Code");
        equipmentHeaders.put("ArUNIT_NO", "&#1603;&#1608;&#1583; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;");
        
        equipmentHeaders.put("AttENGINE_NUMBER", "engineNo");
        equipmentHeaders.put("EnENGINE_NUMBER", "Engin Number");
        equipmentHeaders.put("ArENGINE_NUMBER", "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1581;&#1585;&#1603;");
        
        equipmentHeaders.put("AttMODEL_NO", "modelNo");
        equipmentHeaders.put("EnMODEL_NO", "Model Number");
        equipmentHeaders.put("ArMODEL_NO", "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1583;&#1610;&#1604;");
        
        equipmentHeaders.put("AttSERIAL_NO", "serialNo");
        equipmentHeaders.put("EnSERIAL_NO", "Serial Number");
        equipmentHeaders.put("ArSERIAL_NO", "&#1575;&#1604;&#1585;&#1602;&#1605; &#1575;&#1604;&#1578;&#1587;&#1604;&#1587;&#1604;&#1610;");
        
        equipmentHeaders.put("AttMANUFACTURER", "manufacturer");
        equipmentHeaders.put("EnMANUFACTURER", "Manufacturer");
        equipmentHeaders.put("ArMANUFACTURER", "&#1575;&#1604;&#1605;&#1589;&#1606;&#1593;");
        
        equipmentHeaders.put("AttSTATUS", "status");
        equipmentHeaders.put("EnSTATUS", "Equipment Status");
        equipmentHeaders.put("ArSTATUS", "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;");

        equipmentHeaders.put("AttTYPE_OF_RATE", "rateType");
        equipmentHeaders.put("EnTYPE_OF_RATE", "Rate Type");
        equipmentHeaders.put("ArTYPE_OF_RATE", "&#1575;&#1587;&#1575;&#1587; &#1575;&#1604;&#1578;&#1588;&#1594;&#1610;&#1604;");
        
        equipmentHeaders.put("AttTYPE_OF_OPERATION", "opType");
        equipmentHeaders.put("EnTYPE_OF_OPERATION", "Operation Type");
        equipmentHeaders.put("ArTYPE_OF_OPERATION", "&#1591;&#1585;&#1610;&#1602;&#1607; &#1575;&#1604;&#1578;&#1588;&#1594;&#1610;&#1604;");
        
        equipmentHeaders.put("AttNO_OF_HOURS", "noOfHours");
        equipmentHeaders.put("EnNO_OF_HOURS", "No Of Hours");
        equipmentHeaders.put("ArNO_OF_HOURS", "&#1593;&#1583;&#1583; &#1587;&#1575;&#1593;&#1575;&#1578; &#1575;&#1604;&#1578;&#1588;&#1594;&#1610;&#1604;");
         
        equipmentHeaders.put("AttSERVICE_ENTRY_DATE", "serviceEntryDATE");
        equipmentHeaders.put("EnSERVICE_ENTRY_DATE", "Servise Entry Date");
        equipmentHeaders.put("ArSERVICE_ENTRY_DATE", "&#1578;&#1575;&#1585;&#1610;&#1582; &#1583;&#1582;&#1608;&#1604; &#1575;&#1604;&#1582;&#1583;&#1605;&#1607;");
        
        equipmentHeaders.put("AttDESCRIPTION", "desc");
        equipmentHeaders.put("EnDESCRIPTION", "Equipment Description");
        equipmentHeaders.put("ArDESCRIPTION", "&#1575;&#1604;&#1608;&#1589;&#1601;");
    }
    
    private void setItemHeaders(){
        
        itemHeaders.put("AttITEM_NAME", "name");
        itemHeaders.put("EnITEM_NAME", "Item Name");
        itemHeaders.put("ArITEM_NAME", "&#1608;&#1589;&#1601; &#1575;&#1604;&#1576;&#1606;&#1583;");
        
        itemHeaders.put("AttCODE", "title");
        itemHeaders.put("EnCODE", "Item Code");
        itemHeaders.put("ArCODE", "&#1603;&#1608;&#1583; &#1575;&#1604;&#1576;&#1606;&#1583;");
        
        itemHeaders.put("AttTASK_TITLE", "taskTitle");
        itemHeaders.put("EnTASK_TITLE", "Task Title");
        itemHeaders.put("ArTASK_TITLE", "&#1606;&#1608;&#1593; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;");
        
        itemHeaders.put("AttREPAIR_TYPE", "repairtype");
        itemHeaders.put("EnREPAIR_TYPE", "Working Type");
        itemHeaders.put("ArREPAIR_TYPE", "&#1581;&#1580;&#1605; &#1575;&#1604;&#1593;&#1605;&#1604;");
        
        itemHeaders.put("AttEXECUTION_HRS", "executionHrs");
        itemHeaders.put("EnEXECUTION_HRS", "Duration");
        itemHeaders.put("ArEXECUTION_HRS", "&#1605;&#1578;&#1608;&#1587;&#1591; &#1575;&#1604;&#1587;&#1575;&#1593;&#1575;&#1578;");

        itemHeaders.put("AttENG_DESC", "engDesc");
        itemHeaders.put("EnENG_DESC", "English Description");
        itemHeaders.put("ArENG_DESC", "&#1575;&#1604;&#1608;&#1589;&#1601; &#1576;&#1575;&#1604;&#1575;&#1606;&#1580;&#1604;&#1610;&#1586;&#1609;");
        
    }
    
    public Hashtable getEquipmentHeaders(){
        return equipmentHeaders;
    }
    
      public Hashtable getItemHeaders(){
        return itemHeaders;
    }
}
