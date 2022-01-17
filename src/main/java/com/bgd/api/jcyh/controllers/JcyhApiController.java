package com.bgd.api.jcyh.controllers;

import com.bgd.api.AbstractApiController;
import com.bgd.api.ApiLogService;
import com.bgd.api.common.enums.ApiEnum;
import com.bgd.api.common.security.check.ApiCheckService;
import com.bgd.platform.util.service.SpringContextUtil;
import net.sf.json.JSONObject;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;

/**
 * @author guodg
 * @date 2021/5/12 16:58
 * @description
 */
@RestController("jcyhApiController")
@RequestMapping("/api/v1/jcyh")
public class JcyhApiController extends AbstractApiController {
    /**
     * 注入
     */
    @Override
    protected void init() {
        super.apiLogService = (ApiLogService) SpringContextUtil.getBean("commonApiLogService");
        super.apiCheckService = (ApiCheckService) SpringContextUtil.getBean("commonApiCheckService");
    }

    /**
     * 银行账户接收接口
     *
     * @param message
     * @param request
     * @return
     */
    @RequestMapping(value = "/receiveService", method = RequestMethod.POST)
    @ResponseBody
    public JSONObject service1(@RequestBody JSONObject message, HttpServletRequest request) {
        return super.service(message, request, ApiEnum.API_JCYH);
    }

    /**
     * 测试接口
     *
     * @return
     */
    @RequestMapping(value = "/apiTest", method = RequestMethod.GET)
    @ResponseBody
    public String test() {
        return "Hello Word! This is JCYH API!";
    }

    /**
     * 个性定制接口
     *
     * @param message
     * @param request
     * @return
     */
    @RequestMapping(value = "/GXDZService", method = RequestMethod.POST)
    @ResponseBody
    public JSONObject GXDZService(@RequestBody JSONObject message, HttpServletRequest request)
    {
        return super.GXDZService(message, request, ApiEnum.API_GXDZ_GD);
    }

    /**
     * 模拟数财
     *
     * @param message
     * @param request
     * @return
     */
    @RequestMapping(value = "/GXDZService_zs", method = RequestMethod.POST)
    @ResponseBody
    public JSONObject GXDZService_zs(@RequestBody JSONObject message, HttpServletRequest request)
    {
        System.out.println("->模拟中枢发放token接口");
        String s = "{\n" +
                "  \"resultCode\": \"000\",\n" +
                "  \"data\": \"eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySW5mbyI6IntcImNhcHRpb25cIjpcIueuoeeQhuWRmFwiLFwiY29kZVwiOlwiMDAwMDFcIixcImNvbW1lbnRzXCI6XCLns7vnu5_nrqHnkIblkZjnlKjmiLdcIixcImNyZWF0ZVRpbWVcIjpcIjIwMTctMDgtMjMgMTU6MDA6MDBcIixcImVtYWlsXCI6XCJhZG1pbkBhZG1pbi5jb21cIixcIm1vZGlmeVRpbWVcIjpcIjIwMTktMTEtMDcgMTU6MTA6MThcIixcIm1vZGlmeVVzZXJcIjpcImRkZDMzMzgzLTAyYjUtNDZiZi1iNjkyLThlNmM5NzY1OGE2OVwiLFwicGtcIjpcImRkZDMzMzgzLTAyYjUtNDZiZi1iNjkyLThlNmM5NzY1OGE2OVwiLFwidGVsZXBob25lXCI6XCIxNzczODA2OTc0MVwiLFwidG9rZW5cIjpcImRyczQ4aDNvdDJlMTkzYXFieDdnXCIsXCJ1c2VySWRlbnRpdHlcIjpcIlNZU1RFTUFETUlOXCIsXCJ1c2VyTG9ja2VkXCI6ZmFsc2UsXCJ1c2VyTmFtZVwiOlwiYWRtaW5cIixcInVzZXJQa1wiOlwiZGRkMzMzODMtMDJiNS00NmJmLWI2OTItOGU2Yzk3NjU4YTY5XCIsXCJ1c2VyUm9sZVJlbExpc3RcIjpbXX0iLCJleHAiOjE1OTAyOTcxNTh9.32od_c2aBLDJ8GGxz5v0M7lBmnYjAUukwM64-8PKwHQ\",\n" +
                "  \"resultMessage\": \"获取token成功,有效期为1800秒\"\n" +
                "}";

        return JSONObject.fromObject(s);
    }

    /**
     * 模拟中枢
     *
     * @param message
     * @param request
     * @return
     */
    @RequestMapping(value = "/GXDZService_", method = RequestMethod.POST)
    @ResponseBody
    public JSONObject GXDZService_(@RequestBody JSONObject message, HttpServletRequest request)
    {
        System.out.println("->模拟数财提供数据接口");
        String token = request.getHeader("X-Aa-Token");
        System.out.println("需验证的token为>>> " + token);
        String s = "{\n" +
                "  \"DATA\": [\n" +
                "    {\n" +
                "      \"REFNBR\": \"交易流水ID\",\n" +
                "      \"XM_CODE\": \"债券项目编码\",\n" +
                "      \"XM_NAME\": \"债券项目名称\",\n" +
                "      \"ACC_NAME\": \"付款人\",\n" +
                "      \"ACC_NO\": \"2021042803\",\n" +
                "      \"RPYNAM\": \"收款人\",\n" +
                "      \"RPYACC\": \"收款账号\",\n" +
                "      \"TSDAMT\": 323232,\n" +
                "      \"ETYDAT\": \"2022-01-13\",\n" +
                "      \"NUSAGE\": \"交易用途\"\n" +
                "    },{\n" +
                "      \"REFNBR\": \"交易流水ID123\",\n" +
                "      \"XM_CODE\": \"债券项目编码321\",\n" +
                "      \"XM_NAME\": \"债券项目名称111\",\n" +
                "      \"ACC_NAME\": \"付款人11\",\n" +
                "      \"ACC_NO\": \"2021042803\",\n" +
                "      \"RPYNAM\": \"收款人11\",\n" +
                "      \"RPYACC\": \"收款账号111\",\n" +
                "      \"TSDAMT\": 323232,\n" +
                "      \"ETYDAT\": \"2022-01-13\",\n" +
                "      \"NUSAGE\": \"交易用途111\"\n" +
                "    },{\n" +
                "      \"REFNBR\": \"交易流水ID32122\",\n" +
                "      \"XM_CODE\": \"债券项目编码12223\",\n" +
                "      \"XM_NAME\": \"债券项目名称22\",\n" +
                "      \"ACC_NAME\": \"付款人22\",\n" +
                "      \"ACC_NO\": \"2021042803\",\n" +
                "      \"RPYNAM\": \"收款人222\",\n" +
                "      \"RPYACC\": \"收款账22号\",\n" +
                "      \"TSDAMT\": 323232,\n" +
                "      \"ETYDAT\": \"2022-01-13\",\n" +
                "      \"NUSAGE\": \"交易用222途\"\n" +
                "    }\n" +
                "  ],\n" +
                "  \" resultCode \": \"000000\",\n" +
                "  \" resultMessage \": \"成功\"\n" +
                "}";

        return JSONObject.fromObject(s);
    }
}
