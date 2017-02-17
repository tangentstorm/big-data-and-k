# program to clean up csv
# mostly i used http://wikitable2csv.ggor.de/ to import csv from wikipedia,
# then did manual cleanup in emacs, but this was easier for unquoting numbers with commas
import sys
import csv

def clean_num(val):
    res = val.replace(",","")
    return res if res.isdigit() else val

if __name__=="__main__":
    for row in csv.reader(sys.stdin):
        print ",".join(clean_num(val).strip() for val in row)
