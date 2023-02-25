<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>販賣機-後臺 商品列表</title>
</head>
<body>
	<%@ include file="VM_Backend_Navigation.jsp" %>
	
	<h2>商品列表</h2><br/>
	<div style="margin-left:25px;">
	<form action="BackendSearch.do?action=setSearchCondition" method="post">
		<input type="hidden" name="action" value="searchGoodsList"/>
		<input type="hidden" name="pageNo" value="1"/>
		<table>
		
			<tr height="40">
				<td width="200"><b>商品編號</b></td>
				<td width="200"><b>商品名稱(不區分大小寫)</b></td>
				<td width="200"><b>商品價格最低價</b></td>
				<td width="200"><b>商品價格最高價</b></td>
			</tr>
			<tr height="20">
				<td width="200"> <input type="number" name="goodsId" placeholder="Enter goods ID" 
					<c:if test="${SearchCondition.goodsId ne 0}">value="${SearchCondition.goodsId}"</c:if>> </td>
				<td width="200"> <input type="text" name="goodsName" placeholder="Enter goods name"  value="${SearchCondition.goodsName}"></td>
				<td width="200"> <input type="number" name="priceMin" placeholder="Enter goods price Min" 
					<c:if test="${SearchCondition.priceMin ne 0}">value="${SearchCondition.priceMin}"</c:if>></td>
				<td width="200"> <input type="number" name="priceMax" placeholder="Enter goods price Max" 
					<c:if test="${SearchCondition.priceMax ne 0}">value="${SearchCondition.priceMax}"</c:if>></td>
			</tr>
			<tr height="40">
				<td width="200"><b>價格排序</b></td>
				<td width="200"><b>商品低於庫存量</b></td>
				<td width="200"><b>商品狀態</b></td>
				<td width="200"><b></b></td>
			</tr>
			<tr height="20">
				<td width="200"> 
					<select name="orderByPrice">
<!-- 						<option value="" disabled="disabled">--無--</option> -->
						<option value="ID"  >無</option>
						<option value="ASC"  <c:if test="${SearchCondition.orderByPrice eq 'ASC'}"> selected</c:if>> 由低到高</option>
						<option value="DESC" <c:if test="${SearchCondition.orderByPrice eq 'DESC'}"> selected</c:if>>由高到低</option>
					</select>
				
				</td>
				<td width="200"> <input type="number" name="stockQuantity" placeholder="Enter goods stock quantity" 
					<c:if test="${SearchCondition.stockQuantity ne 0}">value="${SearchCondition.stockQuantity}"</c:if>></td>
				<td width="200"> 
					<select name="status">
						<option value="-1">ALL</option>
						<option value="1" <c:if test="${SearchCondition.status eq 1}"> selected</c:if>>上架</option>
						<option value="0" <c:if test="${SearchCondition.status eq 0}"> selected</c:if>>下架</option>
					</select>
				</td>
				<td width="200"> <input type="submit" value="查詢"/></td>
			</tr>
		</table>
	</form>
	<br>
	<%	
	if(null!=request.getParameter("pageNo")){
		pageContext.setAttribute("pageNo", request.getParameter("pageNo"));	
	}else{
		pageContext.setAttribute("pageNo",1);
	}
	%>
	<table border="1">
		<tbody>
			<tr height="50">
				<td width="150"><b>商品名稱</b></td> 
				<td width="100"><b>商品價格</b></td>
				<td width="100"><b>現有庫存</b></td>
				<td width="100"><b>商品狀態</b></td>
			</tr>
			<c:forEach items="${sessionScope.ResultList}" var="gd">
				<tr height="30">
				<td>${gd.goodsName}</td> 
				<td>${gd.goodsPrice}</td>
				<td>${gd.goodsQuantity}</td>
				<td><c:choose>
						<c:when test="${gd.status eq 1}">上架</c:when>
						<c:otherwise>下架</c:otherwise>
					</c:choose></td>		
			</tr>
			</c:forEach>
		</tbody>
	</table>
    page: ${pageNo}/${TotalPages}<br>
	<c:if test="${TotalPages gt '1'}">
		<table>
			<tr>
			<c:if test="${pageNo gt '1'}">
				<td>
				<c:url value="/BackendSearch.do" var="firstPage">
					<c:param name="action" value="searchGoodsList"/>
					<c:param name="pageNo" value="1"/>
				</c:url>
				<a href="${firstPage}"><c:out value="<<"/></a>
				</td>
				<td>
				<c:url value="/BackendSearch.do" var="prePage">
					<c:param name="action" value="searchGoodsList"/>
					<c:param name="pageNo" value="${pageNo-1}"/>
				</c:url>
				<a href="${prePage}"><c:out value="<"/></a>
				</td>
			</c:if>
			
			<c:forEach items="${showPages}" var="page">
			<td>
				<c:url value="/BackendSearch.do" var="p">
					<c:param name="action" value="searchGoodsList"/>
					<c:param name="pageNo" value="${page}"/>
				</c:url>
			<a href="${p}" <c:if test="${pageNo eq page}">style="color: red;font-weight: bold;"</c:if> ><c:out value="${page}"/></a>
			</td>
			</c:forEach>
			
			<c:if test="${pageNo lt TotalPages}">
				<td>
				<c:url value="/BackendSearch.do" var="nxtPage">
					<c:param name="action" value="searchGoodsList"/>
					<c:param name="pageNo" value="${pageNo+1}"/>
				</c:url>
				<a href="${nxtPage}"><c:out value=">"/></a>
				</td>
				<td>
				<c:url value="/BackendSearch.do" var="lastPage">
					<c:param name="action" value="searchGoodsList"/>
					<c:param name="pageNo" value="${TotalPages}"/>
				</c:url>
				<a href="${lastPage}"><c:out value=">>"/></a>
				</td>
				
			</c:if>
			
			
			</tr>
		</table>
	</c:if>
	</div>
</body>
</html>