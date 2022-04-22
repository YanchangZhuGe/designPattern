package designPattern.other.test.sum;

/**
 * 描述:和
 *
 * @author WuYanchang
 * @date 2021/8/3 15:25
 */

public class test21 {
    public static void main(String[] args) {
        long sum = 0, ver = 1;
        for (int i = 1; i <= 20; i++) {
            ver = ver * i;
            sum += ver;
        }
        System.out.println(sum);
    }
}
