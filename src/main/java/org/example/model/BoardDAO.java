package org.example.model;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class BoardDAO {
    private DataSource dataSource;

    // DataSource 생성
    public BoardDAO() {
        try {
            Context initCtx = new InitialContext();
            Context envCtx = (Context) initCtx.lookup("java:comp/env");
            this.dataSource = (DataSource) envCtx.lookup("jdbc/mariadb1");
        } catch (NamingException e) {
            System.out.println("에러 " + e.getMessage());
        }
    }

    // board_list1.jsp의 데이터 처리
    public ArrayList<BoardTO> boardList() {
        System.out.println("boardList 호출");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;


        ArrayList<BoardTO> lists = new ArrayList<>();

        try {

            conn = this.dataSource.getConnection();

            String sql = "select seq, subject, writer, date_format( date, '%Y/%m/%d' ) date, hit, datediff( now(), date ) wgap from board1 order by seq desc";
            pstmt = conn.prepareStatement( sql );

            rs = pstmt.executeQuery();


            while( rs.next() ) {
                BoardTO to = new BoardTO();
                to.setSeq(rs.getString( "seq" ));
                to.setSubject( rs.getString( "subject" ));
                to.setWriter(rs.getString( "writer" ));
                to.setDate(rs.getString( "date" )) ;
                to.setHit(rs.getString( "hit" ));
                to.setWgap(rs.getInt( "wgap" ));

                lists.add(to);
            }

        } catch ( SQLException e ) {
            System.out.println( "[에러] " + e.getMessage() );
        } finally {
            if ( rs != null ) try{rs.close(); } catch (SQLException e) {};
            if ( pstmt != null ) try{pstmt.close(); } catch (SQLException e) {};
            if ( conn != null ) try{conn.close(); } catch (SQLException e) {};
        }

        return lists;

    }

    // board_view1.jsp의 데이터 처리
    public BoardTO boardView( BoardTO to ) {
        return null;
    }

    public void boardWrite() {}

    //데이터가 to에 담김
    //호출하면 write정보가 담김
    //flag => 성공과 실패를 정함
    public int boardWriteOk( BoardTO to ) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        // 에러를 감별할 변수
        int flag = 1;

        try {


            conn = this.dataSource.getConnection();

            String sql = "insert into board1 values ( 0, ?, ?, ?, password( ? ), ?, 0, ?, now() )";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, to.getSubject());
            pstmt.setString(2, to.getWriter());
            pstmt.setString(3, to.getMail());
            pstmt.setString(4, to.getPassword());
            pstmt.setString(5, to.getPassword());
            pstmt.setString(6, to.getWip());

            int result = pstmt.executeUpdate();
            if ( result == 1 ) {
                flag = 0;
            }


        }  catch ( SQLException e ) {
            System.out.println( "[에러] " + e.getMessage() );
        } finally {
            if ( pstmt != null ) try{pstmt.close();} catch (SQLException e) {}
            if ( conn != null ) try{conn.close();} catch (SQLException e) {}
        }

        return flag;
    }

    public BoardTO boardModify( BoardTO to ) {
        return null;
    }

    public int boardModifyOk( BoardTO to) {
        return 0;
    }

    public BoardTO boardDelete( BoardTO to ) {
        return null;
    }

    public int boardDeleteOk( BoardTO to) {
        return 0;
    }
}