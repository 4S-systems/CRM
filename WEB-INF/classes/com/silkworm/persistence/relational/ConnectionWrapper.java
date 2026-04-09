package com.silkworm.persistence.relational;

import java.sql.*;
import java.util.*;
import java.util.concurrent.Executor;

/**
 * This class is a wrapper around a Connection, overriding the
 * close method to just inform the DataSourceWrapper that it's available
 * for reuse again, and the isClosed method to return the state
 * of the wrapper instead of the Connection.
 *
 * @author Hans Bergsten, Gefion software <hans@gefionsoftware.com>
 * @version 1.0
 */
public class ConnectionWrapper implements Connection{
    private Connection realConn;
    private DataSourceWrapper dsw;
    private boolean isClosed = false;
    
    public ConnectionWrapper(Connection realConn, DataSourceWrapper dsw) {
        this.realConn = realConn;
        this.dsw = dsw;
    }
    
    /**
     * Inform the DataSourceWrapper that the ConnectionWrapper
     * is closed.
     */
    public void close() throws SQLException {
        isClosed = true;
        dsw.returnConnection(realConn);
    }
    
    /**
     * Returns true if the ConnectionWrapper is closed, false
     * otherwise.
     */
    public boolean isClosed() throws SQLException {
        return isClosed;
    }
    
    /*
     * Wrapped methods. See Connection for details.
     */
    
    public void clearWarnings() throws SQLException {
        if (isClosed) {
            throw new SQLException("Pooled connection is closed");
        }
        realConn.clearWarnings();
    }
    
    /**
     * Calls the corresponding method on the wrapped Connection.
     */
    public void commit() throws SQLException {
        if (isClosed) {
            throw new SQLException("Pooled connection is closed");
        }
        realConn.commit();
    }
    
    /**
     * Calls the corresponding method on the wrapped Connection.
     */
    public Statement createStatement() throws SQLException {
        if (isClosed) {
            throw new SQLException("Pooled connection is closed");
        }
        return realConn.createStatement();
    }
    
    /**
     * Calls the corresponding method on the wrapped Connection.
     */
    public Statement createStatement(int resultSetType,
    int resultSetConcurrency) throws SQLException {
        if (isClosed) {
            throw new SQLException("Pooled connection is closed");
        }
        return realConn.createStatement(resultSetType, resultSetConcurrency);
    }
    
    /**
     * Calls the corresponding method on the wrapped Connection.
     */
    public boolean getAutoCommit() throws SQLException {
        if (isClosed) {
            throw new SQLException("Pooled connection is closed");
        }
        return realConn.getAutoCommit();
    }
    
    /**
     * Calls the corresponding method on the wrapped Connection.
     */
    public String getCatalog() throws SQLException {
        if (isClosed) {
            throw new SQLException("Pooled connection is closed");
        }
        return realConn.getCatalog();
    }
    
    /**
     * Calls the corresponding method on the wrapped Connection.
     */
    public DatabaseMetaData getMetaData() throws SQLException {
        if (isClosed) {
            throw new SQLException("Pooled connection is closed");
        }
        return realConn.getMetaData();
    }
    
    /**
     * Calls the corresponding method on the wrapped Connection.
     */
    public int getTransactionIsolation() throws SQLException {
        if (isClosed) {
            throw new SQLException("Pooled connection is closed");
        }
        return realConn.getTransactionIsolation();
    }
    
    /**
     * Calls the corresponding method on the wrapped Connection.
     */
    public Map getTypeMap() throws SQLException {
        if (isClosed) {
            throw new SQLException("Pooled connection is closed");
        }
        return realConn.getTypeMap();
    }
    
    /**
     * Calls the corresponding method on the wrapped Connection.
     */
    public SQLWarning getWarnings() throws SQLException {
        if (isClosed) {
            throw new SQLException("Pooled connection is closed");
        }
        return realConn.getWarnings();
    }
    
    /**
     * Calls the corresponding method on the wrapped Connection.
     */
    public boolean isReadOnly() throws SQLException {
        if (isClosed) {
            throw new SQLException("Pooled connection is closed");
        }
        return realConn.isReadOnly();
    }
    
    /**
     * Calls the corresponding method on the wrapped Connection.
     */
    public String nativeSQL(String sql) throws SQLException {
        if (isClosed) {
            throw new SQLException("Pooled connection is closed");
        }
        return realConn.nativeSQL(sql);
    }
    
    /**
     * Calls the corresponding method on the wrapped Connection.
     */
    public CallableStatement prepareCall(String sql) throws SQLException {
        if (isClosed) {
            throw new SQLException("Pooled connection is closed");
        }
        return realConn.prepareCall(sql);
    }
    
    /**
     * Calls the corresponding method on the wrapped Connection.
     */
    public CallableStatement prepareCall(String sql,int resultSetType,
    int resultSetConcurrency) throws SQLException {
        if (isClosed) {
            throw new SQLException("Pooled connection is closed");
        }
        return realConn.prepareCall(sql, resultSetType, resultSetConcurrency);
    }
    
    /**
     * Calls the corresponding method on the wrapped Connection.
     */
    public PreparedStatement prepareStatement(String sql) throws SQLException {
        if (isClosed) {
            throw new SQLException("Pooled connection is closed");
        }
        return realConn.prepareStatement(sql);
    }
    
    /**
     * Calls the corresponding method on the wrapped Connection.
     */
    public PreparedStatement prepareStatement(String sql, int resultSetType,
    int resultSetConcurrency) throws SQLException {
        if (isClosed) {
            throw new SQLException("Pooled connection is closed");
        }
        return realConn.prepareStatement(sql, resultSetType,
        resultSetConcurrency);
    }
    
    /**
     * Calls the corresponding method on the wrapped Connection.
     */
    public void rollback() throws SQLException {
        if (isClosed) {
            throw new SQLException("Pooled connection is closed");
        }
        realConn.rollback();
    }
    
    /**
     * Calls the corresponding method on the wrapped Connection.
     */
    public void setAutoCommit(boolean autoCommit) throws SQLException {
        if (isClosed) {
            throw new SQLException("Pooled connection is closed");
        }
        realConn.setAutoCommit(autoCommit);
    }
    
    /**
     * Calls the corresponding method on the wrapped Connection.
     */
    public void setCatalog(String catalog) throws SQLException {
        if (isClosed) {
            throw new SQLException("Pooled connection is closed");
        }
        realConn.setCatalog(catalog);
    }
    
    /**
     * Calls the corresponding method on the wrapped Connection.
     */
    public void setReadOnly(boolean readOnly) throws SQLException {
        if (isClosed) {
            throw new SQLException("Pooled connection is closed");
        }
        realConn.setReadOnly(readOnly);
    }
    
    /**
     * Calls the corresponding method on the wrapped Connection.
     */
    public void setTransactionIsolation(int level) throws SQLException {
        if (isClosed) {
            throw new SQLException("Pooled connection is closed");
        }
        realConn.setTransactionIsolation(level);
    }
    
    public void setTypeMap(Map map) throws SQLException {
        if (isClosed) {
            throw new SQLException("Pooled connection is closed");
        }
        realConn.setTypeMap(map);
    }
    
    public void setHoldability(int z) {
        return ;
    }
    
    public int getHoldability() {
        return(0);
    }
    
    public Savepoint setSavepoint()throws SQLException
    {
        Savepoint sp=null;
        return(sp);
    }
    
    public Savepoint setSavepoint(String z)throws SQLException
    {
        Savepoint sp=null;
        return(sp);
    }
    
    public Statement createStatement(int resultSetType, int resultSetConcurrency, int resultSetHoldability) throws SQLException {
        Statement s =null;
        return(s);
    }
    
    public CallableStatement prepareCall(String sql, int resultSetType, int resultSetConcurrency, int resultSetHoldability) throws SQLException {
        CallableStatement cs = null;
        return (cs);
    }
    
    public PreparedStatement prepareStatement(String sql, String[] columnNames) throws SQLException {
        PreparedStatement ps=null;
        return(ps);
    }
    
    public PreparedStatement prepareStatement(String sql, int autoGeneratedKeys) throws SQLException {
        PreparedStatement ps=null;
        return(ps);
    }
    
    public PreparedStatement prepareStatement(String sql, int[] columnIndexes) throws SQLException {
        PreparedStatement ps=null;
        return(ps);
    }
    
    public PreparedStatement prepareStatement(String sql, int resultSetType, int resultSetConcurrency, int resultSetHoldability) throws SQLException {
        PreparedStatement ps=null;
        return(ps);
    }
    
    public void releaseSavepoint(Savepoint savepoint) throws SQLException {
        return;
    }
    
    public void rollback(Savepoint savepoint) throws SQLException {
        return;
    }

    public Clob createClob() throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Blob createBlob() throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public NClob createNClob() throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public SQLXML createSQLXML() throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public boolean isValid(int i) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void setClientInfo(String string, String string1) throws SQLClientInfoException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void setClientInfo(Properties prprts) throws SQLClientInfoException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getClientInfo(String string) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Properties getClientInfo() throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Array createArrayOf(String string, Object[] os) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Struct createStruct(String string, Object[] os) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public <T> T unwrap(Class<T> type) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public boolean isWrapperFor(Class<?> type) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void setSchema(String schema) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getSchema() throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }


    public void abort(Executor executor) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }


    public void setNetworkTimeout(Executor executor, int milliseconds) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public int getNetworkTimeout() throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

   
    
}
