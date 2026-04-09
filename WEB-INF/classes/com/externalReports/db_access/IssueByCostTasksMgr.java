package com.externalReports.db_access;

import com.maintenance.common.Tools;
import com.maintenance.db_access.CostResultIemMgr;
import com.maintenance.db_access.ItemsWithAvgPriceItemDataMgr;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;

import java.util.*;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.apache.log4j.xml.DOMConfigurator;

public class IssueByCostTasksMgr extends RDBGateWay {

    private static IssueByCostTasksMgr issueByCostTasksMgr = new IssueByCostTasksMgr();
    private CostResultIemMgr costResultIemMgr = CostResultIemMgr.getInstance();
    private ItemsWithAvgPriceItemDataMgr avgPriceItemDataMgr = ItemsWithAvgPriceItemDataMgr.getInstance();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public IssueByCostTasksMgr() {
    }

    public static IssueByCostTasksMgr getInstance() {
        logger.info("Getting issueByCostTasksMgr Instance ....");
        return issueByCostTasksMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("issue_by_cost_tasks.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document . Message : " + e.getMessage());
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        return null;
    }

    public Vector getSampleReport(WebBusinessObject wboCritaria) {
        WebBusinessObject wbo;
        String stringCostTasks, issueId, stringSparePartsCost;
        double costTasks, costSpareParts;
        Connection connection = null;
        Vector params = new Vector();
        Vector<Row> queryResult = new Vector();
        Vector<WebBusinessObject> resultWbo = new Vector();
        SQLCommandBean commandBean = new SQLCommandBean();

        String beginDate = (String) wboCritaria.getAttribute("beginDate");
        String endDate = (String) wboCritaria.getAttribute("endDate");
        String unitId = (String) wboCritaria.getAttribute("unitId");
        String issueTitle = (String) wboCritaria.getAttribute("issueTitle");
        String orderBy = (String) wboCritaria.getAttribute("orderBy");

        StringBuilder buffer = new StringBuilder("SELECT * FROM ");
        buffer.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ");
        buffer.append("ACTUAL_END_DATE").append(" BETWEEN ? AND ? ");

        params.addElement(new DateValue(Tools.getBeginDate(beginDate)));
        params.addElement(new DateValue(Tools.getEndDate(endDate)));

        if (unitId != null) {
            buffer.append("AND UNIT_ID").append(" = ? ");
            params.addElement(new StringValue(unitId));
        }

        if ("Emergency".equals(issueTitle)) {
            buffer.append("AND SCHEDULE_ID").append(" = '1' ");
        } else if ("notEmergency".equals(issueTitle)) {
            buffer.append("AND SCHEDULE_ID").append(" != '1' ");
        }
        buffer.append("ORDER BY TO_NUMBER(UNIT_ID),");
        buffer.append("TO_NUMBER(ISSUE_ID) ");

        if ("asc".equals(orderBy)) {
            buffer.append("ASC");
        } else {
            buffer.append("DESC");
        }

        try {
            connection = dataSource.getConnection();
            commandBean.setConnection(connection);
            commandBean.setSQLQuery(buffer.toString().trim());
            commandBean.setparams(params);

            queryResult = commandBean.executeQuery();
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        for (Row row : queryResult) {
            wbo = super.fabricateBusObj(row);

            // init. cost tasks
            costTasks = 0.00;

            issueId = (String) wbo.getAttribute("issueId");
            stringCostTasks = (String) wbo.getAttribute("costTasks");

            try {
                costTasks = Double.parseDouble(stringCostTasks);
                costTasks = Tools.round(costTasks, 2);
            } catch (Exception ex) {
                logger.error(ex.getMessage());
            }

            stringCostTasks = Tools.getCurrency(stringCostTasks);

            // cost spare parts.
            costSpareParts = costResultIemMgr.getCostItemIssue(issueId);
            stringSparePartsCost = String.valueOf(costSpareParts);
            stringSparePartsCost = Tools.getCurrency(stringSparePartsCost);

            // set spare parts and tasks cost in wbo
            wbo.setAttribute("costTasks", stringCostTasks);
            wbo.setAttribute("dcostTasks", costTasks);

            wbo.setAttribute("costItems", stringSparePartsCost);
            wbo.setAttribute("dcostItems", costSpareParts);

            resultWbo.addElement(wbo);
        }

        return resultWbo;
    }

    public Vector getSampleFullReport(WebBusinessObject wboCritaria) {
        WebBusinessObject wbo;
        String stringCostTasks, issueId, stringSparePartsCost;
        double costTasks, costSpareParts = 0;
        Connection connection = null;
        Vector params = new Vector();
        Vector<Row> queryResult = new Vector();
        Vector<WebBusinessObject> resultWbo = new Vector();
        SQLCommandBean commandBean = new SQLCommandBean();

        String beginDate = (String) wboCritaria.getAttribute("beginDate");
        String endDate = (String) wboCritaria.getAttribute("endDate");
        String unitId = (String) wboCritaria.getAttribute("unitId");
        String issueTitle = (String) wboCritaria.getAttribute("issueTitle");
        String orderBy = (String) wboCritaria.getAttribute("orderBy");

        StringBuilder buffer = new StringBuilder("SELECT * FROM ");
        buffer.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ");
        buffer.append("ACTUAL_END_DATE").append(" BETWEEN ? AND ? ");

        params.addElement(new DateValue(Tools.getBeginDate(beginDate)));
        params.addElement(new DateValue(Tools.getEndDate(endDate)));

        if (unitId != null) {
            buffer.append("AND UNIT_ID").append(" = ? ");
            params.addElement(new StringValue(unitId));
        }

        if ("Emergency".equals(issueTitle)) {
            buffer.append("AND SCHEDULE_ID").append(" = '1' ");
        } else if ("notEmergency".equals(issueTitle)) {
            buffer.append("AND SCHEDULE_ID").append(" != '1' ");
        }
        buffer.append("ORDER BY TO_NUMBER(UNIT_ID),");
        buffer.append("TO_NUMBER(ISSUE_ID) ");

        if ("asc".equals(orderBy)) {
            buffer.append("ASC");
        } else {
            buffer.append("DESC");
        }

        try {
            connection = dataSource.getConnection();
            commandBean.setConnection(connection);
            commandBean.setSQLQuery(buffer.toString().trim());
            commandBean.setparams(params);

            queryResult = commandBean.executeQuery();
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        for (Row row : queryResult) {
            wbo = super.fabricateBusObj(row);

            // init. cost tasks
            costTasks = 0.00;

            issueId = (String) wbo.getAttribute("issueId");
            stringCostTasks = (String) wbo.getAttribute("costTasks");

            try {
                costTasks = Double.parseDouble(stringCostTasks);
                costTasks = Tools.round(costTasks, 2);
            } catch (Exception ex) {
                logger.error(ex.getMessage());
            }

            stringCostTasks = Tools.getCurrency(stringCostTasks);
            try {
                // cost spare parts.
                costSpareParts = Double.parseDouble(avgPriceItemDataMgr.getIssuePartsCost(issueId));
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(IssueByCostTasksMgr.class.getName()).log(Level.SEVERE, null, ex);
            } catch (UnsupportedConversionException ex) {
                Logger.getLogger(IssueByCostTasksMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            stringSparePartsCost = String.valueOf(costSpareParts);
            stringSparePartsCost = Tools.getCurrency(stringSparePartsCost);

            // set spare parts and tasks cost in wbo
            wbo.setAttribute("costTasks", stringCostTasks);
            wbo.setAttribute("dcostTasks", costTasks);

            wbo.setAttribute("costItems", stringSparePartsCost);
            wbo.setAttribute("dcostItems", costSpareParts);

            resultWbo.addElement(wbo);
        }

        return resultWbo;
    }

    public Vector fabricateSampleReport(Vector vector, String fabricateAttrbute, String otherAttrbute) {
        WebBusinessObject wbo, wboDetails;
        String fabricateValue, otherValue;
        Vector result = new Vector();
        Vector list = new Vector();

        int i = 0, j = 0;
        for (i = 0; i < vector.size(); i++) {
            wbo = (WebBusinessObject) vector.get(i);
            list = new Vector();
            list.addElement(wbo);

            fabricateValue = (String) wbo.getAttribute(fabricateAttrbute);
            otherValue = (String) wbo.getAttribute(otherAttrbute);

            wboDetails = new WebBusinessObject();
            wboDetails.setAttribute(fabricateAttrbute, fabricateValue);
            wboDetails.setAttribute(otherAttrbute, otherValue);

            for (j = i + 1; j < vector.size(); j++) {
                wbo = (WebBusinessObject) vector.get(j);
                if (fabricateValue != null && fabricateValue.equals((String) wbo.getAttribute(fabricateAttrbute))) {
                    list.addElement(wbo);
                } else {
                    j--;
                    break;
                }
            }

            wboDetails.setAttribute("list", list);
            result.addElement(wboDetails);

            i = j;
        }

        return result;
    }

    @Override
    protected void initSupportedQueries() {
    return; //    throw new UnsupportedOperationException("Not supported yet.");
    }
}
