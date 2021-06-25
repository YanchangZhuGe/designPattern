package designPattern.behavior.iterator;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/25 9:40
 */

public class Test {

    public static void main(String[] args) {
        NameRepository namesRepository = new NameRepository();

        for(Iterator iter = namesRepository.getIterator(); iter.hasNext();){
            String name = (String)iter.next();
            System.out.println("Name : " + name);
        }
    }
}
