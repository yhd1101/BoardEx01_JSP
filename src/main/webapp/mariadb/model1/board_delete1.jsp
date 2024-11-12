<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.NamingException" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%
	// seq 파라미터 가져오기
	String seq = request.getParameter("seq");

	// 초기 변수 선언
	String subject = "";
	String writer = "";
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;

	try {
		// 데이터베이스 연결
		Context initCtx = new InitialContext();
		Context envCtx = (Context) initCtx.lookup("java:comp/env");
		DataSource dataSource = (DataSource) envCtx.lookup("jdbc/mariadb1");
		conn = dataSource.getConnection();

		// SQL 실행
		String sql = "SELECT subject, writer FROM board1 WHERE seq=?";
		psmt = conn.prepareStatement(sql);
		psmt.setString(1, seq);
		rs = psmt.executeQuery();

		// 데이터가 존재할 경우 값 할당
		if (rs.next()) {
			subject = rs.getString("subject");
			writer = rs.getString("writer");
		} else {
			System.out.println("No data found for seq: " + seq);
		}

	} catch (NamingException e) {
		System.out.println("NamingException Error: " + e.getMessage());
	} catch (SQLException e) {
		System.out.println("SQLException Error: " + e.getMessage());
	} finally {
		// 리소스 해제
		if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
		if (psmt != null) try { psmt.close(); } catch (SQLException ignored) {}
		if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
	}
%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0">
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<title>게시판</title>
	<link rel="stylesheet" type="text/css" href="../../css/board.css">
	<script type="text/javascript">
		window.onload = function () {
			document.getElementById('dbtn').onclick = function () {
				if (document.dfrm.password.value === '') {
					alert('비밀번호를 입력하셔야 합니다.');
					return false;
				}
				document.dfrm.submit();
			};
		};
	</script>
</head>

<body>
<div class="con_title">
	<h3>게시판</h3>
	<p>HOME &gt; 게시판 &gt; <strong>게시판</strong></p>
</div>
<div class="con_txt">
	<form action="board_delete1_ok.jsp" method="post" name="dfrm">
		<input type="hidden" name="seq" value="<%= seq %>" />
		<div class="contents_sub">
			<div class="board_write">
				<table>
					<tr>
						<th class="top">글쓴이</th>
						<td class="top"><input type="text" name="writer" value="<%= writer %>" class="board_view_input_mail" maxlength="5" readonly/></td>
					</tr>
					<tr>
						<th>제목</th>
						<td><input type="text" name="subject" value="<%= subject %>" class="board_view_input" readonly/></td>
					</tr>
					<tr>
						<th>비밀번호</th>
						<td><input type="password" name="password" value="" class="board_view_input_mail"/></td>
					</tr>
				</table>
			</div>
			<div class="btn_area">
				<div class="align_left">
					<input type="button" value="목록" class="btn_list btn_txt02" style="cursor: pointer;" onclick="location.href='board_list1.jsp'" />
					<input type="button" value="보기" class="btn_list btn_txt02" style="cursor: pointer;" onclick="location.href='board_view1.jsp?seq=<%=seq%>'" />
				</div>
				<div class="align_right">
					<input type="button" id="dbtn" value="삭제" class="btn_write btn_txt01" style="cursor: pointer;" />
				</div>
			</div>
		</div>
	</form>
</div>
</body>
</html>
