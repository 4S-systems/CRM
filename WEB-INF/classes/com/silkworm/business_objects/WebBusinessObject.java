package com.silkworm.business_objects;

import java.util.*;
import org.w3c.dom.*;
import java.io.Serializable;

public class WebBusinessObject implements Serializable {

    protected Hashtable attributes = new Hashtable();
    protected String objectKey;
    protected WebBusinessObject viewOrigin = null;
    protected boolean isInitialized = false;
    protected boolean isNew = true;
    protected boolean isSurrogated = false;
    protected String uniqueIdentifier;
    protected WebBusinessObject webUser = null;
    protected String webUserGroup = null;
    protected String webUserTrade = null;

    public WebBusinessObject() {
    }

    public void setWebUser(WebBusinessObject user) {
        webUser = user;
        webUserGroup = (String) webUser.getAttribute("groupName");
        webUserTrade = (String) webUser.getAttribute("tradeName");
    }

    public WebBusinessObject(Hashtable ht) {
        attributes = ht;
        objectKey = "general";
    }

    public WebBusinessObject(WebBusinessObject deriveFrom) {
        attributes = deriveFrom.getContents();

    }

    public WebBusinessObject(Node node) {

        if (node == null) {
            // throw a business object creation exception
        }

        // parse the document
        try {
            traverseTree(node);
        } catch (Exception ex) {
        }

    }

    public void setAttribute(Object name, Object value) {
        attributes.put(name, value);
    }

    public Object getAttribute(Object name) {

        return attributes.get(name);
    }
    public int countAttribute() {

        return attributes.size();
    }

    public String getPropertyStatusMsg() {
        StringBuffer msg = new StringBuffer();
        if (!isInitialized()) {
            msg.append("Please enter values in all fields");
        } else if (!isValid()) {
            msg.append("Some Fields are missing or invalid ");
        } else {
            msg.append("Valid Input. Thank you");
        }

        return msg.toString();
    }

    /**
     *
     */
    protected boolean isValid() {
        return false;
    }

    public boolean isNew() {
        return isNew;
    }

    protected boolean isInitialized() {
        return isInitialized;
    }

    public boolean isSurrogated() {
        return isSurrogated;
    }

    public void setUniqueIdentifier(String ID) {

        uniqueIdentifier = ID;
    }

    public String getUniqueIdentifier() {
        return uniqueIdentifier;
    }

    public void setObjectKey(String key) {
        objectKey = key;
    }

    public String getObjectKey() {
        return objectKey;
    }

    public Hashtable getContents() {
        Hashtable attributesCopy = (Hashtable) attributes.clone();
        return attributesCopy;

    }

    private void traverseTree(Node node) throws Exception {

        String elementName = null;

        if (node == null) {
            return;
        }
        int type = node.getNodeType();

        switch (type) {
            // handle document nodes
            case Node.DOCUMENT_NODE: {
                // System.out.println("<tr>");
                traverseTree(((Document) node).getDocumentElement());


                break;
            }
            // handle element nodes
            case Node.ELEMENT_NODE: {

                NodeList childNodes =
                        node.getChildNodes();
                if (childNodes != null) {
                    int length = childNodes.getLength();
                    for (int loopIndex = 0; loopIndex
                            < length; loopIndex++) {
                        traverseTree(childNodes.item(loopIndex));
                    }
                }
                break;
            }
            // handle text nodes
            case Node.TEXT_NODE: {

                Node o = node.getParentNode();

                String data =
                        node.getNodeValue().trim();

                if ((data.indexOf("\n") < 0) && (data.length()
                        > 0)) {
                    elementName = o.getNodeName();

                    if (elementName.equals("name")) {
                        this.setObjectKey(data);
                    }

                    attributes.put(o.getNodeName(), data);

                    //System.out.println(o.getNodeName() + "::" + data);

                }
            }
        }
    }

    public void setViewOrigin(WebBusinessObject viewOrigin) {
        this.viewOrigin = viewOrigin;

    }

    public WebBusinessObject getViewOrigin() {
        return viewOrigin;
    }

    // debug methods
    public void printSelf() {
//        Enumeration e = attributes.elements();
//        Enumeration e1 = attributes.keys();
//        
//        String data;
//        String name;
//        
//        System.out.println("my name (object key) is " + getObjectKey());
//        System.out.println("------------------------------------------");
//        while(e.hasMoreElements()) {
//            data = (String) e.nextElement();
//            name = (String) e1.nextElement();
//            System.out.println(name + " :: " + data);
//        }
    }

    public String getObjectAsXML() {
        StringBuffer xml = new StringBuffer("<WebBusinessObject>\n");
        Set s = attributes.keySet();
        Object[] arrS = s.toArray();
        for (int i = 0; i < arrS.length; i++) {
            xml.append("\t<" + arrS[i].toString() + ">" + attributes.get(arrS[i]) + "</" + arrS[i].toString() + ">\n");
        }
        xml.append("</WebBusinessObject>");
        return xml.toString();
    }

    public String getObjectAsJSON() {
        StringBuffer json = new StringBuffer("\r\n{\"WebBusinessObject\":{");
        Set s = attributes.keySet();
        Object[] arrS = s.toArray();
        for (int i = 0; i < arrS.length; i++) {
            json.append("\r\n\"" + arrS[i].toString() + "\": \"" + attributes.get(arrS[i]) + "\",");
        }
        json.append("\r\n}}");
        return json.toString();
    }

    public String getObjectAsJSON2() {
        StringBuffer json = new StringBuffer("{");
        Set s = attributes.keySet();
        Object[] arrS = s.toArray();
        for (int i = 0; i < arrS.length; i++) {
            json.append("\"").append(arrS[i].toString()).append("\": \"").append(attributes.get(arrS[i])).append("\"");
            if (i < arrS.length - 1) {
                json.append(",");
            }
        }
        json.append("}");
        return json.toString();
    }

    /**
     * Tests if some key maps into the specified value in this WebBusinessObject. 
     * This operation is more expensive than the containsKey method.
     * Note that this method is identical in functionality to containsValue, (which is part of the Map interface in the collections framework).
     * @param name value to search for 
     * @return true if and only if some key maps to the value argument in this WebBusinessObject as determined by the equals method; false otherwise.
     */
    public boolean isContainsAttribute(Object name) {
        return attributes.contains(name);
    }
}
