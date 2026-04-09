/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.hubs.servlet;

import com.hubs.db_access.OrgnDstnRlnMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.SecurityUser;
import com.tracker.db_access.ProjectMgr;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author khaled abdo
 */
public class HubsServlet extends TrackerBaseServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    ProjectMgr projectMgr = null;
    OrgnDstnRlnMgr orgnDstnRlnMgr = null;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            switch (operation) {
                case 1:

                    String saveSiteRelation = request.getParameter("saveSiteRelation");

                    String siteOne = null,
                     siteTwo = null,
                     distance = null,
                     cost = null;

                    WebBusinessObject wbo = new WebBusinessObject();

                    try {
                        if (saveSiteRelation != null) {
                            wbo.setAttribute("siteOne", request.getParameter("siteOne"));
                            wbo.setAttribute("siteTwo", request.getParameter("siteTwo"));

                            try {
                                wbo.setAttribute("distance", request.getParameter("distance"));
                                wbo.setAttribute("cost", request.getParameter("cost"));
                                wbo.setAttribute("access", request.getParameter("access"));
                            } catch (NullPointerException e) {
                                wbo.setAttribute("access", "0");
                                wbo.setAttribute("distance", "0");
                                wbo.setAttribute("cost", "0");
                                System.out.println(e.getMessage());
                            }
                            wbo.setAttribute("beginDate", request.getParameter("beginDate"));
                            wbo.setAttribute("endDate", request.getParameter("endDate"));
                            orgnDstnRlnMgr = OrgnDstnRlnMgr.getInstance();

                            if (orgnDstnRlnMgr.saveSiteRelation(wbo)) {
                                request.setAttribute("status", "ok");
                            } else {
                                request.setAttribute("status", "no");
                            }
                        }
                    } catch (NullPointerException e) {
                        System.out.println(e.getMessage());
                    }


                    projectMgr = ProjectMgr.getInstance();
                    ArrayList allSites = projectMgr.getAllAsArrayList();

                    request.setAttribute("defaultLocationName", securityUser.getSiteName());
                    request.setAttribute("allSites", allSites);
                    servedPage = "/docs/hubs/add_projects_relation.jsp";

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 2:
                    servedPage = "/docs/hubs/projects_relations.jsp";
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 3:
                    String page = request.getParameter("servedPage");

                    if (page.equals("projsRls")) {
                        servedPage = "/docs/hubs/get_projects_relations.jsp";
                    } else if (page.equals("allProjsAccess")) {
                        servedPage = "/docs/hubs/all_projects_relations_access.jsp";
                    } else if (page.equals("projsAccess")) {
                        servedPage = "/docs/hubs/get_projects_relations_access.jsp";
                    } else if (page.equals("projsDist")) {
                        servedPage = "/docs/hubs/get_projects_relations_dist.jsp";
                    } else if (page.equals("projsCost")) {
                        servedPage = "/docs/hubs/get_projects_relations_cost.jsp";
                    }

                    orgnDstnRlnMgr = OrgnDstnRlnMgr.getInstance();
                    projectMgr = ProjectMgr.getInstance();
                    Vector projectsRelations = new Vector();
                    Vector allProjects = new Vector();
                    Vector distinctProjectsTwo = orgnDstnRlnMgr.getDistinctProjectsTwo();
                    try {

                        allProjects = projectMgr.getCashedTable();
                    } catch (NullPointerException e) {
                        //allProjects = projectMgr.getSitesBySort();
                        System.out.println(e.getMessage());
                    }

                    projectsRelations = orgnDstnRlnMgr.getAllProjectsRelations();
                    request.setAttribute("projectsRelations", projectsRelations);
                    request.setAttribute("allProjects", allProjects);
                    request.setAttribute("distinctProjectsTwo", distinctProjectsTwo);
                    this.forward(servedPage, request, response);
                    break;

                case 4:
                    wbo = new WebBusinessObject();
                    try {
                        wbo.setAttribute("id", request.getParameter("id"));
                        wbo.setAttribute("value", request.getParameter("value"));
                        wbo.setAttribute("type", request.getParameter("saveType"));

                        orgnDstnRlnMgr = OrgnDstnRlnMgr.getInstance();
                        if (orgnDstnRlnMgr.updateProjectsRelation(wbo)) {
                            request.setAttribute("status", "ok");
                        } else {
                            request.setAttribute("status", "no");
                        }
                    } catch (NullPointerException e) {
                        System.out.println(e.getMessage());
                    }
                    break;

                case 5:
                    wbo = new WebBusinessObject();

                    saveSiteRelation = request.getParameter("saveSiteRelation");
                    servedPage = "/docs/hubs/projs_relation_id.jsp";
                    String id = new String();
                    /*try {
                    wbo.setAttribute("projOne", request.getParameter("projOne"));
                    wbo.setAttribute("projTwo", request.getParameter("projTwo"));

                    orgnDstnRlnMgr = OrgnDstnRlnMgr.getInstance();

                    id = orgnDstnRlnMgr.addProjectsRelation(wbo);
                    if (!id.equals("")) {
                    request.setAttribute("status", "ok");
                    } else {
                    request.setAttribute("status", "no");
                    }

                    } catch (Exception e) {
                    System.out.println(e.getMessage());
                    }*/
                    try {
                        if (saveSiteRelation != null) {
                            wbo.setAttribute("siteOne", request.getParameter("siteOne"));
                            wbo.setAttribute("siteTwo", request.getParameter("siteTwo"));

                            try {
                                wbo.setAttribute("distance", request.getParameter("distance"));
                                wbo.setAttribute("cost", request.getParameter("cost"));
                                wbo.setAttribute("access", request.getParameter("access"));
                            } catch (NullPointerException e) {
                                wbo.setAttribute("access", "0");
                                wbo.setAttribute("distance", "0");
                                wbo.setAttribute("cost", "0");
                                System.out.println(e.getMessage());
                            }
                            wbo.setAttribute("beginDate", request.getParameter("beginDate"));
                            wbo.setAttribute("endDate", request.getParameter("endDate"));
                            orgnDstnRlnMgr = OrgnDstnRlnMgr.getInstance();

                            id = orgnDstnRlnMgr.addProjectsRelation(wbo);
                            if (!id.equals("")) {
                                request.setAttribute("status", "ok");
                            } else {
                                request.setAttribute("status", "no");
                            }
                        }
                    } catch (NullPointerException e) {
                        System.out.println(e.getMessage());
                    }
                    request.setAttribute("id", id);
                    this.forward(servedPage, request, response);

                    break;

                case 6:
                    wbo = new WebBusinessObject();

                    saveSiteRelation = request.getParameter("saveSiteRelation");
                    servedPage = "/docs/hubs/projs_relation_id.jsp";
                    id = new String();

                    try {
                        id = request.getParameter("id");
                        wbo.setAttribute("id", id);

                        try {
                            wbo.setAttribute("distance", request.getParameter("distance"));
                            wbo.setAttribute("cost", request.getParameter("cost"));
                            wbo.setAttribute("access", request.getParameter("access"));
                        } catch (NullPointerException e) {
                            wbo.setAttribute("access", "0");
                            wbo.setAttribute("distance", "0");
                            wbo.setAttribute("cost", "0");
                            System.out.println(e.getMessage());
                        }
                        wbo.setAttribute("beginDate", request.getParameter("beginDate"));
                        wbo.setAttribute("endDate", request.getParameter("endDate"));
                        orgnDstnRlnMgr = OrgnDstnRlnMgr.getInstance();
                        try {
                            if (orgnDstnRlnMgr.updateProjRelations(wbo)) {
                                request.setAttribute("status", "ok");
                            } else {
                                request.setAttribute("status", "no");
                            }
                        } catch (ParseException ex) {
                            Logger.getLogger(HubsServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    } catch (NullPointerException e) {
                        System.out.println(e.getMessage());
                    }
                    request.setAttribute("id", id);
                    this.forward(servedPage, request, response);

                    break;
                default:
                    break;
            }
        } finally {
            out.close();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    public int getOpCode(String opName) {
        if (opName.equals("getSiteRelationForm")) {
            return 1;
        } else if (opName.equals("saveSiteRelation")) {
            return 1;
        } else if (opName.equals("projectsRelations")) {
            return 2;
        } else if (opName.equals("getProjectsRelations")) {
            return 3;
        } else if (opName.equals("updateProjectsRelations")) {
            return 4;
        } else if (opName.equals("addProjectsRelation")) {
            return 5;
        } else if (opName.equals("updateProjRelations")) {
            return 6;
        }
        return 0;
    }
}
