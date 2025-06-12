package com.bgp.gms.service.op.util;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Stack;

/*
 *���� -5*(10/(2*4.5-4)+(-3/1.5+4)*(-2))/(-2/1-(-1))+12=2.0
 */
public class OPCaculator {
	// ������������ʽ������
	public static double excute(String value) throws Exception {
		List<String> list = toList(value);// ��˳��ת�����ַ���list ��������ʽ
		list = toSuffixExpressionList(list);// ת���沨��ʽ���ַ���list ��������ʽ
		double result = suffix_excute(list);// ���沨��ʽ���
		return result;
	}

	// ���ʽ���ֳ�����list �����������ַ��ŷֿ�
	private static List<String> toList(String value) {
		// ��ʼΪ-ʱ����0
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
				// ��������
				if ("-".equals(item) && "(".equals(value.substring(i - 1, i))) {
					continue;
				}
				end = i;
				// ǰһ���Ƿ���ʱ��������
				if (begin != end) {
					resultList.add(value.substring(begin, end));
				}
				// ���Ϸ���
				resultList.add(value.substring(end, end + 1));
				begin = end + 1;
			}
		}
		// �������һ������
		if (begin != value.length()) {
			resultList.add(value.substring(begin));
		}
		// System.out.println(value + "=" + list);
		return resultList;
	}

	// ����listת�����沨��ʽlist ���Ҹ�
	private static List<String> toSuffixExpressionList(List<String> list) throws Exception {
		Stack<String> operatorStack = new Stack<String>();// ����ջ
		Stack<String> resultStack = new Stack<String>();// ���ջ
		Iterator<String> iter = list.iterator();
		while (iter.hasNext()) {
			String item = iter.next();
			if (isOperator(item)) {
				if (")".equals(item)) {
					// ����)ʱ����ջһֱ������ѹ����ջֱ������(������(������������
					while (!(operatorStack.isEmpty() || "(".equals(operatorStack.peek()))) {
						resultStack.push(operatorStack.pop());
					}
					// ����(
					if (!operatorStack.isEmpty() && "(".equals(operatorStack.peek())) {
						operatorStack.pop();
					} else {
						throw new Exception("(����");
					}
				} else if ("(".equals(item)) {
					// ����(ʱֱ�������ջ������
					operatorStack.push(item);
				} else {
					// �������������ʱ�����ջ����������ջ��Ϊ�ջ�(ʱֱ�������ջ������������Ƚ� ����ջ����ֱ�������ջ������
					// �������ջ������ѹ����ջ ����ִ�������ջ���Ƚ�ֱ���������ջ������
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
				// ����ʱֱ������ջ
				resultStack.push(item);
			}
		}
		// ����ջȫ��������ѹ����ջ
		while (!operatorStack.isEmpty()) {
			if ("(".equals(operatorStack.peek())) {
				throw new Exception("(����");
			}
			resultStack.push(operatorStack.pop());
		}
		// ���ջ����������ó����ս��
		iter = resultStack.iterator();
		List<String> resultList = new ArrayList<String>();
		while (iter.hasNext()) {
			resultList.add(iter.next());
		}
		// System.out.println(list + "=" + rtList);
		return resultList;
	}

	// �沨��ʽlist ��ֵ
	// ��������ɨ����ʽ����������ʱ��������ѹ���ջ�����������ʱ������ջ�����������������������������Ӧ�ļ��㣨�ζ�Ԫ�� op
	// ջ��Ԫ�أ������������ջ���ظ���������ֱ�����ʽ���Ҷˣ��������ó���ֵ��Ϊ���ʽ�Ľ����
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

	// �Ƚ�������ߵ� 1 1>2, 0 1=2 -1 1<2
	private static int compareOperator(String operator1, String operator2) {
		if ("*".equals(operator1) || "/".equals(operator1)) {
			return ("-".equals(operator2) || "+".equals(operator2)) ? 1 : 0;
		} else if ("-".equals(operator1) || "+".equals(operator1)) {
			return ("*".equals(operator2) || "/".equals(operator2)) ? -1 : 0;
		}
		// ���������
		return 1;
	}

	// +-*/��������
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
		// ���������
		return -1;
	}

	// �Ƿ�Ϊ�����
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
