package designPattern.behavior.iterator.enums;

import com.nstc.common.entity.core.exception.NsBizException;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2022/7/13 13:37
 */
@Getter
@AllArgsConstructor
public enum PledgeImportEnum {

    A("押品编号", "pledgeNo"),
    B("单位名称", "unitName"),
    C("押品名称", "pledgeName"),
    D("抵押/质押", "pledgeTypeName"),
    E("押品类型", "ptName"),
    F("币种", "curName"),
    G("净值", "netWorthAmouint"),
    H("评估价值", "evaluaAmount"),
    I("评估机构", "organ"),
    J("评估基准日", "evalDatueDay"),
    K("备注", "memo"),
    ;

    private String key;
    private String value;

    /**
     * 中文转化
     */
    public static List<Map<String, Object>> changeKey(List<Map<String, Object>> list) {
        List<Map<String, Object>> result = new ArrayList<>();
        list.stream().forEach(stringObjectMap -> {
            Map<String, Object> map = new HashMap<>();
            for (PledgeImportEnum importEnum : PledgeImportEnum.values()) {
                for (Map.Entry<String, Object> entry : stringObjectMap.entrySet()) {
                    if (importEnum.getKey().equals(entry.getKey())) {
                        map.put(importEnum.getValue(), stringObjectMap.get(entry.getKey()));
                    }
                }
            }
            result.add(map);
        });

        return result;
    }

    /**
     * 校验模板
     */
    public static void checkIsTemplate(List<String> list) {
        list.stream().forEach(stringObjectMap -> {
            for (PledgeImportEnum importEnum : PledgeImportEnum.values()) {
                //判断这个表头有没有匹配模板,如果有一个表头没有模板匹配项,那么弹窗提示
                boolean flag = false;
                for (String str : list) {
                    if (importEnum.getKey().equals(str)) {
                        flag = true;
                    }
                }
                if (flag == false) {
                    throw new NsBizException("导入模板不符");
                }
            }
        });
    }

    public static List<Map<String, Object>> convertHeader(List<String> list) {
        List<Map<String, Object>> result = new ArrayList<>();
        list.stream().forEach(str -> {
            for (PledgeImportEnum importEnum : PledgeImportEnum.values()) {
                if (importEnum.getKey().equals(str)) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("label", importEnum.getKey());
                    map.put("prop", importEnum.getValue());
                    result.add(map);
                }
            }
        });

        return result;
    }
}
