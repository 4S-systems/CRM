package com.silkworm.persistence.relational;

import java.io.*;
import java.sql.*;
import java.util.logging.Logger;
import javax.sql.*;
import java.util.*;

/**
 * This class is a wrapper implementing the JDBC 2.0 SE DataSource
 * interface, used to make the ConnectionPool class look like
 * a JDBC 2.0 DataSource.
 *
 * @author Hans Bergsten, Gefion software <hans@gefionsoftware.com>
 * @version 1.0
 */
public class DataSourceWrapper implements DataSource {
    private ConnectionPool pool;

    public DataSourceWrapper(String driverClass, String url, Properties details) throws ClassNotFoundException, InstantiationException,
        SQLException, IllegalAccessException {
        pool = new ConnectionPool(url,details,driverClass, 1, 1);
    }

    /**
     * Gets a connection from the pool and returns it wrapped in
     * a ConnectionWrapper.
     */
    public Connection getConnection() throws SQLException {
        return new ConnectionWrapper(pool.getConnection(), this);
    }

    /**
     * Returns a Connection to the pool. This method is called by
     * the ConnectionWrapper's close() method.
     */
    public void returnConnection(Connection conn) {
        pool.returnConnection(conn);
    }

    /**
     * Always throws a SQLException. Username and password are set
     * in the constructor and can not be changed.
     */
    public Connection getConnection(String username, String password)
            throws SQLException {
        throw new SQLException("Not supported");
    }

    /**
     * Always throws a SQLException. Not supported.
     */
    public int getLoginTimeout() throws SQLException {
        throw new SQLException("Not supported");
    }

    /**
     * Always throws a SQLException. Not supported.
     */
    public PrintWriter getLogWriter() throws SQLException {
        throw new SQLException("Not supported");
    }

    /**
     * Always throws a SQLException. Not supported.
     */
    public void setLoginTimeout(int seconds) throws SQLException {
        throw new SQLException("Not supported");
    }

    /**
     * Always throws a SQLException. Not supported.
     */
    public synchronized void setLogWriter(PrintWriter out) throws SQLException {
        throw new SQLException("Not supported");
    }

    public <T> T unwrap(Class<T> type) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public boolean isWrapperFor(Class<?> type) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Logger getParentLogger() throws SQLFeatureNotSupportedException {
        throw new UnsupportedOperationException("Not supported yet.");
    }
}
