package com.bgd.api.jcyh.services.gxdz.business;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.bgd.api.common.propety.GxdzApiService;
import com.bgd.api.common.utils.HttpRequstUtil;
import com.bgd.platform.util.dao.BgdDataSource;
import com.bgd.platform.util.service.SpringContextUtil;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.collections.map.HashedMap;
import org.springframework.util.StringUtils;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

/**
 * 描述: 个性定制接口 公共service
 *
 * @author WuYanchang
 * @date 2022/1/10 17:17
 */

public class GxdzCommonService {
    private static Long token_valid_time = Long.valueOf(0);
    private static String token_ = "";
    private static String dtg_code = "";
    private BgdDataSource bgdDataSource;
    private GxdzApiService gxdzApiService;

    public BgdDataSource getBgdDataSource()
    {
        return bgdDataSource;
    }

    public void setBgdDataSource(BgdDataSource bgdDataSource)
    {
        this.bgdDataSource = bgdDataSource;
    }

    public GxdzApiService getGxdzApiService()
    {
        return gxdzApiService;
    }

    public void setGxdzApiService(GxdzApiService gxdzApiService)
    {
        this.gxdzApiService = gxdzApiService;
    }

    /**
     * 查询评分标准
     *
     * @param param 传参
     * @param start 起始页数
     */
    public JSONObject getZflsGrid(int start, int limit, Map param) throws Exception
    {
        String AD_CODE = MapUtils.getString(param, "AD_CODE");
        String AG_CODE = MapUtils.getString(param, "AG_CODE");
        String ZQZH_ID = MapUtils.getString(param, "ZQZH_ID");
        String START_DATE_ACTUAL = MapUtils.getString(param, "START_DATE_ACTUAL");
        String END_DATE_ACTUAL = MapUtils.getString(param, "END_DATE_ACTUAL");
        List<Object> paramList = new ArrayList<Object>();

        // 拼接条件
        StringBuffer sqlWhere = new StringBuffer();
        if (StringUtils.hasText(AG_CODE))
        {
            sqlWhere.append(" AND YHZH.AG_CODE = ? ");
            paramList.add(AG_CODE);
        }
        if (StringUtils.hasText(ZQZH_ID))
        {
            sqlWhere.append(" AND ZJSZ.ACC_NAME = ? ");
            paramList.add(ZQZH_ID);
        }
        if (StringUtils.hasText(START_DATE_ACTUAL) && StringUtils.hasText(END_DATE_ACTUAL))
        {
            sqlWhere.append(" AND ZJSZ.ETYDAT >= ? ");
            sqlWhere.append(" AND ZJSZ.ETYDAT <= ? ");
            paramList.add(START_DATE_ACTUAL);
            paramList.add(END_DATE_ACTUAL);
        }

        // 获取数据总条数
        StringBuffer sqlCount = new StringBuffer();
        sqlCount.append("SELECT COUNT(1) COUNT FROM ( ");
        // 获取分页参数
        StringBuffer sqlStr = new StringBuffer();
        sqlStr.append(" SELECT * FROM ( SELECT SSS.*,ROWNUM RO  FROM (");

        StringBuffer sqlAppend = new StringBuffer();
        sqlAppend.append(" SELECT YHZH.AG_CODE, YHZH.AG_NAME, YHZH.XM_ID, INFO.XM_CODE, INFO.XM_NAME, ZJSZ.RECORD_CODE, ");
        sqlAppend.append(" ZJSZ.REFNBR, ZJSZ.ACC_NO, ZJSZ.ACC_NAME, ZJSZ.ETYDAT, ZJSZ.TSDAMT, ZJSZ.RPYACC, ZJSZ.RPYNAM, ZJSZ.NUSAGE, ZJSZ.REMARK ");
        sqlAppend.append(" FROM DEBT_T_YH_ZJSZ ZJSZ ");
        sqlAppend.append(" LEFT JOIN DEBT_T_ZQGL_YHZH YHZH ON ZJSZ.ACC_NO = YHZH.ACC_NO ");
        sqlAppend.append(" LEFT JOIN DEBT_T_PROJECT_INFO INFO ON INFO.XM_ID = YHZH.XM_ID ");
        sqlAppend.append(" WHERE YHZH.IS_DELETED = '2' AND YHZH.IS_END = '1' ");
        sqlAppend.append(sqlWhere);

        sqlStr.append(sqlAppend);
        sqlStr.append(" )SSS WHERE ROWNUM <= ?)WHERE RO > ? ");

        sqlCount.append(sqlAppend);
        sqlCount.append(" )");
        List list_count = bgdDataSource.findBySql(sqlCount.toString(), paramList.toArray());

        paramList.add(start + limit);
        paramList.add(start);
        List list = bgdDataSource.findBySql(sqlStr.toString(), paramList.toArray());

        Integer result = 0;
        if (list_count.size() > 0)
        {
            Map rs = (Map) list_count.get(0);
            result = Integer.parseInt(rs.get("count").toString());
        }
        JSONObject rs = new JSONObject();
        if (list.size() > 0)
        {
            rs.put("map", list.get(0));
        }
        rs.put("list", list);
        rs.put("count", result);
        return rs;
    }

    /**
     * 广东接受银行流水逻辑
     *
     * @param param 调用数财系统的传参
     */
    public Integer GXDZServiceGD(Map param) throws Exception
    {
        Map gd = gxdzApiService.getGd();
        Map timeout = (Map) gd.get("timeout");
        Integer socket = Integer.valueOf(timeout.get("socket").toString());
        Integer connect = Integer.valueOf(timeout.get("connect").toString());
        Long tokenTimeout = Long.valueOf(timeout.get("token").toString());
        System.out.println("配置参数为>>>" + gd.toString());
        String XM_CODE = MapUtils.getString(param, "XM_CODE");

        param.put("dtgCode", dtg_code);
        JSONObject jsonParam = JSONObject.parseObject(JSONObject.toJSONString(param));
        System.out.println("查询参数为>>>" + jsonParam.toString());
        // 获取中枢token
        System.out.println("->开始请求token,token存才于data中");
        String token = this.getToken(socket, connect, tokenTimeout, (Map) gd.get("zsSys"));
        System.out.println("取到token>>>" + token);
        // 访问数财数据
        System.out.println("->开始访问数财接口, 数据存在于DATA");
        List<Map> paramList = this.getParamList(token, jsonParam, (Map) gd.get("url"), socket, connect);
        System.out.println("完成请求, 数据条数为>>>" + paramList.size());
        // 保存数据入库
        if (paramList.size() > 0)
        {
            StringBuilder delSql = new StringBuilder(" DELETE FROM DEBT_T_YH_ZJSZ WHERE REFNBR = ? ");
            this.bgdDataSource.updateByBatchParamSql(delSql.toString(), paramList, new Object[]{"REFNBR"});

            StringBuilder xmpfSql = new StringBuilder();
            xmpfSql.append("INSERT INTO DEBT_T_YH_ZJSZ (RECORD_DETAIL_ID, REFNBR, XM_CODE, XM_NAME, ACC_NAME, ACC_NO, RPYNAM, RPYACC, TSDAMT, ETYDAT, NUSAGE, CREATE_DATE)");
            xmpfSql.append(" VALUES(SYS_GUID(), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, to_char(sysdate,'yyyy-mm-dd') )");
            bgdDataSource.updateByBatchParamSql(xmpfSql.toString(), paramList,
                    new Object[]{"REFNBR", "XM_CODE", "XM_NAME", "ACC_NAME", "ACC_NO", "RPYNAM", "RPYACC", "TSDAMT", "ETYDAT", "NUSAGE"});
        }
        return paramList.size();
    }

    /**
     * 获取中枢的token
     */
    private String getToken(Integer socket, Integer connect, Long tokenTimeout, Map zsSys)
    {
        Long nowDate = System.currentTimeMillis();
        // 判断token过期
        System.out.println("token时间>>>" + nowDate + "-" + token_valid_time + "-" + (nowDate - token_valid_time));
        if (nowDate - token_valid_time > tokenTimeout)
        {
            // 更新token时间
            token_valid_time = nowDate;
            System.out.println("更新token时间节点>>>" + token_valid_time);
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("appId", zsSys.get("appId"));
            jsonObject.put("secret", zsSys.get("secret"));
            String url_zs = zsSys.get("url").toString();
            String tokenString = HttpRequstUtil.queryResultToString(jsonObject, url_zs, null, socket, connect);
            JSONObject jsonObject1 = JSONObject.parseObject(tokenString);

            token_ = jsonObject1.get("data").toString();
        }
        System.out.println("使用的token为>>>" + token_);
        return token_;
    }

    /**
     * 获取数财系统的-银行流水数据
     *
     * @param token     中枢的token
     * @param jsonParam 查询参数
     * @param urls      数财的接口
     */
    private List<Map> getParamList(String token, JSON jsonParam, Map urls, Integer socket, Integer connect)
    {
        List<Map> list = new ArrayList<Map>();

        String url = (String) urls.get("Yhls");
        String zfString = HttpRequstUtil.queryResultToString(jsonParam, url, token, socket, connect);
        System.out.println("原始数据>>>" + zfString);
        JSONObject jsonObject2 = JSONObject.parseObject(zfString);
        JSONArray data = (JSONArray) jsonObject2.get("DATA");
        list = data.toJavaList(Map.class);
        return list;
    }

    /**
     * 定时任务入口
     */
    public boolean autoJob(JSONObject jobParam)
    {
        Map params = new HashedMap();
        // 定时任务参数
        this.getAutoJobParams(params, jobParam);
        System.out.println("->定时任务-同步数财数据");
        try
        {
            System.out.println("定时任务开启map>>>" + params.toString());
            Integer integer = this.GXDZServiceGD(params);
            System.out.println("获取条数为>>>" + integer);
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return true;
    }

    public void getAutoJobParams(Map map, JSONObject jobParam)
    {
        // 默认提前一天
        Integer proDayInt = 1;
        String ELE_AD_CODE = (String) SpringContextUtil.getSysParamMap().get("ELE_AD_CODE");
        String proDay = (String) jobParam.get("proDay");
        String year = (String) jobParam.get("year");
        // 定义传参
        String dtgCode = dtg_code;
        String areaCode = ELE_AD_CODE;
        String XM_CODE = "";
        String ZQZH_ID = "";
        String START_DATE_ACTUAL = "";
        String END_DATE_ACTUAL = "";

        // 年份默认当前年
        if (StringUtils.isEmpty(year) || "null".equalsIgnoreCase(year))
        {
            Calendar d = Calendar.getInstance();
            year = String.valueOf(d.get(Calendar.YEAR));
        }

        // 动态更新日期
        if (StringUtils.hasText(proDay))
        {
            proDayInt = Integer.valueOf(proDay);
        }
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DATE, -proDayInt);
        START_DATE_ACTUAL = df.format(cal.getTime());

        cal = Calendar.getInstance();
        cal.add(Calendar.DATE, 1);
        END_DATE_ACTUAL = df.format(cal.getTime());

        map.put("dtgCode", dtgCode);
        map.put("areaCode", areaCode);
        map.put("year", year);
        map.put("XM_CODE", XM_CODE);
        map.put("ZQZH_ID", ZQZH_ID);
        map.put("START_DATE_ACTUAL", START_DATE_ACTUAL);
        map.put("END_DATE_ACTUAL", END_DATE_ACTUAL);
    }
}
