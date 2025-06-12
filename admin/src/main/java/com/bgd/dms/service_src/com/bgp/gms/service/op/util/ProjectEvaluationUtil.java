package com.bgp.gms.service.op.util;

import java.io.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;

import org.apache.poi.xssf.usermodel.*;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.gms.service.op.util.OPCommonUtil;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

public class ProjectEvaluationUtil extends BaseService {

	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	/*
	 * 设置计划基础数据
	 */
	public static void setFormulaBasicInfo(Map map, String code, double value) {
		map.put(code, value);
	}
}
