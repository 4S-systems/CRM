package com.maintenance.db_access;

import com.crm.common.CRMConstants;
import com.crm.db_access.AlertMgr;
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
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class IssueDocumentMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static final IssueDocumentMgr ISSUE_DOCUMENT_MGR = new IssueDocumentMgr();
    private final FileMgr fileMgr = FileMgr.getInstance();
    private WebBusinessObject fileDescriptor = null;
    private String documentID=new String();

    public static IssueDocumentMgr getInstance() {
        logger.info("Getting Issue Document Instance ....");
        return ISSUE_DOCUMENT_MGR;
    }

    @Override
    public java.util.ArrayList getCashedTableAsArrayList() {
        return null;
    }

    public String getDocumentID() {
        return documentID;
    }

    public void setDocumentID(String documentID) {
        this.documentID = documentID;
    }
    
public Vector getOnArbitraryDoubleKeyOracle2(String key1Value, String key1Index, String key2Value, String key2Index) throws SQLException, Exception {

        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;

        StringBuffer dq = new StringBuffer("SELECT * FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ");
        dq.append(supportedForm.getTableSupported().getAttribute(key1Index));
        if (key1Value == null) {
            dq.append(" is null ");
        } else {
            dq.append(" = ? ");
        }
        dq.append("AND ");
        dq.append(supportedForm.getTableSupported().getAttribute(key2Index));
        if (key2Value == null) {
            dq.append(" is null ");
        } else {
            dq.append(" = ? ");
        }
        dq.append("ORDER BY DOCUMENT_DATE");
        String theQuery = dq.toString();

        if (supportedForm == null) {

            initSupportedForm();
        }
        logger.info("the query " + theQuery);

        // finally do the query
        if (key1Value != null) {
            SQLparams.add(new StringValue(key1Value));
        }

        if (key2Value != null) {
            SQLparams.add(new StringValue(key2Value));
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }

        return reultBusObjs;

    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("issue_document.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws java.sql.SQLException {
        return false;
    }
    
    public boolean saveDocument(String documentTitle, String businessObjectId, String objectType, String description, Timestamp documentDate, String metaType, String documentType, String createdById, String createdByName, String configType, FileMeta file) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector issueDocumentParameters = new Vector();
        Vector issueDocumentDataParameters = new Vector();
        int result;

        String documentId = UniqueIDGen.getNextID();

        // setup document info.
        issueDocumentParameters.addElement(new StringValue(documentId));
        issueDocumentParameters.addElement(new StringValue(documentTitle));
        issueDocumentParameters.addElement(new StringValue(businessObjectId));
        issueDocumentParameters.addElement(new StringValue(objectType));
        issueDocumentParameters.addElement(new StringValue(description));
        issueDocumentParameters.addElement(new TimestampValue(documentDate));
        issueDocumentParameters.addElement(new StringValue(createdById));
        issueDocumentParameters.addElement(new StringValue(createdByName));
        issueDocumentParameters.addElement(new StringValue(metaType));
        issueDocumentParameters.addElement(new StringValue(documentType));
        issueDocumentParameters.addElement(new StringValue(configType));
        issueDocumentParameters.addElement(new StringValue(""));
        issueDocumentParameters.addElement(new StringValue(""));
        issueDocumentParameters.addElement(new StringValue(""));

        // setup document data info.
        issueDocumentDataParameters.addElement(new StringValue(documentId));
        issueDocumentDataParameters.addElement(new ImageValue(file.getContent(), file.getFileSize()));

        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            command.setConnection(connection);
            command.setSQLQuery(sqlMgr.getSql("insertIssueDocument").trim());
            command.setparams(issueDocumentParameters);
            result = command.executeUpdate();
            if (result < 0) {
                connection.rollback();
                return false;
            }
            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }

            // add alert type from attach file
            boolean saved = AlertMgr.getInstance().saveObject(businessObjectId, CRMConstants.ALERT_TYPE_ID_ATTACH_FILE, createdById, connection);
            if (!saved) {
                connection.rollback();
                return false;
            }
            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }

            command.setSQLQuery(sqlMgr.getSql("insertIssueDocumentData").trim());
            command.setparams(issueDocumentDataParameters);
            result = command.executeUpdate();
            if (result < 0) {
                connection.rollback();
                return false;
            }
            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        return true;
    }

    public boolean saveClientComplaintDocument(String documentTitle, String clientComplaintId, String description, Timestamp documentDate, String metaType, String documentType, String createdById, String createdByName, String configType, File file) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector issueDocumentParameters = new Vector();
        Vector issueDocumentDataParameters = new Vector();
        int result;

        String documentId = UniqueIDGen.getNextID();

        // setup document info.
        issueDocumentParameters.addElement(new StringValue(documentId));
        issueDocumentParameters.addElement(new StringValue(documentTitle));
        issueDocumentParameters.addElement(new StringValue(clientComplaintId));
        issueDocumentParameters.addElement(new StringValue("client_complaint"));
        issueDocumentParameters.addElement(new StringValue(description));
        issueDocumentParameters.addElement(new TimestampValue(documentDate));
        issueDocumentParameters.addElement(new StringValue(createdById));
        issueDocumentParameters.addElement(new StringValue(createdByName));
        issueDocumentParameters.addElement(new StringValue(metaType));
        issueDocumentParameters.addElement(new StringValue(documentType));
        issueDocumentParameters.addElement(new StringValue(configType));
        issueDocumentParameters.addElement(new StringValue(""));
        issueDocumentParameters.addElement(new StringValue(""));
        issueDocumentParameters.addElement(new StringValue(""));

        // setup document data info.
        issueDocumentDataParameters.addElement(new StringValue(documentId));
        issueDocumentDataParameters.addElement(new ImageValue(file));

        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            command.setConnection(connection);
            command.setSQLQuery(sqlMgr.getSql("insertIssueDocument").trim());
            command.setparams(issueDocumentParameters);
            result = command.executeUpdate();
            if (result < 0) {
                connection.rollback();
                return false;
            }
            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }

            // add alert type from attach file
            boolean saved = AlertMgr.getInstance().saveObject(clientComplaintId, CRMConstants.ALERT_TYPE_ID_ATTACH_FILE, createdById, connection);
            if (!saved) {
                connection.rollback();
                return false;
            }
            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }

            command.setSQLQuery(sqlMgr.getSql("insertIssueDocumentData").trim());
            command.setparams(issueDocumentDataParameters);
            result = command.executeUpdate();
            if (result < 0) {
                connection.rollback();
                return false;
            }
            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        return true;
    }

    public InputStream getImage(String documentId) {
        PreparedStatement prepared;
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            prepared = connection.prepareStatement(sqlMgr.getSql("getIssueDocumentImage").trim());
            prepared.setString(1, documentId);

            ResultSet rs = prepared.executeQuery();
            rs.next();
            return rs.getBinaryStream("image");

        } catch (SQLException se) {
            logger.error(se.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return null;
            }
        }
    }

    public boolean saveDocumentByTree(MultipartRequest request, HttpSession s) throws NoUserInSessionException, SQLException {
        String documentId = UniqueIDGen.getNextID();

        DateParser dateParser = new DateParser();
        java.sql.Date sqlDate = dateParser.formatSqlDate(request.getParameter("documentDate"));
        java.sql.Timestamp documentDate = new java.sql.Timestamp(sqlDate.getTime());

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        String documentBusinessType = (String) request.getParameter("documentType");
        String documentTitle = (String) request.getParameter("documentTitle");
        String issueId = (String) request.getParameter("issueId");
        String description = (String) request.getParameter("description");
        String documentType = (String) request.getParameter("fileExtension");
        String type = (String) request.getParameter("type");
        fileDescriptor = fileMgr.getObjectFromCash(documentType);
        String metaType = (String) fileDescriptor.getAttribute("metaType");

        Vector issueDocumentParameters = new Vector();
        Vector issueDocumentDataParameters = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        if (request.getFile("file1") != null) {
            issueDocumentParameters.addElement(new StringValue(documentId));
            issueDocumentParameters.addElement(new StringValue(documentTitle));
            issueDocumentParameters.addElement(new StringValue(issueId));
            issueDocumentParameters.addElement(new StringValue(description));
            issueDocumentParameters.addElement(new TimestampValue(documentDate));
            issueDocumentParameters.addElement(new StringValue(waUser.getAttribute("userId").toString()));
            issueDocumentParameters.addElement(new StringValue(waUser.getAttribute("userName").toString()));
            issueDocumentParameters.addElement(new StringValue(metaType));
            issueDocumentParameters.addElement(new StringValue(documentBusinessType));
            issueDocumentParameters.addElement(new StringValue(request.getParameter("configType")));
            issueDocumentParameters.addElement(new StringValue(type));

            issueDocumentDataParameters.addElement(new StringValue(documentId));
            issueDocumentDataParameters.addElement(new ImageValue(request.getFile("file1")));
        }

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);

            if (request.getFile("file1") != null) {
                forInsert.setSQLQuery(sqlMgr.getSql("insertIssueDocument").trim());
                forInsert.setparams(issueDocumentParameters);
                queryResult = forInsert.executeUpdate();
                if (queryResult < 0) {
                    connection.rollback();
                    return false;
                }

                forInsert.setSQLQuery(sqlMgr.getSql("insertIssueDocumentData").trim());
                forInsert.setparams(issueDocumentDataParameters);
                queryResult = forInsert.executeUpdate();
                if (queryResult < 0) {
                    connection.rollback();
                    return false;
                }
            }

        } catch (SQLException se) {
            connection.rollback();
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    public boolean saveMultiDocument(MultipartRequest request, HttpSession session) throws NoUserInSessionException, SQLException {
        WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        boolean saved;
        String clientComplaintId = request.getParameter("compId");

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);
            Enumeration files;
            files = request.getFileNames();
            while (files.hasMoreElements()) {

                String documentId = UniqueIDGen.getNextID();
                String file = (String) files.nextElement();
                File f = request.getFile(file);
                String fileName = f.getName();
                String documentTitle = fileName.substring(0, fileName.indexOf("."));
                String documentExtension = fileName.substring(fileName.indexOf(".") + 1, fileName.length());
                fileDescriptor = fileMgr.getObjectFromCash(documentExtension);
                String metaType = (String) fileDescriptor.getAttribute("metaType");

                Vector issueDocumentParameters = new Vector();
                Vector issueDocumentDataParameters = new Vector();
                issueDocumentParameters.addElement(new StringValue(documentId));
                issueDocumentParameters.addElement(new StringValue(documentTitle));
                issueDocumentParameters.addElement(new StringValue(clientComplaintId));
                issueDocumentParameters.addElement(new StringValue("UL"));
                issueDocumentParameters.addElement(new StringValue("UL"));
                issueDocumentParameters.addElement(new TimestampValue(new Timestamp(Calendar.getInstance().getTimeInMillis())));
                issueDocumentParameters.addElement(new StringValue(user.getAttribute("userId").toString()));
                issueDocumentParameters.addElement(new StringValue(user.getAttribute("userName").toString()));
                issueDocumentParameters.addElement(new StringValue(metaType));
                issueDocumentParameters.addElement(new StringValue(documentExtension));
                issueDocumentParameters.addElement(new StringValue("1"));
                issueDocumentParameters.addElement(new StringValue("UL"));
                issueDocumentParameters.addElement(new StringValue("UL"));
                issueDocumentParameters.addElement(new StringValue("UL"));

                forInsert.setSQLQuery(sqlMgr.getSql("insertIssueDocument").trim());
                forInsert.setparams(issueDocumentParameters);
                queryResult = forInsert.executeUpdate();
                if (queryResult < 0) {
                    connection.rollback();
                    return false;
                }

                issueDocumentDataParameters.addElement(new StringValue(documentId));
                issueDocumentDataParameters.addElement(new ImageValue(new File(f.getPath())));

                forInsert.setSQLQuery(sqlMgr.getSql("insertIssueDocumentData").trim());
                forInsert.setparams(issueDocumentDataParameters);
                queryResult = forInsert.executeUpdate();
                if (queryResult < 0) {
                    connection.rollback();
                    return false;
                }

                // add alert type from attach file
                saved = AlertMgr.getInstance().saveObject(clientComplaintId, CRMConstants.ALERT_TYPE_ID_ATTACH_FILE, user.getAttribute("userId").toString(), connection);
                if (!saved) {
                    connection.rollback();
                    return false;
                }
                try {
                    Thread.sleep(200);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }
            }
        } catch (Exception se) {
            connection.rollback();
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    public boolean saveDocuments(List<FileMeta> files, String businessObjectId, String objectType, String createdBy, String docTypeID) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        int queryResult = -1000;

        Vector issueDocumentParameters;
        Vector issueDocumentDataParameters;
        String fileName;
        String documentTitle;
        String documentExtension;
        String metaType;

        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            command.setConnection(connection);

            String createdByName = UserMgr.getInstance().getFullName(createdBy);
            for (FileMeta file : files) {
                String documentId = UniqueIDGen.getNextID();
                fileName = file.getFileName();
                documentTitle = fileName.substring(0, fileName.indexOf("."));
                documentExtension = fileName.substring(fileName.indexOf(".") + 1, fileName.length());
                metaType = file.getFileType();
                this.setDocumentID(documentId);

                issueDocumentParameters = new Vector();
                issueDocumentDataParameters = new Vector();
                issueDocumentParameters.addElement(new StringValue(documentId));
                issueDocumentParameters.addElement(new StringValue(documentTitle));
                issueDocumentParameters.addElement(new StringValue(businessObjectId));
                issueDocumentParameters.addElement(new StringValue(objectType));
                issueDocumentParameters.addElement(new StringValue("UL"));
                issueDocumentParameters.addElement(new TimestampValue(new Timestamp(Calendar.getInstance().getTimeInMillis())));
                issueDocumentParameters.addElement(new StringValue(createdBy));
                issueDocumentParameters.addElement(new StringValue(createdByName));
                issueDocumentParameters.addElement(new StringValue(metaType));
                issueDocumentParameters.addElement(new StringValue(documentExtension));
                issueDocumentParameters.addElement(new StringValue(docTypeID != null && !docTypeID.isEmpty() ? docTypeID : "1"));
                issueDocumentParameters.addElement(new StringValue("UL"));
                issueDocumentParameters.addElement(new StringValue("UL"));
                issueDocumentParameters.addElement(new StringValue("UL"));

                command.setSQLQuery(sqlMgr.getSql("insertIssueDocument").trim());
                command.setparams(issueDocumentParameters);
                queryResult = command.executeUpdate();
                if (queryResult < 0) {
                    connection.rollback();
                    return false;
                }

                issueDocumentDataParameters.addElement(new StringValue(documentId));
                issueDocumentDataParameters.addElement(new ImageValue(file.getContent(), file.getFileSize()));

                command.setSQLQuery(sqlMgr.getSql("insertIssueDocumentData").trim());
                command.setparams(issueDocumentDataParameters);
                queryResult = command.executeUpdate();
                if (queryResult < 0) {
                    connection.rollback();
                    return false;
                }
            }
        } catch (SQLException se) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    public String getDocument(String objectId, String objectType) throws NoSuchColumnException {
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        params.addElement(new StringValue(objectId));
        params.addElement(new StringValue(objectType));
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getIssueDocumentByObject").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (Exception se) {
            logger.error(se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        String id = null;
        Row row = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            id = row.getString("DOCUMENT_ID");
            break;
        }
        return id;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    @Override
    public WebBusinessObject fabricateBusObj(Row r) {
        ListIterator li = supportedForm.getFormElemnts().listIterator();
        FormElement formElement;
        Hashtable ht = new Hashtable();
        String colName;

        while (li.hasNext()) {

            try {
                formElement = (FormElement) li.next();
                colName = (String) formElement.getAttribute("column");
                if (r.getString(colName) != null) {
                    ht.put(formElement.getAttribute("name"), r.getString(colName));
                }
            } catch (NoSuchColumnException e) {
            }

        }

        Document document = new Document(ht);

        String date = (String) document.getAttribute("documentDate");
        String formatedDate = date.substring(0, 10);
        document.setAttribute("docDate", formatedDate);
        return (WebBusinessObject) document;
    }

    public Vector getImagesList(String issueId) {
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("selectIssueImages").trim().replaceAll("issueID", "'" + issueId + "'"));
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                return null;
            }
        }
        Vector resultBusObjs = new Vector();
        Document document;
        Row row;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            document = (Document) fabricateBusObj(row);
            resultBusObjs.add(document);
        }

        return resultBusObjs;

    }
    
    public List<WebBusinessObject> getImagesList(String businessObjectId, String objectType) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result = null;
        
        parameters.addElement(new StringValue(businessObjectId));
        parameters.addElement(new StringValue(objectType));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(getQuery("getImageMetaData").trim());
            result = command.executeQuery();
            
            List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
            for (Row row : result) {
                data.add(fabricateBusObj(row));
            }
            
            return data;
        } catch (SQLException se) {
            logger.error("***** " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                return null;
            }
        }

        return new ArrayList<WebBusinessObject>();

    }

    public boolean updateDocument(HttpServletRequest request, HttpSession s) throws NoUserInSessionException, SQLException {
        String documentId = (String) request.getParameter("docID");
        String documentTitle = (String) request.getParameter("documentTitle");
        String description = (String) request.getParameter("description");

        Vector issueDocumentParameters = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        issueDocumentParameters.addElement(new StringValue(documentTitle));
        issueDocumentParameters.addElement(new StringValue(description));
        issueDocumentParameters.addElement(new StringValue(request.getParameter("configType")));
        issueDocumentParameters.addElement(new StringValue(documentId));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("updateIssueDocument").trim());
            forInsert.setparams(issueDocumentParameters);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                connection.rollback();
                return false;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                if (connection != null) {
                    connection.commit();
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }
    
    public List<WebBusinessObject> getAllImagesList(String businessObjectId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result = null;
        parameters.addElement(new StringValue(businessObjectId));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(getQuery("getAllImageMetaData").trim());
            result = command.executeQuery();
            List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
            for (Row row : result) {
                data.add(fabricateBusObj(row));
            }
            return data;
        } catch (SQLException se) {
            logger.error("***** " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                return null;
            }
        }
        return new ArrayList<WebBusinessObject>();
    }
    
    public String getDocumentCountForIssue(String issueID) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result;
        parameters.addElement(new StringValue(issueID));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(getQuery("getDocumentCountForIssue").trim());
            result = command.executeQuery();
            for (Row row : result) {
                if(row.getString("DOCUMENT_NO") != null) {
                    return row.getString("DOCUMENT_NO") + "";
                }
            }
            return "0";
        } catch (SQLException se) {
            logger.error("***** " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (NoSuchColumnException ex) {
            Logger.getLogger(IssueDocumentMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                return null;
            }
        }
        return "0";
    }
    public int deleteIssueDoc(String documentID){
        Connection conn = null;
        int queryRsult = -1000;
        Vector SQLparams = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        SQLparams.addElement(new StringValue(documentID));
         try{   
                
                    beginTransaction();
                    forUpdate.setConnection(transConnection);
                    forUpdate.setparams(SQLparams);
                    String myQuery = getQuery("deleteIssueDoc").trim();
                    forUpdate.setSQLQuery(myQuery);
                    try {
                    queryRsult = forUpdate.executeUpdate();
                    if (queryRsult < 0)
                    {
                        transConnection.rollback();
                        return 0;
                    }
                    
                    }finally
                {
                    endTransaction();
                }
                try {
                beginTransaction();
                forUpdate.setConnection(transConnection);
                forUpdate.setparams(SQLparams);
                 myQuery = getQuery("deleteIssueDocData").trim();
                forUpdate.setSQLQuery(myQuery);

                queryRsult = forUpdate.executeUpdate();
                if (queryRsult < 0)
                {
                    transConnection.rollback();
                    return 0;
                }}finally {
                     endTransaction();
                }
           
    } catch (SQLException ex)
            {
                logger.error("troubles closing connection " + ex.getMessage());
                return 0;
            }
        

        //////////////////////////////////////////////////
        return queryRsult ;
    }
}
