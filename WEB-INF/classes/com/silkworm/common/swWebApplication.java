package com.silkworm.common;

import java.sql.*;
import javax.sql.*;
import java.util.*;

import com.silkworm.persistence.relational.*;

public abstract class swWebApplication {
    
    protected DataSource dataSource;
    protected String webInfPath = null;
    protected String imageDirPath = null;
    protected String webAppBaseURL = null;
    protected String[] sys_paths = null;
    protected Properties dataBase = null;
    
    public abstract void init() throws Exception;
    
    public swWebApplication() { }
    
    public swWebApplication(String driverClass, String databaseURL, Properties connectionAttributes, String sys_paths) throws SQLException, Exception {
        initDataSource(driverClass, databaseURL, connectionAttributes);
        webInfPath = sys_paths;
        init();
    }
    
    public swWebApplication(String driverClass, String databaseURL, Properties connectionAttributes, String[] sys_paths) throws SQLException, Exception {
        initDataSource(driverClass, databaseURL, connectionAttributes);
        webInfPath = sys_paths[0];
        imageDirPath = sys_paths[1];
        this.sys_paths = sys_paths;
        init();
    }
    
    private void initDataSource(String driverClass, String databaseURL, Properties connectionAttributes) throws SQLException, Exception {
        try {
            System.out.println("trying to connect to database...." + databaseURL);
            dataSource = new DataSourceWrapper(driverClass,
            databaseURL,connectionAttributes);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("SQL Exception");
            throw e;
        } catch(ClassNotFoundException cnf) {
            System.out.println("ClassNotFoundException");
            throw cnf;
        } catch(InstantiationException iex) {
            System.out.println("InitiationExeption");
            throw iex;
        }
        System.out.println("Database connection is successful .....");
        
    }
    
    public void setWebAppBase(String indexFileURL) {
        StringBuilder buffer = new StringBuilder(indexFileURL);
        int pos = buffer.indexOf("index");
        webAppBaseURL = buffer.substring(0,pos).toString();
    }
    
    public String getAppBase() {
        return webAppBaseURL;
    }
    
    public void setDatabaseProperties(java.util.Properties p) {
           dataBase = p;
    }
    
    public String getImageDirPath() {
        return webAppBaseURL + "images/";
    }
}
