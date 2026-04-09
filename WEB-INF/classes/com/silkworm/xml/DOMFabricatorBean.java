package com.silkworm.xml;

import javax.xml.parsers.*;
import org.w3c.dom.*;

import java.io.*;

public class DOMFabricatorBean
implements java.io.Serializable {
    public DOMFabricatorBean() {
    }
    
    public static Document
    getDocument(String file) throws Exception {
        
        // Step 1: create a DocumentBuilderFactory
        DocumentBuilderFactory dbf =
        DocumentBuilderFactory.newInstance();
        
        // Step 2: create a DocumentBuilder
        DocumentBuilder db = dbf.newDocumentBuilder();
        
        // Step 3: parse the input file to get
        //   a Document object
        Document doc = db.parse(new File(file));
        return doc;
    }
    
    
    public static Document getDocument(InputStream is) throws Exception {
        
        // Step 1: create a DocumentBuilderFactory
        DocumentBuilderFactory dbf =
        DocumentBuilderFactory.newInstance();
        
        // Step 2: create a DocumentBuilder
        DocumentBuilder db = dbf.newDocumentBuilder();
        
        // Step 3: parse the input file to get
        //   a Document object
        Document doc = db.parse(is);
        return doc;
    }
    
}

