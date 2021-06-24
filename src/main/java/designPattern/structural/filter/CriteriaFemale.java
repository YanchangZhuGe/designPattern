package designPattern.structural.filter;

import java.util.ArrayList;
import java.util.List;

/**
 * 描述:创建实现了 Criteria 接口的实体类。
 *
 * @author WuYanchang
 * @date 2021/6/24 15:58
 */

public class CriteriaFemale implements Criteria {

    @Override
    public List<Person> meetCriteria(List<Person> persons) {
        List<Person> femalePersons = new ArrayList<Person>();
        for (Person person : persons) {
            if (person.getGender().equalsIgnoreCase("FEMALE")) {
                femalePersons.add(person);
            }
        }
        return femalePersons;
    }

}
