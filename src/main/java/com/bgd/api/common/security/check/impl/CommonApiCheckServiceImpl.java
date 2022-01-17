package com.bgd.api.common.security.check.impl;

import com.bgd.api.common.enums.ApiEnum;
import com.bgd.api.common.enums.ApiStatusEnum;
import com.bgd.api.common.exceptions.ApiException;
import com.bgd.api.common.security.check.ApiCheckService;
import com.bgd.api.common.utils.JSONUtil;
import com.bgd.api.common.utils.QueryDBUtil;
import com.bgd.platform.util.common.StringTool;
import com.bgd.platform.util.dao.BgdDataSource;
import net.sf.json.JSONObject;
import org.apache.commons.collections.MapUtils;

import java.util.List;
import java.util.Map;

/**
 * @author : guodg
 * @date : 2021/01/15
 * 通用校验
 * 1.IP白名单
 * 2.报文参数规范化校验
 * 3.报文防重放攻击
 * 4.用户密码校验
 * 5.用户报文授权验证
 */
public class CommonApiCheckServiceImpl implements ApiCheckService {
    private BgdDataSource bgdDataSource;

    public BgdDataSource getBgdDataSource() {
        return bgdDataSource;
    }

    public void setBgdDataSource(BgdDataSource bgdDataSource) {
        this.bgdDataSource = bgdDataSource;
    }

    /**
     * 安全性校验
     *
     * @param message 报文体
     * @param ipAddr  请求IP
     * @param apiEnum 提供服务的业务接口编码
     * @return
     */
    @Override
    public void messageSecurityVerification(JSONObject message, String ipAddr, ApiEnum apiEnum) throws ApiException {
        //校验结果
        if (message == null || ipAddr == null) {
            throw new ApiException("请求报文为空或者请求IP为空！");
        }
        // 1.比对IP白名单表
        this.validUserIpAddress(ipAddr);
        // 解析出用户名、密码、报文编码等信息
        Map headMap = JSONUtil.getMap(message, "HEAD");
        String guid = MapUtils.getString(headMap, "GUID");
        String userCode = MapUtils.getString(headMap, "USER_CODE");
        String pwd = MapUtils.getString(headMap, "PSD");
        String xchCode = MapUtils.getString(headMap, "XCH_CODE");// 报文编码
        String timestamp = MapUtils.getString(headMap, "TIMESTAMP");// 报文编码
        // 2.报文规范验证
        if (StringTool.isNull(guid) || StringTool.isNull(userCode) || StringTool.isNull(pwd) || StringTool.isNull(xchCode) || StringTool.isNull(timestamp)) {
            throw new ApiException(ApiStatusEnum.ERR_PARAM.getCode(), ApiStatusEnum.ERR_PARAM.getMessage());
        }
        // 3.防重放攻击拦截
        this.antiReplayAttack(headMap);
        // 4.用户名密码验证
        this.validUserPassword(userCode, pwd);
        // 5.用户授权验证
        this.validUserAuthorization(userCode, apiEnum.getCode(), xchCode);
        // 验证通过，则解密报文
        MessageUtil.decryptMessage(message, userCode);
    }

    /**
     * 校验ip白名单
     *
     * @param ipAddr
     * @throws ApiException
     */
    private void validUserIpAddress(String ipAddr) throws ApiException {
        String sql = "SELECT 1 FROM DEBT_T_API_ACCESS_USER WHERE IP_ADDRESS = ? AND IS_DELETED = 2";
        List resList = bgdDataSource.findBySql(sql, new Object[]{ipAddr});
        // IP不存在于IP白名单中
        if (resList.isEmpty()) {
            throw new ApiException(ApiStatusEnum.ERR_IP.getCode(), ApiStatusEnum.ERR_IP.getMessage());
        }
    }

    /**
     * 防重放攻击
     * 1.时间戳防重放
     * 判断报文时间戳与当前数据库时间差值，大于60s认为是无效请求，60s内为有效请求
     * 2.请求唯一标识防重放
     * 若在有效请求时间范围内，根据报文主键（唯一序列号）、报文时间戳生成请求唯一标识，存储到请求缓存中，
     * 若有相同请求唯一标识的请求，则被认定为重放攻击，被拦截
     *
     * @param params 请求参数
     * @return
     */
    private void antiReplayAttack(Map<String, String> params) throws ApiException {
        String requestTimestamp = MapUtils.getString(params, "TIMESTAMP");
        String msgId = MapUtils.getString(params, "GUID");
        //1.判断请求时间戳与当前系统时间差值
        long subValue = QueryDBUtil.subtractTimeStamp(requestTimestamp);
        // 请求时间大于60s，认为是无效请求
        if (subValue > 60) {
            throw new ApiException("请求超时，该请求无效！");
        }
        //2.生成请求唯一标识，存入数据库
        String requestKey = msgId + requestTimestamp;
        System.out.println(requestKey);
        if (!antiReplaySetNX(requestKey)) {
            throw new ApiException("疑似请求攻击，该请求在短时间内重复提交！");
        }
    }

    /**
     * 向请求缓存表插入key,若key已存在，则返回false,若不存在，则成功插入返回true
     * 并清理大于14天的请求记录
     *
     * @param key 请求唯一标识
     * @return
     */
    private boolean antiReplaySetNX(String key) {
        boolean isPass = false;
        String sql = "INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(DEBT_T_API_REQUEST_CACHE(REQUEST_KEY)) */ INTO " +
                "DEBT_T_API_REQUEST_CACHE(REQUEST_KEY,CREATE_TIME,UPDATE_TIME,IS_DELETED) " +
                "VALUES(?,TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'),TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'),2)";
        try {
            int effectRows = bgdDataSource.updateBySql(sql, new Object[]{key});
            if (effectRows > 0) {
                // 清理大于14天的缓存记录
                String clearSql = "DELETE FROM DEBT_T_API_REQUEST_CACHE WHERE 1=1 AND (SYSDATE - TO_DATE(CREATE_TIME,'YYYY-MM-DD HH24:MI:SS')) > 14";
                bgdDataSource.updateBySql(clearSql, new Object[]{});
                isPass = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isPass;
    }

    /**
     * 校验用户是否授权对某个业务接口下的某个报文拥有访问权限
     *
     * @param userCode 访问用户编码
     * @param apiCode  业务接口编码
     * @param xchCode  报文编码
     * @return
     */
    private Map validUserAuthorization(String userCode, String apiCode, String xchCode) throws ApiException {
        StringBuffer sql = new StringBuffer();
        sql.append("SELECT 1 FROM DEBT_T_API_XCH_USER_AUTH WHERE IS_DELETED = 2 AND USER_CODE = ? AND API_CODE = ? AND XCH_CODE = ?");
        List<Map> resList = bgdDataSource.findBySql(sql.toString(), new Object[]{userCode, apiCode, xchCode});
        if (resList.isEmpty()) {
            throw new ApiException(ApiStatusEnum.ERR_OAUTH.getCode(), ApiStatusEnum.ERR_OAUTH.getMessage());
        }
        return null;
    }

    /**
     * 校验用户名密码等
     *
     * @param userCode
     * @param password
     * @return
     */
    private void validUserPassword(String userCode, String password) throws ApiException {
        //解密
        StringBuffer sql = new StringBuffer();
        sql.append("SELECT 1 FROM DEBT_T_API_ACCESS_USER WHERE IS_DELETED = 2 AND USER_CODE = ? AND USER_PWD = ?");
        List resList = bgdDataSource.findBySql(sql.toString(), new Object[]{userCode, password});
        if (resList.isEmpty()) {
            throw new ApiException(ApiStatusEnum.ERR_USER.getCode(), ApiStatusEnum.ERR_USER.getMessage());
        }
    }
}
