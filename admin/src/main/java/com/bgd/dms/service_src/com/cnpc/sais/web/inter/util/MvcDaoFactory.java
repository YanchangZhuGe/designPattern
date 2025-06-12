package com.cnpc.sais.web.inter.util;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

@SuppressWarnings("unused")
public class MvcDaoFactory {
	private static String url;
	private static String user;
	private static String pwd;
	private static String dbFile = "/";
	private static String driverClass;
	
	static {
		Properties props = new Properties();
		try {
			props.load(MvcDaoFactory.class.getClassLoader().getResourceAsStream("dbConfig.properties"));
			driverClass = props.getProperty("db.driver");
			url = props.getProperty("db.driverUrl");
			user = props.getProperty("db.user");
			pwd = props.getProperty("db.password");
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public static Connection getConnection() throws SQLException, ClassNotFoundException{
		Class.forName(driverClass);
		return DriverManager.getConnection(url, user, pwd);
	}
	
}
