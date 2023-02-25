<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>販賣機-後臺</title>
</head>
<body>
	<h1>販賣機-後臺</h1><br/>		
	<table border="1" style="border-collapse:collapse;;margin-left:25px;">
		<tr>
			<td width="200" height="50" align="center">
				<a href="BackendSearch.do?action=queryAllGoods">商品列表</a>
			</td>
			<td width="200" height="50" align="center">
				<a href="BackendAction.do?action=goodsReplenishmentView">商品維護作業</a>
			</td>
			<td width="200" height="50" align="center">
				<a href="BackendAction.do?action=goodsCreateView">商品新增上架</a>
			</td>
			<td width="200" height="50" align="center">
				<a href="BackendAction.do?action=goodsSaleReportView">銷售報表</a>
				<!-- 用redirect改變網址&清除request -->
			</td>
			<td width="200" height="50" align="center">
				<a href="BackendAction.do?action=gotoFrontend">回到前臺</a>
			</td>
		</tr>
	</table>
	<br/><br/><HR>
</body>
</html>