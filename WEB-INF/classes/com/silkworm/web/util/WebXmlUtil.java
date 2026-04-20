package com.silkworm.web.util;

import com.crm.common.CRMConstants;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.UniqueIDGen;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.w3c.dom.DOMException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class WebXmlUtil {

    public static boolean createXmlForClient(String path, WebBusinessObject clientWbo, String[] projectIDs, HashMap<String, String> periods, HashMap<String, String> paymentTypes, HashMap<String, String> areas, String campaignID, String userID) {
        try {
            DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

            //root elements
            Document doc = docBuilder.newDocument();

            Element rootElement = doc.createElement("client");
            doc.appendChild(rootElement);

            Element node = doc.createElement("clientID");
            node.appendChild(doc.createTextNode((String) clientWbo.getAttribute("clientID")));
            rootElement.appendChild(node);

            node = doc.createElement("clientName");
            node.appendChild(doc.createTextNode((String) clientWbo.getAttribute("clientName")));
            rootElement.appendChild(node);

            node = doc.createElement("mobile");
            node.appendChild(doc.createTextNode((String) clientWbo.getAttribute("clientMobile")));
            rootElement.appendChild(node);

            node = doc.createElement("phone");
            node.appendChild(doc.createTextNode((String) clientWbo.getAttribute("clientPhone")));
            rootElement.appendChild(node);

            node = doc.createElement("email");
            node.appendChild(doc.createTextNode((String) clientWbo.getAttribute("email")));
            rootElement.appendChild(node);

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            node = doc.createElement("creationTime");
            node.appendChild(doc.createTextNode(sdf.format(new Date())));
            rootElement.appendChild(node);
            
            node = doc.createElement("description");
            node.appendChild(doc.createTextNode(clientWbo.getAttribute("description") != null ? (String) clientWbo.getAttribute("description") : ""));
            rootElement.appendChild(node);

            if (projectIDs != null) {
                Element projects = doc.createElement("projects");
                rootElement.appendChild(projects);

                for (String projectID : projectIDs) {
                    Element projectNode = doc.createElement("project");
                    projects.appendChild(projectNode);

                    Element subNode = doc.createElement("projectID");
                    subNode.appendChild(doc.createTextNode(projectID));
                    projectNode.appendChild(subNode);

                    subNode = doc.createElement("period");
                    subNode.appendChild(doc.createTextNode(periods.get(projectID)));
                    projectNode.appendChild(subNode);

                    subNode = doc.createElement("paymentType");
                    subNode.appendChild(doc.createTextNode(paymentTypes.get(projectID)));
                    projectNode.appendChild(subNode);

                    subNode = doc.createElement("area");
                    subNode.appendChild(doc.createTextNode(areas.get(projectID)));
                    projectNode.appendChild(subNode);
                }
            }

            if (campaignID != null) {
                node = doc.createElement("campaignID");
                node.appendChild(doc.createTextNode(campaignID));
                rootElement.appendChild(node);
            }

            TransformerFactory transformerFactory = TransformerFactory.newInstance();
            Transformer transformer = transformerFactory.newTransformer();
            DOMSource source = new DOMSource(doc);

            File theDir = new File(path);
            if (!theDir.exists()) {
                theDir.mkdir();
            }
            theDir = new File(path + "/web/");
            if (!theDir.exists()) {
                theDir.mkdir();
            }
            theDir = new File(path + "/web/u" + userID + "/");
            if (!theDir.exists()) {
                theDir.mkdir();
            }

            StreamResult result = new StreamResult(new File(path + "/web/u" + userID + "/" + (String) clientWbo.getAttribute("clientID") + ".xml"));
            transformer.transform(source, result);
        } catch (ParserConfigurationException pce) {
            System.out.println(pce.getMessage());
            return false;
        } catch (TransformerException tfe) {
            System.out.println(tfe.getMessage());
            return false;
        }
        return true;
    }

    public static ArrayList<WebBusinessObject> readClientsList(String path) {
        ArrayList<WebBusinessObject> clientsList = new ArrayList<WebBusinessObject>();
        try {
            ArrayList<String> clientIDsList = getClientList(path);
            for (String clientID : clientIDsList) {
                File clientXmlFile = new File(path + clientID + ".xml");
                if (clientXmlFile.exists()) {
                    WebBusinessObject clientWbo = new WebBusinessObject();
                    DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
                    DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
                    Document doc = dBuilder.parse(clientXmlFile);

                    doc.getDocumentElement().normalize();
                    clientWbo.setAttribute("clientID", doc.getElementsByTagName("clientID").item(0).getTextContent().trim());
                    clientWbo.setAttribute("clientName", doc.getElementsByTagName("clientName").item(0).getTextContent().trim());
                    clientWbo.setAttribute("mobile", doc.getElementsByTagName("mobile").item(0).getTextContent().trim());
                    clientWbo.setAttribute("phone", doc.getElementsByTagName("phone").item(0).getTextContent().trim());
                    clientWbo.setAttribute("email", doc.getElementsByTagName("email").item(0).getTextContent().trim());
                    clientWbo.setAttribute("creationTime", doc.getElementsByTagName("creationTime").item(0).getTextContent().trim());
                    clientWbo.setAttribute("description", doc.getElementsByTagName("description").item(0).getTextContent().trim());
                    if (doc.getElementsByTagName("campaignID") != null && doc.getElementsByTagName("campaignID").getLength() > 0) {
                        clientWbo.setAttribute("campaignID", doc.getElementsByTagName("campaignID").item(0).getTextContent().trim());
                    }
                    if (doc.getElementsByTagName("sourceID") != null && doc.getElementsByTagName("sourceID").getLength() > 0) {
                        clientWbo.setAttribute("sourceID", doc.getElementsByTagName("sourceID").item(0).getTextContent().trim());
                    }
                    if (doc.getElementsByTagName("season") != null && doc.getElementsByTagName("season").getLength() > 0) {
                        clientWbo.setAttribute("season", doc.getElementsByTagName("season").item(0).getTextContent().trim());
                    }
                    clientsList.add(clientWbo);
                }
            }
        } catch (ParserConfigurationException ex) {
            Logger.getLogger(WebXmlUtil.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SAXException ex) {
            Logger.getLogger(WebXmlUtil.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            Logger.getLogger(WebXmlUtil.class.getName()).log(Level.SEVERE, null, ex);
        }
        return clientsList;
    }

    private static ArrayList<String> getClientList(String path) {
        File webDir = new File(path);
        String[] webDirContents = webDir.list();
        ArrayList<String> clientIDsList = new ArrayList<String>();
        if (webDirContents != null) {
            for (String fileName : webDirContents) {
                String[] s = fileName.split("\\.");
                if (s.length > 0) {
                    clientIDsList.add(s[0]);
                }
            }
        }
        return clientIDsList;
    }

    public static boolean deleteClientFile(String path, String clientID) {
        File clientFile = new File(path + clientID + ".xml");
        if (clientFile.exists()) {
            clientFile.delete();
            return true;
        }
        return false;
    }

    public static ArrayList<WebBusinessObject> getProjectsForClient(String path, String clientID) {
        ArrayList<WebBusinessObject> projectsList = new ArrayList<WebBusinessObject>();
        try {
            File clientXmlFile = new File(path + clientID + ".xml");
            if (clientXmlFile.exists()) {
                WebBusinessObject projectWbo;
                DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
                DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
                Document doc = dBuilder.parse(clientXmlFile);

                doc.getDocumentElement().normalize();
                NodeList projectNodes = doc.getElementsByTagName("project");
                if (projectNodes != null) {
                    for (int i = 0; i < projectNodes.getLength(); i++) {
                        Node projectNode = projectNodes.item(i);
                        NodeList childList = projectNode.getChildNodes();
                        if (childList != null) {
                            projectWbo = new WebBusinessObject();
                            for (int j = 0; j < childList.getLength(); j++) {
                                Node childNode = childList.item(j);
                                projectWbo.setAttribute(childNode.getNodeName(), childNode.getTextContent());
                            }
                            projectsList.add(projectWbo);
                        }

                    }
                }
            }
        } catch (ParserConfigurationException ex) {
            Logger.getLogger(WebXmlUtil.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SAXException ex) {
            Logger.getLogger(WebXmlUtil.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            Logger.getLogger(WebXmlUtil.class.getName()).log(Level.SEVERE, null, ex);
        }
        return projectsList;
    }

    public static boolean createXmlForClientFromExcel(File fileExcel, String path, String campaignID, String sourceID, String season, String projectID, String userID) {
        try {

            FileInputStream file = new FileInputStream(fileExcel);
            XSSFWorkbook workbook = new XSSFWorkbook(file);
            DataFormatter formatter = new DataFormatter();
            //Get first sheet from the workbook
            XSSFSheet sheet = workbook.getSheetAt(0);
            Iterator<Row> rowIterator = sheet.iterator();
            if (rowIterator.hasNext()) {
                rowIterator.next(); //First row contains titles
            }
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String creationTime = sdf.format(new Date());
            while (rowIterator.hasNext()) {
                DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
                DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

                //root elements
                Document doc = docBuilder.newDocument();
                Element rootElement = doc.createElement("client");
                doc.appendChild(rootElement);

                String clientID = UniqueIDGen.getNextID();
                Element node = doc.createElement("clientID");
                node.appendChild(doc.createTextNode(clientID));
                rootElement.appendChild(node);

                Row row = rowIterator.next();
                Cell cell = row.getCell(1);

                node = doc.createElement("clientName");
                node.appendChild(doc.createTextNode(cell != null ? cell.getStringCellValue().replaceAll("\'", "").replaceAll("\"", "") : ""));
                rootElement.appendChild(node);

                cell = row.getCell(3);
                node = doc.createElement("phone");
                try {
                    node.appendChild(doc.createTextNode(cell != null ? cell.getStringCellValue().trim() : ""));
                } catch (java.lang.IllegalStateException ex) {
                    node.appendChild(doc.createTextNode(cell != null ? cell.getNumericCellValue() + "" : ""));
                }
                rootElement.appendChild(node);

                cell = row.getCell(2);
                node = doc.createElement("mobile");
                String mobile = cell != null ? convertArabicNoToEnglish(formatter.formatCellValue(cell).trim()) : "";
                node.appendChild(doc.createTextNode(mobile));
                rootElement.appendChild(node);

                cell = row.getCell(4);
                node = doc.createElement("email");
                node.appendChild(doc.createTextNode(cell != null ? cell.getStringCellValue() : ""));
                rootElement.appendChild(node);

                node = doc.createElement("creationTime");
                node.appendChild(doc.createTextNode(creationTime));
                rootElement.appendChild(node);
                
                cell = row.getCell(5);
                node = doc.createElement("description");
                node.appendChild(doc.createTextNode(cell != null ? cell.getStringCellValue() : ""));
                rootElement.appendChild(node);
                
                if (projectID != null && !projectID.isEmpty()) {
                    Element projects = doc.createElement("projects");
                    rootElement.appendChild(projects);

                    Element projectNode = doc.createElement("project");
                    projects.appendChild(projectNode);

                    Element subNode = doc.createElement("projectID");
                    subNode.appendChild(doc.createTextNode(projectID));
                    projectNode.appendChild(subNode);

                    subNode = doc.createElement("period");
                    subNode.appendChild(doc.createTextNode(CRMConstants.PERIOD_DEFAULT_VALUE));
                    projectNode.appendChild(subNode);

                    subNode = doc.createElement("paymentType");
                    subNode.appendChild(doc.createTextNode(CRMConstants.PAYMENT_TYPE_DEFAULT_VALUE));
                    projectNode.appendChild(subNode);

                    subNode = doc.createElement("area");
                    subNode.appendChild(doc.createTextNode("100"));
                    projectNode.appendChild(subNode);
                }

                if (campaignID != null) {
                    node = doc.createElement("campaignID");
                    node.appendChild(doc.createTextNode(campaignID));
                    rootElement.appendChild(node);
                }
                
                if (sourceID != null) {
                    node = doc.createElement("sourceID");
                    node.appendChild(doc.createTextNode(sourceID));
                    rootElement.appendChild(node);
                }
                
                if (season != null) {
                    node = doc.createElement("season");
                    node.appendChild(doc.createTextNode(season));
                    rootElement.appendChild(node);
                }

                TransformerFactory transformerFactory = TransformerFactory.newInstance();
                Transformer transformer = transformerFactory.newTransformer();
                DOMSource source = new DOMSource(doc);

                File theDir = new File(path);
                if (!theDir.exists()) {
                    theDir.mkdir();
                }
                theDir = new File(path + "/web/u" + userID + "/");
                if (!theDir.exists()) {
                    theDir.mkdir();
                }

                StreamResult result = new StreamResult(new File(path + "/web/u" + userID + "/" + clientID + ".xml"));
                transformer.transform(source, result);
            }
        } catch (ParserConfigurationException pce) {
            Logger.getLogger(WebXmlUtil.class.getName()).log(Level.SEVERE, null, pce);
            return false;
        } catch (TransformerException tfe) {
            Logger.getLogger(WebXmlUtil.class.getName()).log(Level.SEVERE, null, tfe);
            return false;
        } catch (FileNotFoundException ex) {
            Logger.getLogger(WebXmlUtil.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            Logger.getLogger(WebXmlUtil.class.getName()).log(Level.SEVERE, null, ex);
        }
        return true;
    }
    
    public static boolean createXmlForClientFromCSV(File fileCSV, String path, String campaignID, String sourceID, String season, String projectID, String userID) {
        BufferedReader br = null;
        String line;
        String cvsSplitBy = ",";
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String creationTime = sdf.format(new Date());
            br = new BufferedReader(new FileReader(fileCSV));
            if (br.readLine() != null) {
                while ((line = br.readLine()) != null) {
                    String[] client = line.split(cvsSplitBy);
//                if (client.length == 6) {
                    DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
                    DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

                    //root elements
                    Document doc = docBuilder.newDocument();
                    Element rootElement = doc.createElement("client");
                    doc.appendChild(rootElement);

                    String clientID = UniqueIDGen.getNextID();
                    Element node = doc.createElement("clientID");
                    node.appendChild(doc.createTextNode(clientID));
                    rootElement.appendChild(node);

                    node = doc.createElement("clientName");
                    node.appendChild(doc.createTextNode(client[1].replaceAll("\'", "").replaceAll("\"", "")));
                    rootElement.appendChild(node);

                    node = doc.createElement("phone");
                    node.appendChild(doc.createTextNode(client[2].trim()));
                    rootElement.appendChild(node);

                    node = doc.createElement("mobile");
                    node.appendChild(doc.createTextNode(convertArabicNoToEnglish(client[3].trim())));
                    rootElement.appendChild(node);

                    node = doc.createElement("email");
                    node.appendChild(doc.createTextNode(client[4]));
                    rootElement.appendChild(node);

                    node = doc.createElement("creationTime");
                    node.appendChild(doc.createTextNode(creationTime));
                    rootElement.appendChild(node);

                    node = doc.createElement("description");
                    node.appendChild(doc.createTextNode(client[5].replaceAll("\"", "")));
                    rootElement.appendChild(node);
                    
                    if (projectID != null) {
                        Element projects = doc.createElement("projects");
                        rootElement.appendChild(projects);

                        Element projectNode = doc.createElement("project");
                        projects.appendChild(projectNode);

                        Element subNode = doc.createElement("projectID");
                        subNode.appendChild(doc.createTextNode(projectID));
                        projectNode.appendChild(subNode);

                        subNode = doc.createElement("period");
                        subNode.appendChild(doc.createTextNode(CRMConstants.PERIOD_DEFAULT_VALUE));
                        projectNode.appendChild(subNode);

                        subNode = doc.createElement("paymentType");
                        subNode.appendChild(doc.createTextNode(CRMConstants.PAYMENT_TYPE_DEFAULT_VALUE));
                        projectNode.appendChild(subNode);

                        subNode = doc.createElement("area");
                        subNode.appendChild(doc.createTextNode("100"));
                        projectNode.appendChild(subNode);
                    }

                    if (campaignID != null) {
                        node = doc.createElement("campaignID");
                        node.appendChild(doc.createTextNode(campaignID));
                        rootElement.appendChild(node);
                    }

                    TransformerFactory transformerFactory = TransformerFactory.newInstance();
                    Transformer transformer = transformerFactory.newTransformer();
                    DOMSource source = new DOMSource(doc);

                    File theDir = new File(path);
                    if (!theDir.exists()) {
                        theDir.mkdir();
                    }
                    theDir = new File(path + "/web/u" + userID + "/");
                    if (!theDir.exists()) {
                        theDir.mkdir();
                    }

                    StreamResult result = new StreamResult(new File(path + "/web/u" + userID + "/" + clientID + ".xml"));
                    transformer.transform(source, result);
                }
            }
        } catch (IOException | ParserConfigurationException | TransformerException e) {
            Logger.getLogger(WebXmlUtil.class.getName()).log(Level.SEVERE, null, e);
            return false;
        } finally {
            if (br != null) {
                try {
                    br.close();
                } catch (IOException e) {
                    Logger.getLogger(WebXmlUtil.class.getName()).log(Level.SEVERE, null, e);
                    return false;
                }
            }
        }
        return true;
    }
    
    public static String convertArabicNoToEnglish(String s) {
        String temp = "";
        for (int i = 0; i < s.length(); i++) {
            int c = s.codePointAt(i);
            if (c >= 0x0660 && c <= 0x0669) {
                c -= 0x630;
            }
            temp += Character.toString((char) c);
        }
        return temp;
    }
    
    public static Hashtable<String, String> convertXmlToMap(String xmlString) {
        Hashtable<String, String> result = new Hashtable<>();
        try {
            DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder documentBuilder = documentBuilderFactory.newDocumentBuilder();
            Document doc = documentBuilder.parse(new ByteArrayInputStream(xmlString.getBytes()));
            doc.getDocumentElement().normalize();
            NodeList nodeList = doc.getElementsByTagName("WebBusinessObject");
            for (int itr = 0; itr < nodeList.item(0).getChildNodes().getLength(); itr++) {
                Node node = nodeList.item(0).getChildNodes().item(itr);
                if (node.getNodeType() == Node.ELEMENT_NODE) {
                    Element eElement = (Element) node;
                    result.put(eElement.getTagName(), eElement.getTextContent());
                }
            }
        } catch (IOException | ParserConfigurationException | DOMException | SAXException e) {
            System.out.println("errrrrrrrrrrrrror parsing");
        }
        return result;
    }
}
