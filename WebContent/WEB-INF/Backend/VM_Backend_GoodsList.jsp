<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>販賣機-後臺 商品列表</title>
	<link type="text/css" rel="stylesheet"
		href="${CSS_PATH}/bootstrap.min.css" />
	<script src="${JS_PATH}/jquery-3.2.1.min.js"></script>
	<script src="${JS_PATH}/popper.min.js"></script>
	<script src="${JS_PATH}/bootstrap.min.js"></script>
</head>
<body>
	<div class="container">
	
	<c:set var="currentPage" value="list"/>
	<%@ include file="VM_Backend_Navigation.jsp" %>
	<div class="row">
		<div class="col my-4"><h2>商品列表</h2></div>
	</div>

		<form  action="BackendSearch.do?action=setSearchCondition" method="post">
		<input type="hidden" name="action" value="searchGoodsList"/>
		<input type="hidden" name="pageNo" value="1"/>
			<div class="form-row">
				<div class="form-group col-md-3">
					<label for="formGoodsID">商品編號</label>
					<input type="number" class="form-control" id="formGoodsID" name="goodsId" placeholder="GOODS ID" 
							<c:if test="${SearchCondition.goodsId ne 0}">value="${SearchCondition.goodsId}"</c:if>>
				</div>	
				<div class="form-group col-md-3">
					<label for="formGoodsName">商品名稱</label>
					<input type="text" class="form-control" id="formGoodsName" name="goodsName" placeholder="GOODS NAME" 
							value="${SearchCondition.goodsName}">
				</div>
				<div class="form-group col-md-3">
					<label for="formMinPrice">最低價格</label>
					<input type="number" class="form-control" id="formMinPrice" name="priceMin" placeholder="MINIMUN PRICE" 
							<c:if test="${SearchCondition.priceMin ne 0}">value="${SearchCondition.priceMin}"</c:if>>
				</div>
				<div class="form-group col-md-3">
					<label for="formMinPrice">最高價格</label>
					<input type="number" class="form-control" id="formMaxPrice" name="priceMax" placeholder="MAXIMUN PRICE" 
							<c:if test="${SearchCondition.priceMax ne 0}">value="${SearchCondition.priceMax}"</c:if>>
				</div>
			</div>
			<div class="form-row">
				<div class="form-group col-md-3">
					<label for="formOrder">價格排序</label>
					<select class="form-control" id="formOrder" name="orderByPrice">
						<option value="ID"  >無</option>
						<option value="ASC"  <c:if test="${SearchCondition.orderByPrice eq 'ASC'}"> selected</c:if>> 由低到高</option>
						<option value="DESC" <c:if test="${SearchCondition.orderByPrice eq 'DESC'}"> selected</c:if>>由高到低</option>
					</select>
				</div>
				<div class="form-group col-md-3">
					<label for="formQuantity">庫存量低於</label>
					<input type="number" class="form-control" id="formQuantity" name="stockQuantity" placeholder="STOCK QUANTITY" 
							<c:if test="${SearchCondition.stockQuantity ne 0}">value="${SearchCondition.stockQuantity}"</c:if>>
				</div>
				<div class="form-group col-md-3">
					<label for="formStatus">商品狀態</label>
					<select class="form-control" id="formStatus" name="status">
						<option value="-1">ALL</option>
						<option value="1" <c:if test="${SearchCondition.status eq 1}"> selected</c:if>>上架</option>
						<option value="0" <c:if test="${SearchCondition.status eq 0}"> selected</c:if>>下架</option>
					</select>
				</div>
				<div class="form-group col-md-3">
					<label> <br/></label>
					<input type="submit" class="btn btn-outline-secondary btn-block" value="查詢"/>
				</div>
			</div>
	</form>
	
	<div class="row" style="margin-top:30px;">
	<%	
	if(null!=request.getParameter("pageNo")){
		pageContext.setAttribute("pageNo", request.getParameter("pageNo"));	
	}else{
		pageContext.setAttribute("pageNo",1);
	}
	%>
	<table class="table table-striped table-hover">
		<thead class="thead-dark">
			<tr>
				<th scope="col">#</th>
				<th scope="col">商品名稱</th>
				<th scope="col">商品價格</th>
				<th scope="col">現有庫存</th>
				<th scope="col">商品狀態</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${sessionScope.ResultList}" var="gd" varStatus="status">
			<tr>
				<th scope="row">${(pageNo-1)*10+status.index + 1}</th>
				<td>${gd.goodsName}</td> 
				<td>${gd.goodsPrice}</td>
				<td>${gd.goodsQuantity}</td>
				<td>
				<c:choose>
					<c:when test="${gd.status eq 1}">上架</c:when>
					<c:otherwise>下架</c:otherwise>
				</c:choose>
				</td>		
			</tr>
			</c:forEach>
		</tbody>
	</table>
	</div>
<%--     page: ${pageNo}/${TotalPages}<br> --%>
	
	<div class="row">
	<div class="col">
	<c:if test="${TotalPages gt '1'}">
			<nav aria-label="Page navigation example">
			<ul class="pagination justify-content-center">
				<li class="page-item <c:if test="${pageNo eq '1'}">disabled</c:if>">
					<c:url value="/BackendSearch.do" var="firstPage">
						<c:param name="action" value="searchGoodsList"/>
						<c:param name="pageNo" value="1"/>
					</c:url>
					<a class="page-link" href="${firstPage}"><span>第一頁</span></a>
				</li>
				<li class="page-item <c:if test="${pageNo eq '1'}">disabled</c:if>">
					<c:url value="/BackendSearch.do" var="prePage">
						<c:param name="action" value="searchGoodsList"/>
						<c:param name="pageNo" value="${pageNo-1}"/>
					</c:url>
					<a class="page-link" href="${prePage}"><span>上一頁</span></a>
				</li>
				<c:forEach items="${showPages}" var="page">
					<li class="page-item <c:if test="${pageNo eq page}">active</c:if>">
						<c:url value="/BackendSearch.do" var="pLink">
							<c:param name="action" value="searchGoodsList"/>
							<c:param name="pageNo" value="${page}"/>
						</c:url>
						<a class="page-link" href="${pLink}">${page}</a>
					</li>
				</c:forEach>
				<li class="page-item <c:if test="${pageNo eq TotalPages}">disabled</c:if>">
					<c:url value="/BackendSearch.do" var="nxtPage">
						<c:param name="action" value="searchGoodsList"/>
						<c:param name="pageNo" value="${pageNo+1}"/>
					</c:url>
					<a class="page-link" href="${nxtPage}"><span>下一頁</span></a>
					
				</li>
				<li class="page-item <c:if test="${pageNo eq TotalPages}">disabled</c:if>">
					<c:url value="/BackendSearch.do" var="lastPage">
						<c:param name="action" value="searchGoodsList"/>
						<c:param name="pageNo" value="${TotalPages}"/>
					</c:url>
					<a class="page-link" href="${lastPage}"><span>最末頁</span></a>
				</li>
			</ul>
			</nav>
		</c:if>
		</div>
		</div>
	</div>
</body>
</html>