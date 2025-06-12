package com.bgp.mcs.service.common;

import java.io.*;
import java.net.URL;
import java.text.DecimalFormat;
import java.util.*;

import javax.swing.text.DefaultStyledDocument;
import javax.swing.text.rtf.RTFEditorKit;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.fop.apps.FOPException;
import org.apache.fop.apps.FOUserAgent;
import org.apache.fop.apps.Fop;
import org.apache.fop.apps.FopFactory;
import org.apache.fop.apps.MimeConstants;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
  
import javax.xml.transform.stream.StreamResult;   
/**
 * 标题：东方地球物理公司物探生产管理系统
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：夏秋雨
 * 
 * 时间：2012-02-29
 *       
 * 描述：利用FOP将FO文件转换成RTF,解决WORD的下载问题
 */
public class ConvertFoToRTFSrv extends BaseService{

	private FopFactory fopFactory = FopFactory.newInstance();

    /**
     * Converts an FO file to a RTF file using FOP
     * @param fo the FO file
     * @param rtf the target RTF file
     * @throws IOException In case of an I/O problem
     * @throws FOPException In case of a FOP problem
     */
    public void convertFO2RTF(File fo, File rtf) throws IOException, FOPException {

        FOUserAgent foUserAgent = fopFactory.newFOUserAgent();
        // configure foUserAgent as desired

        OutputStream out = null;

        try {
            // Setup output stream.  Note: Using BufferedOutputStream
            // for performance reasons (helpful with FileOutputStreams).
            out = new FileOutputStream(rtf);
            out = new BufferedOutputStream(out);

            // Construct fop with desired output format
            Fop fop = fopFactory.newFop(MimeConstants.MIME_RTF, foUserAgent, out);

            // Setup JAXP using identity transformer
            TransformerFactory factory = TransformerFactory.newInstance();
            Transformer transformer = factory.newTransformer(); // identity transformer

            // Setup input stream
            Source src = new StreamSource(fo);

            // Resulting SAX events (the generated FO) must be piped through to FOP
            Result res = new SAXResult(fop.getDefaultHandler());

            // Start XSLT transformation and FOP processing
            transformer.transform(src, res);

            // Please note: getResults() won't work for RTF and other flow formats (like MIF)
            // as the layout engine is not involved in the conversion. The page-breaking
            // is done by the application opening the generated file (like MS Word).
            //FormattingResults foResults = fop.getResults();

        } catch (Exception e) {
            e.printStackTrace(System.err);
            //System.exit(-1);
        } finally {
            out.close();
        }
    }


    /**
     * Main method.
     * @param args command-line arguments
     */
    public ISrvMsg convertFop(ISrvMsg reqDTO) throws Exception {
//    	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
    	MQMsgImpl mqmsgimpl = (MQMsgImpl)SrvMsgUtil.createMQResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String userOrgId = user.getOrgId();
		String affordOrg = user.getSubOrgIDofAffordOrg();//user.getCodeAffordOrgID()不一样啊
		String weekDate = reqDTO.getValue("weekDate");//
		String orgId = reqDTO.getValue("orgId");// 
		String subFlag = reqDTO.getValue("subFlag");// 
		String weekNum = reqDTO.getValue("weekNum");// 
		
		String fileType = reqDTO.getValue("fileType");
		
		Map dateMap = new HashMap();
		List list = new ArrayList();
		String country = "";
		String orgSubId = "";
		DecimalFormat df = new DecimalFormat();
		df.setMaximumFractionDigits(2);
		df.setMinimumFractionDigits(0);
		String line = System.getProperty("line.separator");
		String sql1 = "SELECT SUM(AI.PREPARE_NUM) PREPARE_NUM, "+
        	" SUM(AI.CONSTRUCT_NUM) CONSTRUCT_NUM, SUM(AI.END_NUM) END_NUM, "+
        	" AI.ORG_ID,  AI.WEEK_DATE FROM BGP_WR_ACQ_PROJECT_INFO AI "+
        	" WHERE AI.BSFLAG = '0'AND AI.SUBFLAG ='"+subFlag+"' AND PROJECT_TYPE = '2'" +
        	" and ai.week_date= TO_DATE('"+weekDate+"', 'yyyy-mm-dd') GROUP BY AI.ORG_ID, AI.WEEK_DATE";
		list = BeanFactory.getQueryJdbcDAO().queryRecords(sql1);
		String constructNum1 = "0";
		String prepareNum1 = "0";
		String endNum1 = "0";
		if (list != null && list.size() > 0) {
			for (int i = 0; i < list.size(); i++) {
				dateMap = (Map) list.get(i);
				if (dateMap != null) {
					orgId = (String) dateMap.get("orgId");
					if(orgId!=null && !orgId.equals("") && orgId.equals("C6000000000060"))
					{
						prepareNum1 = (String)dateMap.get("prepareNum");
						constructNum1 = (String)dateMap.get("constructNum");
						endNum1 = (String)dateMap.get("endNum");
						double pNum1 = 0;
						if(prepareNum1!=null && !prepareNum1.equals("")){
							pNum1 = pNum1 + Double.parseDouble(prepareNum1);
						}
						double cNum1 = 0;
						if(constructNum1!=null && !constructNum1.equals("")){
							cNum1 = cNum1 + Double.parseDouble(constructNum1);
						}
						double eNum1 = 0;
						if(endNum1!=null && !endNum1.equals("")){
							eNum1 = eNum1 + Double.parseDouble(endNum1);
						}
						prepareNum1 = String.valueOf(pNum1);
						constructNum1 = String.valueOf(cNum1);
						endNum1 = String.valueOf(eNum1);
					}
				}
			}
		}
		orgId = reqDTO.getValue("orgId");// 
		String sql2 = "SELECT ROUND(T2.CARRYOUT / T4.CARRYOUT * 100, 2) CARRYOUT_AS, "+
		" case when T5.COMPLETE_MONEY =0 then 100 else ROUND(T3.COMPLETE_MONEY / T5.COMPLETE_MONEY * 100, 2) end COMPLETE_MONEY_AS,T2.COUNTRY "+
			" FROM (SELECT SUM(IM.NEW_GET) NEW_GET, SUM(IM.CARRYOUT) CARRYOUT, IM.COUNTRY "+
			" FROM BGP_WR_INCOME_MONEY IM WHERE IM.BSFLAG = '0' AND IM.SUBFLAG = '"+subFlag+
			"' AND (IM.WEEK_DATE <= TO_DATE('"+weekDate+"', 'yyyy-mm-dd') AND "+
			" IM.WEEK_DATE >= TRUNC(TO_DATE('"+weekDate+"', 'yyyy-mm-dd'), 'yyyy')) "+
			" GROUP BY IM.COUNTRY) T2,(SELECT SUM(WI.COMPLETE_2d_MONEY) COMPLETE_MONEY, WI.COUNTRY "+
			" FROM BGP_WR_WORKLOAD_INFO WI WHERE WI.BSFLAG = '0' AND WI.SUBFLAG = '"+subFlag +
			"' AND (WI.WEEK_DATE <= TO_DATE('"+weekDate+"', 'yyyy-mm-dd') AND "+
			" WI.WEEK_DATE >= TRUNC(TO_DATE('"+weekDate+"', 'yyyy-mm-dd'), 'yyyy')) "+
			" GROUP BY WI.COUNTRY) T3, (SELECT SUM(IM.NEW_GET) NEW_GET, SUM(IM.CARRYOUT) CARRYOUT, "+
			" IM.COUNTRY FROM BGP_WR_INCOME_MONEY IM WHERE IM.BSFLAG = '0' AND IM.SUBFLAG = '"+subFlag +
			"' AND (IM.WEEK_DATE <= ADD_MONTHS(TO_DATE('"+weekDate+"', 'yyyy-mm-dd'), -12) AND "+
			" IM.WEEK_DATE >= ADD_MONTHS(TRUNC(TO_DATE('"+weekDate+"', 'yyyy-mm-dd'), 'yyyy'), -12)) "+
			" GROUP BY IM.COUNTRY) T4, (SELECT SUM(WI.COMPLETE_2d_MONEY) COMPLETE_MONEY, WI.COUNTRY "+
			" FROM BGP_WR_WORKLOAD_INFO WI WHERE WI.BSFLAG = '0' AND WI.SUBFLAG = '"+subFlag+
			"' AND (WI.WEEK_DATE <= ADD_MONTHS(TO_DATE('"+weekDate+"', 'yyyy-mm-dd'), -12) AND "+
			" WI.WEEK_DATE >= ADD_MONTHS(TRUNC(TO_DATE('"+weekDate+"', 'yyyy-mm-dd'), 'yyyy'), -12)) "+
			" GROUP BY WI.COUNTRY) T5 WHERE T2.COUNTRY = T3.COUNTRY AND T3.COUNTRY = T4.COUNTRY AND T5.COUNTRY = T4.COUNTRY";
		list = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		String carroutAs = "";
		String 	completeAs = "";
		double carrout = 0;
		double complete = 0;
		String tb = "增长";
		String tbComplete = "增长";
		if(list!=null && list.size()>0){
			for (int i = 0; i < list.size(); i++) {
				dateMap = (Map) list.get(i);
				if (dateMap != null) {
					carroutAs = (String) dateMap.get("carroutAs");
					if(carroutAs!=null && !carroutAs.equals("")){
						carrout = carrout + Double.valueOf(carroutAs);
					}
					completeAs = (String) dateMap.get("completeMoneyAs");
					if(completeAs!=null && !completeAs.equals("")){
						complete = complete + Double.valueOf(completeAs);
					}
				}
			}
		}
		if (carrout < 0) {
			tb = "减少";
		} else if (carrout > 0) {
			tb = "增长";
		}
		if (complete < 0) {
			tbComplete = "减少";
		} else if (complete > 0) {
			tbComplete = "增长";
		}
		String sql3 = "SELECT T.CONTENT, T.ORG_SUBJECTION_ID FROM BGP_WR_MARTANDPROJECT_INFO T "+
			" WHERE T.TYPEID = '1' AND T.BSFLAG = '0' AND T.SUBFLAG = '1' and t.org_subjection_id like 'C105024%'"+
			" and t.type='1' AND T.WEEK_DATE = TO_DATE('"+weekDate+"', 'yyyy-mm-dd')";
		list = BeanFactory.getQueryJdbcDAO().queryRecords(sql3);
		orgSubId = "";
		String content1 = "";
		if(list!=null && list.size()>0){
			for (int i = 0; i < list.size(); i++) {
				dateMap = (Map) list.get(i);
				if (dateMap != null) {
					content1 = (String)dateMap.get("content");
					if(orgSubId!=null && !content1.equals("") ){
						content1 = content1 + (String)dateMap.get("content")+ line;
					}
				}
			}
		}
		if(content1.indexOf("&")!=-1){
			content1 = content1.replaceAll("&", "and");
		}
		String sql4 = "SELECT T.CONTENT, T.ORG_SUBJECTION_ID FROM BGP_WR_MARTANDPROJECT_INFO T "+
		" WHERE T.TYPEID = '2' AND T.BSFLAG = '0' AND T.SUBFLAG = '1'"+
		" and t.type='1' AND T.WEEK_DATE = TO_DATE('"+weekDate+"', 'yyyy-mm-dd')";
		list = BeanFactory.getQueryJdbcDAO().queryRecords(sql4);
		orgSubId = "";
		String content2 = "";
		if(list!=null && list.size()>0){
			for (int i = 0; i < list.size(); i++) {
				dateMap = (Map) list.get(i);
				if (dateMap != null) {
					content2 = (String)dateMap.get("content");
					orgSubId = (String)dateMap.get("orgSubjectId");
					if(orgSubId!=null && content2!=null  && !content2.equals("")
							&& !orgSubId.equals("") && orgSubId.startsWith("C105024")){
						content2 = content2 + (Long)dateMap.get("content")+";" + line ;
					}
				}
			}
		}
		if(content2.indexOf("&")!=-1){
			content2 = content2.replaceAll("&", "and");
		}
		String sql5 = "SELECT T.CONTENT, T.ORG_SUBJECTION_ID FROM BGP_WR_MARTANDPROJECT_INFO T "+
		" WHERE T.TYPEID = '3' AND T.BSFLAG = '0' AND T.SUBFLAG = '1'"+
		" and t.type='1' AND T.WEEK_DATE = TO_DATE('"+weekDate+"', 'yyyy-mm-dd')";
		list = BeanFactory.getQueryJdbcDAO().queryRecords(sql5);
		orgSubId = "";
		String content3 = "";
		if(list!=null && list.size()>0){
			for (int i = 0; i < list.size(); i++) {
				dateMap = (Map) list.get(i);
				if (dateMap != null) {
					content3 = (String)dateMap.get("content");
					orgSubId = (String)dateMap.get("orgSubjectId");
					if(orgSubId!=null && content3!=null  && !content3.equals("")
							&& !orgSubId.equals("") && orgSubId.startsWith("C105024")){
						content3 = (Long)dateMap.get("content") + line;
						break;
					}
				}
			}
		}
		if(content3.indexOf("&")!=-1){
			content3 = content3.replaceAll("&", "and");
		}
		orgId = reqDTO.getValue("orgId");// 
		String sql6 = "SELECT M1.COUNTRY, M1.CONSTRUCT_NUM_ALL, M1.PREPARE_NUM_ALL, M1.END_NUM_ALL,"+
			" M3.END_NUM, M3.PREPARE_NUM,  M2.CONSTRUCT_NUM "+
			" FROM (SELECT DECODE(SUM(T.CONSTRUCT_NUM), NULL, 0, SUM(T.CONSTRUCT_NUM)) CONSTRUCT_NUM_ALL, "+
			" DECODE(SUM(T.PREPARE_NUM), NULL, 0, SUM(T.PREPARE_NUM)) PREPARE_NUM_ALL, "+
			" DECODE(SUM(T.END_NUM), NULL, 0, SUM(T.END_NUM)) END_NUM_ALL, T.COUNTRY "+
			" FROM BGP_WR_ACQ_PROJECT_INFO T WHERE T.BSFLAG = '0' AND T.PROJECT_TYPE = '1' AND T.SUBFLAG ='"+subFlag+
			"' AND T.ORG_SUBJECTION_ID LIKE '"+orgId+"' || '%' AND T.WEEK_DATE = TO_DATE('"+weekDate+"', 'yyyy-MM-dd') "+
			" GROUP BY T.COUNTRY) M1 LEFT OUTER JOIN (SELECT MAX(CONSTRUCT_NUM) CONSTRUCT_NUM, COUNTRY "+
			" FROM (SELECT WMSYS.WM_CONCAT(Z.CONSTRUCT_NUM) over(partition by Z.COUNTRY ORDER BY Z.CODING_SHOW_ID) CONSTRUCT_NUM,"+
			" Z.COUNTRY FROM (SELECT DECODE(SUM(T.CONSTRUCT_NUM), 0, '', OI.ORG_ABBREVIATION || "+
			" TO_CHAR(SUM(T.CONSTRUCT_NUM), 'fm999999') || '个') CONSTRUCT_NUM, T.ORG_SUBJECTION_ID, "+
			" T.COUNTRY,OS.CODING_SHOW_ID FROM BGP_WR_ACQ_PROJECT_INFO T INNER JOIN COMM_ORG_SUBJECTION OS "+
			" ON T.Org_Id = os.org_id and os.bsflag = '0' INNER JOIN COMM_ORG_INFORMATION OI "+
			" ON T.ORG_ID = OI.ORG_ID AND T.BSFLAG = '0' AND T.PROJECT_TYPE = '1' AND T.SUBFLAG = '"+subFlag+
			"' AND T.WEEK_DATE = TO_DATE('"+weekDate+"', 'yyyy-MM-dd') GROUP BY T.COUNTRY, OI.ORG_ABBREVIATION, T.ORG_SUBJECTION_ID, "+
			" OS.CODING_SHOW_ID ORDER BY OS.CODING_SHOW_ID) Z WHERE Z.ORG_SUBJECTION_ID LIKE '"+orgId+"' || '%') "+
			" GROUP BY COUNTRY) M2 ON M1.COUNTRY = M2.COUNTRY "+
			" LEFT OUTER JOIN (select max(END_NUM) END_NUM, max(PREPARE_NUM) PREPARE_NUM "+
			" from (SELECT WMSYS.WM_CONCAT(Z.END_NUM) over(order by z.CODING_SHOW_ID) END_NUM, "+
			" WMSYS.WM_CONCAT(Z.PREPARE_NUM) over(order by z.CODING_SHOW_ID) PREPARE_NUM "+
			" FROM (SELECT DECODE(SUM(T.END_NUM), 0, '',OI.ORG_ABBREVIATION || "+
			" TO_CHAR(SUM(T.END_NUM), 'fm999999') || '个') END_NUM, "+
			" DECODE(SUM(T.PREPARE_NUM),0, '', OI.ORG_ABBREVIATION || TO_CHAR(SUM(T.PREPARE_NUM), "+
			" 'fm999999') || '个') PREPARE_NUM, T.ORG_SUBJECTION_ID, OS.CODING_SHOW_ID "+
			" FROM BGP_WR_ACQ_PROJECT_INFO T INNER JOIN COMM_ORG_SUBJECTION OS ON T.Org_Id = os.org_id "+
			" and os.bsflag = '0' INNER JOIN COMM_ORG_INFORMATION OI  ON T.ORG_ID = OI.ORG_ID AND T.BSFLAG = '0' "+
			" AND T.PROJECT_TYPE = '1' AND T.SUBFLAG = '"+subFlag+"' AND T.WEEK_DATE = TO_DATE('"+weekDate+"', 'yyyy-MM-dd') "+
			" GROUP BY OI.ORG_ABBREVIATION, T.ORG_SUBJECTION_ID, OS.CODING_SHOW_ID  "+
			" ORDER BY OS.CODING_SHOW_ID) Z WHERE Z.ORG_SUBJECTION_ID LIKE '"+orgId+"' || '%')) M3 ON 1 = 1"; 
		list = BeanFactory.getQueryJdbcDAO().queryRecords(sql6);
		country = "";
		String cNumAll = "";
		int numAll = 0;
		int numAll1 = 0;
		String cNum = "";
		String num = "";
		String num1 = "";
		String prepareNumAll = "";
		int pNumAll = 0;
		String prepareNum = "";
		String pNum = "";
		String endNumAll = "";
		int eNumAll = 0;
		String endNum = "";
		String eNum = "";
		int []first6 = new int[2];
		if(list!=null && list.size()>0){
			for (int i = 0; i < list.size(); i++) {
				dateMap = (Map) list.get(i);
				if (dateMap != null) {
					cNumAll = (String) dateMap.get("constructNumAll");
					cNum = (String) dateMap.get("constructNum");
					prepareNumAll = (String)dateMap.get("prepareNumAll");
					prepareNum = (String)dateMap.get("prepareNum");
					endNumAll =(String)dateMap.get("endNumAll");
					endNum = (String)dateMap.get("endNum");
					country = (String)dateMap.get("country");
					if(cNumAll!=null && !cNumAll.equals("")&&country!=null&&country.equals("2")){
						numAll = numAll + Integer.valueOf(cNumAll);
					}
					if(cNum!=null && !cNum.equals("")&&country!=null&&country.equals("2")){
						num = num + cNum;
					}
					if(cNumAll!=null && !cNumAll.equals("")&&country!=null&&country.equals("1")){
						numAll1 = numAll1 + Integer.valueOf(cNumAll);
					}
					if(cNum!=null && !cNum.equals("")&&country!=null&&country.equals("1")){
						num1 = num1 + cNum;
					}
					if(prepareNumAll!=null && !prepareNumAll.equals("")){
						pNumAll = pNumAll + Integer.valueOf(prepareNumAll);
					}
					if(prepareNum!=null && !prepareNum.equals("")){
						if(first6[0]==0){
							pNum = pNum + prepareNum;
							first6[0] = -1;
						}
					}
					
					if(endNumAll!=null && !endNumAll.equals("")){
						eNumAll = eNumAll + Integer.valueOf(endNumAll);
					}
					if(endNum!=null && !endNum.equals("") ){
						if(first6[1] == 0){
							eNum = eNum + endNum;
							first6[1] = -1;
						}
					}
				}
			}
		}
		String sql7 = "SELECT GP.PROJECT_NAME || '(' || K.ORG_ABBREVIATION || ')：' || "+
			" Replace(T.PROJECT_CONTENT, 'km2', 'k㎡') PROJECT_CONTENT, T.ORG_SUBJECTION_ID "+ 
			" FROM BGP_WR_STRESS_PROJECT_INFO T LEFT OUTER JOIN GP_TASK_PROJECT GP ON "+
			" T.PROJECT_INFO_NO = GP.PROJECT_INFO_NO LEFT OUTER JOIN (SELECT  "+
			" WMSYS.WM_CONCAT(distinct OI.ORG_ABBREVIATION) ORG_ABBREVIATION, "+
			" GD.PROJECT_INFO_NO FROM GP_TASK_PROJECT_DYNAMIC GD INNER JOIN  "+
			" COMM_ORG_INFORMATION OI ON GD.ORG_ID = OI.ORG_ID AND OI.BSFLAG = '0' AND "+ 
			" GD.BSFLAG = '0' GROUP BY GD.PROJECT_INFO_NO) K ON T.PROJECT_INFO_NO = "+
			" K.PROJECT_INFO_NO AND GP.PROJECT_INFO_NO = T.PROJECT_INFO_NO WHERE T.BSFLAG = "+ 
			" '0' AND T.SUBFLAG = '"+subFlag+"' AND T.WEEK_DATE = TO_DATE('"+weekDate+"', 'yyyy-mm-dd') "+
			" GROUP BY GP.PROJECT_NAME, T.PROJECT_CONTENT, T.ORG_SUBJECTION_ID, K.ORG_ABBREVIATION";
		list = BeanFactory.getQueryJdbcDAO().queryRecords(sql7);
		orgSubId = "";
		String projectContent = "";		
		if(list!=null && list.size()>0){
			for (int i = 0; i < list.size(); i++) {
				dateMap = (Map) list.get(i);
				if (dateMap != null) {
					orgSubId = (String) dateMap.get("orgSubjectionId");
					orgId = user.getSubOrgIDofAffordOrg();
					String content = (String) dateMap.get("projectContent");
					if(orgSubId!=null && !orgSubId.equals("") && orgSubId.startsWith(orgId))
					{
						projectContent = content + ";" + projectContent ;
					}
					
				}
			}
		}
		if(projectContent.endsWith(";")){
			projectContent = projectContent.substring(0, projectContent.length()-1);
		}
		if(projectContent.indexOf("&")!=-1){
			projectContent = projectContent.replaceAll("&", "and");
		}
		orgId = reqDTO.getValue("orgId");// 
		String sql8 = "SELECT T.SAIL_NAME || '：' || T.SAIL_CONTENT sail_content,t.org_subjection_id "+
			" FROM BGP_WR_SAIL_INFO T WHERE T.BSFLAG = '0' AND T.SUBFLAG = '"+subFlag+"' " +
			" AND T.WEEK_DATE = TO_DATE('"+weekDate+"', 'yyyy-MM-dd')";
		list = BeanFactory.getQueryJdbcDAO().queryRecords(sql8);
		orgSubId = "";
		String sailContent = "";		
		if(list!=null && list.size()>0){
			for (int i = 0; i < list.size(); i++) {
				dateMap = (Map) list.get(i);
				if (dateMap != null) {
					orgSubId = (String) dateMap.get("orgSubjectionId");
					orgId = user.getSubOrgIDofAffordOrg();
					String content = (String) dateMap.get("sailContent");
					if(orgSubId!=null && !orgSubId.equals("") && orgSubId.startsWith(orgId))
					{
						sailContent = content + ";" + sailContent + line;
					}
				}
			}
		}
		if(sailContent.endsWith(";")){
			sailContent = sailContent.substring(0, sailContent.length()-1);
		}
		if(sailContent.indexOf("&")!=-1){
			sailContent = sailContent.replaceAll("&", "and");
		}
		orgId = reqDTO.getValue("orgId");// 
		String sql9 = "SELECT NVL(T.YEAR_2D_WORKLOAD, 0) YEAR_2D_WORKLOAD, NVL(T.YEAR_3D_WORKLOAD, 0) "+
			" YEAR_3D_WORKLOAD, T.ORG_ID, NVL(M.PREPARE_NUM, 0) PREPARE_NUM, "+
			" NVL(M.CONSTRUCT_NUM, 0) CONSTRUCT_NUM, NVL(M.END_NUM, 0) END_NUM FROM (SELECT "+ 
			" Z.WEEK_DATE, Z.ORG_ID, SUM(Z.YEAR_2D_WORKLOAD) YEAR_2D_WORKLOAD, "+
			" SUM(Z.YEAR_3D_WORKLOAD) YEAR_3D_WORKLOAD FROM BGP_WR_WORKLOAD_INFO Z WHERE "+ 
			" Z.BSFLAG = '0' AND Z.SUBFLAG = '"+subFlag+"' GROUP BY Z.WEEK_DATE, Z.ORG_ID) T LEFT OUTER "+ 
			" JOIN (SELECT SUM(AI.PREPARE_NUM) PREPARE_NUM, SUM(AI.CONSTRUCT_NUM) "+
			" CONSTRUCT_NUM, SUM(AI.END_NUM) END_NUM, AI.ORG_ID, AI.WEEK_DATE FROM "+
			" BGP_WR_ACQ_PROJECT_INFO AI WHERE AI.BSFLAG = '0' AND AI.SUBFLAG = '"+subFlag+"' AND "+ 
			" PROJECT_TYPE = '1' GROUP BY AI.ORG_ID, AI.WEEK_DATE) M ON T.ORG_ID = M.ORG_ID "+ 
			" AND T.WEEK_DATE = M.WEEK_DATE WHERE T.WEEK_DATE = TO_DATE('"+weekDate+"', 'yyyy-mm-dd')";
		List list9 = BeanFactory.getQueryJdbcDAO().queryRecords(sql9);
		
		String sql10 = "SELECT T.ORG_ID, T.PROJECT_NAME, T.MANAGE_ORG, T.TEAM_NAME, T.DESIGN_WORKLOAD, "+ 
			" T.COMPLETE_WORKLOAD, T.SCHEDULE, T.PROJECT_STATUS, T.NOTES, t.project_type, "+ 
			" t.project_note FROM BGP_WR_PROJECT_DYNAMIC T WHERE T.BSFLAG = '0' "+
			" AND T.SUBFLAG = '"+subFlag+"'  AND T.WEEK_DATE= TO_DATE('"+weekDate+"','yyyy-mm-dd')";
		List list10 = BeanFactory.getQueryJdbcDAO().queryRecords(sql10);
		
		String sql11 = "SELECT T.PROJECT_NAME || '：' || Replace(T.PROJECT_NOTE, 'km2', 'k㎡') "+
			" PROJECT_NOTE,T.Org_Subjection_Id FROM BGP_WR_PROJECT_DYNAMIC T WHERE T.BSFLAG ='0' "+
			" AND T.SUBFLAG = '"+subFlag+"' AND T.WEEK_DATE = TO_DATE('"+weekDate+"', 'yyyy-mm-dd') AND  T.PROJECT_TYPE = '4'";
		list = BeanFactory.getQueryJdbcDAO().queryRecords(sql11);
//		StringBuffer projectNote = new StringBuffer();
		List projectNotes = new ArrayList();
		if(list!=null && list.size()>0){
			for (int i = 0; i < list.size(); i++) {
				dateMap = (Map) list.get(i);
				if (dateMap != null) {
					orgSubId = (String) dateMap.get("orgSubjectionId");
					orgId = user.getSubOrgIDofAffordOrg();
					String projectNoteTmp = (String) dateMap.get("projectNote");
					if(orgSubId!=null && !orgSubId.equals("") && orgSubId.startsWith(orgId))
					{
						projectNotes.add(projectNoteTmp);
					}
				}
			}
		}
		
		/*Pattern p = Pattern.compile(line);
        Matcher m = p.matcher(projectNote);
        projectNote = m.toString().substring(0, projectNote.length()-line.length());*/
		orgId = reqDTO.getValue("orgId");// 
		String sql12 = "SELECT t.complexion,t.org_subjection_id FROM BGP_WR_HOLD_INFO T WHERE T.BSFLAG = '0' "+
			" AND T.SUBFLAG = '"+subFlag+"' AND T.WEEK_DATE = TO_DATE('"+weekDate+"', 'yyyy-mm-dd')";
		list = BeanFactory.getQueryJdbcDAO().queryRecords(sql12);
		String complexion = "";
		if(list!=null && list.size()>0){
			for (int i = 0; i < list.size(); i++) {
				dateMap = (Map) list.get(i);
				if (dateMap != null) {
					orgSubId = (String) dateMap.get("orgSubjectionId");
					orgId = user.getSubOrgIDofAffordOrg();
					String content = (String) dateMap.get("complexion");
					if(orgSubId!=null && !orgSubId.equals("") && orgSubId.startsWith(orgId))
					{
						complexion = content + ";" +complexion + line;
					}
				}
			}
		}
		if(complexion.indexOf("&")!=-1){
			complexion = complexion.replaceAll("&", "and");
		}
		String sql13 = "SELECT '不正常原因:'||WMSYS.WM_CONCAT(T.REASON) REASON, T.org_id FROM "+
			" BGP_WR_PROJECT_DYNAMIC T WHERE T.BSFLAG = '0' AND T.SUBFLAG = '"+subFlag+"' AND T.WEEK_DATE "+
			" = TO_DATE('"+weekDate+"', 'yyyy-mm-dd') AND T.REASON IS NOT NULL GROUP BY T.org_id";
		List  list13 = BeanFactory.getQueryJdbcDAO().queryRecords(sql13);
		
		String sql14 = "SELECT M.COUNTRY, M.DEVICE_NAME, M.ORG_SUBJECTION_ID, SUM(TOTAL_NUM) TOTAL_NUM, "+ 
			" SUM(USE_NUM) USE_NUM, SUM(PLAN_NUM) PLAN_NUM, SUM(TRUSFER_NUM) TRUSFER_NUM, "+
			" SUM(SAFETY_NUM) SAFETY_NUM, SUM(TOTAL_NUM_S) TOTAL_NUM_S, SUM(USE_NUM_S) "+
			" USE_NUM_S, SUM(PLAN_NUM_S) PLAN_NUM_S, SUM(TRUSFER_NUM_S) TRUSFER_NUM_S, "+
			" SUM(SAFETY_NUM_S) SAFETY_NUM_S, SUM(NOTUSE_NUM) NOTUSE_NUM, SUM(NOTUSE_NUM_S) "+ 
			" NOTUSE_NUM_S, SUM(USE_RATE) USE_RATE, SUM(OCCUPY_RATE) OCCUPY_RATE FROM (SELECT "+ 
			" Z1.ORG_SUBJECTION_ID, Z1.COUNTRY, Z1.DEVICE_NAME, Z1.TOTAL_NUM, Z1.USE_NUM, "+
			" Z1.PLAN_NUM, Z1.TRUSFER_NUM, Z1.SAFETY_NUM, Z1.NOTUSE_NUM, Z2.TOTAL_NUM "+
			" TOTAL_NUM_S, Z2.USE_NUM USE_NUM_S, Z2.PLAN_NUM PLAN_NUM_S, Z2.TRUSFER_NUM "+
			" TRUSFER_NUM_S, Z2.SAFETY_NUM SAFETY_NUM_S, Z2.NOTUSE_NUM NOTUSE_NUM_S, "+
			" Z1.USE_RATE, Z1.OCCUPY_RATE, Z1.WEEK_DATE FROM (SELECT T.ORG_SUBJECTION_ID, "+ 
			" T.COUNTRY, SD.CODING_NAME DEVICE_NAME, T.TOTAL_NUM, T.USE_NUM, T.PLAN_NUM, "+
			" T.TRUSFER_NUM, T.SAFETY_NUM, T.NOTUSE_NUM, T.WEEK_DATE, T.USE_RATE, "+
			" T.OCCUPY_RATE FROM BGP_WR_INSTRUMENT_INFO T INNER JOIN COMM_CODING_SORT_DETAIL SD "+ 
			" ON T.EQUIPMENT_TYPE = SD.CODING_CODE_ID AND SD.BSFLAG = '0' AND T.BSFLAG ='0' "+
			" AND T.SUBFLAG = '"+subFlag+"' WHERE T.INSTRUMENT_TYPE = '1') Z1 INNER JOIN (SELECT "+
			" T.ORG_SUBJECTION_ID, T.COUNTRY, SD.CODING_NAME DEVICE_NAME, T.TOTAL_NUM, "+
			" T.USE_NUM, T.PLAN_NUM, T.TRUSFER_NUM, T.SAFETY_NUM, T.NOTUSE_NUM, T.WEEK_DATE "+ 
			" FROM BGP_WR_INSTRUMENT_INFO T INNER JOIN COMM_CODING_SORT_DETAIL SD ON "+
			" T.EQUIPMENT_TYPE = SD.CODING_CODE_ID AND SD.BSFLAG = '0' AND T.BSFLAG = '0' AND "+ 
			" T.SUBFLAG = '"+subFlag+"' WHERE T.INSTRUMENT_TYPE = '2') Z2 ON Z1.ORG_SUBJECTION_ID = "+
			" Z2.ORG_SUBJECTION_ID AND Z1.COUNTRY = Z2.COUNTRY AND Z1.DEVICE_NAME = Z2.DEVICE_NAME " +
			" AND Z1.WEEK_DATE = Z2.WEEK_DATE AND Z1.WEEK_DATE = TO_DATE('"+weekDate+"','yyyy-mm-dd')) M " +
			" GROUP BY M.COUNTRY, M.DEVICE_NAME, M.ORG_SUBJECTION_ID order by M.DEVICE_NAME";
		List list14 = BeanFactory.getQueryJdbcDAO().queryRecords(sql14);
		double []sum127 = new double[11];
		List deviceList = new ArrayList();
		if(list14!=null && list14.size()>0){
			for (int i = 0; i < list14.size(); i++) {
				dateMap = (Map) list14.get(i);
				if (dateMap != null) {
					orgSubId = (String) dateMap.get("orgSubjectionId");
					orgId = user.getSubOrgIDofAffordOrg();
					country = (String)dateMap.get("country");
					if(country!=null && orgSubId!=null && !country.equals("") && !orgSubId.equals("") 
					   && country.equals("2") && orgSubId.startsWith(orgId))
					{
						String deviceName = (String)dateMap.get("deviceName");
						if(deviceList == null){
							deviceList.add(dateMap);
						}
						int j = 0;
						for( j= 0; j < deviceList.size(); j++){
							Map map = (Map)deviceList.get(j);
							String device = (String)map.get("deviceName");
							if(device!=null && deviceName!=null){
								if(device.equals(deviceName)){
									break;
								}
							}
						}
						if(j == deviceList.size()){
							deviceList.add(dateMap);
						}
					}
					
				}
			}
		}
		List deviceList137 = new ArrayList();
		if(list14!=null && list14.size()>0){
			for (int i = 0; i < list14.size(); i++) {
				dateMap = (Map) list14.get(i);
				if (dateMap != null) {
					orgSubId = (String) dateMap.get("orgSubjectionId");
					country = (String)dateMap.get("country");
					if(country!=null && orgSubId!=null && !country.equals("") && !orgSubId.equals("") 
					   && country.equals("1") && !orgSubId.startsWith("C105007") && !orgSubId.startsWith("C105063"))
					{
						String deviceName = (String)dateMap.get("deviceName");
						if(deviceList137 == null){
							deviceList137.add(dateMap);
						}
						int j = 0;
						for( j= 0; j < deviceList137.size(); j++){
							Map map = (Map)deviceList137.get(j);
							String device = (String)map.get("deviceName");
							if(device!=null && deviceName!=null){
								if(device.equals(deviceName)){
									break;
								}
							}
						}
						if(j == deviceList137.size()){
							deviceList137.add(dateMap);
						}
					}
					
				}
			}
		}
		List deviceList147 = new ArrayList();
		if(list14!=null && list14.size()>0){
			for (int i = 0; i < list14.size(); i++) {
				dateMap = (Map) list14.get(i);
				if (dateMap != null) {
					orgSubId = (String) dateMap.get("orgSubjectionId");
					country = (String)dateMap.get("country");
					if(country!=null && orgSubId!=null && !country.equals("") && !orgSubId.equals("") 
					   && country.equals("0") && orgSubId.startsWith("C105007"))
					{
						String deviceName = (String)dateMap.get("deviceName");
						if(deviceList147 == null){
							deviceList147.add(dateMap);
						}
						int j = 0;
						for( j= 0; j < deviceList147.size(); j++){
							Map map = (Map)deviceList147.get(j);
							String device = (String)map.get("deviceName");
							if(device!=null && deviceName!=null){
								if(device.equals(deviceName)){
									break;
								}
							}
						}
						if(j == deviceList147.size()){
							deviceList147.add(dateMap);
						}
					}
					
				}
			}
		}
		List deviceList152 = new ArrayList();
		if(list14!=null && list14.size()>0){
			for (int i = 0; i < list14.size(); i++) {
				dateMap = (Map) list14.get(i);
				if (dateMap != null) {
					orgSubId = (String) dateMap.get("orgSubjectionId");
					country = (String)dateMap.get("country");
					if(country!=null && orgSubId!=null && !country.equals("") && !orgSubId.equals("") 
					   && country.equals("0") && orgSubId.startsWith("C105063"))
					{
						String deviceName = (String)dateMap.get("deviceName");
						if(deviceList152 == null){
							deviceList152.add(dateMap);
						}
						int j = 0;
						for( j= 0; j < deviceList152.size(); j++){
							Map map = (Map)deviceList152.get(j);
							String device = (String)map.get("deviceName");
							if(device!=null && deviceName!=null){
								if(device.equals(deviceName)){
									break;
								}
							}
						}
						if(j == deviceList152.size()){
							deviceList152.add(dateMap);
						}
					}
					
				}
			}
		}
		orgId = reqDTO.getValue("orgId");// 
		String sql15 = "SELECT T.TOTAL_NUM, T.USE_NUM, T.SAFETY_NUM, T.PLAN_NUM, T.EXLAIN_INFO, "+
			" T.Org_Subjection_Id, T.COUNTRY, T.TYPEID, T.TRUSFER_NUM, SD.CODING_NAME "+
			" DEVICE_NAME FROM BGP_WR_FOCUS_INFO T INNER JOIN COMM_CODING_SORT_DETAIL SD ON "+ 
			" T.EQUIPMENT_TYPE = SD.CODING_CODE_ID WHERE T.BSFLAG = '0' AND T.SUBFLAG = '"+subFlag+ 
			"' AND T.WEEK_DATE = TO_DATE('"+weekDate+"', 'yyyy-mm-dd') order by SD.CODING_NAME ";
		list = BeanFactory.getQueryJdbcDAO().queryRecords(sql15);
		double []sum131 = new double[4];
		List deviceList15 = new ArrayList();
		if(list!=null && list.size()>0){
			for (int i = 0; i < list.size(); i++) {
				dateMap = (Map) list.get(i);
				if (dateMap != null) {
					orgSubId = (String) dateMap.get("orgSubjectionId");
					orgId = user.getSubOrgIDofAffordOrg();
					country = (String)dateMap.get("country");
					if(country!=null && orgSubId!=null && !country.equals("") && !orgSubId.equals("") 
					   && country.equals("2") && orgSubId.startsWith(orgId)){
						String deviceName = (String)dateMap.get("deviceName");
						if(deviceList15 == null){
							deviceList15.add(dateMap);
						}
						int j = 0;
						for( j= 0; j < deviceList15.size(); j++){
							Map map = (Map)deviceList15.get(j);
							String device = (String)map.get("deviceName");
							if(device!=null && deviceName!=null){
								if(device.equals(deviceName)){
									break;
								}
							}
						}
						if(j == deviceList15.size()){
							deviceList15.add(dateMap);
						}
					}
					
				}
			}
		}
		List deviceList140 = new ArrayList();
		if(list!=null && list.size()>0){
			for (int i = 0; i < list.size(); i++) {
				dateMap = (Map) list.get(i);
				if (dateMap != null) {
					orgSubId = (String) dateMap.get("orgSubjectionId");
					orgId = user.getSubOrgIDofAffordOrg();
					country = (String)dateMap.get("country");
					String typeid = (String)dateMap.get("typeid");
					if(country!=null && orgSubId!=null && typeid!=null && !country.equals("") 
						&& !orgSubId.equals("") && !typeid.equals("") && typeid.equals("2")
					   && country.equals("1") && orgSubId.startsWith(orgId)){
						String deviceName = (String)dateMap.get("deviceName");
						if(deviceList140 == null){
							deviceList140.add(dateMap);
						}
						int j = 0;
						for( j= 0; j < deviceList140.size(); j++){
							Map map = (Map)deviceList140.get(j);
							String device = (String)map.get("deviceName");
							if(device!=null && deviceName!=null){
								if(device.equals(deviceName)){
									break;
								}
							}
						}
						if(j == deviceList140.size()){
							deviceList140.add(dateMap);
						}
					}
					
				}
			}
		}
		List deviceList141 = new ArrayList();
		if(list!=null && list.size()>0){
			for (int i = 0; i < list.size(); i++) {
				dateMap = (Map) list.get(i);
				if (dateMap != null) {
					orgSubId = (String) dateMap.get("orgSubjectionId");
					orgId = user.getSubOrgIDofAffordOrg();
					country = (String)dateMap.get("country");
					String typeid = (String)dateMap.get("typeid");
					if(country!=null && orgSubId!=null && typeid!=null && !country.equals("") 
						&& !orgSubId.equals("") && !typeid.equals("") && typeid.equals("1")
					   && country.equals("1") && orgSubId.startsWith(orgId)){
						String deviceName = (String)dateMap.get("deviceName");
						if(deviceList141 == null){
							deviceList141.add(dateMap);
						}
						int j = 0;
						for( j= 0; j < deviceList141.size(); j++){
							Map map = (Map)deviceList141.get(j);
							String device = (String)map.get("deviceName");
							if(device!=null && deviceName!=null){
								if(device.equals(deviceName)){
									break;
								}
							}
						}
						if(j == deviceList141.size()){
							deviceList141.add(dateMap);
						}
					}
					
				}
			}
		}
		orgId = reqDTO.getValue("orgId");// 
		String sql16 = "SELECT OI.ORG_ABBREVIATION, WMSYS.WM_CONCAT(T.SERVICE_INFO) SERVICE_INFO, "+
			" T.USER_NUM, T.STOCK_NUM, T.ORG_SUBJECTION_ID FROM BGP_WR_MATERIAL_INFO T INNER "+
			" JOIN COMM_ORG_INFORMATION OI ON T.ORG_ID = OI.ORG_ID AND OI.BSFLAG = '0' WHERE "+
			" T.BSFLAG = '0' AND T.SUBFLAG = '"+subFlag+"' AND T.WEEK_DATE = TO_DATE('"+weekDate+"', 'yyyy-mm-dd') "+
			" GROUP BY OI.ORG_ABBREVIATION, T.USER_NUM, T.STOCK_NUM, T.ORG_SUBJECTION_ID";
		list = BeanFactory.getQueryJdbcDAO().queryRecords(sql16);
		List deviceList156 = new ArrayList();
		if(list!=null && list.size()>0){
			for (int i = 0; i < list.size(); i++) {
				dateMap = (Map) list.get(i);
				if (dateMap != null) {
					orgSubId = (String) dateMap.get("orgSubjectionId");
					orgId = user.getSubOrgIDofAffordOrg();
					country = (String)dateMap.get("country");
					if(orgSubId!=null  && !orgSubId.equals("") && orgSubId.startsWith(orgId)){
						deviceList156.add(dateMap);
					}
					
				}
			}
		}
		orgId = reqDTO.getValue("orgId");// 
		String sql17 = "SELECT SUM(T.SERVICE_PROJECT_NUM) SERVICE_PROJECT_NUM, SUM(T.START_PROJECT_NUM) "+ 
			" START_PROJECT_NUM, t.org_subjection_id FROM BGP_WR_MATERIAL_INFO T WHERE "+
			" T.BSFLAG = '0' AND T.SUBFLAG = '"+subFlag+"' AND T.WEEK_DATE = TO_DATE('"+weekDate+"', 'yyyy-mm-dd') "+ 
			" group by t.org_subjection_id ";
		list = BeanFactory.getQueryJdbcDAO().queryRecords(sql17);
		String serviceProjectNum = "0";
		String startProjectNum = "0";
		int serviceNum = 0;
		int startNum = 0;
		String C157 = "正在服务项目";
		if(list!=null && list.size()>0){
			for (int i = 0; i < list.size(); i++) {
				dateMap = (Map) list.get(i);
				if (dateMap != null) {
					orgSubId = (String) dateMap.get("orgSubjectionId");
					orgId = user.getSubOrgIDofAffordOrg();
					serviceProjectNum = (String)dateMap.get("serviceProjectNum");
					startProjectNum = (String)dateMap.get("startProjectNum");
					if(serviceProjectNum!=null ){
						serviceProjectNum = serviceProjectNum.trim();
						if(!serviceProjectNum.equals("")){
							serviceNum = serviceNum + Integer.valueOf(serviceProjectNum);
						}
					}
					if(startProjectNum!=null ){
						startProjectNum = startProjectNum.trim();
						if(!startProjectNum.equals(""))
						startNum = startNum + Integer.valueOf(startProjectNum);
					}
				}
			}
			
		}
		C157 = C157 + serviceNum +"个，其中启动准备项目" + startNum +"个.";
		if(C157.indexOf("&")!=-1){
			C157 = C157.replaceAll("&", " and ");
		}
		orgId = reqDTO.getValue("orgId");// 
		String sql18 = "SELECT to_number(TO_CHAR(TO_DATE('"+weekDate+"', 'yyyy-mm-dd'), 'mm')) || '月' || " +
				" to_number(TO_CHAR(TO_DATE('"+weekDate+"', 'yyyy-mm-dd'), 'dd')) || '日' START_DATE, "+
				" to_number(TO_CHAR(TO_DATE('"+weekDate+"', 'yyyy-mm-dd') + 6, 'mm')) || '月' || "+
				" to_number(TO_CHAR(TO_DATE('"+weekDate+"', 'yyyy-mm-dd') + 6, 'dd')) || '日' END_DATE, "+
				" to_number(TO_CHAR(SYSDATE, 'yyyy')) || '年' || to_number(TO_CHAR(SYSDATE, 'mm')) || '月' || "+
				" to_number(TO_CHAR(SYSDATE, 'dd')) || '日' NOW_DATE,  "+
				" Trunc((Trunc(Next_Day(TO_DATE('"+weekDate+"','yyyy-mm-dd'), 2))- Next_Day(Trunc(TO_DATE('"+
				 weekDate+"', 'yyyy-mm-dd'), 'YY'),2))/7)-(-2) weeks FROM DUAL";
		dateMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql18);
		String startDate = "";
		String endDate = "";
		String nowDate = "";
		if(dateMap!=null){
			startDate = (String) dateMap.get("startDate");
			endDate = (String) dateMap.get("endDate");
			nowDate = (String) dateMap.get("nowDate");
		}
		String sql19 = "SELECT BYE.ORG_SUBJECTION_ID, SUM(BYE.BUDGET_MONEY) BUDGET_MONEY "+
			" FROM BGP_WR_BUDGET_YEAR BYE "+
			" WHERE BYE.YEAR = TO_CHAR(TO_DATE('"+weekDate+"', 'yyyy-mm-dd'), 'yyyy') "+
			" AND BYE.BSFLAG = '0' "+
			" AND BYE.SUBFLAG = '1' "+
			" GROUP BY BYE.ORG_SUBJECTION_ID";
		list = BeanFactory.getQueryJdbcDAO().queryRecords(sql19);
		String budget = "";
		double []C = new double[38];
		int []first = new int[4];
		for(int i =0;i<4;i++){
			first[i] = 0;
		}
		if(list!=null &&list.size()>0){
			for(int i =0;i<list.size();i++){
				dateMap = (Map)list.get(i);
				budget = (String) dateMap.get("budgetMoney");
				orgSubId = (String) dateMap.get("orgSubjectionId");
				if(orgSubId!=null&&!orgSubId.equals("")&&orgSubId.startsWith(affordOrg)){
					if(budget!=null ){
						budget = budget.trim();
						if (!budget.equals("")) {
							if (orgSubId.startsWith("C105002")) {

								C[14] = C[14] + Double.valueOf(budget);
							}
							if (orgSubId.startsWith("C105001005")) {
								C[15] = C[15] + Double.valueOf(budget);
							}
							if (orgSubId.startsWith("C105001002")) {
								C[16] = C[16] + Double.valueOf(budget);
							}
							if (orgSubId.startsWith("C105001003")) {
								C[17] = C[17] + Double.valueOf(budget);
							}
							if (orgSubId.startsWith("C105001004")) {
								C[18] = C[18] + Double.valueOf(budget);
							}
							if (orgSubId.startsWith("C105005004")) {
								C[19] = C[19] + Double.valueOf(budget);
							}
							if (orgSubId.startsWith("C105005000")) {
								C[20] = C[20] + Double.valueOf(budget);
							}
							if (orgSubId.startsWith("C105005001")) {
								C[21] = C[21] + Double.valueOf(budget);
							}
							if (orgSubId.startsWith("C105007") ) {
								if(first[0] == 0){
									C[22] = C[22] + Double.valueOf(budget);
									first[0] = -1;
								}
							}
							if (orgSubId.startsWith("C105063") ) {
								if (first[1] == 0) {
									C[24] = C[24] + Double.valueOf(budget);
									first[1] = -1;
								}
							}
							if (orgSubId.startsWith("C105003") ) {
								if (first[2] == 0) {
									C[26] = C[26] + Double.valueOf(budget);
									first[2] = -1;
								}
							}
							if (orgSubId.startsWith("C105008") ) {
								if (first[3] == 0) {
									C[28] = C[28] + Double.valueOf(budget);
									first[3] = -1;
								}
							}
							if (orgSubId.startsWith("C105006")) {
								C[32] = C[32] + Double.valueOf(budget);
							}
							if (orgSubId.startsWith("C105004")) {
								C[33] = C[33] + Double.valueOf(budget);
							}
							if (orgSubId.startsWith("C105014")) {
								C[34] = C[34] + Double.valueOf(budget);
							}
							if (orgSubId.startsWith("C105016")) {
								C[35] = C[35] + Double.valueOf(budget);
							}
							if (orgSubId.startsWith("C105079001")) {
								C[36] = C[36] + Double.valueOf(budget);
							}
						}
					}
				}
			}
			C[30] = C[14] + C[15] + C[16] + C[17] + C[18] + C[19] + C[20] + C[21] + C[22] + C[24] + C[26] + C[28];
			C[37] = C[30] + C[32] + C[33] + C[34] + C[35] + C[36];
		}
		orgId = reqDTO.getValue("orgId");// 
		String sql20 = "SELECT IM.COUNTRY, IM.NEW_GET, IM.CARRYOUT, IM.ORG_SUBJECTION_ID FROM "+
			" BGP_WR_INCOME_MONEY IM WHERE IM.BSFLAG = '0' AND IM.SUBFLAG = '1' and im.type = '1' "+
			" and im.org_type = '1' AND IM.WEEK_DATE = TO_DATE('"+weekDate+"', 'yyyy-mm-dd')";
		list = BeanFactory.getQueryJdbcDAO().queryRecords(sql20);
//		dateMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql20);
		
		String newGet = "";
		String carryout = "";
		//累计落实(万元)
		double []D = new double[38];
		
		//累计新签(万元)
		double []E = new double[38];
		
		//为预算收入％
		double []F = new double[38];
		if(list!=null &&list.size()>0){
			for(int i =0;i<list.size();i++){
				dateMap = (Map)list.get(i);
				country = (String) dateMap.get("country");
				newGet = (String) dateMap.get("newGet");
				carryout = (String) dateMap.get("carryout");
				orgSubId = (String) dateMap.get("orgSubjectionId");
				if(orgSubId!=null&&!orgSubId.equals("")&&orgSubId.startsWith(affordOrg)){
					if(newGet!=null ){
						newGet = newGet.trim();
						if (!newGet.equals("")) {
							if (orgSubId.startsWith("C105002")) {
								D[14] = D[14] + Double.valueOf(newGet);
							}
							if (orgSubId.startsWith("C105001005")) {
								D[15] = D[15] + Double.valueOf(newGet);
							}
							if (orgSubId.startsWith("C105001002")) {
								D[16] = D[16] + Double.valueOf(newGet);
							}
							if (orgSubId.startsWith("C105001003")) {
								D[17] = D[17] + Double.valueOf(newGet);
							}
							if (orgSubId.startsWith("C105001004")) {
								D[18] = D[18] + Double.valueOf(newGet);
							}
							if (orgSubId.startsWith("C105005004")) {
								D[19] = D[19] + Double.valueOf(newGet);
							}
							if (orgSubId.startsWith("C105005000")) {
								D[20] = D[20] + Double.valueOf(newGet);
							}
							if (orgSubId.startsWith("C105005001")) {
								D[21] = D[21] + Double.valueOf(newGet);
							}
							if (orgSubId.startsWith("C105007")
									&& country != null && country.equals("2")) {
								D[22] = D[22] + Double.valueOf(newGet);
							}
							if (orgSubId.startsWith("C105007")
									&& country != null && country.equals("1")) {
								D[23] = D[23] + Double.valueOf(newGet);
							}
							if (orgSubId.startsWith("C105063")
									&& country != null && country.equals("2")) {
								D[24] = D[24] + Double.valueOf(newGet);
							}
							if (orgSubId.startsWith("C105063")
									&& country != null && country.equals("1")) {
								D[25] = D[25] + Double.valueOf(newGet);
							}
							if (orgSubId.startsWith("C105003")
									&& country != null && country.equals("2")) {
								D[26] = D[26] + Double.valueOf(newGet);
							}
							if (orgSubId.startsWith("C105003")
									&& country != null && country.equals("1")) {
								D[27] = D[27] + Double.valueOf(newGet);
							}
							if (orgSubId.startsWith("C105008")
									&& country != null && country.equals("2")) {
								D[28] = D[28] + Double.valueOf(newGet);
							}
							if (orgSubId.startsWith("C105008")
									&& country != null && country.equals("1")) {
								D[29] = D[29] + Double.valueOf(newGet);
							}
							if (orgSubId.startsWith("C105006")) {
								D[32] = D[32] + Double.valueOf(newGet);
							}
							if (orgSubId.startsWith("C105004")) {
								D[33] = D[33] + Double.valueOf(newGet);
							}
							if (orgSubId.startsWith("C105014")) {
								D[34] = D[34] + Double.valueOf(newGet);
							}
							if (orgSubId.startsWith("C105016")) {
								D[35] = D[35] + Double.valueOf(newGet);
							}
							if (orgSubId.startsWith("C105079001")) {
								D[36] = D[36] + Double.valueOf(newGet);
							}
						}
					}
					if(carryout!=null ){
						carryout = carryout.trim();
						if (!carryout.equals("")) {
							if (orgSubId.startsWith("C105002")) {
								E[14] = E[14] + Double.valueOf(carryout);
							}
							if (orgSubId.startsWith("C105001005")) {
								E[15] = E[15] + Double.valueOf(carryout);
							}
							if (orgSubId.startsWith("C105001002")) {
								E[16] = E[16] + Double.valueOf(carryout);
							}
							if (orgSubId.startsWith("C105001003")) {
								E[17] = E[17] + Double.valueOf(carryout);
							}
							if (orgSubId.startsWith("C105001004")) {
								E[18] = E[18] + Double.valueOf(carryout);
							}
							if (orgSubId.startsWith("C105005004")) {
								E[19] = E[19] + Double.valueOf(carryout);
							}
							if (orgSubId.startsWith("C105005000")) {
								E[20] = E[20] + Double.valueOf(carryout);
							}
							if (orgSubId.startsWith("C105005001")) {
								E[21] = E[21] + Double.valueOf(carryout);
							}
							if (orgSubId.startsWith("C105007")
									&& country != null && country.equals("2")) {
								E[22] = E[22] + Double.valueOf(carryout);
							}
							if (orgSubId.startsWith("C105007")
									&& country != null && country.equals("1")) {
								E[23] = E[23] + Double.valueOf(carryout);
							}
							if (orgSubId.startsWith("C105063")
									&& country != null && country.equals("2")) {
								E[24] = E[24] + Double.valueOf(carryout);
							}
							if (orgSubId.startsWith("C105063")
									&& country != null && country.equals("1")) {
								E[25] = E[25] + Double.valueOf(carryout);
							}
							if (orgSubId.startsWith("C105003")
									&& country != null && country.equals("2")) {
								E[26] = E[26] + Double.valueOf(carryout);
							}
							if (orgSubId.startsWith("C105003")
									&& country != null && country.equals("1")) {
								E[27] = E[27] + Double.valueOf(carryout);
							}
							if (orgSubId.startsWith("C105008")
									&& country != null && country.equals("2")) {
								E[28] = E[28] + Double.valueOf(carryout);
							}
							if (orgSubId.startsWith("C105008")
									&& country != null && country.equals("1")) {
								E[29] = E[29] + Double.valueOf(carryout);
							}
							if (orgSubId.startsWith("C105006")) {
								E[32] = E[32] + Double.valueOf(carryout);
							}
							if (orgSubId.startsWith("C105004")) {
								E[33] = E[33] + Double.valueOf(carryout);
							}
							if (orgSubId.startsWith("C105014")) {
								E[34] = E[34] + Double.valueOf(carryout);
							}
							if (orgSubId.startsWith("C105016")) {
								E[35] = E[35] + Double.valueOf(carryout);
							}
							if (orgSubId.startsWith("C105079001")) {
								E[36] = E[36] + Double.valueOf(carryout);
							}
						}
					}
				}
			}
			D[30] = D[14] + D[22] + D[24] + D[26] + D[28];
			D[31] = D[15] + D[16] + D[17] + D[18] + D[19] + D[20] + D[21] + D[23] + D[25] + D[27] + D[29];
			D[37] = D[30] + D[31] + D[32] + D[33] + D[34] + D[35] + D[36];
			E[30] = E[14] + E[22] + E[24] + E[26] + E[28];
			E[31] = E[15] + E[16] + E[17] + E[18] + E[19] + E[20] + E[21] + E[23] + E[25] + E[27] + E[29];
			E[37] = E[30] + E[31] + E[32] + E[33] + E[34] + E[35] + E[36];
			if(C[14] != 0 ){
				F[14] = E[14] / C[14] *100;
				F[14] = Double.valueOf(df.format(F[14]).replace(",", ""));
			}
			if(C[15] != 0 ){
				F[15] = E[15] / C[15] *100;
				F[15] = Double.valueOf(df.format(F[15]).replace(",", ""));
			}
			if(C[16] != 0 ){
				F[16] = E[16] / C[16] *100;
				F[16] = Double.valueOf(df.format(F[16]).replace(",", ""));
			}
			if(C[17] != 0 ){
				F[17] = E[17] / C[17] *100;
				F[17] = Double.valueOf(df.format(F[17]).replace(",", ""));
			}
			if(C[18] != 0 ){
				F[18] = E[18] / C[18] *100;
				F[18] = Double.valueOf(df.format(F[18]).replace(",", ""));
			}
			if(C[19] != 0 ){
				F[19] = E[19] / C[19] *100;
				F[19] = Double.valueOf(df.format(F[19]).replace(",", ""));
			}
			if(C[20] != 0 ){
				F[20] = E[20] / C[20] *100;
				F[20] = Double.valueOf(df.format(F[20]).replace(",", ""));
			}
			if(C[21] != 0 ){
				F[21] = E[21] / C[21] *100;
				F[21] = Double.valueOf(df.format(F[21]).replace(",", ""));
			}
			if(C[22] != 0 ){
				F[22] = (E[22] +E[23])/ C[22] *100;
				F[22] = Double.valueOf(df.format(F[22]).replace(",", ""));
			}
			if(C[24] != 0 ){
				F[24] = (E[24] +E[25])/ C[24] *100;
				F[24] = Double.valueOf(df.format(F[24]).replace(",", ""));
			}
			if(C[26] != 0 ){
				F[26] = (E[26] +E[27])/ C[26] *100;
				F[26] = Double.valueOf(df.format(F[26]).replace(",", ""));
			}
			if(C[28] != 0 ){
				F[28] = (E[28] +E[29])/ C[28] *100;
				F[28] = Double.valueOf(df.format(F[28]).replace(",", ""));
			}
			if(C[30] != 0 ){
				F[30] = (E[30] + E[31])/ C[30] *100;
				F[30] = Double.valueOf(df.format(F[30]).replace(",", ""));
			}
			if(C[32] != 0 ){
				F[32] = E[32] / C[32] *100;
				F[32] = Double.valueOf(df.format(F[32]).replace(",", ""));
			}
			if(C[33] != 0 ){
				F[33] = E[33] / C[33] *100;
				F[33] = Double.valueOf(df.format(F[33]).replace(",", ""));
			}
			if(C[34] != 0 ){
				F[34] = E[34] / C[34] *100;
				F[34] = Double.valueOf(df.format(F[34]).replace(",", ""));
			}
			if(C[35] != 0 ){
				F[35] = E[35] / C[35] *100;
				F[35] = Double.valueOf(df.format(F[35]).replace(",", ""));
			}
			if(C[36] != 0 ){
				F[36] = E[36] / C[36] *100;
				F[36] = Double.valueOf(df.format(F[36]).replace(",", ""));
			}
			if(C[37] != 0 ){
				F[37] = E[37] / C[37] *100;
				F[37] = Double.valueOf(df.format(F[37]).replace(",", ""));
			}
		}
		orgId = reqDTO.getValue("orgId");// 
		String sql21 = "SELECT WI.ORG_SUBJECTION_ID, WI.COUNTRY, WI.WEEK_2D_WORKLOAD, "+
			" WI.WEEK_3D_WORKLOAD, WI.YEAR_2D_WORKLOAD, WI.YEAR_3D_WORKLOAD, "+
			" WI.COMPLETE_2D_MONEY, WI.COMPLETE_3D_MONEY FROM BGP_WR_WORKLOAD_INFO WI WHERE "+ 
			" WI.BSFLAG = '0' AND WI.SUBFLAG = '"+subFlag+"' AND WI.WEEK_DATE = TO_DATE('"+weekDate+"', 'yyyy-mm-dd')";
		list = BeanFactory.getQueryJdbcDAO().queryRecords(sql21);
		String week2dWorkload = "";
		String week3dWorkload = "";
		String year2dWorkload = "";
		String year3dWorkload = "";
		String complete2dMoney = "";
		String complete3dMoney = "";
		double []G = new double[38];
		double []H = new double[38];
		double []I = new double[38];
		double []J = new double[38];
		double []K = new double[38];
		double []L = new double[38];
		if(list!=null &&list.size()>0){
			for(int i =0;i<list.size();i++){
				dateMap = (Map)list.get(i);
				country = (String) dateMap.get("country");
				complete2dMoney = (String) dateMap.get("complete2dMoney");
				week2dWorkload = (String) dateMap.get("week2dWorkload");
				week3dWorkload = (String) dateMap.get("week3dWorkload");
				year2dWorkload = (String) dateMap.get("year2dWorkload");
				year3dWorkload = (String) dateMap.get("year3dWorkload");
				orgSubId = (String) dateMap.get("orgSubjectionId");
				if(orgSubId!=null&&!orgSubId.equals("")&&orgSubId.startsWith(affordOrg)){
					if(complete2dMoney!=null ){
						complete2dMoney = complete2dMoney.trim();
						if (!complete2dMoney.equals("")) {
							if (orgSubId.startsWith("C105002")) {
								G[14] = G[14] + Double.valueOf(complete2dMoney);
							}
							if (orgSubId.startsWith("C105001005")) {
								G[15] = G[15] + Double.valueOf(complete2dMoney);
							}
							if (orgSubId.startsWith("C105001002")) {
								G[16] = G[16] + Double.valueOf(complete2dMoney);
							}
							if (orgSubId.startsWith("C105001003")) {
								G[17] = G[17] + Double.valueOf(complete2dMoney);
							}
							if (orgSubId.startsWith("C105001004")) {
								G[18] = G[18] + Double.valueOf(complete2dMoney);
							}
							if (orgSubId.startsWith("C105005004")) {
								G[19] = G[19] + Double.valueOf(complete2dMoney);
							}
							if (orgSubId.startsWith("C105005000")) {
								G[20] = G[20] + Double.valueOf(complete2dMoney);
							}
							if (orgSubId.startsWith("C105005001")) {
								G[21] = G[21] + Double.valueOf(complete2dMoney);
							}
							if (orgSubId.startsWith("C105007")
									&& country != null && country.equals("2")) {
								G[22] = G[22] + Double.valueOf(complete2dMoney);
							}
							if (orgSubId.startsWith("C105007")
									&& country != null && country.equals("1")) {
								G[23] = G[23] + Double.valueOf(complete2dMoney);
							}
							if (orgSubId.startsWith("C105063")
									&& country != null && country.equals("2")) {
								G[24] = G[24] + Double.valueOf(complete2dMoney);
							}
							if (orgSubId.startsWith("C105063")
									&& country != null && country.equals("1")) {
								G[25] = G[25] + Double.valueOf(complete2dMoney);
							}
							if (orgSubId.startsWith("C105003")
									&& country != null && country.equals("2")) {
								G[26] = G[26] + Double.valueOf(complete2dMoney);
							}
							if (orgSubId.startsWith("C105003")
									&& country != null && country.equals("1")) {
								G[27] = G[27] + Double.valueOf(complete2dMoney);
							}
							if (orgSubId.startsWith("C105008")
									&& country != null && country.equals("2")) {
								G[28] = G[28] + Double.valueOf(complete2dMoney);
							}
							if (orgSubId.startsWith("C105008")
									&& country != null && country.equals("1")) {
								G[29] = G[29] + Double.valueOf(complete2dMoney);
							}
							if (orgSubId.startsWith("C105006")) {
								G[32] = G[32] + Double.valueOf(complete2dMoney);
							}
							if (orgSubId.startsWith("C105004")) {
								G[33] = G[33] + Double.valueOf(complete2dMoney);
							}
							if (orgSubId.startsWith("C105014")) {
								G[34] = G[34] + Double.valueOf(complete2dMoney);
							}
							if (orgSubId.startsWith("C105016")) {
								G[35] = G[35] + Double.valueOf(complete2dMoney);
							}
							if (orgSubId.startsWith("C105079001")) {
								G[36] = G[36] + Double.valueOf(complete2dMoney);
							}
						}
					}
					if(week2dWorkload!=null ){
						week2dWorkload = week2dWorkload.trim();
						if (!week2dWorkload.equals("")) {
							if (orgSubId.startsWith("C105002")) {
								I[14] = I[14] + Double.valueOf(week2dWorkload);
							}
							if (orgSubId.startsWith("C105001005")) {
								I[15] = I[15] + Double.valueOf(week2dWorkload);
							}
							if (orgSubId.startsWith("C105001002")) {
								I[16] = I[16] + Double.valueOf(week2dWorkload);
							}
							if (orgSubId.startsWith("C105001003")) {
								I[17] = I[17] + Double.valueOf(week2dWorkload);
							}
							if (orgSubId.startsWith("C105001004")) {
								I[18] = I[18] + Double.valueOf(week2dWorkload);
							}
							if (orgSubId.startsWith("C105005004")) {
								I[19] = I[19] + Double.valueOf(week2dWorkload);
							}
							if (orgSubId.startsWith("C105005000")) {
								I[20] = I[20] + Double.valueOf(week2dWorkload);
							}
							if (orgSubId.startsWith("C105005001")) {
								I[21] = I[21] + Double.valueOf(week2dWorkload);
							}
							if (orgSubId.startsWith("C105007")
									&& country != null && country.equals("2")) {
								I[22] = I[22] + Double.valueOf(week2dWorkload);
							}
							if (orgSubId.startsWith("C105007")
									&& country != null && country.equals("1")) {
								I[23] = I[23] + Double.valueOf(week2dWorkload);
							}
							if (orgSubId.startsWith("C105063")
									&& country != null && country.equals("2")) {
								I[24] = I[24] + Double.valueOf(week2dWorkload);
							}
							if (orgSubId.startsWith("C105063")
									&& country != null && country.equals("1")) {
								I[25] = I[25] + Double.valueOf(week2dWorkload);
							}
							if (orgSubId.startsWith("C105003")
									&& country != null && country.equals("2")) {
								I[26] = I[26] + Double.valueOf(week2dWorkload);
							}
							if (orgSubId.startsWith("C105003")
									&& country != null && country.equals("1")) {
								I[27] = I[27] + Double.valueOf(week2dWorkload);
							}
							if (orgSubId.startsWith("C105008")
									&& country != null && country.equals("2")) {
								I[28] = I[28] + Double.valueOf(week2dWorkload);
							}
							if (orgSubId.startsWith("C105008")
									&& country != null && country.equals("1")) {
								I[29] = I[29] + Double.valueOf(week2dWorkload);
							}
							if (orgSubId.startsWith("C105006")) {
								I[32] = I[32] + Double.valueOf(week2dWorkload);
							}
							if (orgSubId.startsWith("C105004")) {
								I[33] = I[33] + Double.valueOf(week2dWorkload);
							}
							if (orgSubId.startsWith("C105014")) {
								I[34] = I[34] + Double.valueOf(week2dWorkload);
							}
							if (orgSubId.startsWith("C105016")) {
								I[35] = I[35] + Double.valueOf(week2dWorkload);
							}
							if (orgSubId.startsWith("C105079001")) {
								I[36] = I[36] + Double.valueOf(week2dWorkload);
							}
						}
					}
					if(week3dWorkload!=null ){
						week3dWorkload = week3dWorkload.trim();
						if(!week3dWorkload.equals("")) {
							if (orgSubId.startsWith("C105002")) {
								J[14] = J[14] + Double.valueOf(week3dWorkload);
							}
							if (orgSubId.startsWith("C105001005")) {
								J[15] = J[15] + Double.valueOf(week3dWorkload);
							}
							if (orgSubId.startsWith("C105001002")) {
								J[16] = J[16] + Double.valueOf(week3dWorkload);
							}
							if (orgSubId.startsWith("C105001003")) {
								J[17] = J[17] + Double.valueOf(week3dWorkload);
							}
							if (orgSubId.startsWith("C105001004")) {
								J[18] = J[18] + Double.valueOf(week3dWorkload);
							}
							if (orgSubId.startsWith("C105005004")) {
								J[19] = J[19] + Double.valueOf(week3dWorkload);
							}
							if (orgSubId.startsWith("C105005000")) {
								J[20] = J[20] + Double.valueOf(week3dWorkload);
							}
							if (orgSubId.startsWith("C105005001")) {
								J[21] = J[21] + Double.valueOf(week3dWorkload);
							}
							if (orgSubId.startsWith("C105007")
									&& country != null && country.equals("2")) {
								J[22] = J[22] + Double.valueOf(week3dWorkload);
							}
							if (orgSubId.startsWith("C105007")
									&& country != null && country.equals("1")) {
								J[23] = J[23] + Double.valueOf(week3dWorkload);
							}
							if (orgSubId.startsWith("C105063")
									&& country != null && country.equals("2")) {
								J[24] = J[24] + Double.valueOf(week3dWorkload);
							}
							if (orgSubId.startsWith("C105063")
									&& country != null && country.equals("1")) {
								J[25] = J[25] + Double.valueOf(week3dWorkload);
							}
							if (orgSubId.startsWith("C105003")
									&& country != null && country.equals("2")) {
								J[26] = J[26] + Double.valueOf(week3dWorkload);
							}
							if (orgSubId.startsWith("C105003")
									&& country != null && country.equals("1")) {
								J[27] = J[27] + Double.valueOf(week3dWorkload);
							}
							if (orgSubId.startsWith("C105008")
									&& country != null && country.equals("2")) {
								J[28] = J[28] + Double.valueOf(week3dWorkload);
							}
							if (orgSubId.startsWith("C105008")
									&& country != null && country.equals("1")) {
								J[29] = J[29] + Double.valueOf(week3dWorkload);
							}
							if (orgSubId.startsWith("C105006")) {
								J[32] = J[32] + Double.valueOf(week3dWorkload);
							}
							if (orgSubId.startsWith("C105004")) {
								J[33] = J[33] + Double.valueOf(week3dWorkload);
							}
							if (orgSubId.startsWith("C105014")) {
								J[34] = J[34] + Double.valueOf(week3dWorkload);
							}
							if (orgSubId.startsWith("C105016")) {
								J[35] = J[35] + Double.valueOf(week3dWorkload);
							}
							if (orgSubId.startsWith("C105079001")) {
								J[36] = J[36] + Double.valueOf(week3dWorkload);
							}
						}
					}
					if(year2dWorkload!=null && !year2dWorkload.equals("")){
						if(orgSubId.startsWith("C105002") ){
							K[14] = K[14] + Double.valueOf(year2dWorkload);
						}
						if(orgSubId.startsWith("C105001005") ){
							K[15] = K[15] + Double.valueOf(year2dWorkload);
						}
						if(orgSubId.startsWith("C105001002") ){
							K[16] = K[16] + Double.valueOf(year2dWorkload);
						}
						if(orgSubId.startsWith("C105001003") ){
							K[17] = K[17] + Double.valueOf(year2dWorkload);
						}
						if(orgSubId.startsWith("C105001004") ){
							K[18] = K[18] + Double.valueOf(year2dWorkload);
						}
						if(orgSubId.startsWith("C105005004") ){
							K[19] = K[19] + Double.valueOf(year2dWorkload);
						}
						if(orgSubId.startsWith("C105005000") ){
							K[20] = K[20] + Double.valueOf(year2dWorkload);
						}
						if(orgSubId.startsWith("C105005001") ){
							K[21] = K[21] + Double.valueOf(year2dWorkload);
						}
						if(orgSubId.startsWith("C105007") && country!=null && country.equals("2") ){
							K[22] = K[22] + Double.valueOf(year2dWorkload);
						}
						if(orgSubId.startsWith("C105007") && country!=null && country.equals("1")){
							K[23] = K[23] + Double.valueOf(year2dWorkload);
						}
						if(orgSubId.startsWith("C105063") && country!=null && country.equals("2") ){
							K[24] = K[24] + Double.valueOf(year2dWorkload);
						}
						if(orgSubId.startsWith("C105063") && country!=null && country.equals("1")){
							K[25] = K[25] + Double.valueOf(year2dWorkload);
						}
						if(orgSubId.startsWith("C105003") && country!=null && country.equals("2")){
							K[26] = K[26] + Double.valueOf(year2dWorkload);
						}
						if(orgSubId.startsWith("C105003") && country!=null && country.equals("1")){
							K[27] = K[27] + Double.valueOf(year2dWorkload);
						}
						if(orgSubId.startsWith("C105008") && country!=null && country.equals("2")){
							K[28] = K[28] + Double.valueOf(year2dWorkload);
						}
						if(orgSubId.startsWith("C105008") && country!=null && country.equals("1")){
							K[29] = K[29] + Double.valueOf(year2dWorkload);
						}
						if(orgSubId.startsWith("C105006") ){
							K[32] = K[32] + Double.valueOf(year2dWorkload);
						}
						if(orgSubId.startsWith("C105004") ){
							K[33] = K[33] + Double.valueOf(year2dWorkload);
						}
						if(orgSubId.startsWith("C105014") ){
							K[34] = K[34] + Double.valueOf(year2dWorkload);
						}
						if(orgSubId.startsWith("C105016") ){
							K[35] = K[35] + Double.valueOf(year2dWorkload);
						}
						if(orgSubId.startsWith("C105079001") ){
							K[36] = K[36] + Double.valueOf(year2dWorkload);
						}
						
					}
					if(year3dWorkload!=null && !year3dWorkload.equals("")){
						if(orgSubId.startsWith("C105002") ){
							L[14] = L[14] + Double.valueOf(year3dWorkload);
						}
						if(orgSubId.startsWith("C105001005") ){
							L[15] = L[15] + Double.valueOf(year3dWorkload);
						}
						if(orgSubId.startsWith("C105001002") ){
							L[16] = L[16] + Double.valueOf(year3dWorkload);
						}
						if(orgSubId.startsWith("C105001003") ){
							L[17] = L[17] + Double.valueOf(year3dWorkload);
						}
						if(orgSubId.startsWith("C105001004") ){
							L[18] = L[18] + Double.valueOf(year3dWorkload);
						}
						if(orgSubId.startsWith("C105005004") ){
							L[19] = L[19] + Double.valueOf(year3dWorkload);
						}
						if(orgSubId.startsWith("C105005000") ){
							L[20] = L[20] + Double.valueOf(year3dWorkload);
						}
						if(orgSubId.startsWith("C105005001") ){
							L[21] = L[21] + Double.valueOf(year3dWorkload);
						}
						if(orgSubId.startsWith("C105007") && country!=null && country.equals("2") ){
							L[22] = L[22] + Double.valueOf(year3dWorkload);
						}
						if(orgSubId.startsWith("C105007") && country!=null && country.equals("1")){
							L[23] = L[23] + Double.valueOf(year3dWorkload);
						}
						if(orgSubId.startsWith("C105063") && country!=null && country.equals("2") ){
							L[24] = L[24] + Double.valueOf(year3dWorkload);
						}
						if(orgSubId.startsWith("C105063") && country!=null && country.equals("1")){
							L[25] = L[25] + Double.valueOf(year3dWorkload);
						}
						if(orgSubId.startsWith("C105003") && country!=null && country.equals("2")){
							L[26] = L[26] + Double.valueOf(year3dWorkload);
						}
						if(orgSubId.startsWith("C105003") && country!=null && country.equals("1")){
							L[27] = L[27] + Double.valueOf(year3dWorkload);
						}
						if(orgSubId.startsWith("C105008") && country!=null && country.equals("2")){
							L[28] = L[28] + Double.valueOf(year3dWorkload);
						}
						if(orgSubId.startsWith("C105008") && country!=null && country.equals("1")){
							L[29] = L[29] + Double.valueOf(year3dWorkload);
						}
						if(orgSubId.startsWith("C105006") ){
							L[32] = L[32] + Double.valueOf(year3dWorkload);
						}
						if(orgSubId.startsWith("C105004") ){
							L[33] = L[33] + Double.valueOf(year3dWorkload);
						}
						if(orgSubId.startsWith("C105014") ){
							L[34] = L[34] + Double.valueOf(year3dWorkload);
						}
						if(orgSubId.startsWith("C105016") ){
							L[35] = L[35] + Double.valueOf(year3dWorkload);
						}
						if(orgSubId.startsWith("C105079001") ){
							L[36] = L[36] + Double.valueOf(year3dWorkload);
						}
						
					}
				}
			}
			G[30] = G[14] + G[22] + G[24] + G[26] + G[28];
			G[31] = G[15] + G[16] + G[17] + G[18] + G[19] + G[20] + G[21] + G[23] + G[25] + G[27] + G[29];
			G[37] = G[30] + G[31] + G[32] + G[33] + G[34] + G[35] + G[36];
			I[30] = I[14] + I[22] + I[24] + I[26] + I[28];
			I[31] = I[15] + I[16] + I[17] + I[18] + I[19] + I[20] + I[21] + I[23] + I[25] + I[27] + I[29];
			I[37] = I[30] + I[31] + I[32] + I[33] + I[34] + I[35] + I[36];
			J[30] = J[14] + J[22] + J[24] + J[26] + J[28];
			J[31] = J[15] + J[16] + J[17] + J[18] + J[19] + J[20] + J[21] + J[23] + J[25] + J[27] + J[29];
			J[37] = J[30] + J[31] + J[32] + J[33] + J[34] + J[35] + J[36];
			K[30] = K[14] + K[22] + K[24] + K[26] + K[28];
			K[31] = K[15] + K[16] + K[17] + K[18] + K[19] + K[20] + K[21] + K[23] + K[25] + K[27] + K[29];
			K[37] = K[30] + K[31] + K[32] + K[33] + K[34] + K[35] + K[36];
			L[30] = L[14] + L[22] + L[24] + L[26] + L[28];
			L[31] = L[15] + L[16] + L[17] + L[18] + L[19] + L[20] + L[21] + L[23] + L[25] + L[27] + L[29];
			L[37] = L[30] + L[31] + L[32] + L[33] + L[34] + L[35] + L[36];
			if(C[14] != 0 ){
				H[14] = G[14] / C[14] *100;
				H[14] = Double.valueOf(df.format(H[14]).replace(",", ""));
			}
			if(C[15] != 0 ){
				H[15] = G[15] / C[15] *100;
				H[15] = Double.valueOf(df.format(H[15]).replace(",", ""));
			}
			if(C[16] != 0 ){
				H[16] = G[16] / C[16] *100;
				H[16] = Double.valueOf(df.format(H[16]).replace(",", ""));
			}
			if(C[17] != 0 ){
				H[17] = G[17] / C[17] *100;
				H[17] = Double.valueOf(df.format(H[17]).replace(",", ""));
			}
			if(C[18] != 0 ){
				H[18] = G[18] / C[18] *100;
				H[18] = Double.valueOf(df.format(H[18]).replace(",", ""));
			}
			if(C[19] != 0 ){
				H[19] = G[19] / C[19] *100;
				H[19] = Double.valueOf(df.format(H[19]).replace(",", ""));
			}
			if(C[20] != 0 ){
				H[20] = G[20] / C[20] *100;
				H[20] = Double.valueOf(df.format(H[20]).replace(",", ""));
			}
			if(C[21] != 0 ){
				H[21] = G[21] / C[21] *100;
				H[21] = Double.valueOf(df.format(H[21]).replace(",", ""));
			}
			if(C[22] != 0 ){
				H[22] = (G[22] +G[23])/ C[22] *100;
				H[22] = Double.valueOf(df.format(H[22]).replace(",", ""));
			}
			if(C[24] != 0 ){
				H[24] = (G[24] +G[25])/ C[24] *100;
				H[24] = Double.valueOf(df.format(H[24]).replace(",", ""));
			}
			if(C[26] != 0 ){
				H[26] = (G[26] +G[27])/ C[26] *100;
				H[26] = Double.valueOf(df.format(H[26]).replace(",", ""));
			}
			if(C[28] != 0 ){
				H[28] = (G[28] +G[29])/ C[28] *100;
				H[28] = Double.valueOf(df.format(H[28]).replace(",", ""));
			}
			if(C[30] != 0 ){
				H[30] = (G[30] + G[31])/ C[30] *100;
				H[30] = Double.valueOf(df.format(H[30]).replace(",", ""));
			}
			if(C[32] != 0 ){
				H[32] = G[32] / C[32] *100;
				H[32] = Double.valueOf(df.format(H[32]).replace(",", ""));
			}
			if(C[33] != 0 ){
				H[33] = G[33] / C[33] *100;
				H[33] = Double.valueOf(df.format(H[33]).replace(",", ""));
			}
			if(C[34] != 0 ){
				H[34] = G[34] / C[34] *100;
				H[34] = Double.valueOf(df.format(H[34]).replace(",", ""));
			}
			if(C[35] != 0 ){
				H[35] = G[35] / C[35] *100;
				H[35] = Double.valueOf(df.format(H[35]).replace(",", ""));
			}
			if(C[36] != 0 ){
				H[36] = G[36] / C[36] *100;
				H[36] = Double.valueOf(df.format(H[36]).replace(",", ""));
			}
			if(C[37] != 0 ){
				H[37] = G[37] / C[37] *100;
				H[37] = Double.valueOf(df.format(H[37]).replace(",", ""));
			}
		}
		orgId = reqDTO.getValue("orgId");// 
		String sql22 = "SELECT MAX(WEEK_NUM) as  weekNum FROM BGP_WR_RECORD WHERE "+
			" WEEK_DATE = TO_DATE('"+weekDate+"','yyyy-MM-dd') AND WEEK_NUM IS NOT NULL";
		dateMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql22);
		String sql23 = "SELECT NVL(T.YEAR_2D_WORKLOAD, 0) YEAR_2D_WORKLOAD, NVL(T.YEAR_3D_WORKLOAD, 0) "+
			" YEAR_3D_WORKLOAD, T.ORG_ID, OS.ORG_SUBJECTION_ID, NVL(M.PREPARE_NUM, 0) "+
			" PREPARE_NUM, NVL(M.CONSTRUCT_NUM, 0) CONSTRUCT_NUM, NVL(M.END_NUM, 0) END_NUM "+ 
			" FROM (SELECT Z.WEEK_DATE, Z.ORG_ID, SUM(Z.YEAR_DF_WORKLOAD) YEAR_2D_WORKLOAD, "+
			" SUM(Z.YEAR_ZC_WORKLOAD) YEAR_3D_WORKLOAD FROM BGP_WR_WORKLOAD_INFO Z WHERE "+
			" Z.BSFLAG = '0' AND Z.SUBFLAG = '"+subFlag+"' GROUP BY Z.WEEK_DATE, Z.ORG_ID) T LEFT OUTER "+ 
			" JOIN (SELECT SUM(AI.PREPARE_NUM) PREPARE_NUM, SUM(AI.CONSTRUCT_NUM) "+
			" CONSTRUCT_NUM, SUM(AI.END_NUM) END_NUM, AI.ORG_ID, AI.WEEK_DATE FROM "+
			" BGP_WR_ACQ_PROJECT_INFO AI WHERE AI.BSFLAG = '0' AND AI.SUBFLAG = '"+subFlag+"' GROUP BY "+ 
			" AI.ORG_ID, AI.WEEK_DATE) M ON T.ORG_ID = M.ORG_ID AND T.WEEK_DATE = M.WEEK_DATE "+ 
			" LEFT OUTER JOIN COMM_ORG_SUBJECTION OS ON T.ORG_ID = OS.ORG_ID "+
			" WHERE T.WEEK_DATE = TO_DATE('"+weekDate+"', 'yyyy-mm-dd')";
		list = BeanFactory.getQueryJdbcDAO().queryRecords(sql23);
		String year2dWorkload23 = "0";
		String year3dWorkload23 = "0";
		String prepareNum23 = "0";
		String constructNum23 = "0";
		String endNum23 = "0";
		if (list != null && list.size() > 0) {
			for (int i = 0; i < list.size(); i++) {
				dateMap = (Map) list.get(i);
				if (dateMap != null) {
					orgId = (String) dateMap.get("orgId");
					if(orgId!=null && !orgId.equals("") && orgId.equals("C6000000000009"))
					{
						year2dWorkload23 = (String)dateMap.get("year2dWorkload");
						year3dWorkload23 = (String)dateMap.get("year3dWorkload");
						prepareNum23 = (String)dateMap.get("prepareNum");
						constructNum23 = (String)dateMap.get("constructNum");
						endNum23 = (String)dateMap.get("endNum");
						double y2d = 0;
						if(year2dWorkload23!=null && !year2dWorkload23.equals("")){
							 y2d = y2d + Double.parseDouble(year2dWorkload23);
						}
						double y3d = 0;
						if(year3dWorkload23!=null && !year3dWorkload23.equals("")){
							 y3d = y3d + Double.parseDouble(year3dWorkload23);
						}
						double pNum9 = 0;
						if(prepareNum23!=null && !prepareNum23.equals("")){
							pNum9 = pNum9 + Double.parseDouble(prepareNum23);
						}
						double cNum9 = 0;
						if(constructNum23!=null && !constructNum23.equals("")){
							cNum9 = cNum9 + Double.parseDouble(constructNum23);
						}
						double eNum9 = 0;
						if(endNum23!=null && !endNum23.equals("")){
							eNum9 = eNum9 + Double.parseDouble(endNum23);
						}
						year2dWorkload23 = String.valueOf(y2d);
						year3dWorkload23 = String.valueOf(y3d);
						prepareNum23 = String.valueOf(pNum9);
						constructNum23 = String.valueOf(cNum9);
						endNum23 = String.valueOf(eNum9);
					}
				}
			}
		}
	    
//	    FileInputStream fis = null;     
        try {
            System.out.println("ConvertFoToRTFSrv\n");
            System.out.println("Preparing...");
            //Setup directories
//            File baseDir = new File(".");
            URL url = Thread.currentThread().getContextClassLoader().getResource("/");
            
            String dir = url.getFile();
            
            String file = UUID.randomUUID().toString();
                        
            File rtfFile = new File(dir, file+".rft");
            File foFile = new File(dir, file+".fo");
            File htmlFile = new File(dir, file+".html");
            
            FileWriter fos = new FileWriter(foFile);
            
            /*System.out.println( outDir.getAbsolutePath());
            System.out.println( foDir.getAbsolutePath());
            System.out.println(System.getProperty("user.dir"));//user.dir指定了当前的路径
            */
//            foDir.mkdirs();
//            outDir.mkdirs();
//            foDir = new File(foDir,"/web.fo");
//            foDir.createNewFile();
//            if(foDir.exists())
//            System.out.println(foDir.getAbsolutePath());
            
            // 小数点后保留2位的格式化对象
            DecimalFormat df2=new DecimalFormat(); 
            df2.setMaximumFractionDigits(2);
    		df2.setMinimumFractionDigits(0);
    		df2.setGroupingSize(0);
    		
    		// 小数点后保留0位的格式化对象
            DecimalFormat df0=new DecimalFormat(); 
            df0.setMaximumFractionDigits(0);
    		df0.setMinimumFractionDigits(0);
    		df0.setGroupingSize(0);
    		    		
//    		// 小数点后保留1位的格式化对象
//            DecimalFormat df1=new DecimalFormat(); 
//            df1.setMaximumFractionDigits(2);
//    		df1.setMinimumFractionDigits(0);
//    		df1.setGroupingSize(0);
    		
            StringBuffer sb = new StringBuffer();
            sb.append("<?xml version='1.0' encoding='GBK'?> ")
//            .append(" <?xml-stylesheet href='/BGPMCS/pm/hq/productionControlWeekfo2html.xsl' type='text/xsl'?>")
            .append(" <fo:root xmlns:fo='http://www.w3.org/1999/XSL/Format' ")
            .append(" xmlns:xsl='http://www.w3.org/1999/XSL/Transform'")
            .append(" xmlns:svg='http://www.w3.org/2000/svg'>")
            .append(" <fo:layout-master-set>")
            .append(" <fo:simple-page-master master-name='simpleA4' ")
            .append(" page-height='29.7cm' page-width='21cm' ")
            .append(" margin-bottom='2cm'  margin-left='2cm' ")
            .append(" margin-right='2cm'> <fo:region-body margin-top='2cm'/>")
            .append(" </fo:simple-page-master> </fo:layout-master-set>")
            .append(" <fo:page-sequence master-reference='simpleA4'>").append(line)
            .append(" <fo:flow flow-name='xsl-region-body'>")
            .append(" <fo:block font-size='22pt'")
            .append(" font-family='仿宋' font-weight='bold'")
            .append(" line-height='24pt' space-after.optimum='8pt'")
            .append(" text-align='center' padding-top='3pt'>")
            .append(" 公司主业生产经营（周）信息简报 </fo:block>").append(line)
            .append(" <fo:block font-size='14pt' line-height='24pt'")
            .append(" font-family='仿宋' text-align='center'")
            .append(" padding-right='13pt'>("+startDate+" - "+endDate+")</fo:block>")
            .append(" <fo:block font-size='15pt' font-family='仿宋' ")
            .append(" line-height='24pt' text-align='center' padding-right='13pt'>")
            .append(" 公司生产管理处 第（  ）期 "+nowDate+"</fo:block>")
            .append(" <fo:block text-align='center' space-after.optimum='5pt' font-size='5pt'> <fo:leader leader-pattern='rule' ")
            .append(" rule-thickness='1.0pt' leader-length='10cm'/> </fo:block> ")
            .append(" <fo:block font-size='15pt' font-family='黑体'")
            .append(" font-weight='bold' line-height='24pt' space-after.optimum='5pt'")
            .append(" text-align='left' padding-right='13pt'> 一、概述 </fo:block>")
            .append(" <fo:block text-indent='2em' text-align='left' font-family='仿宋' font-size='14pt'>")
            .append(" 1、截止").append(endDate).append(",公司累计落实市场工作量").append(df0.format(E[37]))
            .append("万元（含内部收入），同比").append(tb).append(df2.format(carrout)).append("%")
            .append("。其中勘探主业累计落实").append(df0.format(E[30] + E[31])).append("万元（国际业务")
            .append(df0.format(E[30])).append("万元，国内").append(df0.format(E[31])).append("万元），勘探主业累计新签")
            .append(df0.format(D[30] + D[31])).append("万元（国际业务").append(df0.format(D[30])).append("万元，国内")
            .append(df0.format(D[31])).append("万元）。其他业务累计落实").append(df0.format(E[32]+E[33]+E[34]+E[35]+E[36]))
            .append("万元。</fo:block><fo:block text-indent ='2em' text-align='left' font-family='仿宋' font-size='14pt'>").append(line)
            .append(" 	 2、截止").append(endDate).append("，公司累计完成价值工作量").append(df0.format(G[37]))
            .append("万元（含内部收入），同比").append(tbComplete).append(df2.format(complete)).append("%")
            .append("。其中勘探主业累计完成").append(df0.format(G[30] + G[31])).append("万元（其中：国际部")
            .append(df0.format(G[14])).append("万元，是预算的").append(df2.format(H[14])).append("%；塔里木物探处").append(df0.format(G[15]))
            .append("万元，是预算的").append(df2.format(H[15])).append("%；新疆物探处").append(df0.format(G[16])).append("万元，是预算的")
            .append(df2.format(H[16])).append("%；吐哈物探处").append(df0.format(G[17])).append("万元，是预算的").append(df2.format(H[17]))
            .append("%；青海物探处").append(df0.format(G[18])).append("万元，是预算的").append(df2.format(H[18])).append("%；长庆物探处")
            .append(df0.format(G[19])).append("万元，是预算的").append(df0.format(H[19])).append("%；华北物探处").append(df0.format(G[20]))
            .append("万元，是预算的").append(df2.format(H[20])).append("%；新兴物探开发处").append(df0.format(G[21])).append("万元，是预算的")
            .append(df2.format(H[21])).append("%；大港物探处").append(df0.format(G[22]+G[23])).append("万元，是预算的").append(df2.format(H[22]))
            .append("%；辽河物探处").append(df0.format(G[24]+G[25])).append("万元，是预算的").append(df2.format(H[24])).append("%；研究院")
            .append(df0.format(G[26]+G[27])).append("万元，是预算的").append(df2.format(H[26])).append("%；综合物化探处事业部").append(df0.format(G[28]+G[29]))
            .append("万元，是预算的").append(df2.format(H[28])).append("%），其他业务累计完成").append(df0.format(G[32]+G[33]+G[34]+G[35]+G[36]))
            .append("万元。</fo:block><fo:block text-indent='2em' text-align='left' font-family='仿宋' font-size='14pt'>").append(line)
            .append(" 	 3、截止到本周末，公司正在施工国际项目共计").append(numAll).append("个（").append(num)
            .append("）；国内正在施工项目共计").append(numAll1).append("个(").append(num1).append("）。正在准备的项目")
            .append(pNumAll).append("个（").append(pNum).append("），结束").append(eNumAll).append("个（")
            .append(eNum).append("）。</fo:block><fo:block text-indent='2em' text-align='left' font-family='仿宋' font-size='14pt'> 	 4、公司重点项目动态：")
            .append(projectContent).append(" </fo:block>").append(line)
            .append(" <fo:block font-size='15pt' font-family='黑体' font-weight='bold' line-height='24pt' ")
            .append("  space-after.optimum='8pt'  text-align='left' padding-right='13pt'> 二、公司生产经营情况 </fo:block>")
            .append(" <fo:table table-layout='fixed' width='19cm' border-collapse='collapse' border-color='black' border-width='0.3mm' border-style='solid' font-size='10.5pt' font-family='仿宋'><fo:table-column column-width='1.5cm'/>")
            .append(" <fo:table-column column-width='2cm'/> <fo:table-column column-width='1.5cm'/>")
            .append(" <fo:table-column column-width='1.5cm'/> <fo:table-column column-width='1.5cm'/>")
            .append(" <fo:table-column column-width='1.5cm'/> <fo:table-column column-width='1.5cm'/>")
            .append(" <fo:table-column column-width='1.5cm'/> <fo:table-column column-width='1.2cm'/>")
            .append(" <fo:table-column column-width='1.2cm'/> <fo:table-column column-width='1.2cm'/>")
            .append(" <fo:table-column column-width='1.2cm'/> <fo:table-body> <fo:table-row > ").append(line)
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-rows-spanned='3' number-columns-spanned ='2' ")
            .append(" display-align='center'> <fo:block  text-align='center'>单位</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-rows-spanned='3' display-align='center'>")
            .append(" <fo:block text-align='center'>预算收入（万元）</fo:block> </fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-columns-spanned ='5' display-align='center'>")
            .append(" <fo:block  text-align='center'>价值工作量落实、完成情况</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-columns-spanned ='4' display-align='center'>")
            .append(" <fo:block text-align='center'> 实物工作量完成情况</fo:block> </fo:table-cell> </fo:table-row> <fo:table-row >")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-columns-spanned ='3' display-align='center'>")
            .append(" <fo:block  text-align='center'>落实</fo:block></fo:table-cell> ")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-columns-spanned ='2' display-align='center'>")
            .append(" <fo:block text-align='center'>完成</fo:block> </fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-columns-spanned ='2' display-align='center'>")
            .append(" <fo:block  text-align='center'>本周</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-columns-spanned ='2' display-align='center'>")
            .append(" <fo:block text-align='center'>年累</fo:block> </fo:table-cell> </fo:table-row>	 <fo:table-row>").append(line)
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>累计新签(万元)</fo:block></fo:table-cell> ")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>累计落实(万元)</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>为预算收入％</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>完成(万元)</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>为预算收入％</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>二维(km)</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>三维(k㎡)</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>二维(km)</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>三维(k㎡)</fo:block></fo:table-cell> </fo:table-row> ").append(line);
            
            fos.write(sb.toString());
            sb.delete(0, sb.length());
            
            String []orgName = {"国际勘探事业部","塔里木物探处","新疆物探处","吐哈物探处","青海物探处",
            			"长庆物探处","华北物探处","新兴物探开发处","大港物探处","","辽河物探处","","研究院","",
            			"综合物化探处","","国际勘探主业","国内勘探主业","装备服务处","物探技术研究中心",
            			"信息技术中心","西安物探装备分公司","天津英洛瓦分公司","主营业务总计"};
            String []orgIdString = {"C105002","C105001005","C105001002","C105001003","C105001004",
        				"C105005004","C105005000","C105005001","C105007","","C105063","","C105003","",
        				"C105008","","","","C105006","C105004","C105014","C105016","C105079001",""};
            List orgList = new ArrayList();
            for(int i =0;i<orgIdString.length;i++){
            	Map orgMap = new HashMap();
                orgMap.put("orgName", orgName[i]);
                if(orgName[i].equals("国际勘探主业")||orgName[i].equals("国内勘探主业")||orgName[i].equals("主营业务总计")){
                	orgIdString[i] = "C105";
                }
                orgMap.put("orgIdString", orgIdString[i]);
                orgList.add(orgMap);
            }
			for (int j = 0; j < orgName.length; j++) {
				Map map = (Map) orgList.get(j);
				if (map != null) {
					if(map.get("orgIdString")!=null && map.get("orgIdString").toString().startsWith(affordOrg)){
						String orgIdTemp = map.get("orgIdString").toString();
						if(orgIdTemp.equals("C105007")||orgIdTemp.equals("C105063")||orgIdTemp.equals("C105003")||orgIdTemp.equals("C105008")){
							sb.append(" <fo:table-row> ")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-rows-spanned='2'>")
							.append(" <fo:block  text-align='center'>").append((String)map.get("orgName"))
							.append(" </fo:block></fo:table-cell> <fo:table-cell border-width='0.3mm' border-style='solid' ")
							.append(" display-align='center'><fo:block  text-align='center'>国际</fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' number-rows-spanned='2'  border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(C[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(D[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(E[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' number-rows-spanned='2'  border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df2.format(F[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(G[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' number-rows-spanned='2'  border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df2.format(H[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(I[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(J[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(K[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(L[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" </fo:table-row> <fo:table-row >").append(line)
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'> ")
							.append(" <fo:block  text-align='center'>国内</fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(D[j+14+1])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(E[j+14+1])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(G[j+14+1])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(I[j+14+1])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(J[j+14+1])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(K[j+14+1])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(L[j+14+1])).append(" </fo:block></fo:table-cell>")
							.append(" </fo:table-row>").append(line);
						}
						else if(map.get("orgName")!=null && map.get("orgName").toString().equals("国际勘探主业")){
							sb.append(" <fo:table-row> ").append(" <fo:table-cell border-width='0.3mm' border-style='solid' ")
							.append(" number-columns-spanned='2'><fo:block  text-align='center'>").append((String)map.get("orgName"))
							.append(" </fo:block></fo:table-cell> ")
							.append(" <fo:table-cell border-width='0.3mm' number-rows-spanned='2'  border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(C[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(D[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(E[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' number-rows-spanned='2'  border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df2.format(F[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(G[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' number-rows-spanned='2'  border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df2.format(H[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(I[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(J[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(K[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(L[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" </fo:table-row>").append(line);
						}
						else if(map.get("orgName")!=null && map.get("orgName").toString().equals("国内勘探主业")){
							sb.append(" <fo:table-row> ").append(" <fo:table-cell border-width='0.3mm' border-style='solid' ")
							.append(" number-columns-spanned='2'><fo:block  text-align='center'>").append((String)map.get("orgName"))
							.append(" </fo:block></fo:table-cell> ")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(D[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(E[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(G[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(I[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(J[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(K[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(L[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" </fo:table-row> ").append(line);
						}
						else {
							sb.append(" <fo:table-row> ").append(" <fo:table-cell border-width='0.3mm' border-style='solid' ")
							.append(" number-columns-spanned='2'><fo:block  text-align='center'>").append((String)map.get("orgName"))
							.append(" </fo:block></fo:table-cell> ")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(C[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(D[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(E[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df2.format(F[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(G[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df2.format(H[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(I[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(J[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(K[j+14])).append(" </fo:block></fo:table-cell>")
							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
							.append(" <fo:block  text-align='center'>").append(df0.format(L[j+14])).append(" </fo:block></fo:table-cell></fo:table-row> ");
						}
					}
				}


	            fos.write(sb.toString());
	            sb.delete(0, sb.length());
	            
			}
            sb.append(" </fo:table-body> </fo:table>").append(line).append(" <fo:block font-weight='bold' ")
            .append(" font-size='15pt' font-family='黑体' line-height='24pt' space-after.optimum='8pt' text-align='left'")
            .append(" padding-right='13pt'> 三、市场及项目运作相关信息 </fo:block> <fo:block font-size='14pt' font-family='仿宋' ")
            .append(" line-height='24pt' space-after.optimum='8pt' padding-right='13pt'> （一）本周合同签订情况 </fo:block>");
            
            String[] content1Array = content1.split("\r\n");
            for(int i=0;i<content1Array.length;i++){
	            sb.append(" <fo:block font-size='14pt' font-family='仿宋' line-height='24pt' space-after.optimum='4pt'")
	            .append(" text-indent='2em' padding-right='13pt' font-weight='normal'> ").append(content1Array[i]).append(" </fo:block>").append(line);
            }
            sb.append(" <fo:block font-size='14pt' font-family='仿宋' line-height='24pt' space-after.optimum='8pt' ")
            .append(" padding-right='13pt'> （二）投标项目跟踪</fo:block> ");
            
            String[] content2Array = content2.split("\r\n");
            for(int i=0;i<content2Array.length;i++){
            	sb.append("  <fo:block font-size='14pt' font-family='仿宋' line-height='24pt' space-after.optimum='8pt' padding-right='13pt' text-indent='2em' font-weight='normal'>").append(content2Array[i]).append(" </fo:block> ");
            }
            
            sb.append(line).append(" <fo:block font-size='14pt' font-family='仿宋' line-height='24pt' space-after.optimum='8pt' ")
            .append(" padding-right='13pt'> （三）市场开发工作动态  </fo:block>");
            
            String[] content3Array = content3.split("\r\n");
            for(int i=0;i<content3Array.length;i++){
            	sb.append(" <fo:block font-size='14pt' font-family='仿宋' line-height='24pt' space-after.optimum='8pt' padding-right='13pt' text-indent='2em' font-weight='normal'>").append(content3Array[i]).append(" </fo:block>");
            }
            
            sb.append(line).append(" <fo:block font-size='15pt' font-family='黑体' ")
            .append(" font-weight='bold' line-height='24pt' space-after.optimum='8pt' text-align='left' padding-right='13pt'>")
            .append(" 四、项目运行动态 </fo:block> ").append(line).append(" <fo:block font-size='14pt' font-family='仿宋' font-weight='bold'")
            .append(" line-height='24pt' space-after.optimum='5pt' text-align='left' padding-right='13pt'> （一）公司勘探船只动态 ")
            .append(" <fo:block font-size='14pt' font-family='仿宋' line-height='24pt' space-after.optimum='5pt'")
            .append(" text-align='left' padding-right='13pt'>").append(sailContent).append(" </fo:block> </fo:block>").append(line)
            .append(" <fo:block font-size='14pt' font-family='仿宋' line-height='24pt' space-after.optimum='5pt'")
            .append(" text-align='left' padding-right='13pt' font-weight='bold'> （二）主业各单位生产动态 </fo:block> ");
            

            fos.write(sb.toString());
            sb.delete(0, sb.length());
            
            /*String year2dWorkload9 = "0";
			String year3dWorkload9 = "0";
			String prepareNum9 = "0";
			String constructNum9 = "0";
			String endNum9 = "0";*/
			if (list9 != null && list9.size() > 0) {
				String[] subIds = new String[]{"C105002", "C105001005", "C105001002", "C105001003", "C105001004", "C105005004", "C105005000", "C105005001", "C105007", "C105063"};
				String[] orgIds = new String[]{"C6000000000003", "C6000000000010", "C6000000000011", "C6000000000013", "C6000000000012", "C6000000000045", "C0000000000232", "C6000000000060", "C6000000000008", "C6000000001888"};
				String[] orgNames = new String[]{"1、国际勘探事业部", "2、塔里木物探处", "3、新疆物探处", "4、吐哈物探处", "5、青海物探处", "6、长庆物探处", "7、华北物探处", "8、新兴物探开发处", "9、大港物探处", "10、辽河物探处"};
				for (int k=0; k<orgIds.length;k++){
					if(subIds[k].startsWith(affordOrg)){
						String year2dWorkload9 = "0";
						String year3dWorkload9 = "0";
						String prepareNum9 = "0";
						String constructNum9 = "0";
						String endNum9 = "0";
						sb.append("<fo:block font-size='14pt'")
						.append(" font-family='仿宋' font-weight='bold' line-height='24pt' space-after.optimum='5pt' text-align='left'")
						.append(" padding-right='13pt'> ").append(orgNames[k]).append(" <fo:block font-size='14pt' font-family='仿宋' font-weight='normal'")
						.append(" line-height='24pt' text-align='left' start-indent ='2em' padding-right='13pt'>");
	    			
						for (int i = 0; i < list9.size(); i++) {
							dateMap = (Map) list9.get(i);
							if (dateMap != null) {
								orgId = (String) dateMap.get("orgId");
								if(orgId!=null && !orgId.equals("") && orgId.equals(orgIds[k])){
									year2dWorkload9 = (String)dateMap.get("year2dWorkload");
									year3dWorkload9 = (String)dateMap.get("year3dWorkload");
									prepareNum9 = (String)dateMap.get("prepareNum");
									constructNum9 = (String)dateMap.get("constructNum");
									endNum9 = (String)dateMap.get("endNum");
									double y2d = 0;
									if(year2dWorkload9!=null && !year2dWorkload9.equals("")){
										y2d = y2d + Double.parseDouble(year2dWorkload9);
									}
									double y3d = 0;
									if(year3dWorkload9!=null && !year3dWorkload9.equals("")){
										y3d = y3d + Double.parseDouble(year3dWorkload9);
									}
									int pNum9 = 0;
									if(prepareNum9!=null && !prepareNum9.equals("")){
										pNum9 = pNum9 + Integer.parseInt(prepareNum9);
									}
									int cNum9 = 0;
									if(constructNum9!=null && !constructNum9.equals("")){
										cNum9 = cNum9 + Integer.parseInt(constructNum9);
									}
									int eNum9 = 0;
									if(endNum9!=null && !endNum9.equals("")){
										eNum9 = eNum9 + Integer.parseInt(endNum9);
									}
									year2dWorkload9 = String.valueOf(y2d);
									year3dWorkload9 = String.valueOf(y3d);
									prepareNum9 = String.valueOf(pNum9);
									constructNum9 = String.valueOf(cNum9);
									endNum9 = String.valueOf(eNum9);
								}
							}
						}
					
						sb.append("截止本周末，累计完成二维").append(year2dWorkload9).append("km，累计完成三维")
						.append( year3dWorkload9).append("k㎡。正在施工项目共").append(constructNum9).append("个，准备").append(prepareNum9)
						.append("个，累计结束").append(endNum9).append("个。").append(" </fo:block> </fo:block>").append(line);
						sb.append(" <fo:table table-layout='fixed' width='19cm' border-collapse='collapse' border-color='black' border-width='0.3mm' border-style='solid' font-size='10.5pt' font-family='仿宋' font-weight='normal'> <fo:table-column column-width='5cm'/>").append(line)
						.append(" <fo:table-column column-width='3cm'/> <fo:table-column column-width='1.5cm'/> <fo:table-column column-width='1.5cm'/>")
						.append(" <fo:table-column column-width='1.5cm'/> <fo:table-column column-width='1.2cm'/> <fo:table-column column-width='1.5cm'/>")
						.append(" <fo:table-column column-width='1.5cm'/> <fo:table-body>").append(line).append(" <fo:table-row >")
						.append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-rows-spanned='2' display-align='center'>")
		            	.append(" <fo:block  text-align='center'>项目名称</fo:block> </fo:table-cell>")
		            	.append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-rows-spanned='2' display-align='center'>")
		            	.append(" <fo:block text-align='center'>甲方名称</fo:block> </fo:table-cell>")
		           	 	.append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-rows-spanned='2' display-align='center'>")
		            	.append(" <fo:block  text-align='center'>队号</fo:block> </fo:table-cell>")
		            	.append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-columns-spanned ='2' display-align='center'>")
		            	.append(" <fo:block text-align='center'> 工作量</fo:block> </fo:table-cell>")
		            	.append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-rows-spanned ='2' display-align='center'>")
		            	.append(" <fo:block  text-align='center'>进度％</fo:block> </fo:table-cell>")
		            	.append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-rows-spanned ='2' display-align='center'>")
		            	.append(" <fo:block text-align='center'>项目状态</fo:block> </fo:table-cell>")
		            	.append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-rows-spanned ='2' display-align='center'>")
		           		.append(" <fo:block  text-align='center'>备注</fo:block> </fo:table-cell> </fo:table-row>").append(line)
		            	.append(" <fo:table-row> <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
		            	.append(" <fo:block text-align='center'>设计</fo:block></fo:table-cell>")
		            	.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
		            	.append(" <fo:block text-align='center'>完成</fo:block></fo:table-cell> </fo:table-row>").append(line);
					
						for (int i = 0; i < list10.size(); i++) {
	    					dateMap = (Map) list10.get(i);
	    					if (dateMap != null) {
	    						orgId = (String) dateMap.get("orgId");
	    					
	    						if(orgId!=null && !orgId.equals("") && orgId.equals(orgIds[k])){
	    							String projectName = (String) dateMap.get("projectName");
	        						String manageOrg = (String) dateMap.get("manageOrg");
	        						String teamName = (String) dateMap.get("teamName");
	        						String designWorkload = (String) dateMap.get("designWorkload");
	        						String completeWorkload = (String) dateMap.get("completeWorkload");
	        						String schedule = (String) dateMap.get("schedule");
	        						String projectStatus = (String) dateMap.get("projectStatus");
	        						String notes = (String) dateMap.get("notes");
	        						if(projectName.indexOf("&")!=-1){
	        							projectName = projectName.replaceAll("&", " and ");
	        						}
	        						if(manageOrg.indexOf("&")!=-1){
	        							manageOrg = manageOrg.replaceAll("&", " and ");
	        						}
	        						if(teamName.indexOf("&")!=-1){
	        							teamName = teamName.replaceAll("&", " and ");
	        						}
	        						if(notes.indexOf("&")!=-1){
	        							notes = notes.replaceAll("&", " and ");
	        						}
	        						sb.append(" <fo:table-row >");
	        						sb.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
	        						.append(" <fo:block  text-align='center'>").append(projectName).append(" </fo:block></fo:table-cell>")
	        						.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
	        						.append(" <fo:block  text-align='center'>").append(manageOrg).append(" </fo:block></fo:table-cell>")
	        						.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
	        						.append(" <fo:block  text-align='center'>").append(teamName).append(" </fo:block></fo:table-cell>")
	        						.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
	        						.append(" <fo:block  text-align='center'>").append(designWorkload).append(" </fo:block></fo:table-cell>")
	        						.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
	        						.append(" <fo:block  text-align='center'>").append(completeWorkload).append(" </fo:block></fo:table-cell>")
	        						.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
	        						.append(" <fo:block  text-align='center'>").append(schedule).append(" </fo:block></fo:table-cell>")
	        						.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
	        						.append(" <fo:block  text-align='center'>").append(projectStatus).append(" </fo:block></fo:table-cell>")
	        						.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
	        						.append(" <fo:block  text-align='center'>").append(notes).append(" </fo:block></fo:table-cell>")
	        						.append(" </fo:table-row >").append(line);
	    						}
	    					
	    					}
						}
					
						String reason = "";
						if (list13 != null && list13.size() > 0) {
							for (int i = 0; i < list13.size(); i++) {
								dateMap = (Map) list13.get(i);
								if (dateMap != null) {
									orgId = (String) dateMap.get("orgId");
									if (orgId != null && !orgId.equals("")
											&& orgId.equals("C6000000000003")) {
										if (dateMap.get("reason") != null) {
											reason = (String) dateMap
													.get("reason");
										}
									}
								}
							}
						}
		    			sb.append(" </fo:table-body>").append(line).append(" </fo:table> <fo:block font-size='14pt'  font-family='仿宋' line-height='24pt'")
		    			.append(" text-align='left' start-indent ='2em' padding-right='13pt' font-weight='bolder'>").append(reason).append(" </fo:block>");
		            
		    			if("C6000000000060".equals(orgIds[k])){
		    				sb.append(" <fo:block font-size='14pt' font-family='仿宋' line-height='24pt' text-align='left'")
		    				.append(" start-indent ='1em' padding-right='13pt'> （2）井中地震（VSP）项目动态。<fo:block font-size='14pt'")
		    				.append(" font-family='仿宋' line-height='24pt' text-align='left' start-indent ='2em' padding-right='13pt'>")
		    				.append(" 截止本周末，正在施工项目共").append(df.format(Double.valueOf(constructNum1))).append("个，准备").append(df.format(Double.valueOf(prepareNum1))).append("个，累计结束")
		    				.append( df.format(Double.valueOf(endNum1))).append("个。</fo:block> </fo:block>");
		    			}
							fos.write(sb.toString());
							sb.delete(0, sb.length());
					}
				}
    		}
			if("C105008".startsWith(affordOrg)){
				sb.append(" <fo:block font-size='14pt' font-family='仿宋' font-weight='bold' line-height='24pt' text-align='left' padding-right='13pt'>")
				.append(" （二）非地震项目 <fo:block font-size='14pt' font-family='仿宋' line-height='24pt' font-weight='normal' text-align='left' ")
				.append(" start-indent ='2em' padding-right='13pt'>").append(" 截止本周末，累计完成电法采集").append(year2dWorkload23)
				.append(" km，累计完成重磁采集").append(year3dWorkload23).append(" k㎡。正在施工项目共").append(df0.format(Double.valueOf(constructNum23.toString()))).append("个，准备").append(df0.format(Double.valueOf(prepareNum23.toString())))
				.append(" 个，累计结束").append(df0.format(Double.valueOf(endNum23.toString()))).append(" 个。").append(" </fo:block> </fo:block>").append(line)
				.append(" <fo:table table-layout='fixed' width='16cm' border-collapse='collapse' border-color='black' border-width='0.3mm' border-style='solid' font-size='10.5pt' font-family='仿宋' font-weight='normal'> <fo:table-column column-width='5cm'/>")
				.append(" <fo:table-column column-width='3cm'/> <fo:table-column column-width='1.5cm'/> <fo:table-column column-width='1.5cm'/>")
				.append(" <fo:table-column column-width='1.5cm'/> <fo:table-column column-width='1.5cm'/> <fo:table-column column-width='1.5cm'/>")
				.append(" <fo:table-column column-width='1.5cm'/> <fo:table-body>").append(line).append(" <fo:table-row >")
				.append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-rows-spanned='2' display-align='center'>")
				.append(" <fo:block  text-align='center'>项目名称</fo:block> </fo:table-cell>")
				.append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-rows-spanned='2' display-align='center'>")
				.append(" <fo:block text-align='center'>甲方名称</fo:block> </fo:table-cell>")
				.append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-rows-spanned='2' display-align='center'>")
				.append(" <fo:block  text-align='center'>队号</fo:block> </fo:table-cell>")
				.append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-columns-spanned ='2' display-align='center'>")
				.append(" <fo:block text-align='center'> 工作量</fo:block> </fo:table-cell>")
				.append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-rows-spanned ='2' display-align='center'>")
				.append(" <fo:block  text-align='center'>进度％</fo:block> </fo:table-cell>")
				.append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-rows-spanned ='2' display-align='center'>")
				.append(" <fo:block text-align='center'>项目状态</fo:block> </fo:table-cell>")
				.append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-rows-spanned ='2' display-align='center'>")
				.append(" <fo:block  text-align='center'>备注</fo:block> </fo:table-cell> </fo:table-row> <fo:table-row>")
				.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'> <fo:block text-align='center'>设计</fo:block></fo:table-cell>")
				.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
				.append(" <fo:block text-align='center'>完成</fo:block></fo:table-cell> </fo:table-row>").append(line);
    		

				fos.write(sb.toString());
				sb.delete(0, sb.length());
            
				if(list10!=null && list10.size()>0){
    				for (int i = 0; i < list10.size(); i++) {
    					dateMap = (Map) list10.get(i);
    					if (dateMap != null) {
    						orgId = (String) dateMap.get("orgId");
    						String projectType = (String)dateMap.get("projectType");
    						String projectStatus = (String) dateMap.get("projectStatus");
    						if(projectType!=null && projectStatus!=null && ! projectType.equals("") && !projectStatus.equals("") 
    								&& projectType.equals("3") && !projectStatus.equals("结束"))
    						{
    							String projectName = (String) dateMap.get("projectName");
    							String manageOrg = (String) dateMap.get("manageOrg");
    							String teamName = (String) dateMap.get("teamName");
    							String designWorkload = (String) dateMap.get("designWorkload");
    							String completeWorkload = (String) dateMap.get("completeWorkload");
    							String schedule = (String) dateMap.get("schedule");
        					
    							String notes = (String) dateMap.get("notes");
    							sb.append(" <fo:table-row >");
    							sb.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
    							.append(" <fo:block  text-align='center'>").append(projectName).append(" </fo:block></fo:table-cell>")
    							.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        						.append(" <fo:block  text-align='center'>").append(manageOrg).append(" </fo:block></fo:table-cell>")
        						.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        						.append(" <fo:block  text-align='center'>").append(teamName).append(" </fo:block></fo:table-cell>")
        						.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        						.append(" <fo:block  text-align='center'>").append(designWorkload).append(" </fo:block></fo:table-cell>")
        						.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        						.append(" <fo:block  text-align='center'>").append(completeWorkload).append(" </fo:block></fo:table-cell>")
        						.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        						.append(" <fo:block  text-align='center'>").append(schedule).append(" </fo:block></fo:table-cell>")
        						.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        						.append(" <fo:block  text-align='center'>").append(projectStatus).append(" </fo:block></fo:table-cell>")
        						.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        						.append(" <fo:block  text-align='center'>").append(notes).append(" </fo:block></fo:table-cell>")
        						.append(" </fo:table-row >").append(line);
    						}
    					
    					}

    					fos.write(sb.toString());
    					sb.delete(0, sb.length());
    				}
				}
				sb.append(" </fo:table-body> </fo:table>").append(line);
			}
            sb.append(" <fo:block font-size='14pt' font-weight='bold'")
            .append(" font-family='仿宋' line-height='24pt' text-align='left' padding-right='13pt'>（三）主要处理解释项目动态</fo:block>");
            
            for(int i=0;i<projectNotes.size();i++){
	            sb.append(" <fo:block start-indent ='2em' text-align='left' font-size='14pt' font-family='仿宋'>").append(projectNotes.get(i)).append(" </fo:block> ");
            }
            
            sb.append(" <fo:block font-size='15pt' font-family='黑体' font-weight='bold' line-height='24pt' text-align='left' padding-right='13pt'>")
            .append(" 五、采集技术支持情况</fo:block> ");
            
            String[] complexionArray = complexion.split("\r\n");
            for(int i=0;i<complexionArray.length;i++){
            	sb.append(" <fo:block text-align='left' start-indent ='2em' font-size='14pt' font-family='仿宋'>").append(complexionArray[i]).append(" </fo:block> ").append(line);
            }
            
            sb.append(" <fo:block font-size='15pt' font-family='黑体' font-weight='bold' line-height='24pt'  text-align='left'")
            .append(" padding-right='13pt'> 六、主要装备使用及闲置动态 </fo:block> <fo:block font-size='14pt' font-family='仿宋'")
            .append(" line-height='24pt' text-align='left' padding-right='13pt'> 1、国际主要地震仪器</fo:block>").append(line)
            .append(" <fo:table table-layout='fixed' width='16cm' border-collapse='collapse' border-color='black' border-width='0.3mm' border-style='solid' font-size='10.5pt' font-family='仿宋' font-weight='normal'> <fo:table-column column-width='2.3cm'/>")
            .append(" <fo:table-column column-width='1.3cm'/> <fo:table-column column-width='1.3cm'/> <fo:table-column column-width='1.3cm'/>")
            .append(" <fo:table-column column-width='1.3cm'/> <fo:table-column column-width='1.3cm'/> <fo:table-column column-width='1.3cm'/>")
            .append(" <fo:table-column column-width='1.3cm'/> <fo:table-column column-width='1.3cm'/> <fo:table-column column-width='1.3cm'/>")
            .append(" <fo:table-column column-width='1.3cm'/> <fo:table-column column-width='1.3cm'/> <fo:table-body>").append(line).append(" <fo:table-row >")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-rows-spanned='2' display-align='center'>")
            .append(" <fo:block  text-align='center'>仪器型号</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-columns-spanned='2' display-align='center'>")
            .append(" <fo:block text-align='center'>总量</fo:block> </fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-columns-spanned ='2' display-align='center'>")
            .append(" <fo:block  text-align='center'>在用</fo:block></fo:table-cell> <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'> 利用率</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-columns-spanned ='2' display-align='center'>")
            .append(" <fo:block  text-align='center'>计划投入使用</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-columns-spanned ='2' display-align='center'>")
            .append(" <fo:block text-align='center'>闲置</fo:block> </fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-columns-spanned ='2' display-align='center'>")
            .append(" <fo:block  text-align='center'>因安保原因停用</fo:block></fo:table-cell> </fo:table-row>").append(line)
            .append(" <fo:table-row> <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>主机 （台）</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>道数  （道）</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>主机  （台）</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>道数  （道）</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>％</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>主机  （台）</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>道数  （道）</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>主机   （台）</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>完好  （道）</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>主机   （台）</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>完好  （道）</fo:block></fo:table-cell> </fo:table-row>").append(line);
           

            fos.write(sb.toString());
            sb.delete(0, sb.length());
            
            for(int j = 0 ;j<11;j++){
    			sum127[j] = 0;
    		}
    		if(deviceList!=null && deviceList.size()>0){
    			for (int i = 0; i < deviceList.size(); i++) {
    				dateMap = (Map) deviceList.get(i);
    				if (dateMap != null) {
    					double []sum128 = new double[11];
    					for(int j = 0 ;j<11;j++){
    						sum128[j] = 0;
    					}
    					String name = (String)dateMap.get("deviceName");
    					for(int k= 0; k<deviceList.size();k++){
    						Map map = (Map)deviceList.get(k);
    						String deviceName = (String)map.get("deviceName");
    						if(deviceName!=null && !deviceName.equals("") && deviceName.equals(name)){
        						String totalNum = (String) map.get("totalNum");
            					String totalNumS = (String) map.get("totalNumS");
            					String useNum = (String) map.get("useNum");
            					String useNumS = (String) map.get("useNumS");
            					String useRate = (String) map.get("useRate");
            					String planNum = (String) map.get("planNum");
            					String planNumS = (String) map.get("planNumS");
            					String notuseNum = (String) map.get("notuseNum");
            					String notuseNumS = (String) map.get("notuseNumS");
            					String safetyNum = (String) map.get("safetyNum");
            					String safetyNumS = (String) map.get("safetyNumS");
            					if(totalNum!=null && !totalNum.equals("")){
            						sum128[0] = sum128[0] + Double.valueOf(totalNum);
            					}
            					if(totalNumS!=null && !totalNumS.equals("")){
            						sum128[1] = sum128[1] + Double.valueOf(totalNumS);
            					}
            					if(useNum!=null && !useNum.equals("")){
            						sum128[2] = sum128[2] + Double.valueOf(useNum);
            					}
            					if(useNumS!=null && !useNumS.equals("")){
            						sum128[3] = sum128[3] + Double.valueOf(useNumS);
            					}
            					if(useRate!=null && !useRate.equals("")){
            						sum128[4] = sum128[4] + Double.valueOf(useRate);
            					}
            					if(planNum!=null && !planNum.equals("")){
            						sum128[5] = sum128[5] + Double.valueOf(planNum);
            					}
            					if(planNumS!=null && !planNumS.equals("")){
            						sum128[6] = sum128[6] + Double.valueOf(planNumS);
            					}
            					if(notuseNum!=null && !notuseNum.equals("")){
            						sum128[7] = sum128[7] + Double.valueOf(notuseNum);
            					}
            					if(notuseNumS!=null && !notuseNumS.equals("")){
            						sum128[8] = sum128[8] + Double.valueOf(notuseNumS);
            					}
            					if(safetyNum!=null && !safetyNum.equals("")){
            						sum128[9] = sum128[9] + Double.valueOf(safetyNum);
            					}
            					if(safetyNumS!=null && !safetyNumS.equals("")){
            						sum128[10] = sum128[10] + Double.valueOf(safetyNumS);
            					}
        					}
    					}
    					sum127[0] = sum127[0] + sum128[0];
    					sum127[1] = sum127[1] + sum128[1];
    					sum127[2] = sum127[2] + sum128[2];
    					sum127[3] = sum127[3] + sum128[3];
    					sum127[4] = sum127[4] + sum128[4];
    					sum127[5] = sum127[5] + sum128[5];
    					sum127[6] = sum127[6] + sum128[6];
    					sum127[7] = sum127[7] + sum128[7];
    					sum127[8] = sum127[8] + sum128[8];
    					sum127[9] = sum127[9] + sum128[9];
    					sum127[10] = sum127[10] + sum128[10];
    				}
    			}
    		}
    		sb.append(" <fo:table-row >")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append("总计").append(" </fo:block></fo:table-cell>")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append(df0.format(sum127[0])).append(" </fo:block></fo:table-cell>")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append(df0.format(sum127[1])).append(" </fo:block></fo:table-cell>")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append(df0.format(sum127[2])).append(" </fo:block></fo:table-cell>")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append(df0.format(sum127[3])).append(" </fo:block></fo:table-cell>")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append("").append(" </fo:block></fo:table-cell>")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append(df0.format(sum127[5])).append(" </fo:block></fo:table-cell>")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append(df0.format(sum127[6])).append(" </fo:block></fo:table-cell>")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append(df0.format(sum127[7])).append(" </fo:block></fo:table-cell>")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append(df0.format(sum127[8])).append(" </fo:block></fo:table-cell>")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append(df0.format(sum127[9])).append(" </fo:block></fo:table-cell>")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append(df0.format(sum127[10])).append(" </fo:block></fo:table-cell>")
			.append(" </fo:table-row >").append(line);
            

            fos.write(sb.toString());
            sb.delete(0, sb.length());
            
            
    		if(deviceList!=null && deviceList.size()>0){
    			for (int i = 0; i < deviceList.size(); i++) {
    				dateMap = (Map) deviceList.get(i);
    				if (dateMap != null) {
    					double []sum128 = new double[11];
    					for(int j = 0 ;j<11;j++){
    						sum128[j] = 0;
    					}
    					String name = (String)dateMap.get("deviceName");
    					for(int k= 0; k<deviceList.size();k++){
    						Map map = (Map)deviceList.get(k);
    						String deviceName = (String)map.get("deviceName");
    						if(deviceName!=null && !deviceName.equals("") && deviceName.equals(name)){
        						String totalNum = (String) map.get("totalNum");
            					String totalNumS = (String) map.get("totalNumS");
            					String useNum = (String) map.get("useNum");
            					String useNumS = (String) map.get("useNumS");
            					String useRate = (String) map.get("useRate");
            					String planNum = (String) map.get("planNum");
            					String planNumS = (String) map.get("planNumS");
            					String notuseNum = (String) map.get("notuseNum");
            					String notuseNumS = (String) map.get("notuseNumS");
            					String safetyNum = (String) map.get("safetyNum");
            					String safetyNumS = (String) map.get("safetyNumS");
            					if(totalNum!=null && !totalNum.equals("")){
            						sum128[0] = sum128[0] + Double.valueOf(totalNum);
            					}
            					if(totalNumS!=null && !totalNumS.equals("")){
            						sum128[1] = sum128[1] + Double.valueOf(totalNumS);
            					}
            					if(useNum!=null && !useNum.equals("")){
            						sum128[2] = sum128[2] + Double.valueOf(useNum);
            					}
            					if(useNumS!=null && !useNumS.equals("")){
            						sum128[3] = sum128[3] + Double.valueOf(useNumS);
            					}
            					if(useRate!=null && !useRate.equals("")){
            						sum128[4] = sum128[4] + Double.valueOf(useRate);
            					}
            					if(planNum!=null && !planNum.equals("")){
            						sum128[5] = sum128[5] + Double.valueOf(planNum);
            					}
            					if(planNumS!=null && !planNumS.equals("")){
            						sum128[6] = sum128[6] + Double.valueOf(planNumS);
            					}
            					if(notuseNum!=null && !notuseNum.equals("")){
            						sum128[7] = sum128[7] + Double.valueOf(notuseNum);
            					}
            					if(notuseNumS!=null && !notuseNumS.equals("")){
            						sum128[8] = sum128[8] + Double.valueOf(notuseNumS);
            					}
            					if(safetyNum!=null && !safetyNum.equals("")){
            						sum128[9] = sum128[9] + Double.valueOf(safetyNum);
            					}
            					if(safetyNumS!=null && !safetyNumS.equals("")){
            						sum128[10] = sum128[10] + Double.valueOf(safetyNumS);
            					}
        					}
    					}
    					if(name!=null && !name.equals("")){
        					sb.append(" <fo:table-row >")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(name).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[0])).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[1])).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[2])).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[3])).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(sum128[4]).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[5])).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[6])).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[7])).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[8])).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[9])).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[10])).append(" </fo:block></fo:table-cell>")
        					.append(" </fo:table-row >").append(line);
    					}
    				}

    	            fos.write(sb.toString());
    	            sb.delete(0, sb.length());
    	            
    			}
    		}
            sb.append(" </fo:table-body> </fo:table>").append(line).append(" <fo:block font-size='14pt' font-family='仿宋'")
            .append(" line-height='24pt' text-align='left' padding-right='13pt'> 2、国际可控震源</fo:block>").append(line)
            .append(" <fo:table table-layout='fixed' width='16cm' border-collapse='collapse' border-color='black' border-width='0.3mm' border-style='solid' font-size='10.5pt' font-family='仿宋' font-weight='normal'> <fo:table-column column-width='3cm'/>")
            .append(" <fo:table-column column-width='2.6cm'/> <fo:table-column column-width='2.6cm'/> <fo:table-column column-width='2.6cm'/>")
            .append(" <fo:table-column column-width='2.6cm'/> <fo:table-column column-width='2.6cm'/> <fo:table-body> ").append(line)
            .append(" <fo:table-row>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>型号</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>总量</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>在用</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>停用</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>计划投入</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>停用说明</fo:block></fo:table-cell>  </fo:table-row>").append(line);
            

            fos.write(sb.toString());
            sb.delete(0, sb.length());
            
            
            for(int j = 0 ;j<4;j++){
    			sum131[j] = 0;
    		}
    		if(deviceList15!=null && deviceList15.size()>0){
    			for (int i = 0; i < deviceList15.size(); i++) {
    				dateMap = (Map) deviceList15.get(i);
    				if (dateMap != null) {
    					double []sum132 = new double[5];
						for (int j = 0; j < 5; j++) {
    						sum132[j] = 0;
    					}
    					String name = (String)dateMap.get("deviceName");
    					String exlainInfo = (String)dateMap.get("exlainInfo");
    					if(exlainInfo ==null ){
    						exlainInfo = "";
    					}
    					for(int k= 0; k<deviceList15.size();k++){
    						Map map = (Map)deviceList15.get(k);
    						String deviceName = (String)map.get("deviceName");
    						if(deviceName!=null && !deviceName.equals("")&& deviceName.equals(name)){//&& deviceName.equals("A128")
        						String totalNum = (String) map.get("totalNum");
            					String useNum = (String) map.get("useNum");
            					String planNum = (String) map.get("planNum");
            					String safetyNum = (String) map.get("safetyNum");
            					if(totalNum!=null && !totalNum.equals("")){
            						sum132[0] = sum132[0] + Double.valueOf(totalNum);
            					}
            					if(useNum!=null && !useNum.equals("")){
            						sum132[1] = sum132[1] + Double.valueOf(useNum);
            					}
            					if(planNum!=null && !planNum.equals("")){
            						sum132[3] = sum132[3] + Double.valueOf(planNum);
            					}
            					if(safetyNum!=null && !safetyNum.equals("")){
            						sum132[2] = sum132[2] + Double.valueOf(safetyNum);
            					}
        					}
    					}
    					sum131[0] = sum131[0] + sum132[0];
    					sum131[1] = sum131[1] + sum132[1];
    					sum131[2] = sum131[2] + sum132[2];
    					sum131[3] = sum131[3] + sum132[3];
    				}
    			}
    		}
    		sb.append(" <fo:table-row >")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append("总计").append(" </fo:block></fo:table-cell>")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append(df0.format(sum131[0])).append(" </fo:block></fo:table-cell>")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append(df0.format(sum131[1])).append(" </fo:block></fo:table-cell>")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append(df0.format(sum131[2])).append(" </fo:block></fo:table-cell>")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append(df0.format(sum131[3])).append(" </fo:block></fo:table-cell>")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append("").append(" </fo:block></fo:table-cell>")
			.append(" </fo:table-row >").append(line);
           

            fos.write(sb.toString());
            sb.delete(0, sb.length());
            
            
    		if(deviceList15!=null && deviceList15.size()>0){
    			for (int i = 0; i < deviceList15.size(); i++) {
    				dateMap = (Map) deviceList15.get(i);
    				if (dateMap != null) {
    					double []sum132 = new double[11];
    					for(int j = 0 ;j<11;j++){
    						sum132[j] = 0;
    					}
    					String name = (String)dateMap.get("deviceName");
    					String exlainInfo = (String)dateMap.get("exlainInfo");
    					for(int k= 0; k<deviceList15.size();k++){
    						Map map = (Map)deviceList15.get(k);
    						String deviceName = (String)map.get("deviceName");
    						if(deviceName!=null && !deviceName.equals("") && deviceName.equals(name)){
        						String totalNum = (String) map.get("totalNum");
            					String useNum = (String) map.get("useNum");
            					String planNum = (String) map.get("planNum");
            					String safetyNum = (String) map.get("safetyNum");
            					if(totalNum!=null && !totalNum.equals("")){
            						sum132[0] = sum132[0] + Double.valueOf(totalNum);
            					}
            					if(useNum!=null && !useNum.equals("")){
            						sum132[1] = sum132[1] + Double.valueOf(useNum);
            					}
            					if(planNum!=null && !planNum.equals("")){
            						sum132[3] = sum132[3] + Double.valueOf(planNum);
            					}
            					if(safetyNum!=null && !safetyNum.equals("")){
            						sum132[2] = sum132[2] + Double.valueOf(safetyNum);
            					}
        					}
    					}
    					if(name!=null && !name.equals("")){
        					sb.append(" <fo:table-row >")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(name).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum132[0])).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum132[1])).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum132[2])).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum132[3])).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(exlainInfo).append(" </fo:block></fo:table-cell>")
        					.append(" </fo:table-row >").append(line);
    					}
    				}
    			}
    		}
            

            fos.write(sb.toString());
            sb.delete(0, sb.length());
            
            
            sb.append(" </fo:table-body> </fo:table>").append(line).append(" <fo:block font-size='14pt' font-family='仿宋'")
            .append(" line-height='24pt' text-align='left' padding-right='13pt'> 3、国内主要地震仪器 </fo:block>").append(line)
            .append(" <fo:table table-layout='fixed' width='16cm' border-collapse='collapse' border-color='black' border-width='0.3mm' border-style='solid' font-size='10.5pt' font-family='仿宋' font-weight='normal'> <fo:table-column column-width='4cm'/>")
            .append(" <fo:table-column column-width='1.4cm'/> <fo:table-column column-width='1.4cm'/> <fo:table-column column-width='1.4cm'/>")
            .append(" <fo:table-column column-width='1.4cm'/> <fo:table-column column-width='1.4cm'/> <fo:table-column column-width='1.4cm'/>")
            .append(" <fo:table-column column-width='1.4cm'/> <fo:table-column column-width='1.4cm'/> <fo:table-column column-width='1.4cm'/>")
            .append(" <fo:table-body>").append(line).append(" <fo:table-row >")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-rows-spanned='2' display-align='center'>")
            .append(" <fo:block  text-align='center'>仪器型号</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-columns-spanned='2' display-align='center'>")
            .append(" <fo:block text-align='center'>总量</fo:block> </fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-columns-spanned ='2' display-align='center'>")
            .append(" <fo:block  text-align='center'>在用</fo:block></fo:table-cell> <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'> 利用率</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-columns-spanned ='2' display-align='center'>")
            .append(" <fo:block  text-align='center'>计划投入使用</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-columns-spanned ='2' display-align='center'>")
            .append(" <fo:block  text-align='center'>可调用</fo:block></fo:table-cell> </fo:table-row>").append(line)
            .append(" <fo:table-row> <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>主机 （台）</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>道数  （道）</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>主机  （台）</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>道数  （道）</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>％</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>主机  （台）</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>道数  （道）</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>主机   （台）</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>完好  （道）</fo:block></fo:table-cell> </fo:table-row>").append(line);
            

            fos.write(sb.toString());
            sb.delete(0, sb.length());
            
            
            for(int j = 0 ;j<9;j++){
    			sum127[j] = 0;
    		}
    		if(deviceList137!=null && deviceList137.size()>0){
    			for (int i = 0; i < deviceList137.size(); i++) {
    				dateMap = (Map) deviceList137.get(i);
    				if (dateMap != null) {
    					double []sum128 = new double[9];
    					for(int j = 0 ;j<9;j++){
    						sum128[j] = 0;
    					}
    					String name = (String)dateMap.get("deviceName");
    					for(int k= 0; k<deviceList137.size();k++){
    						Map map = (Map)deviceList137.get(k);
    						String deviceName = (String)map.get("deviceName");
    						if(deviceName!=null && !deviceName.equals("") && deviceName.equals(name)){
        						String totalNum = (String) map.get("totalNum");
            					String totalNumS = (String) map.get("totalNumS");
            					String useNum = (String) map.get("useNum");
            					String useNumS = (String) map.get("useNumS");
            					String useRate = (String) map.get("useRate");
            					String planNum = (String) map.get("planNum");
            					String planNumS = (String) map.get("planNumS");
            					String trusferNum = (String) map.get("trusferNum");
            					String trusferNumS = (String) map.get("trusferNumS");
            					if(totalNum!=null && !totalNum.equals("")){
            						sum128[0] = sum128[0] + Double.valueOf(totalNum);
            					}
            					if(totalNumS!=null && !totalNumS.equals("")){
            						sum128[1] = sum128[1] + Double.valueOf(totalNumS);
            					}
            					if(useNum!=null && !useNum.equals("")){
            						sum128[2] = sum128[2] + Double.valueOf(useNum);
            					}
            					if(useNumS!=null && !useNumS.equals("")){
            						sum128[3] = sum128[3] + Double.valueOf(useNumS);
            					}
            					if(useRate!=null && !useRate.equals("")){
            						sum128[4] = sum128[4] + Double.valueOf(useRate);
            					}
            					if(planNum!=null && !planNum.equals("")){
            						sum128[5] = sum128[5] + Double.valueOf(planNum);
            					}
            					if(planNumS!=null && !planNumS.equals("")){
            						sum128[6] = sum128[6] + Double.valueOf(planNumS);
            					}
            					if(trusferNum!=null && !trusferNum.equals("")){
            						sum128[7] = sum128[7] + Double.valueOf(trusferNum);
            					}
            					if(trusferNumS!=null && !trusferNumS.equals("")){
            						sum128[8] = sum128[8] + Double.valueOf(trusferNumS);
            					}
        					}
    					}
    					sum127[0] = sum127[0] + sum128[0];
    					sum127[1] = sum127[1] + sum128[1];
    					sum127[2] = sum127[2] + sum128[2];
    					sum127[3] = sum127[3] + sum128[3];
    					sum127[4] = sum127[4] + sum128[4];
    					sum127[5] = sum127[5] + sum128[5];
    					sum127[6] = sum127[6] + sum128[6];
    					sum127[7] = sum127[7] + sum128[7];
    					sum127[8] = sum127[8] + sum128[8];
    				}
    			}
    		}
    		sb.append(" <fo:table-row >")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append("总计").append(" </fo:block></fo:table-cell>")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append(df0.format(sum127[0])).append(" </fo:block></fo:table-cell>")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append(df0.format(sum127[1])).append(" </fo:block></fo:table-cell>")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append(df0.format(sum127[2])).append(" </fo:block></fo:table-cell>")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append(df0.format(sum127[3])).append(" </fo:block></fo:table-cell>")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append("").append(" </fo:block></fo:table-cell>")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append(df0.format(sum127[5])).append(" </fo:block></fo:table-cell>")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append(df0.format(sum127[6])).append(" </fo:block></fo:table-cell>")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append(df0.format(sum127[7])).append(" </fo:block></fo:table-cell>")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append(df0.format(sum127[8])).append(" </fo:block></fo:table-cell>")
			.append(" </fo:table-row >").append(line);
            

            fos.write(sb.toString());
            sb.delete(0, sb.length());
            
            
    		if(deviceList137!=null && deviceList137.size()>0){
    			for (int i = 0; i < deviceList137.size(); i++) {
    				dateMap = (Map) deviceList137.get(i);
    				if (dateMap != null) {
    					double []sum128 = new double[11];
    					for(int j = 0 ;j<11;j++){
    						sum128[j] = 0;
    					}
    					String name = (String)dateMap.get("deviceName");
    					for(int k= 0; k<deviceList137.size();k++){
    						Map map = (Map)deviceList137.get(k);
    						String deviceName = (String)map.get("deviceName");
    						if(deviceName!=null && !deviceName.equals("") && deviceName.equals(name)){
    							String totalNum = (String) map.get("totalNum");
            					String totalNumS = (String) map.get("totalNumS");
            					String useNum = (String) map.get("useNum");
            					String useNumS = (String) map.get("useNumS");
            					String useRate = (String) map.get("useRate");
            					String planNum = (String) map.get("planNum");
            					String planNumS = (String) map.get("planNumS");
            					String trusferNum = (String) map.get("trusferNum");
            					String trusferNumS = (String) map.get("trusferNumS");
            					if(totalNum!=null && !totalNum.equals("")){
            						sum128[0] = sum128[0] + Double.valueOf(totalNum);
            					}
            					if(totalNumS!=null && !totalNumS.equals("")){
            						sum128[1] = sum128[1] + Double.valueOf(totalNumS);
            					}
            					if(useNum!=null && !useNum.equals("")){
            						sum128[2] = sum128[2] + Double.valueOf(useNum);
            					}
            					if(useNumS!=null && !useNumS.equals("")){
            						sum128[3] = sum128[3] + Double.valueOf(useNumS);
            					}
            					if(useRate!=null && !useRate.equals("")){
            						sum128[4] = sum128[4] + Double.valueOf(useRate);
            					}
            					if(planNum!=null && !planNum.equals("")){
            						sum128[5] = sum128[5] + Double.valueOf(planNum);
            					}
            					if(planNumS!=null && !planNumS.equals("")){
            						sum128[6] = sum128[6] + Double.valueOf(planNumS);
            					}
            					if(trusferNum!=null && !trusferNum.equals("")){
            						sum128[7] = sum128[7] + Double.valueOf(trusferNum);
            					}
            					if(trusferNumS!=null && !trusferNumS.equals("")){
            						sum128[8] = sum128[8] + Double.valueOf(trusferNumS);
            					}
        					}
    					}
    					if(name!=null && !name.equals("")){
        					sb.append(" <fo:table-row >")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(name).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[0])).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[1])).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[2])).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[3])).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[4])).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[5])).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[6])).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[7])).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[8])).append(" </fo:block></fo:table-cell>")
        					.append(" </fo:table-row >").append(line);

        		            fos.write(sb.toString());
        		            sb.delete(0, sb.length());
        		            
    					}
    				}
    			}
    		}
            sb.append(" </fo:table-body> </fo:table>").append(line).append(" <fo:block font-size='14pt' font-family='仿宋'")
            .append(" line-height='24pt' text-align='left' padding-right='13pt'> 4、国内测量仪器及可控震源</fo:block>").append(line)
            .append(" <fo:table table-layout='fixed' width='16cm' border-collapse='collapse' border-color='black' border-width='0.3mm' border-style='solid' font-size='10.5pt' font-family='仿宋' font-weight='normal'> <fo:table-column column-width='4cm'/>")
            .append(" <fo:table-column column-width='2.1cm'/> <fo:table-column column-width='2.1cm'/> <fo:table-column column-width='2.1cm'/>")
            .append(" <fo:table-column column-width='2.1cm'/> <fo:table-column column-width='2.1cm'/> <fo:table-column column-width='2.1cm'/>")
            .append(" <fo:table-body> ").append(line)
            .append(" <fo:table-row> <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>类型</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>仪器型号</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>总量(台)</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>在用</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>计划投入使用(台)</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>可调用台数</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>验收、维修中（台）</fo:block></fo:table-cell> </fo:table-row>").append(line);
            

            fos.write(sb.toString());
            sb.delete(0, sb.length());
            
            
            if(deviceList140!=null && deviceList140.size()>0){
    			for (int i = 0; i < deviceList140.size(); i++) {
    				dateMap = (Map) deviceList140.get(i);
    				if (dateMap != null) {
    					double []sum128 = new double[5];
    					for(int j = 0 ;j<5;j++){
    						sum128[j] = 0;
    					}
    					String name = (String)dateMap.get("deviceName");
    					for(int k= 0; k<deviceList140.size();k++){
    						Map map = (Map)deviceList140.get(k);
    						String deviceName = (String)map.get("deviceName");
    						if(deviceName!=null && !deviceName.equals("") && deviceName.equals(name)){
        						String totalNum = (String) map.get("totalNum");
            					String useNum = (String) map.get("useNum");
            					String planNum = (String) map.get("planNum");
            					String trusferNum = (String) map.get("trusferNum");
            					String safetyNum = (String) map.get("safetyNum");
            					if(totalNum!=null && !totalNum.equals("")){
            						sum128[0] = sum128[0] + Double.valueOf(totalNum);
            					}
            					if(useNum!=null && !useNum.equals("")){
            						sum128[1] = sum128[1] + Double.valueOf(useNum);
            					}
            					if(planNum!=null && !planNum.equals("")){
            						sum128[2] = sum128[2] + Double.valueOf(planNum);
            					}
            					if(trusferNum!=null && !trusferNum.equals("")){
            						sum128[3] = sum128[3] + Double.valueOf(trusferNum);
            					}
            					if(safetyNum!=null && !safetyNum.equals("")){
            						sum128[4] = sum128[4] + Double.valueOf(safetyNum);
            					}
        					}
    					}
    					if(name!=null && !name.equals("")){
        					sb.append(" <fo:table-row >")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append("测量仪器").append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(name).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[0])).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[1])).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[2])).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[3])).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[4])).append(" </fo:block></fo:table-cell>")
        					.append(" </fo:table-row >").append(line);

        		            fos.write(sb.toString());
        		            sb.delete(0, sb.length());
        		            
    					}
    				}
    			}
    		}
            if(deviceList141!=null && deviceList141.size()>0){
    			for (int i = 0; i < deviceList141.size(); i++) {
    				dateMap = (Map) deviceList141.get(i);
    				if (dateMap != null) {
    					double []sum128 = new double[5];
    					for(int j = 0 ;j<5;j++){
    						sum128[j] = 0;
    					}
    					String name = (String)dateMap.get("deviceName");
    					for(int k= 0; k<deviceList141.size();k++){
    						Map map = (Map)deviceList141.get(k);
    						String deviceName = (String)map.get("deviceName");
    						if(deviceName!=null && !deviceName.equals("") && deviceName.equals(name)){
        						String totalNum = (String) map.get("totalNum");
            					String useNum = (String) map.get("useNum");
            					String planNum = (String) map.get("planNum");
            					String trusferNum = (String) map.get("trusferNum");
            					String safetyNum = (String) map.get("safetyNum");
            					if(totalNum!=null && !totalNum.equals("")){
            						sum128[0] = sum128[0] + Double.valueOf(totalNum);
            					}
            					if(useNum!=null && !useNum.equals("")){
            						sum128[1] = sum128[1] + Double.valueOf(useNum);
            					}
            					if(planNum!=null && !planNum.equals("")){
            						sum128[2] = sum128[2] + Double.valueOf(planNum);
            					}
            					if(trusferNum!=null && !trusferNum.equals("")){
            						sum128[3] = sum128[3] + Double.valueOf(trusferNum);
            					}
            					if(safetyNum!=null && !safetyNum.equals("")){
            						sum128[4] = sum128[4] + Double.valueOf(safetyNum);
            					}
        					}
    					}
    					if(name!=null && !name.equals("")){
        					sb.append(" <fo:table-row >")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append("可控震源").append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(name).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[0])).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[1])).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[2])).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[3])).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[4])).append(" </fo:block></fo:table-cell>")
        					.append(" </fo:table-row >").append(line);

        		            fos.write(sb.toString());
        		            sb.delete(0, sb.length());
        		            
    					}
    				}
    			}
    		}
            sb.append(" </fo:table-body> </fo:table>").append(line);
            if("C105007".startsWith(affordOrg)){
            	sb.append(" <fo:block font-size='14pt' font-family='仿宋'")
            	.append(" line-height='24pt' text-align='left' padding-right='13pt'>  5、大港物探处主要地震仪器 </fo:block>").append(line)
            	.append(" <fo:table table-layout='fixed' width='16cm' border-collapse='collapse' border-color='black' border-width='0.3mm' border-style='solid' font-size='10.5pt' font-family='仿宋' font-weight='normal'> <fo:table-column column-width='4cm'/>")
            	.append(" <fo:table-column column-width='1.4cm'/> <fo:table-column column-width='1.4cm'/> <fo:table-column column-width='1.4cm'/>")
            	.append(" <fo:table-column column-width='1.4cm'/> <fo:table-column column-width='1.4cm'/> <fo:table-column column-width='1.4cm'/>")
            	.append(" <fo:table-column column-width='1.4cm'/> <fo:table-column column-width='1.4cm'/> <fo:table-column column-width='1.4cm'/>")
            	.append(" <fo:table-body>").append(line).append(" <fo:table-row >")
            	.append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-rows-spanned='2' display-align='center'>")
            	.append(" <fo:block  text-align='center'>仪器型号</fo:block></fo:table-cell>")
            	.append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-columns-spanned='2' display-align='center'>")
            	.append(" <fo:block text-align='center'>总量</fo:block> </fo:table-cell>")
            	.append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-columns-spanned ='2' display-align='center'>")
            	.append(" <fo:block  text-align='center'>在用</fo:block></fo:table-cell> <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            	.append(" <fo:block text-align='center'> 利用率</fo:block></fo:table-cell>")
            	.append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-columns-spanned ='2' display-align='center'>")
            	.append(" <fo:block  text-align='center'>计划投入使用</fo:block></fo:table-cell>")
            	.append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-columns-spanned ='2' display-align='center'>")
            	.append(" <fo:block  text-align='center'>可调用</fo:block></fo:table-cell> </fo:table-row>").append(line)
            	.append(" <fo:table-row> <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            	.append(" <fo:block text-align='center'>主机 （台）</fo:block></fo:table-cell>")
            	.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            	.append(" <fo:block text-align='center'>道数  （道）</fo:block></fo:table-cell>")
            	.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            	.append(" <fo:block text-align='center'>主机  （台）</fo:block></fo:table-cell>")
            	.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            	.append(" <fo:block text-align='center'>道数  （道）</fo:block></fo:table-cell>")
            	.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            	.append(" <fo:block text-align='center'>％</fo:block></fo:table-cell>")
            	.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            	.append(" <fo:block text-align='center'>主机  （台）</fo:block></fo:table-cell>")
            	.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            	.append(" <fo:block text-align='center'>道数  （道）</fo:block></fo:table-cell>")
            	.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            	.append(" <fo:block text-align='center'>主机   （台）</fo:block></fo:table-cell>")
            	.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            	.append(" <fo:block text-align='center'>道数  （道）</fo:block></fo:table-cell> </fo:table-row>").append(line);
           

            	fos.write(sb.toString());
            	sb.delete(0, sb.length());
            
            	for(int j = 0 ;j<11;j++){
            		sum127[j] = 0;
            	}
            	if(deviceList147!=null && deviceList147.size()>0){
            		for (int i = 0; i < deviceList147.size(); i++) {
            			dateMap = (Map) deviceList147.get(i);
            			if (dateMap != null) {
            				double []sum128 = new double[9];
            				for(int j = 0 ;j<9;j++){
            					sum128[j] = 0;
            				}
            				String name = (String)dateMap.get("deviceName");
            				for(int k= 0; k<deviceList147.size();k++){
            					Map map = (Map)deviceList147.get(k);
            					String deviceName = (String)map.get("deviceName");
            					if(deviceName!=null && !deviceName.equals("") && deviceName.equals(name)){
            						String totalNum = (String) map.get("totalNum");
            						String totalNumS = (String) map.get("totalNumS");
            						String useNum = (String) map.get("useNum");
            						String useNumS = (String) map.get("useNumS");
            						String useRate = (String) map.get("useRate");
            						String planNum = (String) map.get("planNum");
            						String planNumS = (String) map.get("planNumS");
            						String trusferNum = (String) map.get("trusferNum");
            						String trusferNumS = (String) map.get("trusferNumS");
            						if(totalNum!=null && !totalNum.equals("")){
            							sum128[0] = sum128[0] + Double.valueOf(totalNum);
            						}
            						if(totalNumS!=null && !totalNumS.equals("")){
            							sum128[1] = sum128[1] + Double.valueOf(totalNumS);
            						}
	            					if(useNum!=null && !useNum.equals("")){
	            						sum128[2] = sum128[2] + Double.valueOf(useNum);
	            					}
	            					if(useNumS!=null && !useNumS.equals("")){
	            						sum128[3] = sum128[3] + Double.valueOf(useNumS);
	            					}
	            					if(useRate!=null && !useRate.equals("")){
	            						sum128[4] = sum128[4] + Double.valueOf(useRate);
	            					}
	            					if(planNum!=null && !planNum.equals("")){
	            						sum128[5] = sum128[5] + Double.valueOf(planNum);
	            					}
	            					if(planNumS!=null && !planNumS.equals("")){
	            						sum128[6] = sum128[6] + Double.valueOf(planNumS);
	            					}
	            					if(trusferNum!=null && !trusferNum.equals("")){
	            						sum128[7] = sum128[7] + Double.valueOf(trusferNum);
	            					}
	            					if(trusferNumS!=null && !trusferNumS.equals("")){
	            						sum128[8] = sum128[8] + Double.valueOf(trusferNumS);
	            					}
	        					}
	    					}
	    					sum127[0] = sum127[0] + sum128[0];
	    					sum127[1] = sum127[1] + sum128[1];
	    					sum127[2] = sum127[2] + sum128[2];
	    					sum127[3] = sum127[3] + sum128[3];
	    					sum127[4] = sum127[4] + sum128[4];
	    					sum127[5] = sum127[5] + sum128[5];
	    					sum127[6] = sum127[6] + sum128[6];
	    					sum127[7] = sum127[7] + sum128[7];
	    					sum127[8] = sum127[8] + sum128[8];
	    				}
	    			}
	    		}
	    		sb.append(" <fo:table-row >")
				.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
				.append(" <fo:block  text-align='center'>").append("总计").append(" </fo:block></fo:table-cell>")
				.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
				.append(" <fo:block  text-align='center'>").append(df0.format(sum127[0])).append(" </fo:block></fo:table-cell>")
				.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
				.append(" <fo:block  text-align='center'>").append(df0.format(sum127[1])).append(" </fo:block></fo:table-cell>")
				.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
				.append(" <fo:block  text-align='center'>").append(df0.format(sum127[2])).append(" </fo:block></fo:table-cell>")
				.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
				.append(" <fo:block  text-align='center'>").append(df0.format(sum127[3])).append(" </fo:block></fo:table-cell>")
				.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
				.append(" <fo:block  text-align='center'>").append("").append(" </fo:block></fo:table-cell>")
				.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
				.append(" <fo:block  text-align='center'>").append(df0.format(sum127[5])).append(" </fo:block></fo:table-cell>")
				.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
				.append(" <fo:block  text-align='center'>").append(df0.format(sum127[6])).append(" </fo:block></fo:table-cell>")
				.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
				.append(" <fo:block  text-align='center'>").append(df0.format(sum127[7])).append(" </fo:block></fo:table-cell>")
				.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
				.append(" <fo:block  text-align='center'>").append(df0.format(sum127[8])).append(" </fo:block></fo:table-cell>")
				.append(" </fo:table-row >").append(line);
	            
	
	            fos.write(sb.toString());
	            sb.delete(0, sb.length());
	            
	            
	    		if(deviceList147!=null && deviceList147.size()>0){
	    			for (int i = 0; i < deviceList147.size(); i++) {
	    				dateMap = (Map) deviceList147.get(i);
	    				if (dateMap != null) {
	    					double []sum128 = new double[11];
	    					for(int j = 0 ;j<11;j++){
	    						sum128[j] = 0;
	    					}
	    					String name = (String)dateMap.get("deviceName");
	    					for(int k= 0; k<deviceList147.size();k++){
	    						Map map = (Map)deviceList147.get(k);
	    						String deviceName = (String)map.get("deviceName");
	    						if(deviceName!=null && !deviceName.equals("") && deviceName.equals(name)){
	    							String totalNum = (String) map.get("totalNum");
	            					String totalNumS = (String) map.get("totalNumS");
	            					String useNum = (String) map.get("useNum");
	            					String useNumS = (String) map.get("useNumS");
	            					String useRate = (String) map.get("useRate");
	            					String planNum = (String) map.get("planNum");
	            					String planNumS = (String) map.get("planNumS");
	            					String trusferNum = (String) map.get("trusferNum");
	            					String trusferNumS = (String) map.get("trusferNumS");
	            					if(totalNum!=null && !totalNum.equals("")){
	            						sum128[0] = sum128[0] + Double.valueOf(totalNum);
	            					}
	            					if(totalNumS!=null && !totalNumS.equals("")){
	            						sum128[1] = sum128[1] + Double.valueOf(totalNumS);
	            					}
	            					if(useNum!=null && !useNum.equals("")){
	            						sum128[2] = sum128[2] + Double.valueOf(useNum);
	            					}
            						if(useNumS!=null && !useNumS.equals("")){
            							sum128[3] = sum128[3] + Double.valueOf(useNumS);
            						}
            						if(useRate!=null && !useRate.equals("")){
            							sum128[4] = sum128[4] + Double.valueOf(useRate);
            						}
            						if(planNum!=null && !planNum.equals("")){
            							sum128[5] = sum128[5] + Double.valueOf(planNum);
            						}
            						if(planNumS!=null && !planNumS.equals("")){
            							sum128[6] = sum128[6] + Double.valueOf(planNumS);
            						}
	            					if(trusferNum!=null && !trusferNum.equals("")){
	            						sum128[7] = sum128[7] + Double.valueOf(trusferNum);
	            					}
	            					if(trusferNumS!=null && !trusferNumS.equals("")){
	            						sum128[8] = sum128[8] + Double.valueOf(trusferNumS);
            						}
        						}
    						}
    						if(name!=null && !name.equals("")){
        						sb.append(" <fo:table-row >")
        						.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        						.append(" <fo:block  text-align='center'>").append(name).append(" </fo:block></fo:table-cell>")
        						.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        						.append(" <fo:block  text-align='center'>").append(df0.format(sum128[0])).append(" </fo:block></fo:table-cell>")
        						.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        						.append(" <fo:block  text-align='center'>").append(df0.format(sum128[1])).append(" </fo:block></fo:table-cell>")
        						.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        						.append(" <fo:block  text-align='center'>").append(df0.format(sum128[2])).append(" </fo:block></fo:table-cell>")
        						.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        						.append(" <fo:block  text-align='center'>").append(df0.format(sum128[3])).append(" </fo:block></fo:table-cell>")
        						.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        						.append(" <fo:block  text-align='center'>").append(df0.format(sum128[4])).append(" </fo:block></fo:table-cell>")
        						.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        						.append(" <fo:block  text-align='center'>").append(df0.format(sum128[5])).append(" </fo:block></fo:table-cell>")
        						.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        						.append(" <fo:block  text-align='center'>").append(df0.format(sum128[6])).append(" </fo:block></fo:table-cell>")
        						.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        						.append(" <fo:block  text-align='center'>").append(df0.format(sum128[7])).append(" </fo:block></fo:table-cell>")
        						.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        						.append(" <fo:block  text-align='center'>").append(df0.format(sum128[8])).append(" </fo:block></fo:table-cell>")
        						.append(" </fo:table-row >").append(line);

        		            	fos.write(sb.toString());
        		            	sb.delete(0, sb.length());
        		            
    						}
    					}
    				}
    			}
    			sb.append(" </fo:table-body> </fo:table> ").append(line);
            }
            if("C105063".startsWith(affordOrg)){
	            sb.append(" <fo:block font-size='14pt' font-family='仿宋'")
	            .append(" line-height='24pt' text-align='left' padding-right='13pt'>" )
	            .append(" 6、辽河物探处主要地震仪器</fo:block>").append(line);
	           
	            sb.append(" <fo:table table-layout='fixed' width='19cm' border-collapse='collapse' border-color='black' border-width='0.3mm' border-style='solid' font-size='10.5pt' font-family='仿宋' font-weight='normal'> <fo:table-column column-width='4.2cm'/>")
	            .append(" <fo:table-column column-width='1.5cm'/> <fo:table-column column-width='1.6cm'/> <fo:table-column column-width='1.5cm'/>")
	            .append(" <fo:table-column column-width='1.6cm'/> <fo:table-column column-width='1.5cm'/> <fo:table-column column-width='1.6cm'/>")
	            .append(" <fo:table-column column-width='1.5cm'/> <fo:table-column column-width='1.6cm'/>")
	            .append(" <fo:table-body>").append(line).append(" <fo:table-row >")
	            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-rows-spanned='2' display-align='center'>")
	            .append(" <fo:block  text-align='center'>仪器型号</fo:block></fo:table-cell>")
	            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-columns-spanned='2' display-align='center'>")
	            .append(" <fo:block text-align='center'>总量</fo:block> </fo:table-cell>")
	            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-columns-spanned ='2' display-align='center'>")
	            .append(" <fo:block  text-align='center'>在用</fo:block></fo:table-cell> ")
	            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-columns-spanned ='2' display-align='center'>")
	            .append(" <fo:block  text-align='center'>计划投入使用</fo:block></fo:table-cell>")
	            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' number-columns-spanned ='2' display-align='center'>")
	            .append(" <fo:block  text-align='center'>可调用</fo:block></fo:table-cell> </fo:table-row>").append(line)
	            .append(" <fo:table-row> <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
	            .append(" <fo:block text-align='center'>主机 （台）</fo:block></fo:table-cell>")
	            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
	            .append(" <fo:block text-align='center'>道数  （道）</fo:block></fo:table-cell>")
	            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
	            .append(" <fo:block text-align='center'>主机  （台）</fo:block></fo:table-cell>")
	            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
	            .append(" <fo:block text-align='center'>道数  （道）</fo:block></fo:table-cell>")
	            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
	            .append(" <fo:block text-align='center'>主机  （台）</fo:block></fo:table-cell>")
	            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
	            .append(" <fo:block text-align='center'>道数  （道）</fo:block></fo:table-cell>")
	            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
	            .append(" <fo:block text-align='center'>道数  （道）</fo:block></fo:table-cell>")
	            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
	            .append(" <fo:block text-align='center'>道数  （道）</fo:block></fo:table-cell> </fo:table-row>").append(line);
	            
	
	            fos.write(sb.toString());
	            sb.delete(0, sb.length());
	            
	            
	            for(int j = 0 ;j<11;j++){
	    			sum127[j] = 0;
	    		}
	    		if(deviceList152!=null && deviceList152.size()>0){
	    			for (int i = 0; i < deviceList152.size(); i++) {
	    				dateMap = (Map) deviceList152.get(i);
	    				if (dateMap != null) {
	    					double []sum128 = new double[11];
	    					for(int j = 0 ;j<9;j++){
	    						sum128[j] = 0;
	    					}
	    					String name = (String)dateMap.get("deviceName");
	    					for(int k= 0; k < deviceList152.size();k++){
	    						Map map = (Map)deviceList152.get(k);
	    						String deviceName = (String)map.get("deviceName");
	    						if(deviceName!=null && !deviceName.equals("") && deviceName.equals(name)){
	    							String totalNum = (String) map.get("totalNum");
	            					String totalNumS = (String) map.get("totalNumS");
	            					String useNum = (String) map.get("useNum");
	            					String useNumS = (String) map.get("useNumS");
	            					String useRate = (String) map.get("useRate");
	            					String planNum = (String) map.get("planNum");
	            					String planNumS = (String) map.get("planNumS");
	            					String trusferNum = (String) map.get("trusferNum");
	            					String trusferNumS = (String) map.get("trusferNumS");
	            					if(totalNum!=null && !totalNum.equals("")){
	            						sum128[0] = sum128[0] + Double.valueOf(totalNum);
	            					}
	            					if(totalNumS!=null && !totalNumS.equals("")){
	            						sum128[1] = sum128[1] + Double.valueOf(totalNumS);
	            					}
	            					if(useNum!=null && !useNum.equals("")){
	            						sum128[2] = sum128[2] + Double.valueOf(useNum);
	            					}
	            					if(useNumS!=null && !useNumS.equals("")){
	            						sum128[3] = sum128[3] + Double.valueOf(useNumS);
	            					}
	            					if(useRate!=null && !useRate.equals("")){
	            						sum128[4] = sum128[4] + Double.valueOf(useRate);
	            					}
	            					if(planNum!=null && !planNum.equals("")){
	            						sum128[5] = sum128[5] + Double.valueOf(planNum);
	            					}
	            					if(planNumS!=null && !planNumS.equals("")){
	            						sum128[6] = sum128[6] + Double.valueOf(planNumS);
	            					}
	            					if(trusferNum!=null && !trusferNum.equals("")){
	            						sum128[7] = sum128[7] + Double.valueOf(trusferNum);
	            					}
	            					if(trusferNumS!=null && !trusferNumS.equals("")){
	            						sum128[8] = sum128[8] + Double.valueOf(trusferNumS);
	            					}
	        					}
	    					}
	    					sum127[0] = sum127[0] + sum128[0];
	    					sum127[1] = sum127[1] + sum128[1];
	    					sum127[2] = sum127[2] + sum128[2];
	    					sum127[3] = sum127[3] + sum128[3];
	    					sum127[5] = sum127[5] + sum128[5];
	    					sum127[6] = sum127[6] + sum128[6];
	    					sum127[7] = sum127[7] + sum128[7];
	    					sum127[8] = sum127[8] + sum128[8];
	    				}
	    			}
	    		}
	    		sb.append(" <fo:table-row >")
				.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
				.append(" <fo:block  text-align='center'>").append("总计").append(" </fo:block></fo:table-cell>")
				.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
				.append(" <fo:block  text-align='center'>").append(df0.format(sum127[0])).append(" </fo:block></fo:table-cell>")
				.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
				.append(" <fo:block  text-align='center'>").append(df0.format(sum127[1])).append(" </fo:block></fo:table-cell>")
				.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
				.append(" <fo:block  text-align='center'>").append(df0.format(sum127[2])).append(" </fo:block></fo:table-cell>")
				.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
				.append(" <fo:block  text-align='center'>").append(df0.format(sum127[3])).append(" </fo:block></fo:table-cell>")
				.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
				.append(" <fo:block  text-align='center'>").append(df0.format(sum127[5])).append(" </fo:block></fo:table-cell>")
				.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
				.append(" <fo:block  text-align='center'>").append(df0.format(sum127[6])).append(" </fo:block></fo:table-cell>")
				.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
				.append(" <fo:block  text-align='center'>").append(df0.format(sum127[7])).append(" </fo:block></fo:table-cell>")
				.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
				.append(" <fo:block  text-align='center'>").append(df0.format(sum127[8])).append(" </fo:block></fo:table-cell>")
				.append(" </fo:table-row >").append(line);
	            
	
	            fos.write(sb.toString());
	            sb.delete(0, sb.length());
	            
	            
	    		if(deviceList152!=null && deviceList152.size()>0){
	    			for (int i = 0; i < deviceList152.size(); i++) {
	    				dateMap = (Map) deviceList152.get(i);
	    				if (dateMap != null) {
	    					double []sum128 = new double[11];
	    					for(int j = 0 ;j<11;j++){
	    						sum128[j] = 0;
	    					}
	    					String name = (String)dateMap.get("deviceName");
	    					for(int k= 0; k<deviceList152.size();k++){
	    						Map map = (Map)deviceList152.get(k);
	    						String deviceName = (String)map.get("deviceName");
	    						if(deviceName!=null && !deviceName.equals("") && deviceName.equals(name)){
	    							String totalNum = (String) map.get("totalNum");
	            					String totalNumS = (String) map.get("totalNumS");
	            					String useNum = (String) map.get("useNum");
	            					String useNumS = (String) map.get("useNumS");
	            					String useRate = (String) map.get("useRate");
	            					String planNum = (String) map.get("planNum");
	            					String planNumS = (String) map.get("planNumS");
	            					String trusferNum = (String) map.get("trusferNum");
	            					String trusferNumS = (String) map.get("trusferNumS");
	            					if(totalNum!=null && !totalNum.equals("")){
	            						sum128[0] = sum128[0] + Double.valueOf(totalNum);
	            					}
	            					if(totalNumS!=null && !totalNumS.equals("")){
	            						sum128[1] = sum128[1] + Double.valueOf(totalNumS);
	            					}
	            					if(useNum!=null && !useNum.equals("")){
	            						sum128[2] = sum128[2] + Double.valueOf(useNum);
	            					}
	            					if(useNumS!=null && !useNumS.equals("")){
	            						sum128[3] = sum128[3] + Double.valueOf(useNumS);
	            					}
	            					if(useRate!=null && !useRate.equals("")){
	            						sum128[4] = sum128[4] + Double.valueOf(useRate);
	            					}
	            					if(planNum!=null && !planNum.equals("")){
	            						sum128[5] = sum128[5] + Double.valueOf(planNum);
	            					}
	            					if(planNumS!=null && !planNumS.equals("")){
	            						sum128[6] = sum128[6] + Double.valueOf(planNumS);
	            					}
	            					if(trusferNum!=null && !trusferNum.equals("")){
	            						sum128[7] = sum128[7] + Double.valueOf(trusferNum);
	            					}
	            					if(trusferNumS!=null && !trusferNumS.equals("")){
	            						sum128[8] = sum128[8] + Double.valueOf(trusferNumS);
	            					}
	        					}
	    					}
	    					if(name!=null && !name.equals("")){
	        					sb.append(" <fo:table-row >")
	        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
	        					.append(" <fo:block  text-align='center'>").append(name).append(" </fo:block></fo:table-cell>")
	        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
	        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[0])).append(" </fo:block></fo:table-cell>")
	        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
	        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[1])).append(" </fo:block></fo:table-cell>")
	        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
	        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[2])).append(" </fo:block></fo:table-cell>")
	        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
	        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[3])).append(" </fo:block></fo:table-cell>")
	        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
	        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[5])).append(" </fo:block></fo:table-cell>")
	        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
	        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[6])).append(" </fo:block></fo:table-cell>")
	        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
	        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[7])).append(" </fo:block></fo:table-cell>")
	        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
	        					.append(" <fo:block  text-align='center'>").append(df0.format(sum128[8])).append(" </fo:block></fo:table-cell>")
	        					.append(" </fo:table-row >").append(line);
	
	        		            fos.write(sb.toString());
	        		            sb.delete(0, sb.length());
	        		            
	    					}
	    				}
	    			}
	    		}
	    		sb.append(" </fo:table-body> </fo:table> ").append(line);
            }
            sb.append(" <fo:block font-size='15pt' font-family='黑体'")
            .append(" font-weight='bold' line-height='24pt' text-align='left' padding-right='13pt'> 七、物资供应动态 </fo:block>").append(line)
            .append(" <fo:table table-layout='fixed' width='16cm' border-collapse='collapse' border-color='black' border-width='0.3mm' border-style='solid' font-size='10.5pt' font-family='仿宋' font-weight='normal'>")
            .append(" <fo:table-column column-width='4cm'/> <fo:table-column column-width='6.6cm'/>")
            .append(" <fo:table-column column-width='3cm'/> <fo:table-column column-width='3cm'/> <fo:table-body>").append(line)
            .append("<fo:table-row>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>基层单位</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>服务小队（项目）</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>现场服务人员</fo:block></fo:table-cell>")
            .append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
            .append(" <fo:block text-align='center'>期末库存（万元）</fo:block></fo:table-cell> </fo:table-row>").append(line);

            fos.write(sb.toString());
            sb.delete(0, sb.length());
            
            double I157 = 0;
            double K157 = 0;
            if(deviceList156!=null && deviceList156.size()>0){
    			for (int i = 0; i < deviceList156.size(); i++) {
    				dateMap = (Map) deviceList156.get(i);
    				if (dateMap != null) {
    					String orgAbbreviation = (String)dateMap.get("orgAbbreviation");
    					if(orgAbbreviation!=null && !orgAbbreviation.equals("")){
    						String serviceInfo = (String)dateMap.get("serviceInfo");
    						String userNum = (String)dateMap.get("userNum");
    						String stockNum = (String)dateMap.get("stockNum");
    						if(userNum !=null && !userNum.equals("")){
    							I157 = I157 + Double.valueOf(userNum);
    						}
    						if(stockNum !=null && !stockNum.equals("")){
    							K157 = K157 + Double.valueOf(stockNum);
    						}
        					sb.append(" <fo:table-row >")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(orgAbbreviation).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(serviceInfo).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(userNum).append(" </fo:block></fo:table-cell>")
        					.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
        					.append(" <fo:block  text-align='center'>").append(stockNum).append(" </fo:block></fo:table-cell>")
        					.append(" </fo:table-row >").append(line);

        		            fos.write(sb.toString());
        		            sb.delete(0, sb.length());
        		            
    					}
    				}
    			}
    		}
            sb.append(" <fo:table-row >")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append("合计").append(" </fo:block></fo:table-cell>")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append(C157).append(" </fo:block></fo:table-cell>")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append(df0.format(I157)).append(" </fo:block></fo:table-cell>")
			.append(" <fo:table-cell border-width='0.3mm' border-style='solid' display-align='center'>")
			.append(" <fo:block  text-align='center'>").append(df0.format(K157)).append(" </fo:block></fo:table-cell>")
			.append(" </fo:table-row >").append(line).append(" </fo:table-body> </fo:table>")
            .append(" </fo:flow>")
            .append(" </fo:page-sequence>")
            .append(" </fo:root>");

            fos.write(sb.toString());
            sb.delete(0, sb.length());
            
            fos.flush();
            fos.close();
            
//            
//            String fileContent = sb.toString();
//            fileContent = fileContent.replace("\'", "\"");
//            byte  []buf = fileContent.getBytes();
//            int count = buf.length;
//            
//            fos.write(buf,0,count);
//            fos.close();
            //Setup input and output files  alignment.fo
            //File fofile = new File(baseDir, "xml/fo/helloworld.fo");
	        //File fofile = new File(baseDir, "xml/fo/advanced/giro.fo");
	        //File fofile = new File(baseDir, "xml/fo/web.fo");
//            File fofile = new File("/fo/fo/web.fo");

            System.out.println("Input: XSL-FO (" + foFile.getAbsolutePath() + ")");
            
//            File rtffile;
            WSFile wsfile = new WSFile();
            
            if("rtf".equals(fileType)){

//                rtffile = new File(outDir, "公司主业生产经营（周）信息简报.rtf");
                
	            System.out.println("Output: RTF (" + rtfFile.getAbsolutePath() + ")");
	            System.out.println();
	            System.out.println("Transforming...");
	
	            /*ExampleFO2RTF app = new ExampleFO2RTF();
	            app.*/
	            convertFO2RTF(foFile, rtfFile);
	            System.out.println("Success!");

	            wsfile.setFilename("公司主业生产经营（周）信息简报.doc");
	            wsfile.setType("application/msword");
            }else{
            	
            	StreamSource xmlSource = new StreamSource(foFile);   
            	String classesDir = Thread.currentThread().getContextClassLoader().getResource("/").getPath();
            	File webRootPath = new File(classesDir).getParentFile().getParentFile();
            	
                StreamSource xsl = new StreamSource(new File(webRootPath, "/pm/hq/productionControlWeekfo2html.xsl"));   
                Result outputTarget = new StreamResult(htmlFile);   
                Transformer ts = TransformerFactory.newInstance().newTransformer(xsl);   
                ts.transform(xmlSource, outputTarget);   
                
                rtfFile = htmlFile;
            	wsfile.setFilename("公司主业生产经营（周）信息简报.html");
            	wsfile.setType("text/html");
            	
            }
            
            String filePath = rtfFile.getAbsolutePath();
//            String filePath = fofile.getAbsolutePath();
            String result = null;   
            DefaultStyledDocument styledDoc = new DefaultStyledDocument();    
            InputStream is = new FileInputStream(rtfFile);    
            new RTFEditorKit().read(is, styledDoc, 0);    
            result = new String(styledDoc.getText(0,styledDoc.getLength()).getBytes("GBK"),"GBK");    
            //提取文本，读取中文需要使用ISO8859_1编码，否则会出现乱码 
//            System.out.println(result);
            filePath = filePath.replaceAll("\\\\","\\\\\\\\");
            FileInputStream fis = new FileInputStream(filePath);
//            fis = new FileInputStream("C:\\222.rtf");
            int a = fis.available();
            byte[] data = new byte[a]; //数据存储的数组fis.available()
            int i = 0; //当前下标
            int n = fis.read();
			while (n != -1) { // 未到达流的末尾
				data[i] = (byte) n;
				i++;
				n = fis.read();
				
			}
            fis.close(); 
            
            wsfile.setFileData(data);
           
            mqmsgimpl.setFile(wsfile);
            
        } catch (Exception e) {
            e.printStackTrace(System.err);
        }
        return mqmsgimpl;
	}
}
