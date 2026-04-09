<%-- 
    Document   : list_expense_items
    Created on : Apr 29, 2018, 9:08:29 AM
    Author     : fatma
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="com.financials.db_access.ExpenseItemRelativeMgr"%>
<%@page import="java.util.List"%>
<%@page import="com.android.business_objects.LiteWebBusinessObject"%>
<%@page import="com.financials.db_access.ExpenseItemMgr"%>
<%@page import="java.util.Vector"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        ArrayList<LiteWebBusinessObject> itemsList = request.getAttribute("itemsList") != null ? (ArrayList<LiteWebBusinessObject>) request.getAttribute("itemsList") : null;
        ExpenseItemMgr expenseItemMgr = ExpenseItemMgr.getInstance();
        
        String stat = (String) request.getSession().getAttribute("currentMode");

        String dir, title, bgColor, bgColorm, sCostItemCode, sCostItemName, sEdit, sView, sDelete, sFactors, sDriver, sTrip,
                sClient, sAgent, sAbsolut;
        if (stat.equals("En")) {
            dir = "LTR";
            title = "Attach Employees to a Car";
            sCostItemCode = "Code";
            sCostItemName = "Name";
            sEdit = "Edit";
            sView = "View";
            sDelete = "Delete";
            sFactors = "Factors";
            sDriver = "Driver";
            sTrip = "Trip";
            sClient = "Client";
            sAgent = "Agent";
            sAbsolut = "Absolut";
        } else {
            dir = "RTL";
            title = "عرض بنود التكلفه";
            sCostItemCode = "الكود";
            sCostItemName = "الاسم";
            sEdit = "تعديل";
            sView = "مشاهدة";
            sDelete = "حذف";
            sFactors = "المعاملات";
            sDriver = "سائق";
            sTrip = "رحلة";
            sClient = "عميل";
            sAgent = "متعهد";
            sAbsolut = "مطلق";
        }
        
        int flipper = 0;
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        
        <script>
            $(document).ready(function(){
                $("#tblData").dataTable({
                    "destroy": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    "columnDefs": [{
                            "targets": 0,
                            "orderable": false
                        }],
                    "order": [[2, "asc"]]
                }).fadeIn(2000);
            });
            
            function viewCostItem(costItemId){
                var url = "FinancialServlet?op=viewCostItem&costItemId=" + costItemId;
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=500, height=300");
            }
        </script>
    </head>
    
    <body>
        <form NAME="ATTACH_EMPLOYEES_TO_CAR_FORM" METHOD="POST">
            <fieldset class="set" style="width: 90%; border-color: #006699;" >
                <legend>
                    <font size="+1">
                         <%=title%> 
                    </font>
                </legend>
                    
                <DIV id="tblDataDiv" style="display: block; width: 90%;">
                    <TABLE id="tblData" class="blueBorder" ALIGN="center" dir="<%=dir%>" width="100%" cellpadding="0" cellspacing="0">
                        <thead>
                            <TR>
                                <TD CLASS="silver_header" STYLE="text-align: center; color: black; font-size: 14px; font-weight: bold;" nowrap width="5%">
                                    <b>
                                         # 
                                    </b>
                                </TD>

                                <TD CLASS="silver_header" STYLE="text-align: center; color: black; font-size: 14px; font-weight: bold;" nowrap width="10%">
                                    <b>
                                         <%=sCostItemCode%> 
                                    </b>
                                </TD>

                                <TD CLASS="silver_header" STYLE="text-align: center; color: black; font-size: 14px; font-weight: bold;" nowrap width="20%">
                                    <b>
                                         <%=sCostItemName%> 
                                    </b>
                                </TD>

                                <TD CLASS="silver_header" STYLE="text-align: center; color: black; font-size: 14px; font-weight: bold;" nowrap width="30%">
                                    <b>
                                         <%=sFactors%> 
                                    </b>
                                </TD>

                                <TD CLASS="silver_header" STYLE="text-align: center; color: black; font-size: 14px; font-weight: bold;" nowrap width="15%">
                                    <b>
                                         <%=sView%> 
                                    </b>
                                </TD>

                                <TD CLASS="silver_header" STYLE="text-align: center; color: black; font-size: 14px; font-weight: bold; display: none;" nowrap width="10%">
                                    <b>
                                         <%=sEdit%> 
                                    </b>
                                </TD>

                                <TD CLASS="silver_header" STYLE="text-align: center; color: black; font-size: 14px; font-weight: bold;" nowrap width="10%">
                                    <b>
                                         <%=sDelete%> 
                                    </b>
                                </TD>
                            </TR>
                        </thead>
                        
                        <tbody>
                            <%
                                int iTotal = 0;
                                LiteWebBusinessObject costItemWbo = new LiteWebBusinessObject();
                                ExpenseItemRelativeMgr expenseItemRelativeMgr=ExpenseItemRelativeMgr.getInstance();
                                ArrayList<LiteWebBusinessObject> fDriverOfCostItemV = new ArrayList<LiteWebBusinessObject>();
                                ArrayList<LiteWebBusinessObject> fJourneyOfCostItemV = new ArrayList<LiteWebBusinessObject>();
                                ArrayList<LiteWebBusinessObject> fClientOfCostItemV = new ArrayList<LiteWebBusinessObject>();
                                ArrayList<LiteWebBusinessObject> fAgentOfCostItemV = new ArrayList<LiteWebBusinessObject>();
                                LiteWebBusinessObject dWbo = null, jWbo = null, cWbo = null, aWbo = null;
                                for (int i = 0; i < itemsList.size(); i++) {
                                    costItemWbo = (LiteWebBusinessObject) itemsList.get(i);
                                    fDriverOfCostItemV = new ArrayList<LiteWebBusinessObject>(expenseItemRelativeMgr.getOnArbitraryDoubleKey(costItemWbo.getAttribute("id").toString(), "key1","driver","key2"));
                                    fJourneyOfCostItemV = new ArrayList<LiteWebBusinessObject>(expenseItemRelativeMgr.getOnArbitraryDoubleKey(costItemWbo.getAttribute("id").toString(), "key1","journey","key2"));
                                    fClientOfCostItemV = new ArrayList<LiteWebBusinessObject>(expenseItemRelativeMgr.getOnArbitraryDoubleKey(costItemWbo.getAttribute("id").toString(), "key1","client","key2")); 
                                    fAgentOfCostItemV = new ArrayList<LiteWebBusinessObject>(expenseItemRelativeMgr.getOnArbitraryDoubleKey(costItemWbo.getAttribute("id").toString(), "key1","agent","key2")); 
                                    dWbo=null;jWbo=null;cWbo=null;aWbo = null;
                                    if(fDriverOfCostItemV!=null && fDriverOfCostItemV.size()>0){
                                        dWbo = (LiteWebBusinessObject) fDriverOfCostItemV.get(0);
                                    }

                                    if(fJourneyOfCostItemV!=null && fJourneyOfCostItemV.size()>0){
                                        jWbo = (LiteWebBusinessObject) fJourneyOfCostItemV.get(0);
                                    }

                                    if(fClientOfCostItemV!=null && fClientOfCostItemV.size()>0){
                                        cWbo = (LiteWebBusinessObject) fClientOfCostItemV.get(0);
                                    }

                                    if(fAgentOfCostItemV!=null && fAgentOfCostItemV.size()>0){
                                        aWbo = (LiteWebBusinessObject) fAgentOfCostItemV.get(0);
                                    }
                                    //unitNameStr = expenseItemMgr.getMeasurementUnitName(empWbo.getAttribute("measureUnit").toString());
                                    iTotal++;
                                    flipper++;

                                    if ((flipper % 2) == 1) {
                                        bgColor = "silver_odd";
                                        bgColorm = "silver_odd_main";
                                    } else {
                                        bgColor = "silver_even";
                                        bgColorm = "silver_even_main";
                                    }
                            %>
                                    <TR>
                                        <TD CLASS="<%=bgColorm%>" nowrap style="text-align: center;">
                                             <%=i+1%> 
                                        </TD>

                                        <TD CLASS="<%=bgColor%>" nowrap style="text-align: center;">
                                             <%=costItemWbo.getAttribute("code")%> 
                                        </TD>

                                        <TD CLASS="<%=bgColor%>" nowrap style="text-align: center;">
                                             <%=costItemWbo.getAttribute("arName")%> 
                                        </TD>

                                        <TD CLASS="<%=bgColor%>" nowrap style="text-align: center;">
                                            <%
                                                if(dWbo==null && jWbo==null && cWbo==null && aWbo==null){
                                            %>
                                                     <%=sAbsolut%> 
                                            <%
                                                }else{
                                                    if(dWbo!=null && !dWbo.equals("")){
                                            %>
                                                         <%=sDriver%> 
                                            <%
                                                    }

                                                    if(jWbo!=null && !jWbo.equals("")){
                                            %>
                                                         <%=sTrip%> 
                                            <%
                                                    }

                                                    if(cWbo!=null && !cWbo.equals("")){
                                            %>
                                                         <%=sClient%> 
                                            <%
                                                    }

                                                    if(aWbo!=null && !aWbo.equals("")){
                                            %>
                                                         <%=sAgent%> 
                                            <%
                                                    }
                                                }
                                            %>
                                        </TD>

                                        <TD CLASS="<%=bgColor%>" nowrap style="text-align: center;">
                                            <a href="javascript: viewCostItem('<%=costItemWbo.getAttribute("id").toString()%>');">
                                                 <%=sView%> 
                                            </a>
                                        </TD>

                                        <TD CLASS="<%=bgColor%>" nowrap style="text-align: center; display: none;">
                                            <a href="<%=context%>/FinancialServlet?op=saveExpenseItem&costItemId=<%=costItemWbo.getAttribute("id")%>">
                                                 <%=sEdit%> 
                                            </a>
                                        </TD>

                                        <TD CLASS="<%=bgColor%>" nowrap style="text-align: center;">
                                            <a href="<%=context%>/FinancialServlet?op=deleteExpenseItem&expenseItemId=<%=costItemWbo.getAttribute("id")%>">
                                                 <%=sDelete%> 
                                            </a>
                                        </TD>
                                    </TR>
                            <%
                                }
                            %>
                        </tbody>
                    </TABLE>
                </DIV>
            </fieldset>
        </form>
    </body>
</html>