package com.silkworm.business_objects;

import org.w3c.dom.*;

public class FormElement extends WebBusinessObject {

  public FormElement(Node node) {
    super(node);
    setObjectKey((String)getAttribute("name"));


  }

  public boolean isValid()
  {
   return true;

  }
}