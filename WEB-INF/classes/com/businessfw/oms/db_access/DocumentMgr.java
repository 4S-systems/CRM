package com.businessfw.oms.db_access;

import com.docviewer.business_objects.Document;
import com.maintenance.common.DateParser;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.business_objects.*;
import com.silkworm.common.UserMgr;
import com.silkworm.db_access.FileMgr;
import com.silkworm.persistence.relational.*;
import com.silkworm.servlets.MultipartRequest;
import com.silkworm.uploader.FileMeta;
import java.io.File;
import java.io.InputStream;
import java.sql.*;
import java.util.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class DocumentMgr extends RDBGateWay
{

    private static final DocumentMgr documentMgr = new DocumentMgr();
    private final FileMgr fileMgr = FileMgr.getInstance();
    private WebBusinessObject fileDescriptor = null;

    public static DocumentMgr getInstance()
    {
        logger.info("Getting documentMgr Instance ....");
        return documentMgr;
    }

    @Override
    public java.util.ArrayList getCashedTableAsArrayList()
    {
        return null;
    }

    @Override
    protected void initSupportedForm()
    {
        if (webInfPath != null)
        {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null)
        {
            try
            {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("document_table.xml")));
            }
            catch (Exception e)
            {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws java.sql.SQLException
    {
        return false;
    }

    public boolean saveDocument(String documentTitle, String businessObjectId, String objectType, String description, Timestamp documentDate, String metaType, String documentType, String createdById, String createdByName, String configType, File file)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector documentParameters = new Vector();
        Vector documentDataParameters = new Vector();
        int result;
        String documentId = UniqueIDGen.getNextID();

        // setup document info.
        documentParameters.addElement(new StringValue(documentId));
        documentParameters.addElement(new StringValue(documentTitle));
        documentParameters.addElement(new StringValue(businessObjectId));
        documentParameters.addElement(new StringValue(objectType));
        documentParameters.addElement(new StringValue(description));
        documentParameters.addElement(new TimestampValue(documentDate));
        documentParameters.addElement(new StringValue(createdById));
        documentParameters.addElement(new StringValue(createdByName));
        documentParameters.addElement(new StringValue(metaType));
        documentParameters.addElement(new StringValue(documentType));
        documentParameters.addElement(new StringValue(configType));
        documentParameters.addElement(new StringValue(""));
        documentParameters.addElement(new StringValue(""));
        documentParameters.addElement(new StringValue(""));

        // setup document data info.
        documentDataParameters.addElement(new StringValue(documentId));
        documentDataParameters.addElement(new ImageValue(file));

        try
        {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            command.setConnection(connection);
            command.setSQLQuery(getQuery("insertDocument").trim());
            command.setparams(documentParameters);
            result = command.executeUpdate();
            if (result < 0)
            {
                connection.rollback();
                return false;
            }
            try
            {
                Thread.sleep(200);
            }
            catch (InterruptedException ex)
            {
                logger.error(ex.getMessage());
            }

            command.setSQLQuery(getQuery("insertDocumentData").trim());
            command.setparams(documentDataParameters);
            result = command.executeUpdate();
            if (result < 0)
            {
                connection.rollback();
                return false;
            }
            try
            {
                Thread.sleep(200);
            }
            catch (InterruptedException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        catch (SQLException ex)
        {
            logger.error(ex.getMessage());
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.commit();
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return true;
    }

    public boolean saveClientComplaintDocument(String documentTitle, String clientComplaintId, String description, Timestamp documentDate, String metaType, String documentType, String createdById, String createdByName, String configType, File file)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector documentParameters = new Vector();
        Vector documentDataParameters = new Vector();
        int result;
        String documentId = UniqueIDGen.getNextID();

        // setup document info.
        documentParameters.addElement(new StringValue(documentId));
        documentParameters.addElement(new StringValue(documentTitle));
        documentParameters.addElement(new StringValue(clientComplaintId));
        documentParameters.addElement(new StringValue("client_complaint"));
        documentParameters.addElement(new StringValue(description));
        documentParameters.addElement(new TimestampValue(documentDate));
        documentParameters.addElement(new StringValue(createdById));
        documentParameters.addElement(new StringValue(createdByName));
        documentParameters.addElement(new StringValue(metaType));
        documentParameters.addElement(new StringValue(documentType));
        documentParameters.addElement(new StringValue(configType));
        documentParameters.addElement(new StringValue(""));
        documentParameters.addElement(new StringValue(""));
        documentParameters.addElement(new StringValue(""));

        // setup document data info.
        documentDataParameters.addElement(new StringValue(documentId));
        documentDataParameters.addElement(new ImageValue(file));

        try
        {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            command.setConnection(connection);
            command.setSQLQuery(getQuery("insertDocument").trim());
            command.setparams(documentParameters);
            result = command.executeUpdate();
            if (result < 0)
            {
                connection.rollback();
                return false;
            }
            try
            {
                Thread.sleep(200);
            }
            catch (InterruptedException ex)
            {
                logger.error(ex.getMessage());
            }

            command.setSQLQuery(getQuery("insertDocumentData").trim());
            command.setparams(documentDataParameters);
            result = command.executeUpdate();
            if (result < 0)
            {
                connection.rollback();
                return false;
            }
            try
            {
                Thread.sleep(200);
            }
            catch (InterruptedException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        catch (SQLException ex)
        {
            logger.error(ex.getMessage());
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.commit();
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return true;
    }

    public InputStream getImage(String documentId)
    {
        PreparedStatement prepared;
        Connection connection = null;
        try
        {
            connection = dataSource.getConnection();
            prepared = connection.prepareStatement(getQuery("getDocumentImage").trim());
            prepared.setString(1, documentId);

            ResultSet rs = prepared.executeQuery();
            rs.next();
            return rs.getBinaryStream("image");
        }
        catch (SQLException se)
        {
            logger.error(se.getMessage());
            return null;
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error("Close Error");
                return null;
            }
        }
    }

    public boolean saveDocumentByTree(MultipartRequest request, HttpSession s) throws NoUserInSessionException, SQLException
    {
        String documentId = UniqueIDGen.getNextID();

        DateParser dateParser = new DateParser();
        java.sql.Date sqlDate = dateParser.formatSqlDate(request.getParameter("documentDate"));
        java.sql.Timestamp documentDate = new java.sql.Timestamp(sqlDate.getTime());

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        String documentBusinessType = (String) request.getParameter("documentType");
        String documentTitle = (String) request.getParameter("documentTitle");
        String equipmentId = (String) request.getParameter("issueId");
        String description = (String) request.getParameter("description");
        String documentType = (String) request.getParameter("fileExtension");
        String type = (String) request.getParameter("type");
        fileDescriptor = fileMgr.getObjectFromCash(documentType);
        String metaType = (String) fileDescriptor.getAttribute("metaType");

        Vector documentParameters = new Vector();
        Vector documentDataParameters = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        if (request.getFile("file1") != null)
        {
            documentParameters.addElement(new StringValue(documentId));
            documentParameters.addElement(new StringValue(documentTitle));
            documentParameters.addElement(new StringValue(equipmentId));
            documentParameters.addElement(new StringValue(description));
            documentParameters.addElement(new TimestampValue(documentDate));
            documentParameters.addElement(new StringValue(waUser.getAttribute("userId").toString()));
            documentParameters.addElement(new StringValue(waUser.getAttribute("userName").toString()));
            documentParameters.addElement(new StringValue(metaType));
            documentParameters.addElement(new StringValue(documentBusinessType));
            documentParameters.addElement(new StringValue(request.getParameter("configType")));
            documentParameters.addElement(new StringValue(type));

            documentDataParameters.addElement(new StringValue(documentId));
            documentDataParameters.addElement(new ImageValue(request.getFile("file1")));
        }

        Connection connection = null;
        try
        {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);

            if (request.getFile("file1") != null)
            {
                forInsert.setSQLQuery(getQuery("insertDocument").trim());
                forInsert.setparams(documentParameters);
                queryResult = forInsert.executeUpdate();
                if (queryResult < 0)
                {
                    connection.rollback();
                    return false;
                }
                forInsert.setSQLQuery(getQuery("insertDocumentData").trim());
                forInsert.setparams(documentDataParameters);
                queryResult = forInsert.executeUpdate();
                if (queryResult < 0)
                {
                    connection.rollback();
                    return false;
                }
            }

        }
        catch (SQLException se)
        {
            if (connection != null)
            {
                connection.rollback();
            }
            logger.error(se.getMessage());
            return false;
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.commit();
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error("Close Error");
                return false;
            }
        }
        return (queryResult > 0);
    }

    public boolean saveMultiDocument(MultipartRequest request, HttpSession session) throws NoUserInSessionException, SQLException
    {
        WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        String clientComplaintId = request.getParameter("compId");

        Connection connection = null;
        try
        {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);
            Enumeration files;
            files = request.getFileNames();
            while (files.hasMoreElements())
            {

                String documentId = UniqueIDGen.getNextID();
                String file = (String) files.nextElement();
                File f = request.getFile(file);
                String fileName = f.getName();
                String documentTitle = fileName.substring(0, fileName.indexOf("."));
                String documentExtension = fileName.substring(fileName.indexOf(".") + 1, fileName.length());
                fileDescriptor = fileMgr.getObjectFromCash(documentExtension);
                String metaType = (String) fileDescriptor.getAttribute("metaType");

                Vector documentParameters = new Vector();
                Vector documentDataParameters = new Vector();
                documentParameters.addElement(new StringValue(documentId));
                documentParameters.addElement(new StringValue(documentTitle));
                documentParameters.addElement(new StringValue(clientComplaintId));
                documentParameters.addElement(new StringValue("UL"));
                documentParameters.addElement(new StringValue("UL"));
                documentParameters.addElement(new TimestampValue(new Timestamp(Calendar.getInstance().getTimeInMillis())));
                documentParameters.addElement(new StringValue(user.getAttribute("userId").toString()));
                documentParameters.addElement(new StringValue(user.getAttribute("userName").toString()));
                documentParameters.addElement(new StringValue(metaType));
                documentParameters.addElement(new StringValue(documentExtension));
                documentParameters.addElement(new StringValue("1"));
                documentParameters.addElement(new StringValue("UL"));
                documentParameters.addElement(new StringValue("UL"));
                documentParameters.addElement(new StringValue("UL"));

                forInsert.setSQLQuery(getQuery("insertDocument").trim());
                forInsert.setparams(documentParameters);
                queryResult = forInsert.executeUpdate();
                if (queryResult < 0)
                {
                    connection.rollback();
                    return false;
                }

                documentDataParameters.addElement(new StringValue(documentId));
                documentDataParameters.addElement(new ImageValue(new File(f.getPath())));

                forInsert.setSQLQuery(getQuery("insertDocumentData").trim());
                forInsert.setparams(documentDataParameters);
                queryResult = forInsert.executeUpdate();
                if (queryResult < 0)
                {
                    connection.rollback();
                    return false;
                }
            }
        }
        catch (SQLException se)
        {
            if (connection != null)
            {
                connection.rollback();
            }
            logger.error(se.getMessage());
            return false;
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.commit();
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    public boolean saveDocuments(List<FileMeta> files, String businessObjectId, String objectType, String createdBy)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        int queryResult = -1000;

        Vector documentParameters;
        Vector documentDataParameters;
        String fileName;
        String documentTitle;
        String documentExtension;
        String metaType;
        try
        {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            command.setConnection(connection);

            String createdByName = UserMgr.getInstance().getFullName(createdBy);
            for (FileMeta file : files)
            {
                String documentId = UniqueIDGen.getNextID();
                fileName = file.getFileName();
                documentTitle = fileName.substring(0, fileName.indexOf("."));
                documentExtension = fileName.substring(fileName.indexOf(".") + 1, fileName.length());
                metaType = file.getFileType();

                documentParameters = new Vector();
                documentDataParameters = new Vector();
                documentParameters.addElement(new StringValue(documentId));
                documentParameters.addElement(new StringValue(documentTitle));
                documentParameters.addElement(new StringValue(businessObjectId));
                documentParameters.addElement(new StringValue(objectType));
                documentParameters.addElement(new StringValue("UL"));
                documentParameters.addElement(new TimestampValue(new Timestamp(Calendar.getInstance().getTimeInMillis())));
                documentParameters.addElement(new StringValue(createdBy));
                documentParameters.addElement(new StringValue(createdByName));
                documentParameters.addElement(new StringValue(metaType));
                documentParameters.addElement(new StringValue(documentExtension));
                documentParameters.addElement(new StringValue("1"));
                documentParameters.addElement(new StringValue("UL"));
                documentParameters.addElement(new StringValue("UL"));
                documentParameters.addElement(new StringValue("UL"));

                command.setSQLQuery(getQuery("insertDocument").trim());
                command.setparams(documentParameters);
                queryResult = command.executeUpdate();
                if (queryResult < 0)
                {
                    connection.rollback();
                    return false;
                }

                documentDataParameters.addElement(new StringValue(documentId));
                documentDataParameters.addElement(new ImageValue(file.getContent(), file.getFileSize()));

                command.setSQLQuery(getQuery("insertDocumentData").trim());
                command.setparams(documentDataParameters);
                queryResult = command.executeUpdate();
                if (queryResult < 0)
                {
                    connection.rollback();
                    return false;
                }
            }
        }
        catch (SQLException se)
        {
            try
            {
                if (connection != null)
                {
                    connection.rollback();
                }
            }
            catch (SQLException ex)
            {
                logger.error("Close Error");
            }
            logger.error(se.getMessage());
            return false;
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.commit();
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    public String getDocument(String objectId, String objectType) throws NoSuchColumnException
    {
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        params.addElement(new StringValue(objectId));
        params.addElement(new StringValue(objectType));
        Connection connection = null;
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getDocumentByObject").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        }
        catch (UnsupportedTypeException se)
        {
            logger.error(se.getMessage());
        }
        catch (SQLException se)
        {
            logger.error(se.getMessage());
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error("Close Error");
            }
        }

        String id = null;
        Row row;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements())
        {
            row = (Row) e.nextElement();
            id = row.getString("DOCUMENT_ID");
            break;
        }
        return id;
    }

    @Override
    protected void initSupportedQueries()
    {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    @Override
    public WebBusinessObject fabricateBusObj(Row r)
    {
        ListIterator li = supportedForm.getFormElemnts().listIterator();
        FormElement formElement;
        Hashtable ht = new Hashtable();
        String colName;

        while (li.hasNext())
        {

            try
            {
                formElement = (FormElement) li.next();
                colName = (String) formElement.getAttribute("column");
                if (r.getString(colName) != null)
                {
                    ht.put(formElement.getAttribute("name"), r.getString(colName));
                }
            }
            catch (NoSuchColumnException e)
            {
            }

        }

        Document document = new Document(ht);

        String date = (String) document.getAttribute("documentDate");
        String formatedDate = date.substring(0, 10);
        document.setAttribute("docDate", formatedDate);
        return (WebBusinessObject) document;
    }

    public List<WebBusinessObject> getImagesList(String businessObjectId, String objectType)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result;

        parameters.addElement(new StringValue(businessObjectId));
        parameters.addElement(new StringValue(objectType));

        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(getQuery("getImageMetaData").trim());
            result = command.executeQuery();

            List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
            for (Row row : result)
            {
                data.add(fabricateBusObj(row));
            }

            return data;
        }
        catch (SQLException se)
        {
            logger.error("***** " + se.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException sex)
            {
                return null;
            }
        }

        return new ArrayList<WebBusinessObject>();

    }

    public boolean updateDocument(HttpServletRequest request, HttpSession s) throws NoUserInSessionException, SQLException
    {
        String documentId = (String) request.getParameter("docID");
        String documentTitle = (String) request.getParameter("documentTitle");
        String description = (String) request.getParameter("description");

        Vector documentParameters = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        documentParameters.addElement(new StringValue(documentTitle));
        documentParameters.addElement(new StringValue(description));
        documentParameters.addElement(new StringValue(request.getParameter("configType")));
        documentParameters.addElement(new StringValue(documentId));

        Connection connection = null;
        try
        {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("updateDocument").trim());
            forInsert.setparams(documentParameters);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0)
            {
                connection.rollback();
                return false;
            }
        }
        catch (SQLException se)
        {
            logger.error(se.getMessage());
            return false;
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.commit();
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    public List<WebBusinessObject> getAllImagesList(String businessObjectId)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result;
        parameters.addElement(new StringValue(businessObjectId));
        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(getQuery("getAllImageMetaData").trim());
            result = command.executeQuery();
            List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
            for (Row row : result)
            {
                data.add(fabricateBusObj(row));
            }
            return data;
        }
        catch (SQLException se)
        {
            logger.error("***** " + se.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException sex)
            {
                return null;
            }
        }
        return new ArrayList<WebBusinessObject>();
    }

    public List<WebBusinessObject> getAllContractsList(String businessObjectId)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result;
        parameters.addElement(new StringValue(businessObjectId));
        parameters.addElement(new StringValue("contract"));
        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(getQuery("getDocumentByObject").trim());
            result = command.executeQuery();
            List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
            for (Row row : result)
            {
                data.add(fabricateBusObj(row));
            }
            return data;
        }
        catch (SQLException se)
        {
            logger.error("***** " + se.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException sex)
            {
                return null;
            }
        }
        return new ArrayList<WebBusinessObject>();
    }
}
