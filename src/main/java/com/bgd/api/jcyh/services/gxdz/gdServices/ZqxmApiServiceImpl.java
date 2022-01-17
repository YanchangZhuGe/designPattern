package com.bgd.api.jcyh.services.gxdz.gdServices;

import com.bgd.api.ApiLogService;
import com.bgd.api.ApiService;
import com.bgd.api.common.enums.ApiEnum;
import com.bgd.api.common.exceptions.ApiException;
import com.bgd.api.common.utils.EnumUtil;
import com.bgd.api.common.utils.JSONUtil;
import com.bgd.platform.util.dao.BgdDataSource;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 广东个性接口-债券项目查询
 * 被动调用
 */
public class ZqxmApiServiceImpl implements ApiService {
    private BgdDataSource bgdDataSource;
    private ApiLogService apiLogService;

    public void setApiLogService(ApiLogService apiLogService)
    {
        this.apiLogService = apiLogService;
    }

    public void setBgdDataSource(BgdDataSource bgdDataSource)
    {
        this.bgdDataSource = bgdDataSource;
    }

    /**
     * @param message 请求报文
     * @param apiEnum 业务接口
     * @param xchCode 报文编码
     * @return
     * @throws Exception
     */
    @Override
    public JSONObject handle(JSONObject message, ApiEnum apiEnum, String xchCode) throws Exception
    {
        String queryTable = EnumUtil.getQueryTableByXchCode(xchCode, apiEnum);
        String USCCODE = JSONUtil.getString(message, "USCCODE");
        String XM_NAME = JSONUtil.getString(message, "XM_NAME");
        // 2.查询数据
        StringBuilder sql = new StringBuilder();
        List<Object> paramList = new ArrayList();

        sql.append(" SELECT T.* FROM ").append(queryTable).append(" T ");
        sql.append(" WHERE 1=1 ");
        if (StringUtils.hasText(USCCODE))
        {
            sql.append(" AND T.USCCODE = ? ");
            paramList.add(USCCODE);
        }
        if (StringUtils.hasText(XM_NAME))
        {
            sql.append(" AND T.XM_NAME LIKE CONCAT(CONCAT('%',?),'%') ");
            paramList.add(XM_NAME);
        }
        List<Map> list = null;
        try
        {
            list = bgdDataSource.findBySql(sql.toString(), paramList.toArray());
        } catch (Exception e)
        {
            throw new ApiException("债券项目信息查询失败", e);
        }
        // 构造报文返回
        JSONObject rs = new JSONObject();
        rs.put("DATA", JSONArray.fromObject(list));
        rs.put("params", message);
        return rs;
    }
}
