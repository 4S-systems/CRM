package com.silkworm.telecom;

import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.RDBGateWay;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import org.asteriskjava.manager.AuthenticationFailedException;
import org.asteriskjava.manager.ManagerConnection;
import org.asteriskjava.manager.ManagerConnectionFactory;
import org.asteriskjava.manager.TimeoutException;
import org.asteriskjava.manager.action.OriginateAction;
import org.asteriskjava.manager.response.ManagerResponse;

public class TeleComGateway extends RDBGateWay {

    private static ManagerConnection managerConnection;
    private static final TeleComGateway telecomMgr = new TeleComGateway();

    public static TeleComGateway getInstance() {
        logger.info("initalizing telecommunication ............");
        ManagerConnectionFactory factory = new ManagerConnectionFactory(
                "41.131.30.220", "manager", "pa55w0rd");
        managerConnection = factory.createManagerConnection();
        return telecomMgr;
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    protected void initSupportedForm() {

        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    protected void initSupportedQueries() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
    public void callNumber(String calee, String context, String exten) throws IOException, AuthenticationFailedException,
            TimeoutException {
        OriginateAction originateAction;
        ManagerResponse originateResponse;

        originateAction = new OriginateAction();

        originateAction.setChannel(calee);
        originateAction.setContext(context);
        originateAction.setExten(exten);

        originateAction.setPriority(new Integer(1));
        originateAction.setTimeout(new Integer(30000));

        // connect to Asterisk and log in
        managerConnection.login();

        // send the originate action and wait for a maximum of 30 seconds for Asterisk
        // to send a reply
        originateResponse = managerConnection.sendAction(originateAction, 30000);

        // print out whether the originate succeeded or not
        System.out.println(originateResponse.getResponse());

        // and finally log off and disconnect
        managerConnection.logoff();
    }
}
