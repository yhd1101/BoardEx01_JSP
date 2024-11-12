<%--
  Created by IntelliJ IDEA.
  User: yanghandong
  Date: 11/8/24
  Time: 3:14 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.NamingException" %>

<%@ page import="javax.sql.DataSource" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.SQLException" %>

<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%
    String subject = request.getParameter( "subject" );
    String writer = request.getParameter( "writer" );
    String mail = request.getParameter( "mail1" ) + "@" + request.getParameter( "mail2" );
    String password = request.getParameter( "password" );
    String content = request.getParameter( "content" );

    //out.println( subject );
    //out.println( writer );
    //ip
    String wip = request.getRemoteAddr();

    Connection conn = null;
    PreparedStatement pstmt = null;

    // 에러를 감별할 변수
    int flag = 1;

    try {
        Context initCtx = new InitialContext();
        Context envCtx = (Context) initCtx.lookup("java:comp/env");
        DataSource dataSource = (DataSource) envCtx.lookup("jdbc/mariadb1");

        conn = dataSource.getConnection();

        String sql = "insert into board1 values ( 0, ?, ?, ?, password( ? ), ?, 0, ?, now() )";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, subject);
        pstmt.setString(2, writer);
        pstmt.setString(3, mail);
        pstmt.setString(4, password);
        pstmt.setString(5, content);
        pstmt.setString(6, wip);

        int result = pstmt.executeUpdate();
        if ( result == 1 ) {
            // 정상
            flag = 0;
        }

        //out.println( "입력 완료" );

    } catch ( NamingException e ) {
        System.out.println( "[에러] " + e.getMessage() );
    } catch ( SQLException e ) {
        System.out.println( "[에러] " + e.getMessage() );
    } finally {
        if ( pstmt != null ) pstmt.close();
        if ( conn != null ) conn.close();
    }

    // 에러 중심의 후처리 = 자바스크립트 중심으로 처리

    out.println( "<script type='text/javascript'>" );
    if ( flag == 0 ) {
        // 정상
        out.println( "alert( '글쓰기 성공' );" );
        out.println( "location.href='./board_list1.jsp';" );
    } else {
        // 비정상
        out.println( "alert( '글쓰기 실패' );" );
        out.println( "history.back();" );
    }
    out.println( "</script>" );
%>
</body>
</html>
