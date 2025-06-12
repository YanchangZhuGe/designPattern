package com.bgp.mcs.service.common.excelIE.util;

public class ExcelExceptionHandler extends Exception {

	/**
	 * 标题：东方地球物理公司物探生产管理系统
	 * 
	 * 公司: 中油瑞飞
	 * 
	 * 作者：邱庆豹
	 * 
	 * 描述：excel导入导出通用自定义异常类
	 */
	private static final long serialVersionUID = 1733724984787093986L;

	/**
	 * This field holds the exception ex if the ExcelExceptionHandler(String s,
	 * Throwable ex) constructor was used to instantiate the object
	 * 
	 * @serial
	 * @since 1.2
	 */
	private Throwable ex;

	/**
	 * Constructs a <code>ExcelExceptionHandler</code> with no detail message.
	 */
	public ExcelExceptionHandler() {
		super((Throwable) null); // Disallow initCause
	}

	/**
	 * Constructs a <code>ExcelExceptionHandler</code> with the specified
	 * detail message.
	 * 
	 * @param s
	 *            the detail message.
	 */
	public ExcelExceptionHandler(String s) {
		super(s, null); // Disallow initCause
	}

	/**
	 * Constructs a <code>ExcelExceptionHandler</code> with the specified
	 * detail message and optional exception that was raised while loading the
	 * class.
	 * 
	 * @param s
	 *            the detail message
	 * @param ex
	 *            the exception that was raised while loading the class
	 * @since 1.2
	 */
	public ExcelExceptionHandler(String s, Throwable ex) {
		super(s, null); // Disallow initCause
		this.ex = ex;
	}

	/**
	 * Returns the exception that was raised if an error occurred while
	 * attempting to load the class. Otherwise, returns <tt>null</tt>.
	 * 
	 * <p>
	 * This method predates the general-purpose exception chaining facility. The
	 * {@link Throwable#getCause()} method is now the preferred means of
	 * obtaining this information.
	 * 
	 * @return the <code>Exception</code> that was raised while loading a class
	 * @since 1.2
	 */
	public Throwable getException() {
		return ex;
	}

	/**
	 * Returns the cause of this exception (the exception that was raised if an
	 * error occurred while attempting to load the class; otherwise
	 * <tt>null</tt>).
	 * 
	 * @return the cause of this exception.
	 * @since 1.4
	 */
	public Throwable getCause() {
		return ex;
	}

}
