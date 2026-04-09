/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.crm.common;

import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author hany dev
 */
public abstract class CRMConstants {

    // alert type constant
    public static final String ALERT_TYPE_ID_ATTACH_FILE = "1";
    public static final String ALERT_TYPE_ID_ADD_COMMENT = "2";
    public static final String ALERT_TYPE_ID_FINISH_TICKET = "3";
    public static final String ALERT_TYPE_ID_CLOSE_TICKET = "4";
    public static final String ALERT_TYPE_ID_ACCEPT_TICKET = "5";
    public static final String ALERT_TYPE_ID_REJECT_TICKET = "6";
    public static final String ALERT_TYPE_ID_ADD_REVIEW_COMMENT = "7";
    public static final String ALERT_TYPE_ID_ADD_REPLAY_COMMENT = "8";
    public static final String ALERT_TYPE_ID_CONTRACT_EXPIRE = "10";
    public static final String ALERT_TYPE_ID_CREATE_SLA = "11";
    public static final String ALERT_TYPE_ID_UPDATE_SLA = "12";

    public static final String COMMENT_TYPE_ID_GENERAL = "0";
    public static final String COMMENT_TYPE_ID_SPECIAL = "1";
    public static final String COMMENT_TYPE_ID_CHANNELS = "2";
    public static final String COMMENT_TYPE_ID_GENERAL_VALUE = "PUBLIC";
    public static final String COMMENT_TYPE_ID_PROJECT_MANAGER = "-1";
    
    public static final String SALES_MARKTING_GROUP_ID = "1405767998856";
    public static final String CUSTOMER_SERVICE_GROUP_ID = "1383727324202";
    public static final String BROKER_GROUP_ID = "1449081463745";
    public static final String FINANCIAL_MANAGER_ID = "1401551044823";

    // call result project info.
    public static final String PROJECT_CALL_RESULTS_ID = "1411030488127";
    public static final String PROJECT_CALL_RESULTS_LOCATION_TYPE = "VG";

    // meeting project info
    public static final String PROJECT_METTING_ID = "1410435709807";
    public static final String PROJECT_METTING_LOCATION_TYPE = "VG";

    // all client complaint status
    public static final String CLIENT_COMPLAINT_STATUS_RECEIVED = "1";
    public static final String CLIENT_COMPLAINT_STATUS_SENT = "2";
    public static final String CLIENT_COMPLAINT_STATUS_ACKNOLEGED = "3";
    public static final String CLIENT_COMPLAINT_STATUS_ASSIGNED = "4";
    public static final String CLIENT_COMPLAINT_STATUS_REJECTED = "5";
    public static final String CLIENT_COMPLAINT_STATUS_FINISHED = "6";
    public static final String CLIENT_COMPLAINT_STATUS_CLOSED = "7";
    public static final String CLIENT_COMPLAINT_STATUS_FINISHED_NOTE = "Re-Distribution";
    
    // all issue status
    public static final String ISSUE_STATUS_ACCEPTED = "34";
    public static final String ISSUE_STATUS_REJECTED = "35";
    public static final String ISSUE_STATUS_ACCEPTED_WITH_OBSERVATION = "36";
    public static final String ISSUE_STATUS_FINAL_REJECTION = "40";
    public static final String ISSUE_STATUS_NEW = "41";

    public static final String UNIT_STATUS_AVILABLE = "8";
    public static final String UNIT_STATUS_RESERVED = "9";
    public static final String UNIT_STATUS_SOLD = "10";
    public static final String UNIT_STATUS_ONHOLD = "33";
    public static final String UNIT_STATUS_HIDE = "28";
    public static final String UNIT_STATUS_RENT = "61";

    public static final String CLIENT_STATUS_CUSTOMER = "11";
    public static final String CLIENT_STATUS_LEAD = "12";
    public static final String CLIENT_STATUS_OPPORTUNITY = "13";
    public static final String CLIENT_STATUS_CONTACT = "14";
    
    public static final String RESERVATION_STATUS_PENDING = "30";
    public static final String RESERVATION_STATUS_CONFIRM = "31";
    public static final String RESERVATION_STATUS_CANCEL = "32";
    public static final String RESERVATION_STATUS_UNDER_RETRIEVE = "42";
    public static final String RESERVATION_STATUS_RETRIEVED = "43";

    public static final String SYSTEM_AUTOMATION_ID = "-1";
    public static final String BUSINESS_OBJECT_TYPE_RESERVATION_CANCELED = "3";
    public static final String EVENT_TYPE_DELETE = "1";
    public static final String EVENT_TYPE_ATTACHED_DOCUMENT = "2";
    public static final String EVENT_TYPE_UPDATED = "3";
    public static final String EVENT_TYPE_INSERT = "4";

    // ALL APPOINTMENT STATUS 
    public static final String APPOINTMENT_STATUS_IMAGE_DEFAULT = "DEFAULT";
    public static final String APPOINTMENT_STATUS_OPEN = "23";
    public static final String APPOINTMENT_STATUS_CARED = "24";
    public static final String APPOINTMENT_STATUS_NEGLECTED = "25";
    public static final String APPOINTMENT_STATUS_DONE = "26";
    public static final String APPOINTMENT_STATUS_NOT_COMPLETE = "27";
    public static final String APPOINTMENT_STATUS_DIRECT_FOLLOW_UP = "29";
    public static final Map<String, String> APPOINTMENT_STATUS_IMAGES = new HashMap<String, String>();

    static {
        APPOINTMENT_STATUS_IMAGES.put(APPOINTMENT_STATUS_DONE, "star.png");
        APPOINTMENT_STATUS_IMAGES.put(APPOINTMENT_STATUS_OPEN, "calendar_circle_yellow.png");
        APPOINTMENT_STATUS_IMAGES.put(APPOINTMENT_STATUS_CARED, "calendar_circle_green.png");
        APPOINTMENT_STATUS_IMAGES.put(APPOINTMENT_STATUS_NEGLECTED, "calendar_circle_red.png");
        APPOINTMENT_STATUS_IMAGES.put(APPOINTMENT_STATUS_DIRECT_FOLLOW_UP, "calendar_circle_blue.png");
        APPOINTMENT_STATUS_IMAGES.put(APPOINTMENT_STATUS_IMAGE_DEFAULT, "calendar_circle_gray.png");
    }

    // ALL CLIENT COMPLAINT TYPES
    public static final String CLIENT_COMPLAINT_TYPE_COMPLAINT = "1";
    public static final String CLIENT_COMPLAINT_TYPE_ORDER = "2";
    public static final String CLIENT_COMPLAINT_TYPE_QUERY = "3";
    public static final String CLIENT_COMPLAINT_TYPE_SERVICE = "4";
    public static final String CLIENT_COMPLAINT_TYPE_EXTRACT = "5";
    public static final String CLIENT_COMPLAINT_TYPE_REQUEST_EXTRADITION = "6";
    public static final String CLIENT_COMPLAINT_TYPE_REQUEST_FINANCIAL = "7";
    public static final String CLIENT_COMPLAINT_TYPE_REQUEST_PAYMENT = "8";
    public static final String CLIENT_COMPLAINT_TYPE_CLIENT_VISIT = "9";
    public static final String CLIENT_COMPLAINT_TYPE_DELIVERY_OF_QUALITY = "10";
    public static final String CLIENT_COMPLAINT_TYPE_DELIVERY_SUCCESSFUL = "11";
    public static final String CLIENT_COMPLAINT_TYPE_JOB_ORDER = "12";
    public static final String CLIENT_COMPLAINT_TYPE_RE_REQUEST_EXTRADITION = "18";
    public static final String CLIENT_COMPLAINT_TYPE_PROCUREMENT = "23";
    public static final String CLIENT_COMPLAINT_TYPE_CALL = "24";
    public static final String CLIENT_COMPLAINT_TYPE_CLIENT_REQUEST = "25";

    // all object type
    public static final String OBJECT_TYPE_CLIENT_COMPLAINT = "client_complaint";
    public static final String OBJECT_TYPE_ISSUE = "issue";
    public static final String OBJECT_TYPE_CLIENT = "client";
    public static final String OBJECT_TYPE_USER = "User";
    public static final String OBJECT_TYPE_UNIT = "Housing_Units";
    public static final String OBJECT_TYPE_PROJECT = "Project";
    public static final String OBJECT_TYPE_EMPLOYEE = "employee";
    
    // project category
    public static final String PROJECT_LOCATION_TYPE_REQUEST_ITEM = "REQ-ITEM";
    public static final String PROJECT_LOCATION_TYPE_SPARE_ITEM = "spare_part";
    public static final String PROJECT_LOCATION_TYPE_STORE_TRANSACTION = "store_transaction";

    // selected tab parameter names
    public static final String SELECTED_TAB_CALL_CENTER_KEY = "call-center";
    public static final String SELECTED_TAB_PROJECT_MANAGER_KEY = "project-manager";
    public static final String SELECTED_TAB_SALES_MARKET_KEY = "sales-market";
    public static final String SELECTED_TAB_MANAGER_AGENDA_KEY = "manager-agenda";
    public static final String SELECTED_TAB_EMPLOYEE_AGENDA_KEY = "employee-agenda";
    public static final String SELECTED_TAB_MANAGER_MONITOR_AGENDA_KEY = "manager-monitor-agenda";
    public static final String SELECTED_TAB_NOTIFICATION_SYSTEM_KEY = "notification-system";
    public static final String SELECTED_TAB_CONTRACTS_KEY = "contracts";
    public static final String SELECTED_TAB_GENERAL_TASK_KEY = "general_task";
    public static final String SELECTED_TAB_SLA_KEY = "sla";
    public static final String SELECTED_TAB_NON_DISTRIBUTED = "non_distributed";
    public static final String SELECTED_TAB_GENERAL_COMPLAINT_KEY = "general_complaint";
    public static final String SELECTED_TAB_GENERIC_CONTRACTS_KEY = "generic-contracts";
    public static final String SELECTED_TAB_EMPLOYEE_SHEET = "EmployeeSheet";


    // some important departments ids
    public static final String DEPARTMENT_PROJECT_MANAGER_ID = "1365238791104";
    public static final String DEPARTMENT_QUALITY_MANAGEMENT_ID = "1363767764429";
    public static final String DEPARTMENT_SALES_ID = "1363695979606";
    public static final String PROJECT_TYPE_BRANCH_ID = "1365240752318";
    public static final String DEPARTMENT_CALL_CENTER_ID = "1363767379185";
    public static final String DEPARTMENT_FINANCES_ID = "1363767702341";
    public static final String DEPARTMENT_PROCUREMENT = "1472297193074";

    // call center mode values
    public static final String CALL_CENTER_INBOUND_CALL = "2";
    public static final String CALL_CENTER_OUTBOUND_CALL = "3";
    public static final String CALL_CENTER_INBOUND_VISIT = "4";
    public static final String CALL_CENTER_OUTBOUND_VISIT = "5";
    public static final String CALL_CENTER_INBOUND_INTERNET = "6";
    
    public static final String FINANCE_REQUEST_TITLE = "محضر استلام";
    public static final String NOTES_REVISION_TITLE = "مراجعة ملاحظات";
    
    public static final String PERIOD_DEFAULT_VALUE = "سنه";
    public static final String PAYMENT_TYPE_DEFAULT_VALUE = "نقدى";

    public static String parseCallCenter(String callCenter) {
        String value = "***";
        if (CALL_CENTER_INBOUND_CALL.equalsIgnoreCase(callCenter)) {
            value = "InBound Call";
        } else if (CALL_CENTER_OUTBOUND_CALL.equalsIgnoreCase(callCenter)) {
            value = "OutBound Call";
        } else if (CALL_CENTER_INBOUND_VISIT.equalsIgnoreCase(callCenter)) {
            value = "InBound Visit";
        } else if (CALL_CENTER_OUTBOUND_VISIT.equalsIgnoreCase(callCenter)) {
            value = "OutBound Visit";
        } else if (CALL_CENTER_INBOUND_INTERNET.equalsIgnoreCase(callCenter)) {
            value = "InBound Internet";
        }
        return value;
    }

    // Freeze Head Bar values
    public static final String FREEZE_HEAD_BAR_YES = "1";
    public static final String FREEZE_HEAD_BAR_NO = "0";

    // RUN_ON_AUTO_PILOT_ELEMENT
    public static final String RUN_ON_AUTO_PILOT_YES = "1";
    public static final String RUN_ON_AUTO_PILOT_NO = "0";
    
    // REQUEST_ITEM
    public static final String REQUEST_ITEM_ACCEPTED = "1";
    public static final String REQUEST_ITEM_NOT_ACCEPTED = "0";
    public static final String REQUEST_ITEM_ACCEPTED_WITH_NOTES = "2";

    // Call Result Conclusion
    public static final String CALL_RESULT_CALL = "call"; // means internet in appointment pop-up
    public static final String CALL_RESULT_INTERESTED = "Interested";
      public static final String CALL_RESULT_OTHER_DATE="1494928254928";
    public static final String CALL_RESULT_INBOUNDCALL = "inboundcall";
    public static final String CALL_RESULT_OUTBOUNDCALL = "outbouncall";
    public static final String CALL_RESULT_NIGHTCALL = "nightcall";
    public static final String CALL_RESULT_INTERNET = "internet";
    public static final String CALL_RESULT_MEETING = "meeting";
    public static final String CALL_RESULT_TS_MEETING = "ts-meeting";
    public static final String CALL_RESULT_SLS_MEETING = "sls-meeting";
    public static final String CALL_RESULT_BKR_MEETING = "bkr-meeting";
    public static final String CALL_RESULT_FOLLOWUP = "follow";
    public static final String CALL_RESULT_FAIL = "not-response";
    public static final String CALL_RESULT_JOB_ORDER = "job-order";
    public static final String CALL_RESULT_NO_ACTION = "no-action";
    public static final String CALL_RESULT_VISIT = "visit";
    public static final String CALL_RESULT_DIRECT_VISIT = "direct-visit";
    
    public static final int ISSUE_NUMBER_OF_COMMENTS = 3;
    
    // Quartz Configuration
    public static final String QUARTZ_OBJECT_TYPE_CLIENT_COMPLAINT = "Client Complaint";
    public static final String QUARTZ_ACTION_CLIENT_COMPLAINT_CLOSED = "Closed Client Complaint";
    public static final String QUARTZ_ACTION_STATUS_RUNNING = "1";
    public static final String QUARTZ_ACTION_STATUS_NOT_RUNNING = "0";
    
    // some trade importance
    public static final String TRADE_TECHOFFICE_ID = "1423412128276";
    
    // Notification Status
    public static final String NOTIFICATION_UNREAD = "37";
    public static final String NOTIFICATION_READ = "38";
    public static final String NOTIFICATION_ACTION = "39";
    
    public static final String PROJECTS_ID = "1364111290870";
    
    public static final String TRADE_FIELD_TECHNICIAN_ID = "1422947377016";
    
    public static final String AMR_KASRAWY_ID = "1401524070443";
    public static final String QUALITY_MANAGER_ID = "1401524070443";
    
    // all calling plan status
    public static final String CALLING_PLAN_STATUS_PLANNED = "44";
    public static final String CALLING_PLAN_STATUS_EXECUTED = "45";
    public static final String CALLING_PLAN_STATUS_CANCELED = "46";
    
    // all quality plan status
    public static final String QUALITY_PLAN_STATUS_PLANNED = "47";
    public static final String QUALITY_PLAN_STATUS_EXECUTED = "48";
    public static final String QUALITY_PLAN_STATUS_CANCELED = "49";
    
    // all spare part status
    public static final String SPARE_ITEM_REQUESTED = "50";
    public static final String SPARE_ITEM_UNAVAILABLE = "51";
    public static final String SPARE_ITEM_IN_THE_WAY = "52";
    public static final String SPARE_ITEM_DELIVERED = "53";
    public static final String SPARE_ITEM_NEGOTIATED = "54";
    public static final String SPARE_ITEM_PAID = "55";
    public static final String SPARE_ITEM_PENDING = "56";
    public static final String SPARE_ITEM_CANCELED = "57";
    
    // all store transaction status
    public static final String STORE_TRANSACTION_PENDING = "58";
    public static final String STORE_TRANSACTION_CANCELED = "59";
    public static final String STORE_TRANSACTION_CONFIRMED = "60";
    
    // store transaction type
    public static final String STORE_TRANSACTION_TYPE_ADD = "1";
    public static final String STORE_TRANSACTION_TYPE_WITHDRAW = "2";
    public static final String STORE_TRANSACTION_TYPE_DISCARD = "3";
    
    // transaction method
    public static final String TRANSACTION_METHOD_OVERLAND = "1";
    public static final String TRANSACTION_METHOD_NAVAL = "2";
    public static final String TRANSACTION_METHOD_AERIAL = "3";
    
    public static final String COMPANY_CLIENT_ID = "1";
    public static final String OWNERS_ASSOCIATION_CLIENT_ID = "2";
    
    public static final String CLIENT_RATE_FOLLOWUP_ID = "1485593353193";
    public static final String CLIENT_RATE_CLOSED_ID = "1485593332865";
    public static final String CLIENT_RATE_NOT_INTERESTED_ID = "1485582767351";
    public static final String CLIENT_RATE_OUT_OF_SEGMENT_ID = "1485582599408";
    
    public static final String DOCUMENT_TYPE_PERSONAL_PHOTO_ID = "2";
    
    // for contract schedule's statuses
    public static final String SCHEDULE_STATUS_SCHEDULED = "76";
    public static final String SCHEDULE_STATUS_DONE = "77";
    public static final String SCHEDULE_STATUS_CANCELED = "78";
    
    public static final String CUSTOMER_REFERRAL_CAMPAIGN_ID = "1530370227288";
    
    // payment details status
    public static final String PAYMENT_DETAILS_DONE = "done";
    public static final String PAYMENT_DETAILS_PARTIAL = "partial";
    public static final String PAYMENT_DETAILS_PENDING = "pending";
    public static final String PAYMENT_DETAILS_DELAYED = "delayed";
    
    //Add-on ID
    
}
