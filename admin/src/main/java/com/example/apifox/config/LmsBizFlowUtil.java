package com.example.apifox.config;

import com.nstc.lms.constants.LmsConstants;
import com.nstc.lms.enums.LmsUmFmClsEnum;
import org.springframework.util.StringUtils;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * <p>Title:</p>
 *
 * <p>Description:</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author wk
 * @since：2020/12/9 15:05
 */
public final class LmsBizFlowUtil {
    /**
     * 日期格式
     */
    //private final SimpleDateFormat BIZ_NO_SDF = new SimpleDateFormat("yyyyMMdd");
    /**
     * 序号格式
     */
    private static final DecimalFormat SEQUENCE_FORMATTER = new DecimalFormat("0000");
    /**
     * 每个流程对应序列号
     */
    private static final Map<String, Integer> BIZ_NO_SEQUENCE_MAP = new HashMap<>();
    /**
     * @Description：获取流程编号
     * @param umFmCls 流程类型
     * @author wk
     * @return 流程编号
     * @since：2021/1/12 16:56
     */
    public static final String getBizNo(LmsUmFmClsEnum umFmCls) {
        SimpleDateFormat BIZ_NO_SDF = new SimpleDateFormat("yyyyMMdd");
        // 流程编号规则为  模块编号-流程编号-YYYYMMDD+4位序列号
        StringBuilder bizNoBuilder = new StringBuilder()
                //.append(AccountConstants.CHANNEL)
                //.append(AccountConstants.BIZ_NO_SEPARATOR)
                .append(umFmCls.getValue())
                .append(LmsConstants.BIZ_NO_SEPARATOR)
                .append(BIZ_NO_SDF.format(Calendar.getInstance().getTime()));
        // 从内存中获取序列号 如果没有则从数据库查询 , 没有数据则默认0000 下一个序号为0001
        Integer nextBizNoSequence = null;
        synchronized (BIZ_NO_SEQUENCE_MAP) {
            Integer bizNoSequence = BIZ_NO_SEQUENCE_MAP.get(bizNoBuilder.toString());
            if (bizNoSequence == null) {
                String sequenceNo = LmsSpringContextUtil.getServiceLocator().getUmFormService().getBizNoSequenceNo(bizNoBuilder.toString());
                if (StringUtils.isEmpty(sequenceNo)) {
                    sequenceNo = LmsConstants.DEFAULT_BIZ_NO_SEQUENCE;
                }
                bizNoSequence = Integer.valueOf(sequenceNo);
                BIZ_NO_SEQUENCE_MAP.put(bizNoBuilder.toString(), bizNoSequence);
            }
            bizNoSequence += 1;
            nextBizNoSequence = bizNoSequence;
        }
        bizNoBuilder.append(SEQUENCE_FORMATTER.format(nextBizNoSequence));
        return bizNoBuilder.toString();
    }
}
