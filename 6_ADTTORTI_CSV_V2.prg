drop program 6_ADTTORTI_CSV_V2 go
create program 6_ADTTORTI_CSV_V2
 
prompt
	"Output to File/Printer/MINE" = "MINE"   ;* Enter or select the printer or file name to send this report to.
	, "Tracking Group" = 102248389.000000
	, "Start Date Of Service" = ""
	, "End Date Of Service" = "SYSDATE"
	, "Delivery Type" = "1"
	, "Output Formatted for ?" = "1"
 
with OUTDEV, trackGroupCd, startDate, endDate, delType, formatType
 
 
/**************************************************************
; DVDev DECLARED RECORD STRUCTURE Simeon A, testing
**************************************************************/
free record RS
record RS
(
	 1 COUNT 									= I2
	 1 QUAL[*]
	 		2 PersonID							= f8
	 		2 EncntrID							= f8
	 		2 LocationCD						= f8
	 		2 LocationName						= vc
			2 Fin			 					= vc
			2 MRN			 					= vc
			2 EMPI			 					= vc
			2 DOS		 						= vc
			2 DOS_DATE							= vc
			2 DOS_TIME							= vc
			2 Chief_Complaint					= vc
			2 unsigned_docs						= vc
			2 unsigned_docs_text				= vc
			2 Tracking_acuity					= vc
			2 Discharge_Dispo					= vc
			2 Pat_FullName						= vc
			2 Pat_LastName						= vc
			2 Pat_FirstName						= vc
			2 Pat_MiddleName					= vc
			2 Address_Line_1 					= vc
			2 Address_Line_2 					= vc
			2 City								= vc
			2 State								= vc
			2 ZIP_Code							= vc
			2 Pat_Home_Phon						= vc
			2 SSN 								= vc
			2 DOB 								= vc
			2 AGE 								= vc
			2 GENDER 							= vc
			2 Marital_Status 					= vc
			2 Insurance_Name 					= vc
			2 Insurance_Address  				= vc
			2 Insurance_Address2 				= vc
			2 Insurance_City 					= vc
			2 Insurance_STATE 					= vc
			2 Insurance_ZIP 					= vc
			2 Financial_Class 					= vc
			2 Plan_Type 						= vc
			2 Insurance_Description 			= vc
			2 Group_Number 						= vc
			2 Group_Name 						= vc
			2 Policy_Num 						= vc
			2 Reltn_To_Subscriber 				= vc
			2 Subscriber_Last_Name				= vc
			2 Subscriber_First_Name				= vc
			2 Subscriber_Middle_Name			= vc
			2 Subscriber_Address_Line_1 		= vc
			2 Subscriber_Address_Line_2 		= vc
			2 Subscriber_City					= vc
			2 Subscriber_State					= vc
			2 Subscriber_ZIP_Code				= vc
			2 Subscriber_Employer_Name 			= vc
			2 Subscriber_Employer_Address  		= vc
			2 Subscriber_Employer_Address2 		= vc
			2 Subscriber_Employer_City 			= vc
			2 Subscriber_Employer_STATE 		= vc
			2 Subscriber_Employer_ZIP 			= vc
			2 Employer_Name 					= vc
			2 Employer_Address  				= vc
			2 Employer_Address2 				= vc
			2 Employer_City 					= vc
			2 Employer_STATE 					= vc
			2 Employer_ZIP 						= vc
			2 Employer_PHONE 					= vc
			2 Registration_Date 				= vc
			2 Registration_Time 				= vc
			2 Discharge_Date 					= vc
			2 Discharge_Time 					= vc
			2 Triage_Date 						= vc
			2 Triage_Time 						= vc
			2 Triage 							= vc
			2 Billing_Status					= vc
			2 Billing_Status_Date				= vc
			2 Billing_Delay						= vc
			2 RTI_Status						= vc
			2 RTI_Status_Date					= vc
			2 IDX_Status						= vc
			2 IDX_Invoice_Number				= vc
			2 IDX_Status_Date					= vc
			2 TES_CRE							= vc
			2 FCT_DISPO							= vc
			2 Primary_PayorID				 	= vc
			2 Secondary_Financial_Class 		= vc
			2 Secondary_Plan_Type				= vc
			2 Secondary_Insurance_Description   = vc
			2 Secondary_Group_Number 			= vc
			2 Secondary_Group_Name 				= vc
			2 Secondary_Policy_Num				= vc
			2 Secondary_PayorID				 	= vc
 
)
/**************************************************************
; DVDev DECLARED VARIABLES
**************************************************************/
declare rtiDivision = vc
 
/**************************************************************
; DVDev Start Coding
**************************************************************/
; RTI MedStar Location Info
if(cnvtstring($trackGroupCd) =  "102226144");gsh uses Team Health
	set rtiDivision = "59whc"
elseif(cnvtstring($trackGroupCd) = "102225132");umh
	set rtiDivision = "34whc"
elseif(cnvtstring($trackGroupCd) = "102247373");hhc
	set rtiDivision = "42whc"
elseif(cnvtstring($trackGroupCd) = "102248389");FSH
	set rtiDivision = "26whc"
elseif(cnvtstring($trackGroupCd) = "101724250");WHC
	set rtiDivision = "18whc"
elseif(cnvtstring($trackGroupCd) = "102247893");GUH
	set rtiDivision = "18guh"
elseif(cnvtstring($trackGroupCd) = "1715312165");SMD
	set rtiDivision = "67whc"
endif
 
select INTO "NL:"
				LocationCD 					= TC.TRACKING_GROUP_CD
				;,RTI_Division					= trim(rtiDiv,3)
				,LocationName					= trim(uar_get_Code_display(TC.TRACKING_GROUP_CD),3)
				,Fin							= ea.alias
				,MRN							= ea2.alias
				,DOS							= trim(FORMAT(TC.CHECKIN_DT_TM, "MM-DD-YYYY HH:MM"),3)
				,Chief_Complaint				= trim(ce.result_val,3)
				,Tracking_acuity				= trim(substring(1,25, tr.description),3)
				,Discharge_Dispo				= trim(uar_get_code_display(tc.checkout_disposition_cd),3)
				,Pat_FullName					= trim(p.name_full_formatted,3)
				,Pat_LastName					= trim(P.NAME_LAST_KEY,3)
				,Pat_FirstName					= trim(P.NAME_FIRST_KEY,3)
				,Pat_MiddleName					= trim(P.name_middle_key,3)
				,Address_Line_1 				= trim(a.street_addr,3)
				,Address_Line_2					= trim(a.street_addr2,3)
				,City							= trim(a.city,3)
				,State							= trim(a.state,3)
				,ZIP_Code						= trim(a.zipcode,3)
				,Pat_Home_Phon					= ph.phone_num
				,SSN 							= trim(format(pa.alias, '###-##-####'),3)
				,DOB 							= format(p.birth_dt_tm, "MM/DD/YYYY ;;D")
				,AGE							= cnvtage(p.birth_dt_tm)
				,GENDER 						= uar_get_Code_display(p.sex_cd)
				,Marital_Status 				= uar_get_Code_display(p.marital_type_cd)
				,Insurance_Name 				= trim(InsO.org_name, 3)
				,Insurance_Address  			= trim(InsA.STREET_ADDR,3)
				,Insurance_Address2				= trim(InsA.STREET_ADDR2,3)
				,Insurance_City 				= trim(InsA.CITY,3)
				,Insurance_STATE 				= trim(InsA.STATE,3)
				,Insurance_ZIP 					= trim(InsA.ZIPCODE,3)
				,Primary_Financial_Class 		= uar_get_Code_display(hpP.plan_type_cd)
				,Primary_Plan_Type 				= uar_get_Code_display(hpP.financial_class_cd)
				,Primary_Insurance_Description 	= hpP.plan_desc
				,Primary_Group_Number 			= eprp.group_nbr
				,Primary_Group_Name 			= trim(eprP.group_name)
				,Primary_Policy_Num 			= hpP.policy_nbr
				,Reltn_To_Subscriber 			= uar_get_Code_display(InsEPR.person_reltn_cd)
				,Subscriber_Last_Name			= InsReltnP.name_last_key
				,Subscriber_First_Name 			= InsReltnP.name_first_key
				,Subscriber_Middle_Name			= InsReltnP.name_middle_key
				,Subscriber_Address_Line_1 		= trim(InsrdA.street_addr,3)
				,Subscriber_Address_Line_2		= trim(InsrdA.street_addr2,3)
				,Subscriber_City				= trim(InsrdA.city,3)
				,Subscriber_State				= trim(InsrdA.state,3)
				,Subscriber_ZIP_Code			= trim(InsrdA.zipcode,3)
				,Subscriber_Employer_Name		= trim(InsrdPOR.FT_ORG_NAME,3)
				,Subscriber_Employer_Address	= trim(InsrdEmpA.STREET_ADDR,3)
				,Subscriber_Employer_Address2 	= trim(InsrdEmpA.STREET_ADDR2,3)
				,Subscriber_Employer_City 		= trim(InsrdEmpA.CITY,3)
				,Subscriber_Employer_STATE 		= trim(InsrdEmpA.STATE,3)
				,Subscriber_Employer_ZIP 		= trim(InsrdEmpA.ZIPCODE,3)
				,Employer_Name 					= trim(emppor.FT_ORG_NAME,3)
				,Employer_Address  		 		= trim(EmpA.STREET_ADDR,3)
				,Employer_Address2 				= trim(EmpA.STREET_ADDR2,3)
				,Employer_City 					= trim(EmpA.CITY,3)
				,Employer_STATE 				= trim(EmpA.STATE,3)
				,Employer_ZIP 					= trim(EmpA.ZIPCODE,3 )
				,Employer_PHONE 				= EmpP.PHONE_NUM
				,Registration_Date 				= format(TC.CHECKIN_DT_TM, "MM-DD-YYYY")
				,Registration_Time 				= format(TC.CHECKIN_DT_TM, "HH:MM;;S")
				,Discharge_Date 				= format(tc.checkout_dt_tm, "MM-DD-YYYY")
				,Discharge_Time 				= format(tc.checkout_dt_tm, "HH:MM;;S")
				,Triage_Date 					= format(e.triage_dt_tm, "MM-DD-YYYY")
				,Triage_Time 					= format(e.triage_dt_tm, "HH:MM;;S")
				,Triage 						= uar_get_Code_display(e.triage_cd)
				,EMPI							= pa2.alias, hpa.alias
				,Secondary_Financial_Class 		= uar_get_Code_display(hpP2.plan_type_cd)
				,Secondary_Plan_Type			= uar_get_Code_display(hpP2.financial_class_cd)
				,Secondary_Insurance_Description= hpP2.plan_desc
				,Secondary_Group_Number 		= eprp2.group_nbr
				,Secondary_Group_Name 			= trim(eprP2.group_name)
				,Secondary_Policy_Num			= hpP2.policy_nbr
				,Secondary_PayorID				= hpa2.alias
 
 	    from
		TRACKING_ITEM TI,
		tracking_checkin tc,
		track_reference tr,
		;tracking_event te,
		encounter e,
		encntr_alias ea,
		encntr_alias ea2,
		Person p,
		phone ph,
		address a,
		PERSON_PRSNL_RELTN   ppr,
		PRSNL pp,
		prsnl_alias pra,
		person_alias   pa,			;SSN
		person_alias   pa2,			;EMPI
		encntr_financial ef,
		encntr_plan_reltn   eprP,
		health_plan   hpP,
		health_plan_alias hpa,
		organization   ogP,
		encntr_plan_reltn   eprP2,
		health_plan   hpP2,
		health_plan_alias hpa2,
		organization   ogP2,
		clinical_event ce,
		PERSON_ORG_RELTN  emppor,
	 	ADDRESS  EmpA,
	 	PHONE  EmpP,
	 	PERSON_ORG_RELTN InsPOR,
		Organization InsO,
		ADDRESS InsA,
		PHONE  InsP,
		encntr_person_reltn InsEPR,
		person InsReltnP,
		address InsrdA,
		PERSON_ORG_RELTN  InsrdPOR,
	 	ADDRESS  InsrdEmpA
	plan ti
		where ti.active_ind							=1
	join tc
		where tc.tracking_id 						= ti.tracking_id
			and tc.active_ind						= 1
			and tc.checkin_id						= 1
			and tc.tracking_group_cd 				= $trackGroupCd
			and tc.checkin_dt_tm					>= cnvtdatetime($STARTDATE )
			and tc.checkin_dt_tm					< cnvtdatetime($ENDDATE)
	join tr
		where tr.tracking_ref_id 					=  outerjoin(tc.acuity_level_id)
	join e
		where e.encntr_id 							=  ti.encntr_id
	join ea
		where ea.encntr_id							=  outerjoin(e.encntr_id)
		and ea.encntr_alias_type_cd					=  outerjoin(1077)
	join ea2
		where ea2.encntr_id							=  outerjoin(e.encntr_id)
		and ea2.encntr_alias_type_cd				=  outerjoin(1079)
	join p
		where p.person_id 							=  ti.person_id
		and	p.active_ind = 1
	join a
		where a.parent_entity_id 					= outerjoin(ti.person_id)
		and a.address_type_cd 						= outerjoin(756.00)
		and a.active_ind 							= outerjoin(1)
	join pa
		where pa.person_id 							=  outerjoin(p.person_id)
		and	pa.active_ind 							=  outerjoin(1)
		and	pa.end_effective_dt_tm 					>  outerjoin(cnvtdatetime(curdate, curtime3))
		and	pa.person_alias_type_cd 				= outerjoin(18.00)
	join pa2
		where pa2.person_id 						=  outerjoin(p.person_id)
		and	pa2.active_ind 							=  outerjoin(1)
		and	pa2.end_effective_dt_tm 				>  outerjoin(cnvtdatetime(curdate, curtime3))
		and	pa2.person_alias_type_cd 				= outerjoin(2)
	join ph
		where ph.parent_entity_id 					=  outerjoin(p.person_id)
		and ph.active_ind 							=  outerjoin(1)
		and ph.phone_type_cd						=  outerjoin( 170.00)
	join ppr
		where ppr.active_ind 						=  outerjoin(1)
		and ppr.beg_effective_dt_tm					<= outerjoin(CNVTDATETIME(CURDATE, CURTIME))
		and ppr.end_effective_dt_tm					>= outerjoin(CNVTDATETIME(CURDATE, CURTIME))
	    and ppr.person_id 							=  outerjoin(ti.person_id)
	    and ppr.person_prsnl_r_cd 					=  outerjoin(1115.00)
	join pp
		where pp.person_id 							=  outerjoin(ppr.prsnl_person_id)
		and pp.active_ind			 				=  outerjoin(1)
	join pra
		where pra.person_id 						=  outerjoin(ppr.prsnl_person_id) ;18599636; 1347525.00
		and pra.prsnl_alias_type_cd 				=  outerjoin(4038127.00)
		and pra.active_ind							=  outerjoin(1)
	join ef
		where ef.encntr_financial_id				=  outerjoin(e.encntr_financial_id)
		and ef.active_ind							=  outerjoin(1)
		and ef.end_effective_dt_tm					>  outerjoin(cnvtdatetime(curdate, curtime3))
	Join eprP
		where eprp.encntr_id 						=  outerjoin(e.encntr_id)
		and eprP.end_effective_dt_tm 				>= outerjoin(cnvtdatetime(curdate,curtime3))
		and eprP.active_ind 						=  outerjoin(1)
		and eprP.priority_seq 						=  outerjoin(1)
	Join eprP2
		where eprp2.encntr_id 						=  outerjoin(e.encntr_id)
		and eprP2.end_effective_dt_tm 				>= outerjoin(cnvtdatetime(curdate,curtime3))
		and eprP2.active_ind 						=  outerjoin(1)
		and eprP2.priority_seq 						=  outerjoin(2)
	join ogP
		where ogP.organization_id 					=  outerjoin(eprP.organization_id)
	join ogP2
		where ogP2.organization_id 					=  outerjoin(eprP2.organization_id)
	join hpP
		where hpP.health_plan_id 					=  outerjoin(eprP.health_plan_id)
	join hpP2
		where hpP2.health_plan_id 					=  outerjoin(eprP2.health_plan_id)
	join hpa
		where hpa.health_plan_id					=  outerjoin(hpp.health_plan_id)
	join hpa2
		where hpa2.health_plan_id					=  outerjoin(hpp2.health_plan_id)
	join ce
		where ce.encntr_id							=  outerjoin(e.encntr_id)
		and ce.event_cd								=  outerjoin(704668.00) ; DISPLAY_KEY= CHIEFCOMPLAINT
		and (ce.result_status_cd					=  outerjoin(23.0) OR
			 ce.result_status_cd					=  outerjoin(25.0) OR
			 ce.result_status_cd					=  outerjoin(34.0) OR
			 ce.result_status_cd					=  outerjoin(35.0))
		and ce.valid_until_dt_tm 					> outerjoin(cnvtdatetime(curdate,curtime3))
	join emppor
		WHERE emppor.PERSON_ID 						=  outerjoin(ti.person_id)
		and emppor.PERSON_ORG_RELTN_CD 				=  outerjoin(1136.00)
		and emppor.ACTIVE_IND 						=  outerjoin(1)
		and emppor.PRIORITY_SEQ 					=  outerjoin(1)
		and emppor.BEG_EFFECTIVE_DT_TM 				<= outerjoin(CNVTDATETIME (CURDATE,CURTIME3))
		and emppor.END_EFFECTIVE_DT_TM 				>= outerjoin(CNVTDATETIME (CURDATE,CURTIME3))
	 JOIN EmpA
		WHERE EmpA.PARENT_ENTITY_ID					=  outerjoin(emppor.ORGANIZATION_ID)
		and EmpA.PARENT_ENTITY_NAME					=  outerjoin("ORGANIZATION" )
		and EmpA.ACTIVE_IND 						=  outerjoin(1)
		and EmpA.BEG_EFFECTIVE_DT_TM 				<= outerjoin(CNVTDATETIME(CURDATE,CURTIME3))
		and EmpA.END_EFFECTIVE_DT_TM+0 				>= outerjoin(CNVTDATETIME(CURDATE,CURTIME3))
	join EmpP
		WHERE EmpP.PARENT_ENTITY_ID					=  outerjoin(emppor.ORGANIZATION_ID)
		and EmpP.PARENT_ENTITY_NAME					=  outerjoin("ORGANIZATION")
		and EmpP.ACTIVE_IND							=  outerjoin(1)
		and EmpP.BEG_EFFECTIVE_DT_TM				<= outerjoin(CNVTDATETIME(CURDATE,CURTIME3))
		and EmpP.END_EFFECTIVE_DT_TM				>= outerjoin(CNVTDATETIME(CURDATE,CURTIME3))
	join InsPOR
		WHERE InsPOR.PERSON_ID 						=  outerjoin(ti.person_id)
		and InsPOR.PERSON_ORG_RELTN_CD 				=  outerjoin(1136.00)
		and InsPOR.ACTIVE_IND 						=  outerjoin(1)
		and InsPOR.PRIORITY_SEQ 					=  outerjoin(1)
		and InsPOR.BEG_EFFECTIVE_DT_TM 				<= outerjoin(CNVTDATETIME (CURDATE,CURTIME3))
		and InsPOR.END_EFFECTIVE_DT_TM 				>= outerjoin(CNVTDATETIME (CURDATE,CURTIME3))
	join InsO
		where InsO.organization_id					=  outerjoin(InsPOR.organization_id)
	 	and InsO.active_ind							=  outerjoin(1)
	 	and InsO.beg_effective_dt_tm				<= outerjoin(CNVTDATETIME(CURDATE,CURTIME3))
	 	and InsO.end_effective_dt_tm				>= outerjoin(CNVTDATETIME(CURDATE,CURTIME3))
	join insA
		WHERE insA.PARENT_ENTITY_ID					=  outerjoin(InsPOR.ORGANIZATION_ID)
		and insA.PARENT_ENTITY_NAME					=  outerjoin("ORGANIZATION" )
		and insA.ACTIVE_IND 						=  outerjoin(1)
		and insA.BEG_EFFECTIVE_DT_TM 				<= outerjoin(CNVTDATETIME(CURDATE,CURTIME3))
		and insA.END_EFFECTIVE_DT_TM+0 				>= outerjoin(CNVTDATETIME(CURDATE,CURTIME3))
	join insP
		WHERE insP.PARENT_ENTITY_ID					=  outerjoin(InsPOR.ORGANIZATION_ID)
		and insP.PARENT_ENTITY_NAME					=  outerjoin("ORGANIZATION")
		and insP.ACTIVE_IND							=  outerjoin(1)
		and insP.BEG_EFFECTIVE_DT_TM				<= outerjoin(CNVTDATETIME(CURDATE,CURTIME3))
		and insP.END_EFFECTIVE_DT_TM				>= outerjoin(CNVTDATETIME(CURDATE,CURTIME3))
	join InsEPR
		where InsEPR.encntr_id						=  outerjoin(e.encntr_id)
		and InsEPR.person_reltn_type_cd				=  outerjoin(1158.00)
		and InsEPR.active_ind						=  outerjoin(1)
		and InsEPR.beg_effective_dt_tm				<= outerjoin(CNVTDATETIME(CURDATE, CURTIME))
		and InsEPR.end_effective_dt_tm				>= outerjoin(CNVTDATETIME(CURDATE, CURTIME))
	join InsReltnP
		where InsReltnP.person_id					=  outerjoin(InsEPR.related_person_id)
	join InsrdA
		where InsrdA.parent_entity_id 				= outerjoin(InsEPR.related_person_id)
		and InsrdA.address_type_cd					= outerjoin(756.00)
		and InsrdA.active_ind 						= outerjoin(1)
	join InsrdPOR
		WHERE InsrdPOR.PERSON_ID 					=  outerjoin(ti.person_id)
		and InsrdPOR.PERSON_ORG_RELTN_CD 			=  outerjoin(1136.00)
		and InsrdPOR.ACTIVE_IND						=  outerjoin(1)
		and InsrdPOR.PRIORITY_SEQ 					=  outerjoin(1)
		and InsrdPOR.BEG_EFFECTIVE_DT_TM 			<= outerjoin(CNVTDATETIME (CURDATE,CURTIME3))
		and InsrdPOR.END_EFFECTIVE_DT_TM 			>= outerjoin(CNVTDATETIME (CURDATE,CURTIME3))
	 JOIN InsrdEmpA
		WHERE InsrdEmpA.PARENT_ENTITY_ID			=  outerjoin(InsrdPOR.ORGANIZATION_ID)
		and InsrdEmpA.PARENT_ENTITY_NAME			=  outerjoin("ORGANIZATION" )
		and InsrdEmpA.ACTIVE_IND 					=  outerjoin(1)
		and InsrdEmpA.BEG_EFFECTIVE_DT_TM 			<= outerjoin(CNVTDATETIME(CURDATE,CURTIME3))
		and InsrdEmpA.END_EFFECTIVE_DT_TM+0 		>= outerjoin(CNVTDATETIME(CURDATE,CURTIME3))
	Order by ti.encntr_id, ea.alias, TC.CHECKIN_DT_TM
 
head report
	cnt = 0
	head ti.encntr_id;TI.TRACKING_ID
 		cnt = cnt + 1
 		stat = alterlist(rs->qual, cnt)
 		rs->qual[cnt].PersonID						= ti.person_id
 		rs->qual[cnt].EncntrID						= ti.encntr_id
		rs->qual[cnt].LocationCD 					= TC.TRACKING_GROUP_CD
		rs->QUAL[cnt].EncntrID						= ti.encntr_id
		rs->qual[cnt].LocationName					= trim(uar_get_Code_display(TC.TRACKING_GROUP_CD),3)
		rs->qual[cnt].Fin							= ea.alias
		rs->qual[cnt].MRN							= ea2.alias
		rs->qual[cnt].DOS							= trim(FORMAT(TC.CHECKIN_DT_TM, "MM-DD-YYYY HH:MM"),3)
		rs->qual[cnt].DOS_DATE						= trim(FORMAT(TC.CHECKIN_DT_TM, "MM-DD-YYYY"),3)
		rs->qual[cnt].DOS_TIME						= trim(FORMAT(TC.CHECKIN_DT_TM, "HH:MM"),3)
		rs->qual[cnt].Chief_Complaint				= replace(replace(trim(ce.result_val,3), char(13), " "), char(10)," ")
		rs->qual[cnt].Tracking_acuity				= trim(substring(1,25, tr.description),3)
		rs->qual[cnt].Discharge_Dispo				= trim(uar_get_code_display(tc.checkout_disposition_cd),3)
		;rs->qual[cnt].FCT_DISPO						= trim(uar_get_code_display(tc.checkout_disposition_cd),3)
		rs->qual[cnt].Pat_FullName					= trim(p.name_full_formatted,3)
		rs->qual[cnt].Pat_LastName					= trim(P.NAME_LAST_KEY,3)
		rs->qual[cnt].Pat_FirstName					= trim(P.NAME_FIRST_KEY,3)
		rs->qual[cnt].Pat_MiddleName				= trim(P.name_middle_key,3)
		rs->qual[cnt].Address_Line_1 				= trim(a.street_addr,3)
		rs->qual[cnt].Address_Line_2				= trim(a.street_addr2,3)
		rs->qual[cnt].City							= trim(a.city,3)
		rs->qual[cnt].State							= trim(a.state,3)
		rs->qual[cnt].ZIP_Code						= trim(a.zipcode,3)
		rs->qual[cnt].Pat_Home_Phon					= ph.phone_num
		rs->qual[cnt].SSN 							= trim(format(pa.alias, '###-##-####'),3)
		rs->qual[cnt].DOB 							= format(p.birth_dt_tm, "MM/DD/YYYY ;;D")
		rs->qual[cnt].AGE							= cnvtage(p.birth_dt_tm)
		rs->qual[cnt].GENDER 						= uar_get_Code_display(p.sex_cd)
		rs->qual[cnt].Marital_Status 				= uar_get_Code_display(p.marital_type_cd)
		rs->qual[cnt].Insurance_Name 				= trim(InsO.org_name, 3)
		rs->qual[cnt].Insurance_Address  			= trim(InsA.STREET_ADDR,3)
		rs->qual[cnt].Insurance_Address2			= trim(InsA.STREET_ADDR2,3)
		rs->qual[cnt].Insurance_City 				= trim(InsA.CITY,3)
		rs->qual[cnt].Insurance_STATE 				= trim(InsA.STATE,3)
		rs->qual[cnt].Insurance_ZIP 				= trim(InsA.ZIPCODE,3)
		rs->qual[cnt].Financial_Class 				= uar_get_Code_display(hpP.plan_type_cd)
		rs->qual[cnt].Plan_Type 					= uar_get_Code_display(hpP.financial_class_cd)
		rs->qual[cnt].Insurance_Description 		= hpP.plan_desc
		rs->qual[cnt].Group_Number 					= eprp.group_nbr
		rs->qual[cnt].Group_Name 					= trim(eprP.group_name)
		rs->qual[cnt].Policy_Num 					= hpP.policy_nbr
		rs->qual[cnt].Reltn_To_Subscriber 			= uar_get_Code_display(InsEPR.person_reltn_cd)
		rs->qual[cnt].Subscriber_Last_Name			= InsReltnP.name_last_key
		rs->qual[cnt].Subscriber_First_Name 		= InsReltnP.name_first_key
		rs->qual[cnt].Subscriber_Middle_Name		= InsReltnP.name_middle_key
		rs->qual[cnt].Subscriber_Address_Line_1 	= trim(InsrdA.street_addr,3)
		rs->qual[cnt].Subscriber_Address_Line_2		= trim(InsrdA.street_addr2,3)
		rs->qual[cnt].Subscriber_City				= trim(InsrdA.city,3)
		rs->qual[cnt].Subscriber_State				= trim(InsrdA.state,3)
		rs->qual[cnt].Subscriber_ZIP_Code			= trim(InsrdA.zipcode,3)
		rs->qual[cnt].Subscriber_Employer_Name		= trim(InsrdPOR.FT_ORG_NAME,3)
		rs->qual[cnt].Subscriber_Employer_Address	= trim(InsrdEmpA.STREET_ADDR,3)
		rs->qual[cnt].Subscriber_Employer_Address2 	= trim(InsrdEmpA.STREET_ADDR2,3)
		rs->qual[cnt].Subscriber_Employer_City 		= trim(InsrdEmpA.CITY,3)
		rs->qual[cnt].Subscriber_Employer_STATE 	= trim(InsrdEmpA.STATE,3)
		rs->qual[cnt].Subscriber_Employer_ZIP 		= trim(InsrdEmpA.ZIPCODE,3)
		rs->qual[cnt].Employer_Name 				= trim(emppor.FT_ORG_NAME,3)
		rs->qual[cnt].Employer_Address  		 	= trim(EmpA.STREET_ADDR,3)
		rs->qual[cnt].Employer_Address2 			= trim(EmpA.STREET_ADDR2,3)
		rs->qual[cnt].Employer_City 				= trim(EmpA.CITY,3)
		rs->qual[cnt].Employer_STATE 				= trim(EmpA.STATE,3)
		rs->qual[cnt].Employer_ZIP 					= trim(EmpA.ZIPCODE,3 )
		rs->qual[cnt].Employer_PHONE 				= EmpP.PHONE_NUM
		rs->qual[cnt].Registration_Date 			= format(TC.CHECKIN_DT_TM, "MM-DD-YYYY")
		rs->qual[cnt].Registration_Time 			= format(TC.CHECKIN_DT_TM, "HH:MM;;S")
		rs->qual[cnt].Discharge_Date 				= format(tc.checkout_dt_tm, "MM-DD-YYYY")
		rs->qual[cnt].Discharge_Time 				= format(tc.checkout_dt_tm, "HH:MM;;S")
		rs->qual[cnt].Triage_Date 					= format(e.triage_dt_tm, "MM-DD-YYYY")
		rs->qual[cnt].Triage_Time 					= format(e.triage_dt_tm, "HH:MM;;S")
		rs->qual[cnt].Triage 						= uar_get_Code_display(e.triage_cd)
		rs->qual[cnt].EMPI							= CNVTALIAS(pa2.ALIAS,pa2.ALIAS_POOL_CD)
		rs->qual[cnt].Primary_PayorID				= hpa.alias
		rs->qual[cnt].Secondary_Financial_Class 	= uar_get_Code_display(hpP2.plan_type_cd)
		rs->qual[cnt].Secondary_Plan_Type			= uar_get_Code_display(hpP2.financial_class_cd)
		rs->qual[cnt].Secondary_Insurance_Description= hpP2.plan_desc
		rs->qual[cnt].Secondary_Group_Number 		= eprp2.group_nbr
		rs->qual[cnt].Secondary_Group_Name 			= trim(eprP2.group_name)
		rs->qual[cnt].Secondary_Policy_Num			= hpP2.policy_nbr
		rs->qual[cnt].Secondary_PayorID				= hpa2.alias
WITH  NOCOUNTER
call echo(Build2("Record has
if(size(rs->qual,5)>0)
	if(VALUE (CNVTREAL($TRACKGROUPCD)) NOT IN (101724250.00, 102247893.00))
	;GET DISPOSITION FROM FCT
	 SELECT INTO "NL:"
		 FROM (DUMMYT D1 WITH SEQ = size(rs->qual,5))
		 ,DCP_FORMS_ACTIVITY			DFA
		 ,DCP_FORMS_ACTIVITY_COMP		DFAC
		 ,CLINICAL_EVENT				CE1
		 ,CLINICAL_EVENT				CE2
		 ,CLINICAL_EVENT				CE3
	PLAN D1
	JOIN DFA
	WHERE  DFA.PERSON_ID  = rs->qual[d1.seq].PersonID
		AND   DFA.ENCNTR_ID = rs->qual[d1.seq].EncntrID
		AND   dfa.dcp_forms_ref_id  = 548153136.00
		AND   DFA.ACTIVE_IND  = 1
		AND   DFA.FORM_STATUS_CD  IN (25.00, 35.00)
	JOIN DFAC
		WHERE DFAC.DCP_FORMS_ACTIVITY_ID = DFA.DCP_FORMS_ACTIVITY_ID
		AND   DFAC.PARENT_ENTITY_NAME = "CLINICAL_EVENT"
	JOIN CE1
		WHERE CE1.EVENT_ID = DFAC.PARENT_ENTITY_ID
		AND   CE1.VALID_UNTIL_DT_TM > CNVTDATETIME(CURDATE, CURTIME3)
		AND   CE1.RESULT_STATUS_CD  IN (25.00, 35.00)
		AND   CE1.event_cd  =   102196313.00 ;FCT
		AND	  CE1.person_id  = DFA.person_id
		AND   CE1.encntr_id  = DFA.encntr_id
	JOIN CE2
		WHERE CE2.parent_event_id = CE1.event_id
		AND   CE2.VALID_UNTIL_DT_TM  > CNVTDATETIME(CURDATE, CURTIME3)
		AND   CE2.RESULT_STATUS_CD  IN (25.00, 35.00)
		AND   CE2.EVENT_TITLE_TEXT = "Facility Charge Ticket 2.0 MD"
		AND	  CE2.person_id  = CE1.person_id
		AND   CE2.encntr_id  = CE1.encntr_id
	JOIN CE3
		WHERE CE3.PARENT_EVENT_ID = CE2.EVENT_ID
		AND   CE3.VALID_UNTIL_DT_TM  > CNVTDATETIME(CURDATE, CURTIME3)
		AND   CE3.RESULT_STATUS_CD IN (25.00, 35.00)
		AND   CE3.person_id = CE2.person_id
		AND   CE3.encntr_id = CE2.encntr_id
		;and   ce3.task_assay_cd IN (102250317.00, 102278325.00)
		AND CE3.event_cd IN (102250423.00,102291170.00)
		;AND CE3.result_val IN ("Transfer to other facility", "TOB Transfer to OB", "TOR Transfer to OR")
 
	    DETAIL
	    IF(CE3.result_val NOT IN ("Standard ED Encounter"))
	    	rs->qual[d1.seq].Discharge_Dispo = CE3.result_val
	    ENDIF
	    WITH NOCOUNTER
	endif
 
	if($formatType = "1")
		if($delType = "1")
			select into $OUTDEV
			LocationCD 					=	rs->qual[d.seq].LocationCD,
			RTI_Division				= 	trim(rtiDivision,3),
			LocationName				=	rs->qual[d.seq].LocationName,
			Fin							=	rs->qual[d.seq].Fin,
			MRN							=	rs->qual[d.seq].MRN,
			DOS							=	rs->qual[d.seq].DOS,
			Chief_Complaint				=	trim(substring(1, 800,replace(rs->qual[d.seq].Chief_Complaint, char(13), "")),3),
			Tracking_acuity				=	substring(1, 500,rs->qual[d.seq].Tracking_acuity)	,
			Discharge_Dispo				=	substring(1, 500,rs->qual[d.seq].Discharge_Dispo)	,
			;F1CT_Dispo					=   substring(1, 500,rs->qual[d.seq].FCT_DISPO)	,
			Pat_FullName				=	substring(1, 100,rs->qual[d.seq].Pat_FullName)	,
			Pat_LastName				=	substring(1, 100,rs->qual[d.seq].Pat_LastName),
			Pat_FirstName				=	substring(1, 100,rs->qual[d.seq].Pat_FirstName),
			Pat_MiddleName				=	substring(1, 100,rs->qual[d.seq].Pat_MiddleName),
			Address_Line_1 				=	substring(1, 100,rs->qual[d.seq].Address_Line_1)	,
			Address_Line_2				=	substring(1, 100,rs->qual[d.seq].Address_Line_2),
			City						=	substring(1, 100,rs->qual[d.seq].City),
			State						=	substring(1, 100,rs->qual[d.seq].State),
			ZIP_Code					=	substring(1, 100,rs->qual[d.seq].ZIP_Code),
			Pat_Home_Phon				=	substring(1, 100,rs->qual[d.seq].Pat_Home_Phon),
			SSN 						=	substring(1, 100,rs->qual[d.seq].SSN)	,
			DOB 						=	substring(1, 100,rs->qual[d.seq].DOB),
			AGE							=	substring(1, 100,rs->qual[d.seq].AGE),
			GENDER 						=	substring(1, 100,rs->qual[d.seq].GENDER)	,
			Marital_Status 				=	substring(1, 100,rs->qual[d.seq].Marital_Status)	,
			Insurance_Name 				=	substring(1, 100,rs->qual[d.seq].Insurance_Name),
			Insurance_Address  			=	substring(1, 100,rs->qual[d.seq].Insurance_Address),
			Insurance_Address2			=	substring(1, 100,rs->qual[d.seq].Insurance_Address2),
			Insurance_City 				=	substring(1, 100,rs->qual[d.seq].Insurance_City),
			Insurance_STATE 			=	substring(1, 100,rs->qual[d.seq].Insurance_STATE),
			Insurance_ZIP 				=	substring(1, 100,rs->qual[d.seq].Insurance_ZIP),
			Financial_Class 			=	substring(1, 100,rs->qual[d.seq].Financial_Class),
			Plan_Type 					=	substring(1, 100,rs->qual[d.seq].Plan_Type),
			Insurance_Description 		=	substring(1, 100,rs->qual[d.seq].Insurance_Description),
			Group_Number 				=	substring(1, 100,rs->qual[d.seq].Group_Number),
			Group_Name 					=	substring(1, 100,rs->qual[d.seq].Group_Name),
			Policy_Num 					=	substring(1, 100,rs->qual[d.seq].Policy_Num),
			Reltn_To_Subscriber 		=	substring(1, 100,rs->qual[d.seq].Reltn_To_Subscriber),
			Subscriber_Last_Name		=	substring(1, 100,rs->qual[d.seq].Subscriber_Last_Name),
			Subscriber_First_Name 		=	substring(1, 100,rs->qual[d.seq].Subscriber_First_Name),
			Subscriber_Middle_Name		=	substring(1, 100,rs->qual[d.seq].Subscriber_Middle_Name),
			Subscriber_Address_Line_1 	=	substring(1, 200,rs->qual[d.seq].Subscriber_Address_Line_1),
			Subscriber_Address_Line_2	=	substring(1, 200,rs->qual[d.seq].Subscriber_Address_Line_2),
			Subscriber_City				=	substring(1, 10,rs->qual[d.seq].Subscriber_City),
			Subscriber_State			=	substring(1, 100,rs->qual[d.seq].Subscriber_State),
			Subscriber_ZIP_Code			=	substring(1, 100,rs->qual[d.seq].Subscriber_ZIP_Code),
			Subscriber_Employer_Name	=	substring(1, 100,rs->qual[d.seq].Subscriber_Employer_Name),
			Subscriber_Employer_Address	=	substring(1, 100,rs->qual[d.seq].Subscriber_Employer_Address),
			Subscriber_Employer_Address2=	substring(1, 100,rs->qual[d.seq].Subscriber_Employer_Address2),
			Subscriber_Employer_City 	=	substring(1, 100,rs->qual[d.seq].Subscriber_Employer_City),
			Subscriber_Employer_STATE 	=	substring(1, 100,rs->qual[d.seq].Subscriber_Employer_STATE),
			Subscriber_Employer_ZIP 	=	substring(1, 10,rs->qual[d.seq].Subscriber_Employer_ZIP),
			Employer_Name 				=	substring(1, 200,rs->qual[d.seq].Employer_Name),
			Employer_Address  			=	substring(1, 200,rs->qual[d.seq].Employer_Address),
			Employer_Address2 			=	substring(1, 200,rs->qual[d.seq].Employer_Address2),
			Employer_City 				=	substring(1, 100,rs->qual[d.seq].Employer_City),
			Employer_STATE 				=	substring(1, 100,rs->qual[d.seq].Employer_STATE),
			Employer_ZIP 				=	substring(1, 10,rs->qual[d.seq].Employer_ZIP),
			Employer_PHONE 				=	substring(1, 20,rs->qual[d.seq].Employer_PHONE),
			Registration_Date 			=	substring(1, 30,rs->qual[d.seq].Registration_Date),
			Registration_Time 			=	substring(1, 20,rs->qual[d.seq].Registration_Time),
			Discharge_Date 				=	substring(1, 30,rs->qual[d.seq].Discharge_Date),
			Discharge_Time 				=	substring(1, 20,rs->qual[d.seq].Discharge_Time),
			Triage_Date 				=	substring(1, 30,rs->qual[d.seq].Triage_Date),
			Triage_Time 				=	substring(1, 20,rs->qual[d.seq].Triage_Time),
			Triage 						=	substring(1, 200,rs->qual[d.seq].Triage),
			EMPI						=	substring(1, 20,rs->qual[d.seq].EMPI),
			Primary_PayorID				= substring(1,20,rs->qual[d.seq].Primary_PayorID),
;			Secondary_Financial_Class 	= substring(1, 100,rs->qual[d.seq].Secondary_Financial_Class),
;			Secondary_Plan_Type			= substring(1, 100,rs->qual[d.seq].Secondary_Plan_Type),
;			Secondary_Insurance_Description= substring(1, 100,rs->qual[d.seq].Secondary_Insurance_Description),
;			Secondary_Group_Number 		= substring(1, 100,rs->qual[d.seq].Secondary_Group_Number),
;			Secondary_Group_Name 			= substring(1, 100,rs->qual[d.seq].Secondary_Group_Name),
;			Secondary_Policy_Num			= substring(1, 100,rs->qual[d.seq].Secondary_Policy_Num),
			Secondary_PayorID				= substring(1, 100,rs->qual[d.seq].Secondary_PayorID)
			FROM (DUMMYT d WITH SEQ = size(rs->qual,5))
			plan d order by rs->qual[d.seq].Pat_FullName
			;WITH NOCOUNTER ,  FORMAT, separator = "  ", check
			with nocounter, format, format=stream, separator=" ", pcformat('"', ',',1),COMPRESS, check
		elseif($delType = "2")
			select into  value($OUTDEV)
			LocationCD 					=	rs->qual[d.seq].LocationCD,
			RTI_Division				= 	trim(rtiDivision,3),
			LocationName				=	rs->qual[d.seq].LocationName,
			Fin							=	rs->qual[d.seq].Fin,
			MRN							=	rs->qual[d.seq].MRN,
			DOS							=	rs->qual[d.seq].DOS,
			Chief_Complaint				=	trim(substring(1, 800,replace(rs->qual[d.seq].Chief_Complaint, char(13), "")),3),
			Tracking_acuity				=	substring(1, 500,rs->qual[d.seq].Tracking_acuity)	,
			Discharge_Dispo				=	substring(1, 500,rs->qual[d.seq].Discharge_Dispo)	,
			;F1CT_Dispo					=   substring(1, 500,rs->qual[d.seq].FCT_DISPO)	,
			Pat_FullName				=	substring(1, 100,rs->qual[d.seq].Pat_FullName)	,
			Pat_LastName				=	substring(1, 100,rs->qual[d.seq].Pat_LastName),
			Pat_FirstName				=	substring(1, 100,rs->qual[d.seq].Pat_FirstName),
			Pat_MiddleName				=	substring(1, 100,rs->qual[d.seq].Pat_MiddleName),
			Address_Line_1 				=	substring(1, 100,rs->qual[d.seq].Address_Line_1)	,
			Address_Line_2				=	substring(1, 100,rs->qual[d.seq].Address_Line_2),
			City						=	substring(1, 100,rs->qual[d.seq].City),
			State						=	substring(1, 100,rs->qual[d.seq].State),
			ZIP_Code					=	substring(1, 100,rs->qual[d.seq].ZIP_Code),
			Pat_Home_Phon				=	substring(1, 100,rs->qual[d.seq].Pat_Home_Phon),
			SSN 						=	substring(1, 100,rs->qual[d.seq].SSN)	,
			DOB 						=	substring(1, 100,rs->qual[d.seq].DOB),
			AGE							=	substring(1, 100,rs->qual[d.seq].AGE),
			GENDER 						=	substring(1, 100,rs->qual[d.seq].GENDER)	,
			Marital_Status 				=	substring(1, 100,rs->qual[d.seq].Marital_Status)	,
			Insurance_Name 				=	substring(1, 100,rs->qual[d.seq].Insurance_Name),
			Insurance_Address  			=	substring(1, 100,rs->qual[d.seq].Insurance_Address),
			Insurance_Address2			=	substring(1, 100,rs->qual[d.seq].Insurance_Address2),
			Insurance_City 				=	substring(1, 100,rs->qual[d.seq].Insurance_City),
			Insurance_STATE 			=	substring(1, 100,rs->qual[d.seq].Insurance_STATE),
			Insurance_ZIP 				=	substring(1, 100,rs->qual[d.seq].Insurance_ZIP),
			Financial_Class 			=	substring(1, 100,rs->qual[d.seq].Financial_Class),
			Plan_Type 					=	substring(1, 100,rs->qual[d.seq].Plan_Type),
			Insurance_Description 		=	substring(1, 100,rs->qual[d.seq].Insurance_Description),
			Group_Number 				=	substring(1, 100,rs->qual[d.seq].Group_Number),
			Group_Name 					=	substring(1, 100,rs->qual[d.seq].Group_Name),
			Policy_Num 					=	substring(1, 100,rs->qual[d.seq].Policy_Num),
			Reltn_To_Subscriber 		=	substring(1, 100,rs->qual[d.seq].Reltn_To_Subscriber),
			Subscriber_Last_Name		=	substring(1, 100,rs->qual[d.seq].Subscriber_Last_Name),
			Subscriber_First_Name 		=	substring(1, 100,rs->qual[d.seq].Subscriber_First_Name),
			Subscriber_Middle_Name		=	substring(1, 100,rs->qual[d.seq].Subscriber_Middle_Name),
			Subscriber_Address_Line_1 	=	substring(1, 200,rs->qual[d.seq].Subscriber_Address_Line_1),
			Subscriber_Address_Line_2	=	substring(1, 200,rs->qual[d.seq].Subscriber_Address_Line_2),
			Subscriber_City				=	substring(1, 10,rs->qual[d.seq].Subscriber_City),
			Subscriber_State			=	substring(1, 100,rs->qual[d.seq].Subscriber_State),
			Subscriber_ZIP_Code			=	substring(1, 100,rs->qual[d.seq].Subscriber_ZIP_Code),
			Subscriber_Employer_Name	=	substring(1, 100,rs->qual[d.seq].Subscriber_Employer_Name),
			Subscriber_Employer_Address	=	substring(1, 100,rs->qual[d.seq].Subscriber_Employer_Address),
			Subscriber_Employer_Address2=	substring(1, 100,rs->qual[d.seq].Subscriber_Employer_Address2),
			Subscriber_Employer_City 	=	substring(1, 100,rs->qual[d.seq].Subscriber_Employer_City),
			Subscriber_Employer_STATE 	=	substring(1, 100,rs->qual[d.seq].Subscriber_Employer_STATE),
			Subscriber_Employer_ZIP 	=	substring(1, 10,rs->qual[d.seq].Subscriber_Employer_ZIP),
			Employer_Name 				=	substring(1, 200,rs->qual[d.seq].Employer_Name),
			Employer_Address  			=	substring(1, 200,rs->qual[d.seq].Employer_Address),
			Employer_Address2 			=	substring(1, 200,rs->qual[d.seq].Employer_Address2),
			Employer_City 				=	substring(1, 100,rs->qual[d.seq].Employer_City),
			Employer_STATE 				=	substring(1, 100,rs->qual[d.seq].Employer_STATE),
			Employer_ZIP 				=	substring(1, 10,rs->qual[d.seq].Employer_ZIP),
			Employer_PHONE 				=	substring(1, 20,rs->qual[d.seq].Employer_PHONE),
			Registration_Date 			=	substring(1, 30,rs->qual[d.seq].Registration_Date),
			Registration_Time 			=	substring(1, 20,rs->qual[d.seq].Registration_Time),
			Discharge_Date 				=	substring(1, 30,rs->qual[d.seq].Discharge_Date),
			Discharge_Time 				=	substring(1, 20,rs->qual[d.seq].Discharge_Time),
			Triage_Date 				=	substring(1, 30,rs->qual[d.seq].Triage_Date),
			Triage_Time 				=	substring(1, 20,rs->qual[d.seq].Triage_Time),
			Triage 						=	substring(1, 200,rs->qual[d.seq].Triage),
			EMPI						=	substring(1, 20,rs->qual[d.seq].EMPI),
			Primary_PayorID				= substring(1,20,rs->qual[d.seq].Primary_PayorID),
;			Secondary_Financial_Class 	= substring(1, 100,rs->qual[d.seq].Secondary_Financial_Class),
;			Secondary_Plan_Type			= substring(1, 100,rs->qual[d.seq].Secondary_Plan_Type),
;			Secondary_Insurance_Description= substring(1, 100,rs->qual[d.seq].Secondary_Insurance_Description),
;			Secondary_Group_Number 		= substring(1, 100,rs->qual[d.seq].Secondary_Group_Number),
;			Secondary_Group_Name 			= substring(1, 100,rs->qual[d.seq].Secondary_Group_Name),
;			Secondary_Policy_Num			= substring(1, 100,rs->qual[d.seq].Secondary_Policy_Num),
			Secondary_PayorID				= substring(1, 100,rs->qual[d.seq].Secondary_PayorID)
			FROM (DUMMYT d WITH SEQ = size(rs->qual,5))
			plan d order by rs->qual[d.seq].Pat_FullName
			with nocounter, format, format=stream, separator=" ", pcformat('"', ',',1),COMPRESS, check
		endif
 	elseif($formatType = "2")
 		if($delType = "1")
			select into $OUTDEV
			Account						=	rs->qual[d.seq].Fin,
			Pat_LastName				=	substring(1, 100,rs->qual[d.seq].Pat_LastName),
			Pat_FirstName				=	substring(1, 100,rs->qual[d.seq].Pat_FirstName),
			AGE							=	substring(1, 100,rs->qual[d.seq].AGE),
			GENDER 						=	substring(1, 100,rs->qual[d.seq].GENDER),
			Discharge_Dispo				=	substring(1, 500,rs->qual[d.seq].Discharge_Dispo),
			DOS_DATE					=	rs->qual[d.seq].DOS_DATE,
			DOS_TIME					=	rs->qual[d.seq].DOS_TIME,
			EMPI						=	substring(1, 20,rs->qual[d.seq].EMPI)
			FROM (DUMMYT d WITH SEQ = size(rs->qual,5))
			plan d order by rs->qual[d.seq].Pat_FullName
			WITH NOCOUNTER ,  FORMAT, separator = "  ", check
		elseif($delType = "2")
			select into  value($OUTDEV)
			Account						=	rs->qual[d.seq].Fin,
			Pat_LastName				=	substring(1, 100,rs->qual[d.seq].Pat_LastName),
			Pat_FirstName				=	substring(1, 100,rs->qual[d.seq].Pat_FirstName),
			AGE							=	substring(1, 100,rs->qual[d.seq].AGE),
			GENDER 						=	substring(1, 100,rs->qual[d.seq].GENDER),
			Discharge_Dispo				=	substring(1, 500,rs->qual[d.seq].Discharge_Dispo),
			DOS_DATE					=	rs->qual[d.seq].DOS_DATE,
			DOS_TIME					=	rs->qual[d.seq].DOS_TIME,
			EMPI						=	substring(1, 20,rs->qual[d.seq].EMPI)
			FROM (DUMMYT d WITH SEQ = size(rs->qual,5))
			plan d order by rs->qual[d.seq].Pat_FullName
			with nocounter, format, format=stream, separator=" ", pcformat('"', ',',1),COMPRESS, check
		endif
 	endif
endif
;--------------------------------------------------------------------------------------------
;  Subroutine to generate ADT CSV File
;--------------------------------------------------------------------------------------------
 
 
/**************************************************************
; DVDev DEFINED SUBROUTINES
**************************************************************/
 
end
go
 
