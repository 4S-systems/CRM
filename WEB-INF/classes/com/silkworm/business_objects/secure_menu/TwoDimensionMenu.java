package com.silkworm.business_objects.secure_menu;

import com.silkworm.business_objects.*;
import com.silkworm.international.*;

import org.w3c.dom.*;

public class TwoDimensionMenu extends TwoDimensionsContainer{
    
    private WebBusinessObject menuRenderer = null;
    private WebBusinessObject menuInfo = null;
    private String[] secureMenu = null;
    private boolean contextInitialized = false;
    
    /** Creates a new instance of Menu */
    public TwoDimensionMenu() {
        super();
    }
    
    
    public TwoDimensionMenu(Document doc) {
        super();
        try {
            buildMenu(doc);
            this.toArrayList();
            
            myName =  menuRenderer.getObjectKey();
        } catch(Exception e) {
            // throw business object creation exception
        }
        
        // printSelf();
    }
    
    public TwoDimensionMenu(Node node) {
        super();
        try {
            buildMenu(node);
            this.toArrayList();
            
            myName =  menuRenderer.getObjectKey();
        } catch(Exception e) {
            // throw business object creation exception
        }
        
        // printSelf();
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
                if(elementName.equals("sub_menu")) {
                    
                    
                    
                    busObjectsArrays.add(new OneDimensionMenu(node));
                    
                } else {
                    if(elementName.equals("menu_rendering")) {
                        menuRenderer = new WebBusinessObject(node);
                    } else if(elementName.equals("menuInfo")) {
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
//        printSelf();
    }
    public void printSelf() {
        
        super.printSelf();
        menuRenderer.printSelf();
        
    }
    
    public WebBusinessObject getMenuInfo() {
        // raise exceptions if null
        return menuInfo;
    }
    
    public WebBusinessObject getRenderer() {
        return  menuRenderer;
    }
    public void turnMenuOff() {
        int menuSize = linearConetnt.size();
        WebBusinessObject wbo = null;
        for(int i=0;i< menuSize;i++) {
            wbo = (WebBusinessObject) linearConetnt.get(i);
            wbo.setAttribute("turnOn", "0");
            
        }
        
    }
    
    public void turnMenuOn() {
        int menuSize = linearConetnt.size();
        WebBusinessObject wbo = null;
        for(int i=0;i< menuSize;i++) {
            wbo = (WebBusinessObject) linearConetnt.get(i);
            wbo.setAttribute("turnOn", "1");
            
        }
        
    }
    
    public void applySecurityPolicy(String policy){ // throws  SecurityPolicyException {
        int menuSize = linearConetnt.size();
        WebBusinessObject wbo = null;
        
        if(policy.length()!= linearConetnt.size()) {
            //  throw new SecurityPolicyException("Security policy not consistent with menu size -- check");
            
            // System.out.println("LLLLLLLLLLLLLLLLLLLLLL  " +  policy.length()  + ":" + linearConetnt.size());
            
        }
        
        for(int i=0;i< menuSize;i++) {
            wbo = (WebBusinessObject) linearConetnt.get(i);
            wbo.setAttribute("turnOn",policy.substring(i,i+1));
            
        }
        
    }
    
    
    public void installMenu(TouristGuide tGuide) {
        String menuOption = null;
        WebBusinessObject wbo = null;
        Integer rank = null;
        int menuSize = linearConetnt.size();
        
        for(int i=0;i< menuSize;i++) {
            wbo = (WebBusinessObject) linearConetnt.get(i);
            rank = new Integer(i);
            wbo.setAttribute("name",tGuide.getMessage(rank.toString()));
            wbo.setObjectKey(tGuide.getMessage(rank.toString()));
            
        }
        
    }
    
    
    private String binaryContains(String entry) {
        int l = secureMenu.length;
        for (int i = 0; i < l; i++) {
            if (entry.equals(secureMenu[i])) {
                return "1";
                
            }
        }
        return "0";
    }
    
    public String getSecureMenu(String[] activeOptions) {
        
        
        //        System.out.println("active options *************************************  ");
        //        for(int j=0;j< activeOptions.length; j++)
        //            System.out.println(activeOptions[j]);
        
        int l = linearConetnt.size();
        StringBuffer retVal = new StringBuffer("");
        
        if(activeOptions==null) {
            for (int i = 0; i < l; i++) {
                
                retVal.append("0");
                
            }
            return retVal.toString();
        }
        secureMenu = activeOptions;
        
        WebBusinessObject wbo = null;
        
        
        
        for (int i = 0; i < l; i++) {
            wbo = (WebBusinessObject) linearConetnt.get(i);
            retVal.append(binaryContains(wbo.getObjectKey()));
            
        }
        return retVal.toString();
        
    }
    
    
    public void insertContext() {
        int menuSize = linearConetnt.size();
        String target = null;
        String alttarget = null;
        
        WebBusinessObject wbo = null;
        String context = (String) menuRenderer.getAttribute("context");
        for(int i=0;i< menuSize;i++) {
            wbo = (WebBusinessObject) linearConetnt.get(i);
            target = (String) wbo.getAttribute("target");
            target = context + target;
            wbo.setAttribute("target",target);
            
            alttarget = (String) wbo.getAttribute("alttarget");
            alttarget = context + alttarget;
            wbo.setAttribute("alttarget",alttarget);
            
        }
        addLogoutContext();
        contextInitialized = true;
    }
    public boolean isContextInitilaized() {
        return contextInitialized;
        
        
    }
    
    public void printSubMenus() {
        int size = this.getContainerAggregateSize();
        String name = null;
        OneDimensionMenu odm = null;
        
        
        for(int i=0;i<size;i++) {
            odm = (OneDimensionMenu) super.busObjectsArrays.get(i);
            name =(String) odm.getMenuInfo().getAttribute("nameAr");
            
            odm.printSelf();
            
        }
        
    }
    
    public void addLogoutContext() {
        int size = this.getContainerAggregateSize();
        String name = null;
        OneDimensionMenu odm = null;
        WebBusinessObject infoNode = null;
        String context = (String) menuRenderer.getAttribute("context");
        String target = null;
        
        
        for(int i=0;i<size;i++) {
            odm = (OneDimensionMenu) super.busObjectsArrays.get(i);
            infoNode = odm.getMenuInfo();
            name = (String) infoNode.getAttribute("nameAr");
            target = (String) infoNode.getAttribute("target");
            if(name.equalsIgnoreCase("Logout")) {
                
                infoNode.setAttribute("target", context + target);
            }
            
            
        }
        
        
    }
    
    public void installMenuHeaders(TouristGuide tGuide) {
        System.out.println("%%%%%%%%%%%%%%%%%%%========================> I'm here");
        int size = this.getContainerAggregateSize();
        String name = null;
        OneDimensionMenu odm = null;
        WebBusinessObject infoNode = null;
        Integer rank = null;
        
        
        for(int i=0;i<size;i++) {
            odm = (OneDimensionMenu) super.busObjectsArrays.get(i);
            infoNode = odm.getMenuInfo();
            rank = new Integer(i);
            infoNode.setAttribute("name",odm.getMenuInfo().getAttribute("nameAr"));
            odm.setContainerName((String) odm.getMenuInfo().getAttribute("nameAr"));
            System.out.println("%%%%%%%%%%%%%%%%%%%========================> " + odm.getMenuInfo().getAttribute("nameAr"));
        }
        
        
    }

    public int getLength() {
        OneDimensionMenu oneDimensionMenu;
        int length = 0;

        for (Object object : busObjectsArrays) {
            oneDimensionMenu = (OneDimensionMenu) object;

            /* enable check if 'display' tag is required */
            // one becuse TwoDimensionsContainer has one length
//            if(this.getMenuInfo().getAttribute("display").equals("1"))
            length++;

            length += oneDimensionMenu.getLength();
        }

        return length;
    }
}
