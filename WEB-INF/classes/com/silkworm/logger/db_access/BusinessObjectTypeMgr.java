/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.silkworm.logger.db_access;

import com.lowagie.text.pdf.hyphenation.TernaryTree.Iterator;
import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.SqlMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author MSaudi
 */
public class BusinessObjectTypeMgr extends RDBGateWay {

    private static BusinessObjectTypeMgr businessObjectTypeMgr = new BusinessObjectTypeMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static BusinessObjectTypeMgr getInstance() {
        return businessObjectTypeMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("business_object_type.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        return new ArrayList(getCashedTable());
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Vector getAllData() {
        Connection connection = null;
        SQLCommandBean forSelect = new SQLCommandBean();
        Vector result = new Vector();
        try {
            connection = dataSource.getConnection();
            forSelect.setConnection(connection);
            forSelect.setSQLQuery(sqlMgr.getSql("selectAllObjects").trim());
            result = forSelect.executeQuery();
        } catch (SQLException ex) {
            Logger.getLogger(BusinessObjectTypeMgr.class.getName()).log(Level.SEVERE, null, ex);
        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(BusinessObjectTypeMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(BusinessObjectTypeMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        Vector reultBusObjs = new Vector();
        Row r = null;
        Enumeration e = result.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }
        return reultBusObjs;
    }

    @Override
    protected void initSupportedQueries() {
        return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
}
