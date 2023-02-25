package com.training.service;

import java.util.List;
import java.util.Set;

import com.training.dao.BackendDao;
import com.training.model.Goods;
import com.training.model.GoodsSearch;
import com.training.vo.SalesReport;

public class BackendService {
	private static BackendService backendService = new BackendService();
	private BackendService(){}
	public static BackendService getInstance()
	{
		return backendService;
	}
	
	private BackendDao backendDao = BackendDao.getInstance();
	
	public  List<Goods> queryGoods(){
		return backendDao.queryGoods();
	}
	
	public  Goods queryGoodsByID(int id){
		return backendDao.queryGoodsByID(id);
	}
	
	public  List<Goods> searchGoods(GoodsSearch search){
		return backendDao.searchGoods(search);
	}
	
	public  int createGoods(Goods goods){
		return backendDao.createGoods(goods);
	}
	
	public  boolean updateGoods(Goods goods){
		return backendDao.updateGoods(goods);
	}
	
	public Set<SalesReport> queryOrderBetweenDate(String queryStartDate, String queryEndDate){
		return backendDao.queryOrderBetweenDate(queryStartDate, queryEndDate);
	}
}
