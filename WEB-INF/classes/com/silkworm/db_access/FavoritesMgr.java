/*
 * FavoritesMgr.java
 *
 * Created on March 30, 2005, 7:28 AM
 */

package com.silkworm.db_access;

/**
 *
 * @author Walid
 */

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import com.silkworm.util.DictionaryItem;
import com.silkworm.util.*;
import java.util.*;
import java.text.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.sql.*;




public class FavoritesMgr extends RDBGateWay implements IBuildFavorites{
    
    private static FavoritesMgr fvtsMgr = new FavoritesMgr();
    
    private Vector userFavorits = null;
    
    private IBuildFavorites ibf = null;
    
    
    public static FavoritesMgr getInstance() {
        return fvtsMgr;
    }
    
    public void setFavoritesBuilder(IBuildFavorites implementer) {
        ibf = implementer;
    }
    
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    
    public ArrayList getCashedTableAsArrayList() {
        return null;
    }
    
    public ArrayList getCashedTableAsBusObjects() {
        return null;
    }
    
    protected void initSupportedForm() {
    }
    
    
    public Vector buildUserFavorits() {
        
        return ibf.buildUserFavorits();
    }
    public Vector buildLinkedFavoritsTree() {
        return ibf.buildLinkedFavoritsTree();
    }
    public Vector buildUserFavoritsNodes() {
        return ibf.buildUserFavoritsNodes();
    }

    @Override
    protected void initSupportedQueries() {
      return; //  throw new UnsupportedOperationException("Not supported yet.");
    }
    
    
}

