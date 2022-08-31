package designPattern.behavior.iterator.enums;

/**
 * <p>Title：</p>
 *
 * <p>Description：合同变更类型</p>
 *
 * <p>Company：北京九恒星科技股份有限公司</p>
 *
 * @author hsw
 * @since：2018年3月7日 下午2:01:41
 */
public enum GuaranteeModiType {
    // 内容修正
    TEXT_MODI(0),
    // 合同变更
    CONTRACT_MODI(1);

    private Integer value;

    private GuaranteeModiType(Integer value) {
        this.value = value;
    }

    public Integer getValue() {
        return value;
    }

    public void setValue(Integer value) {
        this.value = value;
    }


}
