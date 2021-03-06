<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"  %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<!DOCTYPE html>
<html>
<head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>SK SUNNY 은하수</title>
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/fixedmenutab.css"/>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">

<style>
	html,body{
		margin:0;
		font-family: 'Noto Sans KR', sans-serif;
	}

	.sidenav {
		height:100%;
		width: 0;
		position: fixed;
		z-index:333;
		top: 0;
		left: 0;
		background:#f5f5f5;
		overflow-x: hidden;
		transition:0.5s ease-in-out;
		padding-top: 60px;
	}
	.sidenav a {
		padding: 8px 8px 8px 32px;
		text-decoration: none;
		font-size: 18px;
		color: #5d5d5d;
		display: block;
		transition: 0.2s ease-in-out;
	}
	
	.articleinfo {
		padding: 8px 8px 8px 32px;
		font-size: 12px;
		color: gray;
	
	}
	
	.sidenav a:hover, .offcanvas a:focus {
		color: #000;
	}
	#closebtn {
		position: absolute;
		top: 0;
		right: 15px;
		color: #5d5d5d;
		cursor :pointer;
		font-size: 36px !important;
		margin-left: 50px;
	}
	
	#closebtn:hover {
		color: #000;
	}
	
	/* 미디어쿼리 적용 */
	@media screen and (max-height:450px) {
		.sidenav {
			padding-top:15px;
		}
		.sidenav a {
			font-size: 18px;
		}
	}
	
    .point {
		cursor:pointer;
		background:#ffea5b;
		position:absolute;
		opacity:40%;
	}

	.point:hover {
		background:#efd000;
	}
	
    .link {
		cursor:pointer;
		background:#ffc107;
		position:absolute;
		opacity:40%;
	}

	.link:hover {
		background:#ff9007;
	}

	.tooltip {
		background:#edf691;
		color:black;
		width:35%;
		font-size:16px;
		padding:10px;
		position:absolute;
		box-shadow:4px 4px 6px gray;
        z-index: 30;
	}

    .triangle {
        display:inline-block;
        position: absolute;
        border-style: solid;
        border-color:transparent transparent #edf691 transparent;
        border-width: 14px;
        z-index: 2;
    }
	
	.contentslining{
		position:relative;
		top:0;
	}
	
    .blinkBox {
		cursor: pointer;
		position:absolute;
		width:70px;
		height:70px;
	}
</style>

<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript">  
	var idx=-1;
	var chkTooltip=0; //툴팁 열려있는지 체크하는 변수
	var relativeTop,relativeLeft;
	var relativeTop_tmp,relativeLeft_tmp; //열려있는 툴팁박스의 top, left (이미 선택한 단어의 툴팁인지 아닌지를 확인하기 위함)
	var shown = true;

	function toggle() {
		var blink_element= $('.blink');
		if(shown==true) {
			blink_element.hide();
			shown=false;
		}
		else {
			blink_element.show();
			shown=true;
		}
	}


	setInterval(toggle,300);
	
	var sideText='<h3 id="linkName" style="padding: 8px 8px 8px 32px;"></h3><span id="closebtn" onclick="javascript:closeNav()">x</span>';
	var word_tmp=''; //(side bar) 이전에 누른 단어를 또 눌렀는지 확인하기 위한 변수
	function getNewsLink(linkName) { //ajax로 sidebar 기사 링크 가져오기
		var region="광진구 갑";
		$.ajax({
			type:"get",
			url:"${contextPath}/election/getNewsLink",
			data:{region : region,
				  word : linkName	
			},
	         success:function(data) {
	             document.getElementById('mysidenav').style.width = '360px';
	             var text=sideText;

	             $.each(data, function(idx,val) {
	                   text+='<a href="'+val.link+'">'+val.title+'</a><span class="articleinfo">'+val.news+'</span>';   
	             });
	             document.getElementById('mysidenav').innerHTML=text;
	             document.getElementById('linkName').innerHTML="'"+linkName+"'와 관련된 기사";
	             word_tmp=linkName; //저장되어 있는 단어 업데이트
	          },
	          error:function(data) {
	             alert("오류가 발생했습니다. 다시 시도해주세요.")
	          }
	       });
	}
	
	function openNav(linkName) {
		if(linkName!=word_tmp) { //방금 눌렀던 단어를 또 누르는 경우가 아닐 때 & 처음 사이드바 열 때
			getNewsLink(linkName);
		}
	}
	
	function closeNav() {
		document.getElementById('mysidenav').style.width = '0';
		document.getElementById('mysidenav').innerHTML=sideText;
		word_tmp=''; //저장되어 있는 단어 초기화
	}

	function openTooltip(e) {
		idx=$('.point').index($(e));	
		var val=$('.point')[idx];
		var word=val.getAttribute('id');
		var height=val.offsetHeight;
		var clientRect=val.getBoundingClientRect();
		relativeTop=(window.pageYOffset)+clientRect.top+height-9;
		relativeLeft=(window.pageXOffset)+clientRect.left;
		
		if(chkTooltip==1) { //툴팁 박스가 열려있다면
			if(relativeTop_tmp==relativeTop && relativeLeft_tmp==relativeLeft) { //이미 선택되어 있는 단어를 또 선택했을 때는 element 삭제
				document.getElementById("hello").remove();
    			document.getElementById("hello2").remove();
				chkTooltip=0;
				return;
			}
			else { //이미 선택되어 있는 단어가 아닌 단어를 선택했을 때는 meaning select&툴팁 추가
				document.getElementById("hello").remove();
        		document.getElementById("hello2").remove();
				getMeaning(word);
			}
			
		}
		
		else { //툴팁박스가 닫혀있다면  meaning select&툴팁 추가
			getMeaning(word);
		}
	}
	
	function getMeaning(word) { //ajax로 meaning select & 툴팁 추가
		var region="gwangjingu";
		$.ajax({
			type:"get",
			url:"${contextPath}/election/getMeaning",
			data:{region : region,
				  word : word	
			},
			success:function(data) {
				var element2=document.createElement("div");
				element2.className="triangle";
				element2.id="hello2";
				element2.style.top=relativeTop+"px";
				element2.style.left=relativeLeft+"px";
				document.body.appendChild(element2);
				relativeTop_tmp=relativeTop; //현재 툴팁의 top위치를 tmp에 저장
				relativeLeft_tmp=relativeLeft; //현재 툴팁의 top위치를 tmp에 저장

				var element=document.createElement("div");
				element.id="hello";
				element.className="tooltip";
				element.innerHTML=data.meaning;
				
				if(data.link!="") {
					if(data.link[0]=='h') {
						element.innerHTML+="<br><br><span style='font-size:12px;font-weight:bold;'>참고 및 출처</span><br><a style='font-size:9.5px;word-break:break-all;' href='"+data.link+"'>"+data.link+"</a>";
					}
					else {
						element.innerHTML+="<br><br><span style='font-size:12px;font-weight:bold;'>참고 및 출처</span><br><span style='font-size:9.5px;'>"+data.link+"</span>";
					}
				}
				relativeTop=relativeTop+20;
				relativeLeft=relativeLeft-30;
				element.style.top=relativeTop+"px";
				element.style.left=relativeLeft+"px";
				document.body.appendChild(element);
				chkTooltip=1;
			},
			error:function(data) {
				alert("오류가 발생했습니다. 다시 시도해주세요.")
			}
		});
	}
</script>

</head>
<body style="font-family: 'Noto Sans KR', sans-serif;">

	    <!-- 메뉴 -->
		<nav role="navigation">
			<ul id="main-menu">
				<li><a href="${contextPath }/" style="padding:0;"><img src="${contextPath }/resources/image/logo/로고.png" style="width:240px;transform:translateY(-16%);"></a></li>
				<li><a href="#">은하수 프로젝트</a>
				<ul id="sub-menu">
					<li><a href="${contextPath }/introduce" aria-label="subemnu">은하수 소개</a></li>
					<li><a href="${contextPath }/guideline" aria-label="subemnu">선거 가이드라인</a></li>
				</ul>
				</li>
				<li><a href="#">제21대 국회의원 공약보기</a>
				<ul id="sub-menu">
					<li><a href="${contextPath }/" aria-label="subemnu">선거공보물 보기</a></li>
					<li><a href="${contextPath }/category" aria-label="subemnu">분야별 공약 보기</a></li>
				</ul>
				</li>
				<li><a href="${contextPath }/achievementRate">지난 공약 이행률 보기</a></li>
	
			</ul>
		  </nav>

	<!-- 사이드바 -->
	<div id="mysidenav" class="sidenav" style="float:left;">
		<h3 id="linkName" style="padding: 8px 8px 8px 32px;"></h3>
		<span id="closebtn" onclick='javascript:closeNav()'>x</span>
	</div>

	
	<div style="height: 100px;"></div>
	<div class="contentslining">
	<h2 style="text-align: center;margin-top:-0.5%">선거공보물의 저작권은 해당 국회의원에게 있습니다.</h2>
		<div style="position:absolute;top:0px;width:700px;height:984px;overflow:hidden;border:1.5px solid lightgray;transform:translate(58%);">
	    <img src="${contextPath }/resources/image/gwangjingu/광진구갑_전혜숙_선거공보_1.jpg" width="700" height="984">
	</div>
    
	<div style="position:absolute;top:994px;width:700px;height:984px;overflow:hidden;border:1.5px solid lightgray;transform:translate(58%);">
	    <img src="${contextPath }/resources/image/gwangjingu/광진구갑_전혜숙_선거공보_2.jpg" width="700" height="984">
	</div>
	
	<div style="position:absolute;top:1988px;width:700px;height:984px;overflow:hidden;border:1.5px solid lightgray;transform:translate(58%);">
	    <img src="${contextPath }/resources/image/gwangjingu/광진구갑_전혜숙_선거공보_3.jpg" width="700" height="984">
	</div>
	
	<div style="position:absolute;top:2982px;width:700px;height:984px;overflow:hidden;border:1.5px solid lightgray;transform:translate(58%);">
		<img src="${contextPath }/resources/image/gwangjingu/광진구갑_전혜숙_선거공보_4.jpg" width="700" height="984">
	</div>
	
	<div style="position:absolute;top:3976px;width:700px;height:984px;overflow:hidden;border:1.5px solid lightgray;transform:translate(58%);">
        <img src="${contextPath }/resources/image/gwangjingu/광진구갑_전혜숙_선거공보_5.jpg" width="700" height="984">
        <span class="point" style="top: 283px;left: 143px;height:17px;width: 87px;" id="최고고도지구" onclick="openTooltip(this)"></span>
		<span class="point" style="top: 283px;left: 282px;height:17px;width: 46px;" id="종상향" onclick="openTooltip(this)"></span>
		<span class="point" style="top: 543px;left:143px;height:16px;width: 100px;" id="전선지중화사업" onclick="openTooltip(this)"></span>
	
		<div class="blinkBox" style="top: 283px;left:525px;" onclick="openNav('2. 최고고도지구해제및종상향문제해결:도시발전기반조성')" >
			<img src="${contextPath }/resources/image/logo/search.png" width="20" class="blink">
		</div>
		
				<div class="blinkBox" style="top: 457px;left:102px;" onclick="openNav('1. 노후 주민센터 신축 : 군자동·구의2동·광장동 주민센터를 복합청사로 신축해 생활 편의성과 삶의 질 향상')" >
			<img src="${contextPath }/resources/image/logo/search.png" width="20" class="blink">
		</div>
		
		<div class="blinkBox" style="top: 544px;left:101px;" onclick="openNav('4. 전선지중화사업 지속 추진 : 보다 쾌적한 주거환경 조성')" >
			<img src="${contextPath }/resources/image/logo/search.png" width="20" class="blink">
		</div>
	</div>
	
	<div style="position:absolute;top:4970px;width:700px;height:984px;overflow:hidden;border:1.5px solid lightgray;transform:translate(58%);">
        <img src="${contextPath }/resources/image/gwangjingu/광진구갑_전혜숙_선거공보_6.jpg" width="700" height="984">
        <span class="point" style="top: 282px;left: 298px;height:17px;width: 96px;" id="LED조명투광기" onclick="openTooltip(this)"></span>
		<span class="point" style="top: 282px;left: 440px;height:17px;width: 132px;" id="스마트횡단안전시스템" onclick="openTooltip(this)"></span>
		<span class="point" style="top: 328px;left:221px;height:16px;width: 198px;" id="지역 맞춤형 범죄예방디자인" onclick="openTooltip(this)"></span>
		<span class="point" style="top: 499px;left: 75px;height:16px;width: 111px;" id="육아종합지원센터" onclick="openTooltip(this)"></span>
        <span class="point" style="top: 565px;left: 225px;height:16px;width: 100px;" id="친환경무상급식" onclick="openTooltip(this)"></span>
	
		<div class="blinkBox" style="top: 327px;left:511px;" onclick="openNav('4. 안전한 치안환경 구축 : 지역 맞춤형 범죄예방디자인설계(CEPTED) 적용')" >
			<img src="${contextPath }/resources/image/logo/search.png" width="20" class="blink">
		</div>
		
		<div class="blinkBox" style="top: 477px;left:395px;" onclick="openNav('1. 열린육아방 확충 : 양육부담 덜어주는 육아환경 마련')" >
			<img src="${contextPath }/resources/image/logo/search.png" width="20" class="blink">
		</div>
	</div>
	
	<div style="position:absolute;top:5964px;width:700px;height:984px;overflow:hidden;border:1.5px solid lightgray;transform:translate(58%);">
		<img src="${contextPath }/resources/image/gwangjingu/광진구갑_전혜숙_선거공보_7.jpg" width="700" height="984">
		<span class="point" style="top: 569px;left: 313px;height:17px;width: 112px;" id="온종일 돌봄체계" onclick="openTooltip(this)"></span>
		<span class="point" style="top: 666px;left: 359px;height:17px;width: 88px;" id="구직촉진수당" onclick="openTooltip(this)"></span>
		<span class="point" style="top: 870px;left:423px;height:16px;width: 110px;" id="창업 인큐베이터" onclick="openTooltip(this)"></span>
	</div>

	<div style="position:absolute;top:6958px;width:700px;height:984px;overflow:hidden;border:1.5px solid lightgray;transform:translate(58%);">
		<img src="${contextPath }/resources/image/gwangjingu/광진구갑_전혜숙_선거공보_8.jpg" width="700" height="984">
        <span class="point" style="top: 594px;left: 94px;height:16px;width: 88px;" id="온누리상품권" onclick="openTooltip(this)"></span>
		<span class="point" style="top: 594px;left: 188px;height:16px;width: 101px;" id="지역사랑상품권" onclick="openTooltip(this)"></span>
		<span class="point" style="top: 616px;left: 303px;height:17px;width: 172px;" id="간이과세자 기준금액 상향" onclick="openTooltip(this)"></span>
        <span class="point" style="top: 642px;left: 94px;height:16px;width: 72px;" id="상가임차인" onclick="openTooltip(this)"></span>
        <span class="point" style="top: 691px;left: 304px;height:16px;width: 61px;" id="부실채권" onclick="openTooltip(this)"></span>
        <span class="point" style="top: 893px;left: 286px;height:16px;width: 280px;" id="생활건강 실천 포인트제도 (건강 인센티브제)" onclick="openTooltip(this)"></span>

    </div>
	
	<div style="position:absolute;top:7952px;width:700px;height:984px;overflow:hidden;border:1.5px solid lightgray;transform:translate(58%);">
		<img src="${contextPath }/resources/image/gwangjingu/광진구갑_전혜숙_선거공보_9.jpg" width="700" height="984">
		<span class="point" style="top: 478px;left: 72px;height:28px;width: 98px;" id="민식이법" onclick="openTooltip(this)"></span>
		<span class="point" style="top: 478px;left: 182px;height:28px;width: 152px;" id="태호,유찬이법" onclick="openTooltip(this)"></span>
	</div>
	
	<div style="position:absolute;top:8946px;width:700px;height:984px;overflow:hidden;border:1.5px solid lightgray;transform:translate(58%);">
		<img src="${contextPath }/resources/image/gwangjingu/광진구갑_전혜숙_선거공보_10.jpg" width="700" height="984">
		<span class="point" style="top: 600px;left: 72px;height:28px;width: 228px;" id="소방관 국가직전환 법안" onclick="openTooltip(this)"></span>
	</div>
	
	<div style="position:absolute;top:9940px;width:700px;height:984px;overflow:hidden;border:1.5px solid lightgray;transform:translate(58%);">
	    <img src="${contextPath }/resources/image/gwangjingu/광진구갑_전혜숙_선거공보_11.jpg" width="700" height="984">
	</div>
	</div>

</body>
</html>