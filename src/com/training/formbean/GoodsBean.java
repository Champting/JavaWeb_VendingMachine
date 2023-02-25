package com.training.formbean;

import java.math.BigDecimal;

import org.apache.struts.action.ActionForm;
import org.apache.struts.upload.FormFile;

public class GoodsBean extends ActionForm {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	private BigDecimal goodsID;
	private String goodsName;
	private int goodsPrice;
	private int goodsQuantity;
	private String status;
	private FormFile goodsImage;
	
	public FormFile getGoodsImage() {
		return goodsImage;
	}
	public void setGoodsImage(FormFile goodsImage) {
		this.goodsImage = goodsImage;
	}
	public BigDecimal getGoodsID() {
		return goodsID;
	}
	public void setGoodsID(BigDecimal goodsID) {
		this.goodsID = goodsID;
	}
	public String getGoodsName() {
		return goodsName;
	}
	public void setGoodsName(String goodsName) {
		this.goodsName = goodsName;
	}
	public int getGoodsPrice() {
		return goodsPrice;
	}
	public void setGoodsPrice(int goodsPrice) {
		this.goodsPrice = goodsPrice;
	}
	public int getGoodsQuantity() {
		return goodsQuantity;
	}
	public void setGoodsQuantity(int goodsQuantity) {
		this.goodsQuantity = goodsQuantity;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}

}
