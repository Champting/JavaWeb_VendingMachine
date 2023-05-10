package com.training.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import com.training.model.Goods;
import com.training.model.GoodsSearch;
import com.training.vo.SalesReport;

public class BackendDao {
	
	private static BackendDao backendDao = new BackendDao();
	
	private BackendDao(){ }

	public static BackendDao getInstance(){
		return backendDao;
	}
	
	/**
	 * 後臺管理商品列表
	 * @return List(Goods)
	 */
	public List<Goods> queryGoods() {
		List<Goods> goods = new ArrayList<>(); 
		String sql = "SELECT * FROM BEVERAGE_GOODS";
		try(Connection conn = DBConnectionFactory.getOracleDBConnection();
				Statement st = conn.createStatement();
				ResultSet rs = st.executeQuery(sql)){
			while(rs.next()){
				Goods gd = new Goods();
				gd.setGoodsID(rs.getBigDecimal("GOODS_ID"));
				gd.setGoodsName(rs.getString("GOODS_NAME"));
				gd.setGoodsPrice(rs.getInt("PRICE"));
				gd.setGoodsQuantity(rs.getInt("QUANTITY"));
				gd.setGoodsImageName(rs.getString("IMAGE_NAME"));
				gd.setStatus(rs.getString("STATUS"));
				goods.add(gd);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return goods;
	}
	
	public Goods queryGoodsByID(int id) {
		String sql = "SELECT * FROM BEVERAGE_GOODS WHERE GOODS_ID = ?";
		Goods gd = new Goods();
		try(Connection conn = DBConnectionFactory.getOracleDBConnection();
				PreparedStatement prst = conn.prepareStatement(sql)){
			prst.setInt(1, id);
			try(ResultSet rs = prst.executeQuery();){
				while(rs.next()){
					gd.setGoodsID(rs.getBigDecimal("GOODS_ID"));
					gd.setGoodsName(rs.getString("GOODS_NAME"));
					gd.setGoodsPrice(rs.getInt("PRICE"));
					gd.setGoodsQuantity(rs.getInt("QUANTITY"));
					gd.setGoodsImageName(rs.getString("IMAGE_NAME"));
					gd.setStatus(rs.getString("STATUS"));
				}	
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return gd;
	}
	
	
	/**
	 * 後臺依條件查詢商品
	 * @param search
	 * @return List(Goods)
	 */
	public List<Goods> searchGoods(GoodsSearch search) {
		List<Goods> goods = new ArrayList<>(); 
		
		String sql = "SELECT * FROM BEVERAGE_GOODS WHERE GOODS_ID IS NOT NULL";
		List<String> conditions = new ArrayList<>();
	
//		int goodsId;
		if(search.getGoodsId()!=0){
			sql += " AND GOODS_ID = ?";
			Integer id = search.getGoodsId();
			conditions.add(id.toString());
		}

//		String goodsName;
		if(null!=search.getGoodsName() &&search.getGoodsName()!=""){
			sql += " AND LOWER(GOODS_NAME) = LOWER(?)";
			conditions.add(search.getGoodsName());
		}
		
//		int priceMin;
		if(search.getPriceMin()!=0){
			sql += " AND PRICE >= ?";
			Integer min = search.getPriceMin();
			conditions.add(min.toString());
		}

//		int priceMax;		
		if(search.getPriceMax()!=0){
			sql += " AND PRICE <= ?";
			Integer max = search.getPriceMax();
			conditions.add(max.toString());
		}

//		int stockQuantity;
		if(search.getStockQuantity()!=0){
			sql += " AND QUANTITY <= ?";
			Integer q = search.getStockQuantity();
			conditions.add(q.toString());
		}
		
//		int status;
		if(search.getStatus()!=-1){
			sql += " AND STATUS = ?";
			Integer s = search.getStatus();
			conditions.add(s.toString());
		}
		
		
//		String orderByPrice;
		if(!search.getOrderByPrice().equals("ID")){
			sql += " ORDER BY PRICE " + search.getOrderByPrice();
		}
		try(Connection conn = DBConnectionFactory.getOracleDBConnection();
				PreparedStatement prst = conn.prepareStatement(sql)){
			int count = 0;
			for(String condi : conditions){
				prst.setString(++count, condi);
			}
			
			ResultSet rs = prst.executeQuery();
			while(rs.next()){
				Goods gd = new Goods();
				gd.setGoodsID(rs.getBigDecimal("GOODS_ID"));
				gd.setGoodsName(rs.getString("GOODS_NAME"));
				gd.setGoodsPrice(rs.getInt("PRICE"));
				gd.setGoodsQuantity(rs.getInt("QUANTITY"));
				gd.setGoodsImageName(rs.getString("IMAGE_NAME"));
				gd.setStatus(rs.getString("STATUS"));
				goods.add(gd);
			}
			rs.close();
		}catch (SQLException e) {
			e.printStackTrace();
		}
		return goods;
	}
	
	
	
	
	/**
	 * 後臺管理新增商品
	 * @param goods
	 * @return int(商品編號)
	 */
	public int createGoods(Goods goods){
		int goodsID = 0;
		String sql = "INSERT INTO BEVERAGE_GOODS (GOODS_ID, GOODS_NAME, PRICE, QUANTITY, IMAGE_NAME, STATUS) " +
				" VALUES (BEVERAGE_GOODS_SEQ.NEXTVAL, ?, ?, ?, ?, ?)";
		String[] cols = { "GOODS_ID" };
		try(Connection conn = DBConnectionFactory.getOracleDBConnection();
				PreparedStatement prst = conn.prepareStatement(sql, cols)){
			int counter = 0;
			prst.setString(++counter, goods.getGoodsName());
			prst.setInt(++counter, goods.getGoodsPrice());
			prst.setInt(++counter, goods.getGoodsQuantity());
			prst.setString(++counter, goods.getGoodsImageName());
			prst.setString(++counter, goods.getStatus());
			
			prst.executeUpdate();

		
			ResultSet rsKeys = prst.getGeneratedKeys();

			while (rsKeys.next()) {
				goodsID = Integer.parseInt(rsKeys.getString(1));
			}
			rsKeys.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return goodsID;
	}
	
	/**
	 * 後臺管理更新商品
	 * @param goods
	 * @return boolean
	 */
	public boolean updateGoods(Goods goods) {
		boolean updateSuccess = false;
		String select = "SELECT * FROM BEVERAGE_GOODS WHERE GOODS_ID=?";
		int quantity = 0;
		String status = "";
		try(Connection conn = DBConnectionFactory.getOracleDBConnection();
				PreparedStatement prst = conn.prepareStatement(select)){
			prst.setBigDecimal(1, goods.getGoodsID());
			ResultSet rs = prst.executeQuery();
			while(rs.next()){
				quantity = rs.getInt("QUANTITY");
				status = rs.getString("STATUS");
			}
		} catch (SQLException e0) {
			e0.printStackTrace();
		}
		
		
		String sql = "UPDATE BEVERAGE_GOODS SET PRICE=?, QUANTITY=?, STATUS=? " +
				"WHERE GOODS_ID=?";
		try(Connection conn = DBConnectionFactory.getOracleDBConnection();
				PreparedStatement prst = conn.prepareStatement(sql)){
			int counter = 0;
			prst.setInt(++counter, goods.getGoodsPrice());
			int total = goods.getGoodsQuantity()+quantity;
			prst.setInt(++counter, total);
			if(goods.getStatus()!=null && goods.getStatus()!=""){
				prst.setString(++counter, goods.getStatus());
			}else{
				prst.setString(++counter, status);
			}	
			prst.setBigDecimal(++counter, goods.getGoodsID());
			if(prst.executeUpdate()>0){
				updateSuccess=true;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return updateSuccess;
	}
	
	/**
	 * 後臺管理刪除商品
	 * @param goodsID
	 * @return boolean
	 */
	public boolean deleteGoods(BigDecimal goodsID) {
		boolean deleteSuccess = false;
		String sql = "DELETE FROM BEVERAGE_GOODS WHERE GOODS_ID=?";
		try(Connection conn = DBConnectionFactory.getOracleDBConnection();
				PreparedStatement prst = conn.prepareStatement(sql)){
			prst.setBigDecimal(1, goodsID);
			if(prst.executeUpdate()>0){
				deleteSuccess=true;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return deleteSuccess;
	}
	
	/**
	 * 後臺管理顧客訂單查詢
	 * @param queryStartDate
	 * @param queryEndDate
	 * @return Set(SalesReport)
	 */
	public Set<SalesReport> queryOrderBetweenDate(String queryStartDate, String queryEndDate) {
		Set<SalesReport> reports = new LinkedHashSet<>();
//		String sql = "SELECT *, TO_CHAR(ORDER_DATE, 'YYYY/mm/DD') DT FROM BEVERAGE_ORDER OD LEFT JOIN BEVERAGE_MEMBER MB ON OD.CUSTOMER_ID = MB.IDENTIFICATION_NO"
//				+ " LEFT JOIN BEVERAGE_GOODS GD ON OD.GOODS_ID = GD.GOODS_ID"
//				+ " WHERE TRUNC(ORDER_DATE) BETWEEN TO_DATE(?, 'YYYY-mm-DD') AND TO_DATE(?, 'YYYY-mm-DD')";
		
		String sql = "SELECT ORDER_ID, TO_CHAR(ORDER_DATE, 'YYYY/mm/DD') DT, CUSTOMER_NAME, GOODS_NAME, GOODS_BUY_PRICE, BUY_QUANTITY "
				+ " FROM BEVERAGE_ORDER OD LEFT JOIN BEVERAGE_MEMBER MB ON OD.CUSTOMER_ID = MB.IDENTIFICATION_NO"
				+ " LEFT JOIN BEVERAGE_GOODS GD ON OD.GOODS_ID = GD.GOODS_ID"
				+ " WHERE TRUNC(ORDER_DATE) BETWEEN TO_DATE(?, 'YYYY-mm-DD') AND TO_DATE(?, 'YYYY-mm-DD')"
				+ " ORDER BY ORDER_DATE DESC";
		
		try(Connection conn = DBConnectionFactory.getOracleDBConnection();
				PreparedStatement prst = conn.prepareStatement(sql)){
			prst.setString(1, queryStartDate);
			prst.setString(2, queryEndDate);
			ResultSet rs = prst.executeQuery();
			while(rs.next()){
				SalesReport sr = new SalesReport();
				sr.setOrderID(rs.getLong("ORDER_ID"));
				sr.setOrderDate(rs.getString("DT"));
				sr.setCustomerName(rs.getString("CUSTOMER_NAME"));
				sr.setGoodsName(rs.getString("GOODS_NAME"));
				sr.setGoodsBuyPrice(rs.getInt("GOODS_BUY_PRICE"));
				sr.setBuyQuantity(rs.getInt("BUY_QUANTITY"));
				sr.setBuyAmount(sr.getBuyQuantity()*sr.getGoodsBuyPrice());
				reports.add(sr);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return reports;
	}	
	
}
