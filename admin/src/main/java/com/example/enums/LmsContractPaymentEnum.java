package com.example.enums;

import com.alibaba.fastjson.JSONObject;
import com.nstc.util.StringUtils;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2022/5/26 10:37
 */
@Getter
@AllArgsConstructor
public enum LmsContractPaymentEnum {

    /**
     * 分类
     */
    REPAYMENT_TYPE("REPAYMENT_TYPE", "TOP", "还本方式"),
    REPAYMENT_FREQUENCY("REPAYMENT_FREQUENCY", "TOP", "还本频率"),
    REPAYMENT_FIRST_DATE("REPAYMENT_FIRST_DATE", "TOP", "首次还本日期"),
    PAYMENT_TYPE("PAYMENT_TYPE", "TOP", "付息方式"),
    PAYMENT_FREQUENCY("PAYMENT_FREQUENCY", "TOP", "付息频率"),
    PAYMENT_FIRST_DATE("PAYMENT_FIRST_DATE", "TOP", "首次付息日期"),

    /**
     * 还本
     */
    //还本方式
    REPAYMENT_TYPE_01("01", "REPAYMENT_TYPE", "到期一次"),
    REPAYMENT_TYPE_02("02", "REPAYMENT_TYPE", "定期还本"),
    //还本频率
    REPAYMENT_FREQUENCY_01("01", "REPAYMENT_FREQUENCY", "按月"),
    REPAYMENT_FREQUENCY_02("02", "REPAYMENT_FREQUENCY", "按季"),
    REPAYMENT_FREQUENCY_03("03", "REPAYMENT_FREQUENCY", "按半年"),
    REPAYMENT_FREQUENCY_04("04", "REPAYMENT_FREQUENCY", "按年"),
    //首次还本日期
    REPAYMENT_FIRST_DATE_01("01", "REPAYMENT_FIRST_DATE", "合同开始日"),
    REPAYMENT_FIRST_DATE_02("02", "REPAYMENT_FIRST_DATE", "合同结束日"),
    REPAYMENT_FIRST_DATE_03("03", "REPAYMENT_FIRST_DATE", "自定义日期"),

    /**
     * 付息
     */
    //付息方式
    PAYMENT_TYPE_01("01", "PAYMENT_TYPE", "利随本清"),
    PAYMENT_TYPE_02("02", "PAYMENT_TYPE", "定期付息"),
    //付息频率
    PAYMENT_FREQUENCY_01("01", "PAYMENT_FREQUENCY", "按月"),
    PAYMENT_FREQUENCY_02("02", "PAYMENT_FREQUENCY", "按季"),
    PAYMENT_FREQUENCY_03("03", "PAYMENT_FREQUENCY", "按半年"),
    PAYMENT_FREQUENCY_04("04", "PAYMENT_FREQUENCY", "按年"),
    //首次付息日期
    PAYMENT_FIRST_DATE_01("01", "PAYMENT_FIRST_DATE", "合同开始日"),
    PAYMENT_FIRST_DATE_02("02", "PAYMENT_FIRST_DATE", "合同结束日"),
    PAYMENT_FIRST_DATE_03("03", "PAYMENT_FIRST_DATE", "自定义日期"),

    ;

    private String code;
    private String parentCode;
    private String name;

    public static List<JSONObject> getTypeList(String type) {
        String type_ = StringUtils.isEmpty(type) ? "TOP" : type;
        List<JSONObject> list = new ArrayList<JSONObject>();

        for (LmsContractPaymentEnum e : values()) {
            if (e.getParentCode().equals(type_)) {
                JSONObject jsonObject = new JSONObject();
                List<JSONObject> byParent = getByParent(e.getCode());
                jsonObject.put("code", e.getCode());
                jsonObject.put("name", e.getName());
                jsonObject.put("value", byParent);
                list.add(jsonObject);
            }
        }

        return list;
    }

    public static List<JSONObject> getByParent(String parentCode) {

        List<JSONObject> collect = Arrays.stream(values()).parallel()
                .filter(e -> e.getParentCode().equals(parentCode))
                .map(e -> {
                    JSONObject jsonObject = new JSONObject();
                    List<JSONObject> byParent = getByParent(e.getCode());

                    jsonObject.put("code", e.getCode());
                    jsonObject.put("name", e.getName());
                    jsonObject.put("value", byParent);
                    return jsonObject;
                }).collect(Collectors.toList());

        return collect;
    }

}
