drop program 0_SURG_CASE_DTS_1 go
create program 0_SURG_CASE_DTS_1
 
prompt
	"Output to File/Printer/MINE" = "MINE"   ;* Enter or select the printer or file name to send this report to.
	, "Start Date:" = "SYSDATE"
	, "End Date:" = "SYSDATE"
 
with OUTDEV, StartDt, EndDt
 
;declare file_name = vc
;set file_name = "surg_case_extract_1213.csv"
 
free record surg
record surg (
			1 QUAL[*]
				2 CREATE_DT = vc
				2 START_DT = vc
				2 CASE_NBR = vc
				2 DIFF = f8
				2 SURG_AREA = vc
				2 PRIORITY = vc
				2 TYPE = vc
			)
 
SELECT DISTINCT into "nl:"
 
FROM
	SURGICAL_CASE   S
	, sch_event_detail   sed
	, sch_event_detail   sed2
 
PLAN S where s.surg_start_dt_tm between cnvtdatetime($STARTDT)
 
						 and cnvtdatetime($ENDDT)
and s.active_ind = 1
 
JOIN SED WHERE SED.sch_event_id = outerjoin(s.sch_event_id)
and sed.oe_field_meaning_id = outerjoin(127)
and sed.active_ind = outerjoin(1)
 
JOIN SED2 WHERE SED2.sch_event_id = outerjoin(s.sch_event_id)
and sed2.oe_field_meaning_id = outerjoin(126)
and sed2.active_ind = outerjoin(1)
 
ORDER BY
	s.surg_start_dt_tm, s.surg_case_id
 
Head report
count = 0
 
Head s.surg_case_id
count = count + 1
STAT = ALTERLIST(SURG->QUAL,count)
 
SURG->QUAL[count].CREATE_DT = format(s.create_dt_tm,"MM-DD-YY hh:mm;;Q")
SURG->QUAL[count].START_DT =  format(s.surg_start_dt_tm,"MM-DD-YY hh:mm;;Q")
SURG->QUAL[count].CASE_NBR = s.surg_case_nbr_formatted
SURG->QUAL[count].DIFF = datetimediff(s.create_dt_tm,s.surg_start_dt_tm,3)
SURG->QUAL[count].SURG_AREA = uar_get_code_display(s.surg_area_cd)
SURG->QUAL[count].PRIORITY = sed.oe_field_display_value
SURG->QUAL[count].TYPE = sed2.oe_field_display_value
 
with nocounter
 
 
 
SELECT INTO $OUTDEV
		CREATE_DT = trim(substring(1,25,SURG->QUAL[d1.seq].CREATE_DT))
		,START_DT = trim(substring(1,25,SURG->QUAL[d1.seq].START_DT))
		,DIFF_HRS = SURG->QUAL[d1.seq].DIFF
		,CASE_NBR = trim(substring(1,25,SURG->QUAL[d1.seq].CASE_NBR))
		,SURG_AREA = trim(substring(1,25,SURG->QUAL[d1.seq].SURG_AREA))
		,PRIORITY = trim(substring(1,25,SURG->QUAL[d1.seq].PRIORITY))
		,PT_TYPE = trim(substring(1,25,SURG->QUAL[d1.seq].TYPE))
 
		FROM (DUMMYT D1 WITH SEQ = SIZE(SURG->QUAL,5))
		plan d1
 
		with format,separator = " ", time = 60
 
end
go
 
