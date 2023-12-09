package com.example.utils.file.config;//package com.nstc.lms.util;
//
//import com.nstc.core.ProfileWrapper;
//
///**
// * <p>Title: 获取登录信息</p>
// * <p>Description: </p>
// * <p>Company: 北京九恒星科技股份有限公司</p>
// *
// * @author yujin
// * @since 2020/12/24 13:41
// */
//public class LmsProfileThreadLocalUtil {
//
//    private static final ThreadLocal<ProfileWrapper> threadLocal = new ThreadLocal<>();
//
//    private LmsProfileThreadLocalUtil() {
//
//    }
//
//    /**
//     * @param profile
//     * @return
//     * @Description：绑定用户到本地线程
//     * @author tangjiagang
//     * @since：2020/11/16 23:58
//     */
//    public static void bind(ProfileWrapper profile) {
//        threadLocal.set(profile);
//    }
//
//    /**
//     * @param
//     * @return profile
//     * @Description：获取本地线程中的用户信息
//     * @author tangjiagang
//     * @since：2020/11/16 23:59
//     */
//    public static ProfileWrapper getProfile() {
//        return threadLocal.get();
//    }
//
//    /**
//     * @param
//     * @return
//     * @Description：清除绑定的用户
//     * @author tangjiagang
//     * @since：2020/11/16 23:59
//     */
//    public static void remove() {
//        threadLocal.remove();
//    }
//
//}
