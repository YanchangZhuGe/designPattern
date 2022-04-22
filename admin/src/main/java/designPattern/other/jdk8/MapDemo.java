package designPattern.other.jdk8;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/7/9 15:54
 */

public class MapDemo {
    public static void main(String[] args) {
        //创建Map对象
        Map<String, String> map = new HashMap<String, String>();

        //V put(K key, V value) ：就是将key映射到value，如果key存在，则覆盖value，并将原来的value返回
        System.out.println(map.put("ITCAST001", "张三"));
        System.out.println(map.put("ITCAST002", "李四"));
        System.out.println(map.put("ITCAST001", "王五"));

        //void clear() : 清空所有的对应关系
        //map.clear();

        //V remove(Object key) :根据指定的key删除对应关系，并返回key所对应的值，如果没有删除成功则返回null
        System.out.println(map.remove("ITCAST005"));

        //boolean containsKey(Object key) : 判断指定key是否存在
        System.out.println(map.containsKey("ITCAST003"));

        //boolean containsValue(Object value)：判断指定的value是否存在
        System.out.println(map.containsValue("王五"));

        //boolean isEmpty() : 判断是否有对应关系
        System.out.println(map.isEmpty());

        //int size() : 返回对应关系的个数
        System.out.println(map.size());

        //V get(Object key) : 根据指定的key返回对应的value
        System.out.println(map.get("ITCAST002"));

        System.out.println(map);

        //创建Map对象
        Map<String, String> map1 = new HashMap<String, String>();
        //添加映射关系
        map1.put("ITCAST001", "张三");
        map1.put("ITCAST002", "李四");
        map1.put("ITCAST005", "李四");

        //Set<K> keySet() : 以Set的形式获返回所有的key
        Set<String> keys = map1.keySet();
        for (String key : keys) {
            System.out.println(key);
        }
        System.out.println("-----------");

        //Collection<V> values() :
        Collection<String> values = map1.values();
        for (String value : values) {
            System.out.println(value);
        }
    }

}
