package com.silkworm.persistence.relational;

import java.sql.*;
import java.util.*;

/**
 * This class implements a connection pool. It's the same as the
 * ConnectionPool class described in Java Servlet Programming (O'Reilly),
 * copied with permission from Jason Hunter.
 * It's used by the DataSourceWrapper class to provide a JDBC 2.0
 * DataSource interface to the pool.
 *
 * @author Jason Hunter, <jhunter@acm.org>
 * @version 1.0
 */
public class ConnectionPool {
    private Hashtable connections;
    private int increment;
    private String dbURL;
    private Properties connectionDetails;

    public ConnectionPool(String dbURL, Properties details, 
        String driverClassName, int initialConnections, int increment)
        throws SQLException, ClassNotFoundException {

        // Load the specified driver class
        Class.forName(driverClassName);

        this.dbURL = dbURL;
        this.connectionDetails = details;
        this.increment = increment;

        connections = new Hashtable();

        // Put our pool of Connections in the Hashtable
        // The FALSE value indicates they're unused
        for(int i = 0; i < initialConnections; i++) {
            connections.put(DriverManager.getConnection(dbURL,connectionDetails),Boolean.FALSE);
              
        }
    }

    public Connection getConnection() throws SQLException {
        Connection con = null;

        Enumeration cons = connections.keys();

        synchronized (connections) {
            while(cons.hasMoreElements()) {
                con = (Connection)cons.nextElement();

                Boolean b = (Boolean)connections.get(con);
                if (b == Boolean.FALSE) {
                    // So we found an unused connection.
                    // Test its integrity with a quick setAutoCommit(true) call.
                    // For production use, more testing should be performed,
                    // such as executing a simple query.
                    try {
                        con.setAutoCommit(true);
                    }
                    catch(SQLException e) {
                        // Problem with the connection, replace it.
                        connections.remove(con);
                        con = DriverManager.getConnection(dbURL,connectionDetails);
                    }
                    // Update the Hashtable to show this one's taken
                    connections.put(con, Boolean.TRUE);

                    // Return the connection
                    return con;
                }
            }
        }

        // If we get here, there were no free connections.
        // We've got to make more.
        for(int i = 0; i < increment; i++) {
            connections.put(DriverManager.getConnection(dbURL,connectionDetails),
                Boolean.FALSE);
        }

        // Recurse to get one of the new connections.
        return getConnection();
    }

    public void returnConnection(Connection returned) {
        if (connections.containsKey(returned)) {
            connections.put(returned, Boolean.FALSE);
        }
    }
}