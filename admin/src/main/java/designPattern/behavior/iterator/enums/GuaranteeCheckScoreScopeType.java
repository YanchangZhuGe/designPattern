
package designPattern.behavior.iterator.enums;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * <p>Description: 担保考核结果得分区间范围标识</p>
 *
 * @author hsw
 * @since：2018年1月26日 下午4:15:25
 */
public enum GuaranteeCheckScoreScopeType {

    /**
     * 大于
     */
    TYPE_01(new Integer(1), ">"),
    /**
     * 等于
     */
    TYPE_02(new Integer(2), "="),
    /**
     * 小于
     */
    TYPE_03(new Integer(3), "<");

    private Integer value;
    private String name;

    GuaranteeCheckScoreScopeType(Integer value, String name) {
        this.value = value;
        this.name = name;
    }

    public static String getTypeName(Integer value) {
        for (GuaranteeCheckScoreScopeType p : values()) {
            if (p.getValue().equals(value)) {
                return p.getName();
            }
        }
        return "";
    }

    public static List<Map<String, Object>> getListMin() {
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        for (GuaranteeCheckScoreScopeType temp : GuaranteeCheckScoreScopeType.values()) {
            if (temp.value > 1) {
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("value", temp.value);
                map.put("name", temp.name);
                list.add(map);
            }
        }
        return list;
    }

    public static List<Map<String, Object>> getListMax() {
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        for (GuaranteeCheckScoreScopeType temp : GuaranteeCheckScoreScopeType.values()) {
            if (temp.value < 3) {
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("value", temp.value);
                map.put("name", temp.name);
                list.add(map);
            }
        }
        return list;
    }

    /**
     * @return Integer
     */
    public Integer getValue() {
        return value;
    }

    /**
     * @param value Integer
     */
    public void setValue(Integer value) {
        this.value = value;
    }

    /**
     * @return String
     */
    public String getName() {
        return name;
    }

    /**
     * @param name String
     */
    public void setName(String name) {
        this.name = name;
    }

}
