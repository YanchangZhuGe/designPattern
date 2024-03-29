package designPattern.structural.filter;

import java.util.List;

/**
 * 描述:为标准（Criteria）创建一个接口。
 *
 * @author WuYanchang
 * @date 2021/6/24 15:57
 */
public interface Criteria {
    public List<Person> meetCriteria(List<Person> persons);
}
