package com.training.formbean;

import org.apache.struts.action.ActionForm;

public class GoodsOrderForm extends ActionForm{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String goodsID;
	private String buyQuantity;
	
	public String getGoodsID() {
		return goodsID;
	}
	public void setGoodsID(String goodsID) {
		this.goodsID = goodsID;
	}
	public String getBuyQuantity() {
		return buyQuantity;
	}
	public void setBuyQuantity(String buyQuantity) {
		this.buyQuantity = buyQuantity;
	}
	
}
