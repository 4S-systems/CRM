package com.silkworm.persistence.relational;

import java.util.*;
import java.sql.*;

/**
 * This class is a bean for executing SQL statements. It has three
 * properties that can be set: connection, sqlQuery and params.
 * The connection and sqlQuery properties must always be set before
 * calling one of the execute methods. If the params property is
 * set, the sqlQuery property must be a SQL statement with question
 * marks as placeholders for the Value objects in the params
 * property.
 *
 * @author Walid Mohamed, Silkworm software
 * @version 1.0
 */
public class SQLCommandBean {

    private Connection conn;
    private String sqlQuery;
    private Vector params;
    private boolean isExceptionThrown = false;

    /**
     * Sets the Connection to use.
     */
    public void setConnection(Connection conn) {
        this.conn = conn;
    }

    /**
     * Set the SQL string, possibly with ? place holders for
     * params set by setparams().
     */
    public void setSQLQuery(String sqlQuery) {
        this.sqlQuery = sqlQuery;
    }

    /**
     * Sets the params to use for the place holders in the SQL
     * string. The Vector must contain one Value object for
     * each place holder.
     */
    public void setparams(Vector params) {
        this.params = params;
    }

    /**
     * Executes the specified SQL string as a query and returns
     * a Vector with Row objects, or an empty Vector if no rows
     * where found.
     *
     * @return a Vector of Row objects
     * @exception SQLException
     * @exception UnsupportedTypeException, if the returned value
     *            doesn't match any Value subclass
     */
    public Vector executeQuery() throws SQLException, UnsupportedTypeException {
        Vector rows = null;
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        Statement stmt = null;
        try {
            if (params != null && params.size() > 0) {
                // Use a PreparedStatement and set all params
                pstmt = conn.prepareStatement(sqlQuery);
                setparams(pstmt, params);

                // System.out.println("About to Execute A PPPPPPPPPP Statement  ");
                rs = pstmt.executeQuery();
            } else {
                // Use a regular Statement
                stmt = conn.createStatement();
                rs = stmt.executeQuery(sqlQuery);
            }
            // Save the result in a Vector of Row object
            rows = toVector(rs);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (stmt != null) {
                    stmt.close();
                }
                if (pstmt != null) {
                    pstmt.close();
                }
            } catch (SQLException e) {
                // Ignore. Probably caused by a previous SQLException thrown
                // by the outer try block
            }
        }
        return rows;
    }

    public boolean execute() throws SQLException, UnsupportedTypeException {
        Vector rows = null;
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        Statement stmt = null;
        try {
            if (params != null && params.size() > 0) {
                // Use a PreparedStatement and set all params
                pstmt = conn.prepareStatement(sqlQuery);
                setparams(pstmt, params);

                // System.out.println("About to Execute A PPPPPPPPPP Statement  ");
                return pstmt.execute();
            } else {
                // Use a regular Statement
                stmt = conn.createStatement();
                return stmt.execute(sqlQuery);
            }
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (stmt != null) {
                    stmt.close();
                }
                if (pstmt != null) {
                    pstmt.close();
                }
            } catch (SQLException e) {
                // Ignore. Probably caused by a previous SQLException thrown
                // by the outer try block
            }
        }
    }

    /**
     * Executes the specified SQL string (any statement except SELECT, such
     * as UPDATE, INSERT, DELETE or CREATE TABLE) and returns
     * the number of rows affected by the statement, or 0 if none.
     *
     * @return the number of rows affected
     * @exception SQLException
     */
    public int executeUpdate() throws SQLException {
        int noOfRows = 0;
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        Statement stmt = null;
        try {
            if (params != null && params.size() > 0) {
                // Use a PreparedStatement and set all params
                pstmt = conn.prepareStatement(sqlQuery);
                setparams(pstmt, params);
                noOfRows = pstmt.executeUpdate();
            } else {
                // Use a regular Statement
                stmt = conn.createStatement();
                noOfRows = stmt.executeUpdate(sqlQuery);
            }
        }
        finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (stmt != null) {
                    stmt.close();
                }
                if (pstmt != null) {
                    pstmt.close();
                }
            } catch (SQLException e) {
                // Ignore. Probably caused by a previous SQLException thrown
                // by the outer try block
            }
        }
        return noOfRows;
    }

    /**
     * Calls setXXX() methods on the PreparedStatement for all Value
     * objects in the params Vector.
     *
     * @param preparedStatement the PreparedStatement
     * @param parameters a Vector with Value objects
     * @exception SQLException
     */
    private void setparams(PreparedStatement preparedStatement, Vector parameters) throws SQLException {
        for (int i = 0; i < parameters.size(); i++) {
            try {
                Value value = (Value) parameters.elementAt(i);
                // Set the value using the method corresponding to the type.
                // Note! Set methods are indexed from 1, so we add 1 to i
                if (value instanceof BigDecimalValue) {
                    preparedStatement.setBigDecimal(i + 1, value.getBigDecimal());
                } else if (value instanceof BooleanValue) {
                    preparedStatement.setBoolean(i + 1, value.getBoolean());
                } else if (value instanceof ByteValue) {
                    preparedStatement.setByte(i + 1, value.getByte());
                } else if (value instanceof BytesValue) {
                    preparedStatement.setBytes(i + 1, value.getBytes());
                } else if (value instanceof DateValue) {
                    preparedStatement.setDate(i + 1, value.getDate());
                } else if (value instanceof DoubleValue) {
                    preparedStatement.setDouble(i + 1, value.getDouble());
                } else if (value instanceof FloatValue) {
                    preparedStatement.setFloat(i + 1, value.getFloat());
                } else if (value instanceof IntValue) {
                    preparedStatement.setInt(i + 1, value.getInt());
                } else if (value instanceof LongValue) {
                    preparedStatement.setLong(i + 1, value.getLong());
                } else if (value instanceof ShortValue) {
                    preparedStatement.setShort(i + 1, value.getShort());
                } else if (value instanceof StringValue) {
                    preparedStatement.setString(i + 1, value.getString());
                } else if (value instanceof TimeValue) {
                    preparedStatement.setTime(i + 1, value.getTime());
                } else if (value instanceof TimestampValue) {
                    preparedStatement.setTimestamp(i + 1, value.getTimestamp());
                } else if (value instanceof ImageValue) {
                  //  preparedStatement.setBinaryStream(i + 1, value.getImageStream(), value.getImageFileLength());
                     preparedStatement.setBlob(i + 1, value.getImageStream(), value.getImageFileLength());
                } else if(value instanceof NullValue) {
                    preparedStatement.setString(i + 1, value.getString());
                } else {
                    preparedStatement.setObject(i + 1, value.getObject());
                }
            } catch (UnsupportedConversionException e) {
                // Can not happen here since we test the type first
            }
        }
    }

    /**
     * Gets all data from the ResultSet and returns it as a Vector,
     * of Row objects.
     *
     * @param rs the ResultSet
     * @return a Vector of Row objects
     * @exception SQLException, thrown by the JDBC API calls
     * @exception UnsupportedTypeException, if the returned value
     *            doesn't match any Value subclass
     */
    private Vector toVector(ResultSet rs) throws SQLException,
            UnsupportedTypeException {
        Vector rows = new Vector();
        while (rs.next()) {
            Row row = new Row(rs);
            rows.addElement(row);
        }
        return rows;
    }

    public void printParams() {
        for (int i = 0; i < params.size(); i++) {
            System.out.println(params.elementAt(i).toString());
        }
    }
}
