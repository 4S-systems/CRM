/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.crm.servlets;

import com.crm.db_access.ChannelsMgr;
import com.crm.db_access.ChannelsUsersMgr;
import com.maintenance.common.Tools;
import com.silkworm.business_objects.WebBusinessObject;
import com.tracker.db_access.ProjectMgr;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.tracker.servlets.TrackerBaseServlet;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

/**
 *
 * @author walid
 */
public class ChannelsServlet extends TrackerBaseServlet {

    private ChannelsMgr channelsMgr;
    private ChannelsUsersMgr channelsUsersMgr;
    private ProjectMgr projectMgr;
    private Vector<WebBusinessObject> channels;
    private WebBusinessObject wbo;
    private WebBusinessObject data;
    private String channelId;
    private String channelName;
    private String action;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    @Override
    public void destroy() {
    }

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        String loggegUserId = (String) loggedUser.getAttribute("userId");

        channelsMgr = ChannelsMgr.getInstance();
        channelsUsersMgr = ChannelsUsersMgr.getInstance();
        projectMgr = ProjectMgr.getInstance();
        wbo = new WebBusinessObject();
        data = new WebBusinessObject();

        switch (operation) {

            case 1:
                channelId = request.getParameter("channelId");
                servedPage = "/docs/channels/new_channel.jsp";
                Vector departments = new Vector();
                channels = new Vector<WebBusinessObject>();
                action = "add";
                try {
                    departments = projectMgr.getDepartmentsWithManager(loggegUserId);
                    channels = channelsMgr.getOnArbitraryKey(loggegUserId, "key1");
                } catch (Exception ex) {
                    logger.error(ex);
                }
                if (channelId != null) {
                    Vector<WebBusinessObject> channelUsers;
                    List<String> channelsUsersIds = new ArrayList<String>();
                    List<String> departmentNames = new ArrayList<String>();
                    String userId, departmentName;
                    if (channelId != null) {
                        try {
                            channelName = channelsMgr.getByKeyColumnValue(channelId, "key2");
                            channelUsers = channelsUsersMgr.getOnArbitraryKey(channelId, "key1");
                            for (WebBusinessObject channelUser : channelUsers) {
                                userId = (String) channelUser.getAttribute("usersId");
                                channelsUsersIds.add(userId);
                                departmentName = projectMgr.getByKeyColumnValue("key5", userId, "key1");
                                if (departmentName == null) {
                                    departmentName = "None";
                                }
                                departmentNames.add(departmentName);
                            }
                        } catch (Exception ex) {
                            logger.error(ex);
                        }
                    }
                    request.setAttribute("channelsUsersIds", channelsUsersIds);
                    request.setAttribute("departmentNames", departmentNames);
                    request.setAttribute("channelName", channelName);
                    action = "update";
                }
                String departmentName = projectMgr.getByKeyColumnValue("key5", loggegUserId, "key1");
                if (departmentName == null) {
                    departmentName = "None";
                }

                request.setAttribute("page", servedPage);
                request.setAttribute("channels", channels);
                request.setAttribute("departments", departments);
                request.setAttribute("action", action);
                request.setAttribute("departmentName", departmentName);
                this.forwardToServedPage(request, response);
                break;

            case 2:
                servedPage = "ChannelsServlet?op=getChannelChannel";
                channelId = request.getParameter("channelId");
                action = request.getParameter("action");
                String name = request.getParameter("name");
                String[] allUsers = request.getParameterValues("users");
                String[] selectedUsers = request.getParameterValues("departments");
                String[] users = new String[selectedUsers.length];
                for (int i = 0; i < selectedUsers.length; i++) {
                    users[i] = allUsers[Integer.parseInt(selectedUsers[i])];
                }
                try {
                    boolean checker = true;
                    if (action != null && action.equalsIgnoreCase("add")) {
                        if (channelsMgr.getOnSingleKey("key2", channelName) != null) {
                            checker = false;
                        }
                    } else {
                        if (channelsMgr.isValueAlreadyExist(channelName, "key2", channelId)) {
                            checker = false;
                        }
                    }

                    if (channelId != null && checker) {
                        checker = channelsMgr.updateObject(channelId, name, loggegUserId, users);
                    } else if (checker) {
                        checker = channelsMgr.saveObject(name, loggegUserId, users);
                    }

                    if (checker) {
                        request.setAttribute("status", "ok");
                    } else {
                        request.setAttribute("status", "no");
                    }
                } catch (Exception ex) {
                    logger.error(ex);
                }
                this.forward(servedPage, request, response);
                break;

            case 3:
                channelId = request.getParameter("channelId");
                channelName = request.getParameter("channelName");
                action = request.getParameter("action");
                String status = "no";
                if (action != null && action.equalsIgnoreCase("add")) {
                    if (channelsMgr.getOnSingleKey("key2", channelName) != null) {
                        status = "ok";
                    }
                } else {
                    if (channelsMgr.isValueAlreadyExist(channelName, "key2", channelId)) {
                        status = "ok";
                    }
                }

                data.setAttribute("status", status);
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(data));
                break;

            default:
                System.out.println("No operation was matched");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Channels Servlet";
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.equals("getChannelChannel")) {
            return 1;
        } else if (opName.equals("saveOrUpdateChannel")) {
            return 2;
        } else if (opName.equals("checkChannelName")) {
            return 3;
        }
        return 0;
    }
}
