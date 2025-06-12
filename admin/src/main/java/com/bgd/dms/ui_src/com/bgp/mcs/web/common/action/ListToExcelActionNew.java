package com.bgp.mcs.web.common.action;

import java.io.FileOutputStream;
import java.io.OutputStream;
import java.net.URLDecoder;
 
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.springframework.jdbc.core.JdbcTemplate;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import com.bgp.gms.service.rm.dm.constants.DevConstants;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;

public class ListToExcelActionNew extends WSAction {

	public ListToExcelActionNew()
    {
    }
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
    
    public ActionForward executeResponse(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
    throws Exception{
    	
    	String JCDP_COLUMN_EXP = request.getParameter("JCDP_COLUMN_EXP");
		String JCDP_COLUMN_TITLE = request.getParameter("JCDP_COLUMN_TITLE");
		
		String excelName = UUID.randomUUID().toString()+".xls";
		
    	if( (JCDP_COLUMN_EXP!=null && !JCDP_COLUMN_EXP.equals(""))){
    		JCDP_COLUMN_TITLE = URLDecoder.decode(JCDP_COLUMN_TITLE, "utf-8");
    		String JCDP_FILE_NAME = request.getParameter("JCDP_FILE_NAME");
    		if(JCDP_FILE_NAME==null || JCDP_FILE_NAME.equals("")){
    			JCDP_FILE_NAME="����";
    		}else{
    			JCDP_FILE_NAME = URLDecoder.decode(JCDP_FILE_NAME, "utf-8");
    		}
    		JCDP_FILE_NAME = JCDP_FILE_NAME.replaceAll("\\/|\\\\", "");
    		
    		HSSFWorkbook wb = new HSSFWorkbook();//������HSSFWorkbook����  
    		
    		for(int h=1;h<8;h++){
    			List<Map<String,Object>> datas= queryDeviceList(request,30000,h);
    			if(datas.size()==0)continue;
    			HSSFSheet sheet = wb.createSheet(JCDP_FILE_NAME+h);//�����µ�sheet����
        		
        		String[] exps = JCDP_COLUMN_EXP.split(",");
        		String[] titles = JCDP_COLUMN_TITLE.split(",");
        		HSSFRow row0 = sheet.createRow((short)0);//��������
        		
        		HSSFFont font = wb.createFont();
        		font.setFontHeightInPoints((short)11);
        		font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
        		//font.setTypeOffset(XSSFFont.SS_SUPER);
        		HSSFCellStyle style = wb.createCellStyle();
        		style.setFont(font);
        		//style.setAlignment(HSSFCellStyle.ALIGN_CENTER); // ˮƽ���֣�����
        		
        		// ������ͷ
        		for(int j=0;j<titles.length;j++){
        			HSSFCell cell = row0.createCell(j);//������cell
    				cell.setCellValue(titles[j]);
    				cell.setCellStyle(style);
    				//sheet.setColumnWidth(j, 6000);
        		}
        		// ������������
        		for(int i=0;i<datas.size();i++){
        			Map<String,Object> data = datas.get(i);
        			HSSFRow row = sheet.createRow(i+1);//��������
        			for(int j=0;j<exps.length;j++){
        				HSSFCell cell = row.createCell(j);//������cell
        				// 1209 zxh add 
        				if(data.get(exps[j])!=null&&((String)data.get(exps[j])).contains("&sup")){
        					
        					Font font1 = wb.createFont();
        		    		font1.setFontHeightInPoints((short)11);
        		    		font1.setBoldweight(Font.BOLDWEIGHT_BOLD);
        		    		font1.setTypeOffset(XSSFFont.SS_SUPER);
        		    		String datatemp = (String) data.get(exps[j]);
        		    		int supindex = datatemp.indexOf("&sup");
        		    		int strlength = datatemp.length();
        		    		
        		    		datatemp = datatemp.replace("&sup", "");
    		    			HSSFRichTextString rts = new HSSFRichTextString(datatemp);
        		    		
        		    		if((supindex+1+4)!=strlength){
        		    			rts.applyFont(supindex, supindex+1, font1);
        		    		}
        		    		cell.setCellValue(rts);
        					
        				}else{
        					cell.setCellValue((String)data.get(exps[j]));
        				}
        				
        			}
        		}
        		
        		// �����п��Զ� 
        		for(int j=0;j<titles.length;j++){
    				sheet.autoSizeColumn(j); // �Զ������п�
    				sheet.setColumnWidth(j, (int)(sheet.getColumnWidth(j)*1.5)); // �����п�Ϊ�Զ�ֵ��1.5��
        		}
    		}
    		
			// ���� response ������
			response.setContentType("application/vnd.ms-excel;  charset=utf-8");
			
			// ���� response ��ʾ��ͷ
			response.setHeader("Content-Disposition","attachment;  filename=" + java.net.URLEncoder.encode(JCDP_FILE_NAME, "utf-8") + ".xls");
			
			String file = this.getServlet().getServletContext().getRealPath("/WEB-INF/temp/"+excelName);
			
			OutputStream os = new FileOutputStream(file);
    		
			wb.write(os);
			
			os.flush();
			
			os.close();
			 
    	}
    	
    	response.setContentType("text/json; charset=utf-8");
    	
    	String ret="{returnCode:0, excelName:'"+excelName+"'}";
    	
    	response.getWriter().write(ret);
    	
    	return null;
    }
     
 
    public List queryDeviceList(HttpServletRequest   isrvmsg,int pageSize,int currentPage) throws Exception {
		 
		String start_date=isrvmsg.getParameter("start_date");
		String end_date=isrvmsg.getParameter("end_date");
		String lastdate=null;
		String sortField = isrvmsg.getParameter("sort");
		String sortOrder = isrvmsg.getParameter("order");
		String code = isrvmsg.getParameter("code");
		String is_devicecode = isrvmsg.getParameter("isDeviceCode");
		String orgSubId = isrvmsg.getParameter("orgSubId");// ����������λ
		String userOrgId = isrvmsg.getParameter("userOrgId");
		String userSubid = isrvmsg.getParameter("orgSubId");
		int orgLength = userOrgId.length();
		String orgId= isrvmsg.getParameter("orgId");
		String orgType="";
		String dgOrg="C6000000000039,C6000000000040,C6000000005269,C6000000005280,C6000000005275,C6000000005279,C6000000005278,C6000000007366";
		//���8�����������жϱ�־
		if(dgOrg.contains(orgId)){
			orgType="Y";
		}else{
			orgType="N";
		}
		String zhEquSub="";
		if(userSubid.startsWith("C105008042")){//�ۺ��ﻯ̽�����豸���������û���ʾ�豸���ʿ��豸
			zhEquSub="Y";
		}
	
		String str = "SELECT * FROM (SELECT QUERYED_DATAS_.*, ROWNUM ROWNUM_  FROM (";
		if(orgLength==4){
			str += "select u.coding_name as using_stat_desc,nvl(t.ifcountry, '����') as ifcountry_tmp,c.coding_name as tech_stat_desc,t.dev_coding as erp_id, "
				+ "p.project_name as project_name_desc,t.dev_acc_id,t.dev_name,t.dev_model,t.dev_sign,t.self_num,t.license_num,t.dev_type, "
				+ "t.producting_date,t.asset_value,t.net_value,t.dev_position,substr(dev_position,0,10) dev_position1,t.asset_coding,t.cont_num,t.turn_num,t.using_stat,t.saveflag,t.spare1,t.spare2,t.spare3,t.spare4, "
				+ "case when t.owning_sub_id like 'C105001005%' then '����ľ��̽��' when t.owning_sub_id like 'C105001002%' then '�½���̽��' "
				+ "when t.owning_sub_id like 'C105001003%' then '�¹���̽��' when t.owning_sub_id like 'C105001004%' then '�ຣ��̽��' "
				+ "when t.owning_sub_id like 'C105005004%' then '������̽��' when t.owning_sub_id like 'C105005000%' then '������̽��' "
				+ "when t.owning_sub_id like 'C105005001%' then '������̽������' when t.owning_sub_id like 'C105007%' then '������̽��' "
				+ "when t.owning_sub_id like 'C105063%' then '�ɺ���̽��'  "
				+ "when t.owning_sub_id like 'C105008%' then '�ۺ��ﻯ��' when t.owning_sub_id like 'C105002%' then '���ʿ�̽��ҵ��' "
				+ "when t.owning_sub_id like 'C105006%' then 'װ������' when t.owning_sub_id like 'C105003%' then '�о�Ժ' when t.owning_sub_id like 'C105087%' then  '������̽�ֹ�˾'"
				+ "when t.owning_sub_id like 'C105017%' then '����������ҵ��' else info.org_abbreviation end as owning_org_name_desc, "
				+ "i.org_abbreviation usage_org_name_desc,co.coding_name as account_stat_desc from gms_device_account t "
				+ "left join comm_org_information i on t.usage_org_id = i.org_id and i.bsflag = '0' "
				+ "left join comm_org_information info on t.owning_org_id = info.org_id and info.bsflag = '0' "
				+ "left join gp_task_project p on t.project_info_no = p.project_info_no "
				+ "left join comm_coding_sort_detail co on co.coding_code_id = t.account_stat "
				+ "left join comm_coding_sort_detail c on c.coding_code_id = t.tech_stat "
				+ "left join comm_coding_sort_detail u on u.coding_code_id = t.using_stat ";
		}else{
			str += "select u.coding_name as using_stat_desc,nvl(t.ifcountry, '����') as ifcountry_tmp,c.coding_name as tech_stat_desc,t.dev_coding as erp_id, "
				+ "p.project_name as project_name_desc,t.dev_acc_id,t.dev_name,t.dev_model,t.dev_sign,t.self_num,t.license_num,t.dev_type, "
				+ "t.producting_date,t.asset_value,t.net_value,t.dev_position,substr(dev_position,0,10) dev_position1,t.asset_coding,t.cont_num,t.turn_num,t.using_stat,t.saveflag,t.spare1,t.spare2,t.spare3,t.spare4, "
				+ "info.org_abbreviation as owning_org_name_desc, "
				+ "i.org_abbreviation usage_org_name_desc,co.coding_name as account_stat_desc from gms_device_account t "
				+ "left join comm_org_information i on t.usage_org_id = i.org_id and i.bsflag = '0' "
				+ "left join comm_org_information info on t.owning_org_id = info.org_id and info.bsflag = '0' "
				+ "left join gp_task_project p on t.project_info_no = p.project_info_no "
				+ "left join comm_coding_sort_detail co on co.coding_code_id = t.account_stat "
				+ "left join comm_coding_sort_detail c on c.coding_code_id = t.tech_stat "
				+ "left join comm_coding_sort_detail u on u.coding_code_id = t.using_stat ";
		}
		str += "where t.bsflag='"+DevConstants.BSFLAG_NORMAL+"' and t.account_stat != '"+DevConstants.DEV_ACCOUNT_CHUZHI+"' ";
		if(   "Y".equals(orgType)){//���8��רҵ������ֻ�ܿ����Լ����ĵ�����
			if("".equals(code )){
				str += " and ( t.owning_sub_id like '"+userSubid+"%' or t.usage_sub_id like '"+userSubid+"%' ) ";
			}else{
				if("Y".equals(is_devicecode)){
					//����Ƿ�Ҷ�ӽڵ㣬��ô��codeƴlike
					str += " and t.dev_type like"+"'S"+code+"%' and ( t.owning_sub_id like '"+userSubid+"%' or t.usage_sub_id like '"+userSubid+"%' ) ";			
				}else{
					str += " and t.dev_type like"+"'"+code+"%' and ( t.owning_sub_id like '"+userSubid+"%' or t.usage_sub_id like '"+userSubid+"%' ) ";
				}
			}
		}else{
			if("".equals(code)){
				if( "Y".equals(zhEquSub)){//�ۺ��ﻯ̽��е�豸��������
					str += " and ( t.owning_sub_id like 'C105008042%' or t.owning_sub_id like 'C105008013%' ";
					str += " t.usage_sub_id like 'C105008042%' or t.usage_sub_id like 'C105008013%' ) ";
				}else{
					str += " and ( t.owning_sub_id like '"+userOrgId+"%' or t.usage_sub_id like '"+userOrgId+"%' ) ";
				}
			}else{
				if( "Y".equals(is_devicecode)){
					//����Ƿ�Ҷ�ӽڵ㣬��ô��codeƴlike
					if( "Y".equals(zhEquSub)){//�ۺ��ﻯ̽��е�豸��������
						str += " and t.dev_type like"+"'S"+code+"%' and ( t.owning_sub_id like 'C105008042%' or t.owning_sub_id like 'C105008013%' ";
						str += " t.usage_sub_id like 'C105008042%' or t.usage_sub_id like 'C105008013%' ) ";
					}else{
						str += " and t.dev_type like"+"'S"+code+"%' and ( t.owning_sub_id like '"+userOrgId+"%' or t.usage_sub_id like '"+userOrgId+"%' ) ";
					}			
				}else{
					if( "Y".equals(zhEquSub)){//�ۺ��ﻯ̽��е�豸��������
						str += " and t.dev_type like"+"'"+code+"%' and (t.owning_sub_id like 'C105008042%' or t.owning_sub_id like 'C105008013%' ";
						str += " t.usage_sub_id like 'C105008042%' or t.usage_sub_id like 'C105008013%' ) ";
					}else{
						str += " and t.dev_type like"+"'"+code+"%' and ( t.owning_sub_id like '"+userOrgId+"%' or t.usage_sub_id like '"+userOrgId+"%' ) ";
					}
				}
			}
		}
		
		Map maps=isrvmsg.getParameterMap();
		Set set= maps.keySet();
		for (Object key : set) {
			String keys=(String) key;
			if(keys.startsWith("query_")){
		  String 	value= ((String[]) maps.get(key))[0];
		  if(StringUtils.isNotBlank(value)){
			
			  if("start_date".equals(keys.substring(6).toLowerCase())){
				start_date=value;
				str+="    and t.producting_date >= to_date('"+start_date+"','yyyy-MM-dd')";
			  }else if("end_date".equals(keys.substring(6).toLowerCase())){
				end_date=value;
				str+="    and t.producting_date <= to_date('"+end_date+"','yyyy-MM-dd')";
			  }else if("lastdate".equals(keys.substring(6).toLowerCase())){
				  lastdate=value;
			  }else{
			  str+=" and "+ keys.substring(6) +" like '%"+value+"%'";
			  }
		  }
		}
		}
	 
		
		
	 
		if(StringUtils.isNotBlank(sortField)){
			str+=" order by "+sortField+" "+sortOrder+" ";
		}else{
			str += "order by case "
					+ "when t.dev_type like 'S0808%' then 1 " 		//����
					+ "when t.dev_type like 'S14050101%' then 2 "   //������������
					+ "when t.dev_type like 'S0623%' then 3 "       //�ɿ���Դ
					+ "when t.dev_type like 'S1404%' then 4 "       //�����豸
					+ "when t.dev_type like 'S060101%' then 5 "     //��װ���
					+ "when t.dev_type like 'S060102%' then 6 "     //��̧�����
					+ "when t.dev_type like 'S070301%' then 7 "     //������
					+ "when t.dev_type like 'S0622%' then 8 "       //������
					+ "when t.dev_type like 'S08%' then 9 "         //�����豸
					+ "when t.dev_type like 'S0901%' then 10 "      //�������
					+ "end ";
		}
		  
		str+=") QUERYED_DATAS_ WHERE ROWNUM <= "+(pageSize*currentPage)+") WHERE ROWNUM_ >= "+ ((currentPage-1)*pageSize+1);
		return jdbcDao.queryRecords(str);
	}
}
