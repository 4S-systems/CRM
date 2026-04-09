package com.silkworm.business_objects;

import com.silkworm.common.MetaDataMgr;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

public class SqlMgr {
    MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
    Document doc;
    
    private static SqlMgr sqlMgr = new SqlMgr();
    
    public static SqlMgr getInstance() {
        return sqlMgr;
    }

    public SqlMgr() {
        
    }
    
    public void getDocument(){
        try {
            doc = DOMFabricatorBean.getDocument(metaDataMgr.getMetadata(metaDataMgr.getSqlServer() + ".xml"));
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
     public String getSql(String tag){
         if(doc != null){
             NodeList list = doc.getElementsByTagName(tag).item(0).getChildNodes();
             return list.item(0).getNodeValue();
         } else {
             return null;
         }
     }
}
