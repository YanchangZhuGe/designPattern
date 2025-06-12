package com.bgp.mcs.service.pm.service.common;

import java.net.URL;

import org.apache.cxf.binding.soap.saaj.SAAJInInterceptor;
import org.apache.cxf.binding.soap.saaj.SAAJOutInterceptor;
import org.apache.cxf.endpoint.Client;
import org.apache.cxf.frontend.ClientProxy;
import org.apache.cxf.interceptor.LoggingInInterceptor;
import org.apache.cxf.interceptor.LoggingOutInterceptor;

import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.primavera.ws.p6.activity.ActivityPortType;
import com.primavera.ws.p6.activity.ActivityService;
import com.primavera.ws.p6.activitycode.ActivityCodePortType;
import com.primavera.ws.p6.activitycode.ActivityCodeService;
import com.primavera.ws.p6.activitycodeassignment.ActivityCodeAssignmentPortType;
import com.primavera.ws.p6.activitycodeassignment.ActivityCodeAssignmentService;
import com.primavera.ws.p6.activitycodetype.ActivityCodeTypePortType;
import com.primavera.ws.p6.activitycodetype.ActivityCodeTypeService;
import com.primavera.ws.p6.activitystep.ActivityStepPortType;
import com.primavera.ws.p6.activitystep.ActivityStepService;
import com.primavera.ws.p6.baselineproject.BaselineProjectPortType;
import com.primavera.ws.p6.baselineproject.BaselineProjectService;
import com.primavera.ws.p6.calendar.CalendarPortType;
import com.primavera.ws.p6.calendar.CalendarService;
import com.primavera.ws.p6.project.ProjectPortType;
import com.primavera.ws.p6.project.ProjectService;
import com.primavera.ws.p6.projectcodeassignment.ProjectCodeAssignmentPortType;
import com.primavera.ws.p6.projectcodeassignment.ProjectCodeAssignmentService;
import com.primavera.ws.p6.relationship.RelationshipPortType;
import com.primavera.ws.p6.relationship.RelationshipService;
import com.primavera.ws.p6.resource.ResourcePortType;
import com.primavera.ws.p6.resource.ResourceService;
import com.primavera.ws.p6.resourceassignment.ResourceAssignmentPortType;
import com.primavera.ws.p6.resourceassignment.ResourceAssignmentService;
import com.primavera.ws.p6.resourcecode.ResourceCodePortType;
import com.primavera.ws.p6.resourcecode.ResourceCodeService;
import com.primavera.ws.p6.resourcecodetype.ResourceCodeTypePortType;
import com.primavera.ws.p6.resourcecodetype.ResourceCodeTypeService;
import com.primavera.ws.p6.resourcerate.ResourceRatePortType;
import com.primavera.ws.p6.resourcerate.ResourceRateService;
import com.primavera.ws.p6.udfcode.UDFCodePortType;
import com.primavera.ws.p6.udfcode.UDFCodeService;
import com.primavera.ws.p6.udftype.UDFTypePortType;
import com.primavera.ws.p6.udftype.UDFTypeService;
import com.primavera.ws.p6.udfvalue.UDFValuePortType;
import com.primavera.ws.p6.udfvalue.UDFValueService;
import com.primavera.ws.p6.user.UserPortType;
import com.primavera.ws.p6.user.UserService;
import com.primavera.ws.p6.userlicense.UserLicensePortType;
import com.primavera.ws.p6.userlicense.UserLicenseService;
import com.primavera.ws.p6.userobs.UserOBSPortType;
import com.primavera.ws.p6.userobs.UserOBSService;
import com.primavera.ws.p6.wbs.WBSPortType;
import com.primavera.ws.p6.wbs.WBSService;

public class P6WSPortTypeFactory {


	private ILog log;
    
    private static String P6_WS_URL;
    
    private static final String RESOURCE_SERVICE = "/p6ws/services/ResourceService?wsdl";//��Դ
    private static final String RESOURCE_ASSIGNMENT_SERVICE = "/p6ws/services/ResourceAssignmentService?wsdl";//��Դ����
    private static final String RESOURCE_CODE_SERVICE = "/p6ws/services/ResourceCodeService?wsdl";//��Դ������
    private static final String RESOURCE_CODE_TYPE_SERVICE = "/p6ws/services/ResourceCodeTypeService?wsdl";//��Դ���������
    
    private static final String USER_SERVICE = "/p6ws/services/UserService?wsdl";
    private static final String USER_OBS_SERVICE = "/p6ws/services/UserOBSService?wsdl";
    private static final String USER_LICENSE_SERVICE = "/p6ws/services/UserLicenseService?wsdl";
    private static final String PROJECT_SERVICE = "/p6ws/services/ProjectService?wsdl";//��Ŀ
    private static final String WBS_SERVICE = "/p6ws/services/WBSService?wsdl";//wbs
    private static final String RESOURCE_RATE_SERVICE = "/p6ws/services/ResourceRateService?wsdl";
    
    private static final String Activity_Service = "/p6ws/services/ActivityService?wsdl";//��ҵ
    private static final String Activity_Code_Assignment_Service = "/p6ws/services/ActivityCodeAssignmentService?wsdl";//��ҵ����
    private static final String Activity_Code_Service = "/p6ws/services/ActivityCodeService?wsdl";//��ҵ������ֵ
    private static final String Activity_Code_Type_Service = "/p6ws/services/ActivityCodeTypeService?wsdl";//��ҵ����
    private static final String Activity_Step_Service="/p6ws/services/ActivityStepService?wsdl";//��ҵ����
    private static final String Project_Code_Assignment_Service = "/p6ws/services/ProjectCodeAssignmentService?wsdl";//��Ŀ�������Ӧ��
    
    private static final String Relationship_Service = "/p6ws/services/RelationshipService?wsdl";//��ҵ��ϵ
    
    private static final String Calendar_Service = "/p6ws/services/CalendarService?wsdl";//����
    
    //p6�Զ����ֶ�
    private static final String UDFCode_Service = "/p6ws/services/UDFCodeService?wsdl";
    private static final String UDFType_Service = "/p6ws/services/UDFTypeService?wsdl";
    private static final String UDFValue_Service = "/p6ws/services/UDFValueService?wsdl";
    
    private static final String BaselineProject_Service = "/p6ws/services/BaselineProjectService?wsdl";//������Ŀ

    static{

        ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
        P6_WS_URL = cfgHd.getSingleNodeValue("//p6/p6_ws_url");
    }
    
    public P6WSPortTypeFactory()
    {
        log = LogFactory.getLogger(P6WSPortTypeFactory.class);
        
    }

    @SuppressWarnings("unchecked")
	public static <T> T getPortType(Class T, UserToken mcsUser) throws Exception{
    	P6WSUser p6WSUser;
    	if(mcsUser==null){
    		p6WSUser = P6WSUser.DEFAULT_USER;
    	}else{
    		p6WSUser = new P6WSUser(mcsUser.getLoginId(),mcsUser.getUserPwd());
    	}
    	
    	if(T.getName().indexOf("ResourcePortType")>0){
    		return (T)createResourceServicePort(p6WSUser);
    	}  else if(T.getName().indexOf("BaselineProjectPortType")>0){
    		return (T)createBaselineProjectServicePort(p6WSUser);
    	} else if(T.getName().indexOf("UserPortType")>0){
    		return (T)createUserServicePort(p6WSUser);
    	} else if(T.getName().indexOf("UserOBSPortType")>0){
    		return (T)createUserOBSServicePort(p6WSUser);
    	} else if(T.getName().indexOf("UserLicensePortType")>0){
    		return (T)createUserLicenseServicePort(p6WSUser);
    	} else if(T.getName().indexOf("ProjectPortType")>0){
    		return (T)createProjectServicePort(p6WSUser);
    	} else if(T.getName().indexOf("WBSPortType")>0){
    		return (T)createWbsServicePort(p6WSUser);
    	} else if(T.getName().indexOf("ActivityPortType")>0){
    		return (T)createActivityServicePort(p6WSUser);
    	} else if(T.getName().indexOf("ActivityCodeAssignmentPortType")>0){
    		return (T)createActivityCodeAssignmentServicePort(p6WSUser);
    	} else if(T.getName().indexOf("ActivityCodeAssignmentPortType")>0){
    		return (T)createActivityCodeAssignmentServicePort(p6WSUser);
    	} else if(T.getName().indexOf("ActivityCodePortType")>0){
    		return (T)createActivityCodeServicePort(p6WSUser);
    	} else if(T.getName().indexOf("ActivityCodeTypePortType")>0){
    		return (T)createActivityCodeTypeServicePort(p6WSUser);
    	} else if(T.getName().indexOf("ResourceAssignmentPortType")>0){
    		return (T)createResourceAssignmentServicePort(p6WSUser);
    	} else if(T.getName().indexOf("ResourceRatePortType")>0){
    		return (T)createResourceRateServicePort(p6WSUser);
    	} else if(T.getName().indexOf("ResourceCodePortType")>0){
    		return (T)createResourceCodeServicePort(p6WSUser);
    	} else if(T.getName().indexOf("ResourceCodeTypePortType")>0){
    		return (T)createResourceCodeTypeServicePort(p6WSUser);
    	} else if(T.getName().indexOf("ActivityStepPortType")>0){
    		return (T)createActivityStepServicePort(p6WSUser);
    	} else if(T.getName().indexOf("CalendarPortType")>0){
    		return (T)createCalendarServicePort(p6WSUser);
    	} else if(T.getName().indexOf("ProjectCodeAssignmentPortType")>0){
    		return (T)createProjectCodeAssignmentServicePort(p6WSUser);
    	} else if(T.getName().indexOf("UDFCodePortType")>0){
    		return (T)createUDFCodeServicePort(p6WSUser);
    	} else if(T.getName().indexOf("UDFTypePortType")>0){
    		return (T)createUDFTypeServicePort(p6WSUser);
    	} else if(T.getName().indexOf("UDFValuePortType")>0){
    		return (T)createUDFValueServicePort(p6WSUser);
    	} else if(T.getName().indexOf("RelationshipPortType")>0){
    		return (T)createRelationshipServicePort(p6WSUser);
    	}
    	
    	return null;
    }
    
    /**
     * ������Դ�����Port
     * @param p6WSUser
     * @return
     * @throws Exception
     */
    private static ResourcePortType createResourceServicePort(P6WSUser p6WSUser)
      throws Exception
    {
        String url = makeHttpURLString(RESOURCE_SERVICE);
        URL wsdlURL = new URL(url);
        ResourceService service = new ResourceService(wsdlURL);
        ResourcePortType servicePort = service.getResourcePort();
        Client client = ClientProxy.getClient(servicePort);
        setUserTokenData(client, p6WSUser);

        return servicePort;
    }

    /**
     * �����û������Port
     * @param p6WSUser
     * @return
     * @throws Exception
     */
    private static UserPortType createUserServicePort(P6WSUser p6WSUser)
      throws Exception
    {
        String url = makeHttpURLString(USER_SERVICE);
        URL wsdlURL = new URL(url);
        UserService service = new UserService(wsdlURL);
        UserPortType servicePort = service.getUserPort();
        Client client = ClientProxy.getClient(servicePort);
        setUserTokenData(client, p6WSUser);

        return servicePort;
    }

    /**
     * �����û�OBS�����Port
     * @param p6WSUser
     * @return
     * @throws Exception
     */
    private static UserOBSPortType createUserOBSServicePort(P6WSUser p6WSUser)
      throws Exception
    {
        String url = makeHttpURLString(USER_OBS_SERVICE);
        URL wsdlURL = new URL(url);
        UserOBSService service = new UserOBSService(wsdlURL);
        UserOBSPortType servicePort = service.getUserOBSPort();
        Client client = ClientProxy.getClient(servicePort);
        setUserTokenData(client, p6WSUser);

        return servicePort;
    }

    /**
     * �����û�ģ���ȡ���������Port
     * @param p6WSUser
     * @return
     * @throws Exception
     */
    private static UserLicensePortType createUserLicenseServicePort(P6WSUser p6WSUser)
      throws Exception
    {
        String url = makeHttpURLString(USER_LICENSE_SERVICE);
        URL wsdlURL = new URL(url);
        UserLicenseService service = new UserLicenseService(wsdlURL);
        UserLicensePortType servicePort = service.getUserLicensePort();
        Client client = ClientProxy.getClient(servicePort);
        setUserTokenData(client, p6WSUser);

        return servicePort;
    }
    /**
     * ������Ŀ�����Port
     * @param p6WSUser
     * @return
     * @throws Exception
     * ������ 2011 Nov 29
     */
    private static ProjectPortType createProjectServicePort(P6WSUser p6WSUser)
      throws Exception
    {
        String url = makeHttpURLString(PROJECT_SERVICE);
        URL wsdlURL = new URL(url);
        ProjectService service = new ProjectService(wsdlURL);
        ProjectPortType servicePort = service.getProjectPort();
        Client client = ClientProxy.getClient(servicePort);
        setUserTokenData(client, p6WSUser);

        return servicePort;
    }
    
    /**
     * ����wbs�����Port
     * @param p6WSUser
     * @return
     * @throws Exception
     */
    private static WBSPortType createWbsServicePort(P6WSUser p6WSUser)
      throws Exception
    {
        String url = makeHttpURLString(WBS_SERVICE);
        URL wsdlURL = new URL(url);
        WBSService service = new WBSService(wsdlURL);
        WBSPortType servicePort = service.getWBSPort();
        Client client = ClientProxy.getClient(servicePort);
        setUserTokenData(client, p6WSUser);

        return servicePort;
    }
    
    /**
     * ������ҵ�����Port
     * @param p6WSUser
     * @return
     * @throws Exception
     */
    private static ActivityPortType createActivityServicePort(P6WSUser p6WSUser)
      throws Exception
    {
        String url = makeHttpURLString(Activity_Service);
        URL wsdlURL = new URL(url);
        ActivityService service = new ActivityService(wsdlURL);
        ActivityPortType servicePort = service.getActivityPort();
        Client client = ClientProxy.getClient(servicePort);
        setUserTokenData(client, p6WSUser);

        return servicePort;
    }
    
    /**
     * ������ҵ��������Port
     * @param p6WSUser
     * @return
     * @throws Exception
     */
    private static ActivityCodeAssignmentPortType createActivityCodeAssignmentServicePort(P6WSUser p6WSUser)
      throws Exception
    {
        String url = makeHttpURLString(Activity_Code_Assignment_Service);
        URL wsdlURL = new URL(url);
        ActivityCodeAssignmentService service = new ActivityCodeAssignmentService(wsdlURL);
        ActivityCodeAssignmentPortType servicePort = service.getActivityCodeAssignmentPort();
        Client client = ClientProxy.getClient(servicePort);
        setUserTokenData(client, p6WSUser);

        return servicePort;
    }
    
    /**
     * ������ҵ������ֵ�����Port
     * @param p6WSUser
     * @return
     * @throws Exception
     */
    private static ActivityCodePortType createActivityCodeServicePort(P6WSUser p6WSUser)
      throws Exception
    {
        String url = makeHttpURLString(Activity_Code_Service);
        URL wsdlURL = new URL(url);
        ActivityCodeService service = new ActivityCodeService(wsdlURL);
        ActivityCodePortType servicePort = service.getActivityCodePort();
        Client client = ClientProxy.getClient(servicePort);
        setUserTokenData(client, p6WSUser);

        return servicePort;
    }
    
    /**
     * ������ҵ��������Port
     * @param p6WSUser
     * @return
     * @throws Exception
     */
    private static ActivityCodeTypePortType createActivityCodeTypeServicePort(P6WSUser p6WSUser)
      throws Exception
    {
        String url = makeHttpURLString(Activity_Code_Type_Service);
        URL wsdlURL = new URL(url);
        ActivityCodeTypeService service = new ActivityCodeTypeService(wsdlURL);
        ActivityCodeTypePortType servicePort = service.getActivityCodeTypePort();
        Client client = ClientProxy.getClient(servicePort);
        setUserTokenData(client, p6WSUser);

        return servicePort;
    }

    
    /**
     * ������Դ��������Port
     * @param p6WSUser
     * @return
     * @throws Exception
     */
    private static ResourceAssignmentPortType createResourceAssignmentServicePort(P6WSUser p6WSUser)
      throws Exception
    {
        String url = makeHttpURLString(RESOURCE_ASSIGNMENT_SERVICE);
        URL wsdlURL = new URL(url);
        ResourceAssignmentService service = new ResourceAssignmentService(wsdlURL);
        ResourceAssignmentPortType servicePort = service.getResourceAssignmentPort();
        Client client = ClientProxy.getClient(servicePort);
        setUserTokenData(client, p6WSUser);

        return servicePort;
    }
    /**
     * ����ResourceCode�����Port
     * @param p6WSUser
     * @return
     * @throws Exception
     */
    private static ResourceCodePortType createResourceCodeServicePort(P6WSUser p6WSUser)
      throws Exception
    {
        String url = makeHttpURLString(RESOURCE_CODE_SERVICE);
        URL wsdlURL = new URL(url);
        ResourceCodeService service = new ResourceCodeService(wsdlURL);
        ResourceCodePortType servicePort = service.getResourceCodePort();
        Client client = ClientProxy.getClient(servicePort);
        setUserTokenData(client, p6WSUser);

        return servicePort;
    }
    /**
     * ����ResourceCodeType�����Port
     * @param p6WSUser
     * @return
     * @throws Exception
     */
    private static ResourceCodeTypePortType createResourceCodeTypeServicePort(P6WSUser p6WSUser)
      throws Exception
    {
        String url = makeHttpURLString(RESOURCE_CODE_TYPE_SERVICE);
        URL wsdlURL = new URL(url);
        ResourceCodeTypeService service = new ResourceCodeTypeService(wsdlURL);
        ResourceCodeTypePortType servicePort = service.getResourceCodeTypePort();
        Client client = ClientProxy.getClient(servicePort);
        setUserTokenData(client, p6WSUser);

        return servicePort;
    }
    

    /**
     * ������Դ�����ͼ۸�����Port
     * @param p6WSUser
     * @return
     * @throws Exception
     */
    private static ResourceRatePortType createResourceRateServicePort(P6WSUser p6WSUser)
      throws Exception
    {
        String url = makeHttpURLString(RESOURCE_RATE_SERVICE);
        URL wsdlURL = new URL(url);
        ResourceRateService service = new ResourceRateService(wsdlURL);
        ResourceRatePortType servicePort = service.getResourceRatePort();
        Client client = ClientProxy.getClient(servicePort);
        setUserTokenData(client, p6WSUser);

        return servicePort;
    }
    
    /**
     * ����ActivityStep��Port
     * @param p6WSUser
     * @return
     * @throws Exception
     */
    private static ActivityStepPortType createActivityStepServicePort(P6WSUser p6WSUser)
      throws Exception
    {
        String url = makeHttpURLString(Activity_Step_Service);
        URL wsdlURL = new URL(url);
        ActivityStepService service = new ActivityStepService(wsdlURL);
        ActivityStepPortType servicePort = service.getActivityStepPort();
        Client client = ClientProxy.getClient(servicePort);
        setUserTokenData(client, p6WSUser);

        return servicePort;
    }
    
    /**
     * ����CalendarPortType��Port
     * @param p6WSUser
     * @return
     * @throws Exception
     */
    private static CalendarPortType createCalendarServicePort(P6WSUser p6WSUser)
      throws Exception
    {
        String url = makeHttpURLString(Calendar_Service);
        URL wsdlURL = new URL(url);
        CalendarService service = new CalendarService(wsdlURL);
        CalendarPortType servicePort = service.getCalendarPort();
        Client client = ClientProxy.getClient(servicePort);
        setUserTokenData(client, p6WSUser);

        return servicePort;
    }
    
    /**
     * ����ProjectCodeAssignmentPortType��Port
     * @param p6WSUser
     * @return
     * @throws Exception
     */
    private static ProjectCodeAssignmentPortType createProjectCodeAssignmentServicePort(P6WSUser p6WSUser)
    throws Exception
  {
      String url = makeHttpURLString(Project_Code_Assignment_Service);
      URL wsdlURL = new URL(url);
      ProjectCodeAssignmentService service = new ProjectCodeAssignmentService(wsdlURL);
      ProjectCodeAssignmentPortType servicePort = service.getProjectCodeAssignmentPort();
      Client client = ClientProxy.getClient(servicePort);
      setUserTokenData(client, p6WSUser);

      return servicePort;
  }
    
    /**
     * ����UDFCodePortType��Port
     * @param p6WSUser
     * @return
     * @throws Exception
     */
    private static UDFCodePortType createUDFCodeServicePort(P6WSUser p6WSUser)
    throws Exception
  {
      String url = makeHttpURLString(UDFCode_Service);
      URL wsdlURL = new URL(url);
      UDFCodeService service = new UDFCodeService(wsdlURL);
      UDFCodePortType servicePort = service.getUDFCodePort();
      Client client = ClientProxy.getClient(servicePort);
      setUserTokenData(client, p6WSUser);

      return servicePort;
  }
    
    
    /**
     * ����UDFTypePortType��Port
     * @param p6WSUser
     * @return
     * @throws Exception
     */
    private static UDFTypePortType createUDFTypeServicePort(P6WSUser p6WSUser)
    throws Exception
  {
      String url = makeHttpURLString(UDFType_Service);
      URL wsdlURL = new URL(url);
      UDFTypeService service = new UDFTypeService(wsdlURL);
      UDFTypePortType servicePort = service.getUDFTypePort();
      Client client = ClientProxy.getClient(servicePort);
      setUserTokenData(client, p6WSUser);

      return servicePort;
  }
    
    /**
     * ����RelationshipPort��Port
     * @param p6WSUser
     * @return
     * @throws Exception
     */
    private static RelationshipPortType createRelationshipServicePort(P6WSUser p6WSUser)
    throws Exception
  {
      String url = makeHttpURLString(Relationship_Service);
      URL wsdlURL = new URL(url);
      RelationshipService service = new RelationshipService(wsdlURL);
      RelationshipPortType servicePort = service.getRelationshipPort();
      Client client = ClientProxy.getClient(servicePort);
      setUserTokenData(client, p6WSUser);

      return servicePort;
  }
    
    /**
     * ����BaselineProjectPortType��Port
     * @param p6WSUser
     * @return
     * @throws Exception
     */
    private static BaselineProjectPortType createBaselineProjectServicePort(P6WSUser p6WSUser)
    throws Exception
  {
      String url = makeHttpURLString(BaselineProject_Service);
      URL wsdlURL = new URL(url);
      BaselineProjectService service = new BaselineProjectService(wsdlURL);
      BaselineProjectPortType servicePort = service.getBaselineProjectPort();
      Client client = ClientProxy.getClient(servicePort);
      setUserTokenData(client, p6WSUser);

      return servicePort;
  }
    
    /**
     * ����UDFValuePortType��Port
     * @param p6WSUser
     * @return
     * @throws Exception
     */
    private static UDFValuePortType createUDFValueServicePort(P6WSUser p6WSUser)
    throws Exception
  {
      String url = makeHttpURLString(UDFValue_Service);
      URL wsdlURL = new URL(url);
      UDFValueService service = new UDFValueService(wsdlURL);
      UDFValuePortType servicePort = service.getUDFValuePort();
      Client client = ClientProxy.getClient(servicePort);
      setUserTokenData(client, p6WSUser);

      return servicePort;
  }

    
    // ��������URL
    private static String makeHttpURLString(String suffix)
    {
        StringBuilder sb = new StringBuilder(P6_WS_URL);
        sb.append(suffix);

        return sb.toString();
    }

    // ������֤��Ϣ
    private static void setUserTokenData(Client client, P6WSUser p6WSUser)
    {
        // Uncomment the following two lines to log SOAPMessages
        client.getEndpoint().getOutInterceptors().add(new LoggingOutInterceptor());
        client.getEndpoint().getInInterceptors().add(new LoggingInInterceptor());

        client.getEndpoint().getOutInterceptors().add(new SAAJOutInterceptor());
        client.getEndpoint().getInInterceptors().add(new SAAJInInterceptor());

        // To do UsernameToken or SAML, we use our own Interceptor
        //  This will also handle encryption, if enabled
        client.getEndpoint().getOutInterceptors().add(new P6WSOutInterceptor(p6WSUser));

    }

    // �ڲ��࣬�����P6�������û���Ϣ
    static class P6WSUser
    {
        //~ Static fields/initializers -------------------------------------------------------------

        static final P6WSUser DEFAULT_USER;

        static
        {
        	DEFAULT_USER = new P6WSUser("gms_p6_ws_user", "abcd1234");
        }

        //~ Instance fields ------------------------------------------------------------------------

        final String username;
        final String password;

        //~ Constructors ---------------------------------------------------------------------------

        P6WSUser(String username, String password)
        {
            this.username = username;
            this.password = password;
        }
    }
}
