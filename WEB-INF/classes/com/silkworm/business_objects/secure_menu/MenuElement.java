/*
 * MenuElement.java
 *
 * Created on January 7, 2004, 7:03 AM
 */

package com.silkworm.business_objects.secure_menu;

import org.w3c.dom.*;
import com.silkworm.business_objects.*;

/**
 *
 * @author  walid
 */
public class MenuElement extends WebBusinessObject {
    
    /** Creates a new instance of MenuElement */
    public MenuElement(Node node) {
        super(node);
    }
    public boolean isValid() {
        return true;
        
    }
}
