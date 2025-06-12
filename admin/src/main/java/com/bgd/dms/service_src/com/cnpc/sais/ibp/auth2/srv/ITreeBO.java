package com.cnpc.sais.ibp.auth2.srv;

import java.util.List;

import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.sais.ibp.auth2.pojo.TreeNode;


public interface ITreeBO {
	List<TreeNode> getTreeData(ISrvMsg reqDTO) throws Exception;
	void saveTreeData(ISrvMsg reqDTO) throws Exception;
}
