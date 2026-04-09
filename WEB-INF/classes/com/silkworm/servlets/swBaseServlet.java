package com.silkworm.servlets;

import com.maintenance.db_access.TradeTempMgr;
import java.io.*;
import java.util.*;

import javax.servlet.*;
import javax.servlet.http.*;

import com.silkworm.util.*;
import com.silkworm.business_objects.*;
import com.silkworm.common.ApplicationSessionRegistery;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.international.TouristGuide;
import com.silkworm.common.TimeServices;
import com.silkworm.functional_security.db_access.BusinessOpSecurityMgr;
import com.silkworm.db_access.PersistentSessionMgr;
import java.sql.SQLException;
import java.util.logging.Level;

import org.apache.log4j.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class swBaseServlet extends HttpServlet {

    protected String servedPage = null;
    protected ServletContext servletContext = null;
    protected int operation = 0;
    protected String web_inf_path = null;
    protected String context = null;
    protected TouristGuide tGuide = null;
    private String groupID = null;
    protected static Logger logger;
    protected ApplicationSessionRegistery sessionRegistery;
    protected Vector userTradesVec = null;
        
    public PersistentSessionMgr persistentSessionMgr = PersistentSessionMgr.getInstance();
    

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        logger = Logger.getLogger(swBaseServlet.class);
        if (MetaDataMgr.getInstance().getWebInfPath() != null) {
            DOMConfigurator.configure(MetaDataMgr.getInstance().getWebInfPath() + "/LogConfig.xml");
        }
        logger.info("swBaseServlet starting up ........");
        web_inf_path = getServletContext().getRealPath("/WEB-INF");
        tGuide = new TouristGuide("/com/silkworm/international/Messages");
        sessionRegistery = ApplicationSessionRegistery.getInstance();
    }

    @Override
    public void destroy() {
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        if ("1".equals(MetaDataMgr.getInstance().getCheckAuthorization())) {
            WebBusinessObject authorityWbo = TradeTempMgr.getInstance().getOnSingleKey("1");
            if (authorityWbo == null || "0".equals(authorityWbo.getAttribute("isAuthorized"))) {
                goToUnauthorized(request, response);
                return;
            } else if (authorityWbo != null) {
                if ("1".equals(authorityWbo.getAttribute("isLocked"))) {
                    goToLocked(request, response);
                    return;
                } else if ("0".equals(authorityWbo.getAttribute("isPaid"))) {
                    goToNotPaid(request, response);
                    return;
                }
            }
        }
        
        String remoteAccess = request.getSession().getId();
        WebBusinessObject persistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
        if(persistentUser == null) {
            goToIndex(request, response);
            return;
        }
        
        
        
        HttpSession session = request.getSession();
        WebBusinessObject userObj = null;
        try {
            userObj = (WebBusinessObject) session.getAttribute("loggedUser");
        } catch (Exception ex) {
            logger.error(ex);
        }
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");

        if (loggedUser != null) {
            groupID = (String) loggedUser.getAttribute("groupID");
            request.getSession().setAttribute("loggedUser", loggedUser);
        }
        if (userObj != null) {
            userTradesVec = (Vector) userObj.getAttribute("userTrade");

            operation = getOpCode((String) request.getParameter("op"));

            ArrayList requestAsArray = ServletUtils.getRequestParams(request);
            logger.info("Request Array Size is " + requestAsArray.size());
            ServletUtils.printRequest(requestAsArray);
        } else {
            this.goToIndex(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "This is the parent for all application servlets";
    }

    protected void forward(String url, HttpServletRequest request, HttpServletResponse response) {
        try {
            RequestDispatcher rd = request.getRequestDispatcher(url);
            HttpSession session = request.getSession();
            WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
            request.getSession().setAttribute("loggedUser", loggedUser);

            rd.forward(request, response);
        } catch (IOException ioex) {
            goTo(url + ", " + ioex, "error", request, response);
        } catch (ServletException general) {
            goTo(url + ", " + general, "error", request, response);
        }
    }

    protected void goTo(String url, String errorCode, HttpServletRequest request, HttpServletResponse response) {
        logger.error("Exception while trying to forward " + url);
        try {
            RequestDispatcher requestDispatcher = request.getRequestDispatcher("/index.jsp");
            requestDispatcher.forward(request, response);
        } catch (ServletException general) {
            logger.error("Exception while trying to forward " + url + ", Message: " + general.getMessage());
        } catch (IOException general) {
            logger.error("Exception while trying to forward " + url + ", Message: " + general.getMessage());
        }
    }

    protected void goToIndex(HttpServletRequest request, HttpServletResponse response) {
        String url = "/index.jsp";
        logger.error("Exception while trying to forward " + url);
        try {
            RequestDispatcher requestDispatcher = request.getRequestDispatcher(url);
            requestDispatcher.forward(request, response);
        } catch (ServletException general) {
            logger.error("Exception while trying to forward " + url + ", Message: " + general.getMessage());
        } catch (IOException general) {
            logger.error("Exception while trying to forward " + url + ", Message: " + general.getMessage());
        }
    }

    protected void goToErrorPage(HttpServletRequest request, HttpServletResponse response, Throwable throwable) {
        String url = "/error.jsp";
        logger.error("Exception while trying to forward " + url);
        try {
            RequestDispatcher requestDispatcher = request.getRequestDispatcher(url);
            requestDispatcher.forward(request, response);
        } catch (ServletException general) {
            logger.error("Exception while trying to forward " + url + ", Message: " + general.getMessage());
        } catch (IOException general) {
            logger.error("Exception while trying to forward " + url + ", Message: " + general.getMessage());
        }
    }

    protected void checkSecurity() {
    }

    protected Cookie createCookie(HttpServletRequest request) {
        boolean error = false;
        String name = (String) request.getParameter("name");
        if (name == null || name.trim().equals("")) {
            request.setAttribute("noname", "noname");
            error = true;
        }

        String value = (String) request.getParameter("value");
        if (value == null || value.trim().equals("")) {
            request.setAttribute("novalue", "novalue");
            error = true;
        }

        Cookie cookie = new Cookie(name, value);

        String maxage = request.getParameter("maxage");
        if (maxage != null && !maxage.trim().equals("")) {
            try {
                cookie.setMaxAge(Integer.parseInt(maxage));
            } catch (NumberFormatException nfe) {
                request.setAttribute("badnumber", "badnumber");
                error = true;
            }
        }

        String domain = request.getParameter("domain");
        if (domain != null && !domain.trim().equals("")) {
            cookie.setDomain(domain);
        }

        String path = request.getParameter("path");
        if (path != null && !path.trim().equals("")) {
            cookie.setPath(path);
        }

        String secure = request.getParameter("secure");
        if (secure != null && secure.equals("on")) {
            cookie.setSecure(true);
        } else {
            cookie.setSecure(false);
        }

        if (error) {
            request.setAttribute("error", "true");
            return null;
        }
        return cookie;
    }

    protected void printRequest(ArrayList reqParams) {
        DictionaryItem di = null;
        ListIterator li = reqParams.listIterator();

        while (li.hasNext()) {
            di = (DictionaryItem) li.next();
            logger.info("P NAME: " + di.getItemName() + "P VALUE: " + di.getItemValue());
        }

    }

    protected boolean requestHasNoParams(HttpServletRequest request) {
        ArrayList requestAsArray = ServletUtils.getRequestParams(request);
        return requestAsArray.size() > 0 ? false : true;
    }

    protected void forwardToServedPage(HttpServletRequest request, HttpServletResponse response) {
        forward("/main.jsp", request, response);
    }

    protected int getOpCode(String opName) {
        if ("Logout".equalsIgnoreCase(opName)) {
            return 1;
        }

        return 0;
    }

    protected String buildFromDate(HttpServletRequest theRequest) {
        String[] timeStamp = new String[6];
        String startMonth = (String) theRequest.getParameter("startMonth");
        startMonth = DateAndTimeConstants.getMonthAsNumberString(startMonth);

        timeStamp[0] = (String) theRequest.getParameter("startYear");
        timeStamp[1] = startMonth;
        timeStamp[2] = (String) theRequest.getParameter("startDay");

        timeStamp[3] = "00";
        timeStamp[4] = "00";
        timeStamp[5] = "00";

        return TimeServices.getDateAsLongString(timeStamp);
    }

    protected String buildToDate(HttpServletRequest theRequest) {
        String[] timeStamp = new String[6];
        String endMonth = (String) theRequest.getParameter("endMonth");
        endMonth = DateAndTimeConstants.getMonthAsNumberString(endMonth);

        timeStamp[0] = (String) theRequest.getParameter("endYear");
        timeStamp[1] = endMonth;
        timeStamp[2] = (String) theRequest.getParameter("endDay");
        timeStamp[3] = "60";
        timeStamp[4] = "60";
        timeStamp[5] = "60";

        return TimeServices.getDateAsLongString(timeStamp);
    }

    private void secureMenu(HttpServletRequest request, HttpServletResponse response) {
        String servletName = request.getServletPath();
        String queryString = request.getQueryString();
        String[] op;
        String url = null;
        boolean isParameter = false;
        if (queryString != null) {
            if (queryString.contains("&")) {
                isParameter = true;

            } else {
                url = servletName + "?" + queryString;
            }
        }
        logger.info(getServletInfo());

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        context = metaMgr.getContext();

        if (servletName.equals("/LogoutServlet")) {
            request.getSession().removeAttribute("loggedUser");

        } else {
            if (isParameter) {
            } else {

                BusinessOpSecurityMgr businessOpSecurityMgr = BusinessOpSecurityMgr.getInstance();

                Vector data = new Vector();
                Vector menuUrl = new Vector();

                try {
                    data = businessOpSecurityMgr.getOnArbitraryKey(groupID, "key1");
                    menuUrl = businessOpSecurityMgr.getOnArbitraryKey("1", "key1");
                    ;
                } catch (SQLException ex) {
                    java.util.logging.Logger.getLogger(swBaseServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(swBaseServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                WebBusinessObject loggedUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
                if (null == loggedUser) {
                    logger.info("no user in session  ");
                    forward("/index.jsp", request, response);
                    return;
                }
                boolean isFound = false;
                boolean action = false;
                if (data != null & !data.isEmpty()) {
                    for (int j = 0; j < menuUrl.size(); j++) {

                        WebBusinessObject wbo = new WebBusinessObject();
                        wbo = (WebBusinessObject) menuUrl.get(j);
                        if (wbo.getAttribute("fullURL").equals(url)) {
                            action = true;
                        }

                    }
                    if (action) {
                        for (int i = 0; i < data.size(); i++) {

                            WebBusinessObject wbo2 = new WebBusinessObject();
                            wbo2 = (WebBusinessObject) data.get(i);
                            String servletOp = (String) wbo2.getAttribute("fullURL");
                            if (url.equals(servletOp)) {
                                isFound = true;
                            }
                        }
//                }
                        if (isFound) {
                        } else {
                            logger.info("no user in session  ");
                            forward("/index.jsp", request, response);
                        }
                    } else {
                    }

                } else {
                    logger.info("no user in session  ");
                    forward("/index.jsp", request, response);
                }
            }
        }
    }

    public static String getClientIpAddr(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }
    
    protected void goToUnauthorized(HttpServletRequest request, HttpServletResponse response) {
        String url = "/unauthorized.jsp";
        logger.error("Exception while trying to forward " + url);
        try {
            RequestDispatcher requestDispatcher = request.getRequestDispatcher(url);
            requestDispatcher.forward(request, response);
        } catch (ServletException | IOException general) {
            logger.error("Exception while trying to forward " + url + ", Message: " + general.getMessage());
        }
    }
    
    protected void goToNotPaid(HttpServletRequest request, HttpServletResponse response) {
        String url = "/not_paid.jsp";
        logger.error("Exception while trying to forward " + url);
        try {
            RequestDispatcher requestDispatcher = request.getRequestDispatcher(url);
            requestDispatcher.forward(request, response);
        } catch (ServletException | IOException general) {
            logger.error("Exception while trying to forward " + url + ", Message: " + general.getMessage());
        }
    }
    
    protected void goToLocked(HttpServletRequest request, HttpServletResponse response) {
        String url = "/locked.jsp";
        logger.error("Exception while trying to forward " + url);
        try {
            RequestDispatcher requestDispatcher = request.getRequestDispatcher(url);
            requestDispatcher.forward(request, response);
        } catch (ServletException | IOException general) {
            logger.error("Exception while trying to forward " + url + ", Message: " + general.getMessage());
        }
    }
}
