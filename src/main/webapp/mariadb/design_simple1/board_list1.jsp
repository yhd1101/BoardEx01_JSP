<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.NamingException" %>

<%@ page import="javax.sql.DataSource" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.SQLException" %>

<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;

	//데이터 담을것
	StringBuilder sbHtml = new StringBuilder();
	try {
		Context initCtx = new InitialContext();
		Context envCtx = (Context) initCtx.lookup("java:comp/env");
		DataSource dataSource = (DataSource) envCtx.lookup("jdbc/mariadb1");

		conn = dataSource.getConnection();

		String sql = "select seq, subject,writer,  date, hit from board1 order by seq desc";

		psmt = conn.prepareStatement( sql);
		rs = psmt.executeQuery();

		while (rs.next()) {
			String seq = rs.getString("seq");
			String subject = rs.getString("subject");
			String writer = rs.getString("writer");
			String date = rs.getString("date");
			String hit = rs.getString("hit");

			date = date.replace("-", "/");

			sbHtml.append("<tr>");
			sbHtml.append("<td>&nbsp;</td>");
			sbHtml.append("<td>"+seq + "</td>");
			sbHtml.append("<td class='left'><a href='board_view1.jsp?seq=" + seq + "'>" +subject + "</a>&nbsp;<img src='../../images/icon_new.gif' alt='NEW'></td>");
			sbHtml.append("<td>" +writer +"</td>");
			sbHtml.append("<td>" + date +"</td>");
			sbHtml.append("<td>" + hit + "</td>");
			sbHtml.append("<td>&nbsp;</td>");
			sbHtml.append("</tr>");
		}

	} catch ( NamingException e) {
		System.out.println("에러 " + e.getMessage());
	} catch ( SQLException e) {
		System.out.println("에러 " + e.getMessage());
	} finally {
		if (rs !=null) rs.close();
		if (psmt !=null) psmt.close();
		if ( conn != null) conn.close();
	}

%>

<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="../../css/board.css">
</head>

<body>
<!-- 상단 디자인 -->
<div class="con_title">
	<h3>게시판</h3>
	<p>HOME &gt; 게시판 &gt; <strong>게시판</strong></p>
</div>
<div class="con_txt">
	<div class="contents_sub">
		<div class="board_top">
			<div class="bold">총 <span class="txt_orange">1</span>건</div>
		</div>

		<!--게시판-->
		<div class="board">
			<table>
			<tr>
				<th width="3%">&nbsp;</th>
				<th width="5%">번호</th>
				<th>제목</th>
				<th width="10%">글쓴이</th>
				<th width="17%">등록일</th>
				<th width="5%">조회</th>
				<th width="3%">&nbsp;</th>
			</tr>
<%--			<tr>--%>
<%--				<td>&nbsp;</td>--%>
<%--				<td>1</td>--%>
<%--				<td class="left"><a href="board_view1.jsp">adfas</a>&nbsp;<img src="../../images/icon_new.gif" alt="NEW"></td>--%>
<%--				<td>asdfa</td>--%>
<%--				<td>2017-01-31</td>--%>
<%--				<td>6</td>--%>
<%--				<td>&nbsp;</td>--%>
<%--			</tr>--%>
				<%=sbHtml.toString()%>
			</table>
		</div>	

		<div class="btn_area">
			<div class="align_right">
				<input type="button" value="쓰기" class="btn_write btn_txt01" style="cursor: pointer;" onclick="location.href='board_write1.jsp'" />
			</div>
		</div>
		<!--//게시판-->
	</div>
</div>
<!--//하단 디자인 -->

</body>
</html>
