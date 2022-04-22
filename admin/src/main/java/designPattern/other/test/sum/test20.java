package designPattern.other.test.sum;

/**
 * 描述:分数序列
 *
 * @author WuYanchang
 * @date 2021/8/3 15:22
 */

public class test20 {
    public static void main(String[] args) {
        double sum = 0, ver = 2;
        for (int i = 1; i <= 10; i++) {
            sum += ver / i;
            ver += i;
        }
        System.out.println(sum);
    }
}
