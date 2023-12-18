package com.example.utils.file.config;
import com.nstc.lms.service.LmsServiceLocator;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author wk
 * @since 2020/1/13 17:44
 */
@Component
public class LmsSpringContextUtil implements ApplicationContextAware {

    private static ApplicationContext context = null;

    private static final String SERVICE_LOCATOR_BEAN_NAME = "com.nstc.lms.service.LmsServiceLocator";

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        context = applicationContext;
    }

    /**
     * 获取服务门户类
     * @return 服务门户类
     */
    public static LmsServiceLocator getServiceLocator() {
        if (context == null) {
            return null;
        }
        return (LmsServiceLocator) context.getBean(SERVICE_LOCATOR_BEAN_NAME);
    }
}
