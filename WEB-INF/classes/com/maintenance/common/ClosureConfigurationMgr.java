package com.maintenance.common;

import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.MetaDataMgr;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.xml.parsers.*;
import org.apache.log4j.Logger;
import org.apache.log4j.xml.DOMConfigurator;
import org.w3c.dom.*;
import org.xml.sax.*;

public class ClosureConfigurationMgr {

    private static final ClosureConfigurationMgr closureConfigurationMgr = new ClosureConfigurationMgr();
    private static ArrayList<WebBusinessObject> closureActionsList;
    private Document document;
    private final String fileName = "closure_configuration.xml";
    private final Logger logger = Logger.getLogger(ClosureConfigurationMgr.class);
    private final MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();

    public static ClosureConfigurationMgr getCurrentInstance() {
        return closureConfigurationMgr;
    }

    private ClosureConfigurationMgr() {
        if (metaDataMgr.getWebInfPath() != null) {
            metaDataMgr.setMetaData("xfile.jar");
            DOMConfigurator.configure(metaDataMgr.getWebInfPath() + "/LogConfig.xml");

            // load data
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            try {
                document = factory.newDocumentBuilder().parse(metaDataMgr.getMetadata(fileName));
                closureActionsList = new ArrayList<>();
                WebBusinessObject wbo;
                NodeList departmentNodeList = document.getElementsByTagName("department");
                if (departmentNodeList != null) {
                    for (int i = 0; i < departmentNodeList.getLength(); i++) {
                        Node departmentNode = departmentNodeList.item(i);
                        if (departmentNode.hasChildNodes()) {
                            NodeList childNodeList = departmentNode.getChildNodes();
                            wbo = new WebBusinessObject();
                            for (int j = 0; j < childNodeList.getLength(); j++) {
                                Node childNode = childNodeList.item(j);
                                if (childNode.getNodeType() == Node.ELEMENT_NODE) {
                                    wbo.setAttribute(childNode.getNodeName(), childNode.getTextContent());
                                }
                            }
                            closureActionsList.add(wbo);
                        }
                    }
                }
            } catch (IOException | SAXException | ParserConfigurationException e) {
                logger.error(e.getMessage());
            }
        }
    }

    public ArrayList<WebBusinessObject> getClosureActionsList() {
        return closureActionsList;
    }

    public WebBusinessObject getAction(String actionID) {
        for (WebBusinessObject wboTemp : closureActionsList) {
            if (wboTemp.getAttribute("id").equals(actionID)) {
                return wboTemp;
            }
        }
        return null;
    }
}
