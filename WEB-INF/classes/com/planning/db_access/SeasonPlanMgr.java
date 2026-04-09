package com.planning.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class SeasonPlanMgr extends RDBGateWay {

    private static SeasonPlanMgr planMgr = new SeasonPlanMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static SeasonPlanMgr getInstance() {
        logger.info("Getting PlanMgr Instance ....");
        return planMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("season_plan.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;

    }

    public boolean saveObject(WebBusinessObject seasonPlanWbo, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Connection connection = null;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) seasonPlanWbo.getAttribute("seasonId")));
        params.addElement(new StringValue((String) seasonPlanWbo.getAttribute("planId")));
        params.addElement(new StringValue((String) seasonPlanWbo.getAttribute("notes")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("insertSeasonPlan").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            cashData();
            
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

    public boolean saveMultiObject(String planId,
                                   String[] seasonIdArr,
                                   String[] notesArr,
                                   HttpSession s) {

        Connection connection = null;
        WebBusinessObject seasonPlanWbo = null;

        int offset = 0;

        if (seasonIdArr != null) {
            if (notesArr.length > seasonIdArr.length) {
                offset = notesArr.length - seasonIdArr.length;

            }
        }

        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            
            for(int i = 0; i < seasonIdArr.length; i++) {
                seasonPlanWbo = new WebBusinessObject();

                seasonPlanWbo.setAttribute("planId", planId);
                seasonPlanWbo.setAttribute("seasonId", seasonIdArr[i]);
                seasonPlanWbo.setAttribute("notes", (notesArr[i + offset].equals("")) ? "none" : notesArr[i + offset]);
                
                if(!this.saveObject(seasonPlanWbo, s)) {
                    connection.rollback();
                    return false;
                }

                try {
                    Thread.sleep(100);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }

            }

        } catch (Exception ex) {
            try {
                logger.error(ex.getMessage());
                connection.rollback();
            } catch (SQLException ex1) {
                logger.error(ex1.getMessage());
            }
            return false;

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

    public String getAttachedSeasons(String planId) {
	Vector<Row> queryResult = new Vector<Row>();
	Vector params = new Vector();
	SQLCommandBean forQuery = new SQLCommandBean();
	String seasonIdsStr="";
	try {
	   beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(getQuery("getAttachedSeasons").trim());

            params.addElement(new StringValue(planId));
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
            endTransaction();

	}catch(SQLException se) {
            System.out.println("Error In executing Query.............!" + se.getMessage());
	}catch (UnsupportedTypeException ex) {
            Logger.getLogger(SeasonPlanMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
	   for(int i=0;i<queryResult.size();i++){
		try {
		if(i == queryResult.size()-1){
			seasonIdsStr +="'" +((Row) queryResult.get(i)).getString("season_id").toString()+"'";
		}else{
			seasonIdsStr +="'" +((Row) queryResult.get(i)).getString("season_id").toString()+"'"+ ",";
			}
		} catch (NoSuchColumnException ex) {
			Logger.getLogger(SeasonPlanMgr.class.getName()).log(Level.SEVERE, null, ex);
		}

	}
	return seasonIdsStr;

    }

    public Vector getAttachedPlans(String seasonId) {
        Connection connection = null;

        String quary = getQuery("getAttachedPlans").trim();

        Vector param = new Vector();

        param.addElement(new StringValue(seasonId));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(param);
            forQuery.setSQLQuery(quary);
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
        Vector resAsWbo = new Vector();

        Row row;
        for (int i = 0; i < queryResult.size(); i++) {
            row = (Row) queryResult.get(i);
            try {
                WebBusinessObject tempAsWbo = new WebBusinessObject();
                tempAsWbo.setAttribute("planId", row.getString("PLAN_ID"));
                tempAsWbo.setAttribute("planName", row.getString("PLAN_NAME"));
                tempAsWbo.setAttribute("planCode", row.getString("PLAN_CODE"));
                tempAsWbo.setAttribute("planType", row.getString("PLAN_TYPE"));
                tempAsWbo.setAttribute("planDesc", row.getString("PLAN_DESC"));
                tempAsWbo.setAttribute("beginDate", row.getString("BEGIN_DATE"));
                tempAsWbo.setAttribute("endDate", row.getString("END_DATE"));
                resAsWbo.addElement(tempAsWbo);
            } catch (NoSuchColumnException ex) {
                logger.error(ex.getMessage());
            }
        }

        return resAsWbo;
    }

    public ArrayList getCashedTableAsBusObjects() {
        cashData();
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }

        return cashedData;
    }

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("id"));
        }

        return cashedData;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return; //   throw new UnsupportedOperationException("Not supported yet.");
    }

}
