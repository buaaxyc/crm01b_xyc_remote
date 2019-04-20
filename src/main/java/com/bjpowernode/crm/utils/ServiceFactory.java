package com.bjpowernode.crm.utils;

import java.util.ArrayList;

public class ServiceFactory {
	
	public static Object getService(Object service){

		return new TransactionInvocationHandler(service).getProxy();
		
	}
	
}
