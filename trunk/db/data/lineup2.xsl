<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" version="4.0" encoding="UTF-8" indent="yes"/>

<!-- xsl:key name="program-unique" match="Program" use="concat(../DatabaseID,'::',Frequency,'::',ProgramNumber,'::',GuideNumber,'::',GuideName)" / -->
<!-- xsl:key name="program-duplicates" match="Program" use="concat(Frequency,'::',ProgramNumber,'::',GuideNumber,'::',GuideName)" / -->

<xsl:variable name="sortby">
<xsl:if test="not(//Debug)">GuideNumber</xsl:if>
</xsl:variable>

<xsl:template name="channels">
	<table id="table_lineup_{DatabaseID}" class="side">
	<thead>
	<tr><th class="label" colspan="6">
	<xsl:if test="Distance != ''">
	Distance: <xsl:value-of select="Distance"/>km<br/>
	Span: <xsl:value-of select="Span"/>km<br/>
	</xsl:if>
	<a href="#lineup_{DatabaseID}" onclick="select_lineup('lineup_{DatabaseID}'); return false;">&#9660;<xsl:value-of select="DisplayName"/>&#9660;</a>
	</th></tr>

	<tr class="sort">
	<th class="mod">Type</th>
	<th class="channel">Channel</th>
	<th class="virtual">Virtual</th>
	<th class="guide_name">Name</th>
	<th class="resolution">Resolution</th>
	<th class="aspect">Aspect</th>
	</tr>
	</thead>
	<tbody>
	<!-- [count(. | key('program-unique', concat(../DatabaseID,'::',Frequency,'::',ProgramNumber,'::',GuideNumber,'::',GuideName))[1]) = 1] -->
	<xsl:for-each select="Program">
		<xsl:sort select="*[name() = $sortby]=''" />
                <xsl:sort select="*[name() = $sortby]" data-type="number" />

                <xsl:sort select="PhysicalChannel" data-type="number" />
                <xsl:sort select="ProgramNumber" data-type="number" />

		<xsl:variable name="channel">
			<xsl:choose>
				<xsl:when test="PhysicalChannel"><xsl:value-of select="PhysicalChannel"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="Frequency div 1000000"/>MHz</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="GuideName">
			<xsl:choose>
				<xsl:when test="GuideName != ''"><xsl:value-of select="GuideName"/></xsl:when>
				<xsl:otherwise>UNKNOWN</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="samefreq">
		samefreq
		</xsl:variable>

		<tr class="mod-{Modulation} {$samefreq}">

		<td class="mod">
		<xsl:value-of select="Modulation"/>
		</td>

		<td class="channel">
		<a title="Frequency: {Frequency div 1000000}MHz"><xsl:value-of select="$channel"/>
		<xsl:if test="ProgramNumber != 0">-<xsl:value-of select="ProgramNumber"/></xsl:if>
		</a>
		</td>

		<td class="virtual">
		<xsl:value-of select="GuideNumber"/>
		</td>

		<td class="guide_name">
		<a title="{Notes}"><xsl:value-of select="$GuideName"/></a>
		</td>

		<td class="resolution">
		<xsl:for-each select="Resolution">
			<xsl:value-of select="."/><br/>
		</xsl:for-each>
		</td>

		<td class="aspect">
		<xsl:for-each select="Aspect">
			<xsl:value-of select="."/><br/>
		</xsl:for-each>
		</td>

		<td class="image">
		<xsl:for-each select="Snapshot">
			<xsl:variable name="dir">
			<xsl:value-of select="format-number(. mod 100, '00')"/>
			</xsl:variable>
			<xsl:variable name="server">http://img.lineupui.silicondust.com</xsl:variable>
			<a href="{$server}/snapshots/{$dir}/snapshot_{.}.jpg"><img id="thumb_{.}" alt=""/></a>
		</xsl:for-each>
		</td>

		<!-- xsl:if test="//Debug = 1">
		<td>
		<xsl:variable name="dupes" select="count(key('program-duplicates', concat(Frequency,'::',ProgramNumber,'::',GuideNumber,'::',GuideName))) - 1"/>
		=<xsl:value-of select="$dupes"/><br/>
		</td>
		</xsl:if -->

		</tr>

	</xsl:for-each>
	</tbody>
	</table>
</xsl:template>

<xsl:template match="/">
	<html>
		<head>
			<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
			<title><xsl:value-of select="//Location"/> Lineup Results</title>
			<link rel="stylesheet" type="text/css" href="/hdhomerun/lineup.css" />
			<script type="text/javascript" src="/hdhomerun/sorttable.js"/>
			<script type="text/javascript">
			function foreach_lineup(fn) {
				var lineup = document.lineup.lineup_selected;
				for (var i = 0; i &lt; lineup.options.length; i++) {
					var item = lineup.options[i].value;
					fn(lineup, item, i);
				}
			}

			function lineup_select_fn(lineup, item, i) {
				var hash = window.location.href.split('#')[1];
				if (item == hash) {
					lineup.selectedIndex = i;
				}
			}

			function lineup_change_fn(lineup, item, i) {
				var index = lineup.selectedIndex;
				var selected = lineup.options[index].value;
				var e = document.getElementById("table_"+item);
				if (item != selected) {
					e.className = "hide";
				} else {
					e.className = "";
					location.replace("#" + selected);
					loadimages(e);
				}
			}

			function lineup_sidebyside_fn(lineup, item, i) {
				var index = lineup.selectedIndex;
				var selected = lineup.options[index].value;
				var e = document.getElementById("table_"+item);
				e.className = "side";
				location.replace("#sidebyside");
			}

			function loadimages(e) {
				if (e.loaded) return;
				var img=e.getElementsByTagName('img');
				for (var i=0;i &lt; img.length;i++) {
					var server = "http://img.lineupui.silicondust.com";
					var id = String(img[i].id).replace(/^thumb_/, "");
					var dir = id % 100;
					var path = server + "/thumbnails/" + dir + "/thumbnail_" + id + ".jpg";
					img[i].src = path;
				}
				e.loaded = 1;
			}

			function select_lineup(lineup) {
				location.replace("#" + lineup);
				foreach_lineup(lineup_select_fn);
				foreach_lineup(lineup_change_fn);
			}
			</script>
		</head>
		<body>
		<xsl:choose>
			<xsl:when test="//error">
			<div class="error"><xsl:value-of select="//error"/></div>
			</xsl:when>
			<xsl:otherwise>
				<form name="lineup" class="hide">
				<select name="lineup_selected" onChange="foreach_lineup(lineup_change_fn)">
				<xsl:for-each select="//Lineup">
				<xsl:sort select="ProviderName"/>
				<option value="lineup_{DatabaseID}"><xsl:value-of select="DisplayName"/> (<xsl:value-of select="count(Program)"/> programs)</option>
				</xsl:for-each>
				</select>
				&#9664; Provider
				| <a href="#sidebyside" onclick="foreach_lineup(lineup_sidebyside_fn); return false;">grid view</a>
				</form>
				<br/>
				<xsl:for-each select="//Lineup">
				<xsl:sort select="ProviderName"/>
					<xsl:call-template name="channels" />
				</xsl:for-each>
				<script type="text/javascript">
				var hash = window.location.href.split('#')[1];
				document.lineup.className = "header";
				if (hash != "sidebyside") {
					foreach_lineup(lineup_select_fn);
					foreach_lineup(lineup_change_fn);
				}
				</script>

			</xsl:otherwise>
		</xsl:choose>
		</body>
	</html>
</xsl:template>
</xsl:stylesheet>
