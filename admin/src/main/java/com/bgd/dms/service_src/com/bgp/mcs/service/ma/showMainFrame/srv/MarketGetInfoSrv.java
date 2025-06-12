package com.bgp.mcs.service.ma.showMainFrame.srv;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.mcs.service.ma.showMainFrame.util.MarketGetInfoUtil;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

/**
 * 
 * ���⣺��̽��������ϵͳ
 * 
 * רҵ����̽רҵ
 * 
 * ��˾���������
 * 
 * ���ߣ����챪��2011-9-5
 * 
 * �������г���Ϣƽ̨չʾҳ��ͨ�÷�����
 */
@SuppressWarnings({ "rawtypes", "unchecked" })
public class MarketGetInfoSrv extends BaseService {

	private MarketGetInfoUtil mg = MarketGetInfoUtil.getInstance();
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();

	/*
	 * ��ҳ
	 */
	public ISrvMsg getHomePageInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		// ��˾�г���̬
		List sczyb = mg.getMarketHeadingInfoByType("10201002", 1);
		responseDTO.setValue("sczyb", sczyb);
		List jzgzl = mg.getMarketHeadingInfoByType("10201001", 1);
		responseDTO.setValue("jzgzl", jzgzl);
		// ��̽��˾��̬
		List wtgstt = mg.getMarketHeadingInfoByType2("10802002", 3);
		responseDTO.setValue("wtgstt", wtgstt);
		// ���﹫˾��̬
		List ytgstt = mg.getMarketHeadingInfoByType2("10801002", 3);
		responseDTO.setValue("ytgstt", ytgstt);
		// ��ҳͼƬ
		List sytp = mg.getMarketNewPictureUrl(6);
		responseDTO.setValue("sytp", sytp);
		// ��ҵ����
		List hydt = mg.getMarketHeadingInfoByType3("10306", 7);
		responseDTO.setValue("hydt", hydt);
		// ������̬
		List zjdt = mg.getMarketHeadingInfoByType3("10307", 7);
		responseDTO.setValue("zjdt", zjdt);
		// ��˾��Ҫ�
		List gszyhd = mg.getMarketHeadingInfoByType("10302,10301", 12);
		responseDTO.setValue("gszyhd", gszyhd);
		// ����ԭ�ͼ۸�
		List gjyyjg = mg.getMarketHeadingInfoByType3("10802004", 6);
		responseDTO.setValue("gjyyjg", gjyyjg);

		// ������̽��˾����Ա�ͼ
		List srdby = mg.getMarketHeadingInfoAndImgByType("10607", 1);
		responseDTO.setValue("srdby", srdby);

		// ������ǩָ�������
		List list = mg.getNewGetIncomeMoney();
		responseDTO.setValue("list", list);

		// ��ȡlogo�� �����˵��б�
		List sckfList = mg.getTypeInfoByFather("103");
		List scglList = mg.getTypeInfoByFather("104");
		List ygsdtList = mg.getTypeInfoByFather("105");
		List jzhbdtList = mg.getTypeInfoByFather("106");
		List tjfxList = mg.getTypeInfoByFather("102");
		responseDTO.setValue("sckfList", sckfList);
		responseDTO.setValue("scglList", scglList);
		responseDTO.setValue("ygsdtList", ygsdtList);
		responseDTO.setValue("jzhbdtList", jzhbdtList);
		responseDTO.setValue("tjfxList", tjfxList);
		return responseDTO;

	}

	/*
	 * ��ȡ����ҳ����Ϣ
	 */
	public ISrvMsg getSecondPageInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String pageType = reqDTO.getValue("pageType");
		String codingType = "";
		String headingInfo = "";
		if ("sckf".equals(pageType)) {
			codingType = "103";
			headingInfo = "�г�����";
		} else if ("scgl".equals(pageType)) {
			codingType = "104";
			headingInfo = "�г�����";
		} else if ("ygsdt".equals(pageType)) {
			codingType = "105";
			headingInfo = "���﹫˾��̬";
		} else if ("jzhbdt".equals(pageType)) {
			codingType = "106";
			headingInfo = "��̽��˾��̬";
		} else if ("tjfx".equals(pageType)) {
			codingType = "10203";
			headingInfo = "ͳ�Ʒ���";
		}
		responseDTO.setValue("headingInfo", headingInfo);
		// ��ȡ����ҳ���Ҳ����б�
		List twoList = mg.getTypeInfoByFather("tjfx".equals(pageType) ? "102" : codingType);
		responseDTO.setValue("twoList", twoList);
		for (int i = 0; twoList != null && i < twoList.size(); i++) {
			Map map = (Map) twoList.get(i);
			String code = (String) map.get("code");
			List subList = mg.getTypeInfoByFather(code);
			responseDTO.setValue("twoList" + code, subList);
		}
		// ��ȡ����ҳ������б�ҳ��
		List leafList = mg.getLeafTypeInfoByFather(codingType);
		responseDTO.setValue("leafList", leafList);
		for (int i = 0; leafList != null && i < leafList.size(); i++) {
			Map map = (Map) leafList.get(i);
			String code = (String) map.get("code");
			List subList = mg.getMarketHeadingInfoByType(code, 3);
			responseDTO.setValue("leafList" + code, subList);
		}
		responseDTO.setValue("pageType", pageType);

		// ��ȡlogo�� �����˵��б�
		List sckfList = mg.getTypeInfoByFather("103");
		List scglList = mg.getTypeInfoByFather("104");
		List ygsdtList = mg.getTypeInfoByFather("105");
		List jzhbdtList = mg.getTypeInfoByFather("106");
		List tjfxList = mg.getTypeInfoByFather("102");
		responseDTO.setValue("sckfList", sckfList);
		responseDTO.setValue("scglList", scglList);
		responseDTO.setValue("ygsdtList", ygsdtList);
		responseDTO.setValue("jzhbdtList", jzhbdtList);
		responseDTO.setValue("tjfxList", tjfxList);
		return responseDTO;
	}

	/*
	 * ��ȡĳ��������µ�һ��ͼƬ
	 */

	public ISrvMsg getSecondNewPageInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String twoTypeId = reqDTO.getValue("id");
		String TypeName = reqDTO.getValue("typeName");
		String pageType = reqDTO.getValue("pageType");
		String content = mg.getSrcByContentFromOrgModel(twoTypeId);
		responseDTO.setValue("content", content);
		responseDTO.setValue("typeName", TypeName);
		responseDTO.setValue("pageType", pageType);

		// ��ȡlogo�� �����˵��б�
		List sckfList = mg.getTypeInfoByFather("103");
		List scglList = mg.getTypeInfoByFather("104");
		List ygsdtList = mg.getTypeInfoByFather("105");
		List jzhbdtList = mg.getTypeInfoByFather("106");
		List tjfxList = mg.getTypeInfoByFather("102");
		responseDTO.setValue("sckfList", sckfList);
		responseDTO.setValue("scglList", scglList);
		responseDTO.setValue("ygsdtList", ygsdtList);
		responseDTO.setValue("jzhbdtList", jzhbdtList);
		responseDTO.setValue("tjfxList", tjfxList);
		return responseDTO;
	}

	/*
	 * ��ȡ����ҳ����Ϣ
	 */
	public ISrvMsg getSecondPageInfoLike(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String pageType = reqDTO.getValue("pageType");
		String codingType = reqDTO.getValue("typeId");
		String headingInfo = reqDTO.getValue("typeName");
		responseDTO.setValue("headingInfo", headingInfo);
		// ��ȡ����ҳ���Ҳ����б�
		List twoList = mg.getTypeInfoByFather(codingType.substring(0, 3));
		responseDTO.setValue("twoList", twoList);
		for (int i = 0; twoList != null && i < twoList.size(); i++) {
			Map map = (Map) twoList.get(i);
			String code = (String) map.get("code");
			List subList = mg.getTypeInfoByFather(code);
			responseDTO.setValue("twoList" + code, subList);
		}
		// ��ȡ����ҳ������б�ҳ��
		List leafList = mg.getLeafTypeInfoByFather(codingType);
		responseDTO.setValue("leafList", leafList);
		for (int i = 0; leafList != null && i < leafList.size(); i++) {
			Map map = (Map) leafList.get(i);
			String code = (String) map.get("code");
			List subList = mg.getMarketHeadingInfoByType(code, 3);
			responseDTO.setValue("leafList" + code, subList);
		}
		responseDTO.setValue("pageType", pageType);
		responseDTO.setValue("typeId", codingType);

		// ��ȡlogo�� �����˵��б�
		List sckfList = mg.getTypeInfoByFather("103");
		List scglList = mg.getTypeInfoByFather("104");
		List ygsdtList = mg.getTypeInfoByFather("105");
		List jzhbdtList = mg.getTypeInfoByFather("106");
		List tjfxList = mg.getTypeInfoByFather("102");
		responseDTO.setValue("sckfList", sckfList);
		responseDTO.setValue("scglList", scglList);
		responseDTO.setValue("ygsdtList", ygsdtList);
		responseDTO.setValue("jzhbdtList", jzhbdtList);
		responseDTO.setValue("tjfxList", tjfxList);
		return responseDTO;
	}

	/*
	 * ��ȡ��ҳTOPҳlog����Ϣ
	 */

	/*
	 * ��ȡ����ҳ����Ϣ
	 */
	public ISrvMsg getTopPageInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String pageType = reqDTO.getValue("pageType");
		String codingType = reqDTO.getValue("typeId");
		String headingInfo = reqDTO.getValue("typeName");
		responseDTO.setValue("headingInfo", headingInfo);
		responseDTO.setValue("pageType", pageType);
		responseDTO.setValue("typeId", codingType);
		// ��ȡlogo�� �����˵��б�
		List sckfList = mg.getTypeInfoByFather("103");
		List scglList = mg.getTypeInfoByFather("104");
		List ygsdtList = mg.getTypeInfoByFather("105");
		List jzhbdtList = mg.getTypeInfoByFather("106");
		List tjfxList = mg.getTypeInfoByFather("102");
		responseDTO.setValue("sckfList", sckfList);
		responseDTO.setValue("scglList", scglList);
		responseDTO.setValue("ygsdtList", ygsdtList);
		responseDTO.setValue("jzhbdtList", jzhbdtList);
		responseDTO.setValue("tjfxList", tjfxList);
		return responseDTO;
	}

	/*
	 * ��ȡ����ҳ����Ϣ
	 */
	public ISrvMsg getSecondPageInfoMod(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String pageType = reqDTO.getValue("pageType");
		String codingType = reqDTO.getValue("typeId");
		String threeTypeId = reqDTO.getValue("threeTypeId");
		String headingInfo = reqDTO.getValue("headingInfo");
		String typeName = reqDTO.getValue("typeName");
		
		if(codingType.equals("10601")||codingType.equals("10602")||codingType.equals("10603")||codingType.equals("10604")||codingType.equals("10605")){
			typeName="��˾���";
		}
		
		String codingTypeOld=codingType;
		if(codingType.startsWith("106")){
			if (codingType.length() == 3)
				codingTypeOld += "01001";
			if (codingType.length() == 5)
				codingTypeOld += "001";
		}
		if(codingType.equals("10504")||codingType.equals("10505")||codingType.equals("10506")){
			codingTypeOld +="001";
			typeName="��˾���";
		}
		
		if (codingType.startsWith("105")) {
			pageType = "ygsdt";
		} else {
			pageType = "jzhbdt";
		}
		if(headingInfo==null){
			if(pageType.equals("ygsdt")){
				headingInfo="�͹�˾��̬";
			}else{
				headingInfo="��̽��˾��̬";
			}
		}
		if (threeTypeId == null || "".equals(threeTypeId)) {
			if (codingType.startsWith("105")) {
				threeTypeId = "10801006";
			} else {
				threeTypeId = "10802006";
			}
			typeName = "��˾���";
		}
		
		List list = new ArrayList();
		
		if(threeTypeId.equals("10801001")||threeTypeId.equals("10801002")||threeTypeId.equals("10802002")){
			String sqlList = "select r.infomation_id,r.infomation_name,r.release_date from bgp_infomation_release_info r ";
			sqlList += " where bsflag='0' and r.two_type_id='"+codingType+"' and r.three_type_id = '" + threeTypeId + "'  order by release_date desc,modify_date desc";
			
			StringBuffer sb = new StringBuffer();
			sb.append("select * from (select datas.*,rownum rownum_ from (");
			sb.append(sqlList);
			sb.append(") datas where rownum <=10 ").append(") where rownum_ >0 ");
			
			list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		}

		responseDTO.setValue("list", list);
		
		String sqlInfo = "select t.code_name from BGP_INFOMATION_TYPE_INFO t where t.bsflag='0'  and t.code='" + codingTypeOld + "'";
		Map mapInfo = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlInfo);
		if (mapInfo != null && "��˾���".equals(typeName)) {
			typeName = mapInfo.get("codeName") + "���";
		}

		// ��˾���
		String sql = "select ci.* from sm_org sm , ci_corporation ci where sm.org_id = ci.corp_id and sm.bgp_infomation_type_id = '"
				+ codingTypeOld + "'";
		Map mapOrgInfo = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		responseDTO.setValue("mapOrgInfo", mapOrgInfo);
		// ��˾����װ������
		if (codingType.startsWith("106")) {
			String sql3 = "select * from PM_EXCEPTIONAL_SKILL pm,sm_org sm where sm.org_id = pm.corp_id and sm.bgp_infomation_type_id= '"
					+ codingTypeOld + "'";
			Map mapOrgTech = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql3);
			responseDTO.setValue("mapOrgTech", mapOrgTech);
		}

		// ��ȡ����ҳ���Ҳ����б�
		List twoList = mg.getTypeInfoByFather(codingType.substring(0, 3));
		responseDTO.setValue("twoList", twoList);
		for (int i = 0; twoList != null && i < twoList.size(); i++) {
			Map map = (Map) twoList.get(i);
			String code = (String) map.get("code");
			List subList = mg.getTypeInfoByFather(code);
			responseDTO.setValue("twoList" + code, subList);
		}
		responseDTO.setValue("headingInfo", headingInfo);
		responseDTO.setValue("pageType", pageType);
		responseDTO.setValue("typeId", codingTypeOld);
		responseDTO.setValue("threeTypeId", threeTypeId);
		responseDTO.setValue("typeName", typeName);
		// ��ȡ����ҳ���м���Ϣ
		List midList = mg.getMarketHeadingInfoByType(codingType, threeTypeId, 10);
		responseDTO.setValue("midList", midList);
		// ��ȡlogo�� �����˵��б�
		List sckfList = mg.getTypeInfoByFather("103");
		List scglList = mg.getTypeInfoByFather("104");
		List ygsdtList = mg.getTypeInfoByFather("105");
		List jzhbdtList = mg.getTypeInfoByFather("106");
		List tjfxList = mg.getTypeInfoByFather("102");
		responseDTO.setValue("sckfList", sckfList);
		responseDTO.setValue("scglList", scglList);
		responseDTO.setValue("ygsdtList", ygsdtList);
		responseDTO.setValue("jzhbdtList", jzhbdtList);
		responseDTO.setValue("tjfxList", tjfxList);
		return responseDTO;
	}

	// skill���
	public ISrvMsg addSkill(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);

		String codingType = reqDTO.getValue("typeId");

		// ��˾����װ������
		String sql = "select * from sm_org where bgp_infomation_type_id='" + codingType + "'";
		String sql2 = "select * from PM_EXCEPTIONAL_SKILL pm,sm_org sm where sm.org_id = pm.corp_id and sm.bgp_infomation_type_id= '"
				+ codingType + "'";
		Map mapOrgTech = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql2);
		Map mapOrg = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);

		responseDTO.setValue("mapOrgTech", mapOrgTech);
		responseDTO.setValue("mapOrg", mapOrg);
		responseDTO.setValue("typeId", codingType);

		return responseDTO;
	}

	public ISrvMsg saveSkill(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String skillId = isrvmsg.getValue("skillId");
		System.out.println("skillId=====" + skillId);
		String corpId = isrvmsg.getValue("corpId");
		String exceptionalSkill = isrvmsg.getValue("exceptionalSkill");
		String skillSeries = isrvmsg.getValue("skillSeries");

		Date now = new Date();

		Map fileMap = new HashMap();

		if (!skillId.equals("null")) {
			fileMap.put("EXCEPTIONAL_SKILL_ID", skillId);

		} else {
			fileMap.put("CREATOR", user.getUserName());
			fileMap.put("CREATE_DATE", now);
		}
		fileMap.put("CORP_ID", corpId);
		fileMap.put("EXCEPTIONAL_SKILL", exceptionalSkill);
		fileMap.put("SKILL_SERIES", skillSeries);

		fileMap.put("MODIFIER", user.getUserName());
		fileMap.put("MODIFY_DATE", now);
		fileMap.put("BSFLAG", "0");

		pureJdbcDao.saveOrUpdateEntity(fileMap, "PM_EXCEPTIONAL_SKILL");

		return responseDTO;
	}

	// �޸Ĺ�˾���
	public ISrvMsg editOrgInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);

		String codingType = reqDTO.getValue("typeId");

		
		String sql = "select * from sm_org where bgp_infomation_type_id='" + codingType + "'";
		String sql2 = "select * from ci_corporation ci,sm_org sm where sm.org_id = ci.corp_id and sm.bgp_infomation_type_id= '"
				+ codingType + "'";
		Map mapOrgInfo = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql2);
		Map mapOrg = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);

		responseDTO.setValue("mapOrgInfo", mapOrgInfo);
		responseDTO.setValue("mapOrg", mapOrg);
		responseDTO.setValue("typeId", codingType);

		return responseDTO;
	}

	public ISrvMsg saveOrgInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		String typeId = isrvmsg.getValue("typeId");
		String orgId = isrvmsg.getValue("orgId");
		String corpId = isrvmsg.getValue("corpId");
		String zipCode = isrvmsg.getValue("zipCode") == null ? "" : isrvmsg.getValue("zipCode");
		String phone = isrvmsg.getValue("phone")== null ? "" : isrvmsg.getValue("phone");
		String fax = isrvmsg.getValue("fax")== null ? "" : isrvmsg.getValue("fax");
		String oilField = isrvmsg.getValue("oilField")== null ? "" : isrvmsg.getValue("oilField");
		String memo = isrvmsg.getValue("memo")== null ? "" : isrvmsg.getValue("memo");
		String shortName = isrvmsg.getValue("shortName")== null ? "" : isrvmsg.getValue("shortName");
		String fullName = isrvmsg.getValue("fullName")== null ? "" : isrvmsg.getValue("fullName");
		String address = isrvmsg.getValue("address")== null ? "" : isrvmsg.getValue("address");
		String mainBusiness = isrvmsg.getValue("mainBusiness")== null ? "" : isrvmsg.getValue("mainBusiness");

		Date now = new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	    String today = format.format(now);

		Map fileMap = new HashMap();
		if (!corpId.equals("null")) {
			fileMap.put("CORP_ID", corpId);
			fileMap.put("SHORT_NAME", shortName);
			fileMap.put("FULL_NAME", fullName);
			fileMap.put("ADDRESS", address);
			fileMap.put("ZIP_CODE", zipCode);
			fileMap.put("PHONE", phone);
			fileMap.put("FAX", fax);
			fileMap.put("MEMO", memo);
			fileMap.put("MODIFIER", user.getUserName());
			fileMap.put("MODIFY_DATE", now);
			fileMap.put("BSFLAG", "0");
			if (typeId.startsWith("106")) {
				fileMap.put("MAIN_BUSINESS", mainBusiness);
			} else {
				fileMap.put("OIL_FIELD", oilField);
			}
			pureJdbcDao.saveOrUpdateEntity(fileMap, "CI_CORPORATION");
		} else {
			String sql="";
			if (typeId.startsWith("106")) {
				 sql = "insert into CI_CORPORATION(CORP_ID,SHORT_NAME,FULL_NAME,ADDRESS,ZIP_CODE,PHONE,FAX,MAIN_BUSINESS,MEMO,MODIFIER,MODIFY_DATE,BSFLAG,CREATOR,CREATE_DATE) "
					+" values('"+orgId+"','"+shortName+"','"+fullName+"','"+address+"','"+zipCode+"','"+phone+"','"+fax+"','"+mainBusiness+"','"+memo+"','"+user.getUserName()+"',to_date('"+today+"','YYYY-MM-DD HH24-mi-ss'),'0','"+user.getUserName()+"',to_date('"+today+"','YYYY-MM-DD HH24-mi-ss'))";
				
			} else {
				 sql = "insert into CI_CORPORATION(CORP_ID,SHORT_NAME,FULL_NAME,ADDRESS,ZIP_CODE,PHONE,FAX,OIL_FIELD,MEMO,MODIFIER,MODIFY_DATE,BSFLAG,CREATOR,CREATE_DATE) "
					+" values('"+orgId+"','"+shortName+"','"+fullName+"','"+address+"','"+zipCode+"','"+phone+"','"+fax+"','"+oilField+"','"+memo+"','"+user.getUserName()+"',to_date('"+today+"','YYYY-MM-DD HH24-mi-ss'),'0','"+user.getUserName()+"',to_date('"+today+"','YYYY-MM-DD HH24-mi-ss'))";
			}
			jdbcTemplate.execute(sql);
		}
		return responseDTO;
	}

	/*
	 * ��ֵ������¼�������֤����Ψһ��
	 */
	public ISrvMsg varMarketValueQuantityOne(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String valueQuantityId = isrvmsg.getValue("valueQuantityId");
		String year = isrvmsg.getValue("year");
		String month = isrvmsg.getValue("month");
		String orgId = isrvmsg.getValue("orgId");
		String querySql = "select value_quantity_id from mm_value_quantity where record_year='" + year + "' and record_month='" + month
				+ "'and corp_id='" + orgId + "'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(querySql);
		if (map != null && map.get("valueQuantityId") != null) {
			if (valueQuantityId == null || "".equals(valueQuantityId)) {
				responseDTO.setValue("dataExist", "true");
			} else {
				if (!valueQuantityId.equals(map.get("valueQuantityId"))) {
					responseDTO.setValue("dataExist", "true");
				} else {
					responseDTO.setValue("dataExist", "false");
				}
			}
		} else {
			responseDTO.setValue("dataExist", "false");
		}
		return responseDTO;
	}
}
