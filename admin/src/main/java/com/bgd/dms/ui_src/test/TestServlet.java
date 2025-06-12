package test;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

import com.cnpc.jcdp.cfg.BeanFactory;

/**
 * According the file name and its size, generate a unique token. And this
 * token will be refer to user's file.
 */
public class TestServlet extends HttpServlet {
	private static final long serialVersionUID = 2650340991003623753L;
 
	@Override
	public void init() throws ServletException {
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
  
	    String id = request.getParameter("id");  
	    if(id == null)
	    	id = "50000674";
	     
		List<Map> list = new ArrayList<Map>();
		
		if(id.equals("50000674")){
			String orgSQL = "select t2.org_hr_id id,t1.org_hr_parent_id p_id, t1.org_hr_short_name as name, '' t   from bgp_comm_org_hr t1 join bgp_comm_org_hr_gms " +
					" t2 on t1.org_hr_id = t2.org_hr_id join comm_org_subjection t3 on t3.org_id = t2.org_gms_id and t3.bsflag = '0'  and t2.org_hr_id ='"+id+"'";
			
			List<Map> orgList = BeanFactory.getPureJdbcDAO().queryRecords(orgSQL);
			
			list.addAll(processList(orgList,"org"));
			
			String empSQL = " Select e.employee_id as id, s1.org_hr_id p_id, e.employee_name as name ,'' t FROM comm_human_employee e ,comm_org_subjection e1, bgp_comm_org_hr_gms s1" +
					"   WHERE e.bsflag='0'  and e.org_id=e1.org_id  and e1.org_id=s1.org_gms_id and s1.org_hr_id='"+id+"'";
			
			List<Map> humanList = BeanFactory.getPureJdbcDAO().queryRecords(empSQL);		

			list.addAll(processList(humanList,"human"));
			
			String orgSubSQL = "select t2.org_hr_id id,t1.org_hr_parent_id p_id, t1.org_hr_short_name as name, '' t   from bgp_comm_org_hr t1 join bgp_comm_org_hr_gms " +
					"  t2 on t1.org_hr_id = t2.org_hr_id join comm_org_subjection t3 on t3.org_id = t2.org_gms_id and t3.bsflag = '0'  and t1.org_hr_parent_id ='"+id+"'";
			
			List<Map> orgSubList = BeanFactory.getPureJdbcDAO().queryRecords(orgSubSQL);
			 
			list.addAll(processList(orgSubList,"org"));
		} else {
			String empSQL = " Select e.employee_id as id, s1.org_hr_id p_id, e.employee_name as name ,'' t FROM comm_human_employee e ,comm_org_subjection e1, bgp_comm_org_hr_gms s1" +
					"   WHERE e.bsflag='0'  and e.org_id=e1.org_id  and e1.org_id=s1.org_gms_id and s1.org_hr_id='"+id+"'";
			
			List<Map> humanList = BeanFactory.getPureJdbcDAO().queryRecords(empSQL);		
			
			list.addAll(processList(humanList,"human"));
			
			String orgSubSQL = "select t2.org_hr_id id,t1.org_hr_parent_id p_id, t1.org_hr_short_name as name, '' t   from bgp_comm_org_hr t1 join bgp_comm_org_hr_gms " +
					"  t2 on t1.org_hr_id = t2.org_hr_id join comm_org_subjection t3 on t3.org_id = t2.org_gms_id and t3.bsflag = '0'  and t1.org_hr_parent_id ='"+id+"'";
			
			List<Map> orgSubList = BeanFactory.getPureJdbcDAO().queryRecords(orgSubSQL);
			list.addAll(processList(orgSubList,"org"));
			
//			for(Map map :orgSubList){
//				
//				String idd = map.get("id").toString();
//				
//				empSQL = " Select e.employee_id as id, s1.org_hr_id p_id, e.employee_name as name ,'' t FROM comm_human_employee e ,comm_org_subjection e1, bgp_comm_org_hr_gms s1" +
//						"   WHERE e.bsflag='0'  and e.org_id=e1.org_id  and e1.org_id=s1.org_gms_id and s1.org_hr_id='"+idd+"'";
//				
//				humanList = BeanFactory.getPureJdbcDAO().queryRecords(empSQL);		
//				
//				list.addAll(processList(humanList,"human"));
//
//			}
		}

		 
		String json = JSONArray.fromCollection(list).toString();
		
		response.getWriter().write(json);
	}
	
	private List processList(List<Map> list,String treeType){
		List<Map> ls = new ArrayList<Map>();
		
		if(treeType.equals("org")){
			for(Map map:list){
				Object pId = map.get("p_id");
				map.put("pId", pId);
				map.put("isParent", true);
				map.put("open", true);
				ls.add(map);
			}
		} else {
			for(Map map:list){
				Object pId = map.get("p_id");
				map.put("pId", pId);
				ls.add(map);
			}
		}

		return ls;
	}

	@Override
	protected void doHead(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		super.doHead(req, resp);
	}

	@Override
	public void destroy() {
		super.destroy();
	}

}
