package com.example.apifox.config;

import com.nstc.common.utils.bean.BeanUtil;
import com.nstc.common.utils.string.StringUtil;
import com.nstc.lms.entity.scope.order.*;
import lombok.extern.slf4j.Slf4j;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 查询排序工具包
 */
@Slf4j
public class LmsQuerySortUtil {

    private static Map<String, Map<String, String>> map;

    /**
     * 初始化各个查询支持的排序信息
     */
    private static void prepareMap() {
        if (LmsQuerySortUtil.map == null) {
            LmsQuerySortUtil.map = new HashMap<>();

            //初始化
            //借出方总览排序
            LmsQuerySortUtil.map.put("LmsContractOrderScopeOf001", LmsContractOrderScopeOf001.buildOrderPropertyAndColumn());
            //借入方总览排序
            LmsQuerySortUtil.map.put("LmsContractOrderScopeOf002", LmsContractOrderScopeOf002.buildOrderPropertyAndColumn());
            //借款合同列表查询排序
            LmsQuerySortUtil.map.put("LmsContractOrderScopeOf005", LmsContractOrderScopeOf005.buildOrderPropertyAndColumn());
            // 放还款记录排序
            LmsQuerySortUtil.map.put("LmsContractOrderScopeOf035", LmsContractOrderScopeOf035.buildOrderPropertyAndColumn());
            // 借款合同展期记录排序
            LmsQuerySortUtil.map.put("LmsContractOrderScopeOf036", LmsContractOrderScopeOf036.buildOrderPropertyAndColumn());
            // 借款合同操作日志排序
            LmsQuerySortUtil.map.put("LmsContractOrderScopeOf038", LmsContractOrderScopeOf038.buildOrderPropertyAndColumn());

            //放款台账查询排序
            LmsQuerySortUtil.map.put("LmsContractLedgerOrderScopeOf050", LmsContractLedgerOrderScopeOf050.buildOrderPropertyAndColumn());
            //后续有其他查询的排序，直接添加到此处即可
        }
    }

    /**
     *
     * @param key
     * @param obj 必须是list类型的数据
     * @return
     */
    public static List<LmsOrderCommonScope> buildSortConditionPre(String key, Object obj) {
        try {
            prepareMap();

            if (StringUtil.isNotEmpty(key) && obj != null) {
                List<Object> orderParamList = (List<Object>) obj;
                if (orderParamList != null && orderParamList.size() > 0) {
                    List<LmsOrderCommonScope> list = BeanUtil.toBeanList(orderParamList, LmsOrderCommonScope.class);

                    List<LmsOrderCommonScope> sortList = null;
                    if (StringUtil.isNotEmpty(key)) {
                        Map<String, String> propertyColumnMap = map.get(key);
                        if (propertyColumnMap != null && list != null && list.size() > 0) {
                            sortList = new ArrayList<>();

                            for (int i = 0; i < list.size(); i++) {
                                LmsOrderCommonScope temp = list.get(i);
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
