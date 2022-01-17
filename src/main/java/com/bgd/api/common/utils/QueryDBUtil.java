package com.bgd.api.common.utils;

import com.bgd.api.common.exceptions.ApiException;
import com.bgd.platform.util.common.StringTool;
import com.bgd.platform.util.dao.BgdDataSource;
import com.bgd.platform.util.service.SpringContextUtil;
import org.apache.commons.collections.MapUtils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * @author : guodg
 * @date : 2021/01/18
 * 数据库工具类，由于该工具类没有事务处理，所以只允许查询操作
 */
public class QueryDBUtil {
    private static final BgdDataSource bgdDataSource = (BgdDataSource) SpringContextUtil.getBean("bgdDataSource");

    /**
     * 生成报文ID
     *
     * @return
     */
    public static String createMessageId() {
        return bgdDataSource.getId();
    }

    /**
     * 生成时间戳
     * 日期格式：YYYYMMDDHHMISSFF3
     * FF3代表3位毫秒值
     *
     * @return
     */
    public static String createTimeStamp() {
        String sql = "SELECT TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDDHHMISSFF3') VAL FROM DUAL";
        Map map = bgdDataSource.findBySqlMap(sql);
        return MapUtils.getString(map, "VAL");
    }

    /**
     * 感觉用户编码，查询用户配置信息
     *
     * @param userCode
     * @return
     */
    public static Map queryUserConfig(String userCode) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT T.USER_CODE,T.USER_NAME,T.IP_ADDRESS,T.USER_PWD,T.ENC_SF,CASE WHEN T.ENC_SF = 'AES' THEN T.ENC_KEY ELSE T.F_PRI_KEY END DEC_KEY, ");
        sql.append(" CASE WHEN T.ENC_SF = 'AES' THEN T.ENC_KEY ELSE T.S_PUB_KEY END ENC_KEY FROM DEBT_T_API_ACCESS_USER T WHERE 1=1 AND T.IS_DELETED = 2 AND T.USER_CODE = ?");
        return bgdDataSource.findBySqlMap(sql.toString(), new Object[]{userCode});
    }

    /**
     * 查询表中的update_time字段最大值
     *
     * @param tableName
     * @return
     * @throws ApiException
     */
    public static String queryMaxUpdateTime(String tableName) throws ApiException {
        if (StringTool.isNull(tableName)) {
            throw new ApiException("查询表为空！");
        }
        StringBuilder sql = new StringBuilder();
        sql.append(" SELECT MAX(UPDATE_TIME) UPDATE_TIME FROM ");
        sql.append(tableName);
        sql.append(" WHERE 1=1 AND IS_DELETED = 2 ");
        Map map = bgdDataSource.findBySqlMap(sql.toString());
        String updateTime = MapUtils.getString(map, "UPDATE_TIME", "0000-00-00 00:00:00");
        return updateTime;
    }

    /**
     * 计算当前时间戳和给定时间戳之间的差值，并转化为秒
     * 日期格式：yyyyMMddhhmmssSSS
     *
     * @param timeStamp 请求时间戳
     * @return 差值 单位秒
     */
    public static long subtractTimeStamp(String timeStamp) throws ApiException {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMddhhmmssSSS");
        Date parseDate = null;
        Date currentDate = null;
        try {
            parseDate = simpleDateFormat.parse(timeStamp);
            // 当前数据库时间戳
            String currentTimeStamp = createTimeStamp();
            currentDate = simpleDateFormat.parse(currentTimeStamp);
        } catch (ParseException e) {
            throw new ApiException("时间戳格式化错误，请检查是否为yyyyMMddhhmmssSSS格式！");
        }
        // 转化为秒
        long diffValue = (currentDate.getTime() - parseDate.getTime()) / 1000;
        return diffValue;
    }

    /**
     * 拼接插入语句
     *
     * @param table  业务表
     * @param fields 业务表中字段
     * @return
     */
    public static final String spliceInsertStatement(String table, Object[] fields) {
        StringBuffer sql = new StringBuffer("INSERT INTO ");
        StringBuffer appendSql = new StringBuffer(" VALUES( ");
        sql.append(table).append(" ( ");
        for (int i = 0; i < fields.length; i++) {
            if (i == 0) {
                appendSql.append("?");
                sql.append(fields[i].toString());
            } else {
                appendSql.append(",?");
                sql.append("," + fields[i].toString());
            }
        }
        appendSql.append(")");
        sql.append(")");
        sql.append(appendSql);
        return sql.toString();
    }

    /**
     * 获取list中最长的map的keys数组
     *
     * @param inputList
     * @return
     */
    public static Object[] getMaxRowFields(List<Map> inputList) {
        Map maxMap = Collections.max(inputList, new Comparator<Map>() {
            @Override
            public int compare(Map o1, Map o2) {
                return o1.size() >= o2.size() ? 1 : -1;
            }
        });
        return maxMap.keySet().toArray();
    }

}
