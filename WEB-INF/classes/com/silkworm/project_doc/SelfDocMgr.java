/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.silkworm.project_doc;

import com.maintenance.common.ConfigFileMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.persistence.relational.RDBGateWay;
import java.io.File;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;
import org.apache.log4j.Logger;
import org.jdom.*;
import org.jdom.input.SAXBuilder;

/**
 *
 * @author khaled abdo
 */
public class SelfDocMgr extends RDBGateWay {

    MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
    private static SelfDocMgr selfDocMgr = new SelfDocMgr();
    private static String currentLanguage = "Ar";
    protected static Logger logger = Logger.getLogger(ConfigFileMgr.class);
    public static final String ATTRIBUTE_FORMS_XML_FORM_CODE = "code";
    public static final String ATTRIBUTE_FORMS_XML_FORM = "form";
    public static final String ATTRIBUTE_FORMS_XML_NAME_AR = "nameAr";
    public static final String ATTRIBUTE_FORMS_XML_NAME_EN = "nameEn";
    public static final String ATTRIBUTE_FORMS_XML_DECRIPTION_EN = "descEn";
    public static final String ATTRIBUTE_FORMS_XML_DECRIPTION_AR = "descAr";
    public static final String ATTRIBUTE_FORMS_XML_TABEL_READ = "tableRead";
    public static final String ATTRIBUTE_FORMS_XML_TABLE_WRITE = "tableWrite";
    public static final String ATTRIBUTE_FORMS_XML_VIEWS_READ = "viewsRead";
   // public static final String ATTRIBUTE_FORMS_XML_FORM_INDEX = "index";
    public static final String ATTRIBUTE_FORMS_XML_JSP_TAG = "jspTag";
    public static final String ATTRIBUTE_FORMS_XML_QUERY_STRING = "queryString";
    // CONFIG PATH
    public static final String PATH_FORMS_XML = staticWebInfPath + "/database/self_docs.xml";
    private Document doc;
    private Element elements = null;
    private List<Element> listElements;
    private SAXBuilder builder = new SAXBuilder();

    public static SelfDocMgr getInstance() {
        logger.error("Getting databaseControllerMgr Instance ....");
        return selfDocMgr;
    }

    public Vector getFormsList(String formCode) {

        Vector<WebBusinessObject> formVector = new Vector<WebBusinessObject>();
        try {
            doc = (Document) builder.build(new File(SelfDocMgr.PATH_FORMS_XML));
        } catch (JDOMException ex) {
            logger.error(ex.getMessage());
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        elements = doc.getRootElement();
        listElements = elements.getChildren();

        WebBusinessObject wbo = new WebBusinessObject();
        ListForms(formCode, wbo);

        formVector.addElement(wbo);

        return formVector;
    }

    public void ListForms(String formCode, WebBusinessObject wbo) {
        try {
            for (Element element : listElements) {
                if (element.getChild(SelfDocMgr.ATTRIBUTE_FORMS_XML_FORM_CODE).getText().equalsIgnoreCase(formCode)) {

                    wbo.setAttribute(SelfDocMgr.ATTRIBUTE_FORMS_XML_FORM_CODE, element.getChild(SelfDocMgr.ATTRIBUTE_FORMS_XML_FORM_CODE).getText());
                    wbo.setAttribute(SelfDocMgr.ATTRIBUTE_FORMS_XML_NAME_AR, element.getChild(SelfDocMgr.ATTRIBUTE_FORMS_XML_NAME_AR).getText());
                    wbo.setAttribute(SelfDocMgr.ATTRIBUTE_FORMS_XML_NAME_EN, element.getChild(SelfDocMgr.ATTRIBUTE_FORMS_XML_NAME_EN).getText());
                    wbo.setAttribute(SelfDocMgr.ATTRIBUTE_FORMS_XML_DECRIPTION_AR, element.getChild(SelfDocMgr.ATTRIBUTE_FORMS_XML_DECRIPTION_AR).getText());
                    wbo.setAttribute(SelfDocMgr.ATTRIBUTE_FORMS_XML_DECRIPTION_EN, element.getChild(SelfDocMgr.ATTRIBUTE_FORMS_XML_DECRIPTION_EN).getText());
                    wbo.setAttribute(SelfDocMgr.ATTRIBUTE_FORMS_XML_TABEL_READ, element.getChild(SelfDocMgr.ATTRIBUTE_FORMS_XML_TABEL_READ).getText());
                    wbo.setAttribute(SelfDocMgr.ATTRIBUTE_FORMS_XML_TABLE_WRITE, element.getChild(SelfDocMgr.ATTRIBUTE_FORMS_XML_TABLE_WRITE).getText());
                    wbo.setAttribute(SelfDocMgr.ATTRIBUTE_FORMS_XML_VIEWS_READ, element.getChild(SelfDocMgr.ATTRIBUTE_FORMS_XML_VIEWS_READ).getText());
                  //  wbo.setAttribute(SelfDocMgr.ATTRIBUTE_FORMS_XML_FORM_INDEX, element.getChild(SelfDocMgr.ATTRIBUTE_FORMS_XML_FORM_INDEX).getText());
                    wbo.setAttribute(SelfDocMgr.ATTRIBUTE_FORMS_XML_JSP_TAG, element.getChild(SelfDocMgr.ATTRIBUTE_FORMS_XML_JSP_TAG).getText());
                    wbo.setAttribute(SelfDocMgr.ATTRIBUTE_FORMS_XML_QUERY_STRING, element.getChild(SelfDocMgr.ATTRIBUTE_FORMS_XML_QUERY_STRING).getText());
                    return;
                }
            }
        } catch (Exception ex) {

            logger.error(ex.getMessage());
        }
    }

    public void getFormsDetails() {

        try {
            doc = (Document) builder.build(new File(SelfDocMgr.PATH_FORMS_XML));
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        /*elements = doc.getRootElement();
        listElements = elements.getChildren();*/

        /*WebBusinessObject wbo = null;*/

        List<WebBusinessObject> forms = null;

        //Element element = doc.getDocumentElement();

        //NodeList form = doc.getElementsByTagName("form");

        //NodeList personNodes = element.getChildNodes();

        //for (int i = 0; i < form.getLength(); i++) {
        //Node emp = personNodes.item(i);
            /*if (isTextNode(emp)) {
        continue;
        }*/

        /*wbo = new WebBusinessObject();
        String lang = "Ar";
        if(!currentLanguage.equalsIgnoreCase("Ar")){
        lang = "En";
        }
        NodeList index = doc.getElementsByTagName("index");
        Element indexElement = (Element) index.item(i);
        String indexForm = indexElement.getChildNodes().item(0).getNodeValue();
        
        NodeList code = doc.getElementsByTagName("code");
        Element codeElement = (Element) code.item(i);
        String codeForm = codeElement.getChildNodes().item(0).getNodeValue();
        
        
        NodeList name = doc.getElementsByTagName("name"+lang);
        Element nameElement = (Element) name.item(i);
        String nameForm = nameElement.getChildNodes().item(0).getNodeValue();
        
        NodeList desc = doc.getElementsByTagName("desc"+lang);
        Element descElement = (Element) desc.item(i);
        String descForm = descElement.getChildNodes().item(0).getNodeValue();
        
        wbo.setAttribute("index", indexForm);
        wbo.setAttribute("code", codeForm);
        wbo.setAttribute("name", nameForm);
        wbo.setAttribute("desc", descForm);
        
        forms.add(wbo);    
        }*/

        //eturn forms;
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    protected void initSupportedForm() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    protected void initSupportedQueries() {
      return; //  throw new UnsupportedOperationException("Not supported yet.");
    }
}