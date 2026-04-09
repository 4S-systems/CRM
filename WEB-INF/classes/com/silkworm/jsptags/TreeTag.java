package com.silkworm.jsptags;

import com.contractor.db_access.MaintainableMgr;
import com.docviewer.db_access.FolderMgr;
import com.docviewer.db_access.ImageMgr;
import com.maintenance.db_access.CategoryMgr;
import com.maintenance.db_access.MaintenanceItemMgr;
import com.maintenance.db_access.UnitCategoryMgr;
import com.silkworm.business_objects.WebBusinessObject;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Vector;

public class TreeTag {
    
    private static java.util.List _jspx_dependants;
    
    /** Creates a new instance of DropdownDate */
    public TreeTag() {
    }
    
    public String getTreeTagAsString(String fieldName, String sTitle, String context, Vector vecFolder) {
        FolderMgr folderMgr = FolderMgr.getInstance();
        ImageMgr separatorMgr = ImageMgr.getInstance();
        folderMgr.cashData();
        //http://
//        Vector vecFolder = folderMgr.getCashedTableAsBusObjVector();
        String forTag = new String("        <script type=\"text/javascript\" src=\"js/formElements.js\"></script>\n");
        forTag = forTag + ("        <link rel=\"stylesheet\" type=\"text/css\" href=\"css/css_master.css\" />\n");
        forTag = forTag + ("\n");
        forTag = forTag + ("        <script type=\"text/javascript\">\n");
        forTag = forTag + ("            var sjwuic_ScrollCookie = new sjwuic_ScrollCookie('/index2.jsp', '/docs/doc_handling/index2.jsp'); \n");
        forTag = forTag + ("        </script>\n");
        forTag = forTag + ("\n");
        forTag = forTag + ("        <link id=\"link1\" rel=\"stylesheet\" type=\"text/css\" href=\"stylesheet.css\" />\n");
        forTag = forTag + ("        <div id=\"" + fieldName + "\" class=\"Tree \" style=\"position: absolute; width: 207px\"><div>\n");
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
        if(vecFolder != null){
            for(int i = 0; i < vecFolder.size(); i++){
                WebBusinessObject wbo = (WebBusinessObject) vecFolder.elementAt(i);
                String folderName;
                if(wbo.getAttribute("docTitle") != null){
                    folderName = wbo.getAttribute("docTitle").toString();
                } else {
                    folderName = wbo.getAttribute("folderName").toString();
                }
                String sALT = new String(folderName);
                if(folderName.indexOf("&#") > -1){
                    if(folderName.length() > 168){
                        folderName = folderName.substring(0, 167) + "...";
                    }
                } else if(folderName.length() > 24){
                    folderName = folderName.substring(0, 23) + "...";
                }
                String folderID;
                if(wbo.getAttribute("docID") != null){
                    folderID = wbo.getAttribute("docID").toString();
                } else {
                    folderID = wbo.getAttribute("folderID").toString();
                }
                forTag = forTag + ("                <div id=\"" + fieldName + ":treeNode" + i + "\" class=\"TreeRow \" onClick=\"onTreeNodeClick(this, event);\">\n");
                forTag = forTag + ("                    <div id=\"" + fieldName + ":treeNode" + i + "LineImages\" class=\"float\">\n");
                forTag = forTag + ("                        <a id=\"" + fieldName + ":treeNode" + i + ":turner\">\n");
                if(i != vecFolder.size() - 1){
                    forTag = forTag + ("                            <img id=\"" + fieldName + ":treeNode" + i + ":turner_image\" src=\"images/tree_handlerightmiddle.gif\" alt=\"\" border=\"0\" />\n");
                } else {
                    forTag = forTag + ("                            <img id=\"" + fieldName + ":treeNode" + i + ":turner_image\" src=\"images/tree_handlerightlast.gif\" alt=\"\" border=\"0\" />\n");
                }
                forTag = forTag + ("                        </a>\n");
                forTag = forTag + ("                        <img id=\"" + fieldName + ":treeNode" + i + ":image" + i + "\" src=\"images/tree_folder.gif\" alt=\"" + sALT + "\" border=\"0\" />\n");
                forTag = forTag + ("                    </div>\n");
                forTag = forTag + ("                    <div id=\"" + fieldName + ":treeNode" + i + "Text\" class=\"TreeContent TreeImgHeight\" style=\"text-align:left;color:#000099\">\n");
                forTag = forTag + ("                        " + folderName + "\n");
                forTag = forTag + ("                    </div>\n");
                forTag = forTag + ("                </div>\n");
                forTag = forTag + ("                <div id=\"" + fieldName + ":treeNode" + i + "_children\" style=\"display: none;\">\n");
                try {
                    Vector vecSeparator = separatorMgr.getOnArbitraryKey(folderID, "key1");
                    for(int j = 0; j < vecSeparator.size(); j++){
                        WebBusinessObject separator = (WebBusinessObject) vecSeparator.elementAt(j);
                        String sID = separator.getAttribute("docID").toString();
                        String sLink = new String(context + "/ImageReaderServlet?op=ListSptr&docType=sptr&docId=" + sID + "&metaType=cntr&filter=ListSptr&filterValue=" + sID);
                        forTag = forTag + ("                    <div id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + "\" class=\"TreeRow \" onClick=\"onTreeNodeClick(this, event);\">\n");
                        forTag = forTag + ("                        <div id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + "LineImages\" class=\"float\">\n");
                        if(i != vecFolder.size() - 1){
                            forTag = forTag + ("                            <img id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + ":icon1\" src=\"images/tree_linevertical.gif\" alt=\"\" border=\"0\" />\n");
                        } else {
                            forTag = forTag + ("                            <img id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + ":icon1\" src=\"images/tree_blank.gif\" alt=\"\" border=\"0\" />\n");
                        }
                        if(j != vecSeparator.size() - 1){
                            forTag = forTag + ("                            <img id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + ":icon2\" src=\"images/tree_linemiddlenode.gif\" alt=\"\" border=\"0\" />\n");
                        } else {
                            forTag = forTag + ("                            <img id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + ":icon2\" src=\"images/tree_linelastnode.gif\" alt=\"\" border=\"0\" />\n");
                        }
                        forTag = forTag + ("                            <img id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + ":image" + j + "\" src=\"images/tree_document.gif\" alt=\"\" border=\"0\" />\n");
                        forTag = forTag + ("                        </div>\n");
                        forTag = forTag + ("                        <div id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + "Text\" class=\"TreeContent TreeImgHeight\" style=\"text-align:left;\">\n");
                        forTag = forTag + ("                            <a href=\"" + sLink + "\">" + separator.getAttribute("docTitle") + "</a>\n");
                        forTag = forTag + ("                        </div>\n");
                        forTag = forTag + ("                    </div>\n");
                    }
                } catch (SQLException ex) {
                    ex.printStackTrace();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                forTag = forTag + ("                </div>\n");
            }
        }
        forTag = forTag + ("            </div>\n");
        forTag = forTag + ("            <script type=\"text/javascript\">\n");
        forTag = forTag + ("                updateHighlight(\"" + fieldName + "\");\n");
        forTag = forTag + ("                    \n");
        forTag = forTag + ("                setCookieValue(\"" + fieldName + "\" + \"-expand\", null);\n");
        forTag = forTag + ("            </script><div>\n");
        forTag = forTag + ("\n");
        forTag = forTag + ("                <a name=\"" + fieldName + "_skipHyperlink\"></a>\n");
        forTag = forTag + ("            </div>\n");
        forTag = forTag + ("        </div>\n");
        return forTag;
    }
    
    public String getEquipmentTree(String fieldName, String sTitle, String context, Vector vecEquipment) {
//        FolderMgr folderMgr = FolderMgr.getInstance();
        UnitCategoryMgr unitCategoryMgr = UnitCategoryMgr.getInstance();
//        folderMgr.cashData();
        //http://
//        Vector vecEquipment = folderMgr.getCashedTableAsBusObjVector();
        String forTag = new String("        <script type=\"text/javascript\" src=\"js/formElements.js\"></script>\n");
        forTag = forTag + ("        <link rel=\"stylesheet\" type=\"text/css\" href=\"css/css_master.css\" />\n");
        forTag = forTag + ("\n");
        forTag = forTag + ("        <script type=\"text/javascript\">\n");
        forTag = forTag + ("            var sjwuic_ScrollCookie = new sjwuic_ScrollCookie('/index2.jsp', '/docs/doc_handling/index2.jsp'); \n");
        forTag = forTag + ("        </script>\n");
        forTag = forTag + ("\n");
        forTag = forTag + ("        <link id=\"link1\" rel=\"stylesheet\" type=\"text/css\" href=\"stylesheet.css\" />\n");
        forTag = forTag + ("        <div id=\"" + fieldName + "\" class=\"Tree \" style=\"position: absolute; width: 200px; top: 150px\"><div>\n");
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
        if(vecEquipment != null){
            for(int i = 0; i < vecEquipment.size(); i++){
                WebBusinessObject wbo = (WebBusinessObject) vecEquipment.elementAt(i);
                String equipmentName;
                if(wbo.getAttribute("unitName") != null){
                    equipmentName = wbo.getAttribute("unitName").toString();
                } else {
                    equipmentName = new String("");
                }
                String sALT = new String(equipmentName);
//                if(equipmentName.indexOf("&#") > -1){
//                    if(equipmentName.length() > 168){
//                        equipmentName = equipmentName.substring(0, 167) + "...";
//                    }
//                } else if(equipmentName.length() > 24){
//                    equipmentName = equipmentName.substring(0, 23) + "...";
//                }
//                String folderID;
//                if(wbo.getAttribute("docID") != null){
//                    folderID = wbo.getAttribute("docID").toString();
//                } else {
//                    folderID = wbo.getAttribute("folderID").toString();
//                }
                String equipmentID = (String) wbo.getAttribute("id");
                forTag = forTag + ("                <div id=\"" + fieldName + ":treeNode" + i + "\" class=\"TreeRow \" onClick=\"onTreeNodeClick(this, event);\">\n");
                forTag = forTag + ("                    <div id=\"" + fieldName + ":treeNode" + i + "LineImages\" class=\"float\">\n");
                forTag = forTag + ("                        <a id=\"" + fieldName + ":treeNode" + i + ":turner\">\n");
                if(i != vecEquipment.size() - 1){
                    forTag = forTag + ("                            <img id=\"" + fieldName + ":treeNode" + i + ":turner_image\" src=\"images/tree_handlerightmiddle.gif\" alt=\"\" border=\"0\" />\n");
                } else {
                    forTag = forTag + ("                            <img id=\"" + fieldName + ":treeNode" + i + ":turner_image\" src=\"images/tree_handlerightlast.gif\" alt=\"\" border=\"0\" />\n");
                }
                forTag = forTag + ("                        </a>\n");
                forTag = forTag + ("                        <img id=\"" + fieldName + ":treeNode" + i + ":image" + i + "\" src=\"images/tree_folder.gif\" alt=\"" + sALT + "\" border=\"0\" />\n");
                forTag = forTag + ("                    </div>\n");
                forTag = forTag + ("                    <div id=\"" + fieldName + ":treeNode" + i + "Text\" class=\"TreeContent TreeImgHeight\" style=\"text-align:left;color:#000099\">\n");
                forTag = forTag + ("                        " + equipmentName + "\n");
                forTag = forTag + ("                    </div>\n");
                forTag = forTag + ("                </div>\n");
                forTag = forTag + ("                <div id=\"" + fieldName + ":treeNode" + i + "_children\" style=\"display: none;\">\n");
                try {
                    Vector vecSeparator = unitCategoryMgr.getOnArbitraryKey(equipmentID, "key");
                    for(int j = 0; j < vecSeparator.size(); j++){
                        WebBusinessObject category = (WebBusinessObject) vecSeparator.elementAt(j);
                        String categoryID = category.getAttribute("categoryID").toString();
                        String sLink = new String(context + "/EquipmentServlet?op=EquipmentCategoryTree&categoryID=" + categoryID);
                        forTag = forTag + ("                    <div id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + "\" class=\"TreeRow \" onClick=\"onTreeNodeClick(this, event);\">\n");
                        forTag = forTag + ("                        <div id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + "LineImages\" class=\"float\">\n");
                        if(i != vecEquipment.size() - 1){
                            forTag = forTag + ("                            <img id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + ":icon1\" src=\"images/tree_linevertical.gif\" alt=\"\" border=\"0\" />\n");
                        } else {
                            forTag = forTag + ("                            <img id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + ":icon1\" src=\"images/tree_blank.gif\" alt=\"\" border=\"0\" />\n");
                        }
                        if(j != vecSeparator.size() - 1){
                            forTag = forTag + ("                            <img id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + ":icon2\" src=\"images/tree_linemiddlenode.gif\" alt=\"\" border=\"0\" />\n");
                        } else {
                            forTag = forTag + ("                            <img id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + ":icon2\" src=\"images/tree_linelastnode.gif\" alt=\"\" border=\"0\" />\n");
                        }
                        forTag = forTag + ("                            <img id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + ":image" + j + "\" src=\"images/tree_document.gif\" alt=\"\" border=\"0\" />\n");
                        forTag = forTag + ("                        </div>\n");
                        forTag = forTag + ("                        <div id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + "Text\" class=\"TreeContent TreeImgHeight\" style=\"text-align:left;\">\n");
                        forTag = forTag + ("                            <a href=\"" + sLink + "\">" + category.getAttribute("categoryName") + "</a>\n");
//                        forTag = forTag + ("                            " + category.getAttribute("categoryName") + "\n");
                        forTag = forTag + ("                        </div>\n");
                        forTag = forTag + ("                    </div>\n");
                    }
                } catch (SQLException ex) {
                    ex.printStackTrace();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                forTag = forTag + ("                </div>\n");
            }
        }
        forTag = forTag + ("            </div>\n");
        forTag = forTag + ("            <script type=\"text/javascript\">\n");
        forTag = forTag + ("                updateHighlight(\"" + fieldName + "\");\n");
        forTag = forTag + ("                    \n");
        forTag = forTag + ("                setCookieValue(\"" + fieldName + "\" + \"-expand\", null);\n");
        forTag = forTag + ("            </script><div>\n");
        forTag = forTag + ("\n");
        forTag = forTag + ("                <a name=\"" + fieldName + "_skipHyperlink\"></a>\n");
        forTag = forTag + ("            </div>\n");
        forTag = forTag + ("        </div>\n");
        return forTag;
    }
    
    public String getCategoryTree(String fieldName, String sTitle, String context) {
        CategoryMgr categoryMgr = CategoryMgr.getInstance();
        categoryMgr.cashData();
        MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
        ArrayList arCategory = categoryMgr.getCashedTableAsBusObjects();
        String forTag = new String("        <script type=\"text/javascript\" src=\"js/formElements.js\"></script>\n");
        forTag = forTag + ("        <link rel=\"stylesheet\" type=\"text/css\" href=\"css/css_master.css\" />\n");
        forTag = forTag + ("\n");
        forTag = forTag + ("        <script type=\"text/javascript\">\n");
        forTag = forTag + ("            var sjwuic_ScrollCookie = new sjwuic_ScrollCookie('/index2.jsp', '/docs/doc_handling/index2.jsp'); \n");
        forTag = forTag + ("        </script>\n");
        forTag = forTag + ("\n");
        forTag = forTag + ("        <link id=\"link1\" rel=\"stylesheet\" type=\"text/css\" href=\"stylesheet.css\" />\n");
        forTag = forTag + ("        <div id=\"" + fieldName + "\" class=\"Tree \" style=\"position: absolute; width: 200px; top: 150px\"><div>\n");
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
        if(arCategory != null){
            for(int i = 0; i < arCategory.size(); i++){
                WebBusinessObject wbo = (WebBusinessObject) arCategory.get(i);
                String categoryName = wbo.getAttribute("categoryName").toString();
                String sALT = new String(categoryName);
                String categoryID = (String) wbo.getAttribute("categoryId");
                String sLink = new String(context + "/EquipmentServlet?op=EquipmentCategoryTree&categoryID=" + categoryID + "&categoryName=" + categoryName);
                forTag = forTag + ("                <div id=\"" + fieldName + ":treeNode" + i + "\" class=\"TreeRow \" onClick=\"onTreeNodeClick(this, event);\">\n");
                forTag = forTag + ("                    <div id=\"" + fieldName + ":treeNode" + i + "LineImages\" class=\"float\">\n");
                forTag = forTag + ("                        <a id=\"" + fieldName + ":treeNode" + i + ":turner\">\n");
                if(i != arCategory.size() - 1){
                    forTag = forTag + ("                            <img id=\"" + fieldName + ":treeNode" + i + ":turner_image\" src=\"images/tree_handlerightmiddle.gif\" alt=\"\" border=\"0\" />\n");
                } else {
                    forTag = forTag + ("                            <img id=\"" + fieldName + ":treeNode" + i + ":turner_image\" src=\"images/tree_handlerightlast.gif\" alt=\"\" border=\"0\" />\n");
                }
                forTag = forTag + ("                        </a>\n");
                forTag = forTag + ("                        <img id=\"" + fieldName + ":treeNode" + i + ":image" + i + "\" src=\"images/tree_folder.gif\" alt=\"" + sALT + "\" border=\"0\" />\n");
                forTag = forTag + ("                    </div>\n");
                forTag = forTag + ("                    <div id=\"" + fieldName + ":treeNode" + i + "Text\" class=\"TreeContent TreeImgHeight\" style=\"text-align:left;color:#000099\">\n");
                forTag = forTag + ("                        <a href=\"" + sLink + "\">" + categoryName + "</a>\n");
                forTag = forTag + ("                    </div>\n");
                forTag = forTag + ("                </div>\n");
                forTag = forTag + ("                <div id=\"" + fieldName + ":treeNode" + i + "_children\" style=\"display: none;\">\n");
                try {
                    Vector vecItems = maintenanceItemMgr.getOnArbitraryKey(categoryID, "key2");
                    for(int j = 0; j < vecItems.size(); j++){
                        WebBusinessObject item = (WebBusinessObject) vecItems.elementAt(j);
                        String itemID = item.getAttribute("itemID").toString();
                        
                        forTag = forTag + ("                    <div id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + "\" class=\"TreeRow \" onClick=\"onTreeNodeClick(this, event);\">\n");
                        forTag = forTag + ("                        <div id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + "LineImages\" class=\"float\">\n");
                        if(i != arCategory.size() - 1){
                            forTag = forTag + ("                            <img id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + ":icon1\" src=\"images/tree_linevertical.gif\" alt=\"\" border=\"0\" />\n");
                        } else {
                            forTag = forTag + ("                            <img id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + ":icon1\" src=\"images/tree_blank.gif\" alt=\"\" border=\"0\" />\n");
                        }
                        if(j != vecItems.size() - 1){
                            forTag = forTag + ("                            <img id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + ":icon2\" src=\"images/tree_linemiddlenode.gif\" alt=\"\" border=\"0\" />\n");
                        } else {
                            forTag = forTag + ("                            <img id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + ":icon2\" src=\"images/tree_linelastnode.gif\" alt=\"\" border=\"0\" />\n");
                        }
                        forTag = forTag + ("                            <img width='19' id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + ":image" + j + "\" src=\"images/nonconfig.gif\" alt=\"\" border=\"0\" />\n");
                        forTag = forTag + ("                        </div>\n");
                        forTag = forTag + ("                        <div id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + "Text\" class=\"TreeContent TreeImgHeight\" style=\"text-align:left;\">\n");
                        forTag = forTag + ("                            " + item.getAttribute("itemDscrptn") + "\n");
                        forTag = forTag + ("                        </div>\n");
                        forTag = forTag + ("                    </div>\n");
                    }
                } catch (SQLException ex) {
                    ex.printStackTrace();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                forTag = forTag + ("                </div>\n");
            }
        }
        forTag = forTag + ("            </div>\n");
        forTag = forTag + ("            <script type=\"text/javascript\">\n");
        forTag = forTag + ("                updateHighlight(\"" + fieldName + "\");\n");
        forTag = forTag + ("                    \n");
        forTag = forTag + ("                setCookieValue(\"" + fieldName + "\" + \"-expand\", null);\n");
        forTag = forTag + ("            </script><div>\n");
        forTag = forTag + ("\n");
        forTag = forTag + ("                <a name=\"" + fieldName + "_skipHyperlink\"></a>\n");
        forTag = forTag + ("            </div>\n");
        forTag = forTag + ("        </div>\n");
        return forTag;
    }
    
    public String getCategoryTreeAr(String fieldName, String sTitle, String context) {
        CategoryMgr categoryMgr = CategoryMgr.getInstance();
        categoryMgr.cashData();
        MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
        ArrayList arCategory = categoryMgr.getCashedTableAsBusObjects();
        String forTag = new String("        <script type=\"text/javascript\" src=\"js/formElements.js\"></script>\n");
        forTag = forTag + ("        <link rel=\"stylesheet\" type=\"text/css\" href=\"css/css_master.css\" />\n");
        forTag = forTag + ("\n");
        forTag = forTag + ("        <script type=\"text/javascript\">\n");
        forTag = forTag + ("            var sjwuic_ScrollCookie = new sjwuic_ScrollCookie('/index2.jsp', '/docs/doc_handling/index2.jsp'); \n");
        forTag = forTag + ("        </script>\n");
        forTag = forTag + ("\n");
        forTag = forTag + ("        <link id=\"link1\" rel=\"stylesheet\" type=\"text/css\" href=\"stylesheet.css\" />\n");
        forTag = forTag + ("        <div id=\"" + fieldName + "\" class=\"Tree \" style=\"position: absolute; width: 200px; top: 150px\"><div>\n");
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
        if(arCategory != null){
            for(int i = 0; i < arCategory.size(); i++){
                WebBusinessObject wbo = (WebBusinessObject) arCategory.get(i);
                String categoryName = wbo.getAttribute("categoryName").toString();
                String sALT = new String(categoryName);
                String categoryID = (String) wbo.getAttribute("categoryId");
                String sLink = new String(context + "/EquipmentServlet?op=EquipmentCategoryTree&categoryID=" + categoryID + "&categoryName=" + categoryName);
                forTag = forTag + ("                <div id=\"" + fieldName + ":treeNode" + i + "\" class=\"TreeRow \" onClick=\"onTreeNodeClick(this, event);\">\n");
                forTag = forTag + ("                    <div id=\"" + fieldName + ":treeNode" + i + "LineImages\" class=\"float\">\n");
                forTag = forTag + ("                        <a id=\"" + fieldName + ":treeNode" + i + ":turner\">\n");
                if(i != arCategory.size() - 1){
                    forTag = forTag + ("                            <img id=\"" + fieldName + ":treeNode" + i + ":turner_image\" src=\"images/tree_handlerightmiddle.gif\" alt=\"\" border=\"0\" />\n");
                } else {
                    forTag = forTag + ("                            <img id=\"" + fieldName + ":treeNode" + i + ":turner_image\" src=\"images/tree_handlerightlast.gif\" alt=\"\" border=\"0\" />\n");
                }
                forTag = forTag + ("                        </a>\n");
                forTag = forTag + ("                        <img id=\"" + fieldName + ":treeNode" + i + ":image" + i + "\" src=\"images/tree_folder.gif\" alt=\"" + sALT + "\" border=\"0\" />\n");
                
                
                forTag = forTag + ("                    </div>\n");
                forTag = forTag + ("                    <div id=\"" + fieldName + ":treeNode" + i + "Text\" class=\"TreeContent TreeImgHeight\" style=\"text-align:right;color:#000099\">\n");
                forTag = forTag + ("                        <a href=\"" + sLink + "\">" + categoryName + "</a>\n");
                forTag = forTag + ("                    </div>\n");
                forTag = forTag + ("                </div>\n");
                forTag = forTag + ("                <div id=\"" + fieldName + ":treeNode" + i + "_children\" style=\"display: none;\">\n");
                try {
                    Vector vecItems = maintenanceItemMgr.getOnArbitraryKey(categoryID, "key2");
                    for(int j = 0; j < vecItems.size(); j++){
                        WebBusinessObject item = (WebBusinessObject) vecItems.elementAt(j);
                        String itemID = item.getAttribute("itemID").toString();
                        
                        forTag = forTag + ("                    <div id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + "\" class=\"TreeRow \" onClick=\"onTreeNodeClick(this, event);\">\n");
                        forTag = forTag + ("                        <div id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + "LineImages\" class=\"float\">\n");
                        
                        if(i != arCategory.size() - 1){
                            forTag = forTag + ("                            <img id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + ":icon1\" src=\"images/tree_linevertical.gif\" alt=\"\" border=\"0\" />\n");
                        } else {
                            forTag = forTag + ("                            <img id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + ":icon1\" src=\"images/tree_blank.gif\" alt=\"\" border=\"0\" />\n");
                        }
                        if(j != vecItems.size() - 1){
                            forTag = forTag + ("                            <img id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + ":icon2\" src=\"images/tree_linemiddlenode.gif\" alt=\"\" border=\"0\" />\n");
                        } else {
                            forTag = forTag + ("                            <img id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + ":icon2\" src=\"images/tree_linelastnode.gif\" alt=\"\" border=\"0\" />\n");
                        }
                        forTag = forTag + ("                            <img width='19' id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + ":image" + j + "\" src=\"images/nonconfig.gif\" alt=\"\" border=\"0\" />\n");
                        forTag = forTag + ("                        </div>\n");
                        forTag = forTag + ("                        <div id=\"" + fieldName + ":treeNode" + i + ":treeNode" + j + "Text\" class=\"TreeContent TreeImgHeight\" style=\"text-align:right;\">\n");
                        forTag = forTag + ("                            " + item.getAttribute("itemDscrptn") + "\n");
                        forTag = forTag + ("                        </div>\n");
                        forTag = forTag + ("                    </div>\n");
                    }
                } catch (SQLException ex) {
                    ex.printStackTrace();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                forTag = forTag + ("                </div>\n");
            }
        }
        forTag = forTag + ("            </div>\n");
        forTag = forTag + ("            <script type=\"text/javascript\">\n");
        forTag = forTag + ("                updateHighlight(\"" + fieldName + "\");\n");
        forTag = forTag + ("                    \n");
        forTag = forTag + ("                setCookieValue(\"" + fieldName + "\" + \"-expand\", null);\n");
        forTag = forTag + ("            </script><div>\n");
        forTag = forTag + ("\n");
        forTag = forTag + ("                <a name=\"" + fieldName + "_skipHyperlink\"></a>\n");
        forTag = forTag + ("            </div>\n");
        forTag = forTag + ("        </div>\n");
        return forTag;
    }
}
