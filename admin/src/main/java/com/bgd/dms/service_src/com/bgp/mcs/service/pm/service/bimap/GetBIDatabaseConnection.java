package com.bgp.mcs.service.pm.service.bimap;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class GetBIDatabaseConnection {
	
	//����
	private static final String DRIVER = "oracle.jdbc.driver.OracleDriver";
	//��ʽ���� �����ַ���
	private static String URL = "jdbc:oracle:thin:@10.88.248.131:1521:dssdb";
	//��ʽ���� ���ݿ���ʺź�����
	private static final String DBUSER = "data";
	private static final String DBPWD = "BGPdata";
	
	//���Ի��� �����ַ���
	private static String URL_TRAIN = "jdbc:oracle:thin:@10.88.248.133:1521:dssdb";
	//���Ի��� ���ݿ���ʺź�����
	private static final String DBUSER_TRAIN = "data";
	private static final String DBPWD_TRAIN = "BGPdata";
	
	/**
	 * ��ȡjdbc����
	 * @return
	 */
	public static Connection getConnection(String databaseFlag) {

		Connection conn = null;
		try {
			if("synMapInfoGMStoBI".equals(databaseFlag) || "synMapInfoGMStoBI" == databaseFlag){
				Class.forName(DRIVER);
				conn = DriverManager.getConnection(URL, DBUSER, DBPWD);
				conn.setAutoCommit(false);
			}else if("synMapInfoGMStoBITrain".equals(databaseFlag) || "synMapInfoGMStoBITrain" == databaseFlag){
				Class.forName(DRIVER);
				conn = DriverManager.getConnection(URL_TRAIN, DBUSER_TRAIN, DBPWD_TRAIN);
				conn.setAutoCommit(false);
			}
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return conn;
	}
	/**
	 * �ر�ResultSet
	 * @param rs
	 */
	public static void closeResultSet(ResultSet rs) {
		if (rs != null) {
			try {
				rs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	/**
	 * �ر�Statement
	 * @param stmt
	 */
	public static void closeStatement(Statement stmt) {
		if (stmt != null) {
			try {
				stmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	/**
	 * �ر�Connection
	 * @param conn
	 */
	public static void closeConnection(Connection conn) {
		if (conn != null) {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
}
