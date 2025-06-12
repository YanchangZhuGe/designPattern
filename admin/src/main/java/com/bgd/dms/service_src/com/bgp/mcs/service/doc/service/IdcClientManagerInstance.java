package com.bgp.mcs.service.doc.service;

import oracle.stellent.ridc.IdcClientManager;

public class IdcClientManagerInstance {
	static final IdcClientManager idcClientManager=new IdcClientManager();
	public static IdcClientManager getInstance(){
		return idcClientManager;
	}
}
