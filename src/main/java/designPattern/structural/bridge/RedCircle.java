package designPattern.structural.bridge;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/24 15:50
 */

public class RedCircle implements DrawAPI {
    @Override
    public void drawCircle(int radius, int x, int y) {
        System.out.println("Drawing Circle[ color: red, radius: "
                + radius +", x: " +x+", "+ y +"]");
    }

}
