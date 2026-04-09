package com.silkworm.persistence.relational;

import java.util.*;
import java.sql.*;
import java.sql.Date;
import java.math.*;


/**
 * This class represents a Row in a database query result. It contains
 * a collection of Column objects. A Vector is used to hold the
 * Column objects to preserve the column order in the base ResultSet.
 *
 * @author Walid Mohamed, Silkworm software
 * @version 1.0
 */
public class Row  {
    private Column[] columns;

    /**
     * Constructor. Reads the columns from the current row in the
     * specified ResultSet and creates the corresponding ColumnValue
     * objects.
     *
     * @param rs the ResultSet
     * @exception SQLException, if thrown by any JDBC API call
     */
    public Row(ResultSet rs) throws SQLException, UnsupportedTypeException {
        ResultSetMetaData rsmd = rs.getMetaData();
        int cols = rsmd.getColumnCount();
        columns = new Column[cols];
        // Note! Columns are numbered from 1 in the ResultSet
        for (int i = 1; i <= cols; i++) {
            int type = rsmd.getColumnType(i);
            switch (type) {
                case Types.DATE:
                    columns[i - 1] = new DateColumn(rsmd.getColumnName(i),
                        rs.getDate(i));
                    break;
                case Types.TIME:
                    columns[i - 1] = new TimeColumn(rsmd.getColumnName(i),
                        rs.getTime(i));
                    break;
                case Types.TIMESTAMP:
                    columns[i - 1] = new TimestampColumn(rsmd.getColumnName(i),
                        rs.getTimestamp(i));
                    break;
                case Types.REAL:
                case Types.FLOAT:
                    columns[i - 1] = new FloatColumn(rsmd.getColumnName(i),
                        rs.getFloat(i));
                    break;
                case Types.DOUBLE:
                    columns[i - 1] = new DoubleColumn(rsmd.getColumnName(i),
                        rs.getDouble(i));
                    break;
                case Types.TINYINT:
                    columns[i - 1] = new ByteColumn(rsmd.getColumnName(i),
                        rs.getByte(i));
                    break;
                case Types.SMALLINT:
                    columns[i - 1] = new ShortColumn(rsmd.getColumnName(i), rs.getShort(i));
                    break;
                case Types.INTEGER:
                    columns[i - 1] = new IntColumn(rsmd.getColumnName(i), rs.getInt(i));
                    break;
                case Types.BIGINT:
                    columns[i - 1] = new LongColumn(rsmd.getColumnName(i), rs.getLong(i));
                    break;
                case Types.DECIMAL:
                case Types.NUMERIC:
                    columns[i - 1] = new BigDecimalColumn(rsmd.getColumnName(i), rs.getBigDecimal(i));
                    break;
                case Types.CHAR:
                case Types.LONGVARCHAR:
                case Types.VARCHAR:
                case Types.NVARCHAR:   
                    columns[i - 1] = new StringColumn(rsmd.getColumnName(i), rs.getString(i));
                    break;
                case Types.BLOB:   
                    columns[i - 1] = new BytesColumn(rsmd.getColumnName(i), rs.getBytes(i));
                    break;
                default:
                    columns[i - 1] = new StringColumn(rsmd.getColumnName(i), rs.getString(i));
            }
        }
    }

    /**
     * Returns the number of columns in this row.
     */
    public int getColumnCount() {
        return columns.length;
    }

    /**
     * Returns an array of the Columns in this row.
     */
    public Column[] getColumns() {
        return columns;
    }

    public BigDecimal getBigDecimal(int columnIndex)
        throws NoSuchColumnException, UnsupportedConversionException {
        Column col = null;
        try {
            col = columns[columnIndex - 1];
        }
        catch (ArrayIndexOutOfBoundsException e) {
            throw new NoSuchColumnException(String.valueOf(columnIndex));
        }
        return col.getBigDecimal();
    }

    public BigDecimal getBigDecimal(String columnName)
        throws NoSuchColumnException, UnsupportedConversionException {
        return getBigDecimal(getIndex(columnName));
    }

    public boolean getBoolean(int columnIndex)
        throws NoSuchColumnException, UnsupportedConversionException {
        Column col = null;
        try {
            col = columns[columnIndex - 1];
        }
        catch (ArrayIndexOutOfBoundsException e) {
            throw new NoSuchColumnException(String.valueOf(columnIndex));
        }
        return col.getBoolean();
    }

    public boolean getBoolean(String columnName)
        throws NoSuchColumnException, UnsupportedConversionException {
        return getBoolean(getIndex(columnName));
    }

    public byte getByte(int columnIndex)
        throws NoSuchColumnException, UnsupportedConversionException {
        Column col = null;
        try {
            col = columns[columnIndex - 1];
        }
        catch (ArrayIndexOutOfBoundsException e) {
            throw new NoSuchColumnException(String.valueOf(columnIndex));
        }
        return col.getByte();
    }

    public byte getByte(String columnName)
        throws NoSuchColumnException, UnsupportedConversionException {
        return getByte(getIndex(columnName));
    }

    public byte[] getBytes(int columnIndex)
        throws NoSuchColumnException, UnsupportedConversionException {
        Column col = null;
        try {
            col = columns[columnIndex - 1];
        }
        catch (ArrayIndexOutOfBoundsException e) {
            throw new NoSuchColumnException(String.valueOf(columnIndex));
        }
        return col.getBytes();
    }

    public byte[] getBytes(String columnName)
        throws NoSuchColumnException, UnsupportedConversionException {
        return getBytes(getIndex(columnName));
    }

    public Date getDate(int columnIndex)
        throws NoSuchColumnException, UnsupportedConversionException {
        Column col = null;
        try {
            col = columns[columnIndex - 1];
        }
        catch (ArrayIndexOutOfBoundsException e) {
            throw new NoSuchColumnException(String.valueOf(columnIndex));
        }
        return col.getDate();
    }

    public Date getDate(String columnName)
        throws NoSuchColumnException, UnsupportedConversionException {
        return getDate(getIndex(columnName));
    }

    public double getDouble(int columnIndex)
        throws NoSuchColumnException, UnsupportedConversionException {
        Column col = null;
        try {
            col = columns[columnIndex - 1];
        }
        catch (ArrayIndexOutOfBoundsException e) {
            throw new NoSuchColumnException(String.valueOf(columnIndex));
        }
        return col.getDouble();
    }

    public double getDouble(String columnName)
        throws NoSuchColumnException, UnsupportedConversionException {
        return getDouble(getIndex(columnName));
    }

    public float getFloat(int columnIndex)
        throws NoSuchColumnException, UnsupportedConversionException {
        Column col = null;
        try {
            col = columns[columnIndex - 1];
        }
        catch (ArrayIndexOutOfBoundsException e) {
            throw new NoSuchColumnException(String.valueOf(columnIndex));
        }
        return col.getFloat();
    }

    public float getFloat(String columnName)
        throws NoSuchColumnException, UnsupportedConversionException {
        return getFloat(getIndex(columnName));
    }

    public int getInt(int columnIndex)
        throws NoSuchColumnException, UnsupportedConversionException {
        Column col = null;
        try {
            col = columns[columnIndex - 1];
        }
        catch (ArrayIndexOutOfBoundsException e) {
            throw new NoSuchColumnException(String.valueOf(columnIndex));
        }
        return col.getInt();
    }

    public int getInt(String columnName)
        throws NoSuchColumnException, UnsupportedConversionException {
        return getInt(getIndex(columnName));
    }

    public long getLong(int columnIndex)
        throws NoSuchColumnException, UnsupportedConversionException {
        Column col = null;
        try {
            col = columns[columnIndex - 1];
        }
        catch (ArrayIndexOutOfBoundsException e) {
            throw new NoSuchColumnException(String.valueOf(columnIndex));
        }
        return col.getLong();
    }

    public long getLong(String columnName)
        throws NoSuchColumnException, UnsupportedConversionException {
        return getLong(getIndex(columnName));
    }

    public Object getObject(int columnIndex)
        throws NoSuchColumnException, UnsupportedConversionException {
        Column col = null;
        try {
            col = columns[columnIndex - 1];
        }
        catch (ArrayIndexOutOfBoundsException e) {
            throw new NoSuchColumnException(String.valueOf(columnIndex));
        }
        return col.getObject();
    }

    public Object getObject(String columnName)
        throws NoSuchColumnException, UnsupportedConversionException {
        return getObject(getIndex(columnName));
    }

    public short getShort(int columnIndex)
        throws NoSuchColumnException, UnsupportedConversionException {
        Column col = null;
        try {
            col = columns[columnIndex - 1];
        }
        catch (ArrayIndexOutOfBoundsException e) {
            throw new NoSuchColumnException(String.valueOf(columnIndex));
        }
        return col.getShort();
    }

    public short getShort(String columnName)
        throws NoSuchColumnException, UnsupportedConversionException {
        return getShort(getIndex(columnName));
    }

    public String getString(int columnIndex)
        throws NoSuchColumnException {
        Column col = null;
        try {
            col = columns[columnIndex - 1];
        }
        catch (ArrayIndexOutOfBoundsException e) {
            throw new NoSuchColumnException(String.valueOf(columnIndex));
        }
        return col.getString();
    }

    public String getString(String columnName)
        throws NoSuchColumnException {
        return getString(getIndex(columnName));
    }

    public Time getTime(int columnIndex)
        throws NoSuchColumnException, UnsupportedConversionException {
        Column col = null;
        try {
            col = columns[columnIndex - 1];
        }
        catch (ArrayIndexOutOfBoundsException e) {
            throw new NoSuchColumnException(String.valueOf(columnIndex));
        }
        return col.getTime();
    }

    public Time getTime(String columnName)
        throws NoSuchColumnException, UnsupportedConversionException {
        return getTime(getIndex(columnName));
    }

    public Timestamp getTimestamp(int columnIndex)
        throws NoSuchColumnException, UnsupportedConversionException {
        Column col = null;
        try {
            col = columns[columnIndex - 1];
        }
        catch (ArrayIndexOutOfBoundsException e) {
            throw new NoSuchColumnException(String.valueOf(columnIndex));
        }
        return col.getTimestamp();
    }

    public Timestamp getTimestamp(String columnName)
        throws NoSuchColumnException, UnsupportedConversionException {
        return getTimestamp(getIndex(columnName));
    }

    /**
     * Returns the index of the column with the specified name,
     * ignoring case since column names must be unique anyway
     * and some databases ignores the case used in the SELECT
     * statement when they create the ResultSet.
     */
    private int getIndex(String columnName)
        throws NoSuchColumnException {
        for (int i = 0; i < columns.length; i++) {
            Column col = columns[i];
            if (col.getName().equalsIgnoreCase(columnName)) {
                // Adjust to 1 based indexed
                return i + 1;
            }
        }
        throw new NoSuchColumnException(columnName);
    }
}
