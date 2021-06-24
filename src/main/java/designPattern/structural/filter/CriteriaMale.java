package designPattern.structural.filter;

import java.util.ArrayList;
import java.util.List;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/24 15:57
 */

public class CriteriaMale implements Criteria {

    @Override
    public List<Person> meetCriteria(List<Person> persons) {
        List<Person> malePersons = new ArrayList<Person>();
        for (Person person : persons) {
            if(person.getGender().equalsIgnoreCase("MALE")){
                malePersons.add(person);
            }
        }
        return malePersons;
    }

}
