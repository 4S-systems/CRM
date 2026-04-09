package com.silkworm.jsptags;

import com.docviewer.db_access.FolderMgr;
import com.docviewer.db_access.ImageMgr;
import com.docviewer.db_access.SeparatorMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.TimeServices;
import com.silkworm.util.DateAndTimeConstants;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Vector;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspFactory;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.SkipPageException;
import com.contractor.db_access.MaintainableMgr;

public class MultiTreeTag {
    
    private static java.util.List _jspx_dependants;
    MaintainableMgr maintenable = MaintainableMgr.getInstance();
    String expandTreeString = new String("");
    
    public MultiTreeTag() {
    }
    
    public String getTreeTagAsString(String fieldName, String sTitle, String context, Vector vecFolder) {
        String forTag = new String("<script type=\"text/javascript\" src=\"js/formElements.js\"></script>\n");
        forTag = forTag + ("        <link rel=\"stylesheet\" type=\"text/css\" href=\"css/css_master.css\" />\n");
        forTag = forTag + ("        <script type=\"text/javascript\">\n");
        forTag = forTag + ("            var sjwuic_ScrollCookie = new sjwuic_ScrollCookie('/index2.jsp', '/docs/doc_handling/index2.jsp'); \n");
        forTag = forTag + ("        </script>\n");
        forTag = forTag + ("        <link id=\"link1\" rel=\"stylesheet\" type=\"text/css\" href=\"stylesheet.css\" />\n");
        forTag = forTag + ("        <div id=\"" + fieldName + "\" class=\"Tree \" style=\"position: absolute; width: 700px\"><div>\n");
        forTag = forTag + ("            <a href=\"#" + fieldName + "_skipHyperlink\" alt=\"Jump Over Tree Navigation Area.\">\n");
        forTag = forTag + ("            </a>\n");
        forTag = forTag + ("        </div>\n");
        forTag = forTag + ("            <script type=\"text/javascript\" src=\"js/tree.js\"></script>\n");
        forTag = forTag + ("            <div id=\"" + fieldName + "TitleBarSpacer\"" /* class=\"TreeRootRowHeader\"*/ + "></div>\n");
        forTag = forTag + ("            <div id=\"" + fieldName + "TitleBar\" class=\"TreeRootRow\">\n");
        forTag = forTag + ("                <span>\n");
        forTag = forTag + ("                    <div id=\"" + fieldName + "LineImages\" class=\"float\"></div>\n");
        forTag = forTag + ("                    <div id=\"" + fieldName + "Text\" class=\"TreeContent TreeImgHeight\">\n");
        forTag = forTag + ("                        " + sTitle + "\n");
        forTag = forTag + ("                    </div>\n");
        forTag = forTag + ("                </span>\n");
        forTag = forTag + ("            </div>\n");
        forTag = forTag + ("            <div id=\"" + fieldName + "_children\">\n");
        
        forTag = getBasicParentsAsString(vecFolder, forTag, fieldName);
        
        forTag = forTag + ("            </div>\n");
        forTag = forTag + ("            <script type=\"text/javascript\">\n");
        forTag = forTag + ("                updateHighlight(\"" + fieldName + "\");\n");
        forTag = forTag + ("                setCookieValue(\"" + fieldName + "\" + \"-expand\", null);\n");
        forTag = forTag + ("            </script>\n");
        forTag = forTag + ("            <div>\n");
        forTag = forTag + ("                <a name=\"" + fieldName + "_skipHyperlink\"></a>\n");
        forTag = forTag + ("            </div>\n");
        forTag = forTag + ("        </div>\n");
        
        return forTag;
    }
    
    public String getBasicParentsAsString(Vector vecFolder, String forTag, String fieldID) {
        if(vecFolder != null){
            for(int i = 0; i < vecFolder.size(); i++){
                
                WebBusinessObject wbo = (WebBusinessObject) vecFolder.elementAt(i);
                String folderName  = wbo.getAttribute("unitName").toString();
                
                String sALT = new String(folderName);
                if(folderName.indexOf("&#") > -1){
                    if(folderName.length() > 168){
                        folderName = folderName.substring(0, 167) + "...";
                    }
                } else if(folderName.length() > 24){
                    folderName = folderName.substring(0, 23) + "...";
                }
                
                String fieldName = fieldID + ":treeNode" + i;
                
                forTag = forTag + ("                    <div id=\"" + fieldName + "\" class=\"TreeRow \" onClick=\"onTreeNodeClick(this, event);\">\n");
                forTag = forTag + ("                        <div id=\"" + fieldName + "LineImages\" class=\"float\">\n");
                forTag = forTag + ("                            <a id=\"" + fieldName + ":turner\">\n");
                if(i != vecFolder.size() - 1){
                    forTag = forTag + ("                            <img id=\"" + fieldName + ":turner_image\" src=\"images/tree_handlerightmiddle.gif\" alt=\"\" border=\"0\" />\n");
                } else {
                    forTag = forTag + ("                            <img id=\"" + fieldName + ":turner_image\" src=\"images/tree_handlerightlast.gif\" alt=\"\" border=\"0\" />\n");
                }
                forTag = forTag + ("                            </a>\n");
                forTag = forTag + ("                            <img id=\"" + fieldName + ":image" + i + "\"  src=\"images/tree_folder.gif\" alt=\"" + sALT + "\" border=\"0\" />\n");
                forTag = forTag + ("                        </div>\n");
                forTag = forTag + ("                        <div id=\"" + fieldName + "Text\" class=\"TreeContent TreeImgHeight\" style=\"text-align:left;color:#000099\">\n");
                forTag = forTag + ("                            " + folderName + "\n");
                forTag = forTag + ("                        </div>\n");
                forTag = forTag + ("                    </div>\n");
                forTag = forTag + ("                    <div id=\"" + fieldName + "_children\" style=\"display: none;\">\n");
                
                //Complete your code here
                forTag = getTreeChildesAsString(wbo.getAttribute("id").toString(), forTag, fieldName);
                
                forTag = forTag + ("                    </div>\n");
            }
        }
        
        return forTag;
    }
    
    public String getMedelParentsAsString(String parentID, String forTag, String fieldName, int i) {
        WebBusinessObject wbo = (WebBusinessObject) maintenable.getOnSingleKey(parentID);
        String folderName  = wbo.getAttribute("unitName").toString();
        
        String sALT = new String(folderName);
        if(folderName.indexOf("&#") > -1){
            if(folderName.length() > 168){
                folderName = folderName.substring(0, 167) + "...";
            }
        } else if(folderName.length() > 24){
            folderName = folderName.substring(0, 23) + "...";
        }
        
        forTag = forTag + ("                        <div id=\"" + fieldName + "\" class=\"TreeRow \" onClick=\"onTreeNodeClick(this, event);\">\n");
        forTag = forTag + ("                            <div id=\"" + fieldName + "LineImages\" class=\"float\">\n");
        forTag = forTag + expandTreeString;
        forTag = forTag + ("                                <a id=\"" + fieldName + ":turner\">\n");
        forTag = forTag + ("                                    <img id=\"" + fieldName + ":turner_image\" src=\"images/tree_handlerightlast.gif\" alt=\"\" border=\"0\" />\n");
        forTag = forTag + ("                                </a>\n");
        forTag = forTag + ("                                <img id=\"" + fieldName + ":image" + i + "\" src=\"images/tree_folder.gif\" alt=\"" + sALT + "\" border=\"0\" />\n");
        forTag = forTag + ("                            </div>\n");
        forTag = forTag + ("                            <div id=\"" + fieldName + "Text\" class=\"TreeContent TreeImgHeight\" style=\"text-align:left;color:#000099\">\n");
        forTag = forTag + ("                                " + folderName + "\n");
        forTag = forTag + ("                            </div>\n");
        forTag = forTag + ("                        </div>\n");
        forTag = forTag + ("                        <div id=\"" + fieldName + "_children\" style=\"display: none;\">\n");
        
        //Complete your code here
        forTag = getTreeChildesAsString(wbo.getAttribute("id").toString(), forTag, fieldName);
        
        forTag = forTag + ("                        </div>\n");
        
        return forTag;
    }
    
    public String getTreeChildesAsString(String parentID, String forTag, String fieldID) {
        try{
            Vector unitsVector = maintenable.getOnArbitraryKey(parentID ,"key1");
            
            for(int i=0; i<unitsVector.size(); i++){
                WebBusinessObject wbo = (WebBusinessObject) unitsVector.elementAt(i);
                Integer unitLevel = new Integer(wbo.getAttribute("unitLevel").toString());
                
                Vector unitChildsVec = maintenable.getOnArbitraryKey(wbo.getAttribute("id").toString() ,"key1");
                
                String fieldName = fieldID + ":treeNode" + i;
                
                if(unitChildsVec != null && unitChildsVec.size()>0){
                    expandTreeString = "";
                    
                    for(int j=0; j<unitLevel.intValue()-1; j++){
                        expandTreeString = expandTreeString + ("                                <img id=\"" + fieldName + ":icon1\" src=\"images/tree_linevertical.gif\" alt=\"\" border=\"0\" />\n");
                    }
                    
                    forTag = getMedelParentsAsString(wbo.getAttribute("id").toString(), forTag, fieldName, i);
                } else {
                    if(unitLevel.intValue() == 2){
                        expandTreeString = "";
                    }
                    
                    expandTreeString = expandTreeString + ("                            <img id=\"" + fieldName + ":icon1\" src=\"images/tree_linevertical.gif\" alt=\"\" border=\"0\" />\n");
                    expandTreeString = expandTreeString + ("                            <img id=\"" + fieldName + ":icon2\" src=\"images/tree_linelastnode.gif\" alt=\"\" border=\"0\" />\n");
                    
                    forTag = forTag + ("                    <div id=\"" + fieldName + "\" class=\"TreeRow \" onClick=\"onTreeNodeClick(this, event);\">\n");
                    forTag = forTag + ("                        <div id=\"" + fieldName + "LineImages\" class=\"float\">\n");
                    forTag = forTag + expandTreeString;
                    forTag = forTag + ("                            <img id=\"" + fieldName + ":image" + i + "\" src=\"images/tree_document.gif\" alt=\"\" border=\"0\" />\n");
                    forTag = forTag + ("                        </div>\n");
                    forTag = forTag + ("                        <div id=\"" + fieldName + "Text\" class=\"TreeContent TreeImgHeight\" style=\"text-align:left;\">\n");
                    forTag = forTag + ("                        "+ wbo.getAttribute("unitName").toString() + "\n");
                    
                    forTag = getTreeChildesAsString(wbo.getAttribute("id").toString(), forTag, fieldName);
                    
                    forTag = forTag + ("                        </div>\n");
                    forTag = forTag + ("                    </div>\n");
                }
            }
        } catch(Exception ex){
            System.out.println("Tree building exception "+ex.getStackTrace());
        }
        return forTag;
    }
}
