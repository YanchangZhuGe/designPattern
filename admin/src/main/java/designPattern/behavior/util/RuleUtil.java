package designPattern.behavior.util;

import com.nstc.neams.dao.entity.EamsBussPropertyEntity;

import java.util.ArrayList;
import java.util.List;

public class RuleUtil {
    /**
     * 校验业务传输的字段和维护的字段是否符合
     *
     * @param eamsBussPropertyList 维护
     * @param itmeNoList           传输的itmeNo
     */
    public static void AttributeCheck(List<EamsBussPropertyEntity> eamsBussPropertyList, List<String> itmeNoList) {
        List<String> proNoList = new ArrayList();
        for (EamsBussPropertyEntity entity : eamsBussPropertyList) {
            proNoList.add(entity.getProNo());
        }

        for (String itmeNo : itmeNoList) {
            if (!proNoList.contains(itmeNo)) {
                throw new RuntimeException("维护的业务属性值不存在" + itmeNo);
            }
        }

    }
}
