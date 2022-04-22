package designPattern.other.test.sum;

/**
 * 描述:递归方法求
 *
 * @author WuYanchang
 * @date 2021/8/3 15:26
 */

public class test22 {
    public static void main(String[] args) {
        System.out.println(fac(5));
    }

    public static int fac(int i) {
        if (i == 1) {
            return 1;
        } else {
            return i * fac(i - 1);
        }
    }
}
