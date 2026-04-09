package com.businessfw.hrs.db_access;

import com.docviewer.business_objects.Document;
import com.maintenance.common.DateParser;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.servlets.MultipartRequest;
import javax.servlet.http.HttpSession;
import java.util.*;
import java.sql.*;
import java.io.File;
import com.docviewer.db_access.QueryMgr;
import com.silkworm.db_access.FileMgr;
import com.silkworm.jsptags.DropdownDate;
import java.io.InputStream;
import java.math.BigDecimal;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.xml.DOMConfigurator;

public class EmployeeDocMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static EmployeeDocMgr employeeDocMgr = new EmployeeDocMgr();
    private FileMgr fileMgr = FileMgr.getInstance();
    private WebBusinessObject fileDescriptor = null;
    private QueryMgr queryMgr = null;

    public static EmployeeDocMgr getInstance() {
        logger.info("Getting EmployeeDocMgr Instance ....");
        return employeeDocMgr;
    }

    public void setQueryMgr(QueryMgr qm) {
        queryMgr = qm;
    }

    public java.util.ArrayList getCashedTableAsArrayList() {
        return null;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("employee_doc.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(com.silkworm.business_objects.WebBusinessObject wbo) throws java.sql.SQLException {
        return false;
    }

    public InputStream getImage(String docId) {

        PreparedStatement ps = null;
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            ps = connection.prepareStatement(sqlMgr.getSql("getEmployeeDocImage").trim());
            ps.setString(1, docId);

            ResultSet rs = ps.executeQuery();
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

    public boolean saveDocument(HttpServletRequest request, HttpSession session, String filePath) {
        DropdownDate dropdownDate = new DropdownDate();

        File myfile = new File(filePath);
        theRequest = request;
        File dispose = null;

        WebBusinessObject waUser = (WebBusinessObject) session.getAttribute("loggedUser");

        String docBusinessType = (String) request.getParameter("docType");
        String docTitle = (String) request.getParameter("docTitle");
        String empID = (String) request.getParameter("empID");
        String description = (String) request.getParameter("description");
        String total = (String) request.getParameter("faceValue");
        String docType = (String) request.getParameter("fileExtension");

        fileDescriptor = fileMgr.getObjectFromCash(docType);

        String metaType = (String) fileDescriptor.getAttribute("metaType");
        BigDecimal totalValue = null;


        if ((docTitle == null) || docTitle.equals("")) {
            docTitle = new String("No Title was provided");
        }

        if ((description == null) || description.equals("")) {
            description = new String("No description was provided");
        }
        try {
            totalValue = new BigDecimal(total);
        } catch (Exception e) {
            totalValue = new BigDecimal(0.0);
        }

//        java.sql.Timestamp docDate = dropdownDate.getDate(request.getParameter("docDate"));//super.extractDateFromRequest();

        DateParser dateParser=new DateParser();
        java.sql.Date sqlDate=dateParser.formatSqlDate(request.getParameter("docDate"));
        java.sql.Timestamp docDate=new java.sql.Timestamp(sqlDate.getTime());
        
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(docTitle));
        params.addElement(new StringValue(empID));
        params.addElement(new StringValue(description));
        params.addElement(new ImageValue(myfile));
        params.addElement(new TimestampValue(docDate));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue((String) waUser.getAttribute("userName")));
        params.addElement(new StringValue(metaType));
        params.addElement(new StringValue(docBusinessType));
        params.addElement(new StringValue(request.getParameter("configType")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertEmployeeDocSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                dispose = new File(filePath);
                dispose.delete();
                connection.close();
            } catch (SQLException ex) {
                return false;
            }
        }
        return (queryResult > 0);
    }

    public boolean saveImageDocument(MultipartRequest request, HttpSession session, String filePath) {
        DropdownDate dropdownDate = new DropdownDate();

        File myfile = new File(filePath);
        File dispose = null;

        WebBusinessObject waUser = (WebBusinessObject) session.getAttribute("loggedUser");

        String docBusinessType = (String) request.getParameter("docType");
        String docTitle = (String) request.getParameter("docTitle");
        String empID = (String) request.getParameter("empID");
        String description = (String) request.getParameter("description");
        String total = (String) request.getParameter("faceValue");
        String docType = (String) request.getParameter("fileExtension");

        fileDescriptor = fileMgr.getObjectFromCash(docType);

        String metaType = (String) fileDescriptor.getAttribute("metaType");
        BigDecimal totalValue = null;


        if ((docTitle == null) || docTitle.equals("")) {
            docTitle = new String("No Title was provided");
        }

        if ((description == null) || description.equals("")) {
            description = new String("No description was provided");
        }
        try {
            totalValue = new BigDecimal(total);
        } catch (Exception e) {
            totalValue = new BigDecimal(0.0);
        }

//        java.sql.Timestamp docDate = dropdownDate.getDate(request.getParameter("docDate"));//super.extractDateFromRequest();

        DateParser dateParser=new DateParser();
        java.sql.Date sqlDate=dateParser.formatSqlDate(request.getParameter("docDate"));
        java.sql.Timestamp docDate=new java.sql.Timestamp(sqlDate.getTime());
        
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(docTitle));
        params.addElement(new StringValue(empID));
        params.addElement(new StringValue(description));
        params.addElement(new ImageValue(myfile));
        params.addElement(new TimestampValue(docDate));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue((String) waUser.getAttribute("userName")));
        params.addElement(new StringValue(metaType));
        params.addElement(new StringValue(docBusinessType));
        params.addElement(new StringValue(request.getParameter("configType")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertEmployeeDocSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                dispose = new File(filePath);
                dispose.delete();
                connection.close();
            } catch (SQLException ex) {
                return false;
            }
        }
        return (queryResult > 0);
    }

    public boolean updateDocument(HttpServletRequest request, HttpSession session) {
        DropdownDate dropdownDate = new DropdownDate();

        theRequest = request;
        String description = (String) request.getParameter("description");
//        java.sql.Timestamp docDate = dropdownDate.getDate(request.getParameter("docDate"));
        
        DateParser dateParser=new DateParser();
        java.sql.Date sqlDate=dateParser.formatSqlDate(request.getParameter("docDate"));
        java.sql.Timestamp docDate=new java.sql.Timestamp(sqlDate.getTime());
        
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        String docTitle = (String) request.getParameter("docTitle");
        params.addElement(new StringValue(docTitle));
        params.addElement(new StringValue((String) request.getParameter("description")));
        params.addElement(new TimestampValue(docDate));
        params.addElement(new StringValue(request.getParameter("configType")));
        params.addElement(new StringValue((String) request.getParameter("docID")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateEmployeeDocImage").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    public WebBusinessObject getOnSingleKey(String key) {

        Connection connection = null;

        String query = new String(sqlMgr.getSql("selectEmployeeDocOnSingleKey").trim());

        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(key));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        Document reultBusObj = null;

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObj = (Document) fabricateBusObj(r);

        }
        return reultBusObj;
    }

    public Vector getListOnLIKE(String forOperation, String keyValue) {

        Connection connection = null;
        Document doc = null;

        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(keyValue));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectEmployeeDocListOnLike").trim());
            forQuery.setparams(SQLparams);

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
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();

            doc = (Document) fabricateBusObj(r);
            reultBusObjs.add(doc);
        }

        return reultBusObjs;

    }

    public WebBusinessObject fabricateBusObj(Row r) {

        ListIterator li = supportedForm.getFormElemnts().listIterator();
        FormElement fe = null;
        Hashtable ht = new Hashtable();
        String colName;
        String state = null;
        String docOwnerId = null;

        while (li.hasNext()) {

            try {
                fe = (FormElement) li.next();
                colName = (String) fe.getAttribute("column");
                // needs a case ......
                ht.put(fe.getAttribute("name"), r.getString(colName));
            } catch (Exception e) {

            }

        }

        Document doc = new Document(ht);

        String date = (String) doc.getAttribute("docDate");
        String formatedDate = date.substring(0, 10);
        doc.setAttribute("docDate", formatedDate);
        return (WebBusinessObject) doc;
    }

    public boolean hasDocuments(String empID) throws Exception {

        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectEmployeeDocHasDocument").trim().replace("$", "'" + empID + "'"));
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {

        } catch (UnsupportedTypeException uste) {
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                return false;
            }
        }

        return queryResult.size() > 0;
    }

    public boolean hasImages(String empID) throws Exception {

        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectEmployeeDocHasImage").trim().replace("$", "'" + empID + "'"));
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {

        } catch (UnsupportedTypeException uste) {
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                return false;
            }
        }

        return queryResult.size() > 0;
    }

    public Vector getImagesList(String empID) {

        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectEmployeeDocHasImage").trim().replace("$", "'" + empID + "'"));
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
        Document doc = null;
        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();

            doc = (Document) fabricateBusObj(r);
            resultBusObjs.add(doc);
        }

        return resultBusObjs;

    }

    @Override
    protected void initSupportedQueries() {
      return; //  throw new UnsupportedOperationException("Not supported yet.");
    }
}
