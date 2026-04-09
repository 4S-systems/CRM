package com.ApplicationConfiguration.db_access;

import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.SqlMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class CompanyConfigMgr extends RDBGateWay {

    private static CompanyConfigMgr companyConfigMgr = new CompanyConfigMgr();
    private SqlMgr sqlMgr = SqlMgr.getInstance();

    public static CompanyConfigMgr getInstance() {
        return companyConfigMgr;
    }

    @Override protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("companyConfig.xml")));
            } catch (Exception e) {
                logger.error(e.getMessage());
            }
        }
    }

    @Override public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public boolean updateObject(WebBusinessObject wbo) {
        int result = -1000;
        Vector params = new Vector();
        params.addElement(new StringValue(wbo.getAttribute("arName").toString()));
        params.addElement(new StringValue(wbo.getAttribute("enName").toString()));
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            SQLCommandBean forUpdate = new SQLCommandBean();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateCompanyName").trim());
            forUpdate.setparams(params);
            result = forUpdate.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(CompanyConfigMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(CompanyConfigMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return result > 0;
    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
}
