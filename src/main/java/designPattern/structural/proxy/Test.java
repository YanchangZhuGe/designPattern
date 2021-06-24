package designPattern.structural.proxy;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/24 20:51
 */

public class Test {
    public static void main(String[] args) {
        Image image = new ProxyImage("test_10mb.jpg");

        // 图像将从磁盘加载
        image.display();
        System.out.println("");
        // 图像不需要从磁盘加载
        image.display();
    }

}
