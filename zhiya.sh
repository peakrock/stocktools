
function get_from_web(){
	URL="http://www.chinaclear.cn/cms-rank/queryPledgeProportion?queryDate=${last_stateday}&secCde=${CODE}"
	OFILE="${CODE}.html"
	echo $URL
	curl -s -o ${OFILE} ${URL}

	sed ':a;N;$!ba;s/\n/ /g' ${OFILE}  | grep -P "<table width=\"99%\".*?</table>" -o > ${OFILE}.tmp  && mv -f ${OFILE}.tmp ${OFILE}
	grep -P "<tr style = \"font-size:12px;\">.*?</tr>" -o  $OFILE  >> $SUMMARY
}


cur_sec=`date +%s`
cur_dayofweek=`date +%u`
cur_gape=0
if [ $cur_dayofweek -lt 6 ]; then
	cur_gape=`echo $[ ($cur_dayofweek+1)*24*3600*(-1) ]`
elif [ $cur_dayofweek -ge 6 ]; then
	cur_gape=`echo $[ ($cur_dayofweek-6)*24*3600 ]`
fi

last_stateday_sec=`echo $[$cur_sec+$cur_gape]`
last_stateday=`date --date="@$last_stateday_sec" +%Y.%m.%d`

echo $last_stateday

#LKFW  002690

SUMMARY="summary.html"
echo '<table width="99%" border="0" align="center" cellpadding="0" cellspacing="1" bordercolor="#666666" bgcolor="#666666"> <tr class="TitleBg03">    	  <td height="28" align="center" valign="middle" bgcolor="#FFFFFF" style="font-weight:bold;">证券代码</td>    	  <td align="center" valign="middle" bgcolor="#FFFFFF" style="font-weight:bold;">证券简称</td>    	  <td align="center" valign="middle" bgcolor="#FFFFFF" style="font-weight:bold;">无限售股份质押数量(万)</td>    	  <td align="center" valign="middle" bgcolor="#FFFFFF" style="font-weight:bold;">有限售股份质押数量(万)</td>    	  <td align="center" valign="middle" bgcolor="#FFFFFF" style="font-weight:bold;">A股总股本(万)</td>    	  <td align="center" valign="middle" bgcolor="#FFFFFF" style="font-weight:bold;">质押笔数</td>    	  <td align="center" valign="middle" bgcolor="#FFFFFF" style="font-weight:bold;">质押比例(%)</td> 	      </tr> ' > $SUMMARY

for i in $* 
do
	echo $i
	CODE=$i
	get_from_web
done


if [ "$1" == "" ]; then
	while read line
	do
		CODE=$line
		get_from_web
	done
fi
#echo $str


echo ' </table>' >>$SUMMARY