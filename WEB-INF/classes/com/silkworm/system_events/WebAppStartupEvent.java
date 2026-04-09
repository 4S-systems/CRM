package com.silkworm.system_events;

import com.maintenance.common.ParseSideMenu;
import static com.maintenance.common.Tools.getFileSeparator;
import javax.servlet.ServletContextListener;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import com.silkworm.common.*;
import java.util.Hashtable;

public abstract class WebAppStartupEvent implements ServletContextListener {

    protected ServletContext swAppContext;
    protected ServletContext servletContext;
    protected String webInfPath = null;
    protected String imageDirPath = null;
    protected String[] sys_paths = new String[2];

    protected abstract void getAppParams();

    protected abstract void startTimer();

    protected abstract boolean initDBGateways();

    @Override
    public void contextInitialized(ServletContextEvent event) {
        servletContext = event.getServletContext();
        swAppContext = event.getServletContext();
        sys_paths[0] = servletContext.getRealPath("/WEB-INF");
        sys_paths[1] = servletContext.getRealPath("/images");

        getAppParams();
        startRegistry();
        startTimer();

        //open Jar File to set logos and root path in meta data mgr
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        metaMgr.setMetaData("xfile.jar");
        ParseSideMenu parseSideMenu = new ParseSideMenu();
        Hashtable logos;
        logos = parseSideMenu.getCompanyLogo("configration" + metaMgr.getCompanyName() + ".xml");
        metaMgr.setLogos(logos);
        metaMgr.setRealReportsPath(servletContext.getRealPath(getFileSeparator()));
    }

    @Override
    public void contextDestroyed(ServletContextEvent event) {
    }

    protected void setInitialAttribute(ServletContext context, String initParamName, String defaultValue) {
    }

    protected void startRegistry() {
        ApplicationSessionRegistery applicationUserRegistery = ApplicationSessionRegistery.getInstance();
        servletContext.setAttribute("registry", applicationUserRegistery);
        swAppContext.setAttribute("registry", applicationUserRegistery);
    }
}
