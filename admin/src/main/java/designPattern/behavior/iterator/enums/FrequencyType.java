
package designPattern.behavior.iterator.enums;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <p>Description: 保费收取频率</p>
 *
 * @author hsw
 * @since：2018年1月26日 下午4:15:25
 */
public enum FrequencyType implements TypeEnum {

    /**
     * 按年
     */
    TYPE_01(new Integer(1), "按年", 1, 12),
    /**
     * 按半年
     */
    TYPE_02(new Integer(2), "按半年", 2, 6),
    /**
     * 按季
     */
    TYPE_03(new Integer(3), "按季", 4, 3),
    /**
     * 按月
     */
    TYPE_04(new Integer(4), "按月", 12, 1),
    /**
     * 一次性收取
     */
    TYPE_05(new Integer(5), "一次性收取", 0, 0);
    private Integer value;
    private String name;
    //一年计息次数
    private Integer frequency;
    //月数
    private Integer months;

    FrequencyType(Integer value, String name, Integer frequency, Integer months) {
        this.value = value;
        this.name = name;
        this.frequency = frequency;
        this.months = months;
    }

    public static String getTypeName(Integer value) {
        for (FrequencyType p : values()) {
            if (p.getValue().equals(value)) {
                return p.getName();
            }
        }
        return "";
    }

    public static FrequencyType getFrequencyType(Integer value) {
        for (FrequencyType p : values()) {
            if (p.getValue().equals(value)) {
                return p;
            }
        }
        return null;
    }

    public static List<Map<String, Object>> getList() {
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        for (FrequencyType temp : FrequencyType.values()) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("value", temp.value);
            map.put("name", temp.name);
            list.add(map);
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

    public Integer getFrequency() {
        return frequency;
    }

    public void setFrequency(Integer frequency) {
        this.frequency = frequency;
    }

    public Integer getMonths() {
        return months;
    }

    public void setMonths(Integer months) {
        this.months = months;
    }

}
