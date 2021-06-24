package designPattern.structural.bridge;

/**
 * 描述:创建实现了 DrawAPI 接口的实体桥接实现类
 *
 * @author WuYanchang
 * @date 2021/6/24 15:50
 */

public class GreenCircle implements DrawAPI {
    @Override
    public void drawCircle(int radius, int x, int y) {
        System.out.println("Drawing Circle[ color: green, radius: "
                + radius + ", x: " + x + ", " + y + "]");
    }

}
