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
        z-index: 2;
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
		var region="영등포구 을";
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
		var region="yeongdeungpogu2";
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
	<h2 style="text-align: center;margin-top:-0.5%">선거공보물의 저작권은 해당 국회의원에게 있습니다.</h2>
	<div class="contentslining">
		<div style="position: static;top:0px;width:809px;height:1104px;overflow:hidden;border:1.5px solid lightgray;transform:translate(46%);">
			<img src="${contextPath }/resources/image/yeongdeungpogu2/영등포구을_김민석_선거공보_1.jpg" width="809" height="1104">
		</div>
		
		<div style="width:809px;height:1104px;overflow:hidden;border:1.5px solid lightgray;transform:translate(46%);">
			<img src="${contextPath }/resources/image/yeongdeungpogu2/영등포구을_김민석_선거공보_2.jpg" width="809" height="1104">
		</div>
		
		<div style="width:809px;height:1104px;overflow:hidden;border:1.5px solid lightgray;transform:translate(46%);">
			<img src="${contextPath }/resources/image/yeongdeungpogu2/영등포구을_김민석_선거공보_3.jpg" width="809" height="1104">
			<span class="point" style="top: 394px;left: 502px;height:19px;width: 102px;" id="미래공공의료 특별법" onclick="openTooltip(this)"></span>
			<span class="point" style="top: 417px;left: 502px;height:19px;width: 150px;" id="바이오 메티컬 클러스터 육성" onclick="openTooltip(this)"></span>
			<span class="point" style="top: 438px;left: 502px;height:19px;width: 71px;" id="공공의료 체제" onclick="openTooltip(this)"></span>
			<span class="point" style="top: 607px;left:174px;height:19px;width:85px;" id="소그룹 공동보육" onclick="openTooltip(this)"></span>
			<span class="point" style="top:563px;left: 542px;height:40px;width:164px;" id="지구생태보전 및 기후위기대응 특별법" onclick="openTooltip(this)"></span>
			<span class="point" style="top: 606px;left:552px;height:19px;width:86px;" id="국제탄소배출 기준" onclick="openTooltip(this)"></span>
			<span class="point" style="top: 672px;left:584px;height:19px;width:82px;" id="환경인지 예산제" onclick="openTooltip(this)"></span>
		
		<div class="blinkBox" style="top: 393px;left:320px;" onclick="openNav('재난대응 및 경제활성화지원 기본법 제ㆍ개정')" >
			<img src="${contextPath }/resources/image/logo/search.png" width="20" class="blink">
		</div>
		
		<div class="blinkBox" style="top: 426px;left:476px;" onclick="openNav('바이오 메디컬 클러스터 육성 등 공공의료 체제 지원')" >
			<img src="${contextPath }/resources/image/logo/search.png" width="20" class="blink">
		</div>
		
		
		<div class="blinkBox" style="top: 575px;left:296px;" onclick="openNav('보육 및 육아 지원특별법으로 온라인 교육체제 정비를 위한 긴급지원')" >
			<img src="${contextPath }/resources/image/logo/search.png" width="20" class="blink">
		</div>
		
		<div class="blinkBox" style="top: 582px;left:516px;" onclick="openNav('「지구생태보전 및 기후위기대응 특별법」 제정')" >
			<img src="${contextPath }/resources/image/logo/search.png" width="20" class="blink">
		</div>
		
		<div class="blinkBox" style="top: 673px;left:562px;" onclick="openNav('환경부의 부총리급 상향 및 환경인지 예산제 도입 ')" >
			<img src="${contextPath }/resources/image/logo/search.png" width="20" class="blink">
		</div>
		
		
		</div>
		
		<div style="width:809px;height:1104px;overflow:hidden;border:1.5px solid lightgray;transform:translate(46%);">
			<img src="${contextPath }/resources/image/yeongdeungpogu2/영등포구을_김민석_선거공보_4.jpg" width="809" height="1104">
		</div>
		
		<div style="width:809px;height:1104px;overflow:hidden;border:1.5px solid lightgray;transform:translate(46%);">
			<img src="${contextPath }/resources/image/yeongdeungpogu2/영등포구을_김민석_선거공보_5.jpg" width="809" height="1104">
		</div>
		
		<div style="width:809px;height:1104px;overflow:hidden;border:1.5px solid lightgray;transform:translate(46%);">
			<img src="${contextPath }/resources/image/yeongdeungpogu2/영등포구을_김민석_선거공보_6.jpg" width="809" height="1104">
		</div>
		
		<div style="width:809px;height:1104px;overflow:hidden;border:1.5px solid lightgray;transform:translate(46%);">
			<img src="${contextPath }/resources/image/yeongdeungpogu2/영등포구을_김민석_선거공보_7.jpg" width="809" height="1104">
		</div>
	
		<div style="width:809px;height:1104px;overflow:hidden;border:1.5px solid lightgray;transform:translate(46%);">
			<img src="${contextPath }/resources/image/yeongdeungpogu2/영등포구을_김민석_선거공보_8.jpg" width="809" height="1104">
		</div>
		
		<div style="width:809px;height:1104px;overflow:hidden;border:1.5px solid lightgray;transform:translate(46%);">
			<img src="${contextPath }/resources/image/yeongdeungpogu2/영등포구을_김민석_선거공보_9.jpg"width="809" height="1104">
			<span class="point" style="top: 422px;left: 239px;height:21px;width: 67px;" id="재난관리법" onclick="openTooltip(this)"></span>
			<span class="point" style="top: 412px;left: 542px;height:19px;width: 80px;" id="재난구제조치권" onclick="openTooltip(this)"></span>
			<span class="point" style="top: 433px;left: 542px;height:19px;width: 100px;" id="재난극복소득 조항" onclick="openTooltip(this)"></span>
			<span class="point" style="top: 600px;left:246px;height:21px;width:87px;" id="AI 국제 표준원" onclick="openTooltip(this)"></span>
			<span class="point" style="top:730px;left: 330px;height:21px;width: 106px;" id="공공장난감 도서관" onclick="openTooltip(this)"></span>
			<span class="point" style="top: 712px;left:644px;height:19px;width:68px;" id="고독케어센터" onclick="openTooltip(this)"></span>
		</div>
		<div style="width:809px;height:1104px;overflow:hidden;border:1.5px solid lightgray;transform:translate(46%);">
			<img src="${contextPath }/resources/image/yeongdeungpogu2/영등포구을_김민석_선거공보_10.jpg"width="809" height="1104">
			<span class="point" style="top: 239px;left: 512px;height:19px;width: 79px;" id="여성정책자문단" onclick="openTooltip(this)"></span>
			<span class="point" style="top: 379px;left: 352px;height:19px;width: 70px;" id="내일배움카드" onclick="openTooltip(this)"></span>
			<span class="point" style="top: 415px;left: 352px;height:21px;width: 95px;" id="한국형기본소득" onclick="openTooltip(this)"></span>
			<span class="point" style="top: 433px;left:352px;height:19px;width:60px;" id="인생삼모작" onclick="openTooltip(this)"></span>
			<span class="point" style="top:592px;left: 70px;height:19px;width: 67px;" id="청색경제센터" onclick="openTooltip(this)"></span>
			<span class="point" style="top: 727px;left:298px;height:19px;width:95px;" id="동물임시케어센터" onclick="openTooltip(this)"></span>
			<span class="point" style="top: 948px;left: 120px;height:19px;width: 66px;" id="베슬(인공산)" onclick="openTooltip(this)"></span>
			<span class="point" style="top: 880px;left: 560px;height:19px;width: 69px;" id="포장규제 법" onclick="openTooltip(this)"></span>

		</div>
		<div style="width:809px;height:1104px;overflow:hidden;border:1.5px solid lightgray;transform:translate(46%);">
			<img src="${contextPath }/resources/image/yeongdeungpogu2/영등포구을_김민석_선거공보_11.jpg"width="809" height="1104">
		</div>

	</div>
	
	
</body></html>