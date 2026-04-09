/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.wdr.db_access;

import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.db_access.FavoritesMgr;
import com.silkworm.persistence.relational.RDBGateWay;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 *
 * @author walid
 */
public class BaseReportsMgr extends RDBGateWay{
    
    private static BaseReportsMgr baseReportsMgr = new BaseReportsMgr();
    public static BaseReportsMgr getInstance() {
        return baseReportsMgr;
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    protected void initSupportedForm() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    protected void initSupportedQueries() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
}
