package com.maintenance.db_access;

import com.silkworm.common.MetaDataMgr;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import org.apache.commons.io.IOUtils;

public class WebServiceMgr {

    private static final WebServiceMgr soapMgr = new WebServiceMgr();
    private static final MetaDataMgr metaData = MetaDataMgr.getInstance();
    private static final String URL = metaData.getWebServiceUrl();

    public WebServiceMgr() {
    }

    public static WebServiceMgr getInstance() {
        return soapMgr;
    }

    public ClientApplication getClientAuthorityByWebService(String methodPath) {
        try {
            URL url = new URL(URL + "clients/" + methodPath);
            HttpURLConnection connection
                    = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setRequestProperty("Accept", "application/xml");

            JAXBContext jc = JAXBContext.newInstance(ClientApplication.class);
            InputStream xml = connection.getInputStream();
            String result = IOUtils.toString(xml, StandardCharsets.UTF_8);
            ClientApplication application
                    = (ClientApplication) jc.createUnmarshaller().unmarshal(IOUtils.toInputStream(result, "UTF-8"));
            connection.disconnect();
            return application;
        } catch (MalformedURLException ex) {
            Logger.getLogger(WebServiceMgr.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException | JAXBException ex) {
            Logger.getLogger(WebServiceMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
}
