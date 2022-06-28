package com.example.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 内部户做账业务品种
 *
 * @author zhixiang.deng
 * @version 6.0.0
 * @since 2022/4/22 10:32
 */
@Getter
@AllArgsConstructor
public enum InnerBussNoEnum {

    /**
     * 资金下拨
     */
    BUSS_COLLECTION_DOWN("BUSS_COLLECTION_DOWN"),
    ;


    private final String bussNo;
}
