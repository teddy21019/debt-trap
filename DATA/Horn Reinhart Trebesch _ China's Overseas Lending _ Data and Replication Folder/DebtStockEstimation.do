

*	Estimating outstanding debt owed to China

*	This do-file estimates the outstanding debt stocks owed to Chinese official creditors by 108 countries 
*	from 2000 to 2017 based on the loan-level data (HRT _ ConsensusDatabase.xlsx) and based on exchange rate data 
*	from the IMF International Financial Statistics (FXRates.dta) as well as on Libor data from the ICE Benchmark 
*	Administration (LIBOR.dta).




clear all

*Choose path 	
global path ""

import excel "${path}\HRT _ ConsensusDatabase.xlsx", sheet("Data") firstrow


*Drop grants, undisbursed loans and transactions prior to 2000
keep if DebtEstimateSample == 1


*****************************************
* Intrapolate Loan Terms
*****************************************

merge m:1 Year using "${path}\Libor.dta"
drop _merge

*Currency
replace Commitment = CommitmentUSD if Commitment == .
replace Currency   = "USD" 		   if Currency   == ""

*Commercial Banks, CDB and supplier credits
replace Maturity = 13 			if Maturity == .  & LoanType  == "Commercial"
replace GraceP   = 4 			if GraceP == . 	  & LoanType  == "Commercial"
replace Interest = LIBOR + 2	if Interest == .  & LoanType  == "Commercial"

*Zero-Interest Loans
replace Maturity = 20 if LoanType == "Zero-Interest Loan" & Maturity == . 
replace Grace    = 10 if LoanType == "Zero-Interest Loan" & GraceP   == . 

*Concessional Loans
replace Maturity = 20 			if Maturity == .  & LoanType == "Concessional"
replace GraceP   = 5 			if GraceP == . 	  & LoanType == "Concessional"
replace Interest = 2 			if Interest == .  & LoanType == "Concessional"

*Assume concessional lending terms for unknown Loan Types
replace Maturity  = 20  if LoanType == "" & Maturity == .
replace GraceP    = 5   if LoanType == "" & GraceP   == .
replace Interest  = 2   if LoanType == "" & Interest == .


*****************************************
*Map Flows into Stocks
*****************************************

*Gen End of Grace Period and Maturity Years
gen EndofGracePeriod = Year + round(GracePeriod, 1)
gen YearofMaturity   = Year + round(Maturity, 1)
gen AnnualRepayment  = Commitment /(round(Maturity, 1) - round(GracePeriod, 1))


*Debt without sluggish disbursement schedule 
forvalues num = 2000(1)2017 {
	gen Db`num' = cond(`num' < Year, 0, ///
	cond(`num' <= EndofGracePeriod, Commitment, ///
	cond(`num' <= YearofMaturity,  Commitment - (`num' - EndofGracePeriod)*AnnualRepayment, 0)))
}

*Debt with sluggish disbursement shedule 
forvalues num = 2000(1)2017 {
	gen Db_dis`num' = 0
	quietly replace Db_dis`num' = (Commitment/round(GracePeriod, 1))*(`num' - Year + 1) if `num' >= Year & `num' < EndofGracePeriod
	quietly replace Db_dis`num' = Commitment if `num' == EndofGracePeriod
	quietly replace Db_dis`num' = Db`num' if `num' > EndofGracePeriod
}

*Generate Repayment & Debt Service Variables
gen Rb2000 = 0

forvalues num = 2001/2017 {
	gen Rb`num' = cond(Db`--num' - Db`++num' > 0, AnnualRepayment, 0) ///
	+ (cond(missing(InterestRate),0,InterestRate)/100)*Db`--num'
}


*********************************************************************
*Reshape data from wide to long and define different debt aggregates
*********************************************************************

*Gen reshape id
sort RecipientCountry Year
gen id = _n

rename Year YearIssued
reshape long Db Db_dis Rb, i(id) j(Year)
drop id


*Public Sector Debt only (Dc)
gen Dc = Db
replace Dc = 0 if PublicSector == 0

gen Rc = Rb
replace Rc = 0 if PublicSector == 0


*Only official bilateral creditors & Public recipients
gen De = Db
replace De = 0 if PublicSector == 0 | CommercialBank ==1

gen Re = Rb
replace Re = 0 if PublicSector == 0 | CommercialBank ==1


*Due to rounding, some loans are more than fully repaid and the outstanding balance turns slightly negative
foreach var of varlist Db Db_dis Rb De Re Dc Rc {
	replace `var' = 0 if `var'<0
}


************************
*Transfer into USD
************************

*Fx Rates
merge m:1 Currency Year using "${path}\FXRates.dta"
drop if _merge == 2
drop _merge


foreach var of varlist Db Db_dis Rb De Re Dc Rc {
	replace `var' = `var' / FXRate
}

****************
*Collapse Data
****************

collapse (sum) Db Db_dis Rb Dc Rc De Re, by(RecipientCountry Year)

local debtvars Db Dc De Rb Rc Re Db_dis
foreach x of local debtvars{
format %21.0fc `x'
}


********************
*Variable labels
********************

label var Db 		"Total ext. debt to all CHN creditors in nom USD"
label var Db_dis	"Total ext. debt to all CHN creditors in nom USD - sluggish disbursements"
label var Dc 		"Total ext. public debt to all CHN creditors in nom USD"
label var De		"Total ext. public debt to CHN bilateral creditors (according to IDS) in nom USD"

label var Rb		"Principal & interest on ext. debt to all CHN creditors in nom USD"
label var Rc		"Principal & interest on ext. public debt to all CHN creditors in nom USD"
label var Re		"Principal & interest on ext. public debt to CHN bilateral creditors in nom USD"

browse
