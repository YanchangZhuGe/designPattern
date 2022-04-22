package designPattern.behavior.iterator;

/**
 * 描述:创建实现了 Container 接口的实体类。该类有实现了 Iterator 接口的内部类 NameIterator。
 *
 * @author WuYanchang
 * @date 2021/6/25 9:39
 */

public class NameRepository implements Container {
    public String[] names = {"Robert", "John", "Julie", "Lora"};

    @Override
    public Iterator getIterator() {
        return new NameIterator();
    }

    private class NameIterator implements Iterator {

        int index;

        @Override
        public boolean hasNext() {
            if (index < names.length) {
                return true;
            }
            return false;
        }

        @Override
        public Object next() {
            if (this.hasNext()) {
                return names[index++];
            }
            return null;
        }
    }

}
