/*
 * CIConstants.java
 *
 * Created on September 29, 2005, 5:45 PM
 *
 * To change this template, choose Tools | Options and locate the template under
 * the Source Creation and Management node. Right-click the template and choose
 * Open. You can then make changes to the template in the Source Editor.
 */

package com.sw.constants;

import java.util.*;
import org.w3c.dom.*;
import java.io.Serializable;

/**
 *
 * @author Yasmeen
 */
public class CIConstants implements Serializable {
    
    private Properties configImages = new  Properties();
    
    /** Creates a new instance of CIConstants */
    public CIConstants() {
        
        configImages.put("Use Case", "usecase.gif");
        configImages.put("NONE", "conticon.gif");
        configImages.put("General", "conticon.gif");
        configImages.put("Test Case", "testcase.gif");
        configImages.put("Project Plan", "projectplan.gif");
        configImages.put("Project Schedule", "projectschedule.gif");
        configImages.put("SRS Component", "srs.gif");
        configImages.put("SDD", "sdd.gif");
        configImages.put("Test Plan", "testplan.gif");
        configImages.put("Project Brief", "brief.gif");
        configImages.put("Proposal", "proposal.gif");
        configImages.put("Source Code", "code.gif");
        configImages.put("Contract", "contract.gif");
        configImages.put("SW Configuration Management Plan", "scm.gif");
        configImages.put("Development Standard", "standard.gif");
        configImages.put("User Manual", "usermanual.gif");
        configImages.put("Unit Test Data", "unittestcase.gif");
        configImages.put("Use Case Cluster", "uccluster.gif");
        
    }
    
    public String getImage(String key) {
        return (String) configImages.getProperty(key);
    }
    
}
