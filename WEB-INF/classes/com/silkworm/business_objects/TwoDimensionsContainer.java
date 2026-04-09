package com.silkworm.business_objects;

import com.silkworm.business_objects.secure_menu.OneDimensionMenu;
import java.util.*;

public class TwoDimensionsContainer {
    protected ArrayList busObjectsArrays = new ArrayList();
    protected ArrayList linearConetnt = new ArrayList();
    protected String myName = null;
    
    /** Creates a new instance of TwoDimensionsContainer */
    public TwoDimensionsContainer() {
    }
    
    public void addBusObjectContainer(WebBusinessObjectsContainer wboc) {
        busObjectsArrays.add(wboc);
    }
    public WebBusinessObject getBusinessObjet(String objKey) {
        ListIterator li = busObjectsArrays.listIterator();
        WebBusinessObject target;
        
        while(li.hasNext()) {
            
            target = (WebBusinessObject) li.next();
            
            if(target.getObjectKey().equals(objKey)) {
                return target;
            }
        }
        return null;
        
    }
    
    public void printSelf() {
        System.out.println("----------------------------------------------------");
        System.out.println("Type: Two Dimension Container ");
        System.out.println("Container Aggregate Size: " + busObjectsArrays.size());
        System.out.println("Container Elemnts Size: " + this.getContainerElementSize());
        
        
        System.out.println("Following is a list of my Web Business Objects Containers");
        System.out.println("*********************************");
        
        ListIterator li = busObjectsArrays.listIterator();
        
        WebBusinessObjectsContainer wboc = null;
        while(li.hasNext()) {
            wboc = (WebBusinessObjectsContainer) li.next();
            wboc.printSelf();
        }
        
    }
    
    public int getContainerAggregateSize() {
        return busObjectsArrays.size();
    }
    
    public int getContainerElementSize() {
        int total = 0;
        int length =  busObjectsArrays.size();
        
        
        ListIterator li = busObjectsArrays.listIterator();
        
        WebBusinessObjectsContainer wboc = null;
        while(li.hasNext()) {
            wboc = (WebBusinessObjectsContainer) li.next();
            total = total + wboc.getContainerSize();
        }
        return total;
    }
    
    public ArrayList getContents() {
        return busObjectsArrays;
    }
    
    protected void toArrayList() {
        
        ListIterator outer = busObjectsArrays.listIterator();
        ListIterator inner = null;
        ArrayList innerContents = new ArrayList();
                
        WebBusinessObjectsContainer wboc = null;
        while(outer.hasNext()) {
            wboc = (WebBusinessObjectsContainer) outer.next();
            innerContents = wboc.getContents();
            inner = innerContents.listIterator();
            
            while(inner.hasNext()) {
                linearConetnt.add((WebBusinessObject) inner.next());
                
            }
            
            //   linearConetnt
        }
    }
    
    public void printSelfLinear() {
        ListIterator li = linearConetnt.listIterator();
        WebBusinessObject wbo = null;
        System.out.println("Menu linear length is : " + linearConetnt.size());
        while(li.hasNext()) {
            
            System.out.println("------------------------------------------------------");
            wbo = (WebBusinessObject) li.next();
            wbo.printSelf();
            
        }
    }

    public void setContainerName(String name) {
        
        this.myName= name;
    }
    
    public String getContainerName() {
        
        return myName!=null?myName:null;
    }
}
