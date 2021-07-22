package com.ops.designpattern.util.enums;

import javax.swing.*;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/7/22 16:21
 */
public enum OpenTypeEnum {
    ARTICLE("article", "打开文章"),
    TITLE("title", "搜索标题");
    private String type;
    private String describe;

    OpenTypeEnum(String type, String describe) {
        this.type = type;
        this.describe = describe;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getDescribe() {
        return describe;
    }

    public void setDescribe(String describe) {
        this.describe = describe;
    }
}
