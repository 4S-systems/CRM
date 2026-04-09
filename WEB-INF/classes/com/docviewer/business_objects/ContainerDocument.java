/*
 * ContainerDocument.java
 *
 * Created on April 6, 2005, 5:19 AM
 */

package com.docviewer.business_objects;
import java.util.*;
import com.silkworm.business_objects.*;
/**
 *
 * @author Walid
 */
public class ContainerDocument extends Document {
    
    /** Creates a new instance of ContainerDocument */
    
    private WebBusinessObjectsContainer childDocs =  new WebBusinessObjectsContainer();
    private WebBusinessObjectsContainer childContainers = new WebBusinessObjectsContainer();
    
    public ContainerDocument(Hashtable ht) {
        super(ht);
    }
    
    public ContainerDocument(Document doc) {
        super(doc);
    }
    
    public void addChildToContainers(WebBusinessObject wbo) {
        
        childContainers.addBusObject(wbo);
    }
    
    public void addChildToDocs(WebBusinessObject wbo) {
        
        childDocs.addBusObject(wbo);
        
    }
    
    public WebBusinessObjectsContainer getChildContainers() {
        
        return childContainers;
    }
    
    public WebBusinessObjectsContainer getChildDocs() {
        
        return childDocs;
    }
    
    public void setChildDocs(Vector v) {
        childDocs =  new  WebBusinessObjectsContainer(v);
        
    }
    
    public void setChildContainers(Vector v) {
        childContainers =  new  WebBusinessObjectsContainer(v);
        
    }
    
    
    public boolean docDoesExist(WebBusinessObject lookingFor) {
        
        String targetID = null;
        String lookingForID = (String) lookingFor.getAttribute("docID");
        
        ListIterator li = childContainers.getContents().listIterator();
        WebBusinessObject target;
        
        while(li.hasNext()) {
            
            
            target = (WebBusinessObject) li.next();
            targetID = (String) target.getAttribute("docID");
            
            if(targetID.equals(lookingForID)) {
                return true;
            }
            
            
        }
        return false;
        
    }
    public void printSelf() {
        System.out.println("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");
        super.printSelf();
        childContainers.printSelf();
        childDocs.printSelf();
    }
    
    public String getDocumentType()
    {
        return (String) getAttribute("docType");
    } 
}
