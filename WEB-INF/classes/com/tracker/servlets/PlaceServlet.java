package com.tracker.servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.util.*;
import java.sql.*;
import com.tracker.common.*;
import com.tracker.db_access.*;
import com.tracker.business_objects.*;
import com.silkworm.servlets.*;
import org.apache.log4j.Logger;

public class PlaceServlet extends swBaseServlet {

    PlaceMgr placeMgr = PlaceMgr.getInstance();
    WebIssue wIssue = new WebIssue();
    WebBusinessObject place = null;
    WebBusinessObject userObj = null;
    String viewOrigin = null;

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        servedPage = "/docs/Adminstration/new_place.jsp";
        logger = Logger.getLogger(PlaceServlet.class);
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
        HttpSession session = request.getSession();
        userObj = (WebBusinessObject) session.getAttribute("loggedUser");

        // issueMgr.setUser(userObj);

        String page = null;

        operation = getOpCode((String) request.getParameter("op"));

        switch (operation) {
            case 1:
                String issueId = request.getParameter(IssueConstants.ISSUEID);
                String issueTitle = request.getParameter(IssueConstants.ISSUETITLE);

                servedPage = "/docs/Adminstration/new_place.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);


                break;

            case 2:
                String dName = request.getParameter("place_name");
                String dDescription = request.getParameter("place_desc");

                WebBusinessObject place = new WebBusinessObject();

                place.setAttribute("placeName", dName);
                place.setAttribute("placeDesc", dDescription);

                servedPage = "/docs/Adminstration/new_place.jsp";
                try {
                    if (placeMgr.saveObject(place, session)) {
                        request.setAttribute("Status", "Ok");
                    } else {
                        request.setAttribute("Status", "No");
                    }

                } catch (NoUserInSessionException noUser) {
                    logger.error("Place Servlet: save place " + noUser);
                }

                //request.setAttribute("data", issuesList);
                //request.setAttribute("status", "Unassigned");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 3:
                Vector places = placeMgr.getCashedTable();
                servedPage = "/docs/Adminstration/place_list.jsp";

                request.setAttribute("data", places);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 4:
                String placeName = request.getParameter("placeName");
                String placeId = request.getParameter("placeId");

                servedPage = "/docs/Adminstration/confirm_delplace.jsp";

                request.setAttribute("placeName", placeName);
                request.setAttribute("placeId", placeId);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;


            case 5:
                servedPage = "/docs/Adminstration/view_place.jsp";
                placeId = request.getParameter("placeId");

                place = placeMgr.getOnSingleKey(placeId);
                request.setAttribute("place", place);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;

            case 6:
                placeId = request.getParameter("placeId");
                place = placeMgr.getOnSingleKey(placeId);

                servedPage = "/docs/Adminstration/update_place.jsp";

                request.setAttribute("place", place);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 7:
                servedPage = "/docs/Adminstration/update_place.jsp";

                try {

                    scrapeForm(request, "update");

                    place = new WebBusinessObject();
                    place.setAttribute("placeDesc", request.getParameter("place_desc"));
                    place.setAttribute("placeID", request.getParameter("placeID"));

                    // do update
                    placeMgr.updatePlace(place);

                    // fetch the group again
                    shipBack("ok", request, response);
                    break;
                } catch (EmptyRequestException ere) {
                    shipBack(ere.getMessage(), request, response);
                    break;
                } catch (SQLException sqlEx) {
                    shipBack(sqlEx.getMessage(), request, response);
                    break;
                } catch (NoUserInSessionException nouser) {
                    shipBack(nouser.getMessage(), request, response);
                    break;
                } catch (Exception Ex) {
                    shipBack(Ex.getMessage(), request, response);
                    break;
                }
            case 8:
                try {
                    IssueMgr issueMgr = IssueMgr.getInstance();
                    Integer iTemp = new Integer(issueMgr.hasData("Place_NAME", request.getParameter("placeName")));
                    if (iTemp.intValue() > 0) {
                        servedPage = "/docs/Adminstration/cant_delete.jsp";
                        request.setAttribute("servlet", "PlaceServlet");
                        request.setAttribute("list", "ListPlaces");
                        request.setAttribute("type", "Place");
                        request.setAttribute("name", request.getParameter("placeName"));
                        request.setAttribute("no", iTemp.toString());
                        request.setAttribute("page", servedPage);
                    } else {
                        placeMgr.deleteOnSingleKey(request.getParameter("placeId"));
                        placeMgr.cashData();
                        places = placeMgr.getCashedTable();
                        servedPage = "/docs/Adminstration/place_list.jsp";

                        request.setAttribute("data", places);
                        request.setAttribute("page", servedPage);
                    }
                    this.forwardToServedPage(request, response);
                } catch (NoUserInSessionException ne) {
                }

                break;



            default:
                this.forwardToServedPage(request, response);



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
        return "Place Servlet";
    }

    protected int getOpCode(String opName) {

        if (opName.equalsIgnoreCase("GetPlaceForm")) {
            return 1;
        }
        if (opName.equalsIgnoreCase("create")) {
            return 2;
        }

        if (opName.equalsIgnoreCase("ListPlaces")) {
            return 3;
        }

        if (opName.equalsIgnoreCase("ConfirmDelete")) {
            return 4;
        }

        if (opName.equalsIgnoreCase("ViewPlace")) {
            return 5;
        }

        if (opName.equalsIgnoreCase("GetUpdateForm")) {
            return 6;
        }

        if (opName.equalsIgnoreCase("UpdatePlace")) {
            return 7;
        }

        if (opName.equalsIgnoreCase("Delete")) {
            return 8;
        }
//


        return 0;
    }

    private void scrapeForm(HttpServletRequest request, String mode) throws EmptyRequestException, EntryExistsException, SQLException, Exception {

        String placeID = request.getParameter("placeID");
        String placeDesc = request.getParameter("place_desc");

        if (placeID == null || placeDesc.equals("")) {
            throw new EmptyRequestException(tGuide.getMessage("incompleteinput"));
        }

        if (placeID.equals("") || placeDesc.equals("")) {
            throw new EmptyRequestException(tGuide.getMessage("incompleteinput"));
        }

        if (mode.equalsIgnoreCase("insert")) {
            WebBusinessObject existingPlace = placeMgr.getOnSingleKey(placeID);

            if (existingPlace != null) {
                throw new EntryExistsException();
            }

        }
    }

    private void shipBack(String message, HttpServletRequest request, HttpServletResponse response) {
        place = placeMgr.getOnSingleKey(request.getParameter("placeID"));
        request.setAttribute("place", place);
        request.setAttribute("status", message);
        request.setAttribute("page", servedPage);
        this.forwardToServedPage(request, response);

    }
}
