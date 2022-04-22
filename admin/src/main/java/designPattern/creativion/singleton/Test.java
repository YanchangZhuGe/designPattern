package designPattern.creativion.singleton;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/5/17 10:05
 */

public class Test {
    public static void main(String[] args) {

        //不合法的构造函数
        //编译时错误：构造函数 SingleObject() 是不可见的
        //SingleObject object = new SingleObject();

        //获取唯一可用的对象
        SingleObject object = SingleObject.getInstance();

        //显示消息
        object.showMessage();
    }

}
