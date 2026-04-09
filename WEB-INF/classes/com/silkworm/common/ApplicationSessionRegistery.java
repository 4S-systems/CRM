/*
 * ApplicationUserRegistery.java
 *
 * Created on December 20, 2003, 3:42 PM
 */
package com.silkworm.common;

/**
 *
 * @author walid
 */
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Objects;
import javax.servlet.http.HttpSession;
import org.apache.log4j.Logger;

public class ApplicationSessionRegistery {

    /**
     * Creates a new instance of ApplicationSessionRegistery
     */
    private static final ApplicationSessionRegistery APPLICATION_REGISTERY = new ApplicationSessionRegistery();
    private final List<SessionRegistery> sessions = new ArrayList<SessionRegistery>();
    private final Logger logger = Logger.getLogger(ApplicationSessionRegistery.class);

    private ApplicationSessionRegistery() {

    }

    public static ApplicationSessionRegistery getInstance() {
        System.out.println("Getting ApplicationSessionRegistery Instance ....");
        return APPLICATION_REGISTERY;
    }

    public List<SessionRegistery> getSessions() {
        return sessions;
    }

    public boolean isAtLimit() {
        return (sessions.size() > 99);
    }

    public synchronized boolean addSession(HttpSession session, String loggedInMachine) {
        if (!exists(session.getId())) {
            logger.info("Try Add Session To Registery: ");
            logger.info(session);
            return sessions.add(new SessionRegistery(session, loggedInMachine));
        }
        return false;
    }

    public synchronized SessionRegistery getSession(String sessionId) {
        for (SessionRegistery session : sessions) {
            if (session.getId().equalsIgnoreCase(sessionId)) {
                return session;
            }
        }
        return null;
    }

    public synchronized SessionRegistery getSession(String username, String password) {
        for (SessionRegistery session : sessions) {
            if (session.equalsUsernameAndPassword(username, password)) {
                return session;
            }
        }
        return null;
    }

    public synchronized void setLastActionDate(String sessionId) {
        SessionRegistery session = getSession(sessionId);
        if (session != null) {
            session.setLastActionDate(Calendar.getInstance().getTime());
        }
    }

    public synchronized void setLastVisitedUrl(String sessionId, String url) {
        SessionRegistery session = getSession(sessionId);
        if (session != null) {
            session.setLastVisitedUrl(url);
        }
    }

    public synchronized AuthenticationType authentication(String sessionId, String username, String password) {
        SessionRegistery session = getSession(sessionId);
        if (session != null) {
            if (session.equalsUsernameAndPassword(username, password)) {
                return AuthenticationType.AlreadyLogin;
            }
            return AuthenticationType.ExistsAnotherUser;
        }
        
        // try close other session if exist
        closeSession(getSession(username, password), true);
        return AuthenticationType.NotExistsEveryBody;
    }

    public synchronized boolean exists(String sessionId) {
        return getSession(sessionId) != null;
    }

    public synchronized boolean exists(String username, String password) {
        return getSession(username, password) != null;
    }

    public synchronized boolean exists(String sessionId, String username, String password) {
        SessionRegistery session = getSession(sessionId);
        return (session != null) && session.equalsUsernameAndPassword(username, password);
    }

    public synchronized boolean closeSession(String sessionId, boolean invalidate) {
        SessionRegistery session = getSession(sessionId);
        return closeSession(session, invalidate);
    }

    public synchronized boolean closeSession(SessionRegistery session, boolean invalidate) {
        if (session != null) {
            logger.info("Try Closed Session From Registery");
            sessions.remove(session);
            logger.info("Remove Session From Registery: ");
            logger.info(session);
            String attributeName;
            while (session.getSession().getAttributeNames().hasMoreElements()) {
                attributeName = session.getSession().getAttributeNames().nextElement();
                session.getSession().removeAttribute(attributeName);
            }
            try {
                if (invalidate) {
                    session.getSession().invalidate();
                }
            } catch (Exception ex) {
                logger.error(ex);
                return false;
            }
        }
        return true;
    }

    public void print() {
        StringBuilder builder = new StringBuilder();
        for (SessionRegistery session : sessions) {
            builder.append(session);
            builder.append("\n-----------------------");
        }
        System.out.println(builder.toString());
    }

    public class SessionRegistery {

        private String id;
        private HttpSession session;
        private SecurityUser securityUser;
        private String loggedInMachine;
        private String lastVisitedUrl;
        private Date loggedInDate;
        private Date lastActionDate;

        public SessionRegistery(HttpSession session, String loggedInMachine) {
            this(session, loggedInMachine, Calendar.getInstance().getTime(), Calendar.getInstance().getTime(), "");
        }

        public SessionRegistery(HttpSession session, String loggedInMachine, Date loggedInDate, Date lastActionDate, String lastVisitedUrl) {
            this.id = session.getId();
            this.session = session;
            this.securityUser = (SecurityUser) session.getAttribute("securityUser");
            this.loggedInMachine = loggedInMachine;
            this.lastVisitedUrl = lastVisitedUrl;
            this.loggedInDate = loggedInDate;
            this.lastActionDate = lastActionDate;
        }

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public HttpSession getSession() {
            return session;
        }

        public void setSession(HttpSession session) {
            this.session = session;
        }

        public SecurityUser getLoggedInUser() {
            return (securityUser != null) ? securityUser : (SecurityUser) session.getAttribute("securityUser");
        }

        public void setSecurityUser(SecurityUser securityUser) {
            this.securityUser = securityUser;
        }

        public String getLoggedInMachine() {
            return loggedInMachine;
        }

        public void setLoggedInMachine(String loggedInMachine) {
            this.loggedInMachine = loggedInMachine;
        }

        public String getLastVisitedUrl() {
            return lastVisitedUrl;
        }

        public void setLastVisitedUrl(String lastVisitedUrl) {
            this.lastVisitedUrl = lastVisitedUrl;
        }

        public Date getLoggedInDate() {
            return loggedInDate;
        }

        public void setLoggedInDate(Date loggedInDate) {
            this.loggedInDate = loggedInDate;
        }

        public Date getLastActionDate() {
            return lastActionDate;
        }

        public void setLastActionDate(Date lastActionDate) {
            this.lastActionDate = lastActionDate;
        }

        public boolean equalsUsernameAndPassword(String username, String password) {
            return securityUser.getUserName().equals(username) && securityUser.getUserPassword().equals(password);
        }

        @Override
        public boolean equals(Object object) {
            return (object instanceof SessionRegistery) && this.getId().equalsIgnoreCase(((SessionRegistery) object).getId());
        }

        @Override
        public int hashCode() {
            int hash = Objects.hashCode(this.id);
            return hash;
        }

        @Override
        public String toString() {
            StringBuilder builder = new StringBuilder();
            builder.append("Session ID: ").append(id);
            builder.append("\n\t").append("Logged User: ").append((getLoggedInUser() != null) ? getLoggedInUser().getFullName() : "N/A");
            builder.append("\n\t").append("LoggedIn From Machine: ").append(loggedInMachine);
            builder.append("\n\t").append("Last Visited Url: ").append(lastVisitedUrl);
            builder.append("\n\t").append("LoggedIn Date: ").append(loggedInDate);
            builder.append("\n\t").append("Last Action Date: ").append(lastActionDate);
            builder.append("\n");
            return builder.toString(); //To change body of generated methods, choose Tools | Templates.
        }
    }

    public enum AuthenticationType {

        ExistsAnotherUser, AlreadyLogin, NotExistsEveryBody, InvalidUserOrPassword, SessionsLimits;
    }
}
