// wikipedia table -> csv extractor
// specifically this is for the "united nations" table on:
// https://en.wikipedia.org/wiki/List_of_countries_by_GDP_(nominal)
// (developed and run as a snippet in the chrome dev tools)

function A(jq){ return jq.toArray(); }
function H(el){ return el.innerHTML; }
function I(_,el){ return parseInt(H(el).replace(/,/g, ""))}
function T(m){ return m[0].map((_,y)=>m.map((_,x)=>m[x][y])); } // transpose

var tbl = $("table.wikitable:eq(2)"),
    trs = t.find("tbody>tr");

trs.find("td>span").remove() // drop hidden 'sortkey', and the flag icons
var res = [A(trs.find("td:eq(0)").map(I)),
           A(trs.find("td:eq(1)").map((i,e)=>$(e).text())),
           A(trs.find("td:eq(2)").map(I))]

console.log(T(res).map(row=>row.join(",")).join("\n"))
