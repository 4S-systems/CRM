package com.silkworm.common;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.DocumentBuilder;

import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;
import org.w3c.dom.*;

public class FilterQuery   {
  

  public FilterQuery() { }

  public HashMap getFilterList (){
       MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        List filterList = new ArrayList();
        List valueList = new ArrayList();
        HashMap tagValueList = new HashMap();
        int y=0;
            try {

            DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder docBuilder = docBuilderFactory.newDocumentBuilder();
            String path = metaDataMgr.getWebInfPath();
            Document doc = docBuilder.parse (new File(path+"/filterQuery.xml"));

            // normalize text representation
            doc.getDocumentElement ().normalize ();

            NodeList jobOreder = doc.getElementsByTagName("jobOreder");
          
            for(int s=0; s<jobOreder.getLength() ; s++){


                Node firstNode = jobOreder.item(s);
                if(firstNode.getNodeType() == Node.ELEMENT_NODE){
                   NodeList childList = firstNode.getChildNodes();
                    for(int i = 0; i < childList.getLength(); i++){
                        valueList = new ArrayList();
                        Node child = childList.item(i);
                        if(child.getNodeName() != null && !child.getNodeName().equals("") && !child.getNodeName().equals("#text"))
                        {
                           NodeList mainTag = doc.getElementsByTagName(child.getNodeName().toString());
                                Node tagNode = mainTag.item(0);
                                    if(tagNode.getNodeType() == Node.ELEMENT_NODE) {
                                        Element firstElement = (Element)tagNode;

                                        NodeList queryList = firstElement.getElementsByTagName("query");
                                        Element  queryElement = (Element)queryList.item(0);
                                        NodeList queryTxt = queryElement.getChildNodes();

                                        NodeList stArList = firstElement.getElementsByTagName("stAr");
                                        Element  stArElement = (Element)stArList.item(0);
                                        NodeList stArTxt = stArElement.getChildNodes();

                                        NodeList stEnList = firstElement.getElementsByTagName("stEn");
                                        Element  stEnElement = (Element)stEnList.item(0);
                                        NodeList stEnTxt = stEnElement.getChildNodes();

                                        valueList.add(((Node)queryTxt.item(0)).getNodeValue().trim());
                                        valueList.add(((Node)stArTxt.item(0)).getNodeValue().trim());
                                        valueList.add(((Node)stEnTxt.item(0)).getNodeValue().trim());
                                        valueList.add(child.getNodeName().toString());
                                        tagValueList.put(y, valueList);
                                    }
                                y=y+1;
            
                    }
                        
                }
                
            }
            }

        }catch (SAXParseException err) {
        System.out.println ("** Parsing error" + ", line "
             + err.getLineNumber () + ", uri " + err.getSystemId ());
        System.out.println(" " + err.getMessage ());

        }catch (SAXException e) {
        Exception x = e.getException ();
        ((x == null) ? e : x).printStackTrace ();

        }catch (Throwable t) {
        t.printStackTrace ();
        }

        return tagValueList;

    }


       public String getJobOrderQuery (String tagName){
       MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String getQuery = null;

            try {

            DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder docBuilder = docBuilderFactory.newDocumentBuilder();
            String path = metaDataMgr.getWebInfPath();
            Document doc = docBuilder.parse (new File(path+"/filterQuery.xml"));

            // normalize text representation
            doc.getDocumentElement ().normalize ();
       
            NodeList jobOreder = doc.getElementsByTagName("jobOreder");
          
            for(int s=0; s<jobOreder.getLength() ; s++){


                Node firstNode = jobOreder.item(s);
                if(firstNode.getNodeType() == Node.ELEMENT_NODE){


                    NodeList childList = firstNode.getChildNodes();
                    for(int i = 0; i < childList.getLength(); i++){
                        Node child = childList.item(i);
                        if(child.getNodeName().equals(tagName)){
                            NodeList mainTag = doc.getElementsByTagName(child.getNodeName().toString());

                                Node tagNode = mainTag.item(0);
                                    if(tagNode.getNodeType() == Node.ELEMENT_NODE){
                                        Element firstElement = (Element)tagNode;

                                        NodeList queryList = firstElement.getElementsByTagName("query");
                                        Element  queryElement = (Element)queryList.item(0);
                                        NodeList queryTxt = queryElement.getChildNodes();
                                        getQuery=((Node)queryTxt.item(0)).getNodeValue().trim();

                                    }
                        }
                        System.out.println("node name -->> " + child.getNodeName());
                    }

                }

            }


        }catch (SAXParseException err) {
        System.out.println ("** Parsing error" + ", line "
             + err.getLineNumber () + ", uri " + err.getSystemId ());
        System.out.println(" " + err.getMessage ());

        }catch (SAXException e) {
        Exception x = e.getException ();
        ((x == null) ? e : x).printStackTrace ();

        }catch (Throwable t) {
        t.printStackTrace ();
        }
        
        return getQuery;

    }

      


}
