package com.silkworm.business_objects;

import org.w3c.dom.*;
import java.util.*;

public class HyperMenu extends WebBusinessObjectsContainer{

   private WebBusinessObject menuRenderer = null;

  public HyperMenu() {
    super();

  }


  public HyperMenu(Document doc) {
    super();
    try
    {
      buildMenu(doc);
    }
    catch(Exception e)
    {
     // throw business object creation exception
    }

   // printSelf();
  }


  public void buildMenu(Node node) throws Exception {

        if(node == null) {
           return;
        }
        int type = node.getNodeType();

        switch (type) {
           // handle document nodes
           case Node.DOCUMENT_NODE: {
            // System.out.println("<tr>");

             buildMenu(((Document)node).getDocumentElement());


             break;
          }
          // handle element nodes
          case Node.ELEMENT_NODE: {
            String elementName = node.getNodeName();
             if(elementName.equals("form_element")) {
              busObjects.add(new Item(node));
             }
            else
             {
                if(elementName.equals("menu_rendering"))
                {
                 menuRenderer = new WebBusinessObject(node);
                }
             }

             NodeList childNodes =
             node.getChildNodes();
             if(childNodes != null) {
                int length = childNodes.getLength();
                for (int loopIndex = 0; loopIndex <
                length ; loopIndex++)
                {
                   buildMenu(childNodes.item(loopIndex));

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

   public ArrayList getMenuItems()
   {
    return busObjects;

   }
    public WebBusinessObject getMenuRenderer()
   {
       // raise exceptions if null
    return menuRenderer;
   }

   public void printSelf()
   {

    super.printSelf();
    menuRenderer.printSelf();

   }




}
