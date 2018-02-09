

## curl -o 1.html  http://quote.eastmoney.com/stocklist.html
## curl -o 1.html  http://quote.eastmoney.com/stocklist.html

curl -s -o 1.html  http://quote.eastmoney.com/stocklist.html && sed ':a;N;$!ba;s/\n/ /g' 1.html | grep -P "\([0-9]{6}\)" -o | grep -P "[0-9]{6}" -o