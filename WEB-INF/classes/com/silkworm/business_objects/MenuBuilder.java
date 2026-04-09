package com.silkworm.business_objects;

import java.util.ArrayList;

/**
 * Created by IntelliJ IDEA.
 * User: Ismael
 * Date: Jan 25, 2003
 * Time: 12:21:55 PM
 * To change this template use Options | File Templates.
 */
public class MenuBuilder {
   private HyperMenu menu = null;
   private String fileURL = null;

  public  MenuBuilder()
    {

    }
    public HyperMenu getMenu()
     {

      if(menu == null && fileURL!=null)
      {
       try
       {
            System.out.println("Fatawakal 3ala Allah");
          menu  = new HyperMenu(DOMFabricatorBean.getDocument(fileURL));
          return menu;
       }
       catch(Exception e)
       {
        System.out.println("Could not locate XML Document");
        return null;

       }
      }
      return null;
    }
   public void setMenu(String mFile)
   {


   }

   public void setFileURL(String mFile)
   {
    fileURL = mFile;

   }

   public String getFileURL()
   {
       return fileURL;
   }

}
