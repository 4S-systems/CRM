/*
 * HierarichicalBusObj.java
 *
 * Created on November 29, 2004, 5:30 AM
 */

package com.silkworm.business_objects;

import java.util.*;
import com.silkworm.business_objects.WebBusinessObject;
/**
 *
 * @author  Walid
 */
public class HierarichicalBusObj extends WebBusinessObject{
    
   
    protected HierarichicalBusObj parent = null;
    protected Vector children = new Vector();
    
    protected WebBusinessObject parentAsBusObject = null;
  
    protected String equalityAttribute = null;
    
    public HierarichicalBusObj() {
    }
    
     public HierarichicalBusObj(Hashtable ht) {
         super(ht);
    }
    
    public HierarichicalBusObj(Vector v) {
        
         int s = v.size();
        for(int i = 0;i<s;i++) {
            children.add((WebBusinessObject) v.get(i));
        }
    }
    
   
   
    
    public boolean isLeaf()
    {
        
     return children.size()>0?false:true;  
    } 
    
    public void setParent(HierarichicalBusObj hbo)
    {
     parent = hbo;   
        
    }    
    
     public HierarichicalBusObj getParent(HierarichicalBusObj hbo)
    {
     return parent!=null?parent:null;   
        
    }    
     
     public void setChildren(Vector children)
     {
        this.children =  children; 
         
     }    
}
