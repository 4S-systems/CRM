package com.silkworm.business_objects;

import java.util.*;

public class FrequencyType extends HierarichicalBusObj{
    
    public FrequencyType() {
    }
    
    public FrequencyType(Hashtable ht) {
        super(ht);
    }
    public String toString() {
         return (String) this.getAttribute("frequencyType");
    }
    
    public boolean equals(Object o) {
        FrequencyType cTo = (FrequencyType) o;
        if(cTo.getAttribute("frequencyType").equals(this.getAttribute("frequencyType"))) {
            return true;
        }
        return false;
    }
}
