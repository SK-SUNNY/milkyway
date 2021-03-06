<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"  %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SK SUNNY 은하수</title>
    <style>
       @import url(http://fonts.googleapis.com/earlyaccess/notosanskr.css);
        html, body{
            height:100%;
            margin:0;
            overflow:hidden;
            font-family: 'Noto Sans KR', sans-serif;   
        }
        
        hr{ 
            border: 2px solid #ededed;
        }
        a{
            padding:0;
            margin:0;
            text-decoration: none;
        }
        div{
            display: flex;
            padding-top:0;
            padding-left:1%;
        }
        div a{
            padding:0;
            margin:0;
            padding-top:15px;
            flex:1;
        }
        #id-이낙연:hover, #id-권영세:hover{
            transform: scale( 1.02 );
            transition: all 0.1s ease;
        }
        #id-이낙연 img{
            text-align: right;
            padding-right:0;
            width:370px;
        }
        #id-권영세 img{
            text-align:left;
            width:370px;
        }
        .menu{
            display:flex;
            text-align:center;
            margin:0;
            padding:0;
            font-size:large;
            cursor: pointer;
        }
        #menu_1 {
           flex:1;
           margin-bottom: 2%;
           padding-top: 2%;
        }
        #menu_2 {
           flex:1;
        }
        #menu_3 {
           flex:1;
           margin-bottom: 2%;
           padding-top: 2%;
        }
        #menu_1:hover{
            font-weight: 600;
            transition: all 0.2s ease;
        }
        #menu_2 img{
            width:220px;
        }
        #menu_3:hover{
            font-weight: 600;
            transition: all 0.2s ease;
        }
        .logo{
            padding-top:2%;
            padding-left:1%;
            text-align:left;
            font-weight: 900;
            font-size:4em;
            line-height:2 em;
            cursor:pointer;
            color:black;
        }
        .contents_area{
            padding-left:5%;
            margin:0;
        }

    </style>
</head>
<body>

    <div class="menu">
        <a id="menu_1" href="${contextPath }/main" style="text-decoration:none ;color:black">은하수 프로젝트</a>
        <a id="menu_2" href="${contextPath }/main">
            <img src="${contextPath }/resources/image/logo/로고2.jpg">
        </a>
        <a id="menu_3" href="${contextPath }/menu2" style="text-decoration:none ;color:black">제21대 서울시 국회의원 선거 공보물</a>
    </div>
    <hr>
    <!-- 콘텐츠 영역 -->
    <div class="contents_area">
        <a class="logo" href="${contextPath }/main">제21대<br>서울시 국회의원<br>약속 보러가기</a>
        <a id="id-이낙연" href="${contextPath }/election/jongnogu">
            <img src="${contextPath }/resources/image/id_card/이낙연.png" target="_parent">
        </a>
        <a id="id-권영세" href="${contextPath }/election/yongsangu">
            <img src="${contextPath }/resources/image/id_card/권영세.png" target="_parent">
        </a>
    </div>


    
</body>
</html>