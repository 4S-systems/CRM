package com.silkworm.generics;

import java.sql.*;
import javax.sql.*;

public abstract class swSwingApplication 
{
    protected DataSource dataSource;
    
    /** Creates a new instance of swSwingApplication */
    public swSwingApplication() throws Exception
    {
        try
        {
            init();
        }
        catch(Exception e)
       {
            // log expetion say I could not init the app
            throw new Exception("could not initialize application...");
       }
    }
    
    public void init() throws Exception
    {
        initDataSource();
    }
    
    protected abstract void initDataSource() throws SQLException,Exception;
    
}
