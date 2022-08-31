package designPattern.behavior.iterator.enums;

/**
 * <p>
 * Title:
 * </p>
 *
 * <p>
 * Description:操作状态枚举
 * </p>
 *
 * <p>
 * Company: 北京九恒星科技股份有限公司
 * </p>
 *
 * @author chenlu
 * @since：2016-8-8 下午01:18:33
 */

public enum SaveOrSubmitEnum {

    /*** 保存 **/
    save("save", "保存"),
    /*** 提交 **/
    submit("submit", "提交");

    SaveOrSubmitEnum(String key, String name) {
        this.key = key;
        this.name = name;
    }

    private String key;
    private String name;

    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
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
