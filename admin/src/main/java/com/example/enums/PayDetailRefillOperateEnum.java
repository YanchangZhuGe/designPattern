package com.example.enums;

/**
 * 明细补填操作枚举
 */
public enum PayDetailRefillOperateEnum {
    /**
     * 自动匹配保存,待确认
     */
    AUTO_SAVE,
    /**
     * 自动匹配保存,生效
     */
    AUTO_EFFECTIVE,
    /**
     * 手动保存
     */
    SAVE,
    /**
     * 手动提交
     */
    SUBMIT;
}