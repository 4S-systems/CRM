/*F
 * ImageMgr.java
 *
 *
 *
 * Created on March 28, 2004, 6:31 AM
 */
package com.docviewer.db_access;

import com.maintenance.common.DateParser;
import com.silkworm.jsptags.DropdownDate;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import com.silkworm.Exceptions.*;
import java.util.*;
import java.sql.*;
import java.io.File;
import java.io.*;
import java.math.BigDecimal;
import com.docviewer.business_objects.Document;
import com.silkworm.util.*;
import com.silkworm.common.TimeServices;
import com.silkworm.common.BookmarkMgr;
import com.silkworm.db_access.FileMgr;
import com.silkworm.persistence.relational.StringValue;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author  walid
 */
public class ImageMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    /** Creates a new instance of ImageMgr */
    BookmarkMgr bookmarkMgr = BookmarkMgr.getInstance();
    private static ImageMgr imageMgr = new ImageMgr();
    private static AccountItemMgr accntItemMgr = AccountItemMgr.getInstance();
    private FileMgr fileMgr = FileMgr.getInstance();
    private WebBusinessObject fileDescriptor = null;
    private static DocImgMgr diMgr = DocImgMgr.getInstance();
//    private static final String insertImageSQL = "INSERT INTO document values(?,?,?,?,?,?,?,?,?,?,?,now())";
//    private static final String updateImageSQL = "UPDATE document SET DOC_TITLE = ?, DESCRIPTION = ?, DOC_DATE = ?, CONFIG_ITEM_TYPE = ? WHERE DOC_ID = ?";
//    private static final String getImageSQL = "SELECT IMAGE FROM document WHERE DOC_ID = ?";
    //    private static final String docsInRangeSQL = "SELECT DOC_ID,DOC_TITLE,ACCOUNT,ACCNT_ITEM_NAME,DESCRIPTION,TOTAL,DOC_STORAGE,FILE_NAME,SOUND,DOC_DATE,CREATED_BY,CREATED_BY_NAME,GROUP_NAME,DOC_TYPE,CREATION_TIME FROM DOCUMENT WHERE DOC_DATE BETWEEN ? AND ?";
    //    private static final String accountDocsInRangeSQL = "SELECT DOC_ID,DOC_TITLE,ACCOUNT,ACCNT_ITEM_NAME,DESCRIPTION,TOTAL,DOC_STORAGE,FILE_NAME,SOUND,DOC_DATE,CREATED_BY,CREATED_BY_NAME,GROUP_NAME,DOC_TYPE,CREATION_TIME FROM DOCUMENT WHERE (DOC_DATE BETWEEN ? AND ?) AND ACCOUNT = ? ";
    private QueryMgr queryMgr = null;
    private String query = null;
    WebBusinessObject viewOrigin = null;

    public static ImageMgr getInstance() {
        logger.info("Getting ImageMgr Instance ....");
        return imageMgr;
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
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("document.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(com.silkworm.business_objects.WebBusinessObject wbo) throws java.sql.SQLException {
        return false;
    }

    public boolean saveObject(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new ImageValue(new File((String) wbo.getAttribute("filePath"))));
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertImageSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
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

    public InputStream getImage(String docId) {

        PreparedStatement ps = null;
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            ps = connection.prepareStatement(sqlMgr.getSql("getImageSQL").trim());
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

        if (filter.equalsIgnoreCase("ListByAccount")) {
            return this.getListOnSecondKey(filterValue);
        }
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

        // process the vector
        // vector of business objects

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            //  wbo = fabricateBusObj(r);

            doc = (Document) fabricateBusObj(r);

            viewOrigin.setAttribute("filter", filter);
            viewOrigin.setAttribute("filterValue", "ListAll");
            doc.setViewOrigin(viewOrigin);

            reultBusObjs.add(doc);
        }

        return reultBusObjs;
    }

    public boolean saveDocument(HttpServletRequest request, HttpSession session, String filePath) {
        DropdownDate dropdownDate = new DropdownDate();
        if (request.getParameter("docType").equalsIgnoreCase("jpg")) {
            try {
                BufferedImage img = ImageIO.read(new File(filePath));
                int w = img.getWidth();
                int h = img.getHeight();
                BufferedImage bi = new BufferedImage(w, h, BufferedImage.TYPE_INT_ARGB);
                Graphics g = img.getGraphics();

                File outputfile = new File(filePath);
                g.setColor(Color.pink);
                g.fillRect(0, 0, img.getWidth(), 30);
                g.setColor(Color.black);
                g.setFont(new Font("Dialog", Font.BOLD, 24));
                g.drawString("4S Maintenance System", 25, 25);
                ImageIO.write(img, "jpeg", outputfile);
            } catch (IOException e) {
                logger.error("Image could not be read");
                return false;
            }
        }
        File myfile = new File(filePath);
        theRequest = request;
        File dispose = null;

        WebBusinessObject waUser = (WebBusinessObject) session.getAttribute("loggedUser");

        String docBusinessType = (String) request.getParameter("docType");
        String docTitle = (String) request.getParameter("docTitle");
        String issueid = (String) request.getParameter("issueId");
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

        // date
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
            forInsert.setSQLQuery(sqlMgr.getSql("insertImageSQL").trim());
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
    //

    // return false;

    }

    public boolean saveJobOrderDoc(HttpServletRequest request, String filePath) {
        File myfile = new File(filePath);
        File dispose = null;

        WebBusinessObject waUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");

        String issueid = (String) request.getParameter("issueId");

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        Calendar c = Calendar.getInstance();
        Timestamp time = new Timestamp(c.getTimeInMillis());
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue("Job Order"));
        params.addElement(new StringValue(issueid));
        params.addElement(new StringValue("Job Order"));
        params.addElement(new ImageValue(myfile));
        params.addElement(new TimestampValue(time));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue((String) waUser.getAttribute("userName")));
        params.addElement(new StringValue("pdf"));
        params.addElement(new StringValue("pdf"));
        params.addElement(new StringValue("1"));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertImageSQL").trim());
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
//        java.sql.Timestamp docDate = dropdownDate.getDate(request.getParameter("docDate"));//super.extractDateFromRequest();
        
        DateParser dateParser=new DateParser();
        java.sql.Date sqlDate=dateParser.formatSqlDate(request.getParameter("docDate"));
        java.sql.Timestamp docDate=new java.sql.Timestamp(sqlDate.getTime());
        
        //java.sql.Timestamp releaseDate = super.extractFromDateFromRequest();
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        String docTitle = (String) request.getParameter("docTitle");
//        String configItemType = (String) request.getParameter("docType");
//        docTitle = configItemType.concat("-").concat(docTitle);
        //String sptrID =  request.getParameter("separatorID");
        //WebBusinessObject sptr = getOnSingleKey(sptrID);
        params.addElement(new StringValue(docTitle));
        params.addElement(new StringValue((String) request.getParameter("description")));
        params.addElement(new TimestampValue(docDate));
//        params.addElement(new StringValue(configItemType));
        //params.addElement(new StringValue((String)sptr.getAttribute("docTitle")));
        //params.addElement(new StringValue(sptrID));
        //params.addElement(new StringValue((String)request.getParameter("version")));
//        params.addElement(new StringValue((String)request.getParameter("modifiedBy")));
//        params.addElement(new StringValue((String)request.getParameter("reviewedBy")));
//        params.addElement(new StringValue((String)request.getParameter("approvedBy")));
//        params.addElement(new TimestampValue(releaseDate));
        params.addElement(new StringValue(request.getParameter("configType")));
        params.addElement(new StringValue((String) request.getParameter("docID")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateImageSQL").trim());
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

    public boolean saveMovie(HttpServletRequest request, HttpSession session, String filePath) {

        theRequest = request;
        String token = this.webInfPath + "/swlogo.gif";

        WebBusinessObject waUser = (WebBusinessObject) session.getAttribute("loggedUser");

        String docTitle = (String) request.getParameter("docTitle");
        String description = (String) request.getParameter("description");
        String total = (String) request.getParameter("faceValue");
        String account = (String) request.getParameter("clientName");
        String docType = (String) request.getParameter("docType");
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
        java.sql.Timestamp docDate = super.extractDateFromRequest();

        // ---------------------------------------------------------
        // data from parent table

        String parentSurrogate = request.getParameter("accntItemSurrogate");
        WebBusinessObject parentItem = accntItemMgr.getOnSingleKey(parentSurrogate);

        String associatedItem = (String) parentItem.getAttribute("itemTitle");


        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(docTitle));
        params.addElement(new StringValue(account));
        params.addElement(new StringValue(associatedItem));
        params.addElement(new StringValue(parentSurrogate));
        params.addElement(new StringValue(description));
        params.addElement(new BigDecimalValue(totalValue));
        params.addElement(new ImageValue(new File(token)));
        params.addElement(new StringValue("EXTERNAL"));
        params.addElement(new StringValue(filePath));
        params.addElement(new StringValue("NONE"));
        params.addElement(new TimestampValue(docDate));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue((String) waUser.getAttribute("userName")));
        params.addElement(new StringValue(docType));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertImageSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
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

        String query = new String(sqlMgr.getSql("getImageOnSingleKey").trim());

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

    public Vector getListOnSecondKey(String keyValue) {

        Connection connection = null;
        Document doc = null;

        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(keyValue));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectImageListOnSecondKey").trim());
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

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();

            doc = (Document) fabricateBusObj(r);

            viewOrigin = new WebBusinessObject();
            viewOrigin.setAttribute("filter", "ListByAccount");
            viewOrigin.setAttribute("filterValue", keyValue);
            doc.setViewOrigin(viewOrigin);

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
            // raise an exception

            }

        }

        Document doc = new Document(ht);

        // reformat date in here
        String date = (String) doc.getAttribute("docDate");
        String formatedDate = date.substring(0, 10);
        doc.setAttribute("docDate", formatedDate);

        // check if bookmarked
        WebBusinessObject bm = bookmarkMgr.getBookmark((String) doc.getAttribute("docID"), currentUser);

        doc.setBookmark(bm);

        //owenership

        docOwnerId = (String) doc.getAttribute("createdById");
        doc.setViewrsIds(docOwnerId, (String) currentUser.getAttribute("userId"));
        doc.setWebUser(currentUser);

        return (WebBusinessObject) doc;
    }

    public Vector getListOnLIKE(String forOperation, String keyValue) {

        Connection connection = null;
        Document doc = null;

        String query = queryMgr.getQuery(forOperation, keyValue);
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

        // process the vector
        // vector of business objects
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

    public String getMaxCreationDateForSep(String sepID, boolean baseline) {

        String query = new String(sqlMgr.getSql("selectUnitDocHasDocument").trim().replace("$", sepID));
        if (baseline) {
            query = query + " AND IS_BASELINE = 'TRUE'";
        }
        query = query + " Group by Parent_Id";
        Connection connection = null;
        Document doc = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);


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
                return "";
            }
        }
        if (queryResult.size() > 0) {
            Row r = null;
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                ListIterator li = supportedForm.getFormElemnts().listIterator();
                FormElement fe = null;
                Hashtable ht = new Hashtable();
                String colName;
                while (li.hasNext()) {
                    try {
                        fe = (FormElement) li.next();
                        colName = (String) fe.getAttribute("column");
                        ht.put(fe.getAttribute("name"), r.getString(colName));
                    } catch (Exception ex) {
                    }
                }
                doc = new Document(ht);
            }
            if (doc.getAttribute("maxDate") != null) {
                return doc.getAttribute("maxDate").toString();
            } else {
                return "0000-00-00 00:00:00";
            }
        } else {
            return "";
        }
    }

    public boolean isObsolete(String sepID) {
        WebBusinessObject wbo = getOnSingleKey(sepID);
        if (wbo != null && wbo.getAttribute("isObsolete").toString().equalsIgnoreCase("TRUE")) {
            return true;
        } else {
            return false;
        }
    }

    public boolean setObsolete(String sepID) {

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(sepID));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("setObsolete").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
        } catch (SQLException se) {
            logger.error(" " + se.getMessage());
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

    public String getStatus(String sepID) {

        if (isObsolete(sepID)) {
            return "Obsolete";
        } else {
            ImageMgr imageMgr = ImageMgr.getInstance();
            String maxDate = imageMgr.getMaxCreationDateForSep(sepID, false);
            StringBuffer query = new StringBuffer(sqlMgr.getSql("getImageStatus").trim());
            //query.append("PARENT_ID = ").append("'").append(sepID).append("' AND creation_time = '").append(maxDate).append("'");
            Connection connection = null;
            Document doc = null;
            Vector queryResult = null;
            SQLCommandBean forQuery = new SQLCommandBean();

            try {
                connection = dataSource.getConnection();
                forQuery.setConnection(connection);
                forQuery.setSQLQuery(query.toString());


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
                    return "";
                }
            }
            if (queryResult.size() > 0) {
                Row r = null;
                Enumeration e = queryResult.elements();

                while (e.hasMoreElements()) {
                    r = (Row) e.nextElement();
                    ListIterator li = supportedForm.getFormElemnts().listIterator();
                    FormElement fe = null;
                    Hashtable ht = new Hashtable();
                    String colName;
                    while (li.hasNext()) {
                        try {
                            fe = (FormElement) li.next();
                            colName = (String) fe.getAttribute("column");
                            ht.put(fe.getAttribute("name"), r.getString(colName));
                        } catch (Exception ex) {
                        }
                    }
                    doc = new Document(ht);
                }
                if (doc != null && doc.getAttribute("isBaseline").toString().equalsIgnoreCase("TRUE")) {
                    return "Baseline";
                } else {
                    return "Current";
                }
            } else {
                return "Current";
            }
        }
    }

    public boolean burnAudio(String imageId, String sound) {

        String burnSoundSQL = sqlMgr.getSql("updateScheduleSQL").trim();
        Vector params = new Vector();
        SQLCommandBean forSoundBurn = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(sound));

        params.addElement(new StringValue(imageId));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forSoundBurn.setConnection(connection);

            forSoundBurn.setSQLQuery(burnSoundSQL);
            forSoundBurn.setparams(params);
            queryResult = forSoundBurn.executeUpdate();
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

    private java.sql.Date buildFromDate() {

        DictionaryItem tsItem = null;
        String[] timeStamp = new String[6];
        String startMonth = (String) theRequest.getParameter("startMonth");
        startMonth = new String(DateAndTimeConstants.getMonthAsNumberString(startMonth));

        timeStamp[0] = new String((String) theRequest.getParameter("startYear"));
        timeStamp[1] = new String(startMonth);
        timeStamp[2] = new String((String) theRequest.getParameter("startDay"));

        timeStamp[3] = new String("00");
        timeStamp[4] = new String("00");
        timeStamp[5] = new String("00");


        return TimeServices.toDate(timeStamp);
    }

    private java.sql.Date buildToDate() {
        DictionaryItem tsItem = null;
        String[] timeStamp = new String[6];
        String endMonth = (String) theRequest.getParameter("endMonth");
        endMonth = new String(DateAndTimeConstants.getMonthAsNumberString(endMonth));

        timeStamp[0] = new String((String) theRequest.getParameter("endYear"));
        timeStamp[1] = new String(endMonth);
        timeStamp[2] = new String((String) theRequest.getParameter("endDay"));
        timeStamp[3] = new String("00");
        timeStamp[4] = new String("00");
        timeStamp[5] = new String("00");

        return TimeServices.toDate(timeStamp);
    }

    public Vector getDocsInRange(String filterName, String filterValue) throws Exception, SQLException {

        //theRequest = req;
        int sepPos = filterValue.indexOf(":");
        String fromDate = filterValue.substring(0, sepPos);
        String toDate = filterValue.substring(sepPos + 1);
        Long fromDateL = new Long(fromDate);
        Long toDateL = new Long(toDate);
        Document doc = null;

        java.sql.Date d1 = new java.sql.Date(fromDateL.longValue());
        java.sql.Date d2 = new java.sql.Date(toDateL.longValue());

        Vector SQLparams = new Vector();
        SQLparams.addElement(new DateValue(d1));
        SQLparams.addElement(new DateValue(d2));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {
            forQuery.setConnection(connection);
            //forQuery.setSQLQuery(docsInRangeSQL);
            forQuery.setSQLQuery(queryMgr.getQuery(filterName, ""));
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("SQL Exception" + se.getMessage());
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("UnspportedTypeException " + uste.getMessage());
        } catch (Exception ex) {
            logger.error("Exception" + ex.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        viewOrigin = new WebBusinessObject();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            //  wbo = fabricateBusObj(r);

            doc = (Document) fabricateBusObj(r);

            viewOrigin.setAttribute("filter", filterName);
            viewOrigin.setAttribute("filterValue", filterValue);
            doc.setViewOrigin(viewOrigin);

            reultBusObjs.add(doc);
        }

        return reultBusObjs;
    }

    public Vector getAccountDocsInRange(String filterName, String filterValue) throws Exception, SQLException {

        //theRequest = req;
        int sepPos = filterValue.indexOf(":");
        int sep2Pos = filterValue.indexOf(">");

        if (sep2Pos < 0) {
            return getDocsInRange(filterName, filterValue);
        }

        String fromDate = filterValue.substring(0, sepPos);
        String toDate = filterValue.substring(sepPos + 1, sep2Pos);
        String accntName = filterValue.substring(sep2Pos + 1);
        Long fromDateL = new Long(fromDate);
        Long toDateL = new Long(toDate);
        Document doc = null;

        java.sql.Date d1 = new java.sql.Date(fromDateL.longValue());
        java.sql.Date d2 = new java.sql.Date(toDateL.longValue());

        Vector SQLparams = new Vector();
        SQLparams.addElement(new DateValue(d1));
        SQLparams.addElement(new DateValue(d2));
        SQLparams.addElement(new StringValue(accntName));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            String q = queryMgr.getQuery(filterName, "");
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(queryMgr.getQuery(filterName, ""));
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("SQL Exception" + se.getMessage());
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("UnspportedTypeException " + uste.getMessage());
        } catch (Exception ex) {
            logger.error("Exception ?????" + ex.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        viewOrigin = new WebBusinessObject();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            doc = (Document) fabricateBusObj(r);

            viewOrigin.setAttribute("filter", filterName);
            viewOrigin.setAttribute("filterValue", filterValue);
            doc.setViewOrigin(viewOrigin);

            reultBusObjs.add(doc);
        }

        return reultBusObjs;
    }

    public String getLatestForClient(String account) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(account));

        Connection connection = null;
        String doc_id = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getImageLatestForClient").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                doc_id = r.getString(1);
            }

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } catch (NoSuchColumnException nosuch) {
            logger.error("***** " + nosuch.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        return doc_id;

    }

    public Document getLatestTransactionDoc(String op, String docKey) {

        Document doc = (Document) this.getOnSingleKey(docKey);
        viewOrigin = new WebBusinessObject();
        viewOrigin.setAttribute("filter", op);
        viewOrigin.setAttribute("filterValue", docKey);
        doc.setViewOrigin(viewOrigin);
        return doc;
    }

    public Vector getListByFileType(String forOperation, String keyValue) {

        Connection connection = null;
        Document doc = null;
        String query = queryMgr.getQuery(forOperation, keyValue);

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("getList on file type ImageMgr " + se.getMessage());
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

        // process the vector
        // vector of business objects
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

    public String saveDocumentCoverPage(HttpServletRequest request, HttpSession session, String filePath) {

        // -------------------------------

        theRequest = request;
        File dispose = null;

        String folderID = (String) request.getParameter("folderID");
        WebBusinessObject folder = (WebBusinessObject) getOnSingleKey(folderID);

        WebBusinessObject waUser = (WebBusinessObject) session.getAttribute("loggedUser");

        String docTitle = (String) request.getParameter("docTitle");
        String description = (String) request.getParameter("description");
        String total = (String) request.getParameter("faceValue");
        String account = (String) request.getParameter("folderName");
        String folderName = (String) folder.getAttribute("docTitle");

        String docType = (String) request.getParameter("fileExtension");

        // get file MetaType
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
        // date
        java.sql.Timestamp docDate = super.extractDateFromRequest();

        // ---------------------------------------------------------
        // data from parent table

        String sptrID = request.getParameter("separatorID");
        WebBusinessObject sptr = getOnSingleKey(sptrID);
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String coverPageID = UniqueIDGen.getNextID();
        params.addElement(new StringValue(coverPageID));
        params.addElement(new StringValue(docTitle));
        params.addElement(new StringValue(folderName));
        params.addElement(new StringValue((String) sptr.getAttribute("docTitle")));
        params.addElement(new StringValue(folderID));
        params.addElement(new StringValue(description));
        params.addElement(new BigDecimalValue(totalValue));
        params.addElement(new ImageValue(new File(filePath)));
        params.addElement(new StringValue("INTERNAL"));
        params.addElement(new StringValue("INTERNAL"));
        params.addElement(new StringValue("NONE"));
        params.addElement(new TimestampValue(docDate));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue((String) waUser.getAttribute("userName")));
        params.addElement(new StringValue((String) waUser.getAttribute("groupName")));
        params.addElement(new StringValue(metaType));
        params.addElement(new StringValue(docType));
        params.addElement(new StringValue("sptr"));
        params.addElement(new StringValue(sptrID));
        params.addElement(new StringValue("FALSE"));
        params.addElement(new StringValue("FALSE"));
        params.addElement(new StringValue("FALSE"));
        params.addElement(new StringValue("FALSE"));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertImageSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            return coverPageID;
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

    public ArrayList getListByFileTypeAsArrayList(String forOperation, String fileType) {
        ArrayList filesList = new ArrayList();
        WebBusinessObject wbo = null;

        Vector list = getListByFileType(forOperation, fileType);

        for (int i = 0; i < list.size(); i++) {
            wbo = (WebBusinessObject) list.elementAt(i);
            filesList.add((String) wbo.getAttribute("docTitle"));
        }

        return filesList;
    }

    public ArrayList getListByFileTypeAsBusObjects(String forOperation, String fileType) {

        ArrayList filesList = new ArrayList();
        WebBusinessObject wbo = null;

        Vector list = getListByFileType(forOperation, fileType);

        for (int i = 0; i < list.size(); i++) {
            wbo = (WebBusinessObject) list.elementAt(i);
            filesList.add(wbo);
        }

        return filesList;
    }

    public ArrayList getListByFileTypeAsBusObjectsForGroups(String forOperation, String fileType, HttpSession session) {

        ArrayList filesList = new ArrayList();
        WebBusinessObject wbo = null;
        FolderGroupMgr folderGroupMgr = FolderGroupMgr.getInstance();
        WebBusinessObject wUser = (WebBusinessObject) session.getAttribute("loggedUser");

        Vector list = getListByFileType(forOperation, fileType);

        for (int i = 0; i < list.size(); i++) {
            wbo = (WebBusinessObject) list.elementAt(i);
            if (folderGroupMgr.isOwner(wbo.getAttribute("docID").toString(), wUser.getAttribute("groupID").toString())) {
                filesList.add(wbo);
            }
        }

        return filesList;
    }

    public boolean isUnique(String docName, String parentID) {
        Connection connection = null;
        Document doc = null;

        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(parentID));
        SQLparams.addElement(new StringValue(docName));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectImageIsUnique").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("database error from isUnique: ImageMgr " + se.getMessage());
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

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();

            doc = (Document) fabricateBusObj(r);

            return (null != doc ? false : true);

        }

        return true;

    }

  /*  public Vector getOnArbitraryKey(String keyValue, String keyIndex) throws SQLException, Exception {

        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;

        String theQuery = query.toString();


        if (supportedForm == null) {

            initSupportedForm();
        }

        // finally do the query
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

    }*/

    public ArrayList getCntrDocsChildren(String keyValue) throws SQLException, Exception {

        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;

        String query = new String(sqlMgr.getSql("getImageCntrDocsChildren").trim());

        if (supportedForm == null) {

            initSupportedForm();
        }

        // finally do the query
        SQLparams.add(new StringValue(keyValue));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
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
        ArrayList reultBusObjs = new ArrayList();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }

        return reultBusObjs;
    }

    public Vector getCntrDocsChildrenVector(String keyValue) throws SQLException, Exception {

        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;

        String query = new String(sqlMgr.getSql("getImageCntrDocsChildrenVector").trim());

        if (supportedForm == null) {

            initSupportedForm();
        }

        // finally do the query
        SQLparams.add(new StringValue(keyValue));


        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
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

    public boolean updateFolder(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue((String) wbo.getAttribute("docTitle")));
        params.addElement(new StringValue((String) wbo.getAttribute("description")));
        params.addElement(new StringValue((String) wbo.getAttribute("docID")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateFolder").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
        } catch (SQLException se) {
            logger.error(" " + se.getMessage());
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

    public boolean moveSeparator(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue((String) wbo.getAttribute("parentID")));
        params.addElement(new StringValue((String) wbo.getAttribute("docID")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("moveSeparator").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
        } catch (SQLException se) {
            logger.error(" " + se.getMessage());
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

    public boolean updateDocuments(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {

        String parentID = (String) wbo.getAttribute("parentID");
        String docID = (String) wbo.getAttribute("docID");
        WebBusinessObject folder = new WebBusinessObject();
        folder = getOnSingleKey(parentID);
        String folderName = (String) folder.getAttribute("docTitle");
        String folderId = (String) folder.getAttribute("docID");

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(folderName));
        params.addElement(new StringValue(folderId));
        params.addElement(new StringValue(docID));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateImageDocuments").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

        } catch (SQLException se) {
            logger.error(" " + se.getMessage());
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

    public boolean makeBaseline(WebBusinessObject wbo, String version, HttpSession s) throws NoUserInSessionException {

        String docID = (String) wbo.getAttribute("docID");

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(version));
        params.addElement(new StringValue(docID));
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("makeBaseline").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
        } catch (SQLException se) {
            logger.error(" " + se.getMessage());
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

    public boolean clearBaseline(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {

        String parentID = (String) wbo.getAttribute("parentID");

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(parentID));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("clearBaseline").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
        } catch (SQLException se) {
            logger.error(" " + se.getMessage());
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

    public boolean checkBaseline(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {

        String parentID = (String) wbo.getAttribute("parentID");

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector params = new Vector();
        SQLCommandBean forReading = new SQLCommandBean();
        Vector queryResult = null;

        params.addElement(new StringValue(parentID));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forReading.setConnection(connection);
            forReading.setSQLQuery(sqlMgr.getSql("checkBaseline").trim());
            forReading.setparams(params);
            queryResult = forReading.executeQuery();

        } catch (SQLException se) {
            logger.error(" " + se.getMessage());
            return false;

        } catch (UnsupportedTypeException uste) {
            logger.error(" " + uste.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult.size() > 0);

    }

    public boolean allowShowAllBaseline(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {

        String sepID = (String) wbo.getAttribute("docID");
        int queryResult = -1000;

        if (clearDocuments(sepID, s)) {
            WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

            Vector params = new Vector();
            SQLCommandBean forUpdate = new SQLCommandBean();

            params.addElement(new StringValue("TRUE"));
//        params.addElement(new StringValue("ALL"));
            params.addElement(new StringValue(sepID));
            params.addElement(new StringValue("FALSE"));

            Connection connection = null;
            try {
                connection = dataSource.getConnection();
                forUpdate.setConnection(connection);
                forUpdate.setSQLQuery(sqlMgr.getSql("allowShowAllBaseline").trim());
                forUpdate.setparams(params);
                queryResult = forUpdate.executeUpdate();
            } catch (SQLException se) {
                logger.error(" " + se.getMessage());
                return false;
            } finally {
                try {
                    connection.close();
                } catch (SQLException ex) {
                    logger.error("Close Error");
                    return false;
                }
            }
        }
        return (queryResult > 0);

    }

    public boolean sepAllBaseline(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {

        String sepID = (String) wbo.getAttribute("docID");

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue("FALSE"));
        params.addElement(new StringValue("ALL"));
        params.addElement(new StringValue(sepID));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("sepAllBaseline").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
        } catch (SQLException se) {
            logger.error(" " + se.getMessage());
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

    public boolean clearDocuments(String docID, HttpSession s) throws NoUserInSessionException {

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(docID));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("clearImageDocuments").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
        } catch (SQLException se) {
            logger.error(" " + se.getMessage());
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

    public boolean showOnlyLastBaseline(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {

        String sepID = (String) wbo.getAttribute("docID");
        int queryResult = -1000;

        if (clearDocuments(sepID, s)) {

            WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

            Vector params = new Vector();
            SQLCommandBean forUpdate = new SQLCommandBean();

            params.addElement(new StringValue("TRUE"));
            params.addElement(new StringValue(sepID));
            params.addElement(new StringValue("FALSE"));

            Connection connection = null;
            try {
                connection = dataSource.getConnection();
                forUpdate.setConnection(connection);
                forUpdate.setSQLQuery(sqlMgr.getSql("showOnlyLastBaseline").trim());
                forUpdate.setparams(params);
                queryResult = forUpdate.executeUpdate();
            } catch (SQLException se) {
                logger.error(" " + se.getMessage());
                return false;
            } finally {
                try {
                    connection.close();
                } catch (SQLException ex) {
                    logger.error("Close Error");
                    return false;
                }
            }

        }
        return (queryResult > 0);
    }

    public boolean sepOnlyLastBaseline(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {

        String sepID = (String) wbo.getAttribute("docID");

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue("FALSE"));
        params.addElement(new StringValue("LAST"));
        params.addElement(new StringValue(sepID));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("sepOnlyLastBaseline").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

        } catch (SQLException se) {
            logger.error(" " + se.getMessage());
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

    public Vector publishDocument(String documentType, HttpSession s) throws NoUserInSessionException {

        Connection connection = null;
        Document doc = null;

        String query = queryMgr.getQuery("Publish", documentType);

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);


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

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();

            doc = (Document) fabricateBusObj(r);
//            doc.settargetServlet("ConfigurationServlet");
            viewOrigin = new WebBusinessObject();
            viewOrigin.setAttribute("filter", "PublishDocument");
            viewOrigin.setAttribute("filterValue", documentType);
            doc.setViewOrigin(viewOrigin);

            reultBusObjs.add(doc);
        }

        return reultBusObjs;
    }

    public boolean clearSeparator(String docID, HttpSession s) {

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(docID));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("clearImageSeparator").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

        } catch (SQLException se) {
            logger.error(" " + se.getMessage());
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

    public WebBusinessObject lastBaselineVersion(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {

        String parentID = (String) wbo.getAttribute("parentID");

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
//        StringBuffer query = new StringBuffer("SELECT DOC_ID,DOC_TITLE,ISSUE_ID,DESCRIPTION,DOC_DATE,CREATED_BY,CREATED_BY_NAME,DOC_TYPE,CREATION_TIME FROM document ");
//        query.append(" AND PARENT_ID = ?");

        Vector params = new Vector();
        SQLCommandBean forReading = new SQLCommandBean();
        Vector queryResult = null;

        params.addElement(new StringValue(parentID));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forReading.setConnection(connection);
            forReading.setSQLQuery(sqlMgr.getSql("selectUnitDocHasDocument").trim());
            forReading.setparams(params);
            queryResult = forReading.executeQuery();

        } catch (SQLException se) {
            logger.error(" " + se.getMessage());
            return null;

        } catch (UnsupportedTypeException uste) {
            logger.error(" " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return null;
            }
        }

        WebBusinessObject reultBusObj = null;

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObj = fabricateBusObj(r);
        }

        return reultBusObj;
    }

    public boolean isLocked(String folderID) {
        //ImageMgr fldr = ImageMgr.getInstance();
        WebBusinessObject folder = (WebBusinessObject) getOnSingleKey(folderID);
        if (folder != null) {
            if (folder.getAttribute("isLocked").toString().equalsIgnoreCase("FALSE")) {
                return false;
            } else {
                return true;
            }
        }
        return false;
    }

    public boolean lockDocument(String docID) {

//        StringBuffer query = new StringBuffer("UPDATE document SET IS_LOCKED = 'TRUE' WHERE DOC_ID ='");
//        query.append(docID + "'");
        SQLCommandBean forUpdating = new SQLCommandBean();
        int queryResult = 0;
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdating.setConnection(connection);
            forUpdating.setSQLQuery(sqlMgr.getSql("lockImageDocument").trim().replace("$", docID));
            queryResult = forUpdating.executeUpdate();

        } catch (SQLException se) {
            logger.error(" " + se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }
        return (queryResult > 0);
    }

    public boolean unlockDocument(String docID) {
        SQLCommandBean forUpdating = new SQLCommandBean();
        int queryResult = 0;
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdating.setConnection(connection);
            forUpdating.setSQLQuery(sqlMgr.getSql("unlockImageDocument").trim().replace("$", docID));
            queryResult = forUpdating.executeUpdate();

        } catch (SQLException se) {
            logger.error(" " + se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }
        return (queryResult > 0);
    }

    public boolean UpdateSeparator(String docID, String version, HttpSession s) {

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(version));
        params.addElement(new StringValue(docID));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateImageSeparator").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

        } catch (SQLException se) {
            logger.error(" " + se.getMessage());
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
    public Vector getAllImgInfo(String issueID){

        Vector params = new Vector();
       


        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectImageHasDocument").trim().replace("$", "'" + issueID + "'"));

            queryResult = forQuery.executeQuery();
            endTransaction();

        } catch (SQLException se) {
            logger.error("database error from getListOnSecondKey: ImageMgr " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        }

        Vector reultBusObjs = new Vector();
        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }

        return reultBusObjs;

    }
    public boolean hasDocuments(String issueID) throws Exception {

        // Establish a JDBC connection to the MYSQL database server.
        //Class.forName("org.gjt.mm.mysql.Driver");
        //Class.forName("oracle.jdbc.driver.OracleDriver").newInstance();
        //Connection conn = DriverManager.getConnection(
        //        "jdbc:oracle:thin:@//silkworm4:1521/delta.work");
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectImageHasDocument").trim().replace("$", "'" + issueID + "'"));


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

    private String getAttribute(String string) {
        return null;
    }

    @Override
    protected void initSupportedQueries() {
       return; // throw new UnsupportedOperationException("Not supported yet.");
    }
}
