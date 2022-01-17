package com.bgd.api.jcyh.services.gxdz.business;

import com.alibaba.fastjson.JSONObject;
import com.bgd.debt.common.util.DebtUtils;
import com.bgd.platform.util.action.BaseAction;
import net.sf.json.JSONArray;
import org.apache.struts2.ServletActionContext;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

/**
 * 描述: 个性定制接口 公共action
 *
 * @author WuYanchang
 * @date 2022/1/10 17:16
 */

public class GxdzCommonAction extends BaseAction {

    private GxdzCommonService gxdzCommonService;

    public GxdzCommonService getGxdzCommonService()
    {
        return gxdzCommonService;
    }

    public void setGxdzCommonService(GxdzCommonService gxdzCommonService)
    {
        this.gxdzCommonService = gxdzCommonService;
    }

    public void getZflsGrid()
    {
        HttpServletRequest req = ServletActionContext.getRequest();
        String userCode = (String) req.getSession().getAttribute("USERCODE");//获取登录用户
        String USER_AD_CODE = (String) req.getSession().getAttribute("ADCODE");//获取登录用户的区划权限
        String AD_BJ_CODE = (String) req.getSession().getAttribute("AD_BJ_CODE");//获取登录用户的区划权限

        //接收req传递过来的参数
        Map<String, Object> param = DebtUtils.getEscapeParameterMap(req);

        JSONObject res = new JSONObject();
        //分页
        int start = Integer.parseInt(DebtUtils.escapeParamValue(req, "start", 0, "number"));
        int limit = Integer.parseInt(DebtUtils.escapeParamValue(req, "limit", 0, "number"));
        try
        {
            JSONObject result = gxdzCommonService.getZflsGrid(start, limit, param);
            res.put("list", JSONArray.fromObject((List) result.get("list")));
            res.put("totalcount", (Integer) result.get("count"));
        } catch (Exception e)
        {
            res.put("success", false);
            res.put("msg", DebtUtils.getExceptionMessage(e));
        }
        responseToWeb(res.toString());
    }

    public void GXDZServiceGD()
    {
        HttpServletRequest req = ServletActionContext.getRequest();
        HttpServletResponse resp = ServletActionContext.getResponse();
        resp.setContentType("text/html");
        resp.setCharacterEncoding("utf-8");

        //接收req传递过来的参数
        Map<String, Object> param = DebtUtils.getEscapeParameterMap(req);
        JSONObject result = new JSONObject();
        //将保存功能的结果返回到前台
        try
        {
            Integer re = gxdzCommonService.GXDZServiceGD(param);
            result.put("count", re);
            result.put("success", true);
        } catch (Exception e)
        {
            result.put("success", false);
            result.put("message", DebtUtils.getExceptionMessage(e));
        } finally
        {
            try
            {
                PrintWriter out = resp.getWriter();
                out.write(result.toString());
            } catch (IOException e)
            {
                e.printStackTrace();
            }
        }
    }
}
