package com.training.service;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import com.training.dao.FrontendDao;
import com.training.model.Goods;
import com.training.model.Member;
import com.training.vo.BuyGoodsRtn;

public class FrontendService {
	private static FrontendService frontendService = new FrontendService();
	private FrontendService(){}
	public static FrontendService getInstance()
	{
		return frontendService;
	}
	
	private FrontendDao frontendDao = FrontendDao.getInstance(); 
	
	public Member login(String identificationNo){
		return frontendDao.queryMemberByIdentificationNo(identificationNo);
	}
	
	public List<Goods> searchGoods(String searchKeyword){
		return frontendDao.searchGoods(searchKeyword);
	}
	
	public BuyGoodsRtn buyGoods(String customerID, String[] goodsID_Array, String[] quantities, int inputMoney){
		
		BuyGoodsRtn rtn = new BuyGoodsRtn();
		rtn.setInputMoney(inputMoney);
		
		Set<BigDecimal> goodsIDs = new HashSet<>();
		Map<BigDecimal,Integer> buyList = new HashMap<>();
		for(int i=0;i<goodsID_Array.length;++i){
			if(!quantities[i].equals("0")){
				BigDecimal id = new BigDecimal(goodsID_Array[i]); 
				goodsIDs.add(id);
				buyList.put(id, Integer.parseInt(quantities[i]));
			}
		}
		Map<BigDecimal, Goods> queryBuyGoods =  frontendDao.queryBuyGoods(goodsIDs);
		int total = 0;
		for(BigDecimal id : goodsIDs){
			Goods gd = queryBuyGoods.get(id);
			total += gd.getGoodsPrice()*buyList.get(id);
		}
		
		if(inputMoney>=total){
			Map<Goods,Integer> goodsOrders = new HashMap<>();
			int actualTotal = 0;
			for(BigDecimal goodsID : goodsIDs){
				int buyQuantity = Math.min(buyList.get(goodsID), queryBuyGoods.get(goodsID).getGoodsQuantity());
				actualTotal += buyQuantity * queryBuyGoods.get(goodsID).getGoodsPrice();
				goodsOrders.put(queryBuyGoods.get(goodsID), buyQuantity);
			}
			
			frontendDao.batchCreateGoodsOrder(customerID, goodsOrders);

			rtn.setChangeMoney(inputMoney-actualTotal);
			rtn.setBuyMoney(actualTotal);
			
			for(Goods gd : goodsOrders.keySet()){
				rtn.addGoods(gd.getGoodsName(), gd.getGoodsPrice(), goodsOrders.get(gd));
			}
			
			queryBuyGoods.values().stream().forEach(g -> g.setGoodsQuantity(g.getGoodsQuantity() - goodsOrders.get(g)));
			frontendDao.batchUpdateGoodsQuantity(queryBuyGoods.values().stream().collect(Collectors.toSet()));
			
		}else{
			rtn.setChangeMoney(inputMoney);
			rtn.setBuyMoney(total);
		}
		return rtn;
	}
	
	public Goods queryBuyGoods(BigDecimal goodsIDs){
		return frontendDao.queryBuyGoods(goodsIDs);
	}
	
}
