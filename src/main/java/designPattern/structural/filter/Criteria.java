package designPattern.structural.filter;

import java.util.List;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/24 15:57
 */
public interface Criteria {
 public List<Person> meetCriteria(List<Person> persons);
}
