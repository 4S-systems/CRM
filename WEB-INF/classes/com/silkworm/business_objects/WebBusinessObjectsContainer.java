package com.silkworm.business_objects;


import java.util.*;

public class WebBusinessObjectsContainer {
    
    protected ArrayList busObjects = new ArrayList();
    protected String myName = null;
    protected String equalityAttribute = null;
    
    public WebBusinessObjectsContainer() {
    }
    
    public WebBusinessObjectsContainer(Vector v) {
        
        int s = v.size();
        for(int i = 0;i<s;i++) {
            busObjects.add((WebBusinessObject) v.get(i));
        }
    }
    
    public WebBusinessObjectsContainer(ArrayList al) {
        
        busObjects = al;
    }
    
    public void setBusObjects(ArrayList busObjs) {
        busObjects = busObjs;
        
    }
    
    
    
    public void addBusObject(WebBusinessObject wbo) {
        
        busObjects.add(wbo);
    }
    
    public WebBusinessObject getBusinessObjet(String objKey) {
        
        ListIterator li = busObjects.listIterator();
        WebBusinessObject target;
        
        while(li.hasNext()) {
            
            target = (WebBusinessObject) li.next();
            
            if(target.getObjectKey().equals(objKey)) {
                return target;
            }
            
            
        }
        return null;
        
    }
    
    public int getContainerSize(){
        return busObjects.size();
    }
    
    public void printSelf() {
        System.out.println("----------------------------------------------------");
        System.out.println("Type: Linear Container ");
        System.out.println("Size: " + busObjects.size());
        System.out.println("Following is a list of my WebBusinessObjects");
        System.out.println("*********************");
        
        ListIterator li = busObjects.listIterator();
        
        WebBusinessObject wbo = null;
        while(li.hasNext()) {
            wbo = (WebBusinessObject) li.next();
            wbo.printSelf();
        }
        
    }
    public void setContainerName(String name) {
        myName = name;
    }
    
    public String getContainerName() {
        return myName!=null?myName:null;
    }
    
    public ArrayList getContents() {
        return busObjects;
    }
    
    public void setEqualityAttribute(String attName) {
        equalityAttribute = attName;
    }
    
    public ArrayList getContainerSubset(String[] keys)
    {
        ArrayList subsetList = new ArrayList();
        
        for(int i = 0; i<keys.length;i++)
        {
           subsetList.add(getBusinessObjet(keys[i]));
           System.out.println("created web business object = " );
           getBusinessObjet(keys[i]).printSelf();
        }

        return subsetList;
    }    
}

