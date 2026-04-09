package com.silkworm.business_objects;

import java.io.Serializable;
import java.util.*;

public class MaintainableUnit extends HierarichicalBusObj implements Serializable{
    
    public MaintainableUnit() {
    }
    
    public MaintainableUnit(Hashtable ht) {
        super(ht);
    }
    public String toString() {
         return (String) this.getAttribute("unitName");
    }
    
    public Hashtable getAttributes(){
        return attributes;
    }
    
    public boolean equals(Object o) {
        MaintainableUnit cTo = (MaintainableUnit) o;
        if(cTo.getAttribute("unitName").equals(this.getAttribute("unitName"))) {
            return true;
        }
        return false;
    }
}
