<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>販賣機-後臺 商品新增</title>
</head>
<body>
	<%@ include file="VM_Backend_Navigation.jsp" %>
	
	<h2>商品新增上架</h2><br/>
	<div style="color: blue; font-weight: bold; height: 15px;">${updateMsg}</div>
	<%session.removeAttribute("updateMsg"); %>
	<div style="margin-left:25px;">
	<form action="BackendAction.do?action=addGoods" enctype="multipart/form-data" method="post">
		<p>
			飲料名稱：
			<input type="text" name="goodsName" size="10"/>
		</p>
		<p>
			設定價格： 
			<input type="number" name="goodsPrice" size="5" value="0" min="0" max="1000"/>
		</p>
		<p>
			初始數量：
			<input type="number" name="goodsQuantity" size="5" value="0" min="0" max="1000"/>
		</p>
		<p>
			商品圖片：
			<input type="file" name="goodsImage"/>
		</p>
		<p>
			商品狀態：
			<select name="status">
				<option value="1">上架</option>
				<option value="0">下架</option>				
			</select>
		</p>
		<p>
			<input type="submit" value="送出">
		</p>
	</form>
	</div>
</body>
</html>