package com.example.utils.file.config;

import com.nstc.common.orm.utils.NstcDataScopeContext;
import com.nstc.common.utils.bean.ObjectUtil;
import com.nstc.core.entity.view.NsclientView;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import java.util.*;
import java.util.stream.Collectors;

/**
 * <p>Title: </p>
 *
 * <p>Description: </p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author
 * @since：
 */

@Component
public class LmsUnitDataScopeUtil {
    private final String HANDLING = "LMS_handling";
    private static final Logger logger = LoggerFactory.getLogger(LmsUnitDataScopeUtil.class);

    public Set<String> getIntersectUnit(List<NsclientView> unitNoList) {
        // 获取数据权限中的单位列表
        List<String> cust_no = NstcDataScopeContext.getInstance().getColumnDataScopeList("cust_no");
        List<String> collect = unitNoList.stream().map(NsclientView::getUnitNo).collect(Collectors.toList());
        collect.retainAll(cust_no);
        return new HashSet<>(collect);
    }

    public List<String> getAuthUnit() {
        // 获取数据权限中的单位列表
        String cust_no = NstcDataScopeContext.getInstance().getColumnDataScope("cust_no");
        String[] split = cust_no.split(",");
        return Arrays.asList(split);
    }

    /**
         * 获取业务品种对应的具有权限的单位
         * @param
         * @return
         */

    public List<String> getAuthUnitWithHandling(Integer handlingAudit) {
        List<String> result;
        if (ObjectUtil.isEmpty(handlingAudit)) {
            handlingAudit = 0;
        }
        if (handlingAudit == 1) {
            List<Map<String, String>> unitBizList = NstcDataScopeContext.getInstance().getColumnDataScopeMatrix("cust_no,lms_type_no");
            //logger.error("获取的数据权限为"+unitBizList);

            // 单位编号 -> 对应的业务品种
            // [{0011=AIMS,AIMS_handling}]
            Set<String> finalResult = new HashSet<>();
            unitBizList.forEach(unitBiz -> {
                unitBiz.forEach((unitNo, bizTypes) -> {
                    String[] split = bizTypes.split(",");
                    List<String> list = Arrays.asList(split);
                    if (list.contains(HANDLING)) {
                        finalResult.add(unitNo);
                    }
                });
            });
            result = new ArrayList<>(finalResult);
        } else {
            result = getAuthUnit();
        }
        //logger.error("处理之后的数据权限"+result);
        return result;
    }

    /**
     * 根据单位编号校验是否具有经办权限
     * @param unitNo
     * @return
     */
    public boolean checkHandlingAuth(String unitNo) {
        List<String> authUnitWithHandling = getAuthUnitWithHandling(1);
        return authUnitWithHandling.contains(unitNo);
    }
}
