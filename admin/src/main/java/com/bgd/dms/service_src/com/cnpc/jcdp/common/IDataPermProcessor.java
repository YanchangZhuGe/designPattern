/**
 * 数据权限处理接口
 */
package com.cnpc.jcdp.common;

/**
 * @author rechete
 *
 */
public interface IDataPermProcessor {
	public DataPermission getDataPermission(UserToken user,String funcCode,String sql); 
	
	public DataPermission getDataPermission_WT(UserToken user,String funcCode,String sql); 
}
