package com.maintenance.servlets;

import com.android.business_objects.LiteWebBusinessObject;
import com.businessfw.hrs.db_access.EmployeeMgr;
import com.clients.db_access.ClientMgr;
import com.maintenance.common.ParseSideMenu;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.*;
import java.util.*;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.*;
import javax.servlet.http.*;

import com.contractor.db_access.MaintainableMgr;

import com.maintenance.common.PDFTextCreator;
import com.maintenance.common.Tools;
import com.maintenance.db_access.*;
import com.silkworm.business_objects.*;

import com.silkworm.util.*;
import com.silkworm.common.*;
import com.silkworm.common.bus_admin.AccountMgr;

import com.tracker.db_access.*;
import com.tracker.business_objects.*;
import com.tracker.common.*;
import com.tracker.engine.IssueStatusFactory;
import com.tracker.engine.AssignedIssueState;

public class ComplexIssueServlet extends TrackerBaseServlet {
    //Initialize Managers
    IssueMgr issueMgr = IssueMgr.getInstance();
    MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
    EmployeeMgr employeeMgr = EmployeeMgr.getInstance();
    SequenceMgr sequenceMgr = SequenceMgr.getInstance();
    DriversHistoryMgr driversMgr = DriversHistoryMgr.getInstance();
    
    //Initialize System Valiables
    AssignedIssueState ais = null;
    
    String viewOrigin = null;
    String page = null;
    String issueId = null;
    
    String UnitName = null;
    String UnitId = null;
    Hashtable tasksHT = new Hashtable();
    WebBusinessObject userObj = null;
    WebBusinessObject eqpWbo = null;
    WebBusinessObject driverWbo = null;
    WebIssue wIssue = new WebIssue();
    WebBusinessObject webIssue = new WebBusinessObject();
    WebBusinessObject wboTemp = new WebBusinessObject();
    LaborComplaintsMgr laborComplaintsMgr=LaborComplaintsMgr.getInstance();
    ComplaintTasksMgr compTasksMgr = ComplaintTasksMgr.getInstance();
    HttpSession   mySession=null;
    Vector eqpsVec = new Vector();
    ArrayList trades=new ArrayList();
    
    private WebBusinessObject myIssue;
    
    private PDFTextCreator pdfTextCreator;
    
    /** Initializes the servlet.
     */
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        servedPage = "/docs/complex/new_Complex_Issue.jsp";
    }
    
    /** Destroys the servlet.
     */
    public void destroy() {
    }
    
    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        super.processRequest(request, response);
        //Define page UTF-8
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        //Get Session
        HttpSession session = request.getSession();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        userObj = (WebBusinessObject) session.getAttribute("loggedUser");
        
        int operation = 0;
        
        try {
            if (request.getParameter("op") == null || request.getParameter("op").equalsIgnoreCase("no")) {
                if(request.getParameter("source") == null){
                    sequenceMgr.updateSequence();
                    
                    //get equipments
                    //   eqpsVec = maintainableMgr.getOnArbitraryDoubleKey("1","key3","0","key5");
                    String []params={"1","0",userObj.getAttribute("projectID").toString()};
                    String []keys={"key3","key5","key11"};
                    eqpsVec=maintainableMgr.getOnArbitraryNumberKey(3,params,keys);
                    
                    if(eqpsVec.size()> 0 && eqpsVec != null){
                        eqpWbo = (WebBusinessObject) eqpsVec.elementAt(0);
                    }
                    request.setAttribute("source","newComplexIssue");
                } else {
                    //get selected equipment
                    eqpWbo = maintainableMgr.getOnSingleKey(request.getParameter("unitName"));
                    String page=(String)request.getParameter("source");
                    if(page.equalsIgnoreCase("viewImages")){
                        sequenceMgr.updateSequence();
                        request.setAttribute("source","viewImages");
                    } else
                        request.setAttribute("source","newComplexIssue");
                }
                
                //Get Sequence before JO insertion
                String JOSequenceStr = sequenceMgr.getSequence();
                
                //get current equipment employee
                if(eqpWbo != null){
                    Vector driverVec = driversMgr.getOnArbitraryDoubleKeyOracle(eqpWbo.getAttribute("id").toString(),"key1",null,"key3");
                    if(driverVec.size()> 0 && driverVec != null){
                        driverWbo = (WebBusinessObject) driverVec.elementAt(0);
                    }
                }
                //get Trades
                trades=new ArrayList();
                TradeMgr tradeMgr=TradeMgr.getInstance();
                ArrayList trades=tradeMgr.getCashedTableAsBusObjects();
                
                servedPage = "/docs/complex/new_Complex_Issue.jsp";
                
                request.setAttribute("trades",trades);
                request.setAttribute("JONo",JOSequenceStr);
                request.setAttribute("equipments", eqpsVec);
                request.setAttribute("currentEqp", eqpWbo);
                request.setAttribute("currentEmp", driverWbo);
                
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
            } else {
                operation = getOpCode((String) request.getParameter("op"));
                ArrayList requestAsArray = ServletUtils.getRequestParams(request);
                ServletUtils.printRequest(requestAsArray);
                
                
                switch (operation) {
                    case 1:
                        IssueMgr issueMgr=IssueMgr.getInstance();
                        ComplexIssueMgr complexIssueMgr=ComplexIssueMgr.getInstance();
                        WebBusinessObject complexIssueWbo=new WebBusinessObject();
                        
                        String eqpName=(String)request.getParameter("unitId");
                        if(eqpName!=null){
                            Vector eqpsByName=maintainableMgr.getOnArbitraryKey(eqpName,"key2");
                            if(eqpsByName.size()>0){
                                
                                //get request data
                                UnitId = request.getParameter("unitName");
                                
                                //get equipment site
                                WebBusinessObject wboTemp = maintainableMgr.getOnSingleKey(UnitId);
                                wIssue.setAttribute("project_name", wboTemp.getAttribute("site").toString());
                                
                                String maintDesc="";
                                
                                if(request.getParameter("maintDesc")!=null) {
                                    if(request.getParameter("maintDesc").equals("")||request.getParameter("maintDesc").equalsIgnoreCase("null"))
                                        maintDesc="No Description";
                                    else
                                        maintDesc=request.getParameter("maintDesc").toString();
                                }else
                                    maintDesc="No Description";
                                
                                String[] indexArr = request.getParameterValues("index");
                                String[] tradeArr = request.getParameterValues("tradeId");
                                String[] eqTypeArr= request.getParameterValues("attachedOn");
                                String[] descArr = request.getParameterValues("maintDesc");
                                
                                //Save emergency Job order
                                if (issueMgr.saveEmgObject(request, wIssue, session)) {
                                    
                                    if(complexIssueMgr.saveObject(tradeArr,eqTypeArr,descArr,indexArr,issueMgr.getIssueID(),session)){
                                        request.setAttribute("Status", "OK");
                                        webIssue = issueMgr.getOnSingleKey(issueMgr.getIssueID());
                                        request.setAttribute("issueID", issueMgr.getIssueID());
                                        request.setAttribute("businessID", webIssue.getAttribute("businessID").toString());
                                        request.setAttribute("sID", issueMgr.getSID());
                                        
                                        
                                        MaintainableMgr maintainableMgr=MaintainableMgr.getInstance();
                                        WebBusinessObject eqWbo=maintainableMgr.getOnSingleKey(webIssue.getAttribute("unitId").toString());
                                        request.getSession().setAttribute("IssueWbo",webIssue);
                                        request.getSession().setAttribute("equipmentWbo",eqWbo);
                                        request.getSession().setAttribute("joType","complex");
                                        /****************************************************/
                                        String scheduleUnitID = (String) webIssue.getAttribute("unitScheduleID");
                                        
                                        EquipmentStatusMgr equipmentStatusMgr = EquipmentStatusMgr.getInstance();
                                        WebBusinessObject wboState = equipmentStatusMgr.getLastStatus(UnitId);
                                        int currentStatus = 1;
                                        if(wboState != null){
                                            String stateID = (String) wboState.getAttribute("stateID");
                                            currentStatus = new Integer(stateID).intValue();
                                        }
                                        if(currentStatus == 1){
                                            Calendar c = Calendar.getInstance();
                                            WebBusinessObject wboStatus = new WebBusinessObject();
                                            wboStatus.setAttribute("equipmentID", UnitId);
                                            wboStatus.setAttribute("stateID", new String("2"));
                                            wboStatus.setAttribute("note", "Out of Line");
                                            wboStatus.setAttribute("beginDate", (c.get(Calendar.MONTH) + 1) + "/" + c.get(Calendar.DAY_OF_MONTH) + "/" + c.get(Calendar.YEAR));
                                            wboStatus.setAttribute("hour", new Integer(c.get(Calendar.HOUR_OF_DAY)).toString());
                                            wboStatus.setAttribute("minute", new Integer(c.get(Calendar.MINUTE)).toString());
                                            equipmentStatusMgr.saveObject(wboStatus, request.getSession());
                                        }
                                        /////////////////
                                        
                                        
                                /* Get Eq_ID from Unit Schedule to check if this Eq is attached or not
                                 check if the equipment id has record(s) in attach_eqps table and
                                 the separation_date equl null. this mean this eq is attached.*/
                                        Vector attachedEqps=new Vector();
                                        Vector minorAttachedEqps=new Vector();
                                        int attachFlag=0;
                                        SupplementMgr supplementMgr=SupplementMgr.getInstance();
                                        UnitScheduleMgr unitScheduleMgr=UnitScheduleMgr.getInstance();
                                        WebBusinessObject unit_sch_wbo=unitScheduleMgr.getOnSingleKey(scheduleUnitID);
                                        String Eq_ID=(String)unit_sch_wbo.getAttribute("unitId");
                                        attachedEqps=supplementMgr.search(Eq_ID);
                                        minorAttachedEqps=supplementMgr.searchAllowedEqps(Eq_ID);
                                        String attachedEqFlag="";
                                        if(attachedEqps.size()>0) {
                                            attachedEqFlag="attached";
                                        }else{
                                            if(minorAttachedEqps.size()>0) {
                                                attachedEqFlag="attached";
                                            }else{
                                                attachedEqFlag="notatt";
                                            }
                                            
                                        }
                                        request.getSession().setAttribute("attFlag",attachedEqFlag);
                                        
                                        /******Create Dynamic contenet of Issue menu *******/
                                        //open Jar File
                                        MetaDataMgr metaMgr=MetaDataMgr.getInstance();
                                        metaMgr.setMetaData("xfile.jar");
                                        ParseSideMenu parseSideMenu=new ParseSideMenu();
                                        Vector issueMenu=new Vector();
                                        String mode=(String)request.getSession().getAttribute("currentMode");
                                        issueMenu=parseSideMenu.parseSideMenu(mode,"issue_menu.xml","c");
                                        
                                        metaMgr.closeDataSource();
                                        
                                        /* Add ids for links*/
                                        Vector linkVec=new Vector();
                                        String link="";
                                        
                                        Hashtable style=new Hashtable();
                                        style=(Hashtable)issueMenu.get(0);
                                        String title=style.get("title").toString();
                                        title+="   "+webIssue.getAttribute("businessID").toString();
                                        style.remove("title");
                                        style.put("title",title);
                                        
                                        for(int i=1;i<issueMenu.size()-1;i++){
                                            linkVec=new Vector();
                                            link="";
                                            linkVec=(Vector)issueMenu.get(i);
                                            link=(String)linkVec.get(1);
                                            
                                            if(link.equalsIgnoreCase("AssignedIssueServlet?op=assign&state=SCHEDULE&viewOrigin=null&direction=forward&issueId=")){
                                                String IssueCurrentStatus=(String)wIssue.getAttribute("currentStatus");
                                                
                                                if(IssueCurrentStatus!=null){
                                                    if(IssueCurrentStatus.equalsIgnoreCase("Schedule")||IssueCurrentStatus.equalsIgnoreCase("Rejected")){
                                                        link+=issueMgr.getIssueID()+"&attachedEqFlag="+attachedEqFlag+"&equipmentID="+UnitId;
                                                    }else{
                                                        issueMenu.remove(i);
                                                        i--;
                                                        continue;
                                                    }
                                                }else{
                                                    link+=issueMgr.getIssueID()+"&attachedEqFlag="+attachedEqFlag+"&equipmentID="+UnitId;
                                                }
                                                
                                            }else{
                                                link+=issueMgr.getIssueID()+"&attachedEqFlag="+attachedEqFlag+"&equipmentID="+UnitId;
                                            }
                                            linkVec.remove(1);
                                            linkVec.add(link);
                                            
                                        }
                                        
                                        Hashtable topMenu=new Hashtable();
                                        Vector tempVec=new Vector();
                                        topMenu=(Hashtable)request.getSession().getAttribute("topMenu");
                                        
                                        if(topMenu!=null && topMenu.size()>0){
                                            
                                /* 1- Get the current Side menu
                                 * 2- Check Menu Type
                                 * 3- insert menu object to top menu accordding to it's type
                                 */
                                            
                                            Vector menuType=new Vector();
                                            Vector currentSideMenu=(Vector)request.getSession().getAttribute("sideMenuVec");
                                            if(currentSideMenu!=null && currentSideMenu.size()>0){
                                                linkVec=new Vector();
                                                
                                                // the element # 1 in menu is to view the object
                                                linkVec=(Vector)currentSideMenu.get(1);
                                                
                                                // size-1 becouse the menu type is the last element in vector
                                                
                                                menuType=(Vector)currentSideMenu.get(currentSideMenu.size()-1);
                                                
                                                if(menuType!=null && menuType.size()>0){
                                                    topMenu.put((String)menuType.get(1),linkVec);
                                                }
                                                
                                            }
                                            request.getSession().setAttribute("topMenu",topMenu);
                                        }
                                        
                                        request.getSession().setAttribute("sideMenuVec",issueMenu);
                                        /*Ebd of Menu*/
                                        
                                        /****************************************************/
                                    } else{
                                        request.setAttribute("Status", "Failed");
                                    }
                                    
                                } else {
                                    request.setAttribute("Status", "Failed");
                                }
                                
                            }else {
                                request.setAttribute("Status", "diffName");
                            }
                        }else {
                            request.setAttribute("Status", "diffName");
                        }
                        
                        servedPage = "/docs/complex/issue_cmplx_saving.jsp";
                        
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                        
                    case 2:
                        Vector itemListTemp = new Vector();
                        String page=request.getParameter("page").toString();
                        String projectname = request.getParameter("projectName");
                        ais = IssueStatusFactory.getStateClass(IssueStatusFactory.SCHEDULE);
                        QuantifiedMntenceMgr quantifiedMgr = QuantifiedMntenceMgr.getInstance();
                        issueId = request.getParameter(IssueConstants.ISSUEID);
                        issueMgr=IssueMgr.getInstance();
                        myIssue = issueMgr.getOnSingleKey(issueId);
                        
                        String uSID = (String) myIssue.getAttribute("unitScheduleID");
                        String  issueTitle = request.getParameter(IssueConstants.ISSUETITLE);
                        
                        
                        filterName = request.getParameter("filterName");
                        filterValue = request.getParameter("filterValue");
                        String attachedEqFlag=(String)request.getParameter("attachedEqFlag");
                        
                        Vector itemList = new Vector();
                        uSID=issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString();
                        QuantMntenceCmplxMgr quantMntenceCmplxMgr=QuantMntenceCmplxMgr.getInstance();
                        if(page.equalsIgnoreCase("localspares")){
                            servedPage = "/docs/complex/add_Local_parts_cmplx.jsp";
                            itemListTemp = quantMntenceCmplxMgr.getSpecialItemSchedule(issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString(),"1");
                        }else{
                            servedPage = "/docs/complex/complex_config_parts.jsp";
                            itemListTemp = quantMntenceCmplxMgr.getSpecialItemSchedule(issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString(),"0");
                        }
                        UnitScheduleMgr unitScheduleMgr=UnitScheduleMgr.getInstance();
                        WebBusinessObject web=unitScheduleMgr.getOnSingleKey(uSID);
                        
                        String eID=web.getAttribute("periodicId").toString();
//                        if(eID.equalsIgnoreCase("1")||eID.equalsIgnoreCase("2")){
//                            itemList=quantMntenceCmplxMgr.getSpecialItemSchedule(uSID,"0");
//                        } else{
                        itemList = itemListTemp;
//                        }
                        
                        Vector attachedEqps=new Vector();
                        Vector minorAttachedEqps=new Vector();
                        int attachFlag=0;
                        SupplementMgr supplementMgr=SupplementMgr.getInstance();
                        unitScheduleMgr=UnitScheduleMgr.getInstance();
                        WebBusinessObject unit_sch_wbo=unitScheduleMgr.getOnSingleKey(uSID);
                        String Eq_ID=(String)unit_sch_wbo.getAttribute("unitId");
                        attachedEqps=supplementMgr.search(Eq_ID);
                        minorAttachedEqps=supplementMgr.searchAllowedEqps(Eq_ID);
                        if(attachedEqps.size()>0) {
                            request.setAttribute("attachedEqFlag","attached");
                        }else{
                            if(minorAttachedEqps.size()>0) {
                                request.setAttribute("attachedEqFlag","attached");
                            }else{
                                request.setAttribute("attachedEqFlag","notAtt");
                            }
                        }
                        
                        complexIssueMgr=ComplexIssueMgr.getInstance();
                        TradeMgr tradeMgr=TradeMgr.getInstance();
                        complexIssueWbo=null;
                        WebBusinessObject tradeWbo=null;
                        String tradeName="";
                        Vector complexIssues=complexIssueMgr.getOnArbitraryKey(issueId,"key1");
                        for(int i=0;i<complexIssues.size();i++){
                            complexIssueWbo=new WebBusinessObject();
                            tradeWbo=new WebBusinessObject();
                            tradeName="";
                            complexIssueWbo=(WebBusinessObject)complexIssues.get(i);
                            tradeWbo=tradeMgr.getOnSingleKey(complexIssueWbo.getAttribute("tradeId").toString());
                            tradeName=tradeWbo.getAttribute("tradeName").toString();
                            complexIssueWbo.setAttribute("tradeName",tradeName);
                        }
                        
                        request.setAttribute("complexIssues",complexIssues);
                        servedPage = "/docs/complex/complex_config_parts.jsp";
                        request.setAttribute("data", itemList);
                        request.setAttribute("attachedEqFlag", attachedEqFlag);
                        request.setAttribute("uID",uSID);
                        request.setAttribute(IssueConstants.ISSUEID, issueId);
                        request.setAttribute(IssueConstants.ISSUETITLE, issueTitle);
                        request.setAttribute("filter",filterName);
                        request.setAttribute("filterValue",filterValue);
                        request.setAttribute("projectName", projectname);
                        request.setAttribute(IssueConstants.STATE,ais);
                        
                        request.setAttribute("page",servedPage);
                        this.forwardToServedPage(request, response);
                        
                        break;
                        
                    case 3:
                        //// begin ////
                        WebBusinessObject wboIssue = new WebBusinessObject();
                        page=request.getParameter("page").toString();
                        quantMntenceCmplxMgr=QuantMntenceCmplxMgr.getInstance();
                        issueMgr=IssueMgr.getInstance();
                        issueId = request.getParameter("issueId");
                        myIssue = issueMgr.getOnSingleKey(issueId);
                        uSID=issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString();
                        itemListTemp = new Vector();
                        itemList = new Vector();
                        
                        if(page.equalsIgnoreCase("localspares")){
                            servedPage = "/docs/complex/add_Local_parts_cmplx.jsp";
                            itemListTemp = quantMntenceCmplxMgr.getSpecialItemSchedule(issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString(),"1");
                        }else{
                            servedPage = "/docs/complex/complex_config_parts.jsp";
                            itemListTemp = quantMntenceCmplxMgr.getSpecialItemSchedule(issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString(),"0");
                        }
                        
                        unitScheduleMgr=UnitScheduleMgr.getInstance();
                        web=unitScheduleMgr.getOnSingleKey(uSID);
                        eID=web.getAttribute("periodicId").toString();
                        
                        String[] TotaleCost=request.getParameterValues("totale");
                        
                        try {
                            if(page.equalsIgnoreCase("localspares")){
                                quantMntenceCmplxMgr.deleteOnArbitraryDoubleKey(uSID, "key1","1","key2");
                            }else{
                                quantMntenceCmplxMgr.deleteOnArbitraryDoubleKey(uSID, "key1","0","key2");
                            }
                            
                            issueMgr.updateTotalCost(new Float(TotaleCost[0]).floatValue(), issueId);
                            
                            /////////////////
                            
                            String[] quantity = request.getParameterValues("qun");
                            String[] price = request.getParameterValues("price");
                            String[] cost = request.getParameterValues("cost");
                            String[] note = request.getParameterValues("note");
                            String[] id = request.getParameterValues("code");
                            String[] cmplxIssueIndex = request.getParameterValues("maintTypeIndex");
                            String[] dates = request.getParameterValues("date");
                            String isDirectPrch=request.getParameter("isDirectPrch").toString();
                            String attOn=(String)request.getParameter("attachedOn");
                            
                            if(attOn!=null) {
                                attOn=attOn.substring(0,attOn.length()-1);
                                String[] attachedOn=attOn.split("!");
                                if(quantMntenceCmplxMgr.saveObject2(quantity,price,cost,note,cmplxIssueIndex,issueId,id,uSID,isDirectPrch,attachedOn,session,dates))
                                    request.setAttribute("status","ok");
                                else
                                    request.setAttribute("status","fail");
                            }else{
                                String[] attachedOn=new String [id.length];
                                for(int i=0;i<id.length;i++)
                                    attachedOn[i]="2";
                                if(quantMntenceCmplxMgr.saveObject2(quantity,price,cost,note,cmplxIssueIndex,issueId,id,uSID,isDirectPrch,attachedOn,session,dates))
                                    request.setAttribute("status","ok");
                                else
                                    request.setAttribute("status","fail");
                            }
                            wboIssue = issueMgr.getOnSingleKey(issueId);
//                            if(wboIssue.getAttribute("issueTitle").toString().equals("Emergency")){
//                                issueMgr.getUpdateCaseConfigEmg(wboIssue.getAttribute("unitScheduleID").toString());
//                            }
                            ////////////////////
                            
                        } catch(Exception ex) {
                            logger.error("Saving Assigned Issue Exception: " + ex.getMessage());
                        }
                        //Begin Save PDF
                        
                        WebBusinessObject waUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
                        String userID = waUser.getAttribute("userId").toString();
                        itemList = new Vector();
                        
                        quantMntenceCmplxMgr=QuantMntenceCmplxMgr.getInstance();
                        if(page.equalsIgnoreCase("localspares")){
                            servedPage = "/docs/complex/add_Local_parts_cmplx.jsp";
                            itemListTemp = quantMntenceCmplxMgr.getSpecialItemSchedule(issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString(),"1");
                        }else{
                            servedPage = "/docs/complex/complex_config_parts.jsp";
                            itemListTemp = quantMntenceCmplxMgr.getSpecialItemSchedule(issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString(),"0");
                        }
                        
                        if(eID.equalsIgnoreCase("1")||eID.equalsIgnoreCase("2")){
                            
                            if(page.equalsIgnoreCase("localspares")){
                                itemList=quantMntenceCmplxMgr.getSpecialItemSchedule(uSID,"1");
                            }else{
                                itemList=quantMntenceCmplxMgr.getSpecialItemSchedule(uSID,"0");
                            }
                        } else{
                            itemList = itemListTemp;
                        }
                        
                        /// begin ///
                        
                        attachedEqps=new Vector();
                        minorAttachedEqps=new Vector();
                        attachFlag=0;
                        supplementMgr=SupplementMgr.getInstance();
                        unitScheduleMgr=UnitScheduleMgr.getInstance();
                        unit_sch_wbo=unitScheduleMgr.getOnSingleKey(uSID);
                        Eq_ID=(String)unit_sch_wbo.getAttribute("unitId");
                        attachedEqps=supplementMgr.search(Eq_ID);
                        minorAttachedEqps=supplementMgr.searchAllowedEqps(Eq_ID);
                        if(attachedEqps.size()>0) {
                            request.setAttribute("attachedEqFlag","attached");
                        }else{
                            if(minorAttachedEqps.size()>0) {
                                request.setAttribute("attachedEqFlag","attached");
                            }else{
                                request.setAttribute("attachedEqFlag","notAtt");
                            }
                        }
                        
                        complexIssueMgr=ComplexIssueMgr.getInstance();
                        tradeMgr=TradeMgr.getInstance();
                        complexIssueWbo=null;
                        tradeWbo=null;
                        tradeName="";
                        complexIssues=complexIssueMgr.getOnArbitraryKey(issueId,"key1");
                        for(int i=0;i<complexIssues.size();i++){
                            complexIssueWbo=new WebBusinessObject();
                            tradeWbo=new WebBusinessObject();
                            tradeName="";
                            complexIssueWbo=(WebBusinessObject)complexIssues.get(i);
                            tradeWbo=tradeMgr.getOnSingleKey(complexIssueWbo.getAttribute("tradeId").toString());
                            tradeName=tradeWbo.getAttribute("tradeName").toString();
                            complexIssueWbo.setAttribute("tradeName",tradeName);
                        }
                        
                        request.setAttribute("data", itemList);
                        request.setAttribute("complexIssues",complexIssues);
                        request.setAttribute("uID",uSID);
                        request.setAttribute(IssueConstants.ISSUEID, issueId);
                        request.setAttribute("issueId", issueId);
                        request.setAttribute("page",servedPage);
                        
                        this.forwardToServedPage(request, response);
                        break;
                        
                    case 4:
                        
                        servedPage = "/docs/complex/add_workers_cmplx.jsp";
                        IssueTasksCmplxMgr issueTasksCmplxMgr= IssueTasksCmplxMgr.getInstance();
                        EmpBasicMgr empBasicMgr = EmpBasicMgr.getInstance();
                        EmployeeMgr employeeMgr = EmployeeMgr.getInstance();
                        Vector vecIssueTasks = new Vector();
                        try {
                            vecIssueTasks = issueTasksCmplxMgr.getOnArbitraryKey(request.getParameter("issueId"), "key1");
                        } catch (SQLException ex) {
                            ex.printStackTrace();
                        } catch (Exception ex) {
                            ex.printStackTrace();
                        }
                        
                        request.setAttribute("arrWorkers", employeeMgr.getCashedTableAsBusObjects());
                        request.setAttribute("vecIssueTasks", vecIssueTasks);
                        request.setAttribute("page",servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                        
                    case 5:
                        servedPage = "/docs/complex/add_workers_cmplx.jsp";
                        
                        TaskExecutionCmplxMgr taskExecutionCmplxMgr = TaskExecutionCmplxMgr.getInstance();
                        if (taskExecutionCmplxMgr.saveObject(request)) {
                            request.setAttribute("Status", "OK");
                            servedPage = "/docs/complex/view_workers_cmplx.jsp";
                            issueTasksCmplxMgr= IssueTasksCmplxMgr.getInstance();
                            empBasicMgr = EmpBasicMgr.getInstance();
                            employeeMgr = EmployeeMgr.getInstance();
                            vecIssueTasks = new Vector();
                            Vector taskExecCmplx=new Vector();
                            taskExecutionCmplxMgr=TaskExecutionCmplxMgr.getInstance();
                            try {
                                taskExecCmplx=taskExecutionCmplxMgr.getOnArbitraryKey(request.getParameter("issueId"), "key3");
                                
                            } catch (SQLException ex) {
                                ex.printStackTrace();
                            } catch (Exception ex) {
                                ex.printStackTrace();
                            }
                            
                            WebBusinessObject taskExecWbo=new WebBusinessObject();
                            WebBusinessObject empWbo=new WebBusinessObject();
                            EmployeeMgr empMgr = EmployeeMgr.getInstance();
                            issueTasksCmplxMgr=IssueTasksCmplxMgr.getInstance();
                            TaskMgr taskMgr=TaskMgr.getInstance();
                            WebBusinessObject taskWbo=new WebBusinessObject();
                            complexIssueMgr=ComplexIssueMgr.getInstance();
                            tradeMgr=TradeMgr.getInstance();
                            WebBusinessObject issueTasksCmplxWbo=new WebBusinessObject();
                            for(int i=0;i<taskExecCmplx.size();i++){
                                taskExecWbo=new WebBusinessObject();
                                taskWbo=new WebBusinessObject();
                                LiteWebBusinessObject empLiteWbo=new LiteWebBusinessObject();
                                issueTasksCmplxWbo=new WebBusinessObject();
                                taskExecWbo=(WebBusinessObject)taskExecCmplx.get(i);
                                issueTasksCmplxWbo=issueTasksCmplxMgr.getOnSingleKey(taskExecWbo.getAttribute("issueTaskID").toString());
                                taskWbo=taskMgr.getOnSingleKey(issueTasksCmplxWbo.getAttribute("codeTask").toString());
                                empLiteWbo=empMgr.getOnSingleKey(taskExecWbo.getAttribute("laborID").toString());
                                
                                complexIssues=new Vector();
                                tradeName="";
                                String x=taskExecWbo.getAttribute("issueId").toString();
                                String y=taskExecWbo.getAttribute("cmplxIssueIndex").toString();
                                complexIssues=complexIssueMgr.getOnArbitraryDoubleKey(x,"key1",y,"key3");
                                complexIssueWbo=(WebBusinessObject)complexIssues.get(0);
                                
                                tradeWbo=tradeMgr.getOnSingleKey(complexIssueWbo.getAttribute("tradeId").toString());
                                tradeName=tradeWbo.getAttribute("tradeName").toString();
                                
                                taskExecWbo.setAttribute("tradeName",tradeName);
                                taskExecWbo.setAttribute("empName",empWbo.getAttribute("empName").toString());
                                taskExecWbo.setAttribute("taskName",taskWbo.getAttribute("name").toString());
                                taskExecWbo.setAttribute("taskCode",taskWbo.getAttribute("title").toString());
                            }
                            
                            request.setAttribute("taskExecCmplx", taskExecCmplx);
                            request.setAttribute("page",servedPage);
                            this.forwardToServedPage(request, response);
                            break;
                        } else {
                            request.setAttribute("Status", "Failed");
                        }
                        issueTasksCmplxMgr = IssueTasksCmplxMgr.getInstance();
                        empBasicMgr = EmpBasicMgr.getInstance();
                        employeeMgr=EmployeeMgr.getInstance();
                        
                        vecIssueTasks = new Vector();
                        try {
                            vecIssueTasks = issueTasksCmplxMgr.getOnArbitraryKey(request.getParameter("issueId"), "key1");
                        } catch (SQLException ex) {
                            logger.error(ex.getMessage());
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }
                        request.setAttribute("arrWorkers", employeeMgr.getCashedTableAsBusObjects());
                        request.setAttribute("vecIssueTasks", vecIssueTasks);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                        
                    case 6:
                        Vector tasksVec = new Vector();
                        Vector executedTasksVec = new Vector();
                        WebBusinessObject wboSchTasks = new WebBusinessObject();
                        unitScheduleMgr = UnitScheduleMgr.getInstance();
                        ScheduleTasksMgr scheduleTasksMgr = ScheduleTasksMgr.getInstance();
                        IssueMetaDataMgr issueMetaDataMgr = IssueMetaDataMgr.getInstance();
                        issueTasksCmplxMgr=IssueTasksCmplxMgr.getInstance();
                        issueMgr=IssueMgr.getInstance();
                        servedPage = "/docs/complex/add_tasks_cmplx.jsp";
                        
                        issueId = request.getParameter("issueId");
                        WebBusinessObject wboIssueTable =  issueMgr.getOnSingleKey(issueId);
                        WebBusinessObject webUnitSch = unitScheduleMgr.getOnSingleKey(wboIssueTable.getAttribute("unitScheduleID").toString());
                        String scheduleId = webUnitSch.getAttribute("periodicId").toString();
                        
                        //get executed and unexecuted Tasks
                        taskExecutionCmplxMgr=TaskExecutionCmplxMgr.getInstance();
                        tasksHT = new Hashtable();
                        //get Issue Tasks
                        tasksVec = issueTasksCmplxMgr.getOnArbitraryKey(issueId,"key1");
                        
                        //get issue_tasks_execution
                        ArrayList executedTasksAL = taskExecutionCmplxMgr.getCashedTableAsArrayList("issueTaskID");
                        
                        //build two vectors TasksVec and Executed Vec
                        for(int i=0; i<tasksVec.size(); i++){
                            WebBusinessObject taskWbo = (WebBusinessObject) tasksVec.elementAt(i);
                            if(executedTasksAL.contains(taskWbo.getAttribute("taskID").toString())){
                                executedTasksVec.add(taskWbo);
                                tasksVec.removeElementAt(i);
                                i--;
                            }
                        }
                        
                        complexIssueMgr=ComplexIssueMgr.getInstance();
                        tradeMgr=TradeMgr.getInstance();
                        complexIssueWbo=null;
                        tradeWbo=null;
                        tradeName="";
                        complexIssues=complexIssueMgr.getOnArbitraryKey(issueId,"key1");
                        for(int i=0;i<complexIssues.size();i++){
                            complexIssueWbo=new WebBusinessObject();
                            tradeWbo=new WebBusinessObject();
                            tradeName="";
                            complexIssueWbo=(WebBusinessObject)complexIssues.get(i);
                            tradeWbo=tradeMgr.getOnSingleKey(complexIssueWbo.getAttribute("tradeId").toString());
                            tradeName=tradeWbo.getAttribute("tradeName").toString();
                            complexIssueWbo.setAttribute("tradeName",tradeName);
                        }
                        
                        WebIssue wTaskIssue = (WebIssue) issueMgr.getOnSingleKey(issueId);
                        WebBusinessObject eqpTask=maintainableMgr.getOnSingleKey(wTaskIssue.getAttribute("unitId").toString());
                        request.getSession().setAttribute("Eqptask",eqpTask);
                        request.setAttribute("issueTasks",tasksVec);
                        request.setAttribute("executedTasks",executedTasksVec);
                        request.setAttribute("complexIssues",complexIssues);
                        request.setAttribute("issueId", issueId);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                        
                    case 7:
                        
                        issueTasksCmplxMgr = IssueTasksCmplxMgr.getInstance();
                        servedPage = "/docs/complex/add_tasks_cmplx.jsp";
                        issueId = request.getParameter("issueId");
                        taskExecutionCmplxMgr=TaskExecutionCmplxMgr.getInstance();
                        executedTasksVec=new Vector();
                        tasksVec=new Vector();
                        
                        try {
                            //get executed and unexecuted Tasks
                            tasksHT = new Hashtable();
                            //get Issue Tasks
                            tasksVec = issueTasksCmplxMgr.getOnArbitraryKey(issueId,"key1");
                            
                            //get issue_tasks_execution
                            executedTasksAL = taskExecutionCmplxMgr.getCashedTableAsArrayList("issueTaskID");
                            
                            //build two vectors TasksVec and Executed Vec
                            for(int i=0; i<tasksVec.size(); i++){
                                WebBusinessObject taskWbo = (WebBusinessObject) tasksVec.elementAt(i);
                                if(executedTasksAL.contains(taskWbo.getAttribute("taskID").toString())){
                                    executedTasksVec.add(taskWbo);
                                    tasksVec.removeElementAt(i);
                                    i--;
                                }
                            }
                            
                            /************************Start of remoev old parts and tasks************************************/
                            /****Get Issue tasks then get task parts then delete
                             * parts on issue then delete tasks on issue****/
                            quantMntenceCmplxMgr=QuantMntenceCmplxMgr.getInstance();
                            ConfigTasksPartsMgr configTasksPartsMgr=ConfigTasksPartsMgr.getInstance();
                            complexIssueMgr=ComplexIssueMgr.getInstance();
                            String unitSchId="";
                            WebBusinessObject taskPartWbo=new WebBusinessObject();
                            WebBusinessObject issueTaskWbo=new WebBusinessObject();
                            
                            Vector taskParts=new Vector();
                            issueMgr=IssueMgr.getInstance();
                            WebBusinessObject issueWbo=new WebBusinessObject();
                            if(tasksVec!=null){
                                
                                for(int i=0;i<tasksVec.size();i++){
                                    
                                    taskPartWbo=new WebBusinessObject();
                                    issueWbo=new WebBusinessObject();
                                    taskParts=new Vector();
                                    unitSchId="";
                                    
                                    issueTaskWbo=(WebBusinessObject)tasksVec.get(i);
                                    issueWbo=issueMgr.getOnSingleKey(issueId);
                                    unitSchId=issueWbo.getAttribute("unitScheduleID").toString();
                                    taskParts=configTasksPartsMgr.getOnArbitraryKey(issueTaskWbo.getAttribute("codeTask").toString(),"key1");
                                    
                                    //loop To Delete Parts from issue parts Table (quantified_mntnc) that are related to Tasks
                                    for(int c=0;c<taskParts.size();c++){
                                        taskPartWbo=new WebBusinessObject();
                                        taskPartWbo=(WebBusinessObject)taskParts.get(c);
                                        String itemId=taskPartWbo.getAttribute("itemId").toString();
                                        quantMntenceCmplxMgr.deleteOnArbitraryDoubleKey(unitSchId,"key1",itemId,"key5");
                                    }
                                    /*******End Of Delete Loop************/
                                }
                            }
                            String taskId="";
                            if (tasksVec.size() > 0) {
                                for(int i=0; i<tasksVec.size();i++){
                                    taskId=((WebBusinessObject) tasksVec.elementAt(i)).getAttribute("taskID").toString();
                                    issueTasksCmplxMgr.deleteOnSingleKey(taskId);
                                }
                            }
                            /************************End of remoev old parts and tasks************************************/
                            
                            /*Save new tasks*/
                            if (issueTasksCmplxMgr.saveObject(request, issueId)) {
                                request.setAttribute("Status", "Ok");
                                
                                tasksHT = new Hashtable();
                                executedTasksVec=new Vector();
                                tasksVec=new Vector();
                                //get Issue Tasks
                                tasksVec = issueTasksCmplxMgr.getOnArbitraryKey(issueId,"key1");
                                
                                //get issue_tasks_execution
                                executedTasksAL = taskExecutionCmplxMgr.getCashedTableAsArrayList("issueTaskID");
                                
                                //build two vectors TasksVec and Executed Vec
                                for(int i=0; i<tasksVec.size(); i++){
                                    WebBusinessObject taskWbo = (WebBusinessObject) tasksVec.elementAt(i);
                                    if(executedTasksAL.contains(taskWbo.getAttribute("taskID").toString())){
                                        executedTasksVec.add(taskWbo);
                                        tasksVec.removeElementAt(i);
                                        i--;
                                    }
                                }
                                
                                /*Get parts per task then add it to JO*/
                                unitSchId="";
                                issueWbo=issueMgr.getOnSingleKey(issueId);
                                unitSchId=issueWbo.getAttribute("unitScheduleID").toString();
                                taskParts=new Vector();
                                String []tasksCodes=request.getParameterValues("id");    //New tasks Ids
                                String[] cmplxIssueIndex = request.getParameterValues("maintTypeIndex");
                                
                                if(tasksCodes!=null){
                                    for(int i=0;i<tasksCodes.length;i++){
                                        taskParts=new Vector();
                                        taskParts=configTasksPartsMgr.getOnArbitraryKey(tasksCodes[i],"key1");  //task Parts
                                        
                                        String[] price=new String[1];
                                        String[] cost=new String[1];
                                        String[] note=new String[1];
                                        String[] id=new String[1];
                                        String[] quantity=new String[1];
                                        String isDirectPrch="0";   //from spares
                                        String[] attachedOn={"2"};
                                        String index[]=new String[1];
                                        
                                        for(int c=0;c<taskParts.size();c++){
                                            taskPartWbo=new WebBusinessObject();
                                            taskPartWbo=(WebBusinessObject)taskParts.get(c);
                                            
                                            quantity[0]=taskPartWbo.getAttribute("itemQuantity").toString();
                                            id[0]=taskPartWbo.getAttribute("itemId").toString();
                                            price[0]=taskPartWbo.getAttribute("itemPrice").toString();
                                            cost[0]=taskPartWbo.getAttribute("totalCost").toString();
                                            note[0]=taskPartWbo.getAttribute("note").toString();
                                            index[0]=cmplxIssueIndex[i];
                                            
                                            /*** Overload saveObject2 method because in this case we didn't have the despense date so it enter with sysdate***/
                                            if(quantMntenceCmplxMgr.saveObject2(quantity,price,cost,note,index,issueId,id,unitSchId,isDirectPrch,attachedOn,session))
                                                issueMgr.updateTotalCost(new Float(taskPartWbo.getAttribute("totalCost").toString()).floatValue(), issueId);
                                            
//                                        WebBusinessObject wboIssue = issueMgr.getOnSingleKey(issueId);
//                                        if(wboIssue.getAttribute("issueTitle").toString().equals("Emergency")){
//                                            issueMgr.getUpdateCaseConfigEmg(unitSchId);
//                                        }
                                        }
                                    }
                                }
                                
                                
                                
//                            if (issueTasksCmplxMgr.saveObject(request, issueId)) {
//                                request.setAttribute("Status", "Ok");
//
//                                tasksHT = new Hashtable();
//                                executedTasksVec=new Vector();
//                                tasksVec=new Vector();
//                                //get Issue Tasks
//                                tasksVec = issueTasksCmplxMgr.getOnArbitraryKey(issueId,"key1");
//
//                                //get issue_tasks_execution
//                                executedTasksAL = taskExecutionCmplxMgr.getCashedTableAsArrayList("issueTaskID");
//
//                                //build two vectors TasksVec and Executed Vec
//                                for(int i=0; i<tasksVec.size(); i++){
//                                    WebBusinessObject taskWbo = (WebBusinessObject) tasksVec.elementAt(i);
//                                    if(executedTasksAL.contains(taskWbo.getAttribute("taskID").toString())){
//                                        executedTasksVec.add(taskWbo);
//                                        tasksVec.removeElementAt(i);
//                                        i--;
//                                    }
//                                }
//
                            } else {
                                request.setAttribute("Status", "No");
                            }
                            
                            complexIssueMgr=ComplexIssueMgr.getInstance();
                            tradeMgr=TradeMgr.getInstance();
                            complexIssueWbo=null;
                            tradeWbo=null;
                            tradeName="";
                            complexIssues=complexIssueMgr.getOnArbitraryKey(issueId,"key1");
                            for(int i=0;i<complexIssues.size();i++){
                                complexIssueWbo=new WebBusinessObject();
                                tradeWbo=new WebBusinessObject();
                                tradeName="";
                                complexIssueWbo=(WebBusinessObject)complexIssues.get(i);
                                tradeWbo=tradeMgr.getOnSingleKey(complexIssueWbo.getAttribute("tradeId").toString());
                                tradeName=tradeWbo.getAttribute("tradeName").toString();
                                complexIssueWbo.setAttribute("tradeName",tradeName);
                            }
                            
                            request.setAttribute("complexIssues",complexIssues);
                            request.setAttribute("issueTasks",tasksVec);
                            request.setAttribute("executedTasks",executedTasksVec);
                            request.setAttribute("issueId", issueId);
                            request.setAttribute("page", servedPage);
                        } catch (SQLException ex) {
                            request.setAttribute("Status", "No");
                        }
                        this.forwardToServedPage(request, response);
                        break;
                        
                    case 8:
                        servedPage = "/docs/complex/Add_labor_complint_cmplx.jsp";
                        filterName = request.getParameter("filterName");
                        filterValue = request.getParameter("filterValue");
                        issueId = request.getParameter("issueId");
                        unitScheduleMgr=UnitScheduleMgr.getInstance();
                        DriversHistoryMgr driverHistoryMgr = DriversHistoryMgr.getInstance();
                        issueMgr=IssueMgr.getInstance();
                        try{
                            //get current equipment labor
                            WebBusinessObject issueWbo = issueMgr.getOnSingleKey(issueId);
                            WebBusinessObject unitScheduleWbo = unitScheduleMgr.getOnSingleKey(issueWbo.getAttribute("unitScheduleID").toString());
                            Vector driversVec = driverHistoryMgr.getOnArbitraryDoubleKeyOracle(unitScheduleWbo.getAttribute("unitId").toString(),"key1", null,"key3");
                            WebBusinessObject driverWbo = (WebBusinessObject) driversVec.elementAt(0);
                            
                            request.setAttribute("currentEmpWbo", driverWbo);
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }
                        
                        complexIssueMgr=ComplexIssueMgr.getInstance();
                        tradeMgr=TradeMgr.getInstance();
                        complexIssues=complexIssueMgr.getOnArbitraryKey(issueId,"key1");
                        for(int i=0;i<complexIssues.size();i++){
                            complexIssueWbo=new WebBusinessObject();
                            tradeWbo=new WebBusinessObject();
                            tradeName="";
                            complexIssueWbo=(WebBusinessObject)complexIssues.get(i);
                            tradeWbo=tradeMgr.getOnSingleKey(complexIssueWbo.getAttribute("tradeId").toString());
                            tradeName=tradeWbo.getAttribute("tradeName").toString();
                            complexIssueWbo.setAttribute("tradeName",tradeName);
                        }
                        
                        laborComplaintsMgr= LaborComplaintsMgr.getInstance();
                        Vector complaintsVec = new Vector();
                        complaintsVec = laborComplaintsMgr.getOnArbitraryKey(issueId, "key1");
                        
                        request.setAttribute("complaintsVec",complaintsVec );
                        
                        request.setAttribute("filterName",filterName );
                        request.setAttribute("complexIssues",complexIssues );
                        request.setAttribute("filterValue" , filterValue);
                        request.setAttribute("issueId", issueId);
                        request.setAttribute("page",servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                        
                    case 9:
                        tasksVec = new Vector();
                        executedTasksVec = new Vector();
                        wboSchTasks = new WebBusinessObject();
                        unitScheduleMgr = UnitScheduleMgr.getInstance();
                        scheduleTasksMgr = ScheduleTasksMgr.getInstance();
                        issueMetaDataMgr = IssueMetaDataMgr.getInstance();
                        issueTasksCmplxMgr=IssueTasksCmplxMgr.getInstance();
                        issueMgr=IssueMgr.getInstance();
                        servedPage = "/docs/complex/view_tasks_cmplx.jsp";
                        
                        issueId = request.getParameter("issueId");
                        wboIssueTable =  issueMgr.getOnSingleKey(issueId);
                        webUnitSch = unitScheduleMgr.getOnSingleKey(wboIssueTable.getAttribute("unitScheduleID").toString());
                        scheduleId = webUnitSch.getAttribute("periodicId").toString();
                        
                        //get executed and unexecuted Tasks
                        taskExecutionCmplxMgr=TaskExecutionCmplxMgr.getInstance();
                        tasksHT = new Hashtable();
                        //get Issue Tasks
                        tasksVec = issueTasksCmplxMgr.getOnArbitraryKey(issueId,"key1");
                        
                        //get issue_tasks_execution
                        executedTasksAL = taskExecutionCmplxMgr.getCashedTableAsArrayList("issueTaskID");
                        
                        //build two vectors TasksVec and Executed Vec
//                        for(int i=0; i<tasksVec.size(); i++){
//                            WebBusinessObject taskWbo = (WebBusinessObject) tasksVec.elementAt(i);
//                            if(executedTasksAL.contains(taskWbo.getAttribute("taskID").toString())){
//                                executedTasksVec.add(taskWbo);
//                                tasksVec.removeElementAt(i);
//                                i--;
//                            }
//                        }
                        
                        /*******************************************/
                        WebBusinessObject task=new WebBusinessObject();
                        WebBusinessObject taskWbo=new WebBusinessObject();
                        WebBusinessObject webUnitType =new WebBusinessObject();
                        WebBusinessObject webIssue=new WebBusinessObject();
                        WebBusinessObject cIssueWbo=new WebBusinessObject();
                        tradeWbo =new WebBusinessObject();
                        
                        TaskMgr taskMgr=TaskMgr.getInstance();
                        UnitMgr unitMgr=UnitMgr.getInstance();
                        issueMgr=IssueMgr.getInstance();
                        tradeMgr=TradeMgr.getInstance();
                        complexIssueMgr=ComplexIssueMgr.getInstance();
                        
                        Vector cIssues=new Vector();
                        Vector filnalTasksVec=new Vector();
                        String taskCode="";
                        String parentUnitId="";
                        String cIssueId="";
                        String tradeId="";
                        
                        
                        for(int i=0;i<tasksVec.size();i++){
                            task=new WebBusinessObject();
                            taskWbo=new WebBusinessObject();
                            cIssueWbo=new WebBusinessObject();
                            tradeWbo =new WebBusinessObject();
                            cIssues=new Vector();
                            taskCode="";
                            parentUnitId="";
                            cIssueId="";
                            tradeId="";
                            
                            task=( WebBusinessObject)tasksVec.get(i);
                            taskCode=(String)task.getAttribute("codeTask");
                            taskWbo= taskMgr.getOnSingleKey(taskCode);
                            parentUnitId=(String)taskWbo.getAttribute("parentUnit");
                            webUnitType = unitMgr.getOnSingleKey(parentUnitId);
                            webIssue = issueMgr.getOnSingleKey(issueId);
                            
                            cIssueId=task.getAttribute("cmplxIssueId").toString();
                            cIssues=complexIssueMgr.getOnArbitraryDoubleKey(issueId,"key1",cIssueId,"key3");
                            cIssueWbo=(WebBusinessObject)cIssues.get(0);
                            tradeId=(String)cIssueWbo.getAttribute("tradeId");
                            tradeWbo = tradeMgr.getOnSingleKey(tradeId);
                            
                            /*************Compose Task Wbo **************/
                            taskWbo.setAttribute("unitName",webUnitType.getAttribute("unitName").toString());
                            taskWbo.setAttribute("tradeName",tradeWbo.getAttribute("tradeName").toString());
                            taskWbo.setAttribute("cmplxIssueId",cIssueId);
                            taskWbo.setAttribute("desc",(String)task.getAttribute("desc"));
                            
                            /******End*******/
                            
                            //build two vectors TasksVec and Executed Vec
                            if(executedTasksAL.contains(task.getAttribute("taskID").toString()))
                                executedTasksVec.add(taskWbo);
                            else
                                filnalTasksVec.add(taskWbo);
                            
                        }
                        /*******************************************/
                        
                        
                        
                        complexIssueMgr=ComplexIssueMgr.getInstance();
                        tradeMgr=TradeMgr.getInstance();
                        complexIssueWbo=null;
                        tradeWbo=null;
                        tradeName="";
                        complexIssues=complexIssueMgr.getOnArbitraryKey(issueId,"key1");
                        for(int i=0;i<complexIssues.size();i++){
                            complexIssueWbo=new WebBusinessObject();
                            tradeWbo=new WebBusinessObject();
                            tradeName="";
                            complexIssueWbo=(WebBusinessObject)complexIssues.get(i);
                            tradeWbo=tradeMgr.getOnSingleKey(complexIssueWbo.getAttribute("tradeId").toString());
                            tradeName=tradeWbo.getAttribute("tradeName").toString();
                            complexIssueWbo.setAttribute("tradeName",tradeName);
                        }
                        
                        WebIssue Wtask=(WebIssue) issueMgr.getOnSingleKey(issueId);
                        WebBusinessObject eqpviwTaske=maintainableMgr.getOnSingleKey(Wtask.getAttribute("unitId").toString());
                        request.getSession().setAttribute("eqpView",eqpviwTaske);
                        
//                        request.setAttribute("issueTasks",tasksVec);
                        request.setAttribute("issueTasks",filnalTasksVec);
                        request.setAttribute("executedTasks",executedTasksVec);
                        request.setAttribute("complexIssues",complexIssues);
                        request.setAttribute("issueId", issueId);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                        
                    case 10:
                        
                        itemListTemp = new Vector();
                        projectname = request.getParameter("projectName");
                        ais = IssueStatusFactory.getStateClass(IssueStatusFactory.SCHEDULE);
                        quantifiedMgr = QuantifiedMntenceMgr.getInstance();
                        issueId = request.getParameter(IssueConstants.ISSUEID);
                        issueMgr=IssueMgr.getInstance();
                        myIssue = issueMgr.getOnSingleKey(issueId);
                        
                        uSID = (String) myIssue.getAttribute("unitScheduleID");
                        issueTitle = request.getParameter(IssueConstants.ISSUETITLE);
                        
                        
                        filterName = request.getParameter("filterName");
                        filterValue = request.getParameter("filterValue");
                        attachedEqFlag=(String)request.getParameter("attachedEqFlag");
                        
                        itemList = new Vector();
                        uSID=issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString();
                        quantMntenceCmplxMgr=QuantMntenceCmplxMgr.getInstance();
                        itemListTemp=quantMntenceCmplxMgr.getSpecialItemSchedule(uSID,"0");
                        unitScheduleMgr=UnitScheduleMgr.getInstance();
                        web=unitScheduleMgr.getOnSingleKey(uSID);
                        
                        eID=web.getAttribute("periodicId").toString();
                        if(eID.equalsIgnoreCase("1")||eID.equalsIgnoreCase("2")){
                            itemList=quantMntenceCmplxMgr.getSpecialItemSchedule(uSID,"0");
                        } else{
                            itemList = itemListTemp;
                        }
                        
                        Vector localItemList=quantMntenceCmplxMgr.getSpecialItemSchedule(uSID,"1");
                        
                        complexIssueMgr=ComplexIssueMgr.getInstance();
                        tradeMgr=TradeMgr.getInstance();
                        complexIssueWbo=null;
                        tradeWbo=null;
                        tradeName="";
                        
                        complexIssues=new Vector();
                        WebBusinessObject itemWbo=new WebBusinessObject();
                        tradeWbo=new WebBusinessObject();
                        complexIssueWbo=new WebBusinessObject();
                        for(int i=0;i<itemList.size();i++){
                            itemWbo=new WebBusinessObject();
                            complexIssues=new Vector();
                            itemWbo=(WebBusinessObject)itemList.get(i);
                            tradeName="";
                            String x=itemWbo.getAttribute("issueId").toString();
                            String y=itemWbo.getAttribute("cmplxIssueId").toString();
                            complexIssues=complexIssueMgr.getOnArbitraryDoubleKey(x,"key1",y,"key3");
                            complexIssueWbo=(WebBusinessObject)complexIssues.get(0);
                            
                            tradeWbo=tradeMgr.getOnSingleKey(complexIssueWbo.getAttribute("tradeId").toString());
                            tradeName=tradeWbo.getAttribute("tradeName").toString();
                            itemWbo.setAttribute("tradeName",tradeName);
                            
                        }
                        
                        for(int i=0;i<localItemList.size();i++){
                            itemWbo=new WebBusinessObject();
                            complexIssues=new Vector();
                            itemWbo=(WebBusinessObject)localItemList.get(i);
                            tradeName="";
                            String x=itemWbo.getAttribute("issueId").toString();
                            String y=itemWbo.getAttribute("cmplxIssueId").toString();
                            complexIssues=complexIssueMgr.getOnArbitraryDoubleKey(x,"key1",y,"key3");
                            complexIssueWbo=(WebBusinessObject)complexIssues.get(0);
                            
                            tradeWbo=tradeMgr.getOnSingleKey(complexIssueWbo.getAttribute("tradeId").toString());
                            tradeName=tradeWbo.getAttribute("tradeName").toString();
                            itemWbo.setAttribute("tradeName",tradeName);
                            
                        }
                        
                        servedPage = "/docs/complex/view_parts_cmplx.jsp";
                        request.setAttribute("data", itemList);
                        request.setAttribute("localItemList", localItemList);
                        request.setAttribute("attachedEqFlag", attachedEqFlag);
                        request.setAttribute("uID",uSID);
                        request.setAttribute(IssueConstants.ISSUEID, issueId);
                        request.setAttribute(IssueConstants.ISSUETITLE, issueTitle);
                        request.setAttribute("filter",filterName);
                        request.setAttribute("filterValue",filterValue);
                        request.setAttribute("projectName", projectname);
                        request.setAttribute(IssueConstants.STATE,ais);
                        
                        request.setAttribute("page",servedPage);
                        this.forwardToServedPage(request, response);
                        
                        break;
                        
                    case 11:
                        
                        servedPage = "/docs/complex/view_workers_cmplx.jsp";
                        issueTasksCmplxMgr= IssueTasksCmplxMgr.getInstance();
                        empBasicMgr = EmpBasicMgr.getInstance();
                        employeeMgr = EmployeeMgr.getInstance();
                        vecIssueTasks = new Vector();
                        Vector taskExecCmplx=new Vector();
                        taskExecutionCmplxMgr=TaskExecutionCmplxMgr.getInstance();
                        try {
                            taskExecCmplx=taskExecutionCmplxMgr.getOnArbitraryKey(request.getParameter("issueId"), "key3");
                            
                        } catch (SQLException ex) {
                            ex.printStackTrace();
                        } catch (Exception ex) {
                            ex.printStackTrace();
                        }
                        
                        WebBusinessObject taskExecWbo=new WebBusinessObject();
                        WebBusinessObject empWbo=new WebBusinessObject();
                        EmployeeMgr empMgr = EmployeeMgr.getInstance();
                        issueTasksCmplxMgr=IssueTasksCmplxMgr.getInstance();
                        taskMgr=TaskMgr.getInstance();
                        taskWbo=new WebBusinessObject();
                        complexIssueMgr=ComplexIssueMgr.getInstance();
                        tradeMgr=TradeMgr.getInstance();
                        WebBusinessObject issueTasksCmplxWbo=new WebBusinessObject();
                        for(int i=0;i<taskExecCmplx.size();i++){
                            taskExecWbo=new WebBusinessObject();
                            taskWbo=new WebBusinessObject();
                            LiteWebBusinessObject empLiteWbo=new LiteWebBusinessObject();
                            issueTasksCmplxWbo=new WebBusinessObject();
                            taskExecWbo=(WebBusinessObject)taskExecCmplx.get(i);
                            issueTasksCmplxWbo=issueTasksCmplxMgr.getOnSingleKey(taskExecWbo.getAttribute("issueTaskID").toString());
                            taskWbo=taskMgr.getOnSingleKey(issueTasksCmplxWbo.getAttribute("codeTask").toString());
                            empLiteWbo=empMgr.getOnSingleKey(taskExecWbo.getAttribute("laborID").toString());
                            
                            complexIssues=new Vector();
                            tradeName="";
                            String x=taskExecWbo.getAttribute("issueId").toString();
                            String y=taskExecWbo.getAttribute("cmplxIssueIndex").toString();
                            complexIssues=complexIssueMgr.getOnArbitraryDoubleKey(x,"key1",y,"key3");
                            complexIssueWbo=(WebBusinessObject)complexIssues.get(0);
                            
                            tradeWbo=tradeMgr.getOnSingleKey(complexIssueWbo.getAttribute("tradeId").toString());
                            tradeName=tradeWbo.getAttribute("tradeName").toString();
                            
                            taskExecWbo.setAttribute("tradeName",tradeName);
                            taskExecWbo.setAttribute("empName",empWbo.getAttribute("empName").toString());
                            taskExecWbo.setAttribute("taskName",taskWbo.getAttribute("name").toString());
                            taskExecWbo.setAttribute("taskCode",taskWbo.getAttribute("title").toString());
                        }
                        
                        request.setAttribute("taskExecCmplx", taskExecCmplx);
                        request.setAttribute("page",servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                        
                    case 12:
                        
                        filterName=(String)request.getParameter("filterName");
                        filterValue=(String)request.getParameter("filterValue");
                        String isId = request.getParameter("issueId");
                        String maintTitle = request.getParameter("maintTitle");
                        String jobNo = request.getParameter("jobNo");
                        
                        //get issue complaints and complaints tasks
                        Vector compTasksVec = new Vector();
                        laborComplaintsMgr=LaborComplaintsMgr.getInstance();
                        
                        compTasksMgr = ComplaintTasksMgr.getInstance();
                        compTasksVec = compTasksMgr.getOnArbitraryKey(isId, "key");
                        if(compTasksVec.size()<=0){
                            compTasksVec = laborComplaintsMgr.getOnArbitraryKey(isId, "key1");
                        }
                        
                        request.setAttribute("filterName", filterName);
                        request.setAttribute("filterValue", filterValue);
                        request.setAttribute("maintTitle", maintTitle);
                        request.setAttribute("jobNo", jobNo);
                        request.setAttribute("issueId", isId);
                        request.setAttribute("comp", compTasksVec);
                        
                        servedPage = "/docs/complex/comp_List_cmplx.jsp";
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        
                        break;
                        
                    case 13:
                        String status="failed";
                        
                        filterName = request.getParameter("filterName");
                        filterValue = request.getParameter("filterValue");
                        
                        try{
                            //get current equipment labor
                            unitScheduleMgr=UnitScheduleMgr.getInstance();
                            WebBusinessObject unitScheduleWbo=new WebBusinessObject();
                            driverHistoryMgr=DriversHistoryMgr.getInstance();
                            LaborComplaintsMgr laborComplaintsMgr=LaborComplaintsMgr.getInstance();
                            issueMgr=IssueMgr.getInstance();
                            
                            WebBusinessObject issueWbo = issueMgr.getOnSingleKey(request.getParameter("issueId").toString());
                            unitScheduleWbo = unitScheduleMgr.getOnSingleKey(issueWbo.getAttribute("unitScheduleID").toString());
                            Vector driversVec = driverHistoryMgr.getOnArbitraryDoubleKeyOracle(unitScheduleWbo.getAttribute("unitId").toString(),"key1", null,"key3");
                            WebBusinessObject driverWbo = (WebBusinessObject) driversVec.elementAt(0);
                            
                            request.setAttribute("currentEmpWbo", driverWbo);
                            
                            //Delete All records then insert
                            String[] isRelated  = request.getParameterValues("related");
                            String[] compIds = request.getParameterValues("compId");
                            String[] deletedIds = request.getParameterValues("deletedId");
                            
                            if(deletedIds != null){
                                for(int i=0; i<deletedIds.length; i++){
                                    if(!deletedIds[i].equalsIgnoreCase("new")){
                                        laborComplaintsMgr.deleteOnArbitraryKey(deletedIds[i], "key");
                                    }
                                }
                            }
                            
                            if(isRelated != null){
                                for(int i=0; i<isRelated.length; i++){
                                    if(isRelated[i].equalsIgnoreCase("no"))
                                        laborComplaintsMgr.deleteOnArbitraryKey(compIds[i], "key");
                                }
                            }
                            
                            //insert new records
                            String [] comp=request.getParameterValues("comp");
                            boolean flag = true;
                            
                            for(int i=0; i<isRelated.length; i++){
                                if(!isRelated[i].equalsIgnoreCase("yes")){
                                    flag = false;
                                }
                            }
                            if(comp==null || flag == true){
                                status="ok";
                            } else {
                                if(laborComplaintsMgr.saveObjectCmplx(request)){
                                    status="ok";
                                } else{
                                    status="failed";
                                }
                            }
                            
                        }catch (Exception ex){
                            logger.error(ex.getMessage());
                        }
                        
                        complexIssueMgr=ComplexIssueMgr.getInstance();
                        tradeMgr=TradeMgr.getInstance();
                        complexIssueWbo=null;
                        tradeWbo=null;
                        tradeName="";
                        complexIssues=complexIssueMgr.getOnArbitraryKey(issueId,"key1");
                        for(int i=0;i<complexIssues.size();i++){
                            complexIssueWbo=new WebBusinessObject();
                            tradeWbo=new WebBusinessObject();
                            tradeName="";
                            complexIssueWbo=(WebBusinessObject)complexIssues.get(i);
                            tradeWbo=tradeMgr.getOnSingleKey(complexIssueWbo.getAttribute("tradeId").toString());
                            tradeName=tradeWbo.getAttribute("tradeName").toString();
                            complexIssueWbo.setAttribute("tradeName",tradeName);
                        }
                        
                        laborComplaintsMgr = LaborComplaintsMgr.getInstance();
                        complaintsVec = new Vector();
                        complaintsVec = laborComplaintsMgr.getOnArbitraryKey(issueId, "key1");
//                        complaintsVec = compTasksMgr.getOnArbitraryKey(issueId, "key1");
                        servedPage = "/docs/complex/Add_labor_complint_cmplx.jsp";
                        request.setAttribute("complexIssues",complexIssues );
                        request.setAttribute("complaintsVec",complaintsVec );
                        request.setAttribute("filterName",filterName );
                        request.setAttribute("filterValue" , filterValue);
                        request.setAttribute("issueId",request.getParameter("issueId"));
                        request.setAttribute("Status",status);
                        request.setAttribute("page",servedPage);
                        this.forwardToServedPage(request, response);
                        
                        break;
                        
                    case 14:
                        issueMgr=IssueMgr.getInstance();
                        String mainTitle = request.getParameter("mainTitle");
                        projectname = request.getParameter("projectName");
                        filterName = request.getParameter("filterName");
                        filterValue = request.getParameter("filterValue");
                        issueId = request.getParameter("issueId");
                        WebIssue wIssue = (WebIssue) issueMgr.getOnSingleKey(issueId);
                        
                        MaintainableMgr maintainableMgr=MaintainableMgr.getInstance();
                        WebBusinessObject eqWbo=maintainableMgr.getOnSingleKey(wIssue.getAttribute("unitId").toString());
//                        request.getSession().setAttribute("IssueWbo",wIssue);
//                        request.getSession().setAttribute("equipmentWbo",eqWbo);
//                        request.getSession().setAttribute("joType","complex");
                        
                        HttpSession mySession = request.getSession();
                        mySession.removeAttribute("CurrentJobOrder");
                        mySession.setAttribute("CurrentJobOrder",issueId);
                        // end walid
                        
                        if(request.getParameter("case")!=null){
                            session=request.getSession(true);
                            session.setAttribute("case",request.getParameter("case"));
                            session.setAttribute("title",request.getParameter("title"));
                            session.setAttribute("unitName",request.getParameter("unitName"));
                            
                        }
                        issueMgr=IssueMgr.getInstance();
                        wIssue = (WebIssue) issueMgr.getOnSingleKey(issueId);
                        String sitDate = issueMgr.getsitDate(issueId);
                        String actualBeginDate = issueMgr.getActualBeginDate(issueId);
                        String unitScheduleID = (String) wIssue.getAttribute("unitScheduleID");
                        unitScheduleMgr = UnitScheduleMgr.getInstance();
                        WebBusinessObject unitScheduleWbo = unitScheduleMgr.getOnSingleKey(unitScheduleID);
                        
                        String scheduleUnitID = (String) wIssue.getAttribute("unitScheduleID");
                        
                        // Get Eq_ID from Unit Schedule to check if this Eq is attached or not
                /* check if the equipment id has record(s) in attach_eqps table and
                 the separation_date equl null. this mean this eq is attached.*/
                        attachedEqps=new Vector();
                        minorAttachedEqps=new Vector();
                        attachFlag=0;
                        supplementMgr=SupplementMgr.getInstance();
                        unit_sch_wbo=unitScheduleMgr.getOnSingleKey(scheduleUnitID);
                        Eq_ID=(String)unit_sch_wbo.getAttribute("unitId");
                        attachedEqps=supplementMgr.search(Eq_ID);
                        minorAttachedEqps=supplementMgr.searchAllowedEqps(Eq_ID);
                        if(attachedEqps.size()>0) {
                            wIssue.setAttribute("attachedEq","attached");
                        }else{
                            if(minorAttachedEqps.size()>0) {
                                wIssue.setAttribute("attachedEq","attached");
                            }else{
                                wIssue.setAttribute("attachedEq","notatt");
                            }
                            
                        }
                        
                        /******Create Dynamic contenet of Issue menu *******/
                        //open Jar File
                        MetaDataMgr metaMgr=MetaDataMgr.getInstance();
                        metaMgr.setMetaData("xfile.jar");
                        ParseSideMenu parseSideMenu=new ParseSideMenu();
                        Vector issueMenu=new Vector();
                        String mode=(String)request.getSession().getAttribute("currentMode");
                        issueMenu=parseSideMenu.parseSideMenu(mode,"issue_menu.xml","c");
                        
                        metaMgr.closeDataSource();
                        
                        /* Add ids for links*/
                        Vector linkVec=new Vector();
                        String link="";
                        Hashtable style=new Hashtable();
                        style=(Hashtable)issueMenu.get(0);
                        String title=style.get("title").toString();
                        title+="   "+wIssue.getAttribute("businessID").toString();
                        style.remove("title");
                        style.put("title",title);
                        
                        for(int i=1;i<issueMenu.size()-1;i++){
                            linkVec=new Vector();
                            link="";
                            linkVec=(Vector)issueMenu.get(i);
                            link=(String)linkVec.get(1);
                            
                            if(link.equalsIgnoreCase("AssignedIssueServlet?op=assign&state=SCHEDULE&viewOrigin=null&direction=forward&issueId=")){
                                String currentStatus=(String)wIssue.getAttribute("currentStatus");
                                if(currentStatus!=null){
                                    if(currentStatus.equalsIgnoreCase("Schedule")||currentStatus.equalsIgnoreCase("Rejected")){
                                        link+=wIssue.getAttribute("id").toString()+"&attachedEqFlag="+wIssue.getAttribute("attachedEq").toString()+"&equipmentID="+wIssue.getAttribute("unitId").toString();
                                    }else{
                                        issueMenu.remove(i);
                                        i--;
                                        continue;
                                    }
                                }else{
                                    link+=wIssue.getAttribute("id").toString()+"&attachedEqFlag="+wIssue.getAttribute("attachedEq").toString()+"&equipmentID="+wIssue.getAttribute("unitId").toString();
                                }
                                
                            }else{
                                link+=wIssue.getAttribute("id").toString()+"&attachedEqFlag="+wIssue.getAttribute("attachedEq").toString()+"&equipmentID="+wIssue.getAttribute("unitId").toString();
                            }
                            linkVec.remove(1);
                            linkVec.add(link);
                            
                        }
                        
                        Hashtable topMenu=new Hashtable();
                        Vector tempVec=new Vector();
                        topMenu=(Hashtable)request.getSession().getAttribute("topMenu");
                        
                        if(topMenu!=null && topMenu.size()>0){
                            
                                /* 1- Get the current Side menu
                                 * 2- Check Menu Type
                                 * 3- insert menu object to top menu accordding to it's type
                                 */
                            
                            Vector menuType=new Vector();
                            Vector currentSideMenu=(Vector)request.getSession().getAttribute("sideMenuVec");
                            if(currentSideMenu!=null && currentSideMenu.size()>0){
                                linkVec=new Vector();
                                
                                // the element # 1 in menu is to view the object
                                linkVec=(Vector)currentSideMenu.get(1);
                                
                                // size-1 becouse the menu type is the last element in vector
                                
                                menuType=(Vector)currentSideMenu.get(currentSideMenu.size()-1);
                                
                                if(menuType!=null && menuType.size()>0){
                                    topMenu.put((String)menuType.get(1),linkVec);
                                }
                                
                            }
                            request.getSession().setAttribute("topMenu",topMenu);
                        }
                        
                        request.getSession().setAttribute("sideMenuVec",issueMenu);
                        /*End of Menu*/
                        
                        unitScheduleMgr = UnitScheduleMgr.getInstance();
                        unitScheduleWbo = unitScheduleMgr.getOnSingleKey(scheduleUnitID);
                        request.setAttribute("issueId", wIssue.getAttribute("id"));
                        loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                        request.setAttribute("sitDate",sitDate);
                        request.setAttribute("actualBeginDate",actualBeginDate);
                        
                        request.setAttribute("webIssue",wIssue);
                        request.setAttribute("filterName",filterName);
                        request.setAttribute("filterValue",filterValue);
                        request.setAttribute("projectName", projectname);
                        
                        request.setAttribute("mainTitle", mainTitle);
                        request.setAttribute("equipmentID", unitScheduleWbo.getAttribute("unitId"));
                        servedPage = "/docs/complex/assigned_issue_details_cmplx.jsp";
                        
                        request.setAttribute("page",servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                        
                    case 15:
                        itemListTemp = new Vector();
                        issueMgr=IssueMgr.getInstance();
                        unitScheduleMgr=UnitScheduleMgr.getInstance();
                        
                        projectname = request.getParameter("projectName");
                        ais = IssueStatusFactory.getStateClass(IssueStatusFactory.SCHEDULE);
                        quantifiedMgr = QuantifiedMntenceMgr.getInstance();
                        issueId = request.getParameter(IssueConstants.ISSUEID);
                        myIssue = issueMgr.getOnSingleKey(issueId);
                        uSID= (String) myIssue.getAttribute("unitScheduleID");
                        issueTitle = request.getParameter(IssueConstants.ISSUETITLE);
                        
                        filterName = request.getParameter("filterName");
                        filterValue = request.getParameter("filterValue");
                        
                        itemList = new Vector();
                        uSID=issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString();
//                itemListTemp = quantifiedMgr.getItemSchedule(issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString());
                        quantMntenceCmplxMgr=QuantMntenceCmplxMgr.getInstance();
                        itemListTemp=quantMntenceCmplxMgr.getSpecialItemSchedule(uSID,"1");
                        
                        //String eID;
                        web=unitScheduleMgr.getOnSingleKey(uSID);
                        
                        eID=web.getAttribute("periodicId").toString();
                        
//                        if(eID.equalsIgnoreCase("1")||eID.equalsIgnoreCase("2")){
//                            itemList=quantifiedMntenceMgr.getSpecialItemSchedule(uSID,"1");
//                        } else{
                        
                    /*   in normal casecheck if quantified table didn't contains data for this eq go to
                       eq_mntc_type_config and get data from it spare parts that added from schedule
                       according to local parts we didn't add it from schedule so no local parts in
                       eq_mntc_type_config*/
                        
//                    if(itemListTemp.size()==0) {
//
//                        ConfigureMainTypeMgr itemsList = ConfigureMainTypeMgr.getInstance();
//                        itemList = itemsList.getConfigItemBySchedule(eID);
//                    } else {
                        itemList = itemListTemp;
//                    }
//                        }
                        
                        attachedEqps=new Vector();
                        attachFlag=0;
                        supplementMgr=SupplementMgr.getInstance();
                        unitScheduleMgr=UnitScheduleMgr.getInstance();
                        unit_sch_wbo=unitScheduleMgr.getOnSingleKey(uSID);
                        Eq_ID=(String)unit_sch_wbo.getAttribute("unitId");
                        attachedEqps=supplementMgr.search(Eq_ID);
                        minorAttachedEqps=supplementMgr.searchAllowedEqps(Eq_ID);
                        if(attachedEqps.size()>0) {
                            request.setAttribute("attachedEqFlag","attached");
                        }else{
                            if(minorAttachedEqps.size()>0) {
                                request.setAttribute("attachedEqFlag","attached");
                            }else{
                                request.setAttribute("attachedEqFlag","notAtt");
                            }
                        }
                        
                        complexIssueMgr=ComplexIssueMgr.getInstance();
                        tradeMgr=TradeMgr.getInstance();
                        complexIssueWbo=null;
                        tradeWbo=null;
                        tradeName="";
                        complexIssues=complexIssueMgr.getOnArbitraryKey(issueId,"key1");
                        for(int i=0;i<complexIssues.size();i++){
                            complexIssueWbo=new WebBusinessObject();
                            tradeWbo=new WebBusinessObject();
                            tradeName="";
                            complexIssueWbo=(WebBusinessObject)complexIssues.get(i);
                            tradeWbo=tradeMgr.getOnSingleKey(complexIssueWbo.getAttribute("tradeId").toString());
                            tradeName=tradeWbo.getAttribute("tradeName").toString();
                            complexIssueWbo.setAttribute("tradeName",tradeName);
                        }
                        
                        request.setAttribute("complexIssues",complexIssues);
                        
                        servedPage = "/docs/complex/add_Local_parts_cmplx.jsp";
                        request.setAttribute("data", itemList);
                        request.setAttribute("uID",uSID);
                        request.setAttribute(IssueConstants.ISSUEID, issueId);
                        request.setAttribute(IssueConstants.ISSUETITLE, issueTitle);
                        request.setAttribute("filter",filterName);
                        request.setAttribute("filterValue",filterValue);
                        request.setAttribute("projectName", projectname);
                        request.setAttribute(IssueConstants.STATE,ais);
                        
                        request.setAttribute("page",servedPage);
                        // String dest = AppConstants.getFullLink(filterName,filterValue);
                        this.forwardToServedPage(request, response);
                        //this.forward(dest, request, response);
                        break;
                        
                        
                    case 16:
                        filterName=(String)request.getParameter("filterName");
                        filterValue=(String)request.getParameter("filterValue");
                        isId = request.getParameter("issueId");
                        maintTitle = request.getParameter("maintTitle");
                        jobNo = request.getParameter("jobNo");
                        
                        //get issue complaints and complaints tasks
                        compTasksVec = new Vector();
                        laborComplaintsMgr=LaborComplaintsMgr.getInstance();
//                        compTasksVec = compTasksMgr.getOnArbitraryKey(isId, "key");
                        compTasksMgr = ComplaintTasksMgr.getInstance();
                        compTasksVec = compTasksMgr.getOnArbitraryKey(isId, "key");
//                        compTasksVec=laborComplaintsMgr.getComplaints(isId);
                        
                        request.setAttribute("maintTitle", maintTitle);
                        request.setAttribute("filterName", filterName);
                        request.setAttribute("filterValue", filterValue);
                        request.setAttribute("jobNo", jobNo);
                        request.setAttribute("issueId", isId);
                        request.setAttribute("comp", compTasksVec);
                        
                        servedPage = "/docs/complex/combine_comp_cmplx.jsp";
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        
                        break;
                        
                    case 17:
                        compTasksVec = new Vector();
                        
                        filterName=(String)request.getParameter("filterName");
                        filterValue=(String)request.getParameter("filterValue");
                        isId=request.getParameter("issueId");
                        maintTitle=request.getParameter("maintTitle");
                        jobNo=request.getParameter("jobNo");
                        status="Fail";
                        
                        LaborComplaintsMgr lbMgr=LaborComplaintsMgr.getInstance();
                        IssueTasksMgr issueTasksMgr = IssueTasksMgr.getInstance();
                        IssueTasksComplaintMgr issueCompliantsMgr = IssueTasksComplaintMgr.getInstance();
                        
                        try {
                            Vector issueComplaintsVec = issueCompliantsMgr.getOnArbitraryKey(isId,"key1");
                            
                            if(issueComplaintsVec != null || issueComplaintsVec.size() <= 0){
                                for(int i=0; i<issueComplaintsVec.size(); i++){
                                    WebBusinessObject issueCompWbo = (WebBusinessObject) issueComplaintsVec.elementAt(i);
                                    
                                    issueCompliantsMgr.deleteOnSingleKey(issueCompWbo.getAttribute("id").toString());
                                    issueTasksMgr.deleteOnArbitraryDoubleKey(isId,"key1", issueCompWbo.getAttribute("taskID").toString(), "key2");
                                }
                            }
                            
                            String [] tasks=request.getParameterValues("taskId");
                            for(int i=0;i<tasks.length;i++){
                                if(!tasks[i].equalsIgnoreCase("---")) {
                                    status="fail";
                                    break;
                                }else{
                                    status="ok";
                                }
                            }
                            
                            if(!status.equalsIgnoreCase("ok")){
                                if(lbMgr.newob(request,isId))
                                    status="ok";
                            }
                            
                            //get issue_complaints
                            compTasksMgr = ComplaintTasksMgr.getInstance();
                            compTasksVec = compTasksMgr.getOnArbitraryKey(isId, "key");
                            
                        } catch (SQLException ex) {
                            ex.printStackTrace();
                        } catch(Exception ex){
                            logger.error(ex.getMessage());
                        }
                        
                        request.setAttribute("filterName", filterName);
                        request.setAttribute("filterValue", filterValue);
                        request.setAttribute("status",status);
                        request.setAttribute("maintTitle",maintTitle);
                        request.setAttribute("jobNo",jobNo);
                        request.setAttribute("issueId",isId);
                        request.setAttribute("comp",compTasksVec);
                        servedPage = "/docs/complex/combine_comp_cmplx.jsp";
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        
                        break;
                        
                    case 18:
                        
                        userObj=(WebBusinessObject)session.getAttribute("loggedUser");
                        String unitName = (String)request.getParameter("unitName");
                        String formName = (String)request.getParameter("formName");
                        Vector categoryTemp = new Vector();
                        int count=0;
                        String url="ComplexIssueServlet?op=listEquipment";
                        maintainableMgr = MaintainableMgr.getInstance();
                        
                        if(unitName != null && !unitName.equals("")){
                            String[] parts = unitName.split(",");
                            unitName = "";
                            for (int i=0;i<parts.length;i++){
                                char temp = (char) new Integer(parts[i]).intValue();
                                unitName +=temp;
                            }
                        }
                        
                        try {
                            if(unitName != null && !unitName.equals("")){
                                categoryTemp = maintainableMgr.getEquipBySubNameOrCode(unitName,userObj.getAttribute("projectID").toString(),"name");
                            }else {
                                String params[]={"1","0",userObj.getAttribute("projectID").toString()};
                                String keys[]={"key3","key5","key11"};
                                //categoryTemp = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                                categoryTemp = maintainableMgr.getOnArbitraryNumberKey(3,params,keys);
                            }
                        } catch (SQLException ex) {
                            Logger.getLogger(ComplexIssueServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ComplexIssueServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        String tempcount=(String)request.getParameter("count");
                        if(tempcount!=null)
                            count=Integer.parseInt(tempcount);
                        
                        Vector category = new Vector();
                        WebBusinessObject wbo=new WebBusinessObject();
                        int index=(count+1)*10;
                        String id="";
                        Vector checkattched=new Vector();
                        supplementMgr=SupplementMgr.getInstance();
                        if(categoryTemp.size()<index)
                            index=categoryTemp.size();
                        for (int i = count*10; i <index ; i++) {
                            wbo = (WebBusinessObject) categoryTemp.get(i);
                            category.add(wbo);
                        }
                        
                        float noOfLinks=categoryTemp.size()/10f;
                        String temp=""+noOfLinks;
                        int intNo=Integer.parseInt(temp.substring(temp.indexOf(".")+1,temp.length()));
                        int links=(int)noOfLinks;
                        if(intNo>0)
                            links++;
                        if(links==1)
                            links=0;
                        
                        servedPage = "/docs/issue/equipments_list.jsp";
                        
                        session.removeAttribute("CategoryID");
                        
                        request.setAttribute("count",""+count);
                        request.setAttribute("noOfLinks",""+links);
                        request.setAttribute("fullUrl", url);
                        request.setAttribute("url", url);
                        request.setAttribute("unitName", unitName);
                        request.setAttribute("formName", formName);
                        
                        request.setAttribute("data", category);
                        request.setAttribute("page", servedPage);
                        
                        this.forward(servedPage, request, response);
                        break;
                    case 19:
                        out = response.getWriter();
                        wbo = new WebBusinessObject();
                        AccountMgr accountMgr = AccountMgr.getInstance();
                        if (accountMgr.updateExtraditionUnit(request.getParameter("issueID"), request.getParameter("unitName"))) {
                            wbo.setAttribute("status", "ok");
                        } else {
                            wbo.setAttribute("status", "fail");
                        }
                        out.write(Tools.getJSONObjectAsString(wbo));
                        break;
                    case 20:
                        out = response.getWriter();
                        wbo = new WebBusinessObject();
                        issueMgr = IssueMgr.getInstance();
                        if (issueMgr.updateExtraditionContractor(request.getParameter("issueID"), request.getParameter("clientID"))) {
                            ClientMgr clientMgr = ClientMgr.getInstance();
                            WebBusinessObject clientTemp = clientMgr.getOnSingleKey(request.getParameter("clientID"));
                            wbo.setAttribute("status", "ok");
                            wbo.setAttribute("contractorName", clientTemp.getAttribute("name"));
                        } else {
                            wbo.setAttribute("status", "fail");
                        }
                        out.write(Tools.getJSONObjectAsString(wbo));
                        break;
                        
                        
                    default:
                        this.forwardToServedPage(request, response);
                }
            }
        } catch (Exception sqlEx) {
            // forward to error page
            sqlEx.printStackTrace();
            System.out.println("Error Msg = "+sqlEx.getMessage());
            logger.error(sqlEx.getMessage());
        }
        
    }
    
    /** Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
    
    /** Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
    
    /** Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Short description";
    }
    
    protected int getOpCode(String opName) {
        
        if (opName.equalsIgnoreCase("SaveComplexIssue")) {
            return 1;
        }
        if (opName.equalsIgnoreCase("Complexparts")) {
            return 2;
        }
        if (opName.equalsIgnoreCase("saveconfigPartsComplex")) {
            return 3;
        }
        if (opName.equalsIgnoreCase("AddWorkersCmplxForm")) {
            return 4;
        }
        if (opName.equalsIgnoreCase("SaveWorkers")) {
            return 5;
        }
        if (opName.equalsIgnoreCase("addTasksCmplxForm")) {
            return 6;
        }
        if (opName.equalsIgnoreCase("saveTasksCmplx")) {
            return 7;
        }
        if (opName.equalsIgnoreCase("AddLabourCompalint")) {
            return 8;
        }
        if (opName.equalsIgnoreCase("ViewMItemsCmplx")) {
            return 9;
        }
        if (opName.equalsIgnoreCase("viewComplexparts")) {
            return 10;
        }
        if (opName.equalsIgnoreCase("viewWorkersCmplx")) {
            return 11;
        }
        if (opName.equalsIgnoreCase("viewLabourCompalint")) {
            return 12;
        }
        if (opName.equalsIgnoreCase("addcomp")) {
            return 13;
        }
        if (opName.equalsIgnoreCase("viewDetailsCmplx")) {
            return 14;
        }
        if (opName.equalsIgnoreCase("ComplexLocalparts")) {
            return 15;
        }
        if (opName.equalsIgnoreCase("assignComplaints")) {
            return 16;
        }
        if (opName.equalsIgnoreCase("composeCmpl")) {
            return 17;
        }
        if (opName.equals("listEquipment")) {
            return 18;
        }
        if (opName.equals("updateRequestExtraditionUnit")) {
            return 19;
        }
        if (opName.equals("updateContractor")) {
            return 20;
        }
        
        return 0;
    }
}
