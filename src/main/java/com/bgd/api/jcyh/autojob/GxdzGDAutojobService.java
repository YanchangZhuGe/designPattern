package com.bgd.api.jcyh.autojob;

import com.alibaba.fastjson.JSONObject;
import com.bgd.api.jcyh.services.gxdz.business.GxdzCommonService;
import com.bgd.platform.autotask.job.AutoJob;
import com.bgd.platform.util.service.SpringContextUtil;
import org.apache.commons.collections.MapUtils;

import java.util.Map;

/**
 * 描述: 广东查询数据定时任务类
 *
 * @author WuYanchang
 * @date 2022/1/12 17:55
 */

public class GxdzGDAutojobService extends AutoJob {
    private GxdzCommonService autoJobService = (GxdzCommonService) SpringContextUtil.getBean("gxdzCommonService");

    @Override
    public boolean jobRun(Map map)
    {
        boolean result = false;
        //具体业务处理交给service
        try
        {
            JSONObject jobParam = JSONObject.parseObject(MapUtils.getString(map, "param"));
            result = autoJobService.autoJob(jobParam);
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return result;
    }
}
