package com.maintenance.db_access;

import com.docviewer.business_objects.Document;
import com.maintenance.common.DateParser;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import javax.servlet.http.HttpSession;
import java.util.*;
import java.sql.*;
import java.io.File;
import com.docviewer.db_access.QueryMgr;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.db_access.FileMgr;
import com.silkworm.jsptags.DropdownDate;
import com.silkworm.servlets.MultipartRequest;
import com.silkworm.uploader.FileMeta;
import com.tracker.db_access.ProjectMgr;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.xml.DOMConfigurator;

public class UnitDocMgr extends RDBGateWay {
    
    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static UnitDocMgr unitDocMgr = new UnitDocMgr();
    private FileMgr fileMgr = FileMgr.getInstance();
    private WebBusinessObject fileDescriptor = null;
    private QueryMgr queryMgr = null;
    
    public static UnitDocMgr getInstance() {
        logger.info("Getting UnitDocMgr Instance ....");
        return unitDocMgr;
    }
    
    public void setQueryMgr(QueryMgr qm) {
        queryMgr = qm;
    }
    
    public java.util.ArrayList getCashedTableAsArrayList() {
        return null;
    }
    
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("mnt_unit_document.xml")));
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
            ps = connection.prepareStatement(sqlMgr.getSql("getUnitDocImage").trim());
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
        String equipmentID = (String) request.getParameter("equipmentID");
        String description = (String) request.getParameter("description");
        String total = (String) request.getParameter("faceValue");
        String docType = (String) request.getParameter("fileExtension");
        String type = (String) request.getParameter("type");
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

        DateParser dateParser = new DateParser();
        java.sql.Date sqlDate = dateParser.formatSqlDate(request.getParameter("docDate"));
        java.sql.Timestamp docDate = new java.sql.Timestamp(sqlDate.getTime());
        
        
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(docTitle));
        params.addElement(new StringValue(equipmentID));
        params.addElement(new StringValue(description));
        params.addElement(new ImageValue(myfile));
        params.addElement(new TimestampValue(docDate));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue((String) waUser.getAttribute("userName")));
        params.addElement(new StringValue(metaType));
        params.addElement(new StringValue(docBusinessType));
        params.addElement(new StringValue(request.getParameter("configType")));
        params.addElement(new StringValue(type));
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertUnitDocSQL").trim());
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
        String equipmentID = (String) request.getParameter("equipmentID");
        String description = (String) request.getParameter("description");
        String total = (String) request.getParameter("faceValue");
        String docType = (String) request.getParameter("fileExtension");
        String type = (String) request.getParameter("type");
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

        DateParser dateParser = new DateParser();
        java.sql.Date sqlDate = dateParser.formatSqlDate(request.getParameter("docDate"));
        java.sql.Timestamp docDate = new java.sql.Timestamp(sqlDate.getTime());
        
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(docTitle));
        params.addElement(new StringValue(equipmentID));
        params.addElement(new StringValue(description));
        params.addElement(new ImageValue(myfile));
        params.addElement(new TimestampValue(docDate));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue((String) waUser.getAttribute("userName")));
        params.addElement(new StringValue(metaType));
        params.addElement(new StringValue(docBusinessType));
        params.addElement(new StringValue(request.getParameter("configType")));
        params.addElement(new StringValue(type));
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertUnitDocSQL").trim());
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

        DateParser dateParser = new DateParser();
        java.sql.Date sqlDate = dateParser.formatSqlDate(request.getParameter("docDate"));
        java.sql.Timestamp docDate = new java.sql.Timestamp(sqlDate.getTime());
        
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
            forUpdate.setSQLQuery(sqlMgr.getSql("updateUnitDocImage").trim());
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
    
    public boolean updateDocumentParent(String docId, String parentId) {
        
        
        
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue(parentId));
        params.addElement(new StringValue(docId));
        
        
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateDocumentParent").trim());
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
        
        String query = new String(sqlMgr.getSql("selectUnitDocOnSingleKey").trim());
        
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
    
    public String getPdfContract (String clientID){
        Connection connection = null;
        String doc = null;
        
        Vector SQLparams = new Vector();
        
        SQLparams.addElement(new StringValue(clientID));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectFirstPdfDocument").trim());
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
//        Vector reultBusObjs = new Vector();
        
        Row r = null;
        Enumeration e = queryResult.elements();
        
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            try {
                doc = r.getString(1);
//            reultBusObjs.add(doc);
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(UnitDocMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        return doc;
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
            forQuery.setSQLQuery(sqlMgr.getSql("selectUnitDocListOnLike").trim());
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
    
    public Vector getUnitDocsByDocType(String unitId, String typeId, String docId) {
        
        Connection connection = null;
        Document doc = null;
        
        Vector SQLparams = new Vector();
        
        SQLparams.addElement(new StringValue(unitId));
        SQLparams.addElement(new StringValue(typeId));
        SQLparams.addElement(new StringValue(docId));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getUnitDocsByDocType").trim());
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
    
    public boolean hasDocuments(String equipmentID) throws Exception {
        
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectUnitDocHasDocument").trim().replace("$", "'" + equipmentID + "'"));
            queryResult = forQuery.executeQuery();
            
        } catch (SQLException se) {
            logger.error("database error from getListOnSecondKey: ImageMgr " + se.getMessage());
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
    
    public boolean hasDocumentsByType(String equipmentID, String type) throws Exception {
        
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector SQLparams = new Vector();
        
        SQLparams.addElement(new StringValue(type));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectUnitDocHasDocumentByType").trim().replace("$", "'" + equipmentID + "'"));
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
            
        } catch (SQLException se) {
            logger.error("database error from getListOnSecondKey: ImageMgr " + se.getMessage());
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
    
    public boolean hasImages(String equipmentID) throws Exception {
        
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectUnitDocHasImage").trim().replace("$", "'" + equipmentID + "'"));
            queryResult = forQuery.executeQuery();
            
        } catch (SQLException se) {
            logger.error("database error from getListOnSecondKey: ImageMgr " + se.getMessage());
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
    
    public Vector getImagesList(String equipmentID) {
        
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectUnitDocHasImage").trim().replace("$", "'" + equipmentID + "'"));
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
        Document doc;
        Row r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();

                doc = (Document) fabricateBusObj(r);
                resultBusObjs.add(doc);
            }
        }
        
        return resultBusObjs;
        
    }
    
    public boolean deleteSelectedFile(String docId) throws SQLException {
        
        Connection connection = null;
        Vector queryResult = new Vector();
        int result = -1000;
        boolean status = false;
        SQLCommandBean forQuery = new SQLCommandBean();
        String sql = sqlMgr.getSql("deleteSelectedFile").trim();
        sql = sql.replace("ppp", docId);
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sql);
            result = forQuery.executeUpdate();
            if (result > 0) {
                status = true;
            }
        } catch (SQLException se) {
        } finally {
            connection.commit();
            connection.close();
            
        }
        
        return status;
        
    }
    
    public boolean updateSelectedFile(String docsId, String mainProjectId) throws SQLException {
        
        Connection connection = null;
        Vector queryResult = new Vector();
        int result = -1000;
        boolean status = false;
        SQLCommandBean forQuery = new SQLCommandBean();
        queryResult.addElement(new StringValue(mainProjectId));
        String sql = sqlMgr.getSql("updateSelectedFileParent").trim();
        sql = sql.replace("ppp", docsId);
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sql);
            forQuery.setparams(queryResult);
            result = forQuery.executeUpdate();
            if (result > 0) {
                status = true;
            }
        } catch (SQLException se) {
        } finally {
            connection.commit();
            connection.close();
            
        }
        
        return status;
        
    }
    
    public boolean saveDocumentByTree(MultipartRequest request, HttpSession s) throws NoUserInSessionException {
        DropdownDate dropdownDate = new DropdownDate();
//        java.sql.Timestamp conversionDate = dropdownDate.getDate(request.getParameter("conversionDate"));

        DateParser dateParser = new DateParser();
        java.sql.Date sqlDate = dateParser.formatSqlDate(request.getParameter("docDate"));
        java.sql.Timestamp docDate = new java.sql.Timestamp(sqlDate.getTime());
        
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        
        String docBusinessType = (String) request.getParameter("docType");
        String docTitle = (String) request.getParameter("docTitle");
        String projId = (String) request.getParameter("projId");
        String description = (String) request.getParameter("description");
        String docType = (String) request.getParameter("fileExtension");
        String type = (String) request.getParameter("type");
        fileDescriptor = fileMgr.getObjectFromCash(docType);
        String metaType = (String) fileDescriptor.getAttribute("metaType");
        
        Vector params = new Vector();
        Vector docParams = new Vector();
        Vector issueParams = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        String extJobId = null;
        
        
        if (request.getFile("file1") != null) {
            docParams.addElement(new StringValue(UniqueIDGen.getNextID()));
            docParams.addElement(new StringValue(docTitle));
            docParams.addElement(new StringValue(projId));
            docParams.addElement(new StringValue(description));
            docParams.addElement(new ImageValue(request.getFile("file1")));
            docParams.addElement(new TimestampValue(docDate));
            docParams.addElement(new StringValue(waUser.getAttribute("userId").toString()));
            docParams.addElement(new StringValue(waUser.getAttribute("userName").toString()));
            docParams.addElement(new StringValue(metaType));
            docParams.addElement(new StringValue(docBusinessType));
            docParams.addElement(new StringValue(request.getParameter("configType")));
            docParams.addElement(new StringValue(type));
            
            
        }
        //1378803141254
        issueParams.addElement(new StringValue((String) request.getParameter("issueId")));
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            
            if (request.getFile("file1") != null) {
                forInsert.setSQLQuery(sqlMgr.getSql("insertUnitDocSQL").trim());
                forInsert.setparams(docParams);
                queryResult = forInsert.executeUpdate();
            }
            
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
    
    public Vector getUnitDocs(String beginDate, String endDate, String configItemType) throws NoSuchColumnException {
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        params.addElement(new StringValue(configItemType));
        params.addElement(new DateValue(getSqlDate(beginDate)));
        params.addElement(new DateValue(getSqlDate(endDate)));
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getUnitDocs").trim());
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
        Vector resultBusObjs = new Vector();
        WebBusinessObject wbo;
        Row r = null;
        Enumeration d = queryResult.elements();
        while (d.hasMoreElements()) {
            r = (Row) d.nextElement();
            wbo = new WebBusinessObject();
            wbo.setAttribute("docId", r.getString("doc_id"));
            wbo.setAttribute("docTitle", r.getString("doc_title"));
            wbo.setAttribute("docType", r.getString("doc_type"));
            wbo.setAttribute("unitId", r.getString("unit_id"));
            ProjectMgr projectMgr = ProjectMgr.getInstance();
            WebBusinessObject projWbo = projectMgr.getOnSingleKey(r.getString("unit_id"));
            wbo.setAttribute("unitName", projWbo.getAttribute("projectName"));
            wbo.setAttribute("description", r.getString("description"));
            wbo.setAttribute("docDate", r.getString("doc_date"));
            wbo.setAttribute("configItemType", r.getString("config_item_type"));
            wbo.setAttribute("docType", r.getString("doc_type"));
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }
    
    public Vector getUnitDocs(String beginDate, String endDate) throws NoSuchColumnException {
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        params.addElement(new DateValue(getSqlDate(beginDate)));
        params.addElement(new DateValue(getSqlDate(endDate)));
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getUnitDocsByDates").trim());
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
        Vector resultBusObjs = new Vector();
        WebBusinessObject wbo;
        Row r = null;
        Enumeration d = queryResult.elements();
        while (d.hasMoreElements()) {
            r = (Row) d.nextElement();
            wbo = new WebBusinessObject();
            wbo.setAttribute("docId", r.getString("doc_id"));
            wbo.setAttribute("docTitle", r.getString("doc_title"));
            wbo.setAttribute("docType", r.getString("doc_type"));
            wbo.setAttribute("unitId", r.getString("unit_id"));
            ProjectMgr projectMgr = ProjectMgr.getInstance();
            WebBusinessObject projWbo = projectMgr.getOnSingleKey(r.getString("unit_id"));
            wbo.setAttribute("unitName", projWbo.getAttribute("projectName"));
            wbo.setAttribute("description", r.getString("description"));
            wbo.setAttribute("docDate", r.getString("doc_date"));
            wbo.setAttribute("configItemType", r.getString("config_item_type"));
            wbo.setAttribute("docType", r.getString("doc_type"));
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }
    public String getCountUnitDocs(String unitID) {
       String count = "0" ;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        params.addElement(new StringValue(unitID));
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectCountDocsByUnitCode").trim());
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
        Row r = null;
        Enumeration d = queryResult.elements();
        while (d.hasMoreElements()) {
            r = (Row) d.nextElement();
           try {
               count = r.getString(1);
           } catch (NoSuchColumnException ex) {
               Logger.getLogger(UnitDocMgr.class.getName()).log(Level.SEVERE, null, ex);
           }
        }
        return count;
    }
    
    private java.sql.Date getSqlDate(String date) {
        DateParser parser = new DateParser();
        java.sql.Date sqlDate = parser.formatSqlDate(date);
        
        return sqlDate;
    }
    
    @Override
    protected void initSupportedQueries() {
        return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
    
    public boolean saveMultiDocument(MultipartRequest request, WebBusinessObject persistentUser) throws NoUserInSessionException, SQLException {
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

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
                
                issueDocumentParameters.addElement(new StringValue(documentId));
                issueDocumentParameters.addElement(new StringValue(documentTitle));
                issueDocumentParameters.addElement(new StringValue(request.getParameter("projectId")));
                issueDocumentParameters.addElement(new StringValue("UL"));
                issueDocumentParameters.addElement(new ImageValue(new File(f.getPath())));
                issueDocumentParameters.addElement(new TimestampValue(new Timestamp(Long.parseLong(documentId))));
                issueDocumentParameters.addElement(new StringValue(persistentUser.getAttribute("userId").toString()));
                issueDocumentParameters.addElement(new StringValue(persistentUser.getAttribute("userName").toString()));
                issueDocumentParameters.addElement(new StringValue(metaType));
                issueDocumentParameters.addElement(new StringValue(documentExtension));
                issueDocumentParameters.addElement(new StringValue("1"));
                issueDocumentParameters.addElement(new StringValue(""));

                forInsert.setSQLQuery(sqlMgr.getSql("insertUnitDocSQL").trim());
                forInsert.setparams(issueDocumentParameters);
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

//        }
        return (queryResult > 0);
    }
    public boolean saveUnitImageFromAndroid(File file,String projectId) throws NoUserInSessionException, SQLException {
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);
            Enumeration files;
            

                String documentId = UniqueIDGen.getNextID();
                String fileName = file.getName();
                String documentTitle = fileName.substring(0, fileName.indexOf("."));
                String documentExtension = fileName.substring(fileName.indexOf(".") + 1, fileName.length());
                fileDescriptor = fileMgr.getObjectFromCash(documentExtension);
                String metaType = (String) fileDescriptor.getAttribute("metaType");

                Vector issueDocumentParameters = new Vector();
                
                issueDocumentParameters.addElement(new StringValue(documentId));
                issueDocumentParameters.addElement(new StringValue(documentTitle));
                issueDocumentParameters.addElement(new StringValue(projectId));
                issueDocumentParameters.addElement(new StringValue("UL"));
                issueDocumentParameters.addElement(new ImageValue(file));
                issueDocumentParameters.addElement(new TimestampValue(new Timestamp(Long.parseLong(documentId))));
                issueDocumentParameters.addElement(new StringValue("UL"));
                issueDocumentParameters.addElement(new StringValue("UL"));
                issueDocumentParameters.addElement(new StringValue(metaType));
                issueDocumentParameters.addElement(new StringValue(documentExtension));
                issueDocumentParameters.addElement(new StringValue("1"));
                issueDocumentParameters.addElement(new StringValue(""));

                forInsert.setSQLQuery(sqlMgr.getSql("insertUnitDocSQL").trim());
                forInsert.setparams(issueDocumentParameters);
                queryResult = forInsert.executeUpdate();
                if (queryResult < 0) {
                    connection.rollback();
                    return false;
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

//        }
        return (queryResult > 0);
    }
    
    public Vector getClientDocs(String clientID) throws NoSuchColumnException {
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        params.addElement(new StringValue(clientID));
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getUnitDocsByDates").trim());
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
        Vector resultBusObjs = new Vector();
        WebBusinessObject wbo;
        Row r = null;
        Enumeration d = queryResult.elements();
        while (d.hasMoreElements()) {
            r = (Row) d.nextElement();
            wbo = new WebBusinessObject();
            wbo.setAttribute("docId", r.getString("doc_id"));
            wbo.setAttribute("docTitle", r.getString("doc_title"));
            wbo.setAttribute("docType", r.getString("doc_type"));
            wbo.setAttribute("unitId", r.getString("unit_id"));
            ProjectMgr projectMgr = ProjectMgr.getInstance();
            WebBusinessObject projWbo = projectMgr.getOnSingleKey(r.getString("unit_id"));
            wbo.setAttribute("unitName", projWbo.getAttribute("projectName"));
            wbo.setAttribute("description", r.getString("description"));
            wbo.setAttribute("docDate", r.getString("doc_date"));
            wbo.setAttribute("configItemType", r.getString("config_item_type"));
            wbo.setAttribute("docType", r.getString("doc_type"));
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }
    
    public ArrayList<WebBusinessObject> getLogosWithProjectID(String projectID) {
        Connection connection = null;
        Document doc;
        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(projectID));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getLogosWithProjectID").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.println(se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                return null;
            }
        }
        ArrayList<WebBusinessObject> reultBusObjs = new ArrayList<WebBusinessObject>();
        Row r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                doc = (Document) fabricateBusObj(r);
                reultBusObjs.add(doc);
            }
        }
        return reultBusObjs;
    }
    
    public List<WebBusinessObject> searchForDocuments(java.sql.Date beginDate, java.sql.Date endDate, String projectID, String title) {
        String theQuery = sqlMgr.getSql("searchForDocuments").trim();
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
        Vector<Row> result;
        Vector parameters = new Vector();

        parameters.addElement(new StringValue(projectID));
        parameters.addElement(new StringValue("%" + title + "%"));
        parameters.addElement(new DateValue(beginDate));
        parameters.addElement(new DateValue(endDate));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(theQuery);
            command.setparams(parameters);
            result = command.executeQuery();

            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                data.add(wbo);
            }
        } catch (SQLException ex) {
            logger.error(ex);
        } catch (UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }
        return data;
    }
    
    public boolean saveDocumentForModel(MultipartRequest request, String modelID, HttpSession s) throws NoUserInSessionException {
        DateParser dateParser = new DateParser();
        java.sql.Date sqlDate = dateParser.formatSqlDate(request.getParameter("docDate"));
        java.sql.Timestamp docDate = new java.sql.Timestamp(sqlDate.getTime());

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        String docBusinessType = (String) request.getParameter("docType");
        String docTitle = (String) request.getParameter("title");
        String description = (String) request.getParameter("description");
        String docType = (String) request.getParameter("fileExtension");
        String type = (String) request.getParameter("type");
        fileDescriptor = fileMgr.getObjectFromCash(docType);
        String metaType = (String) fileDescriptor.getAttribute("metaType");

        Vector docParams = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        if (request.getFile("file1") != null) {
            docParams.addElement(new StringValue(UniqueIDGen.getNextID()));
            docParams.addElement(new StringValue(docTitle));
            docParams.addElement(new StringValue(modelID));
            docParams.addElement(new StringValue(description));
            docParams.addElement(new ImageValue(request.getFile("file1")));
            docParams.addElement(new TimestampValue(docDate));
            docParams.addElement(new StringValue(waUser.getAttribute("userId").toString()));
            docParams.addElement(new StringValue(waUser.getAttribute("userName").toString()));
            docParams.addElement(new StringValue(metaType));
            docParams.addElement(new StringValue(docBusinessType));
            docParams.addElement(new StringValue(request.getParameter("configType")));
            docParams.addElement(new StringValue(type));
        }
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            if (request.getFile("file1") != null) {
                forInsert.setSQLQuery(sqlMgr.getSql("insertUnitDocSQL").trim());
                forInsert.setparams(docParams);
                queryResult = forInsert.executeUpdate();
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }
        return (queryResult > 0);
    }
}
