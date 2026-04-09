package com.workFlowTasks.common;

import java.util.Hashtable;
import java.util.*;

public class WFTaskConstants {
    private Hashtable departmentHeaders = new Hashtable();
    private Hashtable taskTypeHeaders = new Hashtable();
    
    public WFTaskConstants(){
        setwfTaskDeptHeaders();
        setwfTaskTypeHeaders();
    }
    
    private void setwfTaskDeptHeaders(){

        departmentHeaders.put("Enaccount", "Accounting");
        departmentHeaders.put("Araccount", "&#1575;&#1604;&#1581;&#1587;&#1575;&#1576;&#1575;&#1578;");
        
        departmentHeaders.put("Endevelopment", "Development");
        departmentHeaders.put("Ardevelopment", "&#1578;&#1591;&#1608;&#1610;&#1585; &#1575;&#1604;&#1576;&#1585;&#1575;&#1605;&#1580;");
        
        departmentHeaders.put("Enmanagement", "management");
        departmentHeaders.put("Armanagement", "&#1575;&#1604;&#1575;&#1583;&#1575;&#1585;&#1607;");
    }
    
    private void setwfTaskTypeHeaders(){
        
        taskTypeHeaders.put("Enservice", "Service");
        taskTypeHeaders.put("Arservice", "&#1582;&#1600;&#1600;&#1583;&#1605;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1607;");
        
        taskTypeHeaders.put("Enpo", "Purchase Order");
        taskTypeHeaders.put("Arpo", "&#1571;&#1605;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1585; &#1588;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1585;&#1575;&#1569;");

    }
    
    public Hashtable getwfTaskDeptHeaders(){
        return departmentHeaders;
    }
    
    public Hashtable getwfTaskTypeHeaders(){
        return taskTypeHeaders;
    }
}
