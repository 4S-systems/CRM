<%@page import="com.crm.common.CRMConstants"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="com.silkworm.common.CustomizationPanelElement"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.Vector"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%
            MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
            String context = metaDataMgr.getContext();

            String userId = request.getParameter("userId");
            Map<CustomizationPanelElement, String> map = (Map<CustomizationPanelElement, String>) request.getAttribute("map");

            String seletedChanelDirection = map.get(CustomizationPanelElement.CHANEL_DIRECTION_ELEMENT);
            String seletedProduct = map.get(CustomizationPanelElement.PRODUCT_ELEMENT);
            String seletedCampaign = map.get(CustomizationPanelElement.CAMPAIGN_ELEMENT);
            String seletedDefaultNewClientDistribution = map.get(CustomizationPanelElement.DEFAULT_NEW_CLIENT_DISTRIBUTION_ELEMENT);
            String seletedDefaultDesktop = map.get(CustomizationPanelElement.DEFAULT_DESKTOP_ELEMENT);
            String seletedDefaultBranch = map.get(CustomizationPanelElement.DEFAULT_BRANCH_ELEMENT);
            String seletedCanChangeHeadBar = map.get(CustomizationPanelElement.CAN_CHANGE_HEAD_BAR_ELEMENT);
            String seletedRunOnAutoPilot = map.get(CustomizationPanelElement.RUN_ON_AUTO_PILOT_ELEMENT);
            String selectedDistributionGroup = map.get(CustomizationPanelElement.DISTRIBUTION_GROUP_ELEMENT);
            String selectedPersonalDistribution = map.get(CustomizationPanelElement.PERSONAL_DISTRIBUTION_ELEMENT);
            String selectedPersonalDistributionType = map.get(CustomizationPanelElement.PERSONAL_DISTRIBUTION_TYPE_ELEMENT);
            
            int index = 0;

            List<WebBusinessObject> tools = (List<WebBusinessObject>) request.getAttribute("tools");
            List<WebBusinessObject> allgroups = (List<WebBusinessObject>) request.getAttribute("allgroups");
            List<WebBusinessObject> groups = (List<WebBusinessObject>) request.getAttribute("groups");
            List<WebBusinessObject> branchs = (List<WebBusinessObject>) request.getAttribute("branchs");
            List<WebBusinessObject> products = (List<WebBusinessObject>) request.getAttribute("products");
            List<WebBusinessObject> requestTypes = (List<WebBusinessObject>) request.getAttribute("requestTypes");

            String state = (String) request.getSession().getAttribute("currentMode");
            String align = null;
            String dir = null;
            if (state.equals("En")) {
                align = "center";
                dir = "LTR";
            } else {
                align = "center";
                dir = "RTL";
            }
        %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Call Center Customization</title>

        <link rel="stylesheet" href="css/CSS.css">
        <script type="text/javascript">
            function submitForm() {
                document.CLIEN_FORM.action = "<%=context%>/CustomizationPanelServlet?op=customizationPanelStore";
                document.CLIEN_FORM.submit();
            }

            function showDiv(id) {
                if (document.getElementById(id).style.display == 'none') {
                    document.getElementById(id).style.display = 'block';
                    document.getElementById(id + 'Icon').src = 'images/arrow_down_white.png';
                } else {
                    document.getElementById(id).style.display = 'none';
                    document.getElementById(id + 'Icon').src = 'images/arrow_right_white.png';
                }
            }
        </script>
    </head>
    <body>
        <FORM NAME="CLIEN_FORM" METHOD="POST">
            <div dir="ltr" style="text-align: left; padding-left: 5%">
                <button  type="button" onclick="submitForm()" id='submitBtn' value="" style="display: inline-block; width: 150px"><b><font color="blue">تسجيل</font></b>&ensp;<img src="images/icons/database_store.png" width="24" height="24"/></button>
            </div>
            <center>
                <fieldset class="set" style="width:90%;border-color: #006699;">
                    <table class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <tr>
                            <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueBorder blueHeaderTD">
                                <font color="black" size="4">Call Center Customization</font>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="50%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4">
                        <tr>
                            <TD STYLE="font-size: 12px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                                <div style="height: auto">
                                    <h3 onclick="JavaScript: showDiv('seletedCampaignDiv')" style="color: blue; text-align: left; cursor: hand"><%=CustomizationPanelElement.CAMPAIGN_ELEMENT.getTitle()%>&ensp;<img id="seletedCampaignDivIcon" src="images/arrow_right_white.png" style="padding-top: 2px"/></h3>
                                    <hr>
                                    <div id="seletedCampaignDiv" dir="ltr" style="text-align: left; display: none; padding-left: 5%">
                                        <% for (WebBusinessObject tool : tools) {%>
                                        <input type="radio" name="seletedCampaign" value="<%=tool.getAttribute("id")%>" <%if (tool.getAttribute("id").equals(seletedCampaign) || index == 0) {%> checked="true"<%}%> ><%=tool.getAttribute("campaignTitle")%> <br>
                                        <%
                                        index++;
                                        }%>
                                        <input type="radio" name="seletedCampaign" value="-1" <%if ("-1".equals(seletedCampaign)) {%> checked="true"<%}%> >None<br>
                                    </div>
                                    <hr>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <TD STYLE="font-size: 12px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                                <div style="height: auto">
                                    <h3 onclick="JavaScript: showDiv('seletedRunOnAutoPilotDiv')" style="color: blue; text-align: left; cursor: hand"><%=CustomizationPanelElement.RUN_ON_AUTO_PILOT_ELEMENT.getTitle()%>&ensp;<img id="seletedRunOnAutoPilotDivIcon" src="images/arrow_right_white.png" style="padding-top: 2px"/></h3>
                                    <hr>
                                    <div id="seletedRunOnAutoPilotDiv" dir="ltr" style="text-align: left; display: none; padding-left: 5%">
                                        <input type="radio" name="seletedRunOnAutoPilot" value="<%=CRMConstants.RUN_ON_AUTO_PILOT_YES%>" checked>Yes<br>
                                        <input type="radio" name="seletedRunOnAutoPilot" value="<%=CRMConstants.RUN_ON_AUTO_PILOT_NO%>" <%=(CRMConstants.RUN_ON_AUTO_PILOT_NO.equalsIgnoreCase(seletedRunOnAutoPilot)) ? "checked" : ""%>>No<br>                                    
                                    </div>
                                    <hr>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <TD STYLE="font-size: 12px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                                <div style="height: auto">
                                    <h3 onclick="JavaScript: showDiv('seletedDefaultNewClientDistributionDiv')" style="color: blue; text-align: left; cursor: hand"><%=CustomizationPanelElement.DEFAULT_NEW_CLIENT_DISTRIBUTION_ELEMENT.getTitle()%>&ensp;<img id="seletedDefaultNewClientDistributionDivIcon" src="images/arrow_right_white.png" style="padding-top: 2px"/></h3>
                                    <hr>
                                    <div id="seletedDefaultNewClientDistributionDiv" dir="ltr" style="text-align: left; display: none; padding-left: 5%">
                                        <% 
                                        index = 0;
                                        for (WebBusinessObject group : allgroups) {%>
                                        <input type="radio" name="seletedDefaultNewClientDistribution" value="<%=group.getAttribute("groupID")%>" <%if (group.getAttribute("groupID").equals(seletedDefaultNewClientDistribution) || index == 0) {%> checked="true"<%}%> ><%=group.getAttribute("groupName")%> <br>
                                        <%
                                        index++;
                                        }%>
                                    </div>
                                    <hr>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <TD STYLE="font-size: 12px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                                <div style="height: auto">
                                    <h3 onclick="JavaScript: showDiv('seletedDefaultDesktopDiv')" style="color: blue; text-align: left; cursor: hand"><%=CustomizationPanelElement.DEFAULT_DESKTOP_ELEMENT.getTitle()%>&ensp;<img id="seletedDefaultDesktopDivIcon" src="images/arrow_right_white.png" style="padding-top: 2px"/></h3>
                                    <hr>
                                    <div id="seletedDefaultDesktopDiv" dir="ltr" style="text-align: left; display: none; padding-left: 5%">
                                        <%
                                        index = 0;
                                        for (WebBusinessObject group : groups) {%>
                                        <input type="radio" name="seletedDefaultDesktop" value="<%=group.getAttribute("groupID")%>" <%if (group.getAttribute("groupID").equals(seletedDefaultDesktop) || index == 0) {%> checked="true"<%}%> ><%=group.getAttribute("groupName")%> <br>
                                        <%
                                        index++;
                                        }%>
                                    </div>
                                    <hr>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <TD STYLE="font-size: 12px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                                <div style="height: auto">
                                    <h3 onclick="JavaScript: showDiv('seletedDefaultBranchDiv')" style="color: blue; text-align: left; cursor: hand"><%=CustomizationPanelElement.DEFAULT_BRANCH_ELEMENT.getTitle()%>&ensp;<img id="seletedDefaultBranchDivIcon" src="images/arrow_right_white.png" style="padding-top: 2px"/></h3>
                                    <hr>
                                    <div id="seletedDefaultBranchDiv" dir="ltr" style="text-align: left; display: none; padding-left: 5%">
                                        <%
                                        index = 0;
                                        for (WebBusinessObject branch : branchs) {%>
                                        <input type="radio" name="seletedDefaultBranch" value="<%=branch.getAttribute("projectID")%>" <%if (branch.getAttribute("projectID").equals(seletedDefaultBranch) || index == 0) {%> checked="true"<%}%> ><%=branch.getAttribute("projectName")%> <br>
                                        <%
                                        index++;
                                        }%>
                                    </div>
                                    <hr>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <TD STYLE="font-size: 12px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                                <div style="height: auto">
                                    <h3 onclick="JavaScript: showDiv('seletedProductDiv')" style="color: blue; text-align: left; cursor: hand"><%=CustomizationPanelElement.PRODUCT_ELEMENT.getTitle()%>&ensp;<img id="seletedProductDivIcon" src="images/arrow_right_white.png" style="padding-top: 2px"/></h3>
                                    <hr>
                                    <div id="seletedProductDiv" dir="ltr" style="text-align: left; display: none; padding-left: 5%">
                                        <%
                                        index = 0;
                                        for (WebBusinessObject product : products) {%>
                                        <input type="radio" name="seletedProduct" value="<%=(String) product.getAttribute("projectID")%>" <%if (((String) product.getAttribute("projectID")).equals(seletedProduct) || index == 0) {%> checked="true" <%}%> ><%=(String) product.getAttribute("projectName")%> <br>
                                        <%
                                        index++;
                                        }%> 
                                    </div>
                                    <hr>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <TD STYLE="font-size: 12px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                                <div style="height: auto">
                                    <h3 onclick="JavaScript: showDiv('seletedChanelDirectionDiv')" style="color: blue; text-align: left; cursor: hand"><%=CustomizationPanelElement.CHANEL_DIRECTION_ELEMENT.getTitle()%>&ensp;<img id="seletedChanelDirectionDivIcon" src="images/arrow_right_white.png" style="padding-top: 2px"/></h3>
                                    <hr>
                                    <div id="seletedChanelDirectionDiv" dir="ltr" style="text-align: left; display: none; padding-left: 5%">
                                        <input type="radio" name="seletedChanelDirection" value="<%=CRMConstants.CALL_CENTER_INBOUND_CALL%>" checked>Inbound Call<br>
                                        <input type="radio" name="seletedChanelDirection" value="<%=CRMConstants.CALL_CENTER_OUTBOUND_CALL%>" <%=(CRMConstants.CALL_CENTER_OUTBOUND_CALL.equalsIgnoreCase(seletedChanelDirection)) ? "checked" : ""%>>Outbound Call<br>
                                        <input type="radio" name="seletedChanelDirection" value="<%=CRMConstants.CALL_CENTER_INBOUND_VISIT%>" <%=(CRMConstants.CALL_CENTER_INBOUND_VISIT.equalsIgnoreCase(seletedChanelDirection)) ? "checked" : ""%>>Inbound Visit<br>
                                        <input type="radio" name="seletedChanelDirection" value="<%=CRMConstants.CALL_CENTER_OUTBOUND_VISIT%>" <%=(CRMConstants.CALL_CENTER_OUTBOUND_VISIT.equalsIgnoreCase(seletedChanelDirection)) ? "checked" : ""%>>Outbound Visit<br>
                                        <input type="radio" name="seletedChanelDirection" value="<%=CRMConstants.CALL_CENTER_INBOUND_INTERNET%>" <%=(CRMConstants.CALL_CENTER_INBOUND_INTERNET.equalsIgnoreCase(seletedChanelDirection)) ? "checked" : ""%>>Inbound Internet<br>
                                    </div>
                                    <hr>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <TD STYLE="font-size: 12px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                                <div style="height: auto">
                                    <h3 onclick="JavaScript: showDiv('selectedDistributionGroupDiv')" style="color: blue; text-align: left; cursor: hand"><%=CustomizationPanelElement.DISTRIBUTION_GROUP_ELEMENT.getTitle()%>&ensp;<img id="selectedDistributionGroupDivIcon" src="images/arrow_right_white.png" style="padding-top: 2px"/></h3>
                                    <hr>
                                    <div id="selectedDistributionGroupDiv" dir="ltr" style="text-align: left; display: none; padding-left: 5%">
                                        <% 
                                        index = 0;
                                        for (WebBusinessObject group : allgroups) {%>
                                        <input type="radio" name="selectedDistributionGroup" value="<%=group.getAttribute("groupID")%>" <%if (group.getAttribute("groupID").equals(selectedDistributionGroup) || index == 0) {%> checked="true"<%}%> ><%=group.getAttribute("groupName")%> <br>
                                        <%
                                        index++;
                                        }%>
                                    </div>
                                    <hr>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <TD STYLE="font-size: 12px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                                <div style="height: auto">
                                    <h3 onclick="JavaScript: showDiv('selectedPersonalDistributionDiv')" style="color: blue; text-align: left; cursor: hand"><%=CustomizationPanelElement.PERSONAL_DISTRIBUTION_ELEMENT.getTitle()%>&ensp;<img id="selectedPersonalDistributionDivIcon" src="images/arrow_right_white.png" style="padding-top: 2px"/></h3>
                                    <hr>
                                    <div id="selectedPersonalDistributionDiv" dir="ltr" style="text-align: left; display: none; padding-left: 5%">
                                        <input type="radio" name="selectedPersonalDistribution" value="<%=CRMConstants.FREEZE_HEAD_BAR_YES%>" <%=(CRMConstants.FREEZE_HEAD_BAR_YES.equalsIgnoreCase(selectedPersonalDistribution)) ? "checked" : ""%>>Yes<br>
                                        <input type="radio" name="selectedPersonalDistribution" value="<%=CRMConstants.FREEZE_HEAD_BAR_NO%>" <%=(CRMConstants.FREEZE_HEAD_BAR_YES.equalsIgnoreCase(selectedPersonalDistribution)) ? "" : "checked"%>>No<br>
                                        <br/>
                                        <select name="selectedPersonalDistributionType" style="font-size: 16px; height: 25px;">
                                        <% 
                                        index = 0;
                                        for (WebBusinessObject requestType : requestTypes) {%>
                                        <option value="<%=requestType.getAttribute("projectID")%>" <%=requestType.getAttribute("projectID").equals(selectedPersonalDistributionType) ? "selected" : ""%> ><%=requestType.getAttribute("projectName")%></option>
                                        <%
                                        index++;
                                        }%>
                                        <select>
                                    </div>
                                    <hr>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <TD STYLE="font-size: 12px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                                <div style="height: auto">
                                    <h3 onclick="JavaScript: showDiv('seletedCanChangeHeadBarDiv')" style="color: blue; text-align: left; cursor: hand"><%=CustomizationPanelElement.CAN_CHANGE_HEAD_BAR_ELEMENT.getTitle()%>&ensp;<img id="seletedCanChangeHeadBarDivIcon" src="images/arrow_right_white.png" style="padding-top: 2px"/></h3>
                                    <hr>
                                    <div id="seletedCanChangeHeadBarDiv" dir="ltr" style="text-align: left; display: none; padding-left: 5%">
                                        <input type="radio" name="seletedCanChangeHeadBar" value="<%=CRMConstants.FREEZE_HEAD_BAR_NO%>" <%=(CRMConstants.FREEZE_HEAD_BAR_YES.equalsIgnoreCase(seletedCanChangeHeadBar)) ? "" : "checked"%>>No<br>
                                        <input type="radio" name="seletedCanChangeHeadBar" value="<%=CRMConstants.FREEZE_HEAD_BAR_YES%>" <%=(CRMConstants.FREEZE_HEAD_BAR_YES.equalsIgnoreCase(seletedCanChangeHeadBar)) ? "checked" : ""%>>Yes<br>
                                    </div>
                                    <hr>
                                </div>
                            </td>
                        </tr>
                    </TABLE>
                    <br/>
                </fieldset>
            </center>
            <input type="hidden" id="userId" name="userId" value="<%=userId%>" />
        </form>
    </body>
</html>
