package com.bgp.mcs.service.hse.service;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.mcs.service.ma.showMainFrame.util.MarketGetInfoUtil;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.MsgElement;

	public class HseUtil {
		
		private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
		private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		private static HseUtil mg = null;
		
		private HseUtil() {

		}

		public static HseUtil getInstance() {
			if (mg == null) {
				return new HseUtil();
			} else {
				return mg;
			}
		}
		
		public void totalEnvironment(String hse_environment_id){
			
			String qqq = "select t.father_org_sub_id,en.create_date,en.hse_environment_id from bgp_hse_org t join bgp_hse_environment en on t.org_sub_id=en.org_sub_id and en.bsflag='0' where en.hse_environment_id='"+hse_environment_id+"'";
			Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(qqq);
			String org_sub_id = (String)map.get("fatherOrgSubId");
			String create_date = (String)map.get("createDate");
			
			if(!org_sub_id.equals("C1")){
			
			String sql1 = "select * from bgp_hse_environment where bsflag='0' and org_sub_id='"+org_sub_id+"' and create_date=to_date('"+create_date+"','yyyy-MM-dd')";
			Map mapId = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql1);
			String hse_environment_id2 = (String)mapId.get("hseEnvironmentId");
			
			
			Map map123 = new HashMap();
			map123.put("HSE_ENVIRONMENT_ID", hse_environment_id2);
			map123.put("MODIFI_DATE", new Date());
			map123.put("STATUS", "1");
			pureJdbcDao.saveOrUpdateEntity(map123,"BGP_HSE_ENVIRONMENT");
			
			
			String sqlTotal = "update bgp_hse_environment_detail t set t.month_data =  (select sum(month_data) from bgp_hse_org ho join bgp_hse_environment en on ho.org_sub_id = en.org_sub_id and en.bsflag = '0' join bgp_hse_environment_detail ed on en.hse_environment_id = ed.hse_environment_id  where (ho.father_org_sub_id='"+org_sub_id+"' and ho.environment_flag='1' and en.create_date=to_date('"+create_date+"','yyyy-MM-dd') and en.status='3' or (ho.organ_flag = '0' and en.status not in ('0', '4') and ho.father_org_sub_id = '"+org_sub_id+"' and en.create_date = to_date('"+create_date+"', 'yyyy-MM-dd')  and ho.environment_flag = '1')) and ed.hse_model_id= t.hse_model_id) where t.hse_environment_id = (select hse_environment_id from bgp_hse_environment where org_sub_id='"+org_sub_id+"' and create_date=to_date('"+create_date+"','yyyy-MM-dd'))";
			jdbcTemplate.execute(sqlTotal);
			
			//根据father_id 查询出下属基层单位包含的     每个基层单位查出6条数据，进行运算《燃料煤平均含硫量=Σ（各下级单位平均含硫量*燃料煤量本月）/Σ（各下级单位燃料煤量本月）》 
			String sqlS = "select * from bgp_hse_org ho join bgp_hse_environment en on ho.org_sub_id = en.org_sub_id and en.bsflag = '0' join bgp_hse_environment_detail ed on en.hse_environment_id=ed.hse_environment_id where ho.father_org_sub_id = '"+org_sub_id+"'  and ho.environment_flag='1' and en.create_date = to_date('"+create_date+"', 'yyyy-MM-dd') and ed.hse_model_id in ('101001001','101001001001','101001001002','101001002','101001002001','101001002002') and en.status='3' order by ed.hse_environment_id desc,ed.hse_model_id asc";
			List list = BeanFactory.getQueryJdbcDAO().queryRecords(sqlS);
			
			double data_s1 = 0;
			double data_s2 = 0;
			double data_s3 = 0;
			double total_data1 = 0;
			double total_data2 = 0;
			double total_data3 = 0;
			
			
			for(int i=0;i<list.size();i+=6){
				Map map1 = (Map)list.get(i);
				Map map2 = (Map)list.get(i+1);
				Map map3 = (Map)list.get(i+2);
				Map map4 = (Map)list.get(i+3);
				Map map5 = (Map)list.get(i+4);
				Map map6 = (Map)list.get(i+5);
				
			/*	1.燃料煤
					其中:野外施工燃料煤
			                                  其他
				2.燃料煤平均含硫量
			                     其中:野外施工燃料煤平均含硫量
			                                 其他
			     month_data1~6 分别对应上面六项 
				*/
				double data1 = 0;
				double data2 = 0;
				double data3 = 0;
				double data4 = 0;
				double data5 = 0;
				double data6 = 0;
				String month_data1 = (String)map1.get("monthData");    
				if(month_data1==null){
					System.out.println("**************************************");
					System.out.println("null");
					System.out.println("**************************************");
				}else if(month_data1.equals("")){
					System.out.println("**************************************");
					System.out.println("空字符串");
					System.out.println("**************************************");
				}else{
					data1 = Double.parseDouble(month_data1);
				}
					
				String month_data2 = (String)map2.get("monthData");
				if(month_data2!=null&&!month_data2.equals("")){
					data2 = Double.parseDouble(month_data2);
				}
				String month_data3 = (String)map3.get("monthData");
				if(month_data3!=null&&!month_data3.equals("")){
					data3 = Double.parseDouble(month_data3);
				}
				String month_data4 = (String)map4.get("monthData");
				if(month_data4!=null&&!month_data4.equals("")){
					data4 = Double.parseDouble(month_data4);
				}
				String month_data5 = (String)map5.get("monthData");
				if(month_data5!=null&&!month_data5.equals("")){
					data5 = Double.parseDouble(month_data5);
				}
				String month_data6 = (String)map6.get("monthData");
				if(month_data6!=null&&!month_data6.equals("")){
					data6 = Double.parseDouble(month_data6);
				}
				
				data_s1 +=data1*data4; 
				data_s2 +=data2*data5; 
				data_s3 +=data3*data6; 
			
				total_data1 += data1;
				total_data2 += data2;
				total_data3 += data3;
			}
			
			if(total_data1==0){
				String sss = "update bgp_hse_environment_detail set month_data = '' where hse_model_id='101001002' and hse_environment_id='"+hse_environment_id2+"'";
				jdbcTemplate.execute(sss);	
			}else{
				double percent_s1 = data_s1/total_data1;
				String sss = "update bgp_hse_environment_detail set month_data = '"+percent_s1+"' where hse_model_id='101001002' and hse_environment_id='"+hse_environment_id2+"'";
				jdbcTemplate.execute(sss);	
			}
			
			if(total_data2==0){
				String sss = "update bgp_hse_environment_detail set month_data = '' where hse_model_id='101001002001' and hse_environment_id='"+hse_environment_id2+"'";
				jdbcTemplate.execute(sss);	
			}else{
				double percent_s2 = data_s2/total_data2;
				String sss = "update bgp_hse_environment_detail set month_data = '"+percent_s2+"' where hse_model_id='101001002001' and hse_environment_id='"+hse_environment_id2+"'";
				jdbcTemplate.execute(sss);	
			}
			
			if(total_data3==0){
				String sss = "update bgp_hse_environment_detail set month_data = '' where hse_model_id='101001002002' and hse_environment_id='"+hse_environment_id2+"'";
				jdbcTemplate.execute(sss);	
			}else{
				double percent_s3 = data_s3/total_data3;
				String sss = "update bgp_hse_environment_detail set month_data = '"+percent_s3+"' where hse_model_id='101001002002' and hse_environment_id='"+hse_environment_id2+"'";
				jdbcTemplate.execute(sss);	
			}
			
			/*		代码33：二氧化硫=野外施工燃料煤二氧化硫产生量+野外作业柴油机用柴油二氧化硫产生量
					野外施工燃料煤二氧化硫产生量（吨）=1.6×野外施工燃料煤×野外施工燃料煤平均含硫量
					野外作业柴油机用柴油二氧化硫产生量（吨）=野外作业柴油机用柴油×18/0.849/1000
					代码34：氮氧化物=野外施工燃料煤氮氧化物产生量+野外作业柴油机用柴油氮氧化物产生量
					野外施工燃料煤氮氧化物产生量（吨）=1.63×野外施工燃料煤×(0.25×0.015＋0.000938）
					野外作业柴油机用柴油氮氧化物产生量（吨）=野外作业柴油机用柴油×60/0.849/1000
			 */
	
			//二氧化硫
			String sqlSO2 = "update bgp_hse_environment_detail t set t.month_data = ((1.6*nvl((select d.month_data from bgp_hse_environment_detail d where d.hse_model_id='101001001001' and d.hse_environment_id='"+hse_environment_id2+"'),0)*nvl((select d.month_data from bgp_hse_environment_detail d where d.hse_model_id='101001002001' and d.hse_environment_id='"+hse_environment_id2+"'),0)/100) + (nvl((select d.month_data from bgp_hse_environment_detail d where d.hse_model_id='101001003002' and d.hse_environment_id='"+hse_environment_id2+"'),0)*18/0.849/1000)) where t.hse_model_id='101003001' and t.hse_environment_id = '"+hse_environment_id2+"'";
			jdbcTemplate.execute(sqlSO2);	
			//氮氧化物
			String sqlNO = "update bgp_hse_environment_detail t set t.month_data = (1.63*nvl((select d.month_data from bgp_hse_environment_detail d where d.hse_model_id='101001001001' and d.hse_environment_id='"+hse_environment_id2+"'),0)*(0.25*0.015+0.000938)) + (nvl((select d.month_data from bgp_hse_environment_detail d where d.hse_model_id='101001003002' and d.hse_environment_id='"+hse_environment_id2+"'),0)*60/0.849/1000) where t.hse_model_id='101003002' and t.hse_environment_id = '"+hse_environment_id2+"'";
			jdbcTemplate.execute(sqlNO);	
			
			
			
			//算出全年累计
			String sqlYear = "update bgp_hse_environment_detail t set t.year_data = (select sum(ed.month_data) from bgp_hse_environment en join bgp_hse_environment_detail ed on en.hse_environment_id=ed.hse_environment_id where en.bsflag='0' and en.org_sub_id=(select org_sub_id from bgp_hse_environment where hse_environment_id = '"+hse_environment_id2+"') and to_char(en.create_date,'yyyy')=to_char(sysdate,'yyyy') and t.hse_model_id=ed.hse_model_id) where t.hse_environment_id = '"+hse_environment_id2+"'";
			jdbcTemplate.execute(sqlYear);
			
			//累计同比增减量
			String sqlIncrease = "update bgp_hse_environment_detail t set t.increase_data = (t.month_data - nvl((select month_data from bgp_hse_environment en join bgp_hse_environment_detail ed on en.hse_environment_id=ed.hse_environment_id where en.bsflag='0' and en.org_sub_id=(select org_sub_id from bgp_hse_environment where hse_environment_id = '"+hse_environment_id2+"') and en.create_date = add_months((select create_date from bgp_hse_environment where hse_environment_id = '"+hse_environment_id2+"'),-12)  and t.hse_model_id=ed.hse_model_id),0)) where t.hse_environment_id = '"+hse_environment_id2+"'";
			jdbcTemplate.execute(sqlIncrease);
			
			//累计同比±%
			String  sqlPercent = "update bgp_hse_environment_detail dd set dd.increase_percent = (select case when asd=0 then 100 else qwe/asd*100 end asd from (select (nvl(t.month_data,0) - nvl((select month_data from bgp_hse_environment en join bgp_hse_environment_detail ed on en.hse_environment_id = ed.hse_environment_id where en.bsflag = '0' and en.org_sub_id = (select org_sub_id from bgp_hse_environment where hse_environment_id = '"+hse_environment_id2+"') and en.create_date = add_months((select create_date from bgp_hse_environment where hse_environment_id = '"+hse_environment_id2+"'), -12) and t.hse_model_id = ed.hse_model_id), 0)) qwe , nvl((select month_data from bgp_hse_environment en join bgp_hse_environment_detail ed on en.hse_environment_id = ed.hse_environment_id where en.bsflag = '0' and en.org_sub_id = (select org_sub_id from bgp_hse_environment where hse_environment_id = '"+hse_environment_id2+"') and en.create_date = add_months((select create_date from bgp_hse_environment where hse_environment_id = '"+hse_environment_id2+"'), -12) and t.hse_model_id = ed.hse_model_id), nvl(t.month_data,0)) asd,t.hse_model_id,t.hse_environment_id from bgp_hse_environment_detail t where t.hse_environment_id = '"+hse_environment_id2+"') cc where dd.hse_model_id=cc.hse_model_id) where dd.hse_environment_id='"+hse_environment_id2+"'";
//			String sqlPercent = "update bgp_hse_environment_detail t set t.increase_percent = (((t.month_data - nvl((select month_data from bgp_hse_environment en join bgp_hse_environment_detail ed on en.hse_environment_id=ed.hse_environment_id where en.bsflag='0' and en.org_sub_id=(select org_sub_id from bgp_hse_environment where hse_environment_id = '"+hse_environment_id2+"') and en.create_date = add_months((select create_date from bgp_hse_environment where hse_environment_id = '"+hse_environment_id2+"'),-12)  and t.hse_model_id=ed.hse_model_id),0))/nvl((select month_data from bgp_hse_environment en join bgp_hse_environment_detail ed on en.hse_environment_id=ed.hse_environment_id where en.bsflag='0' and en.org_sub_id=(select org_sub_id from bgp_hse_environment where hse_environment_id = '"+hse_environment_id2+"') and en.create_date = add_months((select create_date from bgp_hse_environment where hse_environment_id = '"+hse_environment_id2+"'),-12)  and t.hse_model_id=ed.hse_model_id),t.month_data))*100) where t.hse_environment_id = '"+hse_environment_id2+"'";
			jdbcTemplate.execute(sqlPercent);
			
			}
		}
		
		
		
		
		
		
		
		
	    
}
