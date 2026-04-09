package com.docviewer.db_access;

import com.maintenance.common.DateParser;
import com.silkworm.jsptags.DropdownDate;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;
import java.sql.*;
import java.io.File;
import java.io.*;
import java.math.BigDecimal;
import com.docviewer.business_objects.Document;
import com.silkworm.common.*;
import com.silkworm.db_access.FileMgr;
import org.apache.log4j.xml.DOMConfigurator;

public class InstMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    BookmarkMgr bookmarkMgr = BookmarkMgr.getInstance();
    private static InstMgr instMgr = new InstMgr();
    private static AccountItemMgr accntItemMgr = AccountItemMgr.getInstance();
    private FileMgr fileMgr = FileMgr.getInstance();
    private WebBusinessObject fileDescriptor = null;
    private static DocImgMgr diMgr = DocImgMgr.getInstance();
//    private static final String insertImageSQL = "INSERT INTO instructions values(?,?,?,?,?,?,?,?,?,?,?,now())";
//    private static final String updateImageSQL = "UPDATE instructions SET INST_TITLE = ?, DESCRIPTION = ?, INST_DATE = ?, CONFIG_ITEM_TYPE = ? WHERE INST_ID = ?";
//    private static final String getImageSQL = "SELECT IMAGE FROM instructions WHERE INST_ID = ?";
    private QueryMgr queryMgr = null;
    private String query = null;
    WebBusinessObject viewOrigin = null;

    public static InstMgr getInstance() {
        logger.info("Getting InstMgr Instance ....");
        return instMgr;
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
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("instructions.xml")));
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
            ps = connection.prepareStatement(sqlMgr.getSql("getInstSQL").trim());
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

    public Vector getDocsList(String filter, String filterValue) {

        Document doc = null;
        viewOrigin = new WebBusinessObject();
        Connection connection = null;

        query = queryMgr.getQuery(filter);

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            doc = (Document) fabricateBusObj(r);

            viewOrigin.setAttribute("filter", filter);
            viewOrigin.setAttribute("filterValue", "ListAll");
            doc.setViewOrigin(viewOrigin);

            resultBusObjs.add(doc);
        }

        return resultBusObjs;
    }

    public Vector getListOnLIKE(String forOperation, String keyValue) {

        Connection connection = null;
        Document doc = null;

        String query = new String(sqlMgr.getSql("selectInstListOnLike").trim()); //queryMgr.getQuery(forOperation,keyValue);
        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(keyValue));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("database error from getListOnSecondKey: ImageMgr " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();

            doc = (Document) fabricateBusObj(r);

            viewOrigin = new WebBusinessObject();
            viewOrigin.setAttribute("filter", forOperation);
            viewOrigin.setAttribute("filterValue", keyValue);
            doc.setViewOrigin(viewOrigin);

            reultBusObjs.add(doc);
        }

        return reultBusObjs;

    }

    public boolean saveDocument(HttpServletRequest request, HttpSession session, String filePath) {
        DropdownDate dropdownDate = new DropdownDate();

        File myfile = new File(filePath);
        theRequest = request;
        File dispose = null;
        WebBusinessObject waUser = (WebBusinessObject) session.getAttribute("loggedUser");

        String docBusinessType = (String) request.getParameter("docType");
        String docTitle = (String) request.getParameter("docTitle");
        String issueid = (String) request.getParameter("unitScheduleID");
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
        params.addElement(new StringValue(issueid));
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
            forInsert.setSQLQuery(sqlMgr.getSql("insertInstSQL").trim());
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
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    public boolean updateDocument(HttpServletRequest request, HttpSession session) {
        DropdownDate dropdownDate = new DropdownDate();

        theRequest = request;
        String description = (String) request.getParameter("description");
//        java.sql.Timestamp instDate = dropdownDate.getDate(request.getParameter("instDate"));
        
        DateParser dateParser=new DateParser();
        java.sql.Date sqlDate=dateParser.formatSqlDate(request.getParameter("instDate"));
        java.sql.Timestamp instDate=new java.sql.Timestamp(sqlDate.getTime());
        
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        String instTitle = (String) request.getParameter("instTitle");
        params.addElement(new StringValue(instTitle));
        params.addElement(new StringValue((String) request.getParameter("description")));
        params.addElement(new TimestampValue(instDate));
        params.addElement(new StringValue(request.getParameter("configType")));
        params.addElement(new StringValue((String) request.getParameter("instID")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateInstSQL").trim());
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

        String query = new String(sqlMgr.getSql("getInstOnSingleKey").trim());

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
        String date = (String) doc.getAttribute("instDate");
        String formatedDate = date.substring(0, 10);
        doc.setAttribute("docDate", formatedDate);
        return (WebBusinessObject) doc;
    }

    public Vector getOnArbitraryKey(String keyValue, String keyIndex) throws SQLException, Exception {

        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;

        String theQuery = query.toString();


        if (supportedForm == null) {
            initSupportedForm();
        }

        SQLparams.add(new StringValue(keyValue));

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

        } finally {
            connection.close();
        }
        Vector resultBusObjs = new Vector();
        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            resultBusObjs.add(fabricateBusObj(r));
        }
        return resultBusObjs;
    }

    public boolean hasDocuments(String unitScheduleID) throws Exception {
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery("Select INST_ID,INST_TITLE,UNIT_SCHEDULE_ID,DESCRIPTION,INST_DATE,CREATED_BY,CREATED_BY_NAME,DOC_TYPE,CREATION_TIME from instructions where UNIT_SCHEDULE_ID = " + unitScheduleID);


            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("database error from getListOnSecondKey: ImageMgr " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }

        return queryResult.size() > 0;
    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
}
