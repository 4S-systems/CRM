package com.maintenance.servlets;

//import com.maintenance.common.AppConstants;
import com.contractor.db_access.MaintainableMgr;
import com.maintenance.common.ParseSideMenu;
import com.maintenance.common.Tools;
import com.maintenance.db_access.*;
import com.quality_assurance.db_accesss.GenericApprovalStatusMgr;
import com.silkworm.Exceptions.*;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.common.UserMgr;
import com.silkworm.util.*;
import com.tracker.db_access.*;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.*;
import java.sql.SQLException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.*;
import javax.servlet.http.*;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

public class TaskServlet extends TrackerBaseServlet{
    TaskMgr taskMgr =TaskMgr.getInstance();
    UserMgr userMgr =UserMgr.getInstance();
    UnitMgr unitMgr =UnitMgr.getInstance();
    TaskTypeMgr taskTypeMgr = TaskTypeMgr.getInstance();
    ConfigureMainTypeMgr configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
    ConfigTasksPartsMgr configTasksPartsMgr = ConfigTasksPartsMgr.getInstance();
    ConfigAlterTasksPartsMgr configAlterTasksPartsMgr = ConfigAlterTasksPartsMgr.getInstance();
    DistributedItemsMgr distItemsMgr = DistributedItemsMgr.getInstance();
    MainCategoryTypeMgr mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
    EmployeeTitleMgr employeeTitleMgr = EmployeeTitleMgr.getInstance();
    TradeMgr tradeMgr = TradeMgr.getInstance();
    DateAndTimeControl dateAndTime = new DateAndTimeControl();
    String op = null;
    String categoryId=null;

    Vector unitsList = null;
    ArrayList unitArr;
    ArrayList itemCategory;

    String[] quantityMainType = {"",""};
    String[] priceMainType = {"",""};
    String[] idMainType = {"",""};
    String[] itemIdMainType = {"",""};
    String[] itemCost = {"",""};

    MetaDataMgr metaMgr=MetaDataMgr.getInstance();
    ParseSideMenu parseSideMenu=new ParseSideMenu();

    String link="";
    String TaskCode;
    Hashtable style=new Hashtable();
    Vector menuElement=new Vector();
    Hashtable topMenu=new Hashtable();
    Vector tempVec=new Vector();
    Vector taskSideMenuVec;

//    private ExcelCreator excelCreator;

    private HSSFWorkbook workBook;

    @Override
    public void init(ServletConfig config) throws ServletException { super.init(config); }

    @Override
    public void destroy() { }

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        super.processRequest(request,response);
        HttpSession session = request.getSession();

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        switch(operation) {
            case 1:
                System.out.println("i'm hoda");
                Vector tasks=new Vector();
                taskMgr.cashData();
                tasks = taskMgr.getAllItems();
                servedPage = "/docs/Adminstration/new_task.jsp";
                request.setAttribute("data", tasks);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;

//            case 2:
//                dateAndTime = new DateAndTimeControl();
//                int minutes=0;
//
//                servedPage = "/docs/Adminstration/new_task.jsp";
//
//                String tasktitle = null;
//                WebBusinessObject TaskTypeName = new WebBusinessObject();
//                TaskTypeName = taskTypeMgr.getOnSingleKey(request.getParameter("taskType").toString());
//                tasktitle = TaskTypeName.getAttribute("name").toString()+ " - " +request.getParameter("description").toString();
//                WebBusinessObject Ntask = new WebBusinessObject();
//
//                MaintainableMgr maintainableMgr=MaintainableMgr.getInstance();
//
//                String day = (String)request.getParameter("day");
//                String hour = (String)request.getParameter("hour");
//                String minute = (String)request.getParameter("minute");
//
//                if(day != null && !day.equals("")){
//                    minutes = minutes + dateAndTime.getMinuteOfDay(day);
//                }
//                if(hour != null && !hour.equals("")) {
//                    minutes = minutes + dateAndTime.getMinuteOfHour(hour);
//                }
//                if(minute != null && !minute.equals("")) {
//                     minutes = minutes + new Integer(minute).intValue();
//                }
//
//                categoryId = request.getParameter("categoryName");
//                WebBusinessObject catWbo=maintainableMgr.getOnSingleKey(categoryId);
//                String mainTypeId=catWbo.getAttribute("maintTypeId").toString();
//
//                Ntask .setAttribute("title",request.getParameter("title").toString());
//                Ntask .setAttribute("name",request.getParameter("description").toString());
//                Ntask .setAttribute("tradeName",request.getParameter("tradeName").toString());
//                Ntask .setAttribute("taskType",request.getParameter("taskType").toString());
//                Ntask .setAttribute("empTitle",request.getParameter("empTitle").toString());
//                Ntask .setAttribute("taskTitle",tasktitle);
//                Ntask .setAttribute("categoryName",categoryId);
//                Ntask .setAttribute("mainTypeId","");
//                Ntask .setAttribute("isMain","no");
//                Ntask .setAttribute("executionHrs",Integer.toString(minutes));
//                Ntask .setAttribute("jobzise",request.getParameter("jobzise").toString());
//                Ntask .setAttribute("engDesc",request.getParameter("engDesc").toString());
//                Ntask .setAttribute("costHour",request.getParameter("costHour").toString());
//
//                String taskId;
//
//                WebBusinessObject taskWbo=new WebBusinessObject();
//
//                try {
//                    if(!taskMgr.getDoubleName(request.getParameter("title"))) {
//                        taskId=taskMgr.saveTask(Ntask, session);
//                        if(taskId!=null){
//                            request.setAttribute("Status" , "Ok");
//
//                            // create side menu
//                            Tools.createTaskSideMenu(request, taskId);
//                            taskWbo = taskMgr.getOnSingleKey(taskId);
//                        }
//
//                        else
//                            request.setAttribute("Status", "No");
//
//                    }else {
//                        request.setAttribute("Status", "No");
//                        request.setAttribute("name", "Duplicate Name");
//                    }
//                } catch (NoUserInSessionException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//
//                taskMgr.cashData();
//                request.setAttribute("taskWbo",taskWbo);
//                tasks = taskMgr.getAllItems();
//                request.setAttribute("data", tasks);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//
//
//            case 3 :
//
//                StringBuilder  returnXML = new StringBuilder();
//
//                try{
//
//                    taskMgr.cashData();
//                    ArrayList arrMachineItems = taskMgr.getCashedTableAsBusObjects();
//                    int i = 0;
//                    String ttemp;
//                    StringBuffer names=new StringBuffer();
//                    for(; i < arrMachineItems.size(); i++){
//
//                        WebBusinessObject  wbo = (WebBusinessObject)arrMachineItems.get(i);
//
//                        ttemp=wbo.getAttribute("title").toString()+"!=";
//                        names.append(wbo.getAttribute("name").toString()+"!=");
//                        returnXML.append(ttemp);
//
//                        //if(wbo.getAttribute())
//                    }
//                    names.deleteCharAt(names.length()-1);
//                    names.deleteCharAt(names.length()-1);
//                    returnXML.deleteCharAt(returnXML.length( ) - 1);
//                    returnXML.deleteCharAt(returnXML.length( ) - 1);
//                    returnXML.append("&#");
//                    returnXML.append(names);
//
//                } catch (Exception ex){
//                    System.out.println("Get Machine task Exception "+ex.getMessage());
//                }
//                response.setContentType("text/xml;charset=UTF-8");
//                System.err.println(returnXML.toString());
//                response.setHeader("Cache-Control", "no-cache");
//                response.getWriter().write(returnXML.toString( ));
//
//                break;
//
//            case 4:
//                WebBusinessObject wboTrade= new WebBusinessObject();
//                maintainableMgr = MaintainableMgr.getInstance();
//                String code=request.getParameter("value");
//                String desc=" ";
//                String executionHrs=" ";
//                String Jop=" ";
//                String equipType=" ";
//                String jobSize=" ";
//                String id=null;
//                try{
//
//                    taskMgr.cashData();
//                    Vector machineItems = new Vector();
//                    ArrayList arrMachineItems = taskMgr.getCashedTableAsBusObjects();
//                    for(int i = 0; i < arrMachineItems.size(); i++){
//                        WebBusinessObject  wbo = (WebBusinessObject)arrMachineItems.get(i);
//                        String itemCode=wbo.getAttribute("title").toString();
//
//                        if(itemCode.equalsIgnoreCase(code)){
//                            desc=wbo.getAttribute("name").toString();
//                            id=wbo.getAttribute("id").toString();
//
//                            String exeHours = wbo.getAttribute("executionHrs").toString();
//                            Double execHr = 0.0;
//                            int execIntHr = 0;
//                            execHr = new Double(exeHours).doubleValue();
//                            if(execHr<1){
//                                    execHr =1.0;
//                                    }
//                            execIntHr = execHr.intValue();
//                            executionHrs= dateAndTime.getDaysHourMinute(execIntHr);
//
//                            wboTrade = tradeMgr.getOnSingleKey(wbo.getAttribute("trade").toString());
//                            Jop=wboTrade.getAttribute("tradeName").toString();
//                            jobSize=wbo.getAttribute("repairtype").toString();
//                            String parentID=wbo.getAttribute("parentUnit").toString();
//                            WebBusinessObject wboEquipType =  maintainableMgr.getOnSingleKey(parentID);
//                            equipType = wboEquipType.getAttribute("unitName").toString();
//                        }
//                        //if(wbo.getAttribute())
//                    }
//
//                } catch (Exception ex){
//                    logger.error(ex.getMessage());
//                    System.out.println("Get Machine Category Items Exception "+ex.getMessage());
//                }
//                response.setContentType("text/xml;charset=UTF-8");
//
//                response.setHeader("Cache-Control", "no-cache");
//                String re=code+"!="+desc+"!="+id+"!="+executionHrs+"!="+Jop+"!="+jobSize+"!="+equipType;
//                System.err.println(re);
//                response.getWriter( ).write(re);
//
//                break;
//
//            case 5:
//                taskMgr.cashData();
//                tasks = taskMgr.getAllItems();
//                System.out.println("sa ----------------- ");
//                taskWbo=new WebBusinessObject();
//                String isMain="";
//                Vector totalTasks = new Vector();
//
//                for(int i=0;i<tasks.size();i++){
//                    taskWbo=new WebBusinessObject();
//                    isMain="";
//                    taskWbo=(WebBusinessObject)tasks.get(i);
//                    if(taskWbo.getAttribute("isMain").toString().equalsIgnoreCase("yes"))
//                        taskWbo.setAttribute("parentUnit","no");
//                }
//
//                 for(int i=0;i<tasks.size();i++){
//                    taskWbo=new WebBusinessObject();
//                    isMain="";
//                    taskWbo=(WebBusinessObject)tasks.get(i);
//                if (employeeTitleMgr.getOnSingleKey(taskWbo.getAttribute("empTitle").toString()) != null && !employeeTitleMgr.getOnSingleKey(taskWbo.getAttribute("empTitle").toString()).equals("")) {
//                    totalTasks.add(taskWbo);
//                    }
//                    }
//                servedPage = "/docs/Adminstration/Task_List.jsp";
//
//                request.setAttribute("data", totalTasks);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//
//            case 6:
//                String type = null;
//                taskId=null;
//                taskId = request.getParameter("taskId");
//                Vector taskParts= new Vector();
//                WebBusinessObject Approval=null;
//                GenericApprovalStatusMgr genericApprovalStatusMgr = GenericApprovalStatusMgr.getInstance();
//                Approval = genericApprovalStatusMgr.getOnSingleKey1(request.getParameter("taskId"));
//                configTasksPartsMgr=ConfigTasksPartsMgr.getInstance();
//               
//                if(Approval !=null )
//                {
//                    request.setAttribute("flag","true");
//                }
//                else
//                {
//                        request.setAttribute("flag","false");
//                }
//                Ntask = taskMgr.getOnSingleKey(taskId);
//                String page = request.getParameter("page");
//                if(page == null) page = "";
//
//                if(page.equals("bluePage")){
//                    servedPage = "/TaskServlet?op=getTaskDataNotPopup&taskId="+taskId+"&searchType=name&taskName=";
//                    this.forward(servedPage, request, response);
//                } else {
//                    // create side menu
//                    Tools.createTaskSideMenu(request, taskId);
//
//                                    try {
//                    taskParts = configTasksPartsMgr.getOnArbitraryKey(taskId, "key1");
//                    //Vector items=new Vector();
//                    Double totalCost=0.0;
//                    if(taskParts.size()>0){
//                        for(int i=0;i<taskParts.size();i++){
//                            WebBusinessObject taskPartWbo=new WebBusinessObject();
//                            //WebBusinessObject itemWbo=new WebBusinessObject();
//                            taskPartWbo=(WebBusinessObject)taskParts.get(i);
//                            String partCost = (String) taskPartWbo.getAttribute("totalCost");
//                            Double partCostNo= Double.parseDouble(partCost);
//                            totalCost+=partCostNo;
//                       }
//                        Ntask.setAttribute("totalPartsCost", totalCost.toString());
//                        totalCost=0.0;
//                    }
//                } catch (SQLException ex) {
//                    Logger.getLogger(TaskServlet.class.getName()).log(Level.SEVERE, null, ex);
//                } catch (Exception ex) {
//                    Logger.getLogger(TaskServlet.class.getName()).log(Level.SEVERE, null, ex);
//                }
//                    request.setAttribute("Vtask",Ntask);
//
//                    type = (String) Ntask.getAttribute("isMain");
//
//                    if(type.equalsIgnoreCase("yes")) {
//                        servedPage = "/docs/Adminstration/view_Tasks_main.jsp";
//
//                    } else {
//                        servedPage = "/docs/Adminstration/view_Tasks.jsp";
//
//                    }
//                    
//
//                    request.setAttribute("page",servedPage);
//                    this.forwardToServedPage(request, response);
//
//                }
//                  break;
//
//
//            case 7:
//                dateAndTime = new DateAndTimeControl();
//                minutes=0;
//                taskId = request.getParameter("taskId");
//
//                ArrayList mainTypesList = null;
//                ArrayList tradeList = null;
//                ArrayList empTitleList = null;
//                ArrayList tasktypeList = null;
//
//
//                Ntask = taskMgr.getOnSingleKey(taskId);
//                type = (String) Ntask.getAttribute("isMain");
//
//                if(type.equalsIgnoreCase("yes")) {
//                    servedPage = "/docs/Adminstration/update_Tasks_main.jsp";
//
//                    tradeList = tradeMgr.getCashedTableAsBusObjects();
//                    mainTypesList = mainCategoryTypeMgr.getCashedTableAsBusObjects();
//                    tasktypeList = taskTypeMgr.getCashedTableAsBusObjects();
//                    empTitleList = employeeTitleMgr.getCashedTableAsBusObjects();
//
//                    request.setAttribute("mainTypes", mainTypesList);
//                    request.setAttribute("tradeList", tradeList);
//                    request.setAttribute("tasktypeList", tasktypeList);
//                    request.setAttribute("empTitleList", empTitleList);
//
//                } else {
//                     servedPage="/docs/Adminstration/update_Tasks.jsp";
//
//                }
//                day = (String)request.getParameter("day");
//                hour = (String)request.getParameter("hour");
//                minute = (String)request.getParameter("minute");
//
//                if(day != null && !day.equals("")){
//                    minutes = minutes + dateAndTime.getMinuteOfDay(day);
//                }
//                if(hour != null && !hour.equals("")) {
//                    minutes = minutes + dateAndTime.getMinuteOfHour(hour);
//                }
//                if(minute != null && !minute.equals("")) {
//                     minutes = minutes + new Integer(minute).intValue();
//                }
//
//                TaskTypeName = new WebBusinessObject();
//                TaskTypeName = taskTypeMgr.getOnSingleKey(request.getParameter("taskType").toString());
//                tasktitle = TaskTypeName.getAttribute("name").toString()+ " - " +request.getParameter("name").toString();
//                Ntask= new WebBusinessObject();
//                Ntask.setAttribute("title",request.getParameter("title").toString());
//                Ntask.setAttribute("name",request.getParameter("name").toString());
//
//                Ntask.setAttribute("taskId",request.getParameter("taskId").toString());
//                Ntask .setAttribute("tradeName",request.getParameter("tradeName").toString());
//                Ntask .setAttribute("taskType",request.getParameter("taskType").toString());
//                Ntask .setAttribute("empTitle",request.getParameter("empTitle").toString());
//                Ntask .setAttribute("taskTitle",tasktitle);
//                Ntask .setAttribute("categoryName",request.getParameter("categoryName").toString());
//                Ntask .setAttribute("isMain","no");
//                Ntask .setAttribute("executionHrs",Integer.toString(minutes));
//                Ntask .setAttribute("engDesc",request.getParameter("engDesc").toString());
//                Ntask .setAttribute("costHour",request.getParameter("costHour").toString());
//
//                try {
//                    if(!taskMgr.getDoubleNameforUpdate(taskId,request.getParameter("title"))) {
//                        if(taskMgr. updatetaskCode( Ntask, session)){
//                            request.setAttribute("Status" , "Ok");
//
//                            // create side menu
//                            Tools.createTaskSideMenu(request, taskId);
//
//                        }else{
//                            request.setAttribute("Status", "No");
//                        }
//
//                    }else {
//                        request.setAttribute("Status", "No");
//                        request.setAttribute("name", "Duplicate Name");
//                    }
//                } catch (NoUserInSessionException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//
//                Ntask= taskMgr.getOnSingleKey(request.getParameter("taskId"));
//                request.setAttribute("Utask", Ntask);
//                request.setAttribute("taskId", request.getParameter("taskId").toString());
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//
//            case 8:
//                taskId = request.getParameter("taskId");
//                Ntask = taskMgr.getOnSingleKey(taskId );
//
//                type = (String) Ntask.getAttribute("isMain");
//
//                if(type.equalsIgnoreCase("yes")) {
//                    servedPage = "/docs/Adminstration/update_Tasks_main.jsp";
//
//                    tradeList = tradeMgr.getCashedTableAsBusObjects();
//                    mainTypesList = mainCategoryTypeMgr.getCashedTableAsBusObjects();
//                    tasktypeList = taskTypeMgr.getCashedTableAsBusObjects();
//                    empTitleList = employeeTitleMgr.getCashedTableAsBusObjects();
//
//                    request.setAttribute("mainTypes", mainTypesList);
//                    request.setAttribute("tradeList", tradeList);
//                    request.setAttribute("tasktypeList", tasktypeList);
//                    request.setAttribute("empTitleList", empTitleList);
//
//                } else {
//                     servedPage="/docs/Adminstration/update_Tasks.jsp";
//
//                }
//                request.setAttribute("Utask",Ntask);
//                request.setAttribute("taskId",taskId);
//
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//
//            case 9:
//                Ntask = new WebBusinessObject();
//                String title = request.getParameter("taskTitle");
//
//                taskId = request.getParameter("taskId");
//                if (title != null && !title.equals("")){
//                    title = request.getParameter("taskTitle");
//                }else {
//                    Ntask = taskMgr.getOnSingleKey(taskId );
//                    title = Ntask.getAttribute("title").toString();
//
//                }
//                servedPage = "/docs/Adminstration/confirm_delTask.jsp";
//                request.setAttribute("taskTitle",title);
//                request.setAttribute("taskId",taskId);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//
//            case 10:
//                UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
//                IssueTasksMgr issueTasksMgr = IssueTasksMgr.getInstance();
//                IssueMgr issueMgr = IssueMgr.getInstance();
//                int delRows = 0;
//                tasks = taskMgr.getCashedTable();
//                taskId = request.getParameter("taskId");
//                WebBusinessObject wboTask = taskMgr.getOnSingleKey(taskId);
//                Vector issueTaskVec = new Vector();
//                WebBusinessObject issueTaskWbo = new WebBusinessObject();
//                WebBusinessObject issueWbo = new WebBusinessObject();
//                WebBusinessObject unitScheduleWbo = new WebBusinessObject();
//                try {
//                    if(taskMgr.getActiveTask(wboTask.getAttribute("id").toString())) {
//                        issueTaskVec = issueTasksMgr.getOnArbitraryKeyOracle(taskId,"key2");
//                        issueTaskWbo = (WebBusinessObject) issueTaskVec.get(0);
//                        issueWbo = issueMgr.getOnSingleKey(issueTaskWbo.getAttribute("issueID").toString());
//                        unitScheduleWbo = unitScheduleMgr.getOnSingleKey(issueWbo.getAttribute("unitScheduleID").toString());
//                        unitScheduleMgr.deleteOnSingleKey(unitScheduleWbo.getAttribute("id").toString());
//                        if(taskMgr.deleteOnSingleKey(request.getParameter("taskId")))
//                            request.setAttribute("status","ok");
//                        else
//                            request.setAttribute("status","fail");
//
//                    } else {
//                        if(taskMgr.deleteOnSingleKey(request.getParameter("taskId")))
//                            request.setAttribute("status","ok");
//                        else
//                            request.setAttribute("status","fail");
//                    }
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//
//
//                taskMgr.cashData();
//                tasks = taskMgr.getAllItems();
//                System.out.println("sa ----------------- ");
//                taskWbo=new WebBusinessObject();
//                isMain="";
//                for(int i=0;i<tasks.size();i++){
//                    taskWbo=new WebBusinessObject();
//                    isMain="";
//                    taskWbo=(WebBusinessObject)tasks.get(i);
//                    if(taskWbo.getAttribute("isMain").toString().equalsIgnoreCase("yes"))
//                        taskWbo.setAttribute("parentUnit","no");
//                }
//
//                servedPage = "/docs/Adminstration/Task_List.jsp";
//                // remove side Menu from session
//                request.getSession().removeAttribute("sideMenuVec");
//                //////
//                request.setAttribute("data", tasks);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//
//            case 11:
//                Vector equipments=new Vector();
//                MaintainableMgr maintenableUnit = MaintainableMgr.getInstance();
//                maintenableUnit = MaintainableMgr.getInstance();
//                maintenableUnit.cashData();
////                categoryMgr.cashData();
//                equipments = maintenableUnit.getAllCategoryEqu();
//                System.out.println("sa ----------------- ");
//                servedPage = "/docs/Adminstration/tasks_By_Category_List.jsp";
//
//                request.setAttribute("data", equipments);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//
//            case 12:
//                String categoryName = request.getParameter("categoryName");
//                maintenableUnit = MaintainableMgr.getInstance();
//                Vector  Totalitems =new Vector();
//                categoryId="";
//                categoryId=request.getParameter("categoryId");
//                categoryName=request.getParameter("categoryName");
//                session.setAttribute("CategoryID",categoryId);
//
//                maintainableMgr=MaintainableMgr.getInstance();
//                catWbo=maintainableMgr.getOnSingleKey(categoryId);
//
//                try {
////                itemMgr.cashData();
//
//                    Totalitems = taskMgr.getOnArbitraryKey(categoryId,"key1");
//                } catch (SQLException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//                System.out.println("sa ----------------- ");
//                servedPage = "/docs/Adminstration/view_tasks_by_category.jsp";
//
//
//                request.setAttribute("categoryName", categoryName);
//                request.setAttribute("catWbo",catWbo);
//                request.setAttribute("data", Totalitems);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//
//            case 13:
//                Vector trades=new Vector();
////                MaintainableMgr maintenableUnit = MaintainableMgr.getInstance();
//                TradeMgr tradeMgr = TradeMgr.getInstance();
//                tradeMgr = TradeMgr.getInstance();
//                trades=tradeMgr.getCashedTable();
////                categoryMgr.cashData();
////                equipments = maintenableUnit.getAllCategoryEqu();
//                System.out.println("sa ----------------- ");
//                servedPage = "/docs/Adminstration/tasks_By_Trade_List.jsp";
//
//                request.setAttribute("data", trades);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//
//            case 14:
//                String tradeName = request.getParameter("tradeName");
//                Totalitems =new Vector();
//                String tradeId=request.getParameter("tradeId");
//                session.setAttribute("tradeID",tradeId);
//
//                try {
//                    Totalitems = taskMgr.getOnArbitraryKey(tradeId,"key2");
//                } catch (SQLException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//                System.out.println("sa ----------------- ");
//                servedPage = "/docs/Adminstration/view_tasks_by_trade.jsp";
//
//                request.setAttribute("tradeName", tradeName);
//                request.setAttribute("data", Totalitems);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//
//            case 15 :
//
//                returnXML = new StringBuilder();
//                String ttemp;
//                StringBuffer names=new StringBuffer();
//                loggedUser = (WebBusinessObject)session.getAttribute("loggedUser");
//                String projectId = loggedUser.getAttribute("projectID").toString();
//                try{
//                    Vector arrMachineItems=new Vector();
//                    unitMgr.cashData();
//                    WebBusinessObject userWbo=(WebBusinessObject)session.getAttribute("loggedUser");
//
//                    if(userWbo.getAttribute("userType").toString().equalsIgnoreCase("single")){
//                        arrMachineItems = unitMgr.getEquipment();
//                    }else{
//                        arrMachineItems = unitMgr.getEquipment(projectId);
//                    }
//
//                    int i = 0;
//
//                    for(; i < arrMachineItems.size(); i++){
//
//                        WebBusinessObject  wbo = (WebBusinessObject)arrMachineItems.get(i);
//
//                        ttemp=wbo.getAttribute("unitNo").toString()+"!=";
//                        System.out.println(i+"****"+ttemp);
//                        names.append(wbo.getAttribute("unitName").toString()).append("!=");
//                        System.out.println(i+"****"+wbo.getAttribute("unitName").toString());
//                        returnXML.append(ttemp);
//
//                    }
//                    names.deleteCharAt(names.length()-1);
//                    names.deleteCharAt(names.length()-1);
//                    returnXML.deleteCharAt(returnXML.length( ) - 1);
//                    returnXML.deleteCharAt(returnXML.length( ) - 1);
//                    returnXML.append("&#");
//                    returnXML.append(names);
//
//                } catch (Exception ex){
//                    System.out.println("Get Machine task Exception "+ex.getMessage());
//                }
//                response.setContentType("text/xml;charset=UTF-8");
//                System.err.println(returnXML.toString());
//                response.setHeader("Cache-Control", "no-cache");
//                response.getWriter().write(returnXML.toString( ));
//
//                break;
//
//            case 16 :
//
//                returnXML = new StringBuilder();
//                try{
//                    LocalStoresItemsMgr localStoresItemsMgr=LocalStoresItemsMgr.getInstance();
//                    localStoresItemsMgr.cashData();
//                    ArrayList arrMachineItems = localStoresItemsMgr.getCashedTableAsBusObjects();
//                    int i = 0;
//                    ttemp="";
//                    for(; i < arrMachineItems.size(); i++){
//
//                        WebBusinessObject  wbo = (WebBusinessObject)arrMachineItems.get(i);
//                        ttemp=wbo.getAttribute("itemCode").toString()+"!=";
//                        returnXML.append(ttemp);
//                    }
//                    returnXML.deleteCharAt(returnXML.length( ) - 1);
//                    returnXML.deleteCharAt(returnXML.length( ) - 1);
//                    returnXML.append("&#");
//                    for(i=0; i < arrMachineItems.size(); i++){
//
//                        WebBusinessObject  wbo = (WebBusinessObject)arrMachineItems.get(i);
//                        ttemp=wbo.getAttribute("itemName").toString()+"!=";
//                        returnXML.append(ttemp);
//                    }
//                    returnXML.deleteCharAt(returnXML.length( ) - 1);
//                    returnXML.deleteCharAt(returnXML.length( ) - 1);
//
//
//                } catch (Exception ex){
//                    System.out.println("Get Machine Category Items Exception "+ex.getMessage());
//                }
//                response.setContentType("text/xml;charset=UTF-8");
//                System.err.println(returnXML.toString());
//                response.setHeader("Cache-Control", "no-cache");
//                response.getWriter().write(returnXML.toString( ));
//
//                /***********************************************/
//
//                break;
//
//            case 17:
//
//                String name=" ";
//                code=request.getParameter("key").toString();
//                System.out.println("----------------"+code);
//                String price="0.0";
//                id=" ";
//                String Des=" ";
//                String cat=" ";
//
//                /***********************************************/
//                try{
//
//                    LocalStoresItemsMgr localStoresItemsMgr=LocalStoresItemsMgr.getInstance();
//                    localStoresItemsMgr.cashData();
//                    Vector machineItems = new Vector();
//                    ArrayList arrMachineItems = localStoresItemsMgr.getCashedTableAsBusObjects();
//                    for(int i = 0; i < arrMachineItems.size(); i++){
//                        WebBusinessObject  wbo = (WebBusinessObject)arrMachineItems.get(i);
//                        String itemCode=wbo.getAttribute("itemCode").toString();
//                        if(itemCode.equalsIgnoreCase(code)){
//                            name=wbo.getAttribute("itemName").toString();
//                            price=wbo.getAttribute("itemPrice").toString();
//                            id=wbo.getAttribute("id").toString();
//                            Des=wbo.getAttribute("notes").toString();
//                            break;
//                        }
//
//                    }
//
//                } catch (Exception ex){
//                    System.out.println("Get Machine Category Items Exception "+ex.getMessage());
//                }
//                response.setContentType("text/xml;charset=UTF-8");
//
//                response.setHeader("Cache-Control", "no-cache");
//                String returnValue=name+","+price+","+id+","+Des+","+cat;
//                System.err.println(returnValue);
//                response.getWriter( ).write(returnValue);
//                /************************************************/
//
//                break;
//
//            case 18:
//                String schType=request.getParameter("schType");
//                servedPage = "/docs/schedule/config_timely_schedule_local.jsp";
//
//                String scheduleTitle = request.getParameter("scheduleTitle");
//                String scheduleId = request.getParameter("scheduleId");
//                String equipmentID=request.getParameter("equipmentID");
//                if(null!=equipmentID){
//                    if("listAllSchdual".equalsIgnoreCase(request.getParameter("scr")))
//                        request.setAttribute("url","op=ListAllSchedules&equipmentCat="+request.getParameter("categoryId"));
//                    categoryId = request.getParameter("categoryId");
//                    request.setAttribute("categoryId", categoryId);
//                } else{
//
//                    request.setAttribute("url","op=ListAllEquipmentSchedules&equipmentID="+(String)request.getParameter("equipmentID"));
//                }
//                if(request.getParameter("fromView")!=null&&session.getAttribute("urlBackToView")!=null)
//                    request.setAttribute("url",session.getAttribute("urlBackToView"));
//                request.setAttribute("scheduleTitle",scheduleTitle);
//                request.setAttribute("scheduleId", scheduleId);
//                request.setAttribute("schType", schType);
//
//
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//
//            case 19:
//                int  x=1000;
//                int y=600;
//                int z = x / y;
//                schType=request.getParameter("schType");
//                System.out.print("thee modddddd is"+z);
//                String status = request.getParameter("status");
//                ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
//                scheduleMgr.cashData();
//
//                quantityMainType = request.getParameterValues("Hqun");
//                priceMainType = request.getParameterValues("Hprice");
//                idMainType = request.getParameterValues("Hnote");
//                itemIdMainType = request.getParameterValues("Hcode");
//                itemCost = request.getParameterValues("Hcost");
//                String[] itemDes = request.getParameterValues("des");
//                String[] itemCat = request.getParameterValues("cat");
//                String E_Cat=request.getParameter("Cat_id");
//
//
//                if(quantityMainType != null) {
//                    System.out.println(" ===================> "+ itemDes.length );
//                    int size=quantityMainType.length;
//                    String[][] M_Cat_con=new String[size][5];
//                    try {
//                        configureMainTypeMgr.deleteOnArbitraryKey(request.getParameter("scheduleId"),"key1");
//                    } catch (SQLException ex) {
//                        logger.error(ex.getMessage());
//                    } catch (Exception ex) {
//                        logger.error(ex.getMessage());
//                    }
//                    for(int i = 0 ; i < size; i++) {
//                        Hashtable hashConfig;
//
//                        M_Cat_con[i][0]="no";
//                        if(!quantityMainType[i].equals("")&&!quantityMainType[i].equals("0")){
//
//                            System.out.println(quantityMainType[i]+", "+itemCost[i]);
//                            hashConfig = new Hashtable();
//                            hashConfig.put("scheduleId", request.getParameter("scheduleId"));
//                            hashConfig.put("itemID", "local&#"+itemIdMainType[i]);
//                            hashConfig.put("itemQuantity", quantityMainType[i]);
//                            hashConfig.put("itemPrice", priceMainType[i]);
//                            hashConfig.put("totalCost", itemCost[i]);
//                            hashConfig.put("note", idMainType[i]);
//                            System.out.println("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh "+itemIdMainType[i]+" "+itemCat[i]+" "+itemDes[i]+"  "+priceMainType[i]);
//
//
//
//                            M_Cat_con[i][0]=E_Cat;
//                            M_Cat_con[i][1]=itemIdMainType[i];
//                            M_Cat_con[i][2]=itemCat[i];
//                            M_Cat_con[i][3]=itemDes[i];
//                            M_Cat_con[i][4]=priceMainType[i];
//
//
//                            try {
//
//                                configureMainTypeMgr.saveObject(hashConfig,session);
//
////                                issueMgr.updateConfigureValue(ScheduleUnitId);
//                                request.setAttribute("Status", "OK");
//                            } catch(Exception ex) {
//                                System.out.println("General Exception:" + ex.getMessage());
//                            }
//                        }
//                    }
//                    try {
//                        new ConfigureCategoryMgr().saveObject(M_Cat_con,size);
//                    } catch(Exception ex) {
//                        System.out.println("General Exception:" + ex.getMessage());
//                    }
//                }
//
//                if(request.getParameter("url")!=null)
//                    request.setAttribute("url",request.getParameter("url"));
//
//                servedPage = "/docs/schedule/schedule_mainType_config.jsp";
//                request.setAttribute("schType", schType);
//                request.setAttribute("status", status);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//
//                break;
//
//            case 20:
//                maintainableMgr=MaintainableMgr.getInstance();
//                ArrayList allEquipments=new ArrayList();
//                Vector eqps=new Vector();
//
//                try {
//                    eqps=maintainableMgr.getOnArbitraryDoubleKey("0","key3","0","key5");
//                } catch (SQLException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//                WebBusinessObject wbo=new WebBusinessObject();
//
//                for(int i=0;i<eqps.size();i++) {
//                    wbo=(WebBusinessObject)eqps.get(i);
//                    allEquipments.add(wbo);
//                }
//
//                servedPage = "/docs/reports/items_Report_form.jsp";
//                request.setAttribute("currentMode","Ar");
//                request.setAttribute("data", allEquipments);
//                request.setAttribute("page", servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//
//            case 21:
//                maintainableMgr = MaintainableMgr.getInstance();
//                Vector itemWboVec  = null;
//                categoryId = (String)request.getParameter("categoryId");
//
//                String [] options = null;
//                options = (String[]) request.getParameterValues("itemData");
//
//                if(categoryId.equalsIgnoreCase("all")){
//                    String query = "select ";
//                    if(options == null || options.length<=0){
//                        query+= "TASK_NAME, PARENT_UNIT ";
//                    } else {
//                        query+= "TASK_NAME , PARENT_UNIT, ";
//                        for(int i=0;i<options.length;i++) {
//                            query+= options[i]+",";
//                        }
//                    }
//
//                    query = query.trim().substring(0,query.length()-1);
//                    query+= " FROM TASKS where IS_MAIN = 'no' order by PARENT_UNIT ";
//
//                    itemWboVec = taskMgr.getItemRecordAll(query);
//                    WebBusinessObject itemWbo=null;
//                    WebBusinessObject unitWbo=null;
//                    WebBusinessObject mainTypeWbo=null;
//                    maintainableMgr=MaintainableMgr.getInstance();
//                    MainCategoryTypeMgr mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
//
//                    //get first element in parent category
//                    WebBusinessObject firstItemWbo = (WebBusinessObject) itemWboVec.elementAt(0);
//                    WebBusinessObject firstUnitWbo = maintainableMgr.getOnSingleKey(firstItemWbo.getAttribute("parentUnit").toString());
//                    String flagName = firstUnitWbo.getAttribute("unitName").toString();
//                    boolean firstTime = true;
//                    for(int i=0;i<itemWboVec.size();i++){
//                        itemWbo=new WebBusinessObject();
//                        unitWbo=new WebBusinessObject();
//
//                        itemWbo=(WebBusinessObject)itemWboVec.get(i);
//
//                        unitWbo = maintainableMgr.getOnSingleKey(itemWbo.getAttribute("parentUnit").toString());
//
//                        if(unitWbo!=null){
//                            mainTypeWbo=new WebBusinessObject();
//                            mainTypeWbo=mainCategoryTypeMgr.getOnSingleKey(unitWbo.getAttribute("maintTypeId").toString());
//                            if(mainTypeWbo.getAttribute("isAgroupEq").toString().equals("0")){
//                                if(flagName.equalsIgnoreCase(unitWbo.getAttribute("unitName").toString())){
//                                    if(firstTime == true){
//                                        firstTime = false;
//                                        itemWbo.setAttribute("unitName",unitWbo.getAttribute("unitName").toString());
//                                    } else {
//                                        itemWbo.setAttribute("unitName"," ");
//                                    }
//                                } else {
//                                    flagName = unitWbo.getAttribute("unitName").toString();
//                                    firstTime = false;
//                                    itemWbo.setAttribute("unitName",unitWbo.getAttribute("unitName").toString());
//                                }
//                            }else{
//                                itemWboVec.remove(i);
//                                i--;
//                            }
//                        }else{
//                            itemWboVec.remove(i);
//                            i--;
//                        }
//                    }
//                    servedPage = "/docs/reports/item_Report_all.jsp";
//                } else {
//                    catWbo=new WebBusinessObject();
//                    catWbo = (WebBusinessObject) maintainableMgr.getOnSingleKey(categoryId);
//
//                    String query = "select ";
//                    if(options == null || options.length<=0){
//                        query+= "TASK_NAME ";
//                    } else {
//                        query+= "TASK_NAME , ";
//                        for(int i=0;i<options.length;i++) {
//                            query+= options[i]+",";
//                        }
//                    }
//
//                    query = query.trim().substring(0,query.length()-1);
//                    query+= " FROM TASKS WHERE PARENT_UNIT = ? order by TASK_NAME ";
//
//                    itemWboVec = taskMgr.getItemRecord(query,categoryId);
//
//                    servedPage = "/docs/reports/item_Report.jsp";
//                    request.setAttribute("catWbo", catWbo);
//                }
//
//                request.setAttribute("items", options);
//                request.setAttribute("data", itemWboVec);
//                this.forward(servedPage,request, response);

////                break;

            case 22:
//                eqps= new Vector();
//                excelCreator = new ExcelCreator();
//                com.maintenance.common.AppConstants headersData = new AppConstants();
//                Hashtable itemHeaders = headersData.getItemHeaders();
//
//                Vector items = (Vector) request.getSession().getAttribute("data");
//                String []itemsData= (String[]) request.getSession().getAttribute("items");
//
//                String[] headers=new String [itemsData.length+1];
//                String[] attributes=new String [itemsData.length+1];
//                String[] dataTypes=new String[itemsData.length+1];
//                headers[0]=(String)itemHeaders.get("EnITEM_NAME");
//                attributes[0]="name";
//                dataTypes[0]="String";
//                String headerItem="";
//                for(int i=0;i<itemsData.length;i++){
//                    headers[i+1]=(String)itemHeaders.get("En"+(String)itemsData[i]);
//                    attributes[i+1]=(String)itemHeaders.get("Att"+(String)itemsData[i]);
//                    dataTypes[i+1]="String";
//                }
//
//                workBook = excelCreator.createExcelFile(headers, attributes, dataTypes, items, 0);
//
//                response.setHeader("Content-Disposition",
//                        "attachment; filename=\""+ "Equipments_Status.xls");
//                workBook.write(response.getOutputStream());
//
//                response.getOutputStream().flush();
//                response.getOutputStream().close();
//
              break;

            case 23:
//                taskMgr = TaskMgr.getInstance();
//                ItemsMgr itemsMgr = ItemsMgr.getInstance();
//                taskWbo = new WebBusinessObject();
//                WebBusinessObject taskPartWbo = new WebBusinessObject();
//                WebBusinessObject itemWbo = new WebBusinessObject();
//
//                taskId = "";
//                WebBusinessObject item = new WebBusinessObject();
//
//                taskId = request.getParameter("taskId");
//                taskWbo = taskMgr.getOnSingleKey(taskId);
//                taskParts = new Vector();
//                String[] itemCode = null;
//                try {
//                    taskParts = configTasksPartsMgr.getOnArbitraryKey(taskId, "key1");
//                    items=new Vector();
//                    if(taskParts.size()>0){
//                        for(int i = 0; i < taskParts.size(); i++){
//                            taskPartWbo = new WebBusinessObject();
//                            itemWbo = new WebBusinessObject();
//                            items = new Vector();
//
//                            taskPartWbo = (WebBusinessObject)taskParts.get(i);
//                            itemCode = (String[]) taskPartWbo.getAttribute("itemId").toString().split("-");
//                            if(itemCode.length > 1) {
//                             item = itemsMgr.getOnSingleKey(taskPartWbo.getAttribute("itemId").toString());
//                             taskPartWbo.setAttribute("itemId",item.getAttribute("itemCodeByItemForm"));
//                            } else {
//                             item = itemsMgr.getOnObjectByKey(taskPartWbo.getAttribute("itemId").toString());
//                             taskPartWbo.setAttribute("itemId",item.getAttribute("itemCode"));
//                            }
//                            taskPartWbo.setAttribute("itemName",item.getAttribute("itemDscrptn"));
//                        }
//                    }
//
//                } catch (SQLException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//
//                // get all Store From Erp as ex.
//                Tools.setRequestByStoreInfo(request);
//
//                servedPage = "/docs/Adminstration/add_item_parts.jsp";
//                request.setAttribute("page",servedPage);
//                request.setAttribute("taskWbo",taskWbo);
//                request.setAttribute("taskParts",taskParts);
//                this.forwardToServedPage(request, response);
                break;

            case 24:
//                String branch, store;
//                Vector<Hashtable> allParts = new Vector<Hashtable>();
//                taskMgr=TaskMgr.getInstance();
//                taskWbo=new WebBusinessObject();
//                configTasksPartsMgr=ConfigTasksPartsMgr.getInstance();
//                itemsMgr=ItemsMgr.getInstance();
//
//                servedPage = "/docs/Adminstration/add_item_parts.jsp";
//                taskId=request.getParameter("taskId");
//                taskWbo=taskMgr.getOnSingleKey(taskId);
//
//                try {
//                    if(taskId != null){
//
//                        /*********************************************/
//                        String[] quantityPartsForEquipment = request.getParameterValues("qun");
//                        String[] pricePartsForEquipment = request.getParameterValues("price");
//                        String[] notesPartsForEquipment = request.getParameterValues("note");
//                        String[] itemIdPartsForEquipment = request.getParameterValues("code");
//                        String[] itemCostPartsForEquipment = request.getParameterValues("cost");
//                        String[] branchs = request.getParameterValues("branch");
//                        String[] stores = request.getParameterValues("store");
//                        /************ Delete Previous item Parts**************/
//                        configTasksPartsMgr.deleteOnArbitraryKey(taskId, "key1");
//                        /*************end of delete*************/
//                        int size=quantityPartsForEquipment.length;
//                        Hashtable<String, String> hashConfig;
//
//                        for(int i = 0 ; i < size; i++) {
//                            branch = branchs[i];
//                            store = stores[i];
//
//                            if((branch != null && !branch.equals("none") && !branch.equals("null")) && (store != null && !store.equals("none") && !store.equals("null"))) {
//                                hashConfig = new Hashtable<String, String>();
//                                hashConfig.put("TaskCode",taskId);
//                                hashConfig.put("itemID", itemIdPartsForEquipment[i]);
//                                hashConfig.put("itemQuantity", quantityPartsForEquipment[i]);
//                                hashConfig.put("itemPrice", pricePartsForEquipment[i]);
//                                hashConfig.put("totalCost", itemCostPartsForEquipment[i]);
//                                hashConfig.put("note", notesPartsForEquipment[i]);
//                                hashConfig.put("branch", branchs[i]);
//                                hashConfig.put("store", stores[i]);
//
//                                allParts.addElement(hashConfig);
//                            } else {
//                                // cannot save store or branch by null or none
//                                request.setAttribute("Status", "No");
//                                break;
//                            }
//                        }
//
//                        if(configTasksPartsMgr.saveObjects(allParts)) {
//                            request.setAttribute("Status", "OK");
//                        } else {
//                            request.setAttribute("Status", "No");
//                        }
//                    } else {
//                        request.setAttribute("Status", "No");
//                    }
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//
//                taskParts=new Vector();
//                distItemsMgr=DistributedItemsMgr.getInstance();
//
//                try {
//
//                    taskParts=configTasksPartsMgr.getOnArbitraryKey(taskId,"key1");
//                    items=new Vector();
//                    if(taskParts.size()>0){
//                        for(int i=0;i<taskParts.size();i++){
//                            taskPartWbo=new WebBusinessObject();
//                            itemWbo=new WebBusinessObject();
//                            items=new Vector();
//
//                            taskPartWbo=(WebBusinessObject)taskParts.get(i);
//                            itemCode = (String[]) taskPartWbo.getAttribute("itemId").toString().split("-");
//                            if(itemCode.length > 1) {
//                             item = itemsMgr.getOnSingleKey(taskPartWbo.getAttribute("itemId").toString());
//                             taskPartWbo.setAttribute("itemId",item.getAttribute("itemCodeByItemForm"));
//                            } else {
//                             item = itemsMgr.getOnObjectByKey(taskPartWbo.getAttribute("itemId").toString());
//                             taskPartWbo.setAttribute("itemId",item.getAttribute("itemCode"));
//                            }
//                            taskPartWbo.setAttribute("itemName",item.getAttribute("itemDscrptn"));
//                        }
//                    }
//
//                } catch (SQLException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//
//                // get all Store From Erp as ex.
//                Tools.setRequestByStoreInfo(request);
//
//                request.setAttribute("taskWbo",taskWbo);
//                request.setAttribute("taskParts",taskParts);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
              break;

            case 25:
//                taskMgr=TaskMgr.getInstance();
//                taskWbo=new WebBusinessObject();
//                configTasksPartsMgr=ConfigTasksPartsMgr.getInstance();
//                itemsMgr=ItemsMgr.getInstance();
//
//                servedPage = "/docs/Adminstration/view_item_parts.jsp";
//                taskId=request.getParameter("taskId");
//                taskWbo=taskMgr.getOnSingleKey(taskId);
//
//                distItemsMgr=DistributedItemsMgr.getInstance();
//                taskParts=new Vector();
//                Vector taskPartsTemp=new Vector();
//                Vector alterTaskPartsTemp=new Vector();
//
//
//
//
//                try {
//
//                    taskParts=configTasksPartsMgr.getOnArbitraryKey(taskId,"key1");
//                    items=new Vector();
//                    if(taskParts.size()>0){
//                        for(int i=0;i<taskParts.size();i++){
//                            taskPartWbo=new WebBusinessObject();
//                            itemWbo=new WebBusinessObject();
//                            items=new Vector();
//
//                            taskPartWbo=(WebBusinessObject)taskParts.get(i);
////                            items=itemsMgr.getOnArbitraryKey(taskPartWbo.getAttribute("itemId").toString(),"key3");
////                            if(items.size()>0){
////                                itemWbo=(WebBusinessObject)items.get(0);
////                                taskPartWbo.setAttribute("itemName",itemWbo.getAttribute("itemDscrptn").toString());
////                            }
//                             itemCode = (String[]) taskPartWbo.getAttribute("itemId").toString().split("-");
//                            if(itemCode.length > 1) {
//                             item = itemsMgr.getOnSingleKey(taskPartWbo.getAttribute("itemId").toString());
//                             taskPartWbo.setAttribute("itemId",item.getAttribute("itemCodeByItemForm"));
//                            } else {
//                             item = itemsMgr.getOnObjectByKey(taskPartWbo.getAttribute("itemId").toString());
//                             taskPartWbo.setAttribute("itemId",item.getAttribute("itemCode"));
//                            }
////                            item = distItemsMgr.getOnSingleKey(taskPartWbo.getAttribute("itemId").toString());
//                            taskPartWbo.setAttribute("itemName",item.getAttribute("itemDscrptn"));
//
//                        }
//                    }
//
//                } catch (SQLException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//
//                request.setAttribute("taskWbo",taskWbo);
//                request.setAttribute("taskParts",taskParts);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
               break;

//            case 26:
//
//                servedPage = "/docs/Adminstration/add_task_light_tools.jsp";
//                taskMgr=TaskMgr.getInstance();
//                taskWbo=new WebBusinessObject();
//                TaskToolsMgr taskToolsMgr=TaskToolsMgr.getInstance();
//                Vector taskToolsVec=new Vector();
//                maintainableMgr=MaintainableMgr.getInstance();
//                WebBusinessObject eqpWbo=new WebBusinessObject();
//                WebBusinessObject taskToolWbo=new WebBusinessObject();
//                String toolId="";
//
//                taskId=request.getParameter("taskId");
//
//                try {
//                    /**** Number 2 means light tools ****/
//                    taskToolsVec=taskToolsMgr.getOnArbitraryDoubleKey(taskId,"key1","2","key3");
//                } catch (SQLException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//
//                taskWbo=taskMgr.getOnSingleKey(taskId);
//                ToolsMgr toolsMgr=ToolsMgr.getInstance();
//                WebBusinessObject toolWbo=new WebBusinessObject();
//
//                for(int i=0;i<taskToolsVec.size();i++){
//                    taskToolWbo=new WebBusinessObject();
//                    toolWbo=new WebBusinessObject();
//
//                    toolId="";
//
//                    taskToolWbo=(WebBusinessObject)taskToolsVec.get(i);
//                    toolId=taskToolWbo.getAttribute("toolId").toString();
//                    toolWbo=toolsMgr.getOnSingleKey(toolId);
//                    taskToolWbo.setAttribute("toolName",toolWbo.getAttribute("toolName").toString());
//                    taskToolWbo.setAttribute("toolCode",toolWbo.getAttribute("toolCode").toString());
//
//                }
//
//                request.setAttribute("taskId",taskId);
//                request.setAttribute("taskWbo",taskWbo);
//                request.setAttribute("tools",taskToolsVec);
//
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//
//            case 27:
//
//                servedPage = "/docs/Adminstration/add_task_tools.jsp";
//                taskMgr=TaskMgr.getInstance();
//                taskWbo=new WebBusinessObject();
//                taskToolsMgr=TaskToolsMgr.getInstance();
//                taskToolsVec=new Vector();
//                maintainableMgr=MaintainableMgr.getInstance();
//                eqpWbo=new WebBusinessObject();
//                taskToolWbo=new WebBusinessObject();
//                toolId="";
//
//                taskId=request.getParameter("taskId");
//
//                try {
//                    taskToolsVec=taskToolsMgr.getOnArbitraryDoubleKey(taskId,"key1","1","key3");
//                } catch (SQLException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//
//                taskWbo=taskMgr.getOnSingleKey(taskId);
//
//                for(int i=0;i<taskToolsVec.size();i++){
//                    taskToolWbo=new WebBusinessObject();
//                    eqpWbo=new WebBusinessObject();
//                    toolId="";
//
//                    taskToolWbo=(WebBusinessObject)taskToolsVec.get(i);
//                    toolId=taskToolWbo.getAttribute("toolId").toString();
//                    eqpWbo=maintainableMgr.getOnSingleKey(toolId);
//                    taskToolWbo.setAttribute("toolName",eqpWbo.getAttribute("unitName").toString());
//                    taskToolWbo.setAttribute("toolCode",eqpWbo.getAttribute("unitNo").toString());
//
//                }
//
//
//                request.setAttribute("taskId",taskId);
//                request.setAttribute("taskWbo",taskWbo);
//                request.setAttribute("tools",taskToolsVec);
//
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//
//            case 28:
//
//                request.getSession().removeAttribute("sideMenuVec");
//                servedPage = "/manager_agenda.jsp";
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//
//            case 29:
//
//                taskId=request.getParameter("taskId");
//                taskMgr=TaskMgr.getInstance();
//                TaskExecutionNotesMgr taskExecutionNotesMgr=TaskExecutionNotesMgr.getInstance();
//                taskWbo=new WebBusinessObject();
//                taskWbo=taskMgr.getOnSingleKey(taskId);
//
//                Vector taskNotesVec=new Vector();
//
//                try {
//
//                    taskNotesVec=taskExecutionNotesMgr.getOnArbitraryKey(taskId,"key1");
//
//                } catch (SQLException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//
//                request.setAttribute("taskNotes",taskNotesVec);
//                request.setAttribute("taskWbo",taskWbo);
//
//                servedPage = "/docs/Adminstration/add_task_exec_notes.jsp";
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);

//            case 30:

//                WebBusinessObject userObj=(WebBusinessObject)session.getAttribute("loggedUser");
//                Vector activeStoreVec = new Vector();
//                Vector itemList = new Vector();
//                ActiveStoreMgr activeStoreMgr = ActiveStoreMgr.getInstance();
//                ItemFormListMgr itemFormMgr = ItemFormListMgr.getInstance();
//                activeStoreVec = new Vector();
//                activeStoreVec = activeStoreMgr.getActiveStore(session);
//                WebBusinessObject activeStoreWbo = new WebBusinessObject();
//                activeStoreWbo =(WebBusinessObject) activeStoreVec.get(0);
//                WebBusinessObject itemFormCodeWbo = new WebBusinessObject();
//                Vector itemFormListVec = new Vector();
//                int links = 0;
//                float noOfLinks=0;
//                String temp=null;
//                int intNo =0;
//                try {
//                     itemFormListVec = (Vector) itemFormMgr.getOnArbitraryKeyOrdered(activeStoreWbo.getAttribute("storeCode").toString(), "key1","key");
//                } catch (SQLException ex) {
//                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
//                } catch (Exception ex) {
//                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
//                }
//                itemFormCodeWbo = (WebBusinessObject) itemFormListVec.get(0);
//                String itemFormCode = (String) itemFormCodeWbo.getAttribute("codeForm");
//                itemsMgr = ItemsMgr.getInstance();
//                String itemForm = (String) request.getParameter("itemForm");
//                String sparePart = (String) request.getParameter("partName");
//                String partIdByForm = (String) request.getParameter("partIdByForm");
//
//                String formName = (String)request.getParameter("formName");
//                if(sparePart != null && !sparePart.equals("")){
//                    String[]parts = sparePart.split(",");
//                    sparePart = "";
//                    for (int i=0;i<parts.length;i++){
//                        char c = (char) new Integer(parts[i]).intValue();
//                        sparePart +=c;
//                    }
//                }
//
//
//                items = new Vector();
//                int count=0;
//                String url="TaskServlet?op=listParts&formName="+formName;
//                String tempcount=(String)request.getParameter("count");
//                if(tempcount!=null){
//                    count=Integer.parseInt(tempcount);
//                }
//                int index=(count+1)*50;
//                itemsMgr = ItemsMgr.getInstance();
//                activeStoreVec = activeStoreMgr.getActiveStore(session);
//                if(activeStoreVec.size()>0){
//                if (partIdByForm != null && !partIdByForm.equals("")){
//                    String[] item_Form = partIdByForm.split("-");
//                    items = itemsMgr.getSparePartByNameAndItemForm(sparePart,item_Form[0],session);
//                    itemForm = item_Form[0];
//                }else{
//                if(itemForm != null && !itemForm.equals("")){
//                if(sparePart != null && !sparePart.equals("")){
//                    items = itemsMgr.getSparePartByNameAndItemForm(sparePart,itemForm,session);
//                }else {
//                    items = itemsMgr.getSparePartByNameAndItemForm("",itemForm,session);
//                }
//                }else{
//                     if(sparePart != null && !sparePart.equals("")){
//                         items = itemsMgr.getSparePartByNameAndItemForm(sparePart,itemFormCode,session);
//                     }else{
//                    items = itemsMgr.getSparePartByNameAndItemForm("",itemFormCode,session);
//                     }
//                }
//                }
//                itemList = new Vector();
//
//                if(items.size()<index)
//                    index=items.size();
//                for (int i = count*50; i <index ; i++) {
//                    wbo = (WebBusinessObject) items.get(i);
//                    itemList.add(wbo);
//                }
//
//
//                noOfLinks=items.size()/20f;
//                temp=""+noOfLinks;
//                intNo=Integer.parseInt(temp.substring(temp.indexOf(".")+1,temp.length()));
//                links=(int)noOfLinks;
//                if(intNo>0)
//                    links++;
//                if(links==1)
//                    links=0;
//                request.setAttribute("data", itemList);
//                request.setAttribute("noOfLinks",""+links);
//                request.setAttribute("setupStore","1");
//                } else {
//                    request.setAttribute("setupStore","0");
//                }
//
//                //////////////
//
//                servedPage = "/docs/Adminstration/parts_list.jsp";
//
//                request.setAttribute("count",""+count);
//                request.setAttribute("noOfLinks",""+links);
//                request.setAttribute("fullUrl", url);
//                request.setAttribute("url", url);
//                request.setAttribute("partName", sparePart);
//                request.setAttribute("formName", formName);
//
//                request.setAttribute("numRows", request.getParameter("numRows"));
//
//                request.setAttribute("data", itemList);
//                request.setAttribute("page", servedPage);
//
//                this.forward(servedPage, request, response);
//              break;

            case 31:

//                userObj=(WebBusinessObject)session.getAttribute("loggedUser");
//                String taskName = (String)request.getParameter("taskName");
//                formName = (String)request.getParameter("formName");
//                url="TaskServlet?op=listTasks&formName="+formName;
//                count=0;
//
//                taskMgr=TaskMgr.getInstance();
//                tasks = new Vector();
//
//                if(taskName != null && !taskName.equals("")){
//                    String[] codeName = taskName.split(",");
//                    taskName = "";
//                    for (int i=0;i<codeName.length;i++){
//                        char tempCh = (char) new Integer(codeName[i]).intValue();
//                        taskName +=tempCh;
//                    }
//                }
//
//                try {
//                    if(taskName != null && !taskName.equals("")){
//                        tasks=taskMgr.getTasksBySubName(taskName);
//                    }else {
//                        taskMgr.cashData();
//                        tasks=taskMgr.getCashedTable();
//                    }
//                } catch (Exception ex) {
//                    Logger.getLogger(TaskServlet.class.getName()).log(Level.SEVERE, null, ex);
//                }
//
//                tempcount=(String)request.getParameter("count");
//                if(tempcount!=null)
//                    count=Integer.parseInt(tempcount);
//
//                tradeMgr=TradeMgr.getInstance();
//
//                Vector subTasks = new Vector();
//                wbo=new WebBusinessObject();
//                wboTrade=new WebBusinessObject();
//                maintainableMgr=MaintainableMgr.getInstance();
//                mainCategoryTypeMgr=MainCategoryTypeMgr.getInstance();
//
//                String job="";
//
//                index=(count+1)*10;
//                id="";
//                if(tasks.size()<index)
//                    index=tasks.size();
//                for (int i = count*10; i <index ; i++) {
//                    wbo = (WebBusinessObject) tasks.get(i);
//                    wboTrade = tradeMgr.getOnSingleKey(wbo.getAttribute("trade").toString());
//                    if(wboTrade!=null){
//                        job=wboTrade.getAttribute("tradeName").toString();
//                        wbo.setAttribute("trade",job);
//                        if(wbo.getAttribute("isMain").toString().equalsIgnoreCase("no")){
//                            String parentID=wbo.getAttribute("parentUnit").toString();
//                            WebBusinessObject wboEquipType =  maintainableMgr.getOnSingleKey(parentID);
//                            equipType = wboEquipType.getAttribute("unitName").toString();
//                        }else{
//                            mainTypeId=wbo.getAttribute("mainTypeId").toString();
//                            WebBusinessObject wboEquipType =  mainCategoryTypeMgr.getOnSingleKey(mainTypeId);
//                            equipType = wboEquipType.getAttribute("typeName").toString();
//                        }
//                        wbo.setAttribute("eqpName",equipType);
//                        subTasks.add(wbo);
//                    }else{
//                        tasks.remove(i);
//                        i--;
//                    }
//                }
//
//                noOfLinks=tasks.size()/10f;
//                temp=""+noOfLinks;
//                intNo=Integer.parseInt(temp.substring(temp.indexOf(".")+1,temp.length()));
//                links=(int)noOfLinks;
//                if(intNo>0)
//                    links++;
//                if(links==1)
//                    links=0;
//
//                servedPage = "/docs/Adminstration/tasks_list.jsp";
//
//                String temRows=request.getParameter("numRows");
//                if(temRows==null || temRows.equalsIgnoreCase(""))
//                    temRows=""+0;
//
//                request.setAttribute("count",""+count);
//                request.setAttribute("noOfLinks",""+links);
//                request.setAttribute("fullUrl", url);
//                request.setAttribute("url", url);
//                request.setAttribute("taskName", taskName);
//                request.setAttribute("formName", formName);
//
//                request.setAttribute("numRows", temRows);
//
//                request.setAttribute("data", subTasks);
//                request.setAttribute("page", servedPage);
//
//                this.forward(servedPage, request, response);
                break;

            case 32:

//                userObj=(WebBusinessObject)session.getAttribute("loggedUser");
//                String searchType=request.getParameter("searchType");
//                formName = (String)request.getParameter("formName");
//
//                String toolName="";
//                if(searchType.equalsIgnoreCase("name")){
//                    toolName = (String)request.getParameter("toolName");
//                }else{
//                    toolName = (String)request.getParameter("toolCode");
//                }
//                if(toolName != null && !toolName.equals("")){
//                    String[] toolValue = toolName.split(",");
//                    toolName = "";
//                    for (int i=0;i<toolValue.length;i++){
//                        char c = (char) new Integer(toolValue[i]).intValue();
//                        toolName +=c;
//                    }
//                }
//                Vector categoryTemp = new Vector();
//                count=0;
//                url="TaskServlet?op=listTools";
//                maintainableMgr = MaintainableMgr.getInstance();
//                try {
//                    if(toolName != null && !toolName.equals("")){
//                        String projectID="'"+userObj.getAttribute("projectID").toString()+"'";
//                        categoryTemp = maintainableMgr.getEquipBySubNameOrCode(toolName,projectID,searchType);
//                    }else {
//                        String keyIndex[]={"key3","key5","key11"};
//                        String keyValue[]={"1","0",userObj.getAttribute("projectID").toString()};
//                        categoryTemp = maintainableMgr.getOnArbitraryNumberKey(3,keyValue,keyIndex);
//
//                    }
//                } catch (SQLException ex) {
//                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
//                } catch (Exception ex) {
//                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
//                }
//                tempcount=(String)request.getParameter("count");
//                if(tempcount!=null)
//                    count=Integer.parseInt(tempcount);
//
//                Vector category = new Vector();
//
//                index=(count+1)*10;
//                id="";
//                Vector checkattched=new Vector();
//                SupplementMgr supplementMgr=SupplementMgr.getInstance();
//                if(categoryTemp.size()<index)
//                    index=categoryTemp.size();
//                for (int i = count*10; i <index ; i++) {
//                    wbo = (WebBusinessObject) categoryTemp.get(i);
//
//                    category.add(wbo);
//
//                }
//
//                noOfLinks=categoryTemp.size()/10f;
//                temp=""+noOfLinks;
//                intNo=Integer.parseInt(temp.substring(temp.indexOf(".")+1,temp.length()));
//                links=(int)noOfLinks;
//                if(intNo>0)
//                    links++;
//                if(links==1)
//                    links=0;
//
//                session.removeAttribute("CategoryID");
//                servedPage = "/docs/Adminstration/tools_list.jsp";
//                request.setAttribute("count",""+count);
//                request.setAttribute("noOfLinks",""+links);
//                request.setAttribute("fullUrl", url);
//                request.setAttribute("url", url);
//                request.setAttribute("toolName", toolName);
//                request.setAttribute("formName", formName);
//                request.setAttribute("searchType",searchType);
//                request.setAttribute("total",categoryTemp.size());
//                request.setAttribute("data", category);
//                request.setAttribute("numRows", request.getParameter("numRows"));
//                request.setAttribute("page", servedPage);
//
//                this.forward(servedPage, request, response);
//                break;

//            case 33:
//
//                taskMgr=TaskMgr.getInstance();
//                taskWbo=new WebBusinessObject();
//                taskToolsMgr=TaskToolsMgr.getInstance();
//                taskToolsVec=new Vector();
//                maintainableMgr=MaintainableMgr.getInstance();
//                eqpWbo=new WebBusinessObject();
//                taskToolWbo=new WebBusinessObject();
//                toolId="";
//
//                String toolType=request.getParameter("toolType");
//
//                taskId=request.getParameter("taskId");
//
//                /********* First Delete Old Tools for this Task *********/
//                try {
//                    if(toolType.equalsIgnoreCase("heavy")){
//                        taskToolsMgr.deleteOnArbitraryDoubleKey(taskId,"key1","1","key3");
//                    }else{
//                        taskToolsMgr.deleteOnArbitraryDoubleKey(taskId,"key1","2","key3");
//                    }
//
//                } catch (SQLException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//                /**************End Of Deleet******************/
//
//                /******** Read New Tools To Save ************/
//
//                String notes[]=request.getParameterValues("notes");
//                String toolsIds[]=request.getParameterValues("id");
//
//                taskToolWbo=new WebBusinessObject();
//                if(toolsIds != null && toolsIds.length >0){
//                for(int n=0;n<toolsIds.length;n++){
//                    taskToolWbo=new WebBusinessObject();
//
//                    taskToolWbo.setAttribute("taskId",taskId);
//                    taskToolWbo.setAttribute("toolId",toolsIds[n]);
//                    taskToolWbo.setAttribute("notes",notes[n]);
//                    // 1 mean Heavy tool and 2 mean light tool
//                    if(toolType.equalsIgnoreCase("heavy")){
//                        taskToolWbo.setAttribute("toolType","1");
//                    }else{
//                        taskToolWbo.setAttribute("toolType","2");
//                    }
//                    if(taskToolsMgr.saveObject(taskToolWbo,session)){
//                        request.setAttribute("status","ok");
//                    }else
//                        request.setAttribute("status","fail");
//                }
//                }
//
//                try {
//                    if(toolType.equalsIgnoreCase("heavy")){
//                        taskToolsVec=taskToolsMgr.getOnArbitraryDoubleKey(taskId,"key1","1","key3");
//
//                        servedPage = "/docs/Adminstration/add_task_tools.jsp";
//
//                        for(int i=0;i<taskToolsVec.size();i++){
//                            taskToolWbo=new WebBusinessObject();
//                            eqpWbo=new WebBusinessObject();
//                            toolId="";
//
//                            taskToolWbo=(WebBusinessObject)taskToolsVec.get(i);
//                            toolId=taskToolWbo.getAttribute("toolId").toString();
//                            eqpWbo=maintainableMgr.getOnSingleKey(toolId);
//                            taskToolWbo.setAttribute("toolName",eqpWbo.getAttribute("unitName").toString());
//                            taskToolWbo.setAttribute("toolCode",eqpWbo.getAttribute("unitNo").toString());
//
//                        }
//
//                    }else{
//                        taskToolsVec=taskToolsMgr.getOnArbitraryDoubleKey(taskId,"key1","2","key3");
//
//                        servedPage = "/docs/Adminstration/add_task_light_tools.jsp";
//
//                        toolsMgr=ToolsMgr.getInstance();
//                        toolWbo=new WebBusinessObject();
//
//                        for(int i=0;i<taskToolsVec.size();i++){
//                            taskToolWbo=new WebBusinessObject();
//                            toolWbo=new WebBusinessObject();
//
//                            toolId="";
//
//                            taskToolWbo=(WebBusinessObject)taskToolsVec.get(i);
//                            toolId=taskToolWbo.getAttribute("toolId").toString();
//                            toolWbo=toolsMgr.getOnSingleKey(toolId);
//                            taskToolWbo.setAttribute("toolName",toolWbo.getAttribute("toolName").toString());
//                            taskToolWbo.setAttribute("toolCode",toolWbo.getAttribute("toolCode").toString());
//
//                        }
//
//                    }
//                } catch (SQLException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//
//                taskWbo=taskMgr.getOnSingleKey(taskId);
//
//
//                request.setAttribute("taskId",taskId);
//                request.setAttribute("taskWbo",taskWbo);
//                request.setAttribute("tools",taskToolsVec);
//
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//
//            case 34:
//
//                tradeMgr = TradeMgr.getInstance();
//                taskTypeMgr = TaskTypeMgr.getInstance();
//                employeeTitleMgr = EmployeeTitleMgr.getInstance();
//
//                tradeList = tradeMgr.getCashedTableAsBusObjects();
//                mainTypesList = mainCategoryTypeMgr.getCashedTableAsBusObjects();
//                tasktypeList = taskTypeMgr.getCashedTableAsBusObjects();
//                empTitleList = employeeTitleMgr.getCashedTableAsBusObjects();
//
//                servedPage = "/docs/Adminstration/new_task_main.jsp";
//
//                request.setAttribute("mainTypes", mainTypesList);
//                request.setAttribute("tradeList", tradeList);
//                request.setAttribute("tasktypeList", tasktypeList);
//                request.setAttribute("empTitleList", empTitleList);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//
//            case 35:
//                dateAndTime = new DateAndTimeControl();
//                minutes=0;
//                servedPage = "/docs/Adminstration/new_task_main.jsp";
//
//                tasktitle = null;
//                TaskTypeName = new WebBusinessObject();
//                TaskTypeName = taskTypeMgr.getOnSingleKey(request.getParameter("taskType").toString());
//                tasktitle = TaskTypeName.getAttribute("name").toString()+ " - " +request.getParameter("description").toString();
//                Ntask = new WebBusinessObject();
//
//                day = (String)request.getParameter("day");
//                hour = (String)request.getParameter("hour");
//                minute = (String)request.getParameter("minute");
//
//                if(day != null && !day.equals("")){
//                    minutes = minutes + dateAndTime.getMinuteOfDay(day);
//                }
//                if(hour != null && !hour.equals("")) {
//                    minutes = minutes + dateAndTime.getMinuteOfHour(hour);
//                }
//                if(minute != null && !minute.equals("")) {
//                     minutes = minutes + new Integer(minute).intValue();
//                }
//
//                configTasksPartsMgr=ConfigTasksPartsMgr.getInstance();
//
//                TaskCode=request.getParameter("title").toString();
//                Ntask .setAttribute("title",request.getParameter("title").toString());
//                Ntask .setAttribute("name",request.getParameter("description").toString());
//                Ntask .setAttribute("tradeName",request.getParameter("tradeName").toString());
//                Ntask .setAttribute("taskType",request.getParameter("taskType").toString());
//                Ntask .setAttribute("empTitle",request.getParameter("empTitle").toString());
//                Ntask .setAttribute("taskTitle",tasktitle);
//                Ntask .setAttribute("categoryName","");
//                Ntask .setAttribute("mainTypeId",request.getParameter("mainTypeId").toString());
//                Ntask .setAttribute("isMain","yes");
//                Ntask .setAttribute("executionHrs",Integer.toString(minutes));
//                Ntask .setAttribute("jobzise",request.getParameter("jobzise").toString());
//                Ntask .setAttribute("engDesc",request.getParameter("engDesc").toString());
//                Ntask .setAttribute("costHour",request.getParameter("costHour").toString());
//
//                taskId="";
//                taskWbo = new WebBusinessObject();
//                try {
//                    if(!taskMgr.getDoubleName(request.getParameter("title"))) {
//                        taskId=taskMgr.saveTask(Ntask, session);
//                        if(taskId!=null){
//                            request.setAttribute("Status" , "Ok");
//
//                            // create side menu
//                            Tools.createTaskSideMenu(request, taskId);
//                            taskWbo = taskMgr.getOnSingleKey(taskId);
//                        }
//
//                        else
//                            request.setAttribute("Status", "No");
//
//                    }else {
//                        request.setAttribute("Status", "No");
//                        request.setAttribute("name", "Duplicate Name");
//                    }
//                } catch (NoUserInSessionException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//
//                mainCategoryTypeMgr=MainCategoryTypeMgr.getInstance();
//                tradeMgr = TradeMgr.getInstance();
//                taskTypeMgr = TaskTypeMgr.getInstance();
//                employeeTitleMgr = EmployeeTitleMgr.getInstance();
//
//                tradeList = tradeMgr.getCashedTableAsBusObjects();
//                mainTypesList = mainCategoryTypeMgr.getCashedTableAsBusObjects();
//                tasktypeList = taskTypeMgr.getCashedTableAsBusObjects();
//                empTitleList = employeeTitleMgr.getCashedTableAsBusObjects();
//
//                request.setAttribute("mainTypes", mainTypesList);
//                request.setAttribute("tradeList", tradeList);
//                request.setAttribute("tasktypeList", tasktypeList);
//                request.setAttribute("empTitleList", empTitleList);
//                request.setAttribute("taskWbo",taskWbo);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//
//            case 36:
//                taskId=null;
//                servedPage = "/docs/Adminstration/view_Tasks_main.jsp";
//                taskId = request.getParameter("taskId");
//                Ntask = taskMgr.getOnSingleKey(taskId);
//
//                    // create side menu
//                    Tools.createTaskSideMenu(request, taskId);
//
//                request.setAttribute("Vtask",Ntask);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//
//
//            case 37:
//                dateAndTime = new DateAndTimeControl();
//                minutes=0;
//                taskId = request.getParameter("taskId");
//                servedPage="/docs/Adminstration/update_Tasks_main.jsp";
//
//                day = (String)request.getParameter("day");
//                hour = (String)request.getParameter("hour");
//                minute = (String)request.getParameter("minute");
//
//                if(day != null && !day.equals("")){
//                    minutes = minutes + dateAndTime.getMinuteOfDay(day);
//                }
//                if(hour != null && !hour.equals("")) {
//                    minutes = minutes + dateAndTime.getMinuteOfHour(hour);
//                }
//                if(minute != null && !minute.equals("")) {
//                     minutes = minutes + new Integer(minute).intValue();
//                }
//
//                TaskTypeName = new WebBusinessObject();
//                TaskTypeName = taskTypeMgr.getOnSingleKey(request.getParameter("taskType").toString());
//                tasktitle = TaskTypeName.getAttribute("name").toString()+ " - " +request.getParameter("name").toString();
//                Ntask= new WebBusinessObject();
//                Ntask.setAttribute("title",request.getParameter("title").toString());
//                Ntask.setAttribute("name",request.getParameter("name").toString());
//
//                Ntask.setAttribute("taskId",request.getParameter("taskId").toString());
//                Ntask .setAttribute("tradeName",request.getParameter("tradeName").toString());
//                Ntask .setAttribute("taskType",request.getParameter("taskType").toString());
//                Ntask .setAttribute("empTitle",request.getParameter("empTitle").toString());
//                Ntask .setAttribute("taskTitle",tasktitle);
//                Ntask .setAttribute("categoryName","");
//                Ntask .setAttribute("mainTypeId",request.getParameter("mainTypeId").toString());
//                Ntask .setAttribute("isMain","yes");
//                Ntask .setAttribute("executionHrs",Integer.toString(minutes));
//                Ntask .setAttribute("engDesc",request.getParameter("engDesc").toString());
//                Ntask .setAttribute("costHour",request.getParameter("costHour").toString());
//
//                try {
//                    if(!taskMgr.getDoubleNameforUpdate(taskId,request.getParameter("title"))) {
//                        if(taskMgr. updatetaskCode( Ntask, session)){
//                            request.setAttribute("Status" , "Ok");
//
//                            // create side menu
//                            Tools.createTaskSideMenu(request, taskId);
//
//                        }else{
//                            request.setAttribute("Status", "No");
//                        }
//
//                    }else {
//                        request.setAttribute("Status", "No");
//                        request.setAttribute("name", "Duplicate Name");
//                    }
//                } catch (NoUserInSessionException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//
//                mainCategoryTypeMgr=MainCategoryTypeMgr.getInstance();
//                tradeMgr = TradeMgr.getInstance();
//                taskTypeMgr = TaskTypeMgr.getInstance();
//                employeeTitleMgr = EmployeeTitleMgr.getInstance();
//
//                tradeList = tradeMgr.getCashedTableAsBusObjects();
//                mainTypesList = mainCategoryTypeMgr.getCashedTableAsBusObjects();
//                tasktypeList = taskTypeMgr.getCashedTableAsBusObjects();
//                empTitleList = employeeTitleMgr.getCashedTableAsBusObjects();
//
//                request.setAttribute("mainTypes", mainTypesList);
//                request.setAttribute("tradeList", tradeList);
//                request.setAttribute("tasktypeList", tasktypeList);
//                request.setAttribute("empTitleList", empTitleList);
//
//
//                Ntask= taskMgr.getOnSingleKey(request.getParameter("taskId"));
//                request.setAttribute("Utask", Ntask);
//                request.setAttribute("taskId", request.getParameter("taskId").toString());
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//
//            case 38:
//
//                taskId = request.getParameter("taskId");
//                Ntask = taskMgr.getOnSingleKey(taskId );
//                servedPage = "/docs/Adminstration/update_Tasks_main.jsp";
//                request.setAttribute("Utask",Ntask);
//                request.setAttribute("taskId",taskId);
//
//                mainCategoryTypeMgr=MainCategoryTypeMgr.getInstance();
//                tradeMgr = TradeMgr.getInstance();
//                taskTypeMgr = TaskTypeMgr.getInstance();
//                employeeTitleMgr = EmployeeTitleMgr.getInstance();
//
//                tradeList = tradeMgr.getCashedTableAsBusObjects();
//                mainTypesList = mainCategoryTypeMgr.getCashedTableAsBusObjects();
//                tasktypeList = taskTypeMgr.getCashedTableAsBusObjects();
//                empTitleList = employeeTitleMgr.getCashedTableAsBusObjects();
//
//                request.setAttribute("mainTypes", mainTypesList);
//                request.setAttribute("tradeList", tradeList);
//                request.setAttribute("tasktypeList", tasktypeList);
//                request.setAttribute("empTitleList", empTitleList);
//
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//
//            case 39:
//                servedPage = "/docs/Adminstration/search_task.jsp";
//                request.setAttribute("listType","popup");
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//
//            case 40:

//                count=0;
//                url="TaskServlet?op=searchTaskResult";
//                taskName="";
//                tasks=new Vector();
//                employeeTitleMgr = EmployeeTitleMgr.getInstance();
//                totalTasks = new Vector();
//                userObj=(WebBusinessObject)session.getAttribute("loggedUser");
//                searchType=request.getParameter("searchType");
//                formName = (String)request.getParameter("formName");
//
//                String taskName1 = (String)request.getParameter("taskName");
//                String taskCode = (String)request.getParameter("taskCode");
//
//                if(searchType.equalsIgnoreCase("name")){
//                    taskName = (String)request.getParameter("taskName");
//                }else{
//                    taskName = (String)request.getParameter("taskCode");
//                }
//
//                if(taskName != null && !taskName.equals("")){
//                    String[] taskValue = taskName.split(",");
//                    taskName = "";
//                    for (int i=0;i<taskValue.length;i++){
//                        char c = (char) new Integer(taskValue[i]).intValue();
//                        taskName +=c;
//                    }
//                }
//
//                try {
//                    if(taskName != null && !taskName.equals("")){
//                        if(searchType.equalsIgnoreCase("name"))
//                            tasks=taskMgr.getTasksBySubName(taskName);
//                        else
//                            tasks=taskMgr.getTasksBySubCode(taskName);
//                    }else {
//                        taskMgr.cashData();
//                        tasks=taskMgr.getCashedTable();
//                    }
//                } catch (Exception ex) {
//                    Logger.getLogger(TaskServlet.class.getName()).log(Level.SEVERE, null, ex);
//                }
//                for(int i=0;i<tasks.size();i++){
//                    taskWbo=new WebBusinessObject();
//                    isMain="";
//                    taskWbo=(WebBusinessObject)tasks.get(i);
//                if (employeeTitleMgr.getOnSingleKey(taskWbo.getAttribute("empTitle").toString()) != null && !employeeTitleMgr.getOnSingleKey(taskWbo.getAttribute("empTitle").toString()).equals("")) {
//                    totalTasks.add(taskWbo);
//                    }
//                    }
//                tempcount=(String)request.getParameter("count");
//                if(tempcount!=null)
//                    count=Integer.parseInt(tempcount);
//
//                tradeMgr=TradeMgr.getInstance();
//
//                subTasks = new Vector();
//                wbo=new WebBusinessObject();
//                wboTrade=new WebBusinessObject();
//                maintainableMgr=MaintainableMgr.getInstance();
//
//                job="";
//
//                index=(count+1)*10;
//                id="";
//                if(totalTasks.size()<index)
//                    index=totalTasks.size();
//                for (int i = count*10; i <index ; i++) {
//                    wbo = (WebBusinessObject) totalTasks.get(i);
//                    wboTrade = tradeMgr.getOnSingleKey(wbo.getAttribute("trade").toString());
//                    if(wboTrade!=null){
//                        job=wboTrade.getAttribute("tradeName").toString();
//                        wbo.setAttribute("trade",job);
//                        subTasks.add(wbo);
//                    }else{
//                        totalTasks.remove(i);
//                        i--;
//                    }
//                }
//
//                noOfLinks=totalTasks.size()/10f;
//                temp=""+noOfLinks;
//                intNo=Integer.parseInt(temp.substring(temp.indexOf(".")+1,temp.length()));
//                links=(int)noOfLinks;
//                if(intNo>0)
//                    links++;
//                if(links==1)
//                    links=0;
//
//                servedPage = "/docs/Adminstration/search_task_result.jsp";
//
//                request.setAttribute("count",""+count);
//                request.setAttribute("noOfLinks",""+links);
//                request.setAttribute("fullUrl", url);
//                request.setAttribute("url", url);
//                request.setAttribute("taskName", taskName);
//                 request.setAttribute("taskName1", taskName1);
//                  request.setAttribute("taskCode", taskCode);
//                request.setAttribute("formName", formName);
//                request.setAttribute("searchType", searchType);
//
//                request.setAttribute("data", subTasks);
//                request.setAttribute("page", servedPage);
//
//                this.forward(servedPage,request, response);
//                break;

            case 41:

//                taskId="";
//                taskWbo=new WebBusinessObject();
//                taskMgr=TaskMgr.getInstance();
//                taskId=request.getParameter("taskId");
//                mainCategoryTypeMgr=MainCategoryTypeMgr.getInstance();
//                TaskTypeMgr taskTypeMgr = TaskTypeMgr.getInstance();
//                maintainableMgr = MaintainableMgr.getInstance();
//                tradeMgr = TradeMgr.getInstance();
//                employeeTitleMgr = EmployeeTitleMgr.getInstance();
//
//                searchType=(String)request.getParameter("searchType");
//                taskName = (String)request.getParameter("taskName");
//                taskCode = (String)request.getParameter("taskCode");
//
//                wboTrade = new WebBusinessObject();
//                WebBusinessObject wboTaskType = new WebBusinessObject();
//                WebBusinessObject wboEmpTitle = new WebBusinessObject();
//                WebBusinessObject wboCategoryName = new WebBusinessObject();
//                String catName="";
//
//                taskWbo=taskMgr.getOnSingleKey(taskId);
//
//                if(taskWbo!=null){
//
//
//                    wboTrade = tradeMgr.getOnSingleKey(taskWbo.getAttribute("trade").toString());
//                    wboTaskType = taskTypeMgr.getOnSingleKey(taskWbo.getAttribute("taskType").toString());
//                    wboEmpTitle = employeeTitleMgr.getOnSingleKey(taskWbo.getAttribute("empTitle").toString());
//
//                    if(taskWbo.getAttribute("isMain").toString().equalsIgnoreCase("no")){
//                        wboCategoryName = maintainableMgr.getOnSingleKey(taskWbo.getAttribute("parentUnit").toString());
//                        catName=wboCategoryName.getAttribute("unitName").toString();
//                    }else{
//                        wboCategoryName = mainCategoryTypeMgr.getOnSingleKey(taskWbo.getAttribute("mainTypeId").toString());
//                        catName=wboCategoryName.getAttribute("typeName").toString();
//                    }
//
//                    taskWbo.setAttribute("tradeName",wboTrade.getAttribute("tradeName"));
//                    taskWbo.setAttribute("taskTypeName",wboTaskType.getAttribute("name"));
//                    taskWbo.setAttribute("catName",catName);
//                    taskWbo.setAttribute("empName",wboEmpTitle.getAttribute("name"));
//
//                }
//
//                 // create side menu
//                    Tools.createTaskSideMenu(request, taskId);
//
//                servedPage = "/docs/Adminstration/task_Data.jsp";
//
//                request.setAttribute("taskWbo", taskWbo);
//                request.setAttribute("page", servedPage);
//                request.setAttribute("searchType", searchType);
//                request.setAttribute("taskName", taskName);
//                request.setAttribute("taskCode", taskCode);
//
//                this.forward(servedPage,request, response);
//                break;
//
//            case 42:
//
//                taskId=request.getParameter("taskId");
//                taskMgr=TaskMgr.getInstance();
//                taskExecutionNotesMgr=TaskExecutionNotesMgr.getInstance();
//                servedPage = "/docs/Adminstration/add_task_exec_notes.jsp";
//                taskNotesVec=new Vector();
//
//                try {
//
//                    taskExecutionNotesMgr.deleteOnArbitraryKey(taskId,"key1");
//                    if(taskExecutionNotesMgr.saveObject(request,session)){
//                        request.setAttribute("status","ok");
//                    }else{
//                        request.setAttribute("Status", "no");
//                    }
//
//                } catch (NoUserInSessionException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//
//                try {
//
//                    taskNotesVec=taskExecutionNotesMgr.getOnArbitraryKey(taskId,"key1");
//
//                } catch (SQLException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//
//                taskWbo=new WebBusinessObject();
//                taskWbo=taskMgr.getOnSingleKey(taskId);
//
//                request.setAttribute("taskNotes",taskNotesVec);
//                request.setAttribute("taskWbo",taskWbo);
//
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
                break;

            case 43:

//                taskMgr=TaskMgr.getInstance();
//                taskExecutionNotesMgr=TaskExecutionNotesMgr.getInstance();
//                mainCategoryTypeMgr=MainCategoryTypeMgr.getInstance();
//                maintainableMgr=MaintainableMgr.getInstance();
//                configTasksPartsMgr=ConfigTasksPartsMgr.getInstance();
//                itemsMgr=ItemsMgr.getInstance();
//                taskToolsMgr=TaskToolsMgr.getInstance();
//                employeeTitleMgr = EmployeeTitleMgr.getInstance();
//                taskTypeMgr=TaskTypeMgr.getInstance();
//
//                wboEmpTitle=new WebBusinessObject();
//                taskWbo=new WebBusinessObject();
//                WebBusinessObject maincatWbo=new WebBusinessObject();
//                catWbo=new WebBusinessObject();
//                taskToolWbo=new WebBusinessObject();
//                wboTaskType=new WebBusinessObject();
//
//                taskNotesVec=new Vector();
//                taskParts=new Vector();
//                taskToolsVec=new Vector();
//
//                taskId=request.getParameter("taskId");
//                taskWbo=taskMgr.getOnSingleKey(taskId);
//
//                try {
//
//                    taskNotesVec=taskExecutionNotesMgr.getOnArbitraryKey(taskId,"key1");
//
//                } catch (SQLException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//                itemsMgr = ItemsMgr.getInstance();
//
//                try {
//
////                    distItemsMgr=DistributedItemsMgr.getInstance();
//
//
//                    taskParts=configTasksPartsMgr.getOnArbitraryKey(taskId,"key1");
//                    items=new Vector();
//                    if(taskParts.size()>0){
//                        for(int i=0;i<taskParts.size();i++){
//                            taskPartWbo=new WebBusinessObject();
//                            itemWbo=new WebBusinessObject();
//                            items=new Vector();
//
//                            taskPartWbo=(WebBusinessObject)taskParts.get(i);
//                            itemCode = taskPartWbo.getAttribute("itemId").toString().split("-");
//                            if(itemCode.length > 1){
//                                itemWbo=itemsMgr.getOnSingleKey(taskPartWbo.getAttribute("itemId").toString());
//                            } else {
//                                itemWbo=itemsMgr.getOnObjectByKey(taskPartWbo.getAttribute("itemId").toString());
//                            }
//
//                            if(itemWbo!=null) {
//                                taskPartWbo.setAttribute("itemName",itemWbo.getAttribute("itemDscrptn").toString());
//                            }else{
//                                taskParts.remove(i);
//                                i--;
//                            }
//                        }
//                    }
//
//                } catch (SQLException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//
//                /*********** Get Heavy Tools **************/
//                try {
//                    taskToolsVec=taskToolsMgr.getOnArbitraryDoubleKey(taskId,"key1","1","key3");
//                } catch (SQLException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//
//
//                for(int i=0;i<taskToolsVec.size();i++){
//                    taskToolWbo=new WebBusinessObject();
//                    eqpWbo=new WebBusinessObject();
//                    toolId="";
//
//                    taskToolWbo=(WebBusinessObject)taskToolsVec.get(i);
//                    toolId=taskToolWbo.getAttribute("toolId").toString();
//                    eqpWbo=maintainableMgr.getOnSingleKey(toolId);
//                    taskToolWbo.setAttribute("toolName",eqpWbo.getAttribute("unitName").toString());
//                    taskToolWbo.setAttribute("toolCode",eqpWbo.getAttribute("unitNo").toString());
//                }
//                /************ End Of Heavy Tools ****************/
//
//                /************ Get Light Tools ******************/
//                Vector taskLightToolsVec=new Vector();
//                try {
//
//                    taskLightToolsVec=taskToolsMgr.getOnArbitraryDoubleKey(taskId,"key1","2","key3");
//
//                } catch (SQLException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//
//                toolsMgr=ToolsMgr.getInstance();
//                toolWbo=new WebBusinessObject();
//
//                for(int i=0;i<taskLightToolsVec.size();i++){
//                    taskToolWbo=new WebBusinessObject();
//                    toolWbo=new WebBusinessObject();
//
//                    toolId="";
//
//                    taskToolWbo=(WebBusinessObject)taskLightToolsVec.get(i);
//                    toolId=taskToolWbo.getAttribute("toolId").toString();
//                    toolWbo=toolsMgr.getOnSingleKey(toolId);
//                    taskToolWbo.setAttribute("toolName",toolWbo.getAttribute("toolName").toString());
//                    taskToolWbo.setAttribute("toolCode",toolWbo.getAttribute("toolCode").toString());
//
//                }
//                /************ End Of Light Tools ***************/
//
//
//                wboTrade=new WebBusinessObject();
//                tradeMgr=TradeMgr.getInstance();
//
//                wboTrade = tradeMgr.getOnSingleKey(taskWbo.getAttribute("trade").toString());
//
//                if(wboTrade!=null){
//                    job=wboTrade.getAttribute("tradeName").toString();
//                    taskWbo.setAttribute("trade",job);
//                }else{
//                    taskWbo.setAttribute("trade","No Data");
//                }
//
//                if(taskWbo.getAttribute("isMain").toString().equalsIgnoreCase("no")){
//
//                    String parentID=taskWbo.getAttribute("parentUnit").toString();
//                    WebBusinessObject wboEquipType =  maintainableMgr.getOnSingleKey(parentID);
//                    equipType = wboEquipType.getAttribute("unitName").toString();
//
//                }else{
//
//                    mainTypeId=taskWbo.getAttribute("mainTypeId").toString();
//                    WebBusinessObject wboEquipType =  mainCategoryTypeMgr.getOnSingleKey(mainTypeId);
//                    equipType = wboEquipType.getAttribute("typeName").toString();
//
//                }
//                taskWbo.setAttribute("eqpName",equipType);
//
//                wboEmpTitle = employeeTitleMgr.getOnSingleKey(taskWbo.getAttribute("empTitle").toString());
//                wboTaskType = taskTypeMgr.getOnSingleKey(taskWbo.getAttribute("taskType").toString());
//
//                taskWbo.setAttribute("empName",wboEmpTitle.getAttribute("name"));
//                taskWbo.setAttribute("taskType",wboTaskType.getAttribute("name"));
//
//                request.setAttribute("taskWbo",taskWbo);
//                request.setAttribute("taskNotes",taskNotesVec);
//                request.setAttribute("taskParts",taskParts);
//                request.setAttribute("taskTools",taskToolsVec);
//                request.setAttribute("taskLightToolsVec",taskLightToolsVec);
//
//                if(request.getParameter("single")!=null)
//                servedPage = "/docs/Adminstration/print_Task_dialog.jsp";
//                else
//                servedPage = "/docs/Adminstration/print_Task.jsp";
//                this.forward(servedPage, request, response);

                break;

            case 44:

//                userObj=(WebBusinessObject)session.getAttribute("loggedUser");
//                searchType=request.getParameter("searchType");
//                formName = (String)request.getParameter("formName");
//
//                toolName="";
//                if(searchType.equalsIgnoreCase("name")){
//                    toolName = (String)request.getParameter("toolName");
//                }else{
//                    toolName = (String)request.getParameter("toolCode");
//                }
//                if(toolName != null && !toolName.equals("")){
//                    String[] toolValue = toolName.split(",");
//                    toolName = "";
//                    for (int i=0;i<toolValue.length;i++){
//                        char c = (char) new Integer(toolValue[i]).intValue();
//                        toolName +=c;
//                    }
//                }
//                Vector toolsTempVec = new Vector();
//                toolsMgr=ToolsMgr.getInstance();
//
//                count=0;
//                url="TaskServlet?op=listLightTools";
//
//                try {
//
//                    if(toolName != null && !toolName.equals("")){
//
//                        toolsTempVec = toolsMgr.getToolsBySubNameOrCode(toolName,searchType);
//
//                    }else {
//
//                        toolsMgr.cashData();
//                        toolsTempVec = toolsMgr.getCashedTable();
//
//                    }
//
//                } catch (Exception ex) {
//                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
//                }
//
//                tempcount=(String)request.getParameter("count");
//                if(tempcount!=null)
//                    count=Integer.parseInt(tempcount);
//
//                Vector toolsVec = new Vector();
//
//                index=(count+1)*10;
//                id="";
//
//                if(toolsTempVec.size()<index)
//                    index=toolsTempVec.size();
//
//                for (int i = count*10; i <index ; i++) {
//                    wbo = (WebBusinessObject) toolsTempVec.get(i);
//                    toolsVec.add(wbo);
//                }
//
//                noOfLinks=toolsTempVec.size()/10f;
//                temp=""+noOfLinks;
//                intNo=Integer.parseInt(temp.substring(temp.indexOf(".")+1,temp.length()));
//                links=(int)noOfLinks;
//                if(intNo>0)
//                    links++;
//                if(links==1)
//                    links=0;
//
//                servedPage = "/docs/Adminstration/light_tools_list.jsp";
//                request.setAttribute("count",""+count);
//                request.setAttribute("noOfLinks",""+links);
//                request.setAttribute("fullUrl", url);
//                request.setAttribute("url", url);
//                request.setAttribute("toolName", toolName);
//                request.setAttribute("formName", formName);
//                request.setAttribute("searchType",searchType);
//                request.setAttribute("total",toolsTempVec.size());
//                request.setAttribute("data", toolsVec);
//                request.setAttribute("numRows", request.getParameter("numRows"));
//                request.setAttribute("page", servedPage);
//
//                this.forward(servedPage, request, response);
//                break;

            case 45:
                servedPage = "/docs/Adminstration/search_task.jsp";
                request.setAttribute("listType","details");
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 46:

//                count=0;
//                url="TaskServlet?op=searchTaskBySub";
//                String servletName="TaskServlet";
//                String op="searchTaskBySub";
//
//                taskName="";
//                tasks=new Vector();
//                Vector tasksByParentUnit=new Vector();
//                totalTasks = new Vector();
//                employeeTitleMgr = EmployeeTitleMgr.getInstance();
//
//                userObj=(WebBusinessObject)session.getAttribute("loggedUser");
//                searchType=request.getParameter("searchType");
//                formName = (String)request.getParameter("formName");
//                String beginDate = (String)request.getParameter("beginDate");
//                String endDate = (String)request.getParameter("endDate");
//                if(beginDate!= null && !beginDate.equals("")){
//                session.setAttribute("beginDatesql", beginDate);
//                session.setAttribute("endDatesql", endDate);               
//                }
//                else{
//                
//                beginDate=(String)session.getAttribute("beginDatesql");
//                endDate=(String)session.getAttribute("endDatesql");
//                
//                
//                }
//
//                if(searchType.equalsIgnoreCase("name")){
//                    taskName = (String)request.getParameter("taskName");
//                }else{
//                    taskName = (String)request.getParameter("taskCode");
//                }
//
//                if(taskName != null && !taskName.equals("")){
//                    String[] taskValue = taskName.split(",");
//                    taskName = "";
//                    for (int i=0;i<taskValue.length;i++){
//                        char c = (char) new Integer(taskValue[i]).intValue();
//                        taskName +=c;
//                    }
//                }
//                //////////////////// To Search By Date /////////////////////////////////////////////
//                try {
//                    if(taskName != null && !taskName.equals("")){
//                        if(searchType.equalsIgnoreCase("name"))
//                            tasks=taskMgr.getAllItemsByDate(beginDate,endDate);
//                        else
//                            tasks=taskMgr.getAllItemsByDate(beginDate,endDate);
//                    }else {
//                        taskMgr.cashData();
//                        tasks=taskMgr.getAllItemsByDate(beginDate,endDate);
//                    }
//                } catch (Exception ex) {
//                    Logger.getLogger(TaskServlet.class.getName()).log(Level.SEVERE, null, ex);
//                }
//
//                for(int i=0;i<tasks.size();i++){
//                    taskWbo=new WebBusinessObject();
//                    isMain="";
//                    taskWbo=(WebBusinessObject)tasks.get(i);
//                    if(taskWbo.getAttribute("isMain").toString().equalsIgnoreCase("yes"))
//                        taskWbo.setAttribute("parentUnit","no");
//                }
//
//                  for(int i=0;i<tasks.size();i++){
//                    taskWbo=new WebBusinessObject();
//                    isMain="";
//                    taskWbo=(WebBusinessObject)tasks.get(i);
//                if (employeeTitleMgr.getOnSingleKey(taskWbo.getAttribute("empTitle").toString()) != null && !employeeTitleMgr.getOnSingleKey(taskWbo.getAttribute("empTitle").toString()).equals("")) {
//                    totalTasks.add(taskWbo);
//                    }
//                    }
//
//                tempcount=(String)request.getParameter("count");
//                if(tempcount!=null)
//                    count=Integer.parseInt(tempcount);
//
//                tradeMgr=TradeMgr.getInstance();
//
//                subTasks = new Vector();
//                wbo=new WebBusinessObject();
//                wboTrade=new WebBusinessObject();
//                maintainableMgr=MaintainableMgr.getInstance();
//
//                job="";
//
//                index=(count+1)*10;
//                id="";
//                if(totalTasks.size()<index)
//                    index=totalTasks.size();
//                for (int i = count*10; i <index ; i++) {
//                    wbo = (WebBusinessObject) totalTasks.get(i);
//                    wboTrade = tradeMgr.getOnSingleKey(wbo.getAttribute("trade").toString());
//                    if(wboTrade!=null){
//                        job=wboTrade.getAttribute("tradeName").toString();
//                        wbo.setAttribute("trade",job);
//                        subTasks.add(wbo);
//                    }else{
//                        totalTasks.remove(i);
//                        i--;
//                    }
//                }
//
//                noOfLinks=totalTasks.size()/10f;
//                temp=""+noOfLinks;
//                intNo=Integer.parseInt(temp.substring(temp.indexOf(".")+1,temp.length()));
//                links=(int)noOfLinks;
//                if(intNo>0)
//                    links++;
//                if(links==1)
//                    links=0;
//
//                if(request.getParameter("Tasks")==null)
//                servedPage = "/docs/Adminstration/view_Tasks_BySubNameCode.jsp";
//                else
//                servedPage = "/docs/Adminstration/view_Tasks_ByDate.jsp";
//
//                int total=totalTasks.size();
//
//                request.setAttribute("total",""+total);
//                request.setAttribute("count",""+count);
//                request.setAttribute("noOfLinks",""+links);
//                request.setAttribute("fullUrl", url);
//                request.setAttribute("url", url);
//                request.setAttribute("taskName", taskName);
//                request.setAttribute("searchType", searchType);
//                request.setAttribute("formName", formName);
//                request.setAttribute("data", subTasks);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);

                break;

            case 47:

                servedPage = "/docs/Adminstration/new_tool.jsp";
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 48:

//                servedPage = "/docs/Adminstration/new_tool.jsp";
//                status="";
//                toolsMgr=ToolsMgr.getInstance();
//
//                toolWbo=new WebBusinessObject();
//
//                toolName=request.getParameter("toolName");
//                String toolCode=request.getParameter("toolCode");
//                String toolNotes=request.getParameter("toolNotes");
//
//                toolWbo.setAttribute("toolName",toolName);
//                toolWbo.setAttribute("toolCode",toolCode);
//                toolWbo.setAttribute("toolNotes",toolNotes);
//
//
//                try {
//                    if(!toolsMgr.getDoubleName(toolCode)) {
//                        if(toolsMgr.saveObject(toolWbo, session))
//                            request.setAttribute("status","ok");
//                        else
//                            request.setAttribute("status","fail");
//                    }
//                } catch (SQLException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//
//                request.setAttribute("status",status);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
                break;

//            case 49:
//
//                unitScheduleMgr = UnitScheduleMgr.getInstance();
//                issueTasksMgr = IssueTasksMgr.getInstance();
//                issueMgr = IssueMgr.getInstance();
//                delRows = 0;
//                tasks = taskMgr.getCashedTable();
//                taskId = request.getParameter("taskId");
//                wboTask = taskMgr.getOnSingleKey(taskId);
//                issueTaskVec = new Vector();
//                issueTaskWbo = new WebBusinessObject();
//                issueWbo = new WebBusinessObject();
//                unitScheduleWbo = new WebBusinessObject();
//                try {
//                    if(taskMgr.getActiveTask(wboTask.getAttribute("id").toString())) {
//                        issueTaskVec = issueTasksMgr.getOnArbitraryKeyOracle(taskId,"key2");
//                        issueTaskWbo = (WebBusinessObject) issueTaskVec.get(0);
//                        issueWbo = issueMgr.getOnSingleKey(issueTaskWbo.getAttribute("issueID").toString());
//                        unitScheduleWbo = unitScheduleMgr.getOnSingleKey(issueWbo.getAttribute("unitScheduleID").toString());
//                        unitScheduleMgr.deleteOnSingleKey(unitScheduleWbo.getAttribute("id").toString());
//                        if(taskMgr.deleteOnSingleKey(request.getParameter("taskId")))
//                            request.setAttribute("status","ok");
//                        else
//                            request.setAttribute("status","fail");
//
//                    } else {
//                        if(taskMgr.deleteOnSingleKey(request.getParameter("taskId")))
//                            request.setAttribute("status","ok");
//                        else
//                            request.setAttribute("status","fail");
//                    }
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//
//
//                taskMgr.cashData();
//                tasks = taskMgr.getAllItems();
//                System.out.println("sa ----------------- ");
//                taskWbo=new WebBusinessObject();
//                isMain="";
//                for(int i=0;i<tasks.size();i++){
//                    taskWbo=new WebBusinessObject();
//                    isMain="";
//                    taskWbo=(WebBusinessObject)tasks.get(i);
//                    if(taskWbo.getAttribute("isMain").toString().equalsIgnoreCase("yes"))
//                        taskWbo.setAttribute("parentUnit","no");
//                }
//                request.getSession().removeAttribute("topMenu");
//                request.getSession().removeAttribute("sideMenuVec");
//                servedPage = "/docs/Adminstration/Task_List.jsp";
//                request.setAttribute("data", tasks);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//
//            case 50:

//                userObj=(WebBusinessObject)session.getAttribute("loggedUser");
//                taskCode = (String)request.getParameter("taskCode");
//                formName = (String)request.getParameter("formName");
//                url="TaskServlet?op=listTasksByCode&formName="+formName;
//                count=0;
//
//                taskMgr=TaskMgr.getInstance();
//                tasks = new Vector();
//
//                if(taskCode != null && !taskCode.equals("")){
//                    String[] codeName = taskCode.split(",");
//                    taskCode = "";
//                    for (int i=0;i<codeName.length;i++){
//                        char tempCh = (char) new Integer(codeName[i]).intValue();
//                        taskCode +=tempCh;
//                    }
//                }
//
//                try {
//                    if(taskCode != null && !taskCode.equals("")){
//                        tasks=taskMgr.getTasksBySubCode(taskCode);
//                    }else {
//                        taskMgr.cashData();
//                        tasks=taskMgr.getCashedTable();
//                    }
//                } catch (Exception ex) {
//                    Logger.getLogger(TaskServlet.class.getName()).log(Level.SEVERE, null, ex);
//                }
//
//                tempcount=(String)request.getParameter("count");
//                if(tempcount!=null)
//                    count=Integer.parseInt(tempcount);
//
//                tradeMgr=TradeMgr.getInstance();
//
//                subTasks = new Vector();//
//                wbo=new WebBusinessObject();
//                wboTrade=new WebBusinessObject();
//                maintainableMgr=MaintainableMgr.getInstance();
//                mainCategoryTypeMgr=MainCategoryTypeMgr.getInstance();//
//
//                job="";//
//
//                index=(count+1)*10;
//                id="";
//                if(tasks.size()<index)
//                    index=tasks.size();
//                for (int i = count*10; i <index ; i++) {
//                    wbo = (WebBusinessObject) tasks.get(i);
//                    wboTrade = tradeMgr.getOnSingleKey(wbo.getAttribute("trade").toString());
//                    if(wboTrade!=null){
//                        job=wboTrade.getAttribute("tradeName").toString();
//                        wbo.setAttribute("trade",job);
//                        if(wbo.getAttribute("isMain").toString().equalsIgnoreCase("no")){
//                            String parentID=wbo.getAttribute("parentUnit").toString();
//                            WebBusinessObject wboEquipType =  maintainableMgr.getOnSingleKey(parentID);
//                            equipType = wboEquipType.getAttribute("unitName").toString();
//                        }else{
//                            mainTypeId=wbo.getAttribute("mainTypeId").toString();
//                            WebBusinessObject wboEquipType =  mainCategoryTypeMgr.getOnSingleKey(mainTypeId);
//                            equipType = wboEquipType.getAttribute("typeName").toString();
//                        }
//                        wbo.setAttribute("eqpName",equipType);
//                        subTasks.add(wbo);
//                    }else{
//                        tasks.remove(i);
//                        i--;
//                    }
//                }
//
//                noOfLinks=tasks.size()/10f;
//                temp=""+noOfLinks;
//                intNo=Integer.parseInt(temp.substring(temp.indexOf(".")+1,temp.length()));
//                links=(int)noOfLinks;
//                if(intNo>0)
//                    links++;
//                if(links==1)
//                    links=0;
//
//                servedPage = "/docs/Adminstration/tasks_list.jsp";
//
//                temRows=request.getParameter("numRows");
//                if(temRows==null || temRows.equalsIgnoreCase(""))
//                    temRows=""+0;
//
//                request.setAttribute("count",""+count);
//                request.setAttribute("noOfLinks",""+links);
//                request.setAttribute("fullUrl", url);
//                request.setAttribute("url", url);
//                System.out.println(taskCode);
//                request.setAttribute("taskName", taskCode);
//                request.setAttribute("isCode", "true");
//                System.out.println(taskCode);
//                request.setAttribute("formName", formName);
//
//                request.setAttribute("numRows", temRows);
//
//                request.setAttribute("data", subTasks);
//                request.setAttribute("page", servedPage);
//
//                this.forward(servedPage, request, response);
//                break;
//
//            case 51:
//                taskId = request.getParameter("taskId");
//                servedPage = "/docs/Adminstration/confirm_deltool.jsp";
//
//                request.setAttribute("taskId", taskId);
//                request.setAttribute("page", servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//            case 52:
//                servedPage = "/docs/Adminstration/search_task.jsp";
//                request.setAttribute("listType","notPopup");
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//            case 53:
//                count=0;
//                url="TaskServlet?op=getSearchTaskNotPopup";
//                taskName="";
//                tasks=new Vector();
//                employeeTitleMgr = EmployeeTitleMgr.getInstance();
//                totalTasks = new Vector();
//                userObj=(WebBusinessObject)session.getAttribute("loggedUser");
//                searchType=request.getParameter("searchType");
//                formName = (String)request.getParameter("formName");
//
//                taskName1 = (String)request.getParameter("taskName");
//                taskCode = (String)request.getParameter("taskCode");
//
//                if(searchType.equalsIgnoreCase("name")){
//                    taskName = (String)request.getParameter("taskName");
//                }else{
//                    taskName = (String)request.getParameter("taskCode");
//                }
//
//                if(taskName != null && !taskName.equals("")){
//                    String[] taskValue = taskName.split(",");
//                    taskName = "";
//                    for (int i=0;i<taskValue.length;i++){
//                        char c = (char) new Integer(taskValue[i]).intValue();
//                        taskName +=c;
//                    }
//                }
//
//                try {
//                    if(taskName != null && !taskName.equals("")){
//                        if(searchType.equalsIgnoreCase("name"))
//                            tasks=taskMgr.getTasksBySubName(taskName);
//                        else
//                            tasks=taskMgr.getTasksBySubCode(taskName);
//                    }else {
//                        taskMgr.cashData();
//                        tasks=taskMgr.getCashedTable();
//                    }
//                } catch (Exception ex) {
//                    Logger.getLogger(TaskServlet.class.getName()).log(Level.SEVERE, null, ex);
//                }
//                for(int i=0;i<tasks.size();i++){
//                    taskWbo=new WebBusinessObject();
//                    isMain="";
//                    taskWbo=(WebBusinessObject)tasks.get(i);
//                if (employeeTitleMgr.getOnSingleKey(taskWbo.getAttribute("empTitle").toString()) != null && !employeeTitleMgr.getOnSingleKey(taskWbo.getAttribute("empTitle").toString()).equals("")) {
//                    totalTasks.add(taskWbo);
//                    }
//                    }
//                tempcount=(String)request.getParameter("count");
//                if(tempcount!=null)
//                    count=Integer.parseInt(tempcount);
//
//                tradeMgr=TradeMgr.getInstance();
//
//                subTasks = new Vector();
//                wbo=new WebBusinessObject();
//                wboTrade=new WebBusinessObject();
//                maintainableMgr=MaintainableMgr.getInstance();
//
//                job="";
//
//                index=(count+1)*10;
//                id="";
//                if(totalTasks.size()<index)
//                    index=totalTasks.size();
//                for (int i = count*10; i <index ; i++) {
//                    wbo = (WebBusinessObject) totalTasks.get(i);
//                    wboTrade = tradeMgr.getOnSingleKey(wbo.getAttribute("trade").toString());
//                    if(wboTrade!=null){
//                        job=wboTrade.getAttribute("tradeName").toString();
//                        wbo.setAttribute("trade",job);
//                        subTasks.add(wbo);
//                    }else{
//                        totalTasks.remove(i);
//                        i--;
//                    }
//                }
//
//                noOfLinks=totalTasks.size()/10f;
//                temp=""+noOfLinks;
//                intNo=Integer.parseInt(temp.substring(temp.indexOf(".")+1,temp.length()));
//                links=(int)noOfLinks;
//                if(intNo>0)
//                    links++;
//                if(links==1)
//                    links=0;
//
//                servedPage = "/docs/Adminstration/search_task_result.jsp";
//
//                request.setAttribute("count",""+count);
//                request.setAttribute("noOfLinks",""+links);
//                request.setAttribute("fullUrl", url);
//                request.setAttribute("url", url);
//                request.setAttribute("taskName", taskName);
//                request.setAttribute("taskName1", taskName1);
//                request.setAttribute("taskCode", taskCode);
//                request.setAttribute("formName", formName);
//                request.setAttribute("searchType", searchType);
//                request.setAttribute("popup", "no");
//                request.setAttribute("data", subTasks);
//                request.setAttribute("page", servedPage);
//
//                this.forwardToServedPage(request, response);
//                break;

            case 54:
//                taskId="";
//                taskWbo=new WebBusinessObject();
//                taskMgr=TaskMgr.getInstance();
//                taskId=request.getParameter("taskId");
//                mainCategoryTypeMgr=MainCategoryTypeMgr.getInstance();
//                taskTypeMgr = TaskTypeMgr.getInstance();
//                maintainableMgr = MaintainableMgr.getInstance();
//                tradeMgr = TradeMgr.getInstance();
//                employeeTitleMgr = EmployeeTitleMgr.getInstance();
//
//                searchType=(String)request.getParameter("searchType");
//                taskName = (String)request.getParameter("taskName");
//                taskCode = (String)request.getParameter("taskCode");
//
//                wboTrade = new WebBusinessObject();
//                wboTaskType = new WebBusinessObject();
//                wboEmpTitle = new WebBusinessObject();
//                wboCategoryName = new WebBusinessObject();
//                catName="";
//
//                taskWbo=taskMgr.getOnSingleKey(taskId);
//
//                if(taskWbo!=null){
//
//
//                    wboTrade = tradeMgr.getOnSingleKey(taskWbo.getAttribute("trade").toString());
//                    wboTaskType = taskTypeMgr.getOnSingleKey(taskWbo.getAttribute("taskType").toString());
//                    wboEmpTitle = employeeTitleMgr.getOnSingleKey(taskWbo.getAttribute("empTitle").toString());
//
//                    if(taskWbo.getAttribute("isMain").toString().equalsIgnoreCase("no")){
//                        wboCategoryName = maintainableMgr.getOnSingleKey(taskWbo.getAttribute("parentUnit").toString());
//                        catName=wboCategoryName.getAttribute("unitName").toString();
//                    }else{
//                        wboCategoryName = mainCategoryTypeMgr.getOnSingleKey(taskWbo.getAttribute("mainTypeId").toString());
//                        catName=wboCategoryName.getAttribute("typeName").toString();
//                    }
//
//                    taskWbo.setAttribute("tradeName",wboTrade.getAttribute("tradeName"));
//                    taskWbo.setAttribute("taskTypeName",wboTaskType.getAttribute("name"));
//                    taskWbo.setAttribute("catName",catName);
//                    taskWbo.setAttribute("empName",wboEmpTitle.getAttribute("name"));
//
//                }
//
//                 // create side menu
//                    Tools.createTaskSideMenu(request, taskId);
//
//                servedPage = "/docs/Adminstration/task_Data.jsp";
//
//                request.setAttribute("taskWbo", taskWbo);
//                request.setAttribute("page", servedPage);
//                request.setAttribute("searchType", searchType);
//                request.setAttribute("taskName", taskName);
//                request.setAttribute("popup", "no");
//                request.setAttribute("taskCode", taskCode);
//
//                this.forwardToServedPage(request, response);
               break;
             case 55:

//                count=0;
//                url="TaskServlet?op=searchTaskBySub";
//                servletName="TaskServlet";
//                op="searchTaskBySub";
//
//                taskName="";
//                tasks=new Vector();
//                 tasksByParentUnit=new Vector();
//                totalTasks = new Vector();
//                employeeTitleMgr = EmployeeTitleMgr.getInstance();
//
//                userObj=(WebBusinessObject)session.getAttribute("loggedUser");
//                searchType=request.getParameter("searchType");
//                formName = (String)request.getParameter("formName");
//                beginDate = (String)request.getParameter("beginDate");
//                endDate = (String)request.getParameter("endDate");
//                if(beginDate!= null && !beginDate.equals("")){
//                session.setAttribute("beginDatesql", beginDate);
//                session.setAttribute("endDatesql", endDate);               
//                }
//                else{
//                
//                beginDate=(String)session.getAttribute("beginDatesql");
//                endDate=(String)session.getAttribute("endDatesql");
//                
//                
//                }
//
//                if(searchType.equalsIgnoreCase("name")){
//                    taskName = (String)request.getParameter("taskName");
//                }else{
//                    taskName = (String)request.getParameter("taskCode");
//                }
//
//                if(taskName != null && !taskName.equals("")){
//                    String[] taskValue = taskName.split(",");
//                    taskName = "";
//                    for (int i=0;i<taskValue.length;i++){
//                        char c = (char) new Integer(taskValue[i]).intValue();
//                        taskName +=c;
//                    }
//                }
//                //////////////////// To Search By Date /////////////////////////////////////////////
//                try {
//                    if(taskName != null && !taskName.equals("")){
//                        if(searchType.equalsIgnoreCase("name"))
//                            tasks=taskMgr.getAllItemsByDate(beginDate,endDate);
//                        else
//                            tasks=taskMgr.getAllItemsByDate(beginDate,endDate);
//                    }else {
//                        taskMgr.cashData();
//                        tasks=taskMgr.getAllItemsByDate(beginDate,endDate);
//                    }
//                } catch (Exception ex) {
//                    Logger.getLogger(TaskServlet.class.getName()).log(Level.SEVERE, null, ex);
//                }
//
//                for(int i=0;i<tasks.size();i++){
//                    taskWbo=new WebBusinessObject();
//                    isMain="";
//                    taskWbo=(WebBusinessObject)tasks.get(i);
//                    if(taskWbo.getAttribute("isMain").toString().equalsIgnoreCase("yes"))
//                      taskWbo.setAttribute("parentUnit","no");
//                }
//                    ////////////////////////
//                  for(int i=0;i<tasks.size();i++){
//                    taskWbo=new WebBusinessObject();
//                    isMain="";
//                    taskWbo=(WebBusinessObject)tasks.get(i);
//                if (employeeTitleMgr.getOnSingleKey(taskWbo.getAttribute("empTitle").toString()) != null && !employeeTitleMgr.getOnSingleKey(taskWbo.getAttribute("empTitle").toString()).equals("")) {
//                    totalTasks.add(taskWbo);
//                    }
//                    }
//
//                tempcount=(String)request.getParameter("count");
//                if(tempcount!=null)
//                    count=Integer.parseInt(tempcount);
//
//                tradeMgr=TradeMgr.getInstance();
//
//                subTasks = new Vector();
//                wbo=new WebBusinessObject();
//                wboTrade=new WebBusinessObject();
//                maintainableMgr=MaintainableMgr.getInstance();
//
//                job="";
//
//                index=(count+1)*10;
//                id="";
//                if(totalTasks.size()<index)
//                    index=totalTasks.size();
//                
//                for (int i = count*10; i <index ; i++) {
//                    wbo = (WebBusinessObject) totalTasks.get(i);
//                    WebBusinessObject userWbo=new WebBusinessObject();
//                    userWbo=userMgr.getOnSingleKey(wbo.getAttribute("createdBy").toString());
//                    wboTrade = tradeMgr.getOnSingleKey(wbo.getAttribute("trade").toString());
//                     //------------Add Created By -------------------//
//                    
//                    if(userWbo!=null&&wboTrade!=null){
//                        job=userWbo.getAttribute("userName").toString();
//                        wbo.setAttribute("createdBy",job);
//                        job=wboTrade.getAttribute("tradeName").toString();
//                        wbo.setAttribute("trade",job);
//                        subTasks.add(wbo);
//                    }else{
//                        totalTasks.remove(i);
//                        i--;
//                    }
//                }
//
//                
//                noOfLinks=totalTasks.size()/10f;
//                temp=""+noOfLinks;
//                intNo=Integer.parseInt(temp.substring(temp.indexOf(".")+1,temp.length()));
//                links=(int)noOfLinks;
//                if(intNo>0)
//                    links++;
//                if(links==1)
//                    links=0;
//
//                servedPage = "/docs/Adminstration/view_Tasks_ByDate.jsp";
//
//                total=totalTasks.size();
//
//                request.setAttribute("total",""+total);
//                request.setAttribute("count",""+count);
//                request.setAttribute("noOfLinks",""+links);
//                request.setAttribute("fullUrl", url);
//                request.setAttribute("url", url);
//                request.setAttribute("taskName", taskName);
//                request.setAttribute("searchType", searchType);
//                request.setAttribute("formName", formName);
//                request.setAttribute("data", subTasks);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);

//                break;
//            case 56:
//                type = null;
//                taskId=null;
//                taskId = request.getParameter("taskId");
//                
//                Approval=null;
//                genericApprovalStatusMgr = GenericApprovalStatusMgr.getInstance();
//                Approval = genericApprovalStatusMgr.getOnSingleKey1(request.getParameter("taskId"));
//                if(Approval !=null )
//                {
//                    request.setAttribute("flag","true");
//                }
//                else
//                {
//                        request.setAttribute("flag","false");
//                }
//                Ntask = taskMgr.getOnSingleKey(taskId);
//                page = request.getParameter("page");
//                if(page == null) page = "";
//                 
//                    //create side menu
//                    Tools.createTaskSideMenu(request, taskId);
//
//                    request.setAttribute("Vtask",Ntask);
//
//                    type = (String) Ntask.getAttribute("isMain");
//
//                    
//                        servedPage = "/docs/Adminstration/view_Tasks_dialog.jsp";
//
//                   this.forward(servedPage, request, response);
//                                     
//
//              
//                  break;
//
//            case 57:
//                servedPage = "/docs/Adminstration/search_task_review.jsp";
//                request.setAttribute("listType","details");
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//            case 58:
//                servedPage = "/docs/Adminstration/tasks_items_review.jsp";
//                request.setAttribute("listType","details");
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//
//            case 59:
//                taskMgr = TaskMgr.getInstance();
//                itemsMgr = ItemsMgr.getInstance();
//                taskWbo = new WebBusinessObject();
//                taskPartWbo = new WebBusinessObject();
//                itemWbo = new WebBusinessObject();
//
//                taskId = "";
//                item = new WebBusinessObject();
//
//                taskId = request.getParameter("taskId");
//                taskWbo = taskMgr.getOnSingleKey(taskId);
//                String mainItemId= (String) request.getParameter("mainItemId");
////                String mainItemForm= (String) request.getParameter("mainItemForm");
//                ItemsMgr itemMgr = ItemsMgr.getInstance();
//                itemWbo = itemMgr.getOnSingleKey(mainItemId);
//
//                taskParts = new Vector();
//
//                itemCode = null;
//                try {
//                    taskParts = configAlterTasksPartsMgr.getOnArbitraryDoubleKey(taskId, "key1",mainItemId,"key2");
//                    items=new Vector();
//                    if(taskParts.size()>0){
//                        for(int i = 0; i < taskParts.size(); i++){
//                            taskPartWbo = new WebBusinessObject();
//                          //  itemWbo = new WebBusinessObject();
//                            items = new Vector();
//
//                            taskPartWbo = (WebBusinessObject)taskParts.get(i);
//                            itemCode = (String[]) taskPartWbo.getAttribute("itemId").toString().split("-");
//                            if(itemCode.length > 1) {
//                             item = itemsMgr.getOnSingleKey(taskPartWbo.getAttribute("itemId").toString());
//                             taskPartWbo.setAttribute("itemId",item.getAttribute("itemCodeByItemForm"));
//                            } else {
//                             item = itemsMgr.getOnObjectByKey(taskPartWbo.getAttribute("itemId").toString());
//                             taskPartWbo.setAttribute("itemId",item.getAttribute("itemCode"));
//                            }
//                            taskPartWbo.setAttribute("itemName",item.getAttribute("itemDscrptn"));
//                        }
//                    }
//
//                } catch (SQLException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//
//                // get all Store From Erp as ex.
//                Tools.setRequestByStoreInfo(request);
//
//                servedPage = "/docs/Adminstration/add_alter_item_parts.jsp";
//                request.setAttribute("page",servedPage);
//                request.setAttribute("taskWbo",taskWbo);
//                request.setAttribute("itemWbo",itemWbo);
//                request.setAttribute("taskParts",taskParts);
//                this.forwardToServedPage(request, response);
//                break;

            case 60:

                
//                allParts = new Vector<Hashtable>();
//                taskMgr=TaskMgr.getInstance();
//                taskWbo=new WebBusinessObject();
//                configAlterTasksPartsMgr=ConfigAlterTasksPartsMgr.getInstance();
//                itemsMgr=ItemsMgr.getInstance();
//
//                servedPage = "/docs/Adminstration/add_alter_item_parts.jsp";
//                taskId=request.getParameter("taskId");
//                mainItemId= (String) request.getParameter("mainItemId");
//                itemMgr = ItemsMgr.getInstance();
//                itemWbo = itemMgr.getOnSingleKey(mainItemId);
//                taskWbo=taskMgr.getOnSingleKey(taskId);
//
//                try {
//                    if(taskId != null){
//
//                        /*********************************************/
//                        String[] quantityPartsForEquipment = request.getParameterValues("qun");
//                        String[] pricePartsForEquipment = request.getParameterValues("price");
//                        String[] notesPartsForEquipment = request.getParameterValues("note");
//                        String[] itemIdPartsForEquipment = request.getParameterValues("code");
//                        String[] itemCostPartsForEquipment = request.getParameterValues("cost");
//                        String[] branchs = request.getParameterValues("branch");
//                        String[] stores = request.getParameterValues("store");
//                        /************ Delete Previous item Parts**************/
//                        try{
//                            configAlterTasksPartsMgr.deleteOnArbitraryDoubleKey(taskId, "key1",mainItemId,"key2");
//                        }catch (Exception ex) {
//                            logger.error(ex.getMessage());
//                        }
//                        
//                        /*************end of delete*************/
//                        int size=quantityPartsForEquipment.length;
//                        Hashtable<String, String> hashConfig;
//
//                        for(int i = 0 ; i < size; i++) {
//                            branch = branchs[i];
//                            store = stores[i];
//
//                            if((branch != null && !branch.equals("none") && !branch.equals("null"))
//                                    && (store != null && !store.equals("none") && !store.equals("null"))) { 
//                               if(!mainItemId.equals(itemIdPartsForEquipment[i])){
//                                    hashConfig = new Hashtable<String, String>();
//                                    hashConfig.put("TaskCode",taskId);
//                                    hashConfig.put("mainItemId",mainItemId);
//                                    hashConfig.put("itemID", itemIdPartsForEquipment[i]);
//                                    hashConfig.put("itemQuantity", quantityPartsForEquipment[i]);
//                                    hashConfig.put("itemPrice", pricePartsForEquipment[i]);
//                                    hashConfig.put("totalCost", itemCostPartsForEquipment[i]);
//                                    hashConfig.put("note", notesPartsForEquipment[i]);
//                                    hashConfig.put("branch", branchs[i]);
//                                    hashConfig.put("store", stores[i]);
//                                    hashConfig.put("mainItem","0");
//
//                                    allParts.addElement(hashConfig);
//                               }
//
//                            } else {
//                                // cannot save store or branch by null or none
//                                request.setAttribute("Status", "No");
//                                break;
//                            }
//                        }
//
//                         Vector mainItemV = new Vector();
//                         mainItemV = configTasksPartsMgr.getOnArbitraryDoubleKey(taskId, "key1",mainItemId,"key2");
//                         WebBusinessObject mainItemWbo = new WebBusinessObject();
//                         if(mainItemV.size()>0){
//                             mainItemWbo = (WebBusinessObject) mainItemV.get(0);
//                             hashConfig = new Hashtable<String, String>();
//                                hashConfig.put("TaskCode",taskId);
//                                hashConfig.put("mainItemId",mainItemId);
//                                hashConfig.put("itemID", mainItemId);
//                                hashConfig.put("itemQuantity", mainItemWbo.getAttribute("itemQuantity").toString());
//                                hashConfig.put("itemPrice", mainItemWbo.getAttribute("itemPrice").toString());
//                                hashConfig.put("totalCost", mainItemWbo.getAttribute("totalCost").toString());
//                                hashConfig.put("note", mainItemWbo.getAttribute("note").toString());
//                                hashConfig.put("branch", mainItemWbo.getAttribute("branchCode").toString());
//                                hashConfig.put("store", mainItemWbo.getAttribute("storeCode").toString());
//                                hashConfig.put("mainItem","1");
//                                allParts.addElement(hashConfig);
//                         }
//                        if(configAlterTasksPartsMgr.saveObjects(allParts)) {
//                            request.setAttribute("Status", "OK");
//                        } else {
//                            request.setAttribute("Status", "No");
//                        }
//                    } else {
//                        request.setAttribute("Status", "No");
//                    }
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//
//                taskParts=new Vector();
//                distItemsMgr=DistributedItemsMgr.getInstance();
//
//                try {
//
//                    taskParts = configAlterTasksPartsMgr.getOnArbitraryDoubleKey(taskId, "key1",mainItemId,"key2");
//                    items=new Vector();
//                    if(taskParts.size()>0){
//                        for(int i=0;i<taskParts.size();i++){
//                            taskPartWbo=new WebBusinessObject();
//                            
//                            items=new Vector();
//
//                            taskPartWbo=(WebBusinessObject)taskParts.get(i);
//                            itemCode = (String[]) taskPartWbo.getAttribute("itemId").toString().split("-");
//                            if(itemCode.length > 1) {
//                             item = itemsMgr.getOnSingleKey(taskPartWbo.getAttribute("itemId").toString());
//                             taskPartWbo.setAttribute("itemId",item.getAttribute("itemCodeByItemForm"));
//                            } else {
//                             item = itemsMgr.getOnObjectByKey(taskPartWbo.getAttribute("itemId").toString());
//                             taskPartWbo.setAttribute("itemId",item.getAttribute("itemCode"));
//                            }
//                            taskPartWbo.setAttribute("itemName",item.getAttribute("itemDscrptn"));
//                        }
//                    }
//
//                } catch (SQLException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//
//                // get all Store From Erp as ex.
//                Tools.setRequestByStoreInfo(request);
//
//                request.setAttribute("taskWbo",taskWbo);
//                request.setAttribute("taskParts",taskParts);
//                request.setAttribute("itemWbo",itemWbo);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
                break;

            case 61:
//                taskMgr=TaskMgr.getInstance();
//                taskWbo=new WebBusinessObject();
//                configTasksPartsMgr=ConfigTasksPartsMgr.getInstance();
//                itemsMgr=ItemsMgr.getInstance();
//
//                servedPage = "/docs/Adminstration/reset_spare_parts_by_task.jsp";
//                taskId=request.getParameter("taskId");
//                taskWbo=taskMgr.getOnSingleKey(taskId);
//
//                distItemsMgr=DistributedItemsMgr.getInstance();
//                taskParts=new Vector();
//                taskPartsTemp=new Vector();
//                alterTaskPartsTemp=new Vector();
//                try {
//
//                    taskParts=configTasksPartsMgr.getOnArbitraryKey(taskId,"key1");
//                    
////                    for(int i=0;i<taskPartsTemp.size();i++){
////                        WebBusinessObject wboTemp = new WebBusinessObject();
////                        wboTemp = (WebBusinessObject)taskPartsTemp.get(i);
////                        alterTaskPartsTemp = configAlterTasksPartsMgr.getOnArbitraryDoubleKey(taskId, "key1",wboTemp.getAttribute("itemId").toString(),"key3");
////                        if(alterTaskPartsTemp.size()>0){
////                            logger.debug("true");
////                            configTasksPartsMgr.deleteOnSingleKey(wboTemp.getAttribute("id").toString());
////                        }else{
////                            taskParts.add(wboTemp);
////                        }
////                    }
//
//                    items=new Vector();
//                    if(taskParts.size()>0){
//                        for(int i=0;i<taskParts.size();i++){
//                            taskPartWbo=new WebBusinessObject();
//                            itemWbo=new WebBusinessObject();
//                            items=new Vector();
//
//                            taskPartWbo=(WebBusinessObject)taskParts.get(i);
////                            items=itemsMgr.getOnArbitraryKey(taskPartWbo.getAttribute("itemId").toString(),"key3");
////                            if(items.size()>0){
////                                itemWbo=(WebBusinessObject)items.get(0);
////                                taskPartWbo.setAttribute("itemName",itemWbo.getAttribute("itemDscrptn").toString());
////                            }
//                             itemCode = (String[]) taskPartWbo.getAttribute("itemId").toString().split("-");
//                            if(itemCode.length > 1) {
//                             item = itemsMgr.getOnSingleKey(taskPartWbo.getAttribute("itemId").toString());
//                             taskPartWbo.setAttribute("itemId",item.getAttribute("itemCodeByItemForm"));
//                            } else {
//                             item = itemsMgr.getOnObjectByKey(taskPartWbo.getAttribute("itemId").toString());
//                             taskPartWbo.setAttribute("itemId",item.getAttribute("itemCode"));
//                            }
////                            item = distItemsMgr.getOnSingleKey(taskPartWbo.getAttribute("itemId").toString());
//                            taskPartWbo.setAttribute("itemName",item.getAttribute("itemDscrptn"));
//
//                        }
//                    }
//
//                } catch (SQLException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//
//                request.setAttribute("taskWbo",taskWbo);
//                request.setAttribute("taskParts",taskParts);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;

           case 62:

//                allParts = new Vector<Hashtable>();
//                taskMgr=TaskMgr.getInstance();
//                taskWbo=new WebBusinessObject();
//                configAlterTasksPartsMgr=ConfigAlterTasksPartsMgr.getInstance();
//                itemsMgr=ItemsMgr.getInstance();
//
//                servedPage = "/docs/Adminstration/add_alter_item_parts.jsp";
//                taskId=request.getParameter("taskId");
//                mainItemId= (String) request.getParameter("mainItemId");
//                itemMgr = ItemsMgr.getInstance();
//                
//                taskWbo=taskMgr.getOnSingleKey(taskId);
//                String masterItem = (String) request.getParameter("masterItem");
//                String[] alterItem = request.getParameterValues("alterItem");
//                itemWbo = new WebBusinessObject();
//                WebBusinessObject mainItemWbo = new WebBusinessObject();
//                mainItemWbo = (WebBusinessObject) configTasksPartsMgr.getOnSingleKey(masterItem);
//                try {
//                    if(taskId != null && masterItem!= null && !masterItem.equals("")
//                            && alterItem != null && !alterItem.equals("")){
//
//                        /*********************************************/
//                        
////                        String[] pricePartsForEquipment = request.getParameterValues("price");
////                        String[] notesPartsForEquipment = request.getParameterValues("note");
////                        String[] itemIdPartsForEquipment = request.getParameterValues("code");
////                        String[] itemCostPartsForEquipment = request.getParameterValues("cost");
////                        String[] branchs = request.getParameterValues("branch");
////                        String[] stores = request.getParameterValues("store");
////                        /************ Delete Previous item Parts**************/
////                        try{
////                            configAlterTasksPartsMgr.deleteOnArbitraryDoubleKey(taskId, "key1",mainItemId,"key2");
////                        }catch (Exception ex) {
////                            logger.error(ex.getMessage());
////                        }
//
//                        /*************end of delete*************/
//                        int size=alterItem.length;
//                        Hashtable<String, String> hashConfig;
//                        String taskPartByAlter=null;
//                        Vector mainItemV = new Vector();
//                        
//                        mainItemWbo = (WebBusinessObject) configTasksPartsMgr.getOnSingleKey(masterItem);
//                        
//                        itemWbo = itemMgr.getOnSingleKey(mainItemWbo.getAttribute("itemId").toString());
//                            for (int i = 0; i < size; i++) {
//                                taskPartByAlter = alterItem[i];
//                                WebBusinessObject alterItemWbo = new WebBusinessObject();
//                                alterItemWbo = (WebBusinessObject) configTasksPartsMgr.getOnSingleKey(taskPartByAlter);
//                                hashConfig = new Hashtable<String, String>();
//                                hashConfig.put("TaskCode", taskId);
//                                hashConfig.put("mainItemId", mainItemWbo.getAttribute("itemId").toString());
//                                hashConfig.put("itemID", alterItemWbo.getAttribute("itemId").toString());
//                                hashConfig.put("itemQuantity", alterItemWbo.getAttribute("itemQuantity").toString());
//                                hashConfig.put("itemPrice", alterItemWbo.getAttribute("itemPrice").toString());
//                                hashConfig.put("totalCost", alterItemWbo.getAttribute("totalCost").toString());
//                                hashConfig.put("note", alterItemWbo.getAttribute("note").toString());
//                                hashConfig.put("branch", alterItemWbo.getAttribute("branchCode").toString());
//                                hashConfig.put("store", alterItemWbo.getAttribute("storeCode").toString());
//                                hashConfig.put("mainItem", "0");
//                                allParts.addElement(hashConfig);
//                            }
//
//
//                            hashConfig = new Hashtable<String, String>();
//                            hashConfig.put("TaskCode", taskId);
//                            hashConfig.put("mainItemId", mainItemWbo.getAttribute("itemId").toString());
//                            hashConfig.put("itemID", mainItemWbo.getAttribute("itemId").toString());
//                            hashConfig.put("itemQuantity", mainItemWbo.getAttribute("itemQuantity").toString());
//                            hashConfig.put("itemPrice", mainItemWbo.getAttribute("itemPrice").toString());
//                            hashConfig.put("totalCost", mainItemWbo.getAttribute("totalCost").toString());
//                            hashConfig.put("note", mainItemWbo.getAttribute("note").toString());
//                            hashConfig.put("branch", mainItemWbo.getAttribute("branchCode").toString());
//                            hashConfig.put("store", mainItemWbo.getAttribute("storeCode").toString());
//                            hashConfig.put("mainItem", "1");
//                            allParts.addElement(hashConfig);
//
//                            if (configAlterTasksPartsMgr.saveObjects(allParts)) {
//                                request.setAttribute("Status", "OK");
//                            } else {
//                                request.setAttribute("Status", "No");
//                            }
//                        } else {
//                            request.setAttribute("Status", "No");
//                        }
//                    } catch (Exception ex) {
//                        logger.error(ex.getMessage());
//                    }
//
//                taskParts=new Vector();
//                distItemsMgr=DistributedItemsMgr.getInstance();
//                taskParts=new Vector();
//                taskPartsTemp=new Vector();
//                alterTaskPartsTemp=new Vector();
//
//
//
//                try {
//
//                    taskPartsTemp=configTasksPartsMgr.getOnArbitraryKey(taskId,"key1");
//
//                    for(int i=0;i<taskPartsTemp.size();i++){
//                        WebBusinessObject wboTemp = new WebBusinessObject();
//                        wboTemp = (WebBusinessObject)taskPartsTemp.get(i);
//                        alterTaskPartsTemp = configAlterTasksPartsMgr.getOnArbitraryDoubleKey(taskId, "key1",wboTemp.getAttribute("itemId").toString(),"key3");
//                        if(alterTaskPartsTemp.size()>0){
//                            logger.debug("true");
//                            WebBusinessObject tempWbo = (WebBusinessObject) alterTaskPartsTemp.get(0);
//                            if(tempWbo.getAttribute("mainItem").toString().equals("0")){
//                                configTasksPartsMgr.deleteOnSingleKey(wboTemp.getAttribute("id").toString());
//                            }
//                            
//                        }else{
//                            taskParts.add(wboTemp);
//                        }
//                    }
//                    
//
//                    taskParts = configAlterTasksPartsMgr.getOnArbitraryDoubleKey(taskId, "key1",mainItemWbo.getAttribute("itemId").toString(),"key2");
//                    items=new Vector();
//                    if(taskParts.size()>0){
//                        for(int i=0;i<taskParts.size();i++){
//                            taskPartWbo=new WebBusinessObject();
//
//                            items=new Vector();
//
//                            taskPartWbo=(WebBusinessObject)taskParts.get(i);
//                            itemCode = (String[]) taskPartWbo.getAttribute("itemId").toString().split("-");
//                            if(itemCode.length > 1) {
//                             item = itemsMgr.getOnSingleKey(taskPartWbo.getAttribute("itemId").toString());
//                             taskPartWbo.setAttribute("itemId",item.getAttribute("itemCodeByItemForm"));
//                            } else {
//                             item = itemsMgr.getOnObjectByKey(taskPartWbo.getAttribute("itemId").toString());
//                             taskPartWbo.setAttribute("itemId",item.getAttribute("itemCode"));
//                            }
//                            taskPartWbo.setAttribute("itemName",item.getAttribute("itemDscrptn"));
//                        }
//                    }
//
//                } catch (SQLException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//
//                // get all Store From Erp as ex.
//                Tools.setRequestByStoreInfo(request);
//
//                request.setAttribute("taskWbo",taskWbo);
//                request.setAttribute("taskParts",taskParts);
//                request.setAttribute("itemWbo",itemWbo);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
               break;

//                case 63:
//
//                tradeMgr = TradeMgr.getInstance();
//                taskTypeMgr = TaskTypeMgr.getInstance();
//                employeeTitleMgr = EmployeeTitleMgr.getInstance();
//
//                tradeList = tradeMgr.getCashedTableAsBusObjects();
//                mainTypesList = mainCategoryTypeMgr.getCashedTableAsBusObjects();
//                tasktypeList = taskTypeMgr.getCashedTableAsBusObjects();
//                empTitleList = employeeTitleMgr.getCashedTableAsBusObjects();
//
//                servedPage = "/docs/Adminstration/new_measure_main.jsp";
//
//                request.setAttribute("mainTypes", mainTypesList);
//                request.setAttribute("tradeList", tradeList);
//                request.setAttribute("tasktypeList", tasktypeList);
//                request.setAttribute("empTitleList", empTitleList);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//
//                case 64:
//                dateAndTime = new DateAndTimeControl();
//                minutes=0;
//                servedPage = "/docs/Adminstration/new_measure_main.jsp";
//                taskTypeMgr =TaskTypeMgr.getInstance();
//                tasktitle = null;
//                TaskTypeName = new WebBusinessObject();
//                TaskTypeName = taskTypeMgr.getOnSingleKey(request.getParameter("taskType").toString());
//                tasktitle = TaskTypeName.getAttribute("name").toString()+ " - " +request.getParameter("description").toString();
//                Ntask = new WebBusinessObject();
//
//                day = (String)request.getParameter("day");
//                hour = (String)request.getParameter("hour");
//                minute = (String)request.getParameter("minute");
//
//                if(day != null && !day.equals("")){
//                    minutes = minutes + dateAndTime.getMinuteOfDay(day);
//                }
//                if(hour != null && !hour.equals("")) {
//                    minutes = minutes + dateAndTime.getMinuteOfHour(hour);
//                }
//                if(minute != null && !minute.equals("")) {
//                     minutes = minutes + new Integer(minute).intValue();
//                }
//
//                configTasksPartsMgr=ConfigTasksPartsMgr.getInstance();
//
//                TaskCode=request.getParameter("title").toString();
//                Ntask .setAttribute("title",request.getParameter("title").toString());
//                Ntask .setAttribute("name",request.getParameter("description").toString());
//                Ntask .setAttribute("tradeName",request.getParameter("tradeName").toString());
//                Ntask .setAttribute("taskType",request.getParameter("taskType").toString());
//                Ntask .setAttribute("empTitle",request.getParameter("empTitle").toString());
//                Ntask .setAttribute("taskTitle",tasktitle);
//                Ntask .setAttribute("categoryName","");
//                Ntask .setAttribute("mainTypeId",request.getParameter("mainTypeId").toString());
//                Ntask .setAttribute("isMain","yes");
//                Ntask .setAttribute("executionHrs",Integer.toString(minutes));
//                Ntask .setAttribute("jobzise",request.getParameter("jobzise").toString());
//                Ntask .setAttribute("engDesc",request.getParameter("engDesc").toString());
//                Ntask .setAttribute("costHour",request.getParameter("costHour").toString());
//
//                taskId="";
//                taskWbo = new WebBusinessObject();
//                try {
//                    if(!taskMgr.getDoubleName(request.getParameter("title"))) {
//                        taskId=taskMgr.saveTask(Ntask, session);
//                        if(taskId!=null){
//                            request.setAttribute("Status" , "Ok");
//
//                            // create side menu
//                            Tools.createTaskSideMenu(request, taskId);
//                            taskWbo = taskMgr.getOnSingleKey(taskId);
//                        }
//
//                        else
//                            request.setAttribute("Status", "No");
//
//                    }else {
//                        request.setAttribute("Status", "No");
//                        request.setAttribute("name", "Duplicate Name");
//                    }
//                } catch (NoUserInSessionException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//
//                mainCategoryTypeMgr=MainCategoryTypeMgr.getInstance();
//                tradeMgr = TradeMgr.getInstance();
//                taskTypeMgr = TaskTypeMgr.getInstance();
//                employeeTitleMgr = EmployeeTitleMgr.getInstance();
//
//                tradeList = tradeMgr.getCashedTableAsBusObjects();
//                mainTypesList = mainCategoryTypeMgr.getCashedTableAsBusObjects();
//                tasktypeList = taskTypeMgr.getCashedTableAsBusObjects();
//                empTitleList = employeeTitleMgr.getCashedTableAsBusObjects();
//
//                request.setAttribute("mainTypes", mainTypesList);
//                request.setAttribute("tradeList", tradeList);
//                request.setAttribute("tasktypeList", tasktypeList);
//                request.setAttribute("empTitleList", empTitleList);
//                request.setAttribute("taskWbo",taskWbo);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//

            default:
                System.out.println("No operation was matched");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException { processRequest(request, response); }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException { processRequest(request, response); }

    @Override
    public String getServletInfo() { return "Search Servlet"; }

    @Override
    protected int getOpCode(String opName) {
        if(opName.equalsIgnoreCase("GetTaskForm"))
            return 1;
        if(opName.equalsIgnoreCase("newtask"))
            return 2;
        if(opName.equalsIgnoreCase("list"))
            return 3;
        if(opName.equalsIgnoreCase("code"))
            return 4;
        if(opName.equalsIgnoreCase("tasks"))
            return 5;
        if(opName.equalsIgnoreCase("view"))
            return 6;
        if(opName.equalsIgnoreCase("update"))
            return 7;
        if(opName.equals("GetTaskUpdate"))
            return 8;
        if(opName.equalsIgnoreCase("confdel"))
            return 9;
        if(opName.equalsIgnoreCase("Delete"))
            return 10;
        if(opName.equalsIgnoreCase("tasksByCategory"))
            return 11;
        if(opName.equalsIgnoreCase("ViewTasksByCategory"))
            return 12;
        if(opName.equalsIgnoreCase("tasksByTrade"))
            return 13;
        if(opName.equalsIgnoreCase("ViewTasksByTrade"))
            return 14;
        if(opName.equalsIgnoreCase("listEq"))
            return 15;
        if(opName.equalsIgnoreCase("listLocalSpares"))
            return 16;
        if(opName.equalsIgnoreCase("getLocalSpareData"))
            return 17;
        if(opName.equalsIgnoreCase("configTimeScheduleLocalParts"))
            return 18;
        if(opName.equalsIgnoreCase("SaveconfigMainTypeHourlyLocalPartes"))
            return 19;
        if(opName.equalsIgnoreCase("getItemsReportForm"))
            return 20;
        if(opName.equalsIgnoreCase("itemReportdata"))
            return 21;
        if(opName.equalsIgnoreCase("extractToExcel"))
            return 22;
        if(opName.equalsIgnoreCase("addPartsForm"))
            return 23;
        if(opName.equalsIgnoreCase("saveItemParts"))
            return 24;
        if(opName.equalsIgnoreCase("viewItemParts"))
            return 25;
        if(opName.equalsIgnoreCase("addLightToolsForm"))
            return 26;
        if(opName.equalsIgnoreCase("addHeavyToolsForm"))
            return 27;
        if(opName.equalsIgnoreCase("removeFromSession"))
            return 28;
        if(opName.equalsIgnoreCase("executionNotesForm"))
            return 29;
        if(opName.equalsIgnoreCase("listParts"))
            return 30;
        if(opName.equalsIgnoreCase("listTasks"))
            return 31;
        if(opName.equalsIgnoreCase("listTools"))
            return 32;
        if(opName.equalsIgnoreCase("saveTaskTools"))
            return 33;
        if(opName.equalsIgnoreCase("getTaskMainForm"))
            return 34;
        if(opName.equalsIgnoreCase("saveTaskMain"))
            return 35;
        if(opName.equalsIgnoreCase("viewTaskMain"))
            return 36;
        if(opName.equalsIgnoreCase("updateTaskMain"))
            return 37;
        if(opName.equals("GetTaskMainUpdate"))
            return 38;
        if(opName.equals("searchTask"))
            return 39;
        if(opName.equals("searchTaskResult"))
            return 40;
        if(opName.equals("getTaskData"))
            return 41;
        if(opName.equals("saveTaskNotes"))
            return 42;
        if(opName.equals("printTaskForm"))
            return 43;
        if(opName.equals("listLightTools"))
            return 44;
        if(opName.equals("tasksByName"))
            return 45;
        if(opName.equals("searchTaskBySub"))
            return 46;
        if(opName.equals("addToolForm"))
            return 47;
        if(opName.equals("saveTools"))
            return 48;
        if(opName.equals("delTaskFromSideMenu"))
            return 49;
        if(opName.equalsIgnoreCase("listTasksByCode"))
            return 50;
        if(opName.equalsIgnoreCase("confirmDelete"))
            return 51;
        if(opName.equalsIgnoreCase("searchTaskNotPopup"))
            return 52;
        if(opName.equalsIgnoreCase("getSearchTaskNotPopup"))
            return 53;
        if(opName.equalsIgnoreCase("getTaskDataNotPopup"))
            return 54;
        if(opName.equalsIgnoreCase("getTaskByDate"))
            return 55;        
        if(opName.equalsIgnoreCase("viewInDialog"))
            return 56;
        if(opName.equalsIgnoreCase("searchToReview"))
            return 57;
        if(opName.equalsIgnoreCase("tasksItemsToReview"))
            return 58;
        if(opName.equalsIgnoreCase("setAlternativeItems"))
            return 59;
        if(opName.equalsIgnoreCase("saveAlterItemParts"))
            return 60;
        if(opName.equalsIgnoreCase("resetSpareParts"))
            return 61;
        if(opName.equalsIgnoreCase("migrateAlterItemParts"))
            return 62;
        if(opName.equalsIgnoreCase("newMeasureForBasicTypeForm"))
            return 63;
        if(opName.equalsIgnoreCase("saveMeasure"))
            return 64;
        return 0;
    }
}

