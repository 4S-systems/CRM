/*
 * OneDimentionMenu.java
 *
 * Created on January 7, 2004, 7:09 AM
 */

package com.silkworm.business_objects.secure_menu;

import com.silkworm.business_objects.*;
import org.w3c.dom.*;
import java.util.*;

/**
 *
 * @author  walid
 */
public class OneDimensionMenu extends WebBusinessObjectsContainer{
    
    private WebBusinessObject menuInfo = null;
    
    private Node myNode=null;
    
    /** Creates a new instance of OneDimentionMenu */
    public OneDimensionMenu() {
        super();
           
    }
    
    public OneDimensionMenu(Node n) {
        
        super();
       
        try {
            buildMenu(n);
            
            myName = menuInfo.getObjectKey();
        }
        catch(Exception e) {
            System.out.println("error    " + e.getMessage()); 
        }
        
       //  printSelf();
    }
    
    public OneDimensionMenu setNode(Node n) {
        myNode = n;
        try
        {
         buildMenu(n);
        }
        catch(Exception e)
        {
         System.out.println("Can not build menu  " + e.getMessage());   
        }   
        return this;
        
    }    

    public void buildMenu(Node node) throws Exception {
        
        if(node == null) {
            return;
        }
        int type = node.getNodeType();
        
        switch (type) {
            // handle document nodes
            case Node.DOCUMENT_NODE: {
                // System.out.println("<tr>");
                
                buildMenu(((Document)node).getDocumentElement());
                
                
                break;
            }
            // handle element nodes
            case Node.ELEMENT_NODE: {
                String elementName = node.getNodeName();
                if(elementName.equals("menu_element")) {
                    busObjects.add(new MenuElement(node));
                }
                else {
                    if(elementName.equals("submenuInfo")) {
                        menuInfo = new WebBusinessObject(node);
                    }
                }
                
                NodeList childNodes =
                node.getChildNodes();
                if(childNodes != null) {
                    int length = childNodes.getLength();
                    for (int loopIndex = 0; loopIndex <
                    length ; loopIndex++) {
                        buildMenu(childNodes.item(loopIndex));
                        
                    }
                }
                
                break;
            }
            // handle text nodes
            case Node.TEXT_NODE: {
                
                Node o = node.getParentNode();
                
                String data =
                node.getNodeValue().trim();
                
                if((data.indexOf("\n")  <0
                ) && (data.length()
                > 0)) {
                    
                }
            }
        }
    }
    
    public ArrayList getMenuItems() {
        return busObjects;
        
    }

    public WebBusinessObject getMenuInfo() {
        // raise exceptions if null
        return menuInfo;
    }
    
    @Override
    public void printSelf() {
        
        super.printSelf();
        menuInfo.printSelf();
        
    }

    public int getLength() {
        int length = 0;
        try {
            for (Object object : busObjects) {

                /* enable check if 'display' tag is required */
//                if(((WebBusinessObject) object).getAttribute("display").equals("1")) {
                length++;
//                }
            }

            return length;
        } catch(Exception ex) { return 0; }
    }
}
