package com.bgd.api.common.security.arithmetic.util;

import com.nstc.common.utils.string.StringUtil;
import com.nstc.util.CastUtil;

import java.math.BigDecimal;
import java.util.Date;

public class CheckChangedUtil {

    /**
     * 比较字符串的变化
     *
     * @param oldObj
     * @param newObj
     * @return
     */
    public static boolean checkChangedString(Object oldObj, Object newObj) {
        String oldVal = null;
        String newVal = null;
        if (oldObj != null) {
            oldVal = StringUtil.toString(oldObj);
        }
        if (newObj != null) {
            newVal = StringUtil.toString(newObj);
        }

        if (oldVal != null && !oldVal.equals(newVal)) {
            //旧值为空，旧值不与新值相等
            return true;
        }
        if (newVal != null && !newVal.equals(oldVal)) {
            //新值为空，新值不与旧值相等
            return true;
        }

        //新旧值都为空、都不为空且相等
        return false;
    }

    /**
     * 比较Bigdecimal类型数据是否有变化
     *
     * @param oldObj
     * @param newObj
     * @return
     */
    public static boolean checkChangedBigDecimal(Object oldObj, Object newObj) {
        BigDecimal oldVal = null;
        BigDecimal newVal = null;
        if (oldObj != null) {
            oldVal = (BigDecimal) oldObj;
        }
        if (newObj != null) {
            newVal = (BigDecimal) newObj;
        }

        //做空判断，防止反编译时默认调用Obj.value等做比较出现NullPointerException异常

        if (oldVal == null && newVal == null) {
            //新旧值都为空，那么没有变化
            return false;
        }

        //以下，最多只可能有一个为空
        if (oldVal == null && newVal != null) {
            //旧值为空，新值不为空，那么有变化
            return true;
        }
        if (oldVal != null && newVal == null) {
            //旧值不为空，新值为空，那么有变化
            return true;
        }

        //以下理论上来说已经不可能出现oldVal、newVal为空的情况了
        if (oldVal != null && newVal != null && !oldVal.equals(newVal)) {
            //新旧值都不为空，且不想等
            return true;
        }

        //新旧值都不为空、且相当
        return false;
    }

    /**
     * 比较Integer类型数据是否有变化
     *
     * @param oldObj
     * @param newObj
     * @return
     */
    public static boolean checkChangedInteger(Object oldObj, Object newObj) {
        Integer oldVal = null;
        Integer newVal = null;
        if (oldObj != null) {
            oldVal = CastUtil.toInteger(oldObj);
        }
        if (newObj != null) {
            newVal = CastUtil.toInteger(newObj);
        }

        //做空判断，防止反编译时默认调用Obj.value等做比较出现NullPointerException异常

        if (oldVal == null && newVal == null) {
            //新旧值都为空，那么没有变化
            return false;
        }

        //以下，最多只可能有一个为空
        if (oldVal == null && newVal != null) {
            //旧值为空，新值不为空，那么有变化
            return true;
        }
        if (oldVal != null && newVal == null) {
            //旧值不为空，新值为空，那么有变化
            return true;
        }

        //以下理论上来说已经不可能出现oldVal、newVal为空的情况了
        if (oldVal != null && newVal != null && !oldVal.equals(newVal)) {
            //新旧值都不为空，且不想等
            return true;
        }

        //新旧值都不为空、且相当
        return false;
    }

    /**
     * 比较Date类型数据是否有变化
     *
     * @param oldObj
     * @param newObj
     * @return
     */
    public static boolean checkChangedDate(Object oldObj, Object newObj) {
        Date oldVal = null;
        Date newVal = null;
        if (oldObj != null) {
            oldVal = oldObj instanceof Date ? (Date) oldObj : CastUtil.toDate(oldObj);
            // oldVal = CastUtil.toDate(oldObj);
        }
        if (newObj != null) {
            newVal = newObj instanceof Date ? (Date) newObj : CastUtil.toDate(newObj);
            //  newVal = CastUtil.toDate(newObj);
        }

        //做空判断，防止反编译时默认调用Obj.value等做比较出现NullPointerException异常

        if (oldVal == null && newVal == null) {
            //新旧值都为空，那么没有变化
            return false;
        }

        //以下，最多只可能有一个为空
        if (oldVal == null && newVal != null) {
            //旧值为空，新值不为空，那么有变化
            return true;
        }
        if (oldVal != null && newVal == null) {
            //旧值不为空，新值为空，那么有变化
            return true;
        }

        //以下理论上来说已经不可能出现oldVal、newVal为空的情况了
        if (oldVal != null && newVal != null && !(oldVal.getTime() == newVal.getTime())) {
            //新旧值都不为空，且不想等
            return true;
        }

        //新旧值都不为空、且相当
        return false;
    }


}
