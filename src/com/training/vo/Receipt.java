package com.training.vo;

import java.util.ArrayList;
import java.util.List;

import com.training.model.Goods;

public class Receipt {
	List<Goods> details = new ArrayList<>();//品名,單價,購買數量
	
	int inputMoney;
	int totalAmount;
	
	public List<Goods> getDetails() {
		return details;
	}
	public int getInputMoney() {
		return inputMoney;
	}
	public void setInputMoney(int inputMoney) {
		this.inputMoney = inputMoney;
	}
	public int getTotalAmount() {
		return totalAmount;
	}
	public void setTotalAmount(int totalAmount) {
		this.totalAmount = totalAmount;
	}
	
	
}
