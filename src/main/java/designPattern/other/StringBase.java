package designPattern.other;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/23 16:06
 */
public class StringBase {

    public static void main(String[] args) {
        int c = 66; //c 叫做实参
        String d = "hello"; //d 叫做实参

        StringBase stringBase = new StringBase();
        stringBase.test5(c, d); // 此处 c 与 d 叫做实参

        System.out.println("c的值是：" + c + " --- d的值是：" + d);
    }

    public void test5(int a, String b) { // a 与 b 叫做形参
        a = 55;
        b = "no";
    }
}

class sushu {
    public static void main(String[] args) {

        for (int i = 100000; i < 1000000000; i++) {
            if (i % 2 == 0) {
                for (int j = 1; j < i; j++) {
                    if (isPrimeNormal(j)) {
                        int k = i - j;
                        if (isPrimeNormal(k)) {
                            System.out.println(i + " = " + j + " + " + k + " ;");
                            break;
                        }
                    }
                }
            }
        }
    }

    public static boolean isPrimeNormal(int num) {
        for (int i = 2; i < num; i++) {
            if (num % i == 0) {
                return false;
            }
        }

        return true;
    }
}
