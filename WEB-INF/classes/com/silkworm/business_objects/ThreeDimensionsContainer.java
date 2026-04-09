/*
 * TwoDimensionsContainer.java
 *
 * Created on January 7, 2004, 7:52 AM
 */

package com.silkworm.business_objects;

import java.util.*;

/**
 *
 * @author  walid
 */
public class ThreeDimensionsContainer {
    
    protected ArrayList menu2DObjectsArrays = new ArrayList();
    protected ArrayList linearConetnt = new ArrayList();
    protected String myName = null;
    
    /** Creates a new instance of TwoDimensionsContainer */
    public ThreeDimensionsContainer() {
    }
    
    public void addBusObjectContainer(WebBusinessObjectsContainer wboc) {
        
        menu2DObjectsArrays.add(wboc);
    }
    public WebBusinessObject getBusinessObjet(String objKey) {
        
        ListIterator li = menu2DObjectsArrays.listIterator();
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
        System.out.println("Type: Three Dimension Container ");
        System.out.println("Container Aggregate Size: " + menu2DObjectsArrays.size());
        System.out.println("Container Elemnts Size: " + this.getContainerElementSize());
        
        
        System.out.println("Following is a list of my Web Business Objects Containers");
        System.out.println("*********************************");
        
        ListIterator li = menu2DObjectsArrays.listIterator();
        
        WebBusinessObjectsContainer wboc = null;
        while(li.hasNext()) {
            wboc = (WebBusinessObjectsContainer) li.next();
            wboc.printSelf();
        }
        
    }
    
    public int getContainerAggregateSize() {
        return menu2DObjectsArrays.size();
    }
    
    public int getContainerElementSize() {
        int total = 0;
        int length =  menu2DObjectsArrays.size();
        
        
        ListIterator li = menu2DObjectsArrays.listIterator();
        
        WebBusinessObjectsContainer wboc = null;
        while(li.hasNext()) {
            wboc = (WebBusinessObjectsContainer) li.next();
            total = total + wboc.getContainerSize();
        }
        return total;
    }
    
    public ArrayList getContents() {
        
        return menu2DObjectsArrays;
    }
    
    protected void toArrayList() {
        
        ListIterator outer = menu2DObjectsArrays.listIterator();
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
