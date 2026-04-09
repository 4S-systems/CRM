

package com.silkworm.contractor;

import com.silkworm.generics.*;
import com.silkworm.persistence.relational.*;
import java.io.File;
import java.io.FileReader;
import java.sql.*;
import javax.sql.*;
import java.util.*;
import com.silkworm.common.*;

import com.contractor.db_access.*;

import com.silkworm.business_objects.*;


public class swContractor extends swSwingApplication{
    
    /** Creates a new instance of swContractor */
    public swContractor() throws Exception {
        super();
        
        System.out.println("besm ALLAH");
        System.setProperty("encoding", "UTF-8");
        System.setProperty("locale", "ar");
        System.out.println(System.getProperty("encoding"));
        System.out.println(System.getProperty("locale"));
    }
    
    
    
    protected void initDataSource() throws SQLException, Exception {
        
        Properties connectionProperties = new Properties();
        connectionProperties.put("user", "root");
        connectionProperties.put("password", "");
        connectionProperties.put("useUnicode", "true");
        connectionProperties.put("characterEncoding", "UTF-8");
        
        try {
//            FileReader fReader = new FileReader(new File("images/database.txt"));
//            String s = new String();
//            while (fReader.ready()){
//                char c = (char) fReader.read();
//                s = s + c;
//            }
            System.out.println("trying to connect to database....");
            dataSource = new DataSourceWrapper("com.mysql.jdbc.Driver",
                    "jdbc:mysql://localhost:3307/maintenance",connectionProperties);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            throw e;
        } catch(ClassNotFoundException cnf) {
            System.out.println(cnf.getMessage());
            throw cnf;
        } catch(InstantiationException iex) {
            System.out.println(iex.getMessage());
            throw iex;
        } catch(Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
    public void init() throws Exception {
        super.init();
        
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        metaMgr.setMetaData("xfile.jar");
        
        MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
        maintainableMgr.setDataSource(dataSource);
        maintainableMgr.cashData();
        
        PeriodicMgr periodicMgr = PeriodicMgr.getInstance();
        periodicMgr.setDataSource(dataSource);
        periodicMgr.cashData();
        
//        IssueMgr issueMgr = IssueMgr.getInstance();
//        issueMgr.setDataSource(dataSource);
//        issueMgr.cashData();
    }
    
}
