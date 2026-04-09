package com.DatabaseController.db_access;

import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.MetaDataMgr;
import java.io.File;
import java.io.IOException;
import javax.xml.parsers.*;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.apache.log4j.Logger;
import org.apache.log4j.xml.DOMConfigurator;
import org.xml.sax.*;
import org.w3c.dom.*;

public class DatabaseConfigurationMgr {
    public static final String DATABASE_CONFIGURATION = "DatabaseConfiguration";
    public static final String ERP_DATABASE_CONFIGURATION = "ErpDatabaseConfiguration";
    public static final String DRIVER_CLASS = "driverClass";
    public static final String URL = "url";
    public static final String USER = "user";
    public static final String PASSWORD = "password";
    public static final String GL_USER = "glUser";
    public static final String GL_PASSWORD = "glPassword";
    public static final String STR_USER = "strUser";
    public static final String STR_PASSWORD = "strPassword";
    public static final String PAY_USER = "payUser";
    public static final String PAY_PASSWORD = "payPassword";

    public static final String SERVICE_ID = "serviceID";
    public static final String HOSTING = "hosting";
    public static final String PORT = "port";
    
    private MetaDataMgr metaDataMgr;
    private String path;
    private String databaseUpdateXmlPath;

    private static Logger logger;

    private Document document;

    private static DatabaseConfigurationMgr databaseConfigurationMgr = new DatabaseConfigurationMgr();

    public DatabaseConfigurationMgr(){
        this.metaDataMgr = MetaDataMgr.getInstance();
        logger = Logger.getLogger(DatabaseConfigurationMgr.class);

        if (metaDataMgr.getWebInfPath() != null) {
            metaDataMgr.setMetaData("xfile.jar");
            DOMConfigurator.configure(metaDataMgr.getWebInfPath() + "/LogConfig.xml");
        }

        this.path = metaDataMgr.getWebInfPath();
        this.databaseUpdateXmlPath = path + "/database/DataBaseConfiguration.xml";
        this.document = getDocument();
    }

    public static DatabaseConfigurationMgr getInstance() {
        logger.info("get Instance from database configuration mgr");
        return databaseConfigurationMgr;
    }

    public String getBasicDriverClass() {
        return getValue(DatabaseConfigurationMgr.DATABASE_CONFIGURATION, DatabaseConfigurationMgr.DRIVER_CLASS);
    }

    public String getBasicUrl() {
        return getValue(DatabaseConfigurationMgr.DATABASE_CONFIGURATION, DatabaseConfigurationMgr.URL);
    }

    public String getBasicUser() {
        return getValue(DatabaseConfigurationMgr.DATABASE_CONFIGURATION, DatabaseConfigurationMgr.USER);
    }

    public String getBasicPassword() {
        return getValue(DatabaseConfigurationMgr.DATABASE_CONFIGURATION, DatabaseConfigurationMgr.PASSWORD);
    }

    public String getErpDriverClass() {
        return getValue(DatabaseConfigurationMgr.ERP_DATABASE_CONFIGURATION, DatabaseConfigurationMgr.DRIVER_CLASS);
    }

    public String getErpUrl() {
        return getValue(DatabaseConfigurationMgr.ERP_DATABASE_CONFIGURATION, DatabaseConfigurationMgr.URL);
    }

    public String getErpGeneralLedgerUser() {
        return getValue(DatabaseConfigurationMgr.ERP_DATABASE_CONFIGURATION, DatabaseConfigurationMgr.GL_USER);
    }

    public String getErpGeneralLedgerPassword() {
        return getValue(DatabaseConfigurationMgr.ERP_DATABASE_CONFIGURATION, DatabaseConfigurationMgr.GL_PASSWORD);
    }

    public String getErpPayrollUser() {
        return getValue(DatabaseConfigurationMgr.ERP_DATABASE_CONFIGURATION, DatabaseConfigurationMgr.PAY_USER);
    }

    public String getErpPayrollPassword() {
        return getValue(DatabaseConfigurationMgr.ERP_DATABASE_CONFIGURATION, DatabaseConfigurationMgr.PAY_PASSWORD);
    }

    public String getErpStoreUser() {
        return getValue(DatabaseConfigurationMgr.ERP_DATABASE_CONFIGURATION, DatabaseConfigurationMgr.STR_USER);
    }

    public String getErpStorePassword() {
        return getValue(DatabaseConfigurationMgr.ERP_DATABASE_CONFIGURATION, DatabaseConfigurationMgr.STR_PASSWORD);
    }

    public WebBusinessObject getBasicUrlInfo() {
        WebBusinessObject wbo = new WebBusinessObject();

        try {
            String url = getBasicUrl();

            String[] split1 = url.split("@");
            String[] split2 = split1[1].split(":");

            wbo.setAttribute(HOSTING, split2[0]);
            wbo.setAttribute(PORT, split2[1]);
            wbo.setAttribute(SERVICE_ID, split2[2]);
        } catch(Exception ex) {
            logger.error(ex.getMessage());
        }

        return wbo;
    }

    public WebBusinessObject getErpUrlInfo() {
        WebBusinessObject wbo = new WebBusinessObject();

        try {
            String url = getErpUrl();

            String[] split1 = url.split("@");
            String[] split2 = split1[1].split(":");

            wbo.setAttribute(HOSTING, split2[0]);
            wbo.setAttribute(PORT, split2[1]);
            wbo.setAttribute(SERVICE_ID, split2[2]);
        } catch(Exception ex) {
            logger.error(ex.getMessage());
        }

        return wbo;
    }

    private String getValue(String parentTag, String chaildTag) {
        String value = null;

        try {
            NodeList nodeList = this.document.getElementsByTagName(parentTag);
            NodeList chalidList;
            Element parentElement, chalidElement;
            for (int i = 0; i < nodeList.getLength(); i++) {
                parentElement = (Element) nodeList.item(i);

                chalidList = parentElement.getElementsByTagName(chaildTag);
                chalidElement = (Element) chalidList.item(0);
                value = chalidElement.getFirstChild().getNodeValue();
            }
        } catch(Exception ex) {
            logger.error(ex.getMessage());
        }

        return value;
    }

    public void setBasicDriverClass(String basicDriverClass) {
        setValue(DatabaseConfigurationMgr.DATABASE_CONFIGURATION, DatabaseConfigurationMgr.DRIVER_CLASS, basicDriverClass);
    }

    public void setBasicUrl(String basicUrl) {
        setValue(DatabaseConfigurationMgr.DATABASE_CONFIGURATION, DatabaseConfigurationMgr.URL, basicUrl);
    }

    public void setBasicUser(String basicUser) {
        setValue(DatabaseConfigurationMgr.DATABASE_CONFIGURATION, DatabaseConfigurationMgr.USER, basicUser);
    }

    public void setBasicPassword(String basicPassword) {
        setValue(DatabaseConfigurationMgr.DATABASE_CONFIGURATION, DatabaseConfigurationMgr.PASSWORD, basicPassword);
    }

    public void setErpDriverClass(String erpDriverClass) {
        setValue(DatabaseConfigurationMgr.ERP_DATABASE_CONFIGURATION, DatabaseConfigurationMgr.DRIVER_CLASS, erpDriverClass);
    }

    public void setErpUrl(String erpUrl) {
        setValue(DatabaseConfigurationMgr.ERP_DATABASE_CONFIGURATION, DatabaseConfigurationMgr.URL, erpUrl);
    }

    public void setErpGeneralLedgerUser(String generalLedgerUser) {
        setValue(DatabaseConfigurationMgr.ERP_DATABASE_CONFIGURATION, DatabaseConfigurationMgr.GL_USER, generalLedgerUser);
    }

    public void setErpGeneralLedgerPassword(String generalLedgerPassword) {
        setValue(DatabaseConfigurationMgr.ERP_DATABASE_CONFIGURATION, DatabaseConfigurationMgr.GL_PASSWORD, generalLedgerPassword);
    }

    public void setErpPayrollUser(String payrollUser) {
        setValue(DatabaseConfigurationMgr.ERP_DATABASE_CONFIGURATION, DatabaseConfigurationMgr.PAY_USER, payrollUser);
    }

    public void setErpPayrollPassword(String payrollPassword) {
        setValue(DatabaseConfigurationMgr.ERP_DATABASE_CONFIGURATION, DatabaseConfigurationMgr.PAY_PASSWORD, payrollPassword);
    }

    public void setErpStoreUser(String storeUser) {
        setValue(DatabaseConfigurationMgr.ERP_DATABASE_CONFIGURATION, DatabaseConfigurationMgr.STR_USER, storeUser);
    }

    public void setErpStorePassword(String storePassword) {
        setValue(DatabaseConfigurationMgr.ERP_DATABASE_CONFIGURATION, DatabaseConfigurationMgr.STR_PASSWORD, storePassword);
    }

    private void setValue(String parentTag, String chaildTag, String value) {
        try {
            NodeList nodeList = this.document.getElementsByTagName(parentTag);
            NodeList chalidList;
            Element parentElement, chalidElement;
            for (int i = 0; i < nodeList.getLength(); i++) {
                parentElement = (Element) nodeList.item(i);

                chalidList = parentElement.getElementsByTagName(chaildTag);
                chalidElement = (Element) chalidList.item(0);
                chalidElement.getFirstChild().setNodeValue(value);
            }
        } catch(Exception ex) {
            logger.error(ex.getMessage());
        }
    }

    public boolean updateDatabaseConfigurationXML() {
        boolean status = false;

        try {
            Transformer transformer = TransformerFactory.newInstance().newTransformer();
            Result result = new StreamResult(new File(databaseUpdateXmlPath));
            Source source = new DOMSource(this.document);
            
            transformer.transform(source, result);
            
            status = true;
        } catch(TransformerConfigurationException ex) {
            logger.error(ex.getMessage());
        } catch(TransformerException ex) {
            logger.error(ex.getMessage());
        } catch(Exception ex) {
            logger.error(ex.getMessage());
        }

        return status;
    }

    private Document getDocument() {
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();

        Document doc = null;

        try {
            doc = factory.newDocumentBuilder().parse(new File(databaseUpdateXmlPath));
        } catch(IOException e) {
            logger.error(e.getMessage());
        } catch(SAXException e) {
            logger.error(e.getMessage());
        } catch(ParserConfigurationException e) {
            logger.error(e.getMessage());
        }catch(Exception e){
            logger.error(e.getMessage());
        }

        return doc;
    }
}
