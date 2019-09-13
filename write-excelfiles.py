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
		array=x.split("\t")
		for col_ind,y in enumerate(array):
			if(line_num == 0):
				open_sheet.write_string(0,col_ind+1,y)
			else:
				open_sheet.write_string(line_num,col_ind,y)
		line_num = line_num+1
oFile.close()
