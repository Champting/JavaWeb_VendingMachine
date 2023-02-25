package com.training.dao;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.training.model.Goods;
import com.training.model.Member;

public class FrontendDao {
	
	private static FrontendDao frontEndDao = new FrontendDao();
	
	private FrontendDao(){ }

	public static FrontendDao getInstance(){
		return frontEndDao;
	}
	
	/**
	 * 前臺顧客登入查詢
	 * @param identificationNo
	 * @return Member
	 */
	public Member queryMemberByIdentificationNo(String identificationNo){
		Member member = null;
		String sql = "SELECT * FROM BEVERAGE_MEMBER WHERE IDENTIFICATION_NO = ?";
		
		try(Connection conn = DBConnectionFactory.getOracleDBConnection();
				PreparedStatement prst = conn.prepareStatement(sql)){
			prst.setString(1, identificationNo);
			ResultSet rs = prst.executeQuery();
			while(rs.next()){
				member = new Member();
				member.setCustomerName(rs.getString("CUSTOMER_NAME"));
				member.setIdentificationNo(rs.getString("IDENTIFICATION_NO"));
				member.setPassword(rs.getString("PASSWORD"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return member;
	}
	
	/**
	 * 前臺顧客瀏灠商品
	 * @param searchKeyword
	 * @param startRowNo
	 * @param endRowNo
	 * @return Set(Goods)
	 */
	public List<Goods> searchGoods(String searchKeyword) {
		List<Goods> goods = new ArrayList<>();
//		Set<Goods> goods = new LinkedHashSet<>();
		String sql = "SELECT * FROM BEVERAGE_GOODS ";
		if(""!=searchKeyword){
			sql+=" WHERE LOWER(GOODS_NAME) LIKE ?";
		}
				
		try(Connection conn = DBConnectionFactory.getOracleDBConnection();
				PreparedStatement prst = conn.prepareStatement(sql)){
			if(""!=searchKeyword){
				prst.setString(1, "%"+searchKeyword.toLowerCase()+"%");
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
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		
		return goods;
	}
	
//	public Set<Goods> searchGoods(int startRowNo, int endRowNo) {
//		Set<Goods> goods = new LinkedHashSet<>();
//		String sql = "SELECT * FROM("
//				+ " SELECT ROWNUM RN, GD.* FROM BEVERAGE_GOODS GD)"
//				+ " WHERE RN BETWEEN ? AND ?";
//		
//		try(Connection conn = DBConnectionFactory.getOracleDBConnection();
//				PreparedStatement prst = conn.prepareStatement(sql)){
//			prst.setInt(1, startRowNo);
//			prst.setInt(2, endRowNo);
//			ResultSet rs = prst.executeQuery();
//			while(rs.next()){
//				Goods gd = new Goods();
//				gd.setGoodsID(rs.getBigDecimal("GOODS_ID"));
//				gd.setGoodsName(rs.getString("GOODS_NAME"));
//				gd.setGoodsPrice(rs.getInt("PRICE"));
//				gd.setGoodsQuantity(rs.getInt("QUANTITY"));
//				gd.setGoodsImageName(rs.getString("IMAGE_NAME"));
//				gd.setStatus(rs.getString("STATUS"));
//				goods.add(gd);
//			}
//			rs.close();
//		} catch (SQLException e) {
//			e.printStackTrace();
//		}
//		
//		
//		return goods;
//	}
	/**
	 * 查詢顧客所購買商品資料(價格、庫存)
	 * @param goodsIDs
	 * @return Map(BigDecimal, Goods)
	 */
	public Map<BigDecimal, Goods> queryBuyGoods(Set<BigDecimal> goodsIDs){
		// key:商品編號、value:商品
		Map<BigDecimal, Goods> goods = new LinkedHashMap<>();
		String sql = "SELECT * FROM BEVERAGE_GOODS WHERE GOODS_ID = ?";
		try(Connection conn = DBConnectionFactory.getOracleDBConnection();
				PreparedStatement prst = conn.prepareStatement(sql)){
			for(BigDecimal gdid : goodsIDs){
				prst.setBigDecimal(1, gdid);
				ResultSet rs = prst.executeQuery();
				while(rs.next()){
					Goods gd = new Goods();
					gd.setGoodsID(rs.getBigDecimal("GOODS_ID"));
					gd.setGoodsName(rs.getString("GOODS_NAME"));
					gd.setGoodsPrice(rs.getInt("PRICE"));
					gd.setGoodsQuantity(rs.getInt("QUANTITY"));
					gd.setGoodsImageName(rs.getString("IMAGE_NAME"));
					gd.setStatus(rs.getString("STATUS"));
					goods.put(gdid, gd);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return goods;
	}
	
	public Goods queryBuyGoods(BigDecimal goodsIDs){
		Goods goods = null;
		String sql = "SELECT * FROM BEVERAGE_GOODS WHERE GOODS_ID = ?";
		try(Connection conn = DBConnectionFactory.getOracleDBConnection();
				PreparedStatement prst = conn.prepareStatement(sql)){
			prst.setBigDecimal(1, goodsIDs);
			ResultSet rs = prst.executeQuery();
			if(rs.next()){
				goods = new Goods();
				goods.setGoodsID(rs.getBigDecimal("GOODS_ID"));
				goods.setGoodsName(rs.getString("GOODS_NAME"));
				goods.setGoodsPrice(rs.getInt("PRICE"));
				goods.setGoodsQuantity(rs.getInt("QUANTITY"));
				goods.setGoodsImageName(rs.getString("IMAGE_NAME"));
				goods.setStatus(rs.getString("STATUS"));
			}
		}catch (SQLException e) {
			e.printStackTrace();
		}
		return goods;		
	}
	
	
	/**
	 * 交易完成更新扣商品庫存數量
	 * @param goods
	 * @return boolean
	 */
	public boolean batchUpdateGoodsQuantity(Set<Goods> goods){
		boolean updateSuccess = false;
		String sql = "UPDATE BEVERAGE_GOODS SET QUANTITY=? WHERE GOODS_ID=?";
		try(Connection conn = DBConnectionFactory.getOracleDBConnection();
				PreparedStatement prst = conn.prepareStatement(sql)){
			for(Goods gd : goods){
				prst.setInt(1, gd.getGoodsQuantity());
				prst.setBigDecimal(2, gd.getGoodsID());
				prst.addBatch();
			}
			int[] updateStatus = prst.executeBatch();
			for(int i : updateStatus){
				if(i==0)
					return false;
			}
			updateSuccess = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return updateSuccess;
	}
	
	/**
	 * 建立訂單資料
	 * @param customerID
	 * @param goodsOrders【訂單資料(key:購買商品、value:購買數量)】
	 * @return boolean
	 */
	public boolean batchCreateGoodsOrder(String customerID, Map<Goods,Integer> goodsOrders){
		boolean insertSuccess = false;
		String sql = "INSERT INTO BEVERAGE_ORDER (ORDER_ID, ORDER_DATE, CUSTOMER_ID, GOODS_ID, GOODS_BUY_PRICE, BUY_QUANTITY) "
				+ " VALUES (BEVERAGE_ORDER_SEQ.NEXTVAL, SYSDATE, ?, ?, ?, ?)";
		try(Connection conn = DBConnectionFactory.getOracleDBConnection();
				PreparedStatement prst = conn.prepareStatement(sql)){
			for(Goods gds : goodsOrders.keySet()){
				int counter = 0;
				prst.setString(++counter, customerID);
				prst.setBigDecimal(++counter, gds.getGoodsID());
				prst.setInt(++counter, gds.getGoodsPrice());
				prst.setInt(++counter, goodsOrders.get(gds));
				prst.addBatch();
			}
			int[] insertStatus = prst.executeBatch();
			for(int i : insertStatus){
				if(i==0)
					return false;
			}
			insertSuccess = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return insertSuccess;
	}	

}
