package com.example.utils.file.config;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.nstc.common.core.util.FrameworkUtil;
import com.nstc.common.entity.core.Profile;
import com.nstc.common.utils.string.StringUtil;
import com.nstc.core.constant.RestResponsePage;
import com.nstc.core.entity.scope.NsClientScope;
import com.nstc.core.entity.view.NsclientView;
import com.nstc.lms.entity.view.LmsContractViewOf001;
import com.nstc.lms.entity.view.LmsContractViewOf002;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;

import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Slf4j
public class LmsCommonUtil {

    /**
     * 日志工具
     */
    //   private static final Logger logger = LogManager.getLogger(CommonUtil.class);

    /* yyyy-MM-dd格式的日期 */
    //public SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    /**
     * 获取当前登录用户名
     *
     * @param tempStaffNo
     * @return
     */
    public static String getStaffNo(String tempStaffNo) {
        String staffNo = null;
        Profile profile = LmsCommonUtil.getProfile();
        if (profile != null) {
            staffNo = profile.getUserNo();
        }
        if (StringUtils.isBlank(staffNo)) {
            //如果未从登录信息获取到的情况下，返回传入的数据。多用于指定默认值
            staffNo = tempStaffNo;
        }
        return staffNo;
    }

    /**
     * 获取当前登录单位名称
     *
     * @param tempUnitNo
     * @return
     */
    public static String getUnitNo(String tempUnitNo) {
        String unitNo = null;
        Profile profile = LmsCommonUtil.getProfile();
        if (profile != null) {
            unitNo = profile.getCustNo();
        }
        if (StringUtils.isBlank(unitNo)) {
            //如果未从登录信息获取到的情况下，返回传入的数据。多用于指定默认值
            unitNo = tempUnitNo;
        }
        return unitNo;
    }

    /**
     * 获取当前登录Profile信息
     *
     * @return
     */
    public static Profile getProfile() {
        Profile profile = null;
        try {
            profile = FrameworkUtil.getProfile();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return profile;
    }


    public static String getUuid() {
        return UUID.randomUUID().toString();
    }

    public static String getUnitName(String tempUnitName) {
        String unitName = null;
        Profile profile = getProfile();
        if (profile != null) {
            unitName = profile.getCustNo();
        }

        if (StringUtils.isBlank(unitName)) {
            unitName = tempUnitName;
        }

        return unitName;
    }

    public static String getStaffName(String tempStaffName) {
        String staffName = null;
        Profile profile = getProfile();
        if (profile != null) {
            staffName = profile.getUserName();
        }

        if (StringUtils.isBlank(staffName)) {
            staffName = tempStaffName;
        }

        return staffName;
    }

    /**
     * 返回yyyy-MM-dd格式的日期（未正常格式化的情况下返回原来的时间）
     *
     * @param date
     * @return
     */
    public static Date transDate(Date date) {
        if (date != null) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                String dateStr = sdf.format(date);
                return sdf.parse(dateStr);
            } catch (Exception e) {
                log.error("----------LMS.CommonUtil.transDate异常----------");
                e.printStackTrace();
            }
        }
        //未正常格式化的情况下返回原来的时间
        return date;
    }

    /**
     * 返回yyyy-MM-dd格式的字符串（未正常格式化的情况下返回原来的时间）
     *
     * @param date
     * @return
     */
    public static String formatDate(Date date) {
        String dateStr = null;
        if (date != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            dateStr = sdf.format(date);
        }
        return dateStr;
    }

    public static void main(String[] args) {
//        System.out.println(transDate(new Date()));
        String str = "123456789";
        System.out.println(str.substring(1, str.length()));
    }

    /**
     * 如果参数为空那么初始化为0
     *
     * @param amount
     * @return
     */
    public static BigDecimal initZeroIfNessary(BigDecimal amount) {
        if (amount == null) {
            amount = BigDecimal.valueOf(0);
        }
        return amount;
    }

    /**
     * 如果参数为空那么初始化为0
     *
     * @param amount
     * @return
     */
    public static BigDecimal initOneIfNessary(BigDecimal amount) {
        if (amount == null) {
            amount = BigDecimal.valueOf(1);
        }
        return amount;
    }

    /**
     * 如果参数为空那么初始化为0
     *
     * @param val
     * @return
     */
    public static Long initZeroIfNessary(Long val) {
        if (val == null) {
            val = 0L;
        }
        return val;
    }

    /**
     * 校验2个字符串是否相等（都为空包括空串和空对象，认为相等）
     *
     * @param a
     * @param b
     * @return
     */
    public static boolean checkStringEqual(String a, String b) {
        if (StringUtil.isBlank(a) && StringUtil.isBlank(b)) {
            //都没有值
            return true;
        }
        if (StringUtil.isBlank(a) && !StringUtil.isBlank(b)) {
            //其中一个为空，另一个不为空那么不相等
            return false;
        }

        if (!StringUtil.isBlank(a) && StringUtil.isBlank(b)) {
            //其中一个为空，另一个不为空那么不相等
            return false;
        }

        //都不为空
        return a.equals(b);
    }

    /**
     * 判断集合不为null且不为空集合
     *
     * @param collection
     * @return
     */
    public static boolean isNotEmpty(Collection collection) {
        return collection != null && !collection.isEmpty();
    }

    /**
     * 判断集合为null或为空集合
     *
     * @param collection
     * @return
     */
    public static boolean isEmpty(Collection collection) {
        return !isNotEmpty(collection);
    }


    /**
     * @description 判断对象中属性值是否全为空
     * @author fbb
     * @param: object
     * @return: boolean
     */
    public static boolean checkObjAllFieldsIsNull(Object object) {
        if (null == object) {
            return true;
        }
        try {
            for (Field f : object.getClass().getDeclaredFields()) {
                f.setAccessible(true);
                if ("serialVersionUID".equals(f.getName())) continue;//实体默认存在serialVersionUID，要排除
//                System.out.println(f.getName()+":");
//                System.out.println(f.get(object));
                if (f.get(object) != null && StringUtils.isNotBlank(f.get(object).toString())) {
                    return false;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return true;
    }


    /**
     * 2个时间相差的天数（只管年月日）
     *
     * @param date1 late
     * @param date2 early
     * @return
     */
    public static Integer diffDays(Date date1, Date date2) {
        if (date1 == null || date2 == null) {
            return null;
        }
        date1 = LmsCommonUtil.transDate(date1);
        date2 = LmsCommonUtil.transDate(date2);

        return (int) ((date1.getTime() - date2.getTime()) / (1000 * 3600 * 24));
    }

    /**
     * 校验字段是否为空，如果为空给出抛出提示信息
     *
     * @param o
     * @param s
     */
    public static void checkNull(Object o, String s) {
        if (o == null) {
            throw new RuntimeException(s);
        }
    }


    public static String getUnitNameByCltno(String cltNo) {
        if (StringUtil.isEmpty(cltNo)) {
            return null;
        }
        NsClientScope scope = new NsClientScope();
        scope.setUnitNo(cltNo);
        NsclientView unit = LmsSpringContextUtil.getServiceLocator().getLmsMainDataService().getOneUnit(scope);
        return unit == null ? null : unit.getUnitName();
    }

    /**
     * 分页结果从Page拷贝到RestResponsePage中去
     * @param responsePage
     * @param pageView
     * @return
     */
    public static RestResponsePage copyPage(RestResponsePage responsePage, Page pageView) {
        if (responsePage != null && pageView != null) {
            Integer page = 0;
            Integer limit = 0;
            Integer total = 0;
            int size = 0;
            //分页大小，每页显示多少条
            Long pageSize = pageView.getSize();
            if (pageSize != null) {
                size = Integer.parseInt(pageSize + "");
            }
            //总页数
            Long pages = pageView.getPages();
            if (pages != null) {
                limit = Integer.parseInt(pages + "");
            }
            //总条数
            Long pageTotal = pageView.getTotal();
            if (pageTotal != null) {
                total = Integer.parseInt(pageTotal + "");
            }
            //当前页
            Long pageCurrent = pageView.getCurrent();
            if (pageCurrent != null) {
                page = Integer.parseInt(pageCurrent + "");
            }

            responsePage.setTotal(total);
            responsePage.setPage(page);
            responsePage.setSize(size);
            responsePage.setLimit(limit);
        }
        return responsePage;
    }

    /**
     * 分页结果从Page拷贝到LmsContractViewOf001中去
     * @param responsePage
     * @param pageView
     * @return
     */
    public static LmsContractViewOf001 copyPage(LmsContractViewOf001 responsePage, Page pageView) {
        if (responsePage != null && pageView != null) {
            Integer page = 0;
            Integer limit = 0;
            Integer total = 0;
            int size = 0;
            //分页大小，每页显示多少条
            Long pageSize = pageView.getSize();
            if (pageSize != null) {
                size = Integer.parseInt(pageSize + "");
            }
            //总页数
            Long pages = pageView.getPages();
            if (pages != null) {
                limit = Integer.parseInt(pages + "");
            }
            //总条数
            Long pageTotal = pageView.getTotal();
            if (pageTotal != null) {
                total = Integer.parseInt(pageTotal + "");
            }
            //当前页
            Long pageCurrent = pageView.getCurrent();
            if (pageCurrent != null) {
                page = Integer.parseInt(pageCurrent + "");
            }

            responsePage.setTotal(total);
            responsePage.setPage(page);
            responsePage.setSize(size);
            responsePage.setLimit(limit);
        }
        return responsePage;
    }

    /**
     * 分页结果从Page拷贝到LmsContractViewOf001中去
     * @param responsePage
     * @param pageView
     * @return
     */
    public static LmsContractViewOf002 copyPage(LmsContractViewOf002 responsePage, Page pageView) {
        if (responsePage != null && pageView != null) {
            Integer page = 0;
            Integer limit = 0;
            Integer total = 0;
            int size = 0;
            //分页大小，每页显示多少条
            Long pageSize = pageView.getSize();
            if (pageSize != null) {
                size = Integer.parseInt(pageSize + "");
            }
            //总页数
            Long pages = pageView.getPages();
            if (pages != null) {
                limit = Integer.parseInt(pages + "");
            }
            //总条数
            Long pageTotal = pageView.getTotal();
            if (pageTotal != null) {
                total = Integer.parseInt(pageTotal + "");
            }
            //当前页
            Long pageCurrent = pageView.getCurrent();
            if (pageCurrent != null) {
                page = Integer.parseInt(pageCurrent + "");
            }

            responsePage.setTotal(total);
            responsePage.setPage(page);
            responsePage.setSize(size);
            responsePage.setLimit(limit);
        }
        return responsePage;
    }

    // 还本付息计划-生成计划编号6位随机数
    public static String getPlanNo6(String type) {
        return type + (int) (Math.random() * 1000000);
    }

    // 自定义分页
    public static <E extends Object> RestResponsePage<List<E>> getStreamList(Page page, List<E> list) {
        int size = list.size();

        list = getStreamListByPage(page, list);
        RestResponsePage<List<E>> responsePage = RestResponsePage.success(list);

        responsePage.setTotal(size);
        responsePage.setPage((int) page.getCurrent());
        responsePage.setSize((int) page.getSize());
        return responsePage;
    }

    // 数据量较少时 使用stream的分页设置
    public static <E extends Object> List<E> getStreamListByPage(Page page, List<E> list) {
        //当前页码
        int current = (int) page.getCurrent();
        //每页条数
        int size = (int) page.getSize();

        //忽略上一页，如果是第一页肯定不用忽略
        int skipnum = size * (current - 1);
        list = list.stream().skip(skipnum).limit(size).collect(Collectors.toList());

        return list;
    }

}
