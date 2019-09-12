import os
import glob
import xlsxwriter as xw

oFile = xw.Workbook('Annotated_Peaks.xlsx')

annot_file_list = [ f for f in glob.glob("*annot*") ]
for files in annot_file_list:
	line_num=0
	F = open(files,'r')
	sheet = files.split('.')[0]
	open_sheet = oFile.add_worksheet(sheet)
	for x in F.readlines():
		if(line_num == 1):
			open_sheet.write_row(0,1,x)
		else:
			open_sheet.write_row(line_num,0,x)
		line_num = line_num+1
oFile.close()

