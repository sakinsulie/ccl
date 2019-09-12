drop program 14_st_lastdoc_pe_dynD_PwrN:dba go
create program 14_st_lastdoc_pe_dynD_PwrN:dba
 \\Client\C$\CernerWorks\ccl_backup\14_st_lastdoc_pe_dynd_pwrn.prg
;prompts
prompt
	"Output to File/Printer/MINE" = "MINE"
 
with OUTDEV
 
/*the embedded rtf commands at top of document */
declare rhead = vc with protect, constant(concat("{\rtf1\ansi \deff0",
                                                 "{\fonttbl",
                                                 "{\f0\fmodern\Courier New;}{\f1 Arial;}}",
                                                 "{\colortbl;",
                                                 "\red0\green0\blue0;",
                                                 "\red255\green255\blue255;",
                                                 "\red0\green0\blue255;",
                                                 "\red0\green255\blue0;",
                                                 "\red255\green0\blue0;}\deftab2520 "))
 
/*color 0 is the default device color, color 1 is "clear" or white, color 2 is black, color 3 is red, color 4 is green,
color 5 is blue.  refer to any rtf reference for more color info. */
set rh8r = "\plain \f0 \fs16 \cb2 \pard\s8 "
/*the embedded rtf commands at top of document for a 1st line reqular */
set rh2r = "\plain \f0 \fs20 \cb2 \pard\sl0 "
/*the embedded rtf commands at top of document for a 1st line bold */
set rh2b = "\plain \f0 \fs20 \b \cb2 \pard\sl0 "
/*the embedded rtf commands at top of document for a 1st line bold-underlined */
set rh2bu = "\plain \f0 \fs18 \b \ul \cb2 \pard\sl0 "
/*the embedded rtf commands at top of document for a 1st line underlined */
set rh2u = "\plain \f0 \fs18 \u \cb2 \pard\sl0 "
/*the embedded rtf commands at top of document for a 1st line italized */
set rh2i = "\plain \f0 \fs18 \i \cb2 \pard\sl0 "
/*the end of line embedded rtf command */
set reol = "\par "
/*the tab embedded rtf command */
set rtab = "\tab "
/*the embedded rtf commands for normal word(s) */
declare wr = c22 with protect, constant("\plain \f0 \fs18 \cb2 ")
/*the embedded rtf commands for bold word(s) */
declare wb = c25 with protect, constant("\plain \f0 \fs18 \b \cb2 ")
/*the embedded rtf commands for normal word(s) */
declare wrr = c22 with protect, constant("\plain \f1 \fs18 \cb2 ")
/*the embedded rtf commands for bold word(s) */
declare wbb = c25 with protect, constant("\plain \f1 \fs18 \b \cb2 ")
/*the embedded rtf commands for bold-underline word(s)*/
declare wbbu = c29 with protect, constant("\plain \f1 \fs20 \b \ul \cb2 ")
 
/*the embedded rtf commands for underlined word(s) */
declare wu = c26 with protect, constant("\plain \f0 \fs18 \ul \cb2 ")
/*the embedded rtf commands for italics word(s) */
declare wi = c25 with protect, constant("\plain \f0 \fs18 \i \cb2 ")
/*the embedded rtf commands for bold-italics word(s) */
declare wbi = c28 with protect, constant("\plain \f0 \fs18 \b \i \cb2 ")
/*the embedded rtf commands for bold-underline-italics word(s) */
declare wiu = c29 with protect, constant("\plain \f0 \fs18 \i \ul \cb2 ")
/*the embedded rtf commands for italics word(s) */
declare wbiu = c32 with protect, constant("\plain \f0 \fs18 \b \ul \i \cb2 ")
/*the embedded rtf commands for bold-underline word(s)*/
declare wbu = c29 with protect, constant("\plain \f0 \fs20 \b \ul \cb2 ")
 
/* the embedded rtf commands to set text to bold red */
set wred = "  \cf5 "
set wblack = "  \cf1 "
 
/*the embedded rtf commands to end the document*/
set rtfeof = "}"
 
;
RECORD REPLY (
  1 TEXT = c64000
  1 STATUS_DATA
    2 STATUS = C1
    2 SUBEVENTSTATUS [1]
      3 OPERATIONNAME = C25
      3 OPERATIONSTATUS = C1
      3 TARGETOBJECTNAME = C25
      3 TARGETOBJECTVALUE = VC
)
 
;output variable...more important if we are going to ascii
declare tmp_str = vc
 
declare html_bdh = vc
declare rtf_bhd = vc
declare crtoken      = c4 with protect,constant("%CR%")
declare tbtoken      = c4 with protect,constant("%TB%")
declare eoftoken     = c5 with protect,constant("%EOF%")
 
declare len        = i4       with protect
declare retlen     = i4       with protect
declare blob_out   = c64000   with protect
declare blob_out2  = c64000   with protect
declare tempvc     = vc       with protect
declare x          = i4       with protect
declare ocfcomp    = f8       with protect,constant(728.0)        ; (120) OCFCOMP      OCF Compression
 
;output format variables from codeset 23
declare xhtml_cd    = f8      with protect,constant(252522796.0)  ; (23)  XHTML        XHTML
declare rtf_cd      = f8      with protect,constant(125.0)        ; (23)  RTF          RTF
declare ah_cd       = f8      with protect,constant(114.0)        ; (23)  AH           AH
 
;server application call constants for tdbexecute call for ConvertFormattedText request
declare appnum      = i4      with protect,constant(3202004)      ; 2004 Release Main Application
declare tasknum     = i4      with protect,constant(3202004)      ; Tasks that contain only requests that read or query data
declare reqnum      = i4      with protect,constant(969553)       ; ConvertFormattedText request
 
;placeholder and error variables
declare stat        = i4      with protect
declare errp        = i4      with protect
declare errc        = i4      with protect
declare errm        = vc      with protect
 
;variables that will store the parsed XHTML data so that we can send it through
;ConvertFormattedText and get a RTF value in return that can be displayed on
;the screen
declare placeholder = i4
declare nplaceholder = i4
declare placetext = gvc
declare divtext = gvc
declare sectext = gvc
declare newsectext = gvc
declare fulltext = gvc
declare secend = i4
declare tmptext = gvc
declare newtmptext = gvc
declare endtext = gvc
declare divholder = i4
declare perform_dt = gvc
 
 
declare placeholder2 = i4
declare placetext2 = gvc
declare divtext2 = gvc
declare sectext2 = gvc
declare fulltext2 = gvc
declare secend2 = i4
declare tmptext2 = gvc
declare endtext2 = gvc
declare divholder2 = i4
declare perform_dt2 = gvc
 
;variable to grab the event_set for the Office Notes
declare cEventSet1 = f8 with constant(uar_get_code_by("DISPLAY_KEY", 93, "OFFICECLINICNOTES")), protect
declare cEventSet2 = f8 with constant(uar_get_code_by("DISPLAY_KEY", 93, "PATIENTCAREDOCUMENTATION")), protect
 
record ConvTextIn (
        1 desired_format_cd = f8
        1 origin_format_cd = f8
        1 origin_text = gvc
)
 
record ConvTextOut (
        1 converted_text = gvc
        1 status_data
          2 status = c1
          2 subeventstatus [*]
            3 OperationName = c25
            3 OperationStatus = c1
            3 TargetObjectName = c25
            3 TargetObjectValue = vc
)
 
record lst(
	1 list[*]
		2 paragData = vc
)
 
 
set placetext = 'dd:concept="PE"'
set divtext = "<div class="
set endtext = "End of Physical Exam</span></span></div>"
set html_bdh = '<span style="padding-top: 0px; padding-bottom: 0px; font-weight: bold; margin-top: 0px; margin-bottom: 0px;">'
set rtf_bhd = build2('\fi-240\li480\tx960\tx1680\tx2400\tx3120\tx3840\tx4560\tx5280\tx6000\tx6720\tx7440\tx8160\tx8880',
					'\tx9600\tx10320\plain\f4\fs16\b\cf1\chshdng0\chcfpat0')
declare spanReplace1 = vc
declare spanReplace0 = vc
declare spanReplace2 = vc
set spanReplace0 = '<span style="padding-top: 0px; padding-bottom: 0px; margin-top:0px; margin-bottom: 0px; -ms-word-wrap: break-word;">'
set spanReplace1 = '<span style="margin: 0px 0in; padding: 0pt; text-align: left; color: rgb(0, 0, 0); font-style: normal; font-weight: normal; text-decoration: none;">'
set spanReplace2 = '<span class="blockformattedtext">'
declare divHeader = vc
declare divFooter = vc
declare str = vc with noconstant("")
declare notfnd = vc with constant("<not_found>")
declare num = i4 with noconstant(1)
 
set divHeader = build2('<div class="ddemrcontent" dd:concept="PE" dd:contenttype="DOC_COMP" ',
'dd:referenceuuid="A49BBBFA-2A02-4D05-87A4-D5BF2836522C" id="_23F6B940-B312-4201-B1A4-7950F7818815"><div class="ddemrcontentitem"'
,'dd:contenttype="PATCARE_MEAS" dd:entityid="0" dd:entityversion="0" id="_6BD02667-B2B0-44AC-8C37-1D7AA6F099B1">'
,'<div class="ddcomponent" dd:entitytexttype="resultval"><div class="ddfreetext ddremovable" dd:btnfloatingstyle="top-right"'
,' id="_A0C9740A-4620-459D-995B-7CAAC090C4C1">')
set divFooter ='</div></div></div></div><span class="ddsectiondisplay"><span style="display: none;">End of Physical Exam</span></span></div>'
 
;set the output format and origin format code for the call to ConvertFormattedText
set ConvTextIn->origin_format_cd  = xhtml_cd
set ConvTextIn->desired_format_cd = rtf_cd
 
/******************************************************************
Select off the dd_contribution table by the reqinfo->updt_id that is
sent in from PowerChart.  This value will be equal to the current
user which will allow us to pull the event_id for the most recent
dynamic doc note that includes the physician documented PE.
******************************************************************/
 
select into "nl:"
from clinical_event ce
,ce_blob cb
,CE_BLOB_RESULT BLR
plan ce
where ce.person_id =  request->person[1]->person_id
    and
    (
     ce.performed_prsnl_id = reqinfo->updt_id
    or
     ce.verified_prsnl_id = reqinfo->updt_id
    )
and ce.event_cd =     2820615.00
and ce.result_status_cd in (23, 25,35)
and ce.valid_until_dt_tm = cnvtdatetime("31-DEC-2100 00:00:00.00")
;and ce.catalog_cd d.form_status_cd in(25.00, 34.00, 35.00) ;(auth_cd, mod_cd, alter_cd)
join cb
	where CB.EVENT_ID = ce.event_id
	and CB.VALID_UNTIL_DT_TM > sysdate
join BLR
	where BLR.EVENT_ID=CB.EVENT_ID
	and BLR.VALID_UNTIL_DT_TM > sysdate
order by ce.event_cd, ce.performed_dt_tm desc
 
head report
 cEventId = 0
head ce.event_cd
 if(cEventId = 0)
  	blob_out    = fillstring(32768, ' ')
  	blob_out2 = " "
  	perform_dt = format(ce.performed_dt_tm,"@SHORTDATETIMENOSEC")
	 if(CB.COMPRESSION_CD=ocfcomp)
	  len=textlen(CB.BLOB_CONTENTS)
	  call uar_ocf_uncompress(CB.BLOB_CONTENTS,len,blob_out,64000,retlen)
	  call echo(build2("perform_dt",format(ce.event_end_dt_tm,"@SHORTDATETIMENOSEC")))
	  call echo(build2("blob_out Text",blob_out))
	 else
	  len       = size(trim(CB.BLOB_CONTENTS))
	  blob_out  = substring(1,len-8,CB.BLOB_CONTENTS)
	  retlen    = len-8
	 endif
	 if (BLR.FORMAT_CD = xhtml_cd)
	 	call echo("Html")
	 	placeholder = findstring(placetext,blob_out,1,0)
		placeholder = findstring(">Slit Lamp Examination</span>",blob_out,1,0)
   		if(placeholder > 0)
   			call echo("Table Section")
			placetext = "<table"
	   		tmptext = substring(1,placeholder,blob_out)
	   		divholder = findstring(placetext,tmptext,1,1)
	   		endtext = "</table>"
	   		secend = findstring(endtext,blob_out,divholder,0)
	   		sectext = substring(divholder,secend+size(endtext)-divholder,blob_out)
	   		call echo(build2("Section Text Now - ",divholder, " : ",sectext))
	   		call echo(build2("Section Text END",divholder))
	   		fulltext = '<?xml version="1.0" encoding="UTF-8"?>'
		    fulltext = concat(fulltext,'<?dynamic-document type="template" version="2.0"?>')
		    fulltext = concat(fulltext,'<!DOCTYPE html SYSTEM "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">')
		    fulltext = concat(fulltext,'<html xmlns="http://www.w3.org/1999/xhtml" xmlns:dd="DynamicDocumentation">')
		    fulltext = concat(fulltext,'<head><title></title> <meta http-equiv="X-UA-Compatible" content="IE=10" /> </head>')
		    fulltext = concat(fulltext,'<body><div style="font-family: tahoma,arial; font-size: 12px;">',sectext)
		    fulltext = concat(fulltext,'<span>(PE Documented on ',perform_dt,')</span>')
		    fulltext = concat(fulltext,"</div></body></html>")
		    ConvTextOut->converted_text = " "
		    ConvTextIn->origin_text = fulltext
		    stat = tdbexecute(appnum,tasknum,reqnum,"REC",ConvTextIn,"REC",ConvTextOut)
;		    call echo(build2("Convert END",divholder))
;		    call echo(build2("Convert fulltext",ConvTextOut->converted_text))
	   else
	   		placeholder = findstring(">Slit Lamp Exam</span><br />",blob_out,1,0)
	   		if(placeholder > 0)
   				call echo("List Section")
   				placetext = '<span style="padding-top: 0px; padding-bottom: 0px; margin-top: 0px; margin-bottom: 0px; -ms-word-wrap: break-word;">'
   				tmptext = substring(1,placeholder,blob_out)
   				divholder = findstring(placetext,tmptext,1,1)
   				endtext = "</span></span>"
   				secend = findstring(endtext,blob_out,divholder,0)
	   			sectext = substring(divholder,secend+size(endtext)-divholder,blob_out)
	   			call echo(build2("Section Text END",divholder))
		   		fulltext = '<?xml version="1.0" encoding="UTF-8"?>'
			   	fulltext = concat(fulltext,'<?dynamic-document type="template" version="2.0"?>')
			   	fulltext = concat(fulltext,'<!DOCTYPE html SYSTEM "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">')
			   	fulltext = concat(fulltext,'<html xmlns="http://www.w3.org/1999/xhtml" xmlns:dd="DynamicDocumentation">')
			   	fulltext = concat(fulltext,'<head><title></title> <meta http-equiv="X-UA-Compatible" content="IE=10" /> </head>')
			   	fulltext = concat(fulltext,'<body><div style="font-family: tahoma,arial; font-size: 12px;">',sectext)
			   	fulltext = concat(fulltext,'<br /> <br /><span>(PE Documented on ',perform_dt,')</span>')
			   	fulltext = concat(fulltext,"</div></body></html>")
			   	ConvTextOut->converted_text = " "
			   	ConvTextIn->origin_text = fulltext
			   	stat = tdbexecute(appnum,tasknum,reqnum,"REC",ConvTextIn,"REC",ConvTextOut)
;			   	call echo(build2("Convert END",divholder))
;			   	call echo(build2("Convert fulltext",ConvTextOut->converted_text))
			 endif
	   endif
   		cEventId = ce.event_id
	  	else
		 	call echo("Power Note section")
		 	perform_dt = format(ce.performed_dt_tm,"@SHORTDATETIMENOSEC")
		 	placetext = "Slit Lamp Exam"
		 	placeholder = findstring(placetext,blob_out,1,0)
		 	;divholder =
		 	if(placeholder > 0)
		 		tmptext = substring(1,placeholder,blob_out)
		 		nplaceholder = placeholder
		 		placeholder = findstring("\chshdng0\chcfpat0 OD\cell OS\cell\trowd",tmptext,1,1)
	   			if(placeholder > 0)
		 			call echo("RTF Table Section")
		 			tmptext = substring(1,placeholder,blob_out)
		 			divholder = findstring("{\par",tmptext,1,1)
		 			endtext= "}"
		 			secend = findstring(endtext,blob_out,divholder,0)
		 			tmptext = substring(divholder,secend-divholder+1,blob_out)
		 			tmptext = replace(tmptext,rtf_bhd,rh2b)
			 		call echo(build2("Section end na: ",tmptext))
			 		call echo("END HERE")
			 		sectext = build2(RHEAD,tmptext,reol,'(PE Documented on ',perform_dt,')', reol,RTFEOF)
			 		;sectext = build2(RHEAD,tmptext,RTFEOF)
			 		call echo(sectext)
			 		ConvTextOut->converted_text = sectext
			 	elseif(findstring("Slit Lamp Examination\cell OD\cell OS\cell",blob_out,1,0)>0)
			 		placeholder = findstring("{\pard",tmptext,1,1)
			 		;newtmptext = tmptext
			 		if(placeholder > 0)
			 			call echo("RTF Table Section__")
			 			tmptext = substring(1,placeholder,blob_out)
			 			divholder = placeholder ;findstring("{\par",tmptext,1,1)
			 			endtext= "}"
			 			secend = findstring(endtext,blob_out,nplaceholder,0)
			 			tmptext = substring(divholder,secend-divholder+1,blob_out)
			 			tmptext = replace(tmptext,rtf_bhd,rh2b)
				 		call echo(build2("Section end na: ",tmptext))
				 		call echo("END HERE")
				 		sectext = build2(RHEAD,tmptext,reol,'(PE Documented on ',perform_dt,')', reol,RTFEOF)
				 		;sectext = build2(RHEAD,tmptext,RTFEOF)
				 		call echo(sectext)
				 		ConvTextOut->converted_text = sectext
			 		endif
			 	else
			 		call echo("RTF Possibly List Section")
			 		placeholder = findstring("plain\f4\fs16\b\cf1\chshdng0\chcfpat0 OD\plain\",blob_out,1,0)
			 		if(placeholder > 0)
			 			call echo("Confirmed RTF List Section")
			 			tmptext = substring(1,placeholder,blob_out)
			 			divholder = findstring("{",tmptext,1,1)
			 			endtext= "}"
			 			secend = findstring(endtext,blob_out,divholder,0)
			 			tmptext = substring(divholder,secend-divholder+1,blob_out)
			 			tmptext = replace(tmptext,rtf_bhd,rh2b)
				 		call echo(build2("Section end na: ",tmptext))
;				 		sectext = build2(RHEAD,tmptext,reol,RTFEOF)
						sectext = build2(RHEAD,tmptext,reol,'(PE Documented on ',perform_dt,')', reol,RTFEOF)
				 		;sectext = build2(RHEAD,tmptext,RTFEOF)
				 		call echo(sectext)
				 		ConvTextOut->converted_text = sectext
			 		endif
			 	endif
 
			 endif
	 endif
 endif
with nocounter
 
;remove trailing CRs
;After the get_blob_results subroutine has run, all your blob results in the
;record structure will have been converted so that there is a %CR% wherever
;an end-of-line is needed and %TB% where whitespace is needed.  It then becomes
;the job of your print routine to convert those tokens into appropriate codes to
;make those things happen.  (The %EOF% token is used locally inside the subroutine
;and will not be found in the results).
 
set tempvc= ConvTextOut->converted_text
for (x=1 to 100)
 set y=findstring(crtoken,tempvc,1,1)
  if (y=textlen(tempvc)-3 and y>1)
   set tempvc=substring(1,y-1,tempvc)
  else
   set x=100
  endif
 endfor
set tempvc=replace(tempvc,crtoken,"\par ")
set tempvc=replace(tempvc,tbtoken,"\tab ")
 
;used if converting to ascii text only
/*
Declare InBuffer = vc
Declare InBufLen = i4
Declare OutBuffer = c2000 with NoConstant("")
Declare OutBufLen = i4 with NoConstant(2000)
Declare RetBufLen = i4 with NoConstant(0)
Declare bFlag = i4 with NoConstant(0)
 
Set InBuffer = tempvc
Set InBufLen = size(InBuffer)
set stat = uar_rtf(InBuffer,InBufLen,OutBuffer,OutBufLen,RetBufLen,bFlag)
 
set TMP_STR = build2(RHEAD,WR,trim(OutBuffer),REOL,"(unchanged from ",perform_dt,")",RTFEOF)
*/
 
;otherwise use this to set the output to be the RTF that is converted
 
set TMP_STR = build2(trim(tempvc))
SET reply->TEXT = TMP_STR
;build2(RHEAD,WR,ConvTextOut->converted_text,RTFEOF)
; ConvTextOut->converted_text ;TMP_STR
 
;     check for errors (most likely from tdbexecute)
set errc=error(errm,0)
 
;output report status and call echorecord for back-end testing
SET reply->STATUS_DATA->STATUS = "s"
call echo(concat("original=",ConvTextIn->origin_text))
 
;uncomment if using ascii text conversion
;call echo(concat("outbuffer=",OutBuffer))
;call echo (concat("retbuflen=",cnvtstring(retbuflen)))
call echo(concat("reply->text=",reply->text))
call echo(concat("converted=",ConvTextOut->converted_text))
;call echorecord(reply)
;call echo(concat("sectext=",TMP_STR))
;call echo(concat("fulltext=",fulltext))
;call echo(concat("errc=",cnvtstring(errc)))
 
end
go
 
