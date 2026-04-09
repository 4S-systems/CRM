package com.tracker.servlets;

import com.contractor.db_access.MaintainableMgr;
import com.maintenance.db_access.AverageUnitMgr;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.io.*;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Vector;

import javax.servlet.*;
import javax.servlet.http.*;


import java.util.Date;
import java.util.Calendar;
import org.apache.log4j.Logger;

public class MidletServlet extends TrackerBaseServlet {

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        logger = Logger.getLogger(MidletServlet.class);
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        //super.processRequest(request,response);
        HttpSession session = request.getSession();
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();
        BufferedReader br = request.getReader();
        String buf = br.readLine();
        int operation = 0;
        WebBusinessObject wbo = new WebBusinessObject();
        if(buf.length() > 0 && buf.indexOf("=") > -1){
            String[] bufTemp = buf.split(",");
            for(int i = 0; i < bufTemp.length; i++){
                String[] temp = bufTemp[i].split("=");
                wbo.setAttribute(temp[0], temp[1]);
            }
            operation = getOpCode((String) wbo.getAttribute("op"));
        }
        switch (operation) {
            case 1:
                Vector SQLparams = new Vector();
                String query = new String("SELECT * FROM USERS WHERE USER_NAME = ? AND PASSWORD = ?");
                SQLparams.addElement(new StringValue((String)wbo.getAttribute("name")));
                SQLparams.addElement(new StringValue((String)wbo.getAttribute("password")));
                Vector queryResult = null;
                SQLCommandBean forQuery = new SQLCommandBean();
                Connection connection = null;
                AverageUnitMgr averageUnitMgr = AverageUnitMgr.getInstance();
                try {
                    connection = averageUnitMgr.getDatabaseConnection();
                    forQuery.setConnection(connection);
                    forQuery.setSQLQuery(query);
                    forQuery.setparams(SQLparams);
                    
                    queryResult = forQuery.executeQuery();
                } catch (SQLException ex) {
                    logger.error(ex.getMessage());
                } catch(UnsupportedTypeException uste) {
                    logger.error("***** " + uste.getMessage());
                } catch(Exception exception) {
                    logger.error("An exception has been thrown " + exception.getMessage());
                } finally {
                    try {
                        connection.close();
                    } catch(SQLException sex) {
                        logger.error("troubles closing connection " + sex.getMessage());
                    }
                }
                if(queryResult.size() > 0){
                    Row r = null;
                    Enumeration e = queryResult.elements();
                    String id = new String("");
                    
                    while(e.hasMoreElements()) {
                        r = (Row) e.nextElement();
                        try {
                            id = r.getString("USER_ID");
                        } catch (NoSuchColumnException ex) {
                            logger.error(ex.getMessage());
                        }
                    }
                    MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
                    ArrayList eqList = maintainableMgr.getEquAsBusObjects();
                    String sEquipments = new String("");
                    for(int i = 0; i < eqList.size(); i++){
                        if(i != 0){
                            sEquipments = sEquipments + ";";
                        }
                        WebBusinessObject wboTemp = (WebBusinessObject) eqList.get(i);
                        sEquipments = sEquipments + ((String)wboTemp.getAttribute("unitName"));
                    }
                    out.print("login=true,id=" + id + ",eqList=" + sEquipments);
                } else {
                    out.print("login=false");
                }
                break;
                
            case 2:
                double iScore = 0;
                String sUserID = wbo.getAttribute("userId").toString();
                String sEquipmentName = wbo.getAttribute("equipmentName").toString();
                String sWorkingHours = wbo.getAttribute("workingHours").toString();
                String sNote = wbo.getAttribute("note").toString();
                MaintainableMgr unit =  MaintainableMgr.getInstance();
                
                Vector equipmentVec = new Vector();
                try {
                    equipmentVec = unit.getOnArbitraryKey(sEquipmentName, "key2");
                } catch (SQLException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                WebBusinessObject equipment = new WebBusinessObject();
                if(equipmentVec.size() > 0){
                    equipment = (WebBusinessObject) equipmentVec.get(0);
                }
                
                int totalRate = 0 ;
                String checkUpdate = null;
                String unitScheduleId = null;
                String equipUnit = (String) equipment.getAttribute("id");
                
                String categoryId = (String) equipment.getAttribute("parentId");
                
                WebBusinessObject Average = new WebBusinessObject();
                WebBusinessObject averageUpdate = new WebBusinessObject();
                
                Average.setAttribute("current_Reading",sWorkingHours);
                Average.setAttribute("description",sNote);
                Average.setAttribute("unit", equipment.getAttribute("id"));
                averageUnitMgr = AverageUnitMgr.getInstance();
                checkUpdate=averageUnitMgr.getTrueUpdate(equipUnit);
                
                long now= timenow();
                testing();
                if (checkUpdate!=null) {
                    averageUpdate = averageUnitMgr.getOnSingleKey(checkUpdate);
                    String prevDate = (String) averageUpdate.getAttribute("entry_Time");
                    
                    if(averageUnitMgr.updateAverage(Average,averageUpdate,prevDate,now)){
                        out.print("save=true");
                    }else{
                        out.print("save=fasle");
                    }
                } else {
                    try {
                        if(averageUnitMgr.saveObject(Average, session, now))
                            out.print("save=true");
                        else
                            out.print("save=fasle");
                    } catch (NoUserInSessionException noUser) {
                        out.print("save=fasle");
                    }
                }
                
                
                break;
                
            default:
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
    
    public String getServletInfo() {
        return "Short description";
    }
    
    protected int getOpCode(String opName) {
        if(opName.equalsIgnoreCase("login")){
            return 1;
        }
        
        if(opName.equalsIgnoreCase("save")){
            return 2;
        }
        return 0;
    }
    
    public long timenow() {
        Date d = Calendar.getInstance().getTime();
        long nowTime = d.getTime();
        return nowTime;
    }
    
    void testing() {
        Date d = Calendar.getInstance().getTime();
        long id = d.getTime();
        String stringID = new Long(id).toString();
        String test = new String("1175358649687");
        Long l = new Long(test);
        long sl = l.longValue();
        d.setTime(sl);
    }
}
