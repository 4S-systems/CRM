package com.silkworm.business_objects;

import org.w3c.dom.*;
import java.util.*;

public class BusinessForm extends WebBusinessObjectsContainer
{
  private WebBusinessObject tableSupported = null;

  public BusinessForm()
  {
    super();
  }

  public BusinessForm(Document doc)
  {
    super();
    try
    {
      buildForm(doc);
    }
    catch(Exception e)
    {
     // throw business object creation exception
    }
    // printSelf();
  }

  public void buildForm(Node node) throws Exception{

        if(node == null) {
           return;
        }
        int type = node.getNodeType();

        switch (type) {
           // handle document nodes
           case Node.DOCUMENT_NODE: {
            // System.out.println("<tr>");

             buildForm(((Document)node).getDocumentElement());


             break;
          }
          // handle element nodes
          case Node.ELEMENT_NODE: {
            String elementName = node.getNodeName();
             if(elementName.equals("form_element")) {
              busObjects.add(new FormElement(node));
             }
             else
             {
                if(elementName.equals("table_supported"))
                {
                 tableSupported = new WebBusinessObject(node);
                }
             }


             NodeList childNodes =
             node.getChildNodes();
             if(childNodes != null) {
                int length = childNodes.getLength();
                for (int loopIndex = 0; loopIndex <
                length ; loopIndex++)
                {
                   buildForm(childNodes.item(loopIndex));

                 }
              }

              break;
           }
           // handle text nodes
           case Node.TEXT_NODE: {

              Node o = node.getParentNode();

              String data =
              node.getNodeValue().trim();

              if((data.indexOf("\n")  <0
              ) && (data.length()
              > 0)) {

              }
            }
         }
    }

   public ArrayList getFormElemnts()
   {
    return busObjects;
   }
   public WebBusinessObject getTableSupported()
   {
       // raise exceptions if null
    return tableSupported;
   }

   public void printSelf()
   {

    super.printSelf();
    tableSupported.printSelf();

   }
}