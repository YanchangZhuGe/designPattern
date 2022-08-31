package com.bgd.api.common.security.arithmetic.util;

import com.nstc.common.utils.bean.BeanUtil;
import com.nstc.common.utils.string.StringUtil;
import com.nstc.gwms.entity.scope.order.GwmsFeesPayOrderScope;
import com.nstc.gwms.entity.scope.order.GwmsFeesPlanSyncOrderScope;
import com.nstc.gwms.entity.scope.order.GwmsOrderCommonScope;
import lombok.extern.slf4j.Slf4j;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 查询排序工具包
 */
@Slf4j
public class GwmsQuerySortUtil {

    private static Map<String, Map<String, String>> map;

    /**
     * 初始化各个查询支持的排序信息
     */
    private static void prepareMap() {
        if (GwmsQuerySortUtil.map == null) {
            GwmsQuerySortUtil.map = new HashMap<>();

            //初始化
            //模块列表查询
            GwmsQuerySortUtil.map.put("PrmsAppOrderScope", GwmsFeesPayOrderScope.buildOrderPropertyAndColumn());
            //需要同步到融资的保费计划查询
            GwmsQuerySortUtil.map.put("GwmsFeesPlanSyncOrderScope", GwmsFeesPlanSyncOrderScope.buildOrderPropertyAndColumn());
        }
    }

    /**
     * @param key
     * @param obj 必须是list类型的数据
     * @return
     */
    public static List<GwmsOrderCommonScope> buildSortConditionPre(String key, Object obj) {
        try {
            prepareMap();

            if (StringUtil.isNotEmpty(key) && obj != null) {
                List<Object> orderParamList = (List<Object>) obj;
                if (orderParamList != null && orderParamList.size() > 0) {
                    List<GwmsOrderCommonScope> list = BeanUtil.toBeanList(orderParamList, GwmsOrderCommonScope.class);

                    List<GwmsOrderCommonScope> sortList = null;
                    if (StringUtil.isNotEmpty(key)) {
                        Map<String, String> propertyColumnMap = map.get(key);
                        if (propertyColumnMap != null && list != null && list.size() > 0) {
                            sortList = new ArrayList<>();

                            for (int i = 0; i < list.size(); i++) {
                                GwmsOrderCommonScope temp = list.get(i);
                                if (temp == null) {
                                    continue;
                                }

                                //无效的字段直接跳过
                                String orderProperty = temp.getOrderProperty();
                                if (StringUtil.isEmpty(orderProperty)) {
                                    continue;
                                }

                                //字段未配置列直接跳过
                                String orderColumn = propertyColumnMap.get(orderProperty);
                                if (StringUtil.isEmpty(orderColumn)) {
                                    continue;
                                }
                                temp.setOrderColumn(orderColumn);

                                //确定升序还是降序
                                String orderType = temp.getOrderType();
                                if (StringUtil.isEmpty(orderType)) {
                                    //默认升序
                                    orderType = "ASC";
                                }
                                if ("ASC".equals(orderType.toUpperCase())) {
                                    orderType = "ASC";
                                } else if ("DESC".equals(orderType.toUpperCase())) {
                                    orderType = "DESC";
                                } else {
                                    //非法时默认升序
                                    orderType = "ASC";
                                }
                                temp.setOrderType(orderType);

                                sortList.add(temp);
                            }
                        }
                    }

                    return sortList;
                }
            }
        } catch (Exception e) {
            log.error("构造查询排序参数异常,排序可能无法生效");
            e.printStackTrace();
        }
        return null;
    }

}
