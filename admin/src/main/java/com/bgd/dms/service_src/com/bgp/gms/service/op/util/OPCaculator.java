package com.bgp.gms.service.op.util;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Stack;

/*
 *测试 -5*(10/(2*4.5-4)+(-3/1.5+4)*(-2))/(-2/1-(-1))+12=2.0
 */
public class OPCaculator {
	// 求四则运算表达式运算结果
	public static double excute(String value) throws Exception {
		List<String> list = toList(value);// 按顺序转成数字符号list 即中序表达式
		list = toSuffixExpressionList(list);// 转成逆波兰式数字符号list 即后序表达式
		double result = suffix_excute(list);// 求逆波兰式结果
		return result;
	}

	// 表达式划分成中序list 即从左到右数字符号分开
	private static List<String> toList(String value) {
		// 开始为-时加上0
		if ("-".equals(value.substring(0, 1))) {
			value = "0" + value;
		}
		int begin = 0;
		int end = 0;
		String item;
		List<String> resultList = new ArrayList<String>();
		for (int i = 0, len = value.length(); i < len; i++) {
			item = value.substring(i, i + 1);
			if (isOperator(item)) {
				// 负数跳过
				if ("-".equals(item) && "(".equals(value.substring(i - 1, i))) {
					continue;
				}
				end = i;
				// 前一个非符号时加上数字
				if (begin != end) {
					resultList.add(value.substring(begin, end));
				}
				// 加上符号
				resultList.add(value.substring(end, end + 1));
				begin = end + 1;
			}
		}
		// 加上最后一个数字
		if (begin != value.length()) {
			resultList.add(value.substring(begin));
		}
		// System.out.println(value + "=" + list);
		return resultList;
	}

	// 中序list转换成逆波兰式list 左右根
	private static List<String> toSuffixExpressionList(List<String> list) throws Exception {
		Stack<String> operatorStack = new Stack<String>();// 符号栈
		Stack<String> resultStack = new Stack<String>();// 结果栈
		Iterator<String> iter = list.iterator();
		while (iter.hasNext()) {
			String item = iter.next();
			if (isOperator(item)) {
				if (")".equals(item)) {
					// 遇到)时符号栈一直弹出并压入结果栈直到遇到(，弹出(废弃，结束。
					while (!(operatorStack.isEmpty() || "(".equals(operatorStack.peek()))) {
						resultStack.push(operatorStack.pop());
					}
					// 弹出(
					if (!operatorStack.isEmpty() && "(".equals(operatorStack.peek())) {
						operatorStack.pop();
					} else {
						throw new Exception("(少了");
					}
				} else if ("(".equals(item)) {
					// 遇到(时直接入符号栈，结束
					operatorStack.push(item);
				} else {
					// 遇到其他运算符时与符号栈顶（若符号栈顶为空或(时直接入符号栈，结束）运算比较 若比栈顶高直接入符号栈，结束
					// 否则符号栈弹出并压入结果栈 并再执行与符号栈顶比较直到弹入符号栈，结束
					while (!(operatorStack.isEmpty() || "(".equals(operatorStack.peek()))) {
						if (compareOperator(item, operatorStack.peek()) < 1) {
							resultStack.push(operatorStack.pop());
						} else {
							break;
						}
					}
					operatorStack.push(item);
				}

			} else {
				// 数字时直接入结果栈
				resultStack.push(item);
			}
		}
		// 符号栈全部弹出并压入结果栈
		while (!operatorStack.isEmpty()) {
			if ("(".equals(operatorStack.peek())) {
				throw new Exception("(多了");
			}
			resultStack.push(operatorStack.pop());
		}
		// 结果栈弹出并反序得出最终结果
		iter = resultStack.iterator();
		List<String> resultList = new ArrayList<String>();
		while (iter.hasNext()) {
			resultList.add(iter.next());
		}
		// System.out.println(list + "=" + rtList);
		return resultList;
	}

	// 逆波兰式list 求值
	// 从左至右扫描表达式，遇到数字时，将数字压入堆栈，遇到运算符时，弹出栈顶的两个数，用运算符对它们做相应的计算（次顶元素 op
	// 栈顶元素），并将结果入栈；重复上述过程直到表达式最右端，最后运算得出的值即为表达式的结果。
	private static double suffix_excute(List<String> list) {
		Stack<Double> resultStack = new Stack<Double>();
		Iterator<String> iter = list.iterator();
		Double num1;
		Double num2;
		while (iter.hasNext()) {
			String item = iter.next();
			if (isOperator(item)) {
				num2 = resultStack.pop();
				num1 = resultStack.pop();
				resultStack.push(doOperator(num1, num2, item));
			} else {
				resultStack.push(Double.parseDouble(item));
			}
		}
		return resultStack.pop();
	}

	// 比较两运算高低 1 1>2, 0 1=2 -1 1<2
	private static int compareOperator(String operator1, String operator2) {
		if ("*".equals(operator1) || "/".equals(operator1)) {
			return ("-".equals(operator2) || "+".equals(operator2)) ? 1 : 0;
		} else if ("-".equals(operator1) || "+".equals(operator1)) {
			return ("*".equals(operator2) || "/".equals(operator2)) ? -1 : 0;
		}
		// 这个到不了
		return 1;
	}

	// +-*/基本运算
	private static double doOperator(Double num1, Double num2, String operator) {
		if ("+".equals(operator)) {
			return num1 + num2;
		} else if ("-".equals(operator)) {
			return num1 - num2;
		} else if ("*".equals(operator)) {
			return num1 * num2;
		} else if ("/".equals(operator)) {
			if(num2==0) return 0;
			return num1 / num2;
		}
		// 这个到不了
		return -1;
	}

	// 是否为运算符
	private static Boolean isOperator(String value) {
		return "(".equals(value) || ")".equals(value) || "+".equals(value) || "-".equals(value) || "*".equals(value) || "/".equals(value);
	}

	public static void main(String[] args) {
		try {
			excute("-5*(10/(2*4.5-4)+(-3/1.5+4)*(-2))/(-2/1-(-1))+12");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
