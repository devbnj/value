# *************************************************************************
# $Id: value.sql 
#
#  Value ERP
#  (c) Copyright 1996-2005, Emryn International, LLC
#  (c) Copyright IMP Systems, INC
#  All Rights Reserved
#  Date of release: 12/15/2005
#  Version: 2.4
#
# Released under the GNU General Public License
#
# NOTE: * Please dont make any modifications to this file 
#       * DO NOT use a mysqldump created file for new changes!
#       * Comments should be like these, full line comments.
# *************************************************************************
# If running on MySQL Command Line
# >drop database value;
# >create database value;
# >use value;
# >\t
# >\T value_setup.log
# >\. value.sql
# >\t
# *************************************************************************

DROP TABLE IF EXISTS inventorymaster;	
DROP TABLE IF EXISTS inventorydetail;
DROP TABLE IF EXISTS inventorytransaction;
DROP TABLE IF EXISTS inventoryadjustment;		
DROP TABLE IF EXISTS serialinventory;
DROP TABLE IF EXISTS nonassetinventory;
DROP TABLE IF EXISTS materialreturn;
DROP TABLE IF EXISTS deductions;
DROP TABLE IF EXISTS departmentevents;
DROP TABLE IF EXISTS employeereview;
DROP TABLE IF EXISTS esalary;
DROP TABLE IF EXISTS grievance;
DROP TABLE IF EXISTS hourlypay;
DROP TABLE IF EXISTS jobcategory;
DROP TABLE IF EXISTS jobopportunities;
DROP TABLE IF EXISTS compensation;
DROP TABLE IF EXISTS locks;
DROP TABLE IF EXISTS logininfo;
DROP TABLE IF EXISTS managebyobjective;
DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS nonworkdays;
DROP TABLE IF EXISTS project;
DROP TABLE IF EXISTS schedule;
DROP TABLE IF EXISTS skills;
DROP TABLE IF EXISTS taxratetables;
DROP TABLE IF EXISTS timesheet;
DROP TABLE IF EXISTS training;
DROP TABLE IF EXISTS trainingcourses;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS hrdepartment;
DROP TABLE IF EXISTS companydepartment;
DROP TABLE IF EXISTS companylocation;
DROP TABLE IF EXISTS constraints;
DROP TABLE IF EXISTS contact;
DROP TABLE IF EXISTS customerrequirements;
DROP TABLE IF EXISTS document;
DROP TABLE IF EXISTS forecast;
DROP TABLE IF EXISTS forecastdecisioncriteria;
DROP TABLE IF EXISTS forecaststageweight;
DROP TABLE IF EXISTS industry;
DROP TABLE IF EXISTS leadmanagment;
DROP TABLE IF EXISTS lostlead;
DROP TABLE IF EXISTS message;
DROP TABLE IF EXISTS promotion;
DROP TABLE IF EXISTS promotionmetrics;
DROP TABLE IF EXISTS prospect;
DROP TABLE IF EXISTS task;
DROP TABLE IF EXISTS team;
DROP TABLE IF EXISTS campaign;
DROP TABLE IF EXISTS custhistory;
DROP TABLE IF EXISTS salescrnote;
DROP TABLE IF EXISTS invoicelines;
DROP TABLE IF EXISTS invoicesettlelines;
DROP TABLE IF EXISTS invoice;
DROP TABLE IF EXISTS salesorderlines;
DROP TABLE IF EXISTS salesorder;
DROP TABLE IF EXISTS custprefs;
DROP TABLE IF EXISTS itemstag;
DROP TABLE IF EXISTS issuesubcont;
DROP TABLE IF EXISTS jobreturn;
DROP TABLE IF EXISTS issuejob;
DROP TABLE IF EXISTS purchdebitnote;
DROP TABLE IF EXISTS receiving;
DROP TABLE IF EXISTS purchorder;
DROP TABLE IF EXISTS custprofile;
DROP TABLE IF EXISTS originate;
DROP TABLE IF EXISTS prefers;
DROP TABLE IF EXISTS cashregs;
DROP TABLE IF EXISTS shop;
DROP TABLE IF EXISTS settlement;
DROP TABLE IF EXISTS department;
DROP TABLE IF EXISTS warehouse;
DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS jobs;
DROP TABLE IF EXISTS itemsalestax;
DROP TABLE IF EXISTS itemunits;
DROP TABLE IF EXISTS itemgroup;
DROP TABLE IF EXISTS itemsection;
DROP TABLE IF EXISTS itemlocn;
DROP TABLE IF EXISTS jourlines;
DROP TABLE IF EXISTS journals;
DROP TABLE IF EXISTS bookref;
DROP TABLE IF EXISTS analysis;
DROP TABLE IF EXISTS subledger;
DROP TABLE IF EXISTS activity;
DROP TABLE IF EXISTS activitygroup;
DROP TABLE IF EXISTS chartacs;
DROP TABLE IF EXISTS groupfile;
DROP TABLE IF EXISTS grouper;
DROP TABLE IF EXISTS pword;
DROP TABLE IF EXISTS accyear;
DROP TABLE IF EXISTS company;
DROP TABLE IF EXISTS organization;
DROP TABLE IF EXISTS dashboard;

CREATE TABLE dashboard (
	dashboard_id integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
	dtodo varchar(90),
	dtodo_date date,
	dissues varchar(90),
	issues_date date
) ;

CREATE TABLE organization (
	organization_id integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
	organization_name varchar (90) NOT NULL,
	type varchar(90) NOT NULL ,
	description varchar(254)
) ;


create table company
	(cconum   integer NOT NULL PRIMARY KEY,
	 cconame  varchar(90),
	 orgid    integer,
	 index    org_ind(orgid),
	 ctype    varchar(90), 
	 cadd1    varchar(90),
	 cadd2    varchar(90),
	 ccity    varchar(90),
	 czip     varchar(90),
	 cstate   varchar(90),
	 cregion  varchar(90), 
	 ccountry varchar(90),
	 clang    varchar(90), 
         csector  varchar(90), 
	 ccoshort varchar(10), 
	 clocstax varchar(90), 
	 cststax  varchar(90), 
	 cctstax  varchar(90), 
	 citax    varchar(90), 
         cestab   varchar(90), 
	 cphone   varchar(90),
	 cfax     varchar(90),
	 locationid integer,
	 companysic_id integer,
	 companyrevenue decimal(20, 4),
	 companynumofemployees varchar(10),
 	 contactid integer ,
	 taxnumber varchar(90), 
	 cemail   varchar(90),
         cwww     varchar(90),
         ccert    varchar(90),  
         CONSTRAINT org_fk FOREIGN KEY (orgid) REFERENCES organization (organization_id)
         on delete cascade
) ;

create table accyear
        (aconum     integer NOT NULL,  
         index      co_ind1(aconum),
         ayearno    integer NOT NULL,      
         ast_date   date NOT NULL , 
         aen_date   date NOT NULL , 
         CONSTRAINT acc_pk PRIMARY KEY (aconum, ayearno),
         CONSTRAINT acc_ck check (aen_date >= ast_date),
         CONSTRAINT acc_fk FOREIGN KEY (aconum)    
                    references company(cconum)     
                    on delete cascade
) ;


create table pword
	(pwuser     varchar(90) NOT NULL PRIMARY KEY,  
	 pwword     varchar(12) NOT NULL, 
	 email      varchar(90) NOT NULL,
	 table_owner        VARCHAR(50), 
	 role           VARCHAR(20), 
	 responsibility VARCHAR(20)
) ;

create table groupfile
	(rsubgrp    integer NOT NULL PRIMARY KEY,     
	 rdescribe  varchar(90),                    
	 rdrbal     decimal(20,4) NOT NULL, 
	 rcrbal     decimal(20,4) NOT NULL,
         rconum     integer NOT NULL,
         ryrno      integer NOT NULL,
         index      co_ind3(rconum, ryrno),
         CONSTRAINT groupfile_fk FOREIGN KEY (rconum, ryrno)
                    references accyear(aconum, ayearno)
) ;

create table grouper
	(group_id   integer NOT NULL PRIMARY KEY,
	 group_desc varchar(90)
) ;

INSERT INTO grouper VALUES(100, 'Assets');
INSERT INTO grouper VALUES(200, 'Liability');
INSERT INTO grouper VALUES(300, 'Income');
INSERT INTO grouper VALUES(400, 'Expense');
INSERT INTO grouper VALUES(500, 'Contra');

create table chartacs
	(gac_head   integer NOT NULL PRIMARY KEY AUTO_INCREMENT, 
	 gdesc      varchar(90) NOT NULL, 
	 gopdr      decimal(20,4) NOT NULL,   
	 gopcr      decimal(20,4) NOT NULL,
	 gdr        decimal(20,4) NOT NULL,   
	 gcr        decimal(20,4) NOT NULL,
	 gbudgdr    decimal(20,4) ,         
	 gbudgcr    decimal(20,4) ,
	 ggroup     integer NOT NULL,       
	 gsubyn     char(1),                
	 gsubgrp    integer NOT NULL,       
         index      grp_ind4(gsubgrp),
         gconum     integer NOT NULL,
         gyrno      integer NOT NULL,
         index      co_ind4(gconum, gyrno),
         gtype      varchar(3),         
	 CONSTRAINT subgrp_fk FOREIGN KEY 
                    (gsubgrp) references groupfile (rsubgrp) on delete cascade,
         CONSTRAINT chartacs_fk FOREIGN KEY (gconum, gyrno)
                    references accyear(aconum, ayearno) on delete cascade,
	 CONSTRAINT ggroup_ck 
                    check (ggroup in (100,200,300,400,500)),
         CONSTRAINT gsubyn_ck 
                    check (gsubyn is null or gsubyn in ('Y', 'N'))
) ;

create table activitygroup
	(aggrp      integer NOT NULL PRIMARY KEY AUTO_INCREMENT,     
	 agdescribe varchar(90),                
	 agdrbal    decimal(20,4) , 
	 agcrbal    decimal(20,4) ,
         agconum    integer NOT NULL,
         agyrno     integer NOT NULL,
         index      co_ind5(agconum, agyrno),
         CONSTRAINT agroup_fk FOREIGN KEY (agconum, agyrno)
                    references accyear(aconum, ayearno)
) ;

create table activity
	(accode    integer NOT NULL PRIMARY KEY AUTO_INCREMENT,        
	 adesc      varchar(90) NOT NULL, 
	 abudgdr    decimal(20,4) ,          
	 abudgcr    decimal(20,4) ,
	 aopdr      decimal(20,4) ,  
	 aopcr      decimal(20,4) ,
	 adr        decimal(20,4),   
	 acr        decimal(20,4),
	 asubgrp    integer NOT NULL,                   
         index      grp_ind6(asubgrp),
         aconum     integer NOT NULL,
         ayrno      integer NOT NULL,
         index      co_ind6(aconum, ayrno),
	 CONSTRAINT acgroup1_fk FOREIGN KEY 
                    (asubgrp) references activitygroup (aggrp),
         CONSTRAINT activity_fk FOREIGN KEY (aconum, ayrno)
                    references accyear(aconum, ayearno)
) ;

create table subledger
	(sid        integer NOT NULL PRIMARY KEY AUTO_INCREMENT,  
	 sdesc      varchar(90) NOT NULL, 
	 sadd1      varchar(90),              
     sadd2      varchar(90),                       
     scity      varchar(90),
     sstate     varchar(90),
     szip       varchar(90),
	 sfax       varchar(90),
	 sltaxno    varchar(90),               
	 sstaxno    varchar(90),		
	 sctaxno    varchar(90),		
	 scontact   varchar(90),              
	 sphone     varchar(90),              
	 semail     varchar(90),              
	 sopdr      decimal(20,4),
	 sopcr      decimal(20,4),
	 sdr        decimal(20,4),
	 scr        decimal(20,4),
	 sac_head   integer NOT NULL,
         index      ac_ind7(sac_head),
         sconum     integer NOT NULL,
         syrno      integer NOT NULL,
         index      co_ind7(sconum, syrno),
         CONSTRAINT sac_fk
                    FOREIGN KEY (sac_head) references chartacs (gac_head)
                    on delete cascade,
         CONSTRAINT subledger_fk FOREIGN KEY (sconum, syrno)
                    references accyear(aconum, ayearno)
) ;


create table analysis
        (analys     integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
	 adescribe  varchar(35),
         aconum     integer NOT NULL,
         ayrno      integer NOT NULL,
         index      co_ind8(aconum, ayrno),
         CONSTRAINT analysis_fk FOREIGN KEY (aconum, ayrno)
                    references accyear(aconum, ayearno)
) ;


create table bookref
	(
	 bkref integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
	 bkdesc varchar(90)
) ;

create table journals
	(
	 jrno       integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
	 jrefno     varchar(30),
         jdate      date NOT NULL,
	 jcheck     varchar(30),
	 jcheckdate date,
	 jinvno     varchar(90),
         jidate     date ,
	 jdelynote  varchar(90),
         jorder     integer,
	 janalysis  integer,
         index      anl_ind9(janalysis),
	 jactivity  integer,
         index      act_ind9(jactivity),
	 jdetails   varchar(90),
	 jnarration varchar(90),
	 jdr        decimal(20,4),
	 jcr        decimal(20,4),
	 jbkref     integer,
         index      ac_ind91(jbkref),
         jentryby   varchar(90),
         index      pw_ind9(jentryby),
         vmdfydate  date,
         vmdfyby    varchar(90),
         jconum     integer NOT NULL,
         jyrno      integer NOT NULL,
         index      co_ind9(jconum, jyrno),
         CONSTRAINT vouchers_fk FOREIGN KEY (jconum, jyrno)
                    references accyear(aconum, ayearno),
         CONSTRAINT vchrspw_fk FOREIGN KEY (jentryby)
                    references pword(pwuser),
         CONSTRAINT vlactivity_fk FOREIGN KEY (jactivity)
                    references activity(accode),
         CONSTRAINT vanalysis_fk FOREIGN KEY (janalysis)
                    references analysis(analys),
	 CONSTRAINT vbk_fk FOREIGN KEY (jbkref) 
                    references bookref (bkref)
) ;

create table jourlines
	(
	 jlrno      integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
	 jlsrno     integer NOT NULL,
	 index      jr_ind1(jlsrno),
         jldate     date NOT NULL,
	 jac_head   integer NOT NULL,
         index      ac_ind90(jac_head),
	 jsubled    integer,
         index      sb_ind9(jsubled),
	 jldr       decimal(20,4),
	 jlcr       decimal(20,4),
	 CONSTRAINT vjr_fk 
                    FOREIGN KEY (jlsrno) 
                    references journals(jrno),
	 CONSTRAINT vac_fk 
                    FOREIGN KEY (jac_head) 
                    references chartacs (gac_head)
) ;

create table itemlocn
	(locn       integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
	 locndesc   varchar(90) NOT NULL,
         larea      numeric(14,4),             
         lconum     integer NOT NULL
) ;


create table itemsection
	(section    integer NOT NULL PRIMARY KEY AUTO_INCREMENT,  
	 sdesc      varchar(90) NOT NULL, 
         sconum     integer NOT NULL
) ;


create table itemgroup
	(igroup     integer NOT NULL PRIMARY KEY AUTO_INCREMENT,  
	 igdesc     varchar(90) NOT NULL, 
	 igopval    decimal(20,4),
	 igrcval    decimal(20,4),
	 igisval    decimal(20,4),
         iconum     integer
) ;


create table itemunits
        (uname      integer NOT NULL PRIMARY KEY AUTO_INCREMENT, 
         udesc      varchar(35),
         uconv      char(3),             
         ufactor    decimal(20,4) ,      
         uconum     integer NOT NULL                
) ; 

create table itemsalestax
        (stype      integer NOT NULL PRIMARY KEY AUTO_INCREMENT,   
         sdesc      varchar(35), 
         sperc      numeric(13,4) NOT NULL 
                    check(SPERC >= 0),
         sconum     integer NOT NULL,
         syrno      integer NOT NULL
) ;


create table jobs
        (jobnum     integer NOT NULL PRIMARY KEY AUTO_INCREMENT,   
         jobdesc    varchar(90) NOT NULL, 
         jdrawno    varchar(25),             
         jac_head   integer NOT NULL,        
         jopval     decimal(20,4) NOT NULL,
         jrcval     decimal(20,4) NOT NULL,  
         jrdval     decimal(20,4) NOT NULL,  
         jconum     integer NOT NULL,
         jyrno      integer NOT NULL
) ;

create table items
	(icode      integer NOT NULL PRIMARY KEY AUTO_INCREMENT,    
	 idesc      varchar(90) NOT NULL,
	 igroup     integer NOT NULL,        
	 INDEX      igroup_ind(igroup),
	 iuom       integer NOT NULL,        
	 INDEX      iuom_ind(iuom),
	 ipprice    decimal (20,4),          
	 isprice1   decimal (20,4),          
	 isprice2   decimal (20,4),
	 isprice3   decimal (20,4),
	 isprice4   decimal (20,4),
	 isprice5   decimal (20,4),
	 iopqty     decimal (20,4), 
	 ircqty     decimal (20,4), 
	 islqty     decimal (20,4), 
	 iopval     decimal (20,4),
	 ircval     decimal (20,4),
	 islval     decimal (20,4),
	 isales     integer NOT NULL, 
	 INDEX      isales_ind(isales),
	 ipurch     integer NOT NULL,   
	 INDEX      ipurch_ind(ipurch),
         istock     integer NOT NULL,   
	 INDEX      istock_ind(istock),
	 inetval    decimal (20,4),     
	 islrate    decimal (20,4),     
	 iaverate   decimal (20,4),     
	 iminstk    decimal (20,4),     
	 isafestk   decimal (20,4),     
	 irelvl     decimal (20,4),     
	 ieoq       decimal (20,4),     
         ilrdate    date,               
         ilidate    date,               
         iconum     integer NOT NULL,
         iyrno      integer NOT NULL,
         CONSTRAINT itemgrp_fk 
		    FOREIGN KEY (igroup) references 
                    itemgroup (igroup),   
         CONSTRAINT itunits_fk FOREIGN KEY (iuom) 
                    references itemunits (uname),
	 CONSTRAINT sales_fk FOREIGN KEY (isales) 
                    references chartacs (gac_head),
	 CONSTRAINT purch_fk FOREIGN KEY (ipurch) 
                    references chartacs (gac_head),
	 CONSTRAINT stock_fk FOREIGN KEY (istock) 
                    references chartacs (gac_head)
) ;

create index indexitemsgrp on items (igroup, icode);
create index indexabc on items (islval DESC);

create table warehouse
        (wnum       integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
         wdesc      varchar(90),
         waddress   varchar(90)
) ;

create table department
        (dnum       integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
         ddesc      varchar(90),
         daddress   varchar(90)
) ;
        
create table settlement
        (stype      integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
         sdesc      varchar(90),
         sperc      decimal(20,4) NOT NULL,
         sac_head   integer NOT NULL,
         INDEX	    isettle(sac_head),
         ssales     decimal(20, 4),
         CONSTRAINT stlac_fk FOREIGN KEY (sac_head)
                    references chartacs (gac_head)
) ;
        

create table shop
        (shopnum    integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
         sdesc      varchar(90),
         saddress   varchar(90),
         sphone     varchar(90),
         sfax       varchar(90),
         smanager   varchar(90),
         ssales     decimal(20, 4)
) ;

create table cashregs
        (regnum     integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
         rdesc      varchar(90),
         rshop      integer NOT NULL,
         INDEX      icashregs_shop(rshop),
         rsales     decimal(20, 4),
         CONSTRAINT cr_fk FOREIGN KEY (rshop)
         	    references shop(shopnum)
) ;

create table prefers
        (prefno     integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
         pdesc      varchar(90),
         pgender    varchar(1) default 'A',
         pconum     integer NOT NULL,
	 CONSTRAINT prefgender_ck 
                    check (pgender in ('M','F','T','C','A'))
) ;

create table originate
        (ono        integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
         owhere     varchar(90)
) ;

create table custprofile
        (custnum    integer NOT NULL PRIMARY KEY,
         cachead    integer,
         INDEX      icustp(cachead),
         cname      varchar(80),
         cgender    varchar(1) default 'A',
         cspouse    varchar(80),
         cdob       date,
         canivers   date,
         caddress   varchar(90),
         caddress2  varchar(90),
         ccity      varchar(90),
         cstate     varchar(90),
         cpostal    varchar(80),
         ccountry   varchar(90),
         cemail     varchar(90),
         cmobile    varchar(90),
         cwphone    varchar(90),
         cbesttime  varchar(4) default 'EVE',
         cconum     integer NOT NULL,
	 CONSTRAINT custgender_ck 
                    check (cgender in ('M','F','T','C','A')),
	 CONSTRAINT custtime_ck 
                    check (cbesttime in ('MORN','NOON','EVE')),
	 CONSTRAINT custsub_fk FOREIGN KEY (cachead) 
                    references subledger (sid)
) ;


create table purchorder
        (ponum      integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
         podate     date ,
         powhouse   integer NOT NULL,
         INDEX 	    ipowhouse(powhouse),
         podept     integer NOT NULL,
         INDEX      ipodept(podept),
         poachead   integer,
         INDEX      ipoachead(poachead),
         posupp     integer NOT NULL,
         INDEX 	    iposupp(posupp),
         poactivity integer,
         INDEX      ipoactivity(poactivity),
         podetail   varchar(90),
         poship     varchar(10),
         podueon    date ,
         poitem     integer NOT NULL,
         INDEX      ipoitem(poitem),
         poqty      decimal(20,4),
         porate     decimal(20,4),
         poamt      decimal(20,4),
         pentrydate date ,
         pentryby   varchar(90),
         pmdfydate  date,
         pmdfyby    varchar(90),
         ponotes    varchar(90),
         pconum     integer NOT NULL,
         pyrno      integer NOT NULL,
         precv      varchar(1) NOT NULL, 
	 CONSTRAINT porecv_ck 
	            check (precv IN ('y','n','Y', 'N')),
	 CONSTRAINT podept_fk FOREIGN KEY (podept) 
                    references department (dnum),
	 CONSTRAINT powhouse_fk FOREIGN KEY (powhouse) 
                    references warehouse (wnum),
         CONSTRAINT pocl_fk FOREIGN KEY (poachead)
                    references chartacs(gac_head),
         CONSTRAINT posl_fk FOREIGN KEY (posupp)
                    references subledger(sid),
         CONSTRAINT poactivity_fk FOREIGN KEY (poactivity)
                    references activity(accode),
         CONSTRAINT podt_ck check (podueon >= podate),
	 CONSTRAINT poitem_fk FOREIGN KEY (poitem) 
                    references items (icode)
) ;

create table receiving
        (rrno       integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
         rrpono     integer NOT NULL,
         INDEX      irrpono(rrpono),
	 rrpodate   date,
         rrwhouse   integer NOT NULL,
         rrdept     integer NOT NULL,
         rrdate     date ,
         rrpaydue   date,
         rrinvoice  integer,
         rrsupp     integer NOT NULL,
         rractivity integer,
         rrdetail   varchar(55),
         rrship     varchar(10),
         rentrydate date ,
         rentryby   varchar(90),
         rmdfydate  date,
         rmdfyby    varchar(90),
         rrtamt     decimal(20, 4),
         rritem     integer,
         rrmake	    varchar(50),
         rrmodel    varchar(50),
         rrserial   varchar(50),
         rrbatch    varchar(50),
         rrqtyorder decimal(20,4), 
         rrqtyrecd  decimal(20,4) NOT NULL, 
         rrqtyshort decimal(20,4), 
         rrqtyret   decimal(20,4) NOT NULL, 
         rrrate     decimal(20,4),
         rramt      decimal(20,4), 
         rrmarkup   decimal(20,4), 
         rrsrate    decimal(20,4), 
         rrnotes    varchar(90),
         rconum     integer NOT NULL,
         ryrno      integer NOT NULL,
         rtagged    varchar(1) NOT NULL,
	 CONSTRAINT rrltag1_ck 
	            check (rtagged IN ('y','n','Y', 'N')),
         CONSTRAINT rrlqty1_ck check (rrqtyrecd <= rrqtyorder),
         CONSTRAINT rrlqty2_ck check (rrqtyret <= rrqtyrecd),
	 CONSTRAINT rrpo_fk FOREIGN KEY (rrpono) 
                    references purchorder (ponum)
) ;


create table purchdebitnote
        (dnote      integer NOT NULL PRIMARY KEY,
         drrno      integer NOT NULL,
         INDEX      ipdnrrno(drrno),
         ddate      date ,
         drrdate    date,
         drrpono    integer,
         drrwhouse  integer,
         drrdept    integer,
         drrsup     integer,
         dnachead   integer NOT NULL,
         dnactivity integer NOT NULL,
         dnitem     integer,
         dnqtyord   decimal(20, 4),
         dnqtyrec   decimal(20, 4),
         dnqtyret   decimal(20, 4),
         dnrate     decimal(20, 4),
         dnamt      decimal(20, 4),
         dentryby   varchar(90),
         drnotes    varchar(90),
         dconum     integer NOT NULL,
         dyrno      integer NOT NULL,
         CONSTRAINT dnote1_fk FOREIGN KEY (drrno)
                    references receiving(rrno)
) ;


create table issuejob
        (issno      integer NOT NULL PRIMARY KEY,
         issjob     integer NOT NULL,
         INDEX      iissjob(issjob), 
         isswhouse  integer NOT NULL,
         INDEX      iisswhouse(isswhouse),
         issdept    integer NOT NULL,
         INDEX      iissdept(issdept),
         issdesc    varchar(90),
         isdate     date,
         isitem     integer,
         INDEX      iissitem(isitem),
         isqty      decimal(20,4),
         israte     decimal(20,4),
         isamt      decimal(20,4),
         isnotes    varchar(90),
         ishash     decimal(20, 4),
         isconum    integer NOT NULL,
         isyrno     integer NOT NULL,
         ientrydate date NOT NULL,
         ientryby   varchar(90),
         imdfyby    varchar(90),
	 CONSTRAINT isjjob_fk FOREIGN KEY (issjob) 
                    references jobs (jobnum),
	 CONSTRAINT isjdept_fk FOREIGN KEY (issdept) 
                    references department (dnum),
	 CONSTRAINT isjwhouse_fk FOREIGN KEY (isswhouse) 
                    references warehouse (wnum),
	 CONSTRAINT isjobitem_fk FOREIGN KEY (isitem) 
                    references items (icode)
) ;


create table jobreturn
        (jrno       integer NOT NULL PRIMARY KEY,
         jrissno    integer NOT NULL, 
         INDEX      ijobretissno(jrissno), 
         job        integer NOT NULL,
         jwhouse    integer NOT NULL,
         jdept      integer NOT NULL,
         jdesc      varchar(90),
         jdate      date,
         jentrydate date NOT NULL,
         jentryby   varchar(90),
         jmdfydate  date NOT NULL,
         jmdfyby    varchar(90),
         jritem     integer,
         jrqty      decimal(20,4),
         jrrate     decimal(20,4),
         jramt      decimal(20,4),
         jrnotes    varchar(90),
         jrconum    integer NOT NULL,
         jryrno     integer NOT NULL,
	 CONSTRAINT jret_issfk FOREIGN KEY (jrissno) 
                    references issuejob (issno)
) ;


create table issuesubcont
        (issno      integer NOT NULL PRIMARY KEY,
         issdesc    varchar(90),
         isac_head  integer NOT NULL,
         INDEX      iisubachead(isac_head),
         issupp     integer NOT NULL,
         INDEX      iissupp(issupp),
         isship     varchar(90),
         isswhouse  integer NOT NULL,
         INDEX      iisswhouse(isswhouse),
         issdept    integer NOT NULL,
         INDEX      iissdept(issdept), 
         isdate     date,
         isrecdue   date,
         isitem     integer,
         isqty      decimal(20,4),
         israte     decimal(20,4),
         isamt      decimal(20,4),
         ientrydate date NOT NULL,
         ientryby   varchar(90),
         imdfydate  date NOT NULL,
         imdfyby    varchar(90),
         isnotes    varchar(90),
         isconum    integer NOT NULL,
         isyrno     integer NOT NULL,
	 CONSTRAINT issubsup_fk FOREIGN KEY (issupp) 
                    references subledger (sid),
	 CONSTRAINT issdept_fk FOREIGN KEY (issdept) 
                    references department (dnum),
	 CONSTRAINT isswhouse_fk FOREIGN KEY (isswhouse) 
                    references warehouse (wnum)
) ;

       
create table itemstag
	(tagno      varchar(20) NOT NULL PRIMARY KEY,
         trrno      integer NOT NULL,
         INDEX      itagrrno(trrno),
         titem      integer NOT NULL,
	 tstax      integer NOT NULL,
	 INDEX      itagstax(tstax),
         tlocn      integer NOT NULL,
         INDEX      itaglocn(tlocn),
         tsection   integer NOT NULL,
         INDEX      itagsection(tsection),
         tuom       integer NOT NULL,
         INDEX      itaguom(tuom),
         tmake      varchar(90),
	 tmodel     varchar(90),
	 tserialnum varchar(90),
         topqty     decimal (20,4) NOT NULL,
         tsoldqty   decimal (20,4) NOT NULL,
         tretqty    decimal (20,4) NOT NULL,
         topval     decimal (20,4) NOT NULL,
         tsprice1   decimal (20,4) NOT NULL,
         tsprice2   decimal (20,4) NOT NULL,
         tsprice3   decimal (20,4) NOT NULL,
         tsprice4   decimal (20,4) NOT NULL,
         tsprice5   decimal (20,4) NOT NULL,
         trecdate   date NOT NULL,
         tissdate   date,
         tretdate   date,
         tac_head   integer,
         tsupplier  integer,
         tdoc       varchar(30),
         tretdoc    varchar(30),
         tconum     integer NOT NULL,
         tyrno      integer NOT NULL,
	 CONSTRAINT tagqty1_ck 
                    check (tretqty <= topqty),
	 CONSTRAINT tagqty2_ck 
                    check (tretqty + topqty >= tsoldqty),
         CONSTRAINT tagunits_fk FOREIGN KEY (tuom) 
                    references itemunits (uname),
	 CONSTRAINT taglocn_fk FOREIGN KEY (tlocn) 
                    references itemlocn (locn),
	 CONSTRAINT tagsection_fk FOREIGN KEY (tsection) 
                    references itemsection (section),
	 CONSTRAINT tagstax_fk FOREIGN KEY (tstax) 
                    references itemsalestax (stype)
) ;

create table custprefs
        (cphone     integer NOT NULL PRIMARY KEY,
         cprefs     integer NOT NULL,
         INDEX      icustprefs(cprefs),
         cnotes     varchar(90),
         cconum     integer NOT NULL,
         CONSTRAINT custpref2_fk
                    FOREIGN KEY (cprefs) references prefers (prefno)
) ;

create table salesorder
        (sono       integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
         sorigin    integer NOT NULL,
         INDEX      isalesordori(sorigin), 
         scust      integer NOT NULL,
         INDEX      isalesordercust(scust),
         sdate      date,
         ssettle    integer NOT NULL,
         INDEX      isalesorderset(ssettle),
         scheckno   varchar(16),
         srouting   varchar(16),
         scardno    varchar(16),
         sauthorz   varchar(50),
         sexpmm     integer ,
         sexpyr     integer ,
	 sbilladdr1 varchar(90),
	 sbilladdr2 varchar(90),
	 sbillcity  varchar(90),
	 sbillstate varchar(90),
	 sbillzip   varchar(90),
	 sbillcnty  varchar(90),
	 sbillphone varchar(90),
         sconum     integer NOT NULL,
         syrno      integer NOT NULL,
         CONSTRAINT sorder1_fk
                    FOREIGN KEY (scust) references custprofile (custnum),
         CONSTRAINT sorder2_fk
                    FOREIGN KEY (sorigin) references originate (ono),
         CONSTRAINT sorder4_fk FOREIGN KEY (ssettle)
                    references settlement (stype)
) ;

create table salesorderlines
        (sseq       integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
         sono       integer NOT NULL,
         INDEX      isalesorder(sono), 
         scust      integer NOT NULL,
         sdate      date,
         stagno     varchar(20),
	 suom       integer,
         sqty       decimal(20,4) NOT NULL,
         srate      decimal(20,4) NOT NULL,
         sstax      decimal(20,4) NOT NULL,
         sdisc      decimal(20,4) NOT NULL,
         samt       decimal(20,4) NOT NULL,
	 sshipaddr1 varchar(90),
	 sshipaddr2 varchar(90),
	 sshipcity  varchar(90),
	 sshipstate varchar(90),
	 sshipzip   varchar(90),
	 sshipcnty  varchar(90),
	 sshipphone varchar(90),
         sconum     integer NOT NULL,
         syrno      integer NOT NULL,
         CONSTRAINT sorder9_fk
                    FOREIGN KEY (sono) references salesorder (sono)
) ;
        
        
create table invoice
        (invno      integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
         mcust      integer,
         INDEX      iinvoicecust(mcust),
         msorder    integer,
         INDEX      iinvorder(msorder),
         mdate      date NOT NULL,
         mcashadv   decimal(20,4) NOT NULL, 
         mtamt      decimal(20,4),
	 mnotes     varchar(90),
	 mshopno    integer,
	 INDEX      iinvshop(mshopno),
	 mregno     integer,
	 INDEX      iinvregno(mregno),
         mconum     integer NOT NULL,
         myrno      integer NOT NULL,
	 CONSTRAINT memodept_fk FOREIGN KEY (mregno) 
                    references cashregs (regnum),
	 CONSTRAINT memocust_fk FOREIGN KEY (mcust) 
                    references custprofile (custnum),
	 CONSTRAINT memoshop_fk FOREIGN KEY (mshopno) 
                    references shop (shopnum)
) ;

create table invoicesettlelines
        (invseq     integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
         invno      integer NOT NULL,
         INDEX      iinvsettleno(invno), 
         mprefs     integer,
         msettle    integer,
         INDEX      iinvsettletype(msettle),
         mcheckno   varchar(16),
         mrouting   varchar(16),
         mcardno    varchar(16),
         mauthorz   varchar(50),
         mexpmm     integer,
         mexpyr     integer,
         mamt       decimal(20, 4),
	 mbilladdr1 varchar(90),
	 mbilladdr2 varchar(90),
	 mbillcity  varchar(90),
	 mbillstate varchar(90),
	 mbillzip   varchar(90),
	 mbillcnty  varchar(90),
	 mbillphone varchar(90),
         CONSTRAINT memos_fk1 FOREIGN KEY (invno)
                    references invoice (invno),
         CONSTRAINT memos_fk2 FOREIGN KEY (msettle)
                    references settlement (stype),
         CONSTRAINT memos_chk1 check (mexpmm >= 1 and mexpmm <= 12),
         CONSTRAINT memos_chk2 check (mexpyr >= 2000 and mexpyr <= 2099)
) ;
         
create table invoicelines
        (invseq     integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
         invno      integer NOT NULL,
         INDEX      iinvlinesno(invno),
         mtagno     varchar(20),
         INDEX      iinvlinestag(mtagno),
	 muom       integer,
         mqty       decimal(20,4) NOT NULL,
         mrate      decimal(20,4) NOT NULL,
         mstax      decimal(20,4) NOT NULL,
         mdisc      decimal(20,4) NOT NULL,
         mamt       decimal(20,4) NOT NULL,
	 mdelivrd   char(1) NOT NULL,
	 mshipaddr1 varchar(90),
	 mshipaddr2 varchar(90),
	 mshipcity  varchar(90),
	 mshipstate varchar(90),
	 mshipzip   varchar(90),
	 mshipcnty  varchar(90),
	 mshipphone varchar(90),
	 CONSTRAINT memodely_ck 
                    check (mdelivrd in ('y','n','h')),
	 CONSTRAINT memomain_fk FOREIGN KEY (invno) 
                    references invoice (invno),
	 CONSTRAINT memoitem_fk FOREIGN KEY (mtagno) 
                    references itemstag (tagno)
) ;

create table salescrnote
        (cnote      integer NOT NULL PRIMARY KEY,
         cinvno     integer NOT NULL,
         INDEX      icrnoteinv(cinvno),
         cseqno     integer NOT NULL,
         cmemdate   date,
         cdate      date ,
         ccust      integer,
         cltagno    integer,
         clqty      decimal(20, 4),
         clrate     decimal(20, 4),
         clamt      decimal(20, 4),
         cltax      decimal(20, 4),
         cldisc     decimal(20, 4),
         clgross    decimal(20, 4),
         centrydate date ,
         centryby   varchar(90) NOT NULL,
         cconum     integer NOT NULL,
         cyrno      integer NOT NULL,
         CONSTRAINT crnote1_fk FOREIGN KEY (cinvno)
                    references invoice (invno)
) ;

        
create table custhistory
        (cphone     integer NOT NULL,
         cinvno     integer NOT NULL,
	 cdate      date,
	 camt       decimal(20, 4),
         centrydate date NOT NULL,
         centryby   varchar(90) NOT NULL,
         cconum     integer NOT NULL,
	 CONSTRAINT chist_pk
                    PRIMARY KEY (cphone, cinvno), 
         CONSTRAINT chist1_fk
                    FOREIGN KEY (cphone) references custprofile (custnum)
) ;

CREATE TABLE campaign (
	campaignid integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
	campaigntype varchar(10) not null ,
	campaigndescription varchar(10) not null ,
	date datetime not null ,
	status varchar(10) ,
	notes varchar(10) 
) ;

create table companydepartment (
	departmentid integer not null primary key auto_increment,
	departmenttype varchar(30) ,
	departmentdescription varchar(10) ,
	companyid integer ,
	locationid integer ,
	status varchar(10)  
) ;


create table companylocation (
	locationid integer not null primary key auto_increment,
	locationtype varchar(50) ,
	locationdescription varchar(50) ,
	companyid integer ,
	contactid integer ,
	address1 varchar(10) ,
	address2 varchar(10) ,
	address3 varchar(10) ,
	city varchar(10) ,
	state varchar(10) ,
	country varchar(10) ,
	postalcode varchar(10) ,
	regionid integer 
) ;


create table constraints (
	constraintid integer not null primary key auto_increment,
	constrainttype varchar(10) ,
	constraintdescription varchar(10) ,
	promotionid integer ,
	value varchar(10) ,
	date varchar(10) ,
	status varchar(10) 
) ;


create table contact (
	contactid integer not null primary key auto_increment,
	messageid integer ,
	companyid integer ,
	contacttype integer ,
	contactfname varchar(10) ,
	contactlname varchar(10) ,
	contactalias varchar(10) ,
	contactposition varchar(10) ,
	locationid integer ,
	birthday varchar(10) ,
	socialinsurancenum varchar(10) ,
	gender varchar(10) ,
	maritalstatus varchar(10) ,
	children varchar(10) ,
	supervisor varchar(10)  
) ;


create table customerrequirements (
	requirementid integer not null primary key auto_increment,
	prospectid integer ,
	requirementtype varchar(10) ,
	requirementdescription varchar(10) ,
	documentid integer ,
	notes varchar(10) ,
	date datetime ,
	status varchar(10)  
) ;


create table document (
	documentid integer not null primary key auto_increment,
	documentgroup varchar(10) ,
	documenttype varchar(10) ,
	documentdescription varchar(10) ,
	notes varchar(10) ,
	document binary (10) ,
	date datetime ,
	status varchar(10)  
) ;


create table forecast (
	forecastid integer not null primary key auto_increment,
	prospectid integer ,
	forecaststageweightid integer ,
	decisioncriteriaid integer ,
	value varchar(10) ,
	date datetime ,
	status varchar(10) ,
	notes varchar(10)  
) ;


create table forecastdecisioncriteria (
	decisioncriteriaid integer not null primary key auto_increment,
	criteriastage varchar(10) ,
	criteriadescription varchar(10) ,
	criteriaweight varchar(10) ,
	date datetime ,
	status varchar(10)  
) ;


create table forecaststageweight (
	forecaststageweightid integer not null primary key auto_increment,
	industryid varchar(10) ,
	stagetype varchar(10) ,
	stageweight integer ,
	date datetime ,
	status varchar(10)  
) ;


CREATE TABLE industry (
	industryid integer not null primary key auto_increment,
	industry varchar(10) ,
	segmenttype varchar(10) ,
	segmentdesc varchar(10) ,
	sic integer ,
	naics integer ,
	industrydollarvalue varchar(10) ,
	industryemployment varchar(10) ,
	notes varchar(50) ,
	status varchar(10)  
) ;


CREATE TABLE leadmanagment (
	leadid integer not null primary key auto_increment,
	leadsourceid integer ,
	leaddescription varchar(20) ,
	campaignid integer ,
	companyname varchar(10) ,
	locationid integer 	,
	contactname varchar(10) ,
	phoneareacode varchar(10) ,
	contactphonenum varchar(10) ,
	contactposition varchar(10) ,
	sicnum varchar(10) ,
	date varchar(10) ,
	companyrevenue varchar(10) ,
	companyemployees varchar(10) 
) ;


CREATE TABLE lostlead (
	lostleadid integer not null primary key auto_increment,
	forecastid integer ,
	prospectid integer ,
	teamid integer ,
	lostleadtype varchar(10) ,
	lostleaddescription varchar(10) ,
	competitorid integer ,
	forecastvalue varchar(10) ,
	exitinterviewnotes varchar(10) ,
	date datetime 
) ;


CREATE TABLE message (
	messageid integer not null primary key auto_increment,
	messagetype varchar(10) ,
	contactid varchar(10) ,
	messagecontent varchar(50)  
) ;



CREATE TABLE promotion (
	promotionid integer not null primary key auto_increment,
	promotiontype varchar(10) ,
	promotiondescription varchar(10) ,
	promotionbudget varchar(10) ,
	channel varchar(10) ,
	campaignid integer ,
	productid integer ,
	notes varchar(10) ,
	status varchar(10)  
) ;


CREATE TABLE promotionmetrics (
	metricsid integer not null primary key auto_increment,
	promotionid integer ,
	metricstype varchar(10) ,
	metricsdescription varchar(10) ,
	weignt varchar(10) ,
	status varchar(10) ,
	date datetime ,
	notes varchar(10)  
) ;


CREATE TABLE prospect (
	prospectid integer not null primary key auto_increment,
	leadid integer ,
	companyid integer ,
	contactid integer ,
	productid integer ,
	prospecttype varchar(10) ,
	prospectdesc varchar(10) ,
	teamid integer ,
	status varchar(10) ,
	regionid varchar(10), 
	date datetime  
) ;


CREATE TABLE task (
	taskid integer not null primary key auto_increment,
	tasktype varchar(10) ,
	taskdescription varchar(10) ,
	note varchar(10) ,
	contactid integer ,
	status varchar(10) ,
	date datetime ,
	datetostart datetime ,
	datetocomplete datetime ,
	datecompleted datetime
) ;


CREATE TABLE team (
	teamid integer not null primary key auto_increment,
	teamtype varchar(10) ,
	teamdescription varchar(10) ,
	status varchar(10) ,
	memberid integer ,
	memberposition varchar(10) ,
	date datetime 
) ;

CREATE TABLE hrdepartment (
	departmentid integer not null primary key auto_increment ,
	departmenttype varchar(10) ,
	departmentdesc varchar(10) ,
	parentdepartmentid integer ,
	departmentname varchar(10) ,
	locationid integer
) ;


CREATE TABLE departmentevents (
	eventid integer not null primary key auto_increment ,
	departmentid integer ,
	INDEX iidepartevents(departmentid),
	eventtype varchar(10) ,
	eventdescription varchar(10) ,
	eventdate varchar(10) ,
	dateposted varchar(10) ,
	status varchar(10) ,
	expiredate varchar(10) ,
	eventdoc varchar(50),
	constraint fk_departmentevents_department foreign key 
	(departmentid) references hrdepartment (departmentid)
) ;


CREATE TABLE employee (
	employeeid integer not null primary key auto_increment ,
	employeetype varchar(10) ,
	departmentid integer ,
	index iiemployee0(departmentid),
	jobid integer ,
	index iiemployee1(jobid),
	employeetypeid integer ,
	index iiemployee5(employeetypeid),
	categoryid integer ,
	index iiemployee2(categoryid),
	messageid integer ,
	index iiemployee3(messageid),
	locationid integer ,
	index iiemployee4(locationid),
	lname varchar(10) ,
	fname varchar(10) ,
	mnames varchar(10) ,
	socialsecuritynum varchar(10) ,
	birthdate varchar(10) ,
	gender varchar(10) ,
	ethnicorigin varchar(10) ,
	maritalstatus varchar(10) ,
	employeestatus varchar(10) ,
	startdate varchar(10) ,
	enddate varchar(10),
	constraint fk_employee_department foreign key 
	(departmentid) references hrdepartment (departmentid)
) ;

CREATE TABLE compensation (
	compensationid integer not null primary key auto_increment ,
	compensationtype varchar(10) ,
	compensationdesc varchar(10) ,
	ratetableid integer ,
	commissionrateid integer ,
	ratetabletype varchar(10) ,
	hurdleid integer ,
	filterid integer ,
	commissiongroupid integer ,
	employeeid integer ,
	INDEX iicomp1(employeeid),
	regionid integer, 
	constraint fk_compemployee foreign key 
	(employeeid) references employee (employeeid)
) ;

CREATE TABLE deductions (
	deductionid integer not null primary key auto_increment ,
	deductiontype varchar(10) ,
	deductiondesc varchar(10) ,
	employeeid integer ,
	INDEX iideduct(employeeid),
	amount varchar(10) ,
	sourcedoc varchar(10) ,
	deductstatus varchar(10),
	constraint fk_deductions_employee foreign key 
	(employeeid) references employee (employeeid)
) ;

CREATE TABLE employeereview (
	employeereviewid integer not null primary key auto_increment ,
	employeeid integer ,
	INDEX iiemployrev1(employeeid),
	reviewtype varchar(10) ,
	reviewdescription varchar(10) ,
	target varchar(10) ,
	scorecard varchar(10) ,
	achievment varchar(10) ,
	employeecomment varchar(10) ,
	reviewercomment varchar(10) ,
	date varchar(10) ,
	status varchar(10),
	constraint fk_employeereview_employee foreign key 
	(employeeid) references employee (employeeid)
) ;


CREATE TABLE esalary (
	salaryid integer not null primary key auto_increment ,
	salarytype varchar(10) ,
	employeeid integer ,
	INDEX iiesal1(employeeid),
	start varchar(10) ,
	categoryid integer ,
	salaryamount integer,
	constraint fk_esalary_employee foreign key 
	(employeeid) references employee (employeeid)
) ;


CREATE TABLE grievance (
	grievanceid integer not null primary key auto_increment ,
	grievancetype varchar(10) ,
	grevancedescription varchar(10) ,
	employeeid integer ,
	INDEX iigrievance(employeeid),
	recommendedaction varchar(10) ,
	companyrep varchar(10) ,
	employeerep varchar(10) ,
	resolution varchar(10),
	constraint fk_grievance_employee foreign key 
	(employeeid) references employee (employeeid)
) ;


CREATE TABLE hourlypay (
	hourlypayid integer not null primary key auto_increment ,
	hourlytype varchar(10) ,
	hourlydescription varchar(10) ,
	hourlyrate varchar(10) ,
	categoryid integer ,
	employeeid integer,
	INDEX iihourpay(employeeid),
	constraint fk_hourlypay_employee foreign key 
	(employeeid) references employee (employeeid)
	
) ;


CREATE TABLE jobcategory (
	positionid integer not null primary key auto_increment ,
	employeeid integer ,
	INDEX iijobcat1(employeeid),
	positionname varchar(10) ,
	companyid integer ,
	departmentid integer ,
	positiontype varchar(10) ,
	startrate varchar(10) ,
	positiondescription varchar(10) ,
	workcompdeducid integer ,
	compensationid integer ,
	reportsto varchar(10),
	constraint fk_jobcatery_employee foreign key 
	(employeeid) references employee (employeeid)
) ;


CREATE TABLE jobopportunities (
	jobopportunityid integer not null primary key auto_increment ,
	jobopportunitytype varchar(10) ,
	jobopportunitydescriprion varchar(10) ,
	jobskillsrequired varchar(10) ,
	positionid integer ,
	INDEX iijoboppor1(positionid),
	dateposted varchar(10) ,
	dateexpire varchar(10) ,
	departmentid integer ,
	status varchar(10),
	constraint fk_jobopportunities_jobcatery foreign key 
	(positionid) references jobcategory (positionid)
) ;


CREATE TABLE locks (
	lockid integer not null primary key auto_increment ,
	locktype varchar(10) ,
	employeeid integer ,
	INDEX iilocks1(employeeid),
	datelock varchar(10) ,
	status varchar(10),
	constraint fk_locks_employee foreign key 
	(employeeid) references employee (employeeid)
) ;


CREATE TABLE logininfo (
	loginid integer not null primary key auto_increment ,
	loginusrname varchar(10) ,
	password varchar(10) ,
	admin binary (10) ,
	superadmin binary (10) ,
	numberoflogins float ,
	lastlogin datetime ,
	loginip integer ,
	datesignup datetime ,
	ipsignup varchar(10) ,
	dateupdated varchar(10) ,
	employeeid integer,
	INDEX iiloginfo1(employeeid),
	constraint fk_logininfo_employee foreign key 
	(employeeid) references employee (employeeid)
) ;


CREATE TABLE managebyobjective (
	mbo_id integer not null primary key auto_increment ,
	mbotype varchar(10) ,
	mbodescription varchar(10) ,
	compensarionid integer ,
	INDEX iimbo1(compensarionid),
	mborate varchar(10),
	constraint fk_managebyobjective_compensation foreign key 
	(compensarionid) references compensation (compensationid)
) ;


CREATE TABLE messages (
	leftmessageid integer not null primary key auto_increment ,
	employeeid integer ,
	INDEX iimessages(employeeid),
	message varchar(10) ,
	messagetype varchar(10) ,
	postedby varchar(10) ,
	dateposted datetime ,
	status varchar(10),
	constraint fk_messages_employee foreign key 
	(employeeid) references employee (employeeid)
) ;


CREATE TABLE nonworkdays (
	nonworkdayid integer not null primary key auto_increment ,
	nonworktype varchar(10) ,
	nonworkdescription varchar(10) ,
	date varchar(10) ,
	payment varchar(10) ,
	employeeid integer,
	INDEX iinonwdays1(employeeid),
	constraint fk_nonworkdays_employee foreign key 
	(employeeid) references employee (employeeid)
) ;


CREATE TABLE project (
	projectid integer not null primary key auto_increment ,
	customerid integer ,
	employeeid integer ,
	INDEX iiproject1(employeeid),
	projecttype varchar(10) ,
	projectdescription varchar(10) ,
	projectstatus varchar(10) ,
	date varchar(10),
	constraint fk_project_employee foreign key 
	(employeeid) references employee (employeeid)
) ;


CREATE TABLE schedule (
	scheduleid integer not null primary key auto_increment ,
	changescheduleid integer ,
	scheduletype varchar(10) ,
	jobcategoryid integer ,
	employeeid integer ,
	INDEX iischedule1(employeeid),
	scheduledate datetime ,
	starttime varchar(10) ,
	endtime varchar(10) ,
	status varchar(10) ,
	changedate datetime ,
	changeschedule varchar(10),
	constraint fk_schedule_employee foreign key 
	(employeeid) references employee (employeeid)
) ;


CREATE TABLE skills (
	skillid integer not null primary key auto_increment ,
	employeeid integer ,
	skilltype varchar(10) ,
	skilldescription varchar(10) ,
	amountofexperience varchar(10) ,
	experiencedescription varchar(10) ,
	mgrratingofskill varchar(10) ,
	date varchar(10) ,
	employeereviewid integer
) ;


CREATE TABLE taxratetables (
	taxrateid integer not null primary key auto_increment ,
	countryid integer ,
	taxcategory varchar(10) ,
	taxtype varchar(10) ,
	taxdescription varchar(10) ,
	taxrate varchar(10) ,
	rateformula varchar(10) ,
	status varchar(10) ,
	date datetime ,
	salarybreak varchar(10)
) ;


CREATE TABLE timesheet (
	timesheetid integer not null primary key auto_increment ,
	employeeid integer ,
	INDEX iitsheet0(employeeid),
	projectid integer ,
	INDEX iitsheet1(projectid),
	checkin varchar(10) ,
	checkout varchar(10) ,
	checkinip varchar(10) ,
	checkoutip varchar(10) ,
	workdescription varchar(10),
	constraint fk_timesheet_employee foreign key 
	(employeeid) references employee (employeeid),
	constraint fk_timesheet_project foreign key 
	(projectid) references project (projectid)
) ;


CREATE TABLE training (
	trainingid integer not null primary key auto_increment ,
	employeeid integer ,
	trainingtype varchar(10) ,
	trainingdescription varchar(10) ,
	trainingvendorid integer ,
	certification bit ,
	traininggrade varchar(10) ,
	courseid integer ,
	mgrauthorization varchar(10) ,
	date varchar(10) ,
	status integer
) ;


CREATE TABLE trainingcourses (
	courseid integer not null primary key auto_increment ,
	coursedescription varchar(10) ,
	coursetype varchar(10) ,
	vendorid integer ,
	courselength varchar(10) ,
	date varchar(10) ,
	status varchar(10)
) ;

CREATE TABLE inventorymaster	(	
	productid  INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,	
	producttype	VARCHAR(100),
	revisionnumber  VARCHAR(100),	
	productname  	VARCHAR(100),
	productdescription  VARCHAR(100),
	reorderlevel  	NUMERIC(14, 6),
	leadtime  NUMERIC(12, 2),	
	vendorpartnumber VARCHAR(100), 	
	manufacturerid	INTEGER,
	manufacturersku	VARCHAR(100),
	fcc_id_number VARCHAR(100), 	
	fda_accession_number VARCHAR(100),
	country_of_origin INTEGER, 	
	margin  NUMERIC(14, 6),	
	manufacturing_leadtime  NUMERIC(12, 2),
	minimumordersize NUMERIC(14, 6),	 	
	unitsofmeasure  INTEGER,	
	weight_lbs NUMERIC(14, 6),	  	
	width_inches NUMERIC(14, 6),	  	
	length_inches NUMERIC(14, 6),	  	
	height_inches NUMERIC(14, 6),	  	
	drawing VARCHAR(100), 	
	nafta_tariff_code VARCHAR(30),
	origincurrency NUMERIC(14, 6),	 	
	safetystock NUMERIC(14, 6),	 	
	overheadcost NUMERIC(14, 6),	 	
	supplierid INTEGER,
	sku VARCHAR(30),	
	upc VARCHAR(30)
);	


CREATE TABLE inventorydetail	(
	invdetailid INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,		
	productid INTEGER,	
	tagid INTEGER,
	lotid	INTEGER,	
	quantity DECIMAL (14, 6),
	date DATETIME,		
	price DECIMAL(14, 6),		
	uom INTEGER,		
	locationid INTEGER
);	
			
CREATE TABLE inventorytransaction (
	invtransactionid INTEGER,		
# look up table	purchase, invoice, transfer, etc	
	invtransactiontype VARCHAR(100),	
# the invoice #, purchase order #, transfer # etc	
	transreferenceid INTEGER,		
	productid INTEGER,		
	quantity NUMERIC(14, 6),			
	date DATETIME
);	
			
# this table is only for cyclical adjustments to the inventory			
CREATE TABLE inventoryadjustment (		
	invadjustmentid	INTEGER,	
	productid INTEGER,		
	adjustment NUMERIC(14, 6),			
	date DATETIME,		
	employeeid INTEGER
);	
			
CREATE TABLE serialinventory (
	serialinvid INTEGER,	
	productid INTEGER,
	serialnum VARCHAR(30),
	sku VARCHAR(30),
	datein DATETIME,
	dateout DATETIME,
	warranteeid INTEGER
);

CREATE TABLE nonassetinventory	(
	nainvid INTEGER,
	productid INTEGER,
	uom INTEGER,
	overhead NUMERIC(14, 6),	
	baserate NUMERIC(14, 6),	
	datesku DATETIME
);	

CREATE TABLE materialreturn (
	materialreturn_id  INTEGER,
	materialreturndesc VARCHAR(100),	
	materialreturnauth VARCHAR(100),	
	purchaseorderid  INTEGER,		
	productid  INTEGER,		
	date  DATETIME,		
	repair_date  DATETIME,
	packingslipnum VARCHAR(30), 		
	serialnum VARCHAR(30),		
	total_batch_qty  NUMERIC(14, 6),	
	rejected  NUMERIC(14, 6),			
	failure  NUMERIC(14, 6),			
	dispositionnum NUMERIC(14, 6),	 		
	disposed_by  INTEGER,		
# employee id	
	inventory_entry_by INTEGER, 		 
# customer that returned the goods	
	customerid INTEGER,  			 
	cause INTEGER, 		
	fix  VARCHAR(30),		
	status VARCHAR(30),  		
# warranty id	
	warrantynum VARCHAR(100),		 
	warranty_expiry INTEGER, 		
	supplierid INTEGER, 		
	rma_disposition VARCHAR(30),  		
	fieldcontact INTEGER, 		
	status_flag INTEGER, 		
	start_date DATETIME, 		
	received_date DATETIME,
	complete_date DATETIME, 		
# look up table(s)	
	rma_categoryid INTEGER, 		
	complaintcategoryid INTEGER,  		
	fixcategoryid INTEGER 			
);

# ------ Test Data --------

INSERT INTO organization VALUES (1,'ABC Group of Companies','Limited Liability',NULL);

INSERT INTO company (cconum, cconame,ccoshort, orgid) VALUES
       (1, 'ABC Consulting', 'ABC', 1);
       
INSERT INTO accyear (aconum, ayearno, ast_date, aen_date) VALUES
	 (1, 2005, '2005-01-01', '2005-12-31');
INSERT INTO accyear (aconum, ayearno, ast_date, aen_date) VALUES
	 (1, 2006, '2006-01-01', '2006-12-31');
    
INSERT INTO `groupfile` VALUES (100,'Liability','0.0000','0.0000',1,2005),(105,'Capital','0.0000','0.0000',1,2005),(110,'Loans and Advances','0.0000','0.0000',1,2005),(115,'Deposits','0.0000','0.0000',1,2005),(120,'Accounts Payable','0.0000','13000.0000',1,2005),(125,'Reserves','0.0000','0.0000',1,2005),(195,'Current Liability','0.0000','0.0000',1,2005),(196,'Profit and Loss','0.0000','0.0000',1,2005),(200,'Assets','0.0000','0.0000',1,2005),(205,'Fixed Assets','0.0000','0.0000',1,2005),(206,'Depreciation','0.0000','0.0000',1,2005),(210,'Loans and Advances','0.0000','0.0000',1,2005),(211,'Payments Due','0.0000','0.0000',1,2005),(215,'Cash in Hand','0.0000','0.0000',1,2005),(220,'Stock','0.0000','0.0000',1,2005),(225,'Deposits','0.0000','0.0000',1,2005),(230,'Accounts Receivable','50000.0000','0.0000',1,2005),(295,'Current Assets','0.0000','0.0000',1,2005),(300,'Income','0.0000','0.0000',1,2005),(305,'Sales','0.0000','50000.0000',1,2005),(310,'Other Income','0.0000','0.0000',1,2005),(400,'Expenditure','0.0000','0.0000',1,2005),(405,'Purchase','13000.0000','0.0000',1,2005),(410,'Other Expense','0.0000','0.0000',1,2005),(500,'Contras','0.0000','0.0000',1,2005);
INSERT INTO `chartacs` VALUES (1,'Accounting Charges','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(2,'Accounts Payable','0.0000','0.0000','0.0000','13000.0000','0.0000','0.0000',100,'Y',120,1,2005,'PRV'),(3,'Accounts Receivable','0.0000','0.0000','50000.0000','0.0000','0.0000','0.0000',200,'Y',230,1,2005,'SLV'),(4,'Advances from Customers','900.0000','0.0000','0.0000','0.0000','0.0000','0.0000',100,'N',110,1,2005,NULL),(5,'Advances Given','0.0000','1000.0000','0.0000','0.0000','0.0000','0.0000',200,'Y',210,1,2005,NULL),(6,'Advances Received','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',100,'N',110,1,2005,NULL),(7,'Advertisement','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(8,'Audit Fees','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(9,'Bad Debts','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',200,'N',230,1,2005,NULL),(10,'Bank Account','10000.0000','0.0000','0.0000','0.0000','0.0000','0.0000',200,'N',215,1,2005,'BBV'),(11,'Bank Charges','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',400,1,2005,NULL),(12,'Bonus and Staff Welfare','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(13,'Books and Periodicals','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(14,'Capital Account','0.0000','9900.0000','0.0000','0.0000','0.0000','0.0000',100,'N',105,1,2005,NULL),(15,'Carriage Inwards','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',405,1,2005,'PRP'),(16,'Cash Balance','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',200,'N',215,1,2005,'CBV'),(17,'Cheques In Hand','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',200,'N',215,1,2005,'BBV'),(18,'Closing Stock','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',200,'N',205,1,2005,NULL),(19,'Commision Earned','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',300,'N',310,1,2005,NULL),(20,'Commission Paid','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(21,'Computer','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',200,'N',205,1,2005,NULL),(22,'Contra','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',500,'N',500,1,2005,NULL),(23,'Credit Cards','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',200,'N',215,1,2005,'CBV'),(24,'Deposits Given','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',200,'N',225,1,2005,NULL),(25,'Deposits Received','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',100,'N',210,1,2005,NULL),(26,'Depreciation','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',206,1,2005,NULL),(27,'Electricity Charges','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(28,'Entertainment','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(29,'ExGratia','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(30,'Exports','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',300,'N',305,1,2005,'SBP'),(31,'Factory Expenses','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(32,'Fax Expenses','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(33,'Fees','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(34,'Freight Expenses','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',305,1,2005,'SBP'),(35,'Fuel Expenses','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(36,'General Reserves','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',100,'N',125,1,2005,NULL),(37,'Goodwill','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',100,'N',195,1,2005,NULL),(38,'Incentives','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(39,'Income Tax','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(40,'Insurance','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(41,'Legal Expenses','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(42,'Medical Expenses','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(43,'Car Expenses','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(44,'Office Expenses','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(45,'Office Maintenance','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(46,'Opening Stock','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',200,'N',205,1,2005,NULL),(47,'Other Revenue','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',300,'N',310,1,2005,NULL),(48,'Postage','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(49,'Preliminary Expenses','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(50,'Printing and Stationary','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(51,'Profit and Loss','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',100,'N',196,1,2005,NULL),(52,'Purchase','0.0000','0.0000','13000.0000','0.0000','0.0000','0.0000',400,'N',405,1,2005,'PRP'),(53,'Purchase Returns','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',405,1,2005,'PRP'),(54,'Remunerations','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(55,'Rent','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(56,'Salaries Due','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',100,'N',211,1,2005,NULL),(57,'Salary','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(58,'Sales','0.0000','0.0000','0.0000','50000.0000','0.0000','0.0000',300,'N',305,1,2005,'SBP'),(59,'Selling Expenses','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(60,'Service Charges Paid','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',405,1,2005,'PRP'),(61,'Service Charges Received','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',300,'N',305,1,2005,'SBP'),(62,'Share Account','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',100,'N',105,1,2005,NULL),(63,'Shipping Expenses','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',305,1,2005,'SBP'),(64,'Stock In Trade','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',200,'N',205,1,2005,NULL),(65,'Subscriptions','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(66,'Sundry Expenses','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(67,'Telephone Expenses','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(68,'Trading Fees','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(69,'Transfer of Funds','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',500,'N',500,1,2005,NULL),(70,'Traveling','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',400,'N',410,1,2005,NULL),(71,'Work in Progress','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',200,'N',295,1,2005,NULL),(72,'Visa','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',200,'N',215,1,2005,'BBV'),(73,'MasterCard','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',200,'N',215,1,2005,'BBV'),(74,'American Express','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',200,'N',215,1,2005,'BBV'),(75,'Discover','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',200,'N',215,1,2005,'BBV'),(76,'Diners','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',200,'N',215,1,2005,'BBV'),(77,'ShopCard','0.0000','0.0000','0.0000','0.0000','0.0000','0.0000',200,'N',215,1,2005,'BBV');
INSERT INTO `subledger` VALUES (1,'Matrox','124 High Road',NULL,'HighPlaces','OR',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0.0000','0.0000','0.0000','0.0000',2,1,2005),(2,'Microsoft','1 Red Ave',NULL,'Seattle',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0.0000','0.0000','0.0000','0.0000',2,1,2005),(3,'Warner','1 Warner Dr',NULL,'Newark','NJ',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0.0000','0.0000','0.0000','0.0000',2,1,2005),(4,'Warner','1 Warner Dr',NULL,'Newark','NJ',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0.0000','0.0000','0.0000','0.0000',2,1,2005),(5,'Fox','Foxy Place',NULL,'Los Angeles','CA',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0.0000','0.0000','0.0000','0.0000',2,1,2005),(6,'Canon','Canon Ave',NULL,'Newark','NJ',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0.0000','0.0000','0.0000','0.0000',2,1,2005),(7,'Sierra','Sierra Leone',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0.0000','0.0000','0.0000','0.0000',2,1,2005),(8,'GT Interactive','GT Road',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0.0000','0.0000','0.0000','13000.0000',2,1,2005),(9,'Hewlett Packard',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0.0000','0.0000','0.0000','0.0000',2,1,2005),(10,'Cotorolla',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0.0000','0.0000','0.0000','0.0000',3,1,2005),(11,'Xicrosoft',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0.0000','0.0000','0.0000','0.0000',3,1,2005),(12,'SunMoon Systems',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0.0000','0.0000','0.0000','0.0000',3,1,2005),(13,'Generally Electric',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0.0000','0.0000','50000.0000','0.0000',3,1,2005),(14,'Joe Holland',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0.0000','0.0000','0.0000','0.0000',3,1,2005),(15,'Sabir Shah',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0.0000','0.0000','0.0000','0.0000',3,1,2005),(16,'Jill Disposed',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0.0000','0.0000','0.0000','0.0000',3,1,2005);

INSERT INTO activitygroup (agdescribe, agconum, agyrno) VALUES
	('No activity', 1, 2005);
INSERT INTO activitygroup (agdescribe, agconum, agyrno) VALUES
	('Project Raptor', 1, 2005);
INSERT INTO activitygroup (agdescribe, agconum, agyrno) VALUES
	('Project Trex', 1, 2005);

INSERT INTO activity (adesc, asubgrp, aconum, ayrno) VALUES
	('None', 1, 1, 2005);
INSERT INTO activity (adesc, asubgrp, aconum, ayrno) VALUES
	('Design', 2, 1, 2005);
INSERT INTO activity (adesc, asubgrp, aconum, ayrno) VALUES
	('Development', 2, 1, 2005);
INSERT INTO activity (adesc, asubgrp, aconum, ayrno) VALUES
	('Test', 2, 1, 2005);
INSERT INTO activity (adesc, asubgrp, aconum, ayrno) VALUES
	('Deploy', 2, 1, 2005);

INSERT INTO analysis (adescribe, aconum, ayrno) VALUES 
	('None', 1, 2005);
INSERT INTO analysis (adescribe, aconum, ayrno) VALUES 
	('Travel', 1, 2005);
INSERT INTO analysis (adescribe, aconum, ayrno) VALUES 
	('Entertainment', 1, 2005);
INSERT INTO analysis (adescribe, aconum, ayrno) VALUES 
	('Car Expenses', 1, 2005);	
	
INSERT INTO pword (pwuser, pwword, email) VALUES ('pizza', 'flavor', 'dev@emryn.com');
INSERT INTO pword (pwuser, pwword, email) VALUES ('spectrum', 'magazine', 'dev@emryn.biz');
insert into pword (pwuser, pwword, email) values ('super', 'flavor', 'super@valueerp.com');
insert into pword (pwuser, pwword, email) values ('agent', 'flavor', 'agent@valueerp.com');
insert into pword (pwuser, pwword, email) values ('viewer', 'flavor', 'viewer@valueerp.com');

INSERT INTO settlement VALUES (1,'Cash',0.0000,16,NULL);
INSERT INTO settlement VALUES (2,'Check',0.0000,10,NULL);
INSERT INTO settlement VALUES (3,'Mastercard',2.5000,73,NULL);
INSERT INTO settlement VALUES (4,'Visa',2.5000,72,NULL);
INSERT INTO settlement VALUES (5,'Amex',3.0000,74,NULL);

INSERT INTO shop VALUES (1,'Shop at Rockaway','Rockaway, NJ 07886','972-344-6544','972-344-5444','Janet Jenson',NULL);
INSERT INTO shop VALUES (2,'Shop at Denville','32 Street, Denville, NJ 06554','972-344-6546','972-344-5443','Sue Anderson',NULL);

INSERT INTO cashregs VALUES (1,'Cash Reg 1',2,NULL);
INSERT INTO cashregs VALUES (2,'Cash Reg 2',2,NULL);
INSERT INTO cashregs VALUES (3,'Cash Reg 3',2,NULL);
INSERT INTO cashregs VALUES (4,'Cash Reg 1',1,NULL);

INSERT INTO itemunits VALUES (1,'Pieces',NULL,NULL,1);
INSERT INTO itemunits VALUES (2,'Numbers',NULL,NULL,1);
INSERT INTO itemunits VALUES (3,'Pcs',NULL,NULL,1);
INSERT INTO itemunits VALUES (4,'Nos',NULL,NULL,1);
INSERT INTO itemunits VALUES (5,'Gallons',NULL,NULL,1);
INSERT INTO itemunits VALUES (6,'Litres',NULL,NULL,1);
INSERT INTO itemunits VALUES (7,'Yards',NULL,NULL,1);
INSERT INTO itemunits VALUES (8,'Pounds',NULL,NULL,1);
INSERT INTO itemunits VALUES (9,'Ozs',NULL,NULL,1);

INSERT INTO itemlocn VALUES (1,'East Case 2nd Floor',100.0000,1);
INSERT INTO itemlocn VALUES (2,'West Corner 1st Floor',120.0000,1);

INSERT INTO itemsection VALUES (1,'Hardware',1);
INSERT INTO itemsection VALUES (2,'Software',1);
INSERT INTO itemsection VALUES (3,'DVDs',1);
INSERT INTO itemsection VALUES (4,'Printers',1);
INSERT INTO itemsection VALUES (5,'Monitors',1);
INSERT INTO itemsection VALUES (6,'Speakers',1);
INSERT INTO itemsection VALUES (7,'Keyboard',1);
INSERT INTO itemsection VALUES (8,'Mice',1);

INSERT INTO itemsalestax VALUES (1,'NJ Sales Tax',6.0000,1,2005);
INSERT INTO itemsalestax VALUES (2,'CA Sales Tax',8.5000,1,2005);
INSERT INTO itemsalestax VALUES (3,'NY Sales Tax',8.0000,1,2005);

INSERT INTO itemgroup VALUES (1,'Hardware',NULL,NULL,NULL,1);
INSERT INTO itemgroup VALUES (2,'Software',NULL,NULL,NULL,1);
INSERT INTO itemgroup VALUES (3,'DVDs',NULL,NULL,NULL,1);

INSERT INTO items (icode, idesc, igroup, iuom, ipprice, isprice1, isales, ipurch, istock, iconum, iyrno) VALUES (1,'Matrox G200 MMS',1, 4, 269.0, 299.99, 58,52,18,1,2005);
INSERT INTO items (icode, idesc, igroup, iuom, ipprice, isprice1, isales, ipurch, istock, iconum, iyrno) VALUES (2,'Matrox G400 32MB',1, 4, 400, 499.99, 58,52,18,1,2005);
INSERT INTO items (icode, idesc, igroup, iuom, ipprice, isprice1, isales, ipurch, istock, iconum, iyrno) VALUES (3,'Microsoft IntelliMouse Pro', 1, 4, 35.0, 49.99, 58,52,18,1,2005);
INSERT INTO items (icode, idesc, igroup, iuom, ipprice, isprice1, isales, ipurch, istock, iconum, iyrno) VALUES (4,'The Replacement Killers', 3, 4, 30.0, 42.0, 58,52,18,1,2005);
INSERT INTO items (icode, idesc, igroup, iuom, ipprice, isprice1, isales, ipurch, istock, iconum, iyrno) VALUES (5,'Blade Runner - Director\'s Cut', 3, 4, 25.0, 35.99, 58,52,18,1,2005);
INSERT INTO items (icode, idesc, igroup, iuom, ipprice, isprice1, isales, ipurch, istock, iconum, iyrno) VALUES (6,'The Matrix',3, 4, 20.0, 29.99, 58,52,18,1,2005);
INSERT INTO items (icode, idesc, igroup, iuom, ipprice, isprice1, isales, ipurch, istock, iconum, iyrno) VALUES (7,'You\'ve Got Mail',3, 4, 20.0, 29.99, 58,52,18,1,2005);
INSERT INTO items (icode, idesc, igroup, iuom, ipprice, isprice1, isales, ipurch, istock, iconum, iyrno) VALUES (8,'A Bug\'s Life',3, 4, 20.0, 35.99, 58,52,18,1,2005);
INSERT INTO items (icode, idesc, igroup, iuom, ipprice, isprice1, isales, ipurch, istock, iconum, iyrno) VALUES (9,'Under Siege',3, 4, 30, 29.99, 58,52,18,1,2005);
INSERT INTO items (icode, idesc, igroup, iuom, ipprice, isprice1, isales, ipurch, istock, iconum, iyrno) VALUES (10,'Under Siege 2 - Dark Territory',3, 4, 25, 29.99, 58,52,18,1,2005);
INSERT INTO items (icode, idesc, igroup, iuom, ipprice, isprice1, isales, ipurch, istock, iconum, iyrno) VALUES (11,'Fire Down Below',3, 4, 25, 29.99, 58,52,18,1,2005);
INSERT INTO items (icode, idesc, igroup, iuom, ipprice, isprice1, isales, ipurch, istock, iconum, iyrno) VALUES (12,'Die Hard With A Vengeance',3, 4, 25.0, 39.99, 58,52,18,1,2005);
INSERT INTO items (icode, idesc, igroup, iuom, ipprice, isprice1, isales, ipurch, istock, iconum, iyrno) VALUES (13,'Lethal Weapon',3, 4, 29.0, 34.99, 58,52,18,1,2005);
INSERT INTO items (icode, idesc, igroup, iuom, ipprice, isprice1, isales, ipurch, istock, iconum, iyrno) VALUES (14,'Red Corner',3, 4, 30.0, 32.00, 58,52,18,1,2005);
INSERT INTO items (icode, idesc, igroup, iuom, ipprice, isprice1, isales, ipurch, istock, iconum, iyrno) VALUES (15,'Frantic',3, 4, 30.0, 35.00, 58,52,18,1,2005);
INSERT INTO items (icode, idesc, igroup, iuom, ipprice, isprice1, isales, ipurch, istock, iconum, iyrno) VALUES (16,'Courage Under Fire',3, 4, 25.0, 38.99, 58,52,18,1,2005);
INSERT INTO items (icode, idesc, igroup, iuom, ipprice, isprice1, isales, ipurch, istock, iconum, iyrno) VALUES (17,'Speed',3, 4, 35.0, 39.99, 58,52,18,1,2005);
INSERT INTO items (icode, idesc, igroup, iuom, ipprice, isprice1, isales, ipurch, istock, iconum, iyrno) VALUES (18,'Speed 2: Cruise Control',3, 4, 35.0, 42.00, 58,52,18,1,2005);
INSERT INTO items (icode, idesc, igroup, iuom, ipprice, isprice1, isales, ipurch, istock, iconum, iyrno) VALUES (19,'There\'s Something About Mary',3, 4, 39.00, 49.99, 58,52,18,1,2005);
INSERT INTO items (icode, idesc, igroup, iuom, ipprice, isprice1, isales, ipurch, istock, iconum, iyrno) VALUES (20,'Beloved',3, 4, 40, 54.99, 58,52,18,1,2005);
INSERT INTO items (icode, idesc, igroup, iuom, ipprice, isprice1, isales, ipurch, istock, iconum, iyrno) VALUES (21,'SWAT 3: Close Quarters Battle',2, 4, 60, 79.99, 58,52,18,1,2005);
INSERT INTO items (icode, idesc, igroup, iuom, ipprice, isprice1, isales, ipurch, istock, iconum, iyrno) VALUES (22,'Unreal Tournament',2, 4, 70, 89.99, 58,52,18,1,2005);
INSERT INTO items (icode, idesc, igroup, iuom, ipprice, isprice1, isales, ipurch, istock, iconum, iyrno) VALUES (23,'The Wheel Of Time',2, 4, 70, 89.99, 58,52,18,1,2005);
INSERT INTO items (icode, idesc, igroup, iuom, ipprice, isprice1, isales, ipurch, istock, iconum, iyrno) VALUES (24,'Disciples: Sacred Lands',2, 4, 70, 90.00, 58,52,18,1,2005);
INSERT INTO items (icode, idesc, igroup, iuom, ipprice, isprice1, isales, ipurch, istock, iconum, iyrno) VALUES (25,'Microsoft Internet Keyboard PS/2',1, 4, 43, 69.99, 58,52,18,1,2005);
INSERT INTO items (icode, idesc, igroup, iuom, ipprice, isprice1, isales, ipurch, istock, iconum, iyrno) VALUES (26,'Microsoft IntelliMouse Explorer',1, 4, 43, 64.95, 58,52,18,1,2005);
INSERT INTO items (icode, idesc, igroup, iuom, ipprice, isprice1, isales, ipurch, istock, iconum, iyrno) VALUES (27,'Hewlett Packard LaserJet 1100Xi',1, 4, 399.00, 499.99, 58,52,18,1,2005);

INSERT INTO itemstag (tagno, trrno, titem, tmake, tstax, tlocn, tsection, tuom, topqty, tsoldqty, tretqty, topval, tsprice1, tsprice2, tsprice3, tsprice4, tsprice5, trecdate, tissdate, tconum, tyrno)
	SELECT CONCAT('SKU',icode), 0, icode, idesc, 1, 1, 1, 1, iopqty, 0, 0, iopqty*ipprice, isprice1, isprice1, isprice1, isprice1, isprice1, now(), now(), 1, 2005 from items;
	
INSERT IGNORE INTO custprofile(custnum, cachead, cname, cconum) 
	SELECT sid, sid, sdesc, sconum FROM subledger WHERE sac_head=3;
	
INSERT INTO department VALUES (1,'Computer','15 Gross Street, Sparta, NJ 07871');
INSERT INTO department VALUES (2,'Software','32nd Street, Philadelphia, PA 10230');	
INSERT INTO department VALUES (3,'DVD Movies','32nd Street, Philadelphia, PA 10230');	

INSERT INTO warehouse VALUES (1,'Warehouse 1','15 Gross Street, Sparta, NJ 07871');
INSERT INTO warehouse VALUES (2,'Warehouse 2','32 Street, Denville, NJ 06554');


INSERT INTO originate VALUES (1,'Referral');
INSERT INTO originate VALUES (2,'Search Engine');
INSERT INTO originate VALUES (3,'Internet');
INSERT INTO originate VALUES (4,'Word of Mouth');
INSERT INTO originate VALUES (5,'Advertisement');
INSERT INTO originate VALUES (6,'Sales Person');
INSERT INTO originate VALUES (7,'Channel Sales');
         
INSERT INTO jobs (jobnum, jobdesc, jac_head, jopval, jrcval, jrdval, jconum, jyrno)
    VALUES (1, 'Motor Cast', 0, 0, 0, 0, 1, 2005);
INSERT INTO jobs (jobnum, jobdesc, jac_head, jopval, jrcval, jrdval, jconum, jyrno)
    VALUES (2, 'Motor Winding', 0, 0, 0, 0, 1, 2005);
INSERT INTO jobs (jobnum, jobdesc, jac_head, jopval, jrcval, jrdval, jconum, jyrno)
    VALUES (3, 'Motor Assembly', 0, 0, 0, 0, 1, 2005);
INSERT INTO jobs (jobnum, jobdesc, jac_head, jopval, jrcval, jrdval, jconum, jyrno)
    VALUES (4, 'Motor Paint', 0, 0, 0, 0, 1, 2005);
INSERT INTO jobs (jobnum, jobdesc, jac_head, jopval, jrcval, jrdval, jconum, jyrno)
    VALUES (5, 'Motor Test', 0, 0, 0, 0, 1, 2005);


INSERT INTO prefers VALUES (1, 'Home Delivery', 'A', 1);
INSERT INTO prefers VALUES (2, 'Trial Period', 'A', 1);
INSERT INTO prefers VALUES (3, 'Payment by check only', 'A', 1);
INSERT INTO prefers VALUES (4, 'After Evening Hours', 'A', 1);

INSERT INTO bookref VALUES (1, 'General Journal');
INSERT INTO bookref VALUES (2, 'Check Payment');
INSERT INTO bookref VALUES (3, 'Check Received');
INSERT INTO bookref VALUES (4, 'Petty Cash');
INSERT INTO bookref VALUES (5, 'Payable');
INSERT INTO bookref VALUES (6, 'Receivable');

INSERT INTO `journals` VALUES (1,NULL,'2005-01-25',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'50000.0000','50000.0000',1,'pizza',NULL,NULL,1,2005),(2,NULL,'2005-05-25',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'13000.0000','13000.0000',1,'pizza',NULL,NULL,1,2005);
INSERT INTO `jourlines` VALUES (1,1,'2005-01-25',3,13,'50000.0000','0.0000'),(2,1,'2005-01-25',58,NULL,'0.0000','50000.0000'),(3,2,'2005-05-25',2,8,'0.0000','13000.0000'),(4,2,'2005-05-25',52,NULL,'13000.0000','0.0000');

########################################################################
# Time sheet
########################################################################

DROP TABLE IF EXISTS tstimes;
DROP TABLE IF EXISTS tsuser;
DROP TABLE IF EXISTS tstask_assignments;
DROP TABLE IF EXISTS tstask;
DROP TABLE IF EXISTS tsproject;
DROP TABLE IF EXISTS tsnote;
DROP TABLE IF EXISTS tsconfig;
DROP TABLE IF EXISTS tsclient;
DROP TABLE IF EXISTS tsassignments;


CREATE TABLE tsassignments (
  proj_id int(11) NOT NULL default '0',
  username char(32) NOT NULL default '',
  PRIMARY KEY  (proj_id,username)
) ;


CREATE TABLE tsclient (
  client_id int(8) NOT NULL auto_increment,
  organisation varchar(64) default NULL,
  description varchar(255) default NULL,
  address1 varchar(127) default NULL,
  city varchar(60) default NULL,
  state varchar(80) default NULL,
  country char(2) default NULL,
  postal_code varchar(13) default NULL,
  contact_first_name varchar(127) default NULL,
  contact_last_name varchar(127) default NULL,
  username varchar(32) default NULL,
  contact_email varchar(127) default NULL,
  phone_number varchar(20) default NULL,
  fax_number varchar(20) default NULL,
  gsm_number varchar(20) default NULL,
  http_url varchar(127) default NULL,
  address2 varchar(127) default NULL,
  PRIMARY KEY  (client_id)
) ;

CREATE TABLE tsconfig (
  config_set_id int(1) NOT NULL default '0',
  version varchar(32) NOT NULL default '__TIMESHEET_VERSION__',
  headerhtml mediumtext NOT NULL,
  bodyhtml mediumtext NOT NULL,
  footerhtml mediumtext NOT NULL,
  errorhtml mediumtext NOT NULL,
  bannerhtml mediumtext NOT NULL,
  tablehtml mediumtext NOT NULL,
  locale varchar(127) default NULL,
  timezone varchar(127) default NULL,
  timeformat enum('12','24') NOT NULL default '12',
  weekstartday tinyint(4) NOT NULL default '0',
  useLDAP tinyint(4) NOT NULL default '0',
  LDAPScheme varchar(32) default NULL,
  LDAPHost varchar(255) default NULL,
  LDAPPort int(11) default NULL,
  LDAPBaseDN varchar(255) default NULL,
  LDAPUsernameAttribute varchar(255) default NULL,
  LDAPSearchScope enum('base','sub','one') NOT NULL default 'base',
  LDAPFilter varchar(255) default NULL,
  LDAPProtocolVersion varchar(255) default '3',
  LDAPBindUsername varchar(255) default '',
  LDAPBindPassword varchar(255) default '',
  PRIMARY KEY  (config_set_id)
) ;

CREATE TABLE tsnote (
  note_id int(6) NOT NULL auto_increment,
  proj_id int(8) NOT NULL default '0',
  date datetime NOT NULL default '0000-00-00 00:00:00',
  subject varchar(127) NOT NULL default '',
  body text NOT NULL,
  to_contact enum('Y','N') NOT NULL default 'N',
  PRIMARY KEY  (note_id)
) ;

CREATE TABLE tsproject (
  proj_id int(11) NOT NULL auto_increment,
  title varchar(200) NOT NULL default '',
  client_id int(11) NOT NULL default '0',
  description varchar(255) default NULL,
  start_date date NOT NULL default '1970-01-01',
  deadline date NOT NULL default '0000-00-00',
  http_link varchar(127) default NULL,
  proj_status enum('Pending','Started','Suspended','Complete') NOT NULL default 'Pending',
  proj_leader varchar(32) NOT NULL default '',
  PRIMARY KEY  (proj_id)
) ;

CREATE TABLE tstask (
  task_id int(11) NOT NULL auto_increment,
  proj_id int(11) NOT NULL default '0',
  name varchar(127) NOT NULL default '',
  description text,
  assigned datetime NOT NULL default '0000-00-00 00:00:00',
  started datetime NOT NULL default '0000-00-00 00:00:00',
  suspended datetime NOT NULL default '0000-00-00 00:00:00',
  completed datetime NOT NULL default '0000-00-00 00:00:00',
  status enum('Pending','Assigned','Started','Suspended','Complete') NOT NULL default 'Pending',
  PRIMARY KEY  (task_id)
) ;

CREATE TABLE tstask_assignments (
  task_id int(8) NOT NULL default '0',
  username varchar(32) NOT NULL default '',
  proj_id int(11) NOT NULL default '0',
  PRIMARY KEY  (task_id,username)
) ;

CREATE TABLE tsuser (
  username varchar(32) NOT NULL default '',
  level int(11) NOT NULL default '0',
  password varchar(41) NOT NULL default '',
  allowed_realms varchar(20) NOT NULL default '.*',
  first_name varchar(64) NOT NULL default '',
  last_name varchar(64) NOT NULL default '',
  email_address varchar(63) NOT NULL default '',
  phone varchar(31) NOT NULL default '',
  bill_rate decimal(8,2) NOT NULL default '0.00',
  time_stamp timestamp NOT NULL,
  status enum('IN','OUT') NOT NULL default 'OUT',
  uid int(11) NOT NULL auto_increment,
  PRIMARY KEY  (username),
  KEY uid (uid)
) ;

CREATE TABLE tstimes (
  uid varchar(32) NOT NULL default '',
  start_time datetime NOT NULL default '1970-01-01 00:00:00',
  end_time datetime NOT NULL default '0000-00-00 00:00:00',
  trans_num int(11) NOT NULL auto_increment,
  proj_id int(11) NOT NULL default '1',
  task_id int(11) NOT NULL default '1',
  log_message varchar(255) default NULL,
  UNIQUE KEY trans_num (trans_num),
  KEY uid (uid,trans_num)
) ;

INSERT INTO tsassignments VALUES (1,'Samantha');
INSERT INTO tsassignments VALUES (1,'Suzy');
INSERT INTO tsassignments VALUES (1,'Joe');
INSERT INTO tsassignments VALUES (1,'David');
INSERT INTO tsassignments VALUES (1,'Goliath');
INSERT INTO tsassignments VALUES (1,'Kingsby');
INSERT INTO tsassignments VALUES (1,'Will');
INSERT INTO tsassignments VALUES (1,'Noni');
INSERT INTO tsassignments VALUES (1,'Bjorn');
INSERT INTO tsassignments VALUES (1,'Janice');
INSERT INTO tsassignments VALUES (1,'John');
INSERT INTO tsassignments VALUES (1,'Mohigan');
INSERT INTO tsassignments VALUES (1,'Sha');
INSERT INTO tsassignments VALUES (1,'Kay');
INSERT INTO tsassignments VALUES (1,'Jessica');
INSERT INTO tsassignments VALUES (1,'Tulip');
INSERT INTO tsassignments VALUES (1,'Uma');
INSERT INTO tsassignments VALUES (1,'Donald');
INSERT INTO tsassignments VALUES (10,'pizza');
INSERT INTO tsassignments VALUES (10,'David');
INSERT INTO tsassignments VALUES (10,'Noni');
INSERT INTO tsassignments VALUES (10,'Mohigan');
INSERT INTO tsassignments VALUES (11,'pizza');
INSERT INTO tsassignments VALUES (11,'David');
INSERT INTO tsassignments VALUES (11,'Noni');
INSERT INTO tsassignments VALUES (11,'Mohigan');
INSERT INTO tsassignments VALUES (12,'pizza');
INSERT INTO tsassignments VALUES (12,'David');
INSERT INTO tsassignments VALUES (12,'Noni');
INSERT INTO tsassignments VALUES (12,'Mohigan');
INSERT INTO tsassignments VALUES (13,'pizza');
INSERT INTO tsassignments VALUES (13,'David');
INSERT INTO tsassignments VALUES (13,'Noni');
INSERT INTO tsassignments VALUES (13,'Mohigan');
INSERT INTO tsassignments VALUES (14,'pizza');
INSERT INTO tsassignments VALUES (14,'David');
INSERT INTO tsassignments VALUES (14,'Noni');
INSERT INTO tsassignments VALUES (14,'Mohigan');
INSERT INTO tsassignments VALUES (15,'pizza');
INSERT INTO tsassignments VALUES (15,'David');
INSERT INTO tsassignments VALUES (15,'Noni');
INSERT INTO tsassignments VALUES (15,'Mohigan');
INSERT INTO tsassignments VALUES (16,'pizza');
INSERT INTO tsassignments VALUES (16,'David');
INSERT INTO tsassignments VALUES (16,'Noni');
INSERT INTO tsassignments VALUES (16,'Mohigan');
INSERT INTO tsassignments VALUES (17,'pizza');
INSERT INTO tsassignments VALUES (17,'David');
INSERT INTO tsassignments VALUES (17,'Noni');
INSERT INTO tsassignments VALUES (17,'Mohigan');
INSERT INTO tsassignments VALUES (18,'pizza');
INSERT INTO tsassignments VALUES (18,'David');
INSERT INTO tsassignments VALUES (18,'Noni');
INSERT INTO tsassignments VALUES (18,'Mohigan');

INSERT INTO tsclient VALUES (1,'No Client','This is required, do not edit or delete this client record','','','','','','','','','','','','','','');
INSERT INTO tsclient VALUES (2,'Mpar Insurance','Mpar Insurance - Exxon Division','161 Broadway','New York','L','US','10036-5797','Noni','Jackass','','Noni.Jackass@mpar.com','','','','www.mpar.com','');

INSERT INTO tsconfig VALUES (0,'__TIMESHEET_VERSION__','<META name=\"description\" content=\"Timesheet.php Employee/Contractor Timesheets\">\r\n<link href=\"css/timesheet.css\" rel=\"stylesheet\" type=\"text/css\">','link=\"#004E8A\" vlink=\"#171A42\"','<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">\r\n<tr><td style=\"background-color: #000788; padding: 3;\" class=\"bottom_bar_text\" align=\"center\">\r\n\r\nTimesheet.php website: <A href=\"http://www.advancen.com/timesheet/\"><span \r\n\r\nclass=\"bottom_bar_text\">http://www.advancen.com/timesheet/</span></A>\r\n<br><span style=\"font-size: 9px;\"><b>Page generated %time% %date% (%timezone% time)</b></span>\r\n\r\n</td></tr></table>','<TABLE border=0 cellpadding=5 width=\"100%\">\r\n<TR><TD><FONT size=\"+2\" color=\"red\">%errormsg%</FONT></TD></TR></TABLE>\r\n<P>Please go <A href=\"javascript:history.back()\">Back</A> and try again.</P>','<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\"><tr>\r\n<td colspan=\"2\" background=\"images/timesheet_background_pattern.gif\"><img src=\"images/timesheet_banner.gif\"></td></tr><tr>\r\n\r\n<td style=\"background-color: #F2F3FF; padding: 3;\">%commandmenu%</td>\r\n<td style=\"background-color: #F2F3FF; padding: 3;\" align=\"right\" width=\"145\" valign=\"top\">You are logged in as %username%</td>\r\n</tr><td colspan=\"2\" height=\"1\" style=\"background-color: #758DD6;\"><img src=\"images/spacer.gif\" width=\"1\" height=\"1\"></td></tr>\r\n</table>','','en_AU','Australia/Melbourne','12',1,0,'ldap','watson',389,'dc=watson','cn','base','','3','','');
INSERT INTO tsconfig VALUES (1,'__TIMESHEET_VERSION__','<META name=\"description\" content=\"Timesheet.php Employee/Contractor Timesheets\">\r\n<link href=\"css/timesheet.css\" rel=\"stylesheet\" type=\"text/css\">','link=\"#004E8A\" vlink=\"#171A42\"','<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">\r\n<tr><td style=\"background-color: #000788; padding: 3;\" class=\"bottom_bar_text\" align=\"center\">\r\n\r\nTimesheet.php website: <A href=\"http://www.advancen.com/timesheet/\"><span \r\n\r\nclass=\"bottom_bar_text\">http://www.advancen.com/timesheet/</span></A>\r\n<br><span style=\"font-size: 9px;\"><b>Page generated %time% %date% (%timezone% time)</b></span>\r\n\r\n</td></tr></table>','<TABLE border=0 cellpadding=5 width=\"100%\">\r\n<TR><TD><FONT size=\"+2\" color=\"red\">%errormsg%</FONT></TD></TR></TABLE>\r\n<P>Please go <A href=\"javascript:history.back()\">Back</A> and try again.</P>','<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\"><tr>\r\n<td colspan=\"2\" background=\"images/timesheet_background_pattern.gif\"><img src=\"images/timesheet_banner.gif\"></td></tr><tr>\r\n\r\n<td style=\"background-color: #F2F3FF; padding: 3;\">%commandmenu%</td>\r\n<td style=\"background-color: #F2F3FF; padding: 3;\" align=\"right\" width=\"145\" valign=\"top\">You are logged in as %username%</td>\r\n</tr><td colspan=\"2\" height=\"1\" style=\"background-color: #758DD6;\"><img src=\"images/spacer.gif\" width=\"1\" height=\"1\"></td></tr>\r\n</table>','','en_AU','Australia/Melbourne','12',1,0,'ldap','watson',389,'dc=watson','cn','base','','3','','');
INSERT INTO tsconfig VALUES (2,'__TIMESHEET_VERSION__','<META name=\"description\" content=\"Timesheet.php Employee/Contractor Timesheets\">\r\n<link href=\"css/questra/timesheet.css\" rel=\"stylesheet\" type=\"text/css\">','link=\"#004E8A\" vlink=\"#171A42\"','</td><td width=\"2\" style=\"background-color: #9494B7;\"><img src=\"images/questra/spacer.gif\" width=\"2\" height=\"1\"></td></tr>\r\n<tr><td colspan=\"3\" style=\"background-color: #9494B7; padding: 3;\" class=\"bottom_bar_text\" align=\"center\">\r\n\r\nTimesheet.php website: <A href=\"http://www.advancen.com/timesheet/\"><span \r\n\r\nclass=\"bottom_bar_text\">http://www.advancen.com/timesheet/</span></A>\r\n<br><span style=\"font-size: 9px;\"><b>Page generated %time% %date% (%timezone% time)</b></span>\r\n\r\n</td></tr></table>','<TABLE border=0 cellpadding=5 width=\"100%\">\r\n<TR><TD><FONT size=\"+2\" color=\"red\">%errormsg%</FONT></TD></TR></TABLE>\r\n<P>Please go <A href=\"javascript:history.back()\">Back</A> and try again.</P>','<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\"><tr>\r\n  <td style=\"padding-right: 15; padding-bottom: 8;\"><img src=\"images/questra/logo.gif\"></td>\r\n  <td width=\"100%\" valign=\"bottom\">\r\n    <table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">\r\n      <tr><td colspan=\"3\" class=\"text_faint\" style=\"padding-bottom: 5;\" align=\"right\">You are logged in as %username%.</td></tr>\r\n      <tr>\r\n        <td background=\"images/questra/bar_left.gif\" valign=\"top\"><img src=\"images/questra/spacer.gif\" height=\"1\" width=\"8\"></td>\r\n        <td background=\"images/questra/bar_background.gif\" width=\"100%\" style=\"padding: 5;\">%commandmenu%</td>\r\n        <td background=\"images/questra/bar_right.gif\" valign=\"top\"><img src=\"images/questra/spacer.gif\" height=\"1\" width=\"8\"></td>\r\n      </tr>\r\n    </table>\r\n  </td>\r\n</tr></table>\r\n\r\n<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\"><tr>\r\n<td colspan=\"3\" height=\"8\" style=\"background-color: #9494B7;\"><img src=\"images/questra/spacer.gif\" width=\"1\" height=\"8\"></td></tr><tr>\r\n<td width=\"2\" style=\"background-color: #9494B7;\"><img src=\"images/questra/spacer.gif\" width=\"2\" height=\"1\"></td>\r\n<td width=\"100%\" bgcolor=\"#F2F2F8\">','','en_AU','Australia/Melbourne','12',1,0,'ldap','watson',389,'dc=watson','cn','base','','3','','');

INSERT INTO tsproject VALUES (10,'PRJ-01 SOX Express',2,'This is a vendor application.','2005-10-06','2005-10-06','','Started','David');
INSERT INTO tsproject VALUES (11,'PRJ-03 ERP JDE',2,'','2005-10-06','2005-10-06','','Started','David');
INSERT INTO tsproject VALUES (12,'PRJ-05 TM1 FCS',2,'','2005-10-06','2005-10-06','','Started','David');
INSERT INTO tsproject VALUES (13,'PRJ-07 Secretariat',2,'','2005-10-06','2005-10-06','','Started','David');
INSERT INTO tsproject VALUES (14,'PRJ-13 SEC Tools Legal',2,'','2005-10-06','2005-10-06','','Started','David');
INSERT INTO tsproject VALUES (15,'PRJ-16 Corporate Tax/GDX/ADS',2,'','2005-10-06','2005-10-06','','Started','David');
INSERT INTO tsproject VALUES (16,'PRJ-18 Chase Insight',2,'','2005-10-06','2005-10-06','','Started','David');
INSERT INTO tsproject VALUES (17,'PRJ-19 FXpress',2,'','2005-10-06','2005-10-06','','Started','David');
INSERT INTO tsproject VALUES (18,'PRJ-20 PNotes',2,'','2005-10-06','2005-10-06','','Started','David');

INSERT INTO tstask VALUES (54,18,'Default Task','','2005-10-03 20:04:00','2005-10-03 20:04:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (55,10,'Kick off meeting','','2005-10-03 20:07:00','2005-10-03 20:07:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (56,10,'Project Schedule and Resources','','2005-10-03 20:08:00','2005-10-03 20:08:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (57,10,'Requirements Documents, Use Cases, Functional Analysis Study','','2005-10-03 20:09:00','2005-10-03 20:09:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (58,10,'Identification of Core / Non-Core Functionality','','2005-10-03 20:10:00','2005-10-03 20:10:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (59,10,'Identify Customer Expectations (Expected Application Behavior)','','2005-10-03 20:11:00','2005-10-03 20:11:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (53,17,'Default Task','','2005-10-03 20:04:00','2005-10-03 20:04:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (52,16,'Default Task','','2005-10-03 20:03:00','2005-10-03 20:03:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (51,15,'Default Task','','2005-10-03 20:03:00','2005-10-03 20:03:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (50,14,'Default Task','','2005-10-03 20:02:00','2005-10-03 20:02:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (49,13,'Default Task','','2005-10-03 20:02:00','2005-10-03 20:02:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (48,12,'Default Task','','2005-10-03 20:02:00','2005-10-03 20:02:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (47,11,'Default Task','','2005-10-03 20:01:00','2005-10-03 20:01:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (46,10,'Default Task','','2005-10-03 20:00:00','2005-10-03 20:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (61,10,'Design and Strategize Scripts','','2005-10-03 20:13:00','2005-10-03 20:13:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (60,10,'Check for Patterns / Existing Scripts','','2005-10-03 20:12:00','2005-10-03 20:12:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (69,10,'Report Defects','','2005-10-03 20:16:00','2005-10-03 20:16:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (66,10,'Check Environment','','2005-10-03 20:15:00','2005-10-03 20:15:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (67,10,'Execute Tests','','2005-10-03 20:15:00','2005-10-03 20:15:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (68,10,'Check and Monitor Logs','','2005-10-03 20:16:00','2005-10-03 20:16:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (70,10,'Report and Setup Dashboard','','2005-10-03 20:17:00','2005-10-03 20:17:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (65,10,'Test the Scripts','','2005-10-03 20:15:00','2005-10-03 20:15:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (64,10,'Test Cases Identification and Nomenclature','','2005-10-03 20:14:00','2005-10-03 20:14:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (62,10,'Plan the Tests','','2005-10-03 20:13:00','2005-10-03 20:13:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (63,10,'Document the Test Plan','','2005-10-03 20:14:00','2005-10-03 20:14:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (74,11,'Identification of Core / Non-Core Functionality','','2005-10-03 20:10:00','2005-10-03 20:10:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (73,11,'Requirements Documents, Use Cases, Functional Analysis Study','','2005-10-03 20:09:00','2005-10-03 20:09:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (71,11,'Kick off meeting','','2005-10-03 20:07:00','2005-10-03 20:07:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (72,11,'Project Schedule and Resources','','2005-10-03 20:08:00','2005-10-03 20:08:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (75,11,'Identify Customer Expectations (Expected Application Behavior)','','2005-10-03 20:11:00','2005-10-03 20:11:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (76,11,'Test Cases Identification and Nomenclature','','2005-10-03 20:14:00','2005-10-03 20:14:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (77,11,'Design and Strategize Scripts','','2005-10-03 20:13:00','2005-10-03 20:13:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (78,11,'Plan the Tests','','2005-10-03 20:13:00','2005-10-03 20:13:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (79,11,'Document the Test Plan','','2005-10-03 20:14:00','2005-10-03 20:14:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (80,11,'Test the Scripts','','2005-10-03 20:15:00','2005-10-03 20:15:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (81,11,'Check for Patterns / Existing Scripts','','2005-10-03 20:12:00','2005-10-03 20:12:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (82,11,'Check Environment','','2005-10-03 20:15:00','2005-10-03 20:15:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (83,11,'Execute Tests','','2005-10-03 20:15:00','2005-10-03 20:15:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (84,11,'Check and Monitor Logs','','2005-10-03 20:16:00','2005-10-03 20:16:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (85,11,'Report Defects','','2005-10-03 20:16:00','2005-10-03 20:16:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (86,11,'Report and Setup Dashboard','','2005-10-03 20:17:00','2005-10-03 20:17:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (87,12,'Kick off meeting','','2005-10-03 20:07:00','2005-10-03 20:07:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (88,12,'Project Schedule and Resources','','2005-10-03 20:08:00','2005-10-03 20:08:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (89,12,'Requirements Documents, Use Cases, Functional Analysis Study','','2005-10-03 20:09:00','2005-10-03 20:09:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (90,12,'Identification of Core / Non-Core Functionality','','2005-10-03 20:10:00','2005-10-03 20:10:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (91,12,'Identify Customer Expectations (Expected Application Behavior)','','2005-10-03 20:11:00','2005-10-03 20:11:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (92,12,'Test Cases Identification and Nomenclature','','2005-10-03 20:14:00','2005-10-03 20:14:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (93,12,'Design and Strategize Scripts','','2005-10-03 20:13:00','2005-10-03 20:13:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (94,12,'Plan the Tests','','2005-10-03 20:13:00','2005-10-03 20:13:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (95,12,'Document the Test Plan','','2005-10-03 20:14:00','2005-10-03 20:14:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (96,12,'Test the Scripts','','2005-10-03 20:15:00','2005-10-03 20:15:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (97,12,'Check for Patterns / Existing Scripts','','2005-10-03 20:12:00','2005-10-03 20:12:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (98,12,'Check Environment','','2005-10-03 20:15:00','2005-10-03 20:15:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (99,12,'Execute Tests','','2005-10-03 20:15:00','2005-10-03 20:15:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (100,12,'Check and Monitor Logs','','2005-10-03 20:16:00','2005-10-03 20:16:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (101,12,'Report Defects','','2005-10-03 20:16:00','2005-10-03 20:16:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (102,12,'Report and Setup Dashboard','','2005-10-03 20:17:00','2005-10-03 20:17:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (103,13,'Kick off meeting','','2005-10-03 20:07:00','2005-10-03 20:07:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (104,13,'Project Schedule and Resources','','2005-10-03 20:08:00','2005-10-03 20:08:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (105,13,'Requirements Documents, Use Cases, Functional Analysis Study','','2005-10-03 20:09:00','2005-10-03 20:09:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (106,13,'Identification of Core / Non-Core Functionality','','2005-10-03 20:10:00','2005-10-03 20:10:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (107,13,'Identify Customer Expectations (Expected Application Behavior)','','2005-10-03 20:11:00','2005-10-03 20:11:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (108,13,'Test Cases Identification and Nomenclature','','2005-10-03 20:14:00','2005-10-03 20:14:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (109,13,'Design and Strategize Scripts','','2005-10-03 20:13:00','2005-10-03 20:13:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (110,13,'Plan the Tests','','2005-10-03 20:13:00','2005-10-03 20:13:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (111,13,'Document the Test Plan','','2005-10-03 20:14:00','2005-10-03 20:14:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (112,13,'Test the Scripts','','2005-10-03 20:15:00','2005-10-03 20:15:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (113,13,'Check for Patterns / Existing Scripts','','2005-10-03 20:12:00','2005-10-03 20:12:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (114,13,'Check Environment','','2005-10-03 20:15:00','2005-10-03 20:15:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (115,13,'Execute Tests','','2005-10-03 20:15:00','2005-10-03 20:15:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (116,13,'Check and Monitor Logs','','2005-10-03 20:16:00','2005-10-03 20:16:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (117,13,'Report Defects','','2005-10-03 20:16:00','2005-10-03 20:16:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (118,13,'Report and Setup Dashboard','','2005-10-03 20:17:00','2005-10-03 20:17:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (119,14,'Kick off meeting','','2005-10-03 20:07:00','2005-10-03 20:07:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (120,14,'Project Schedule and Resources','','2005-10-03 20:08:00','2005-10-03 20:08:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (121,14,'Requirements Documents, Use Cases, Functional Analysis Study','','2005-10-03 20:09:00','2005-10-03 20:09:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (122,14,'Identification of Core / Non-Core Functionality','','2005-10-03 20:10:00','2005-10-03 20:10:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (123,14,'Identify Customer Expectations (Expected Application Behavior)','','2005-10-03 20:11:00','2005-10-03 20:11:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (124,14,'Test Cases Identification and Nomenclature','','2005-10-03 20:14:00','2005-10-03 20:14:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (125,14,'Design and Strategize Scripts','','2005-10-03 20:13:00','2005-10-03 20:13:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (126,14,'Plan the Tests','','2005-10-03 20:13:00','2005-10-03 20:13:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (127,14,'Document the Test Plan','','2005-10-03 20:14:00','2005-10-03 20:14:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (128,14,'Test the Scripts','','2005-10-03 20:15:00','2005-10-03 20:15:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (129,14,'Check for Patterns / Existing Scripts','','2005-10-03 20:12:00','2005-10-03 20:12:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (130,14,'Check Environment','','2005-10-03 20:15:00','2005-10-03 20:15:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (131,14,'Execute Tests','','2005-10-03 20:15:00','2005-10-03 20:15:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (132,14,'Check and Monitor Logs','','2005-10-03 20:16:00','2005-10-03 20:16:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (133,14,'Report Defects','','2005-10-03 20:16:00','2005-10-03 20:16:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (134,14,'Report and Setup Dashboard','','2005-10-03 20:17:00','2005-10-03 20:17:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (135,15,'Kick off meeting','','2005-10-03 20:07:00','2005-10-03 20:07:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (136,15,'Project Schedule and Resources','','2005-10-03 20:08:00','2005-10-03 20:08:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (137,15,'Requirements Documents, Use Cases, Functional Analysis Study','','2005-10-03 20:09:00','2005-10-03 20:09:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (138,15,'Identification of Core / Non-Core Functionality','','2005-10-03 20:10:00','2005-10-03 20:10:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (139,15,'Identify Customer Expectations (Expected Application Behavior)','','2005-10-03 20:11:00','2005-10-03 20:11:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (140,15,'Test Cases Identification and Nomenclature','','2005-10-03 20:14:00','2005-10-03 20:14:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (141,15,'Design and Strategize Scripts','','2005-10-03 20:13:00','2005-10-03 20:13:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (142,15,'Plan the Tests','','2005-10-03 20:13:00','2005-10-03 20:13:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (143,15,'Document the Test Plan','','2005-10-03 20:14:00','2005-10-03 20:14:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (144,15,'Test the Scripts','','2005-10-03 20:15:00','2005-10-03 20:15:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (145,15,'Check for Patterns / Existing Scripts','','2005-10-03 20:12:00','2005-10-03 20:12:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (146,15,'Check Environment','','2005-10-03 20:15:00','2005-10-03 20:15:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (147,15,'Execute Tests','','2005-10-03 20:15:00','2005-10-03 20:15:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (148,15,'Check and Monitor Logs','','2005-10-03 20:16:00','2005-10-03 20:16:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (149,15,'Report Defects','','2005-10-03 20:16:00','2005-10-03 20:16:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (150,15,'Report and Setup Dashboard','','2005-10-03 20:17:00','2005-10-03 20:17:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (151,16,'Kick off meeting','','2005-10-03 20:07:00','2005-10-03 20:07:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (152,16,'Project Schedule and Resources','','2005-10-03 20:08:00','2005-10-03 20:08:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (153,16,'Requirements Documents, Use Cases, Functional Analysis Study','','2005-10-03 20:09:00','2005-10-03 20:09:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (154,16,'Identification of Core / Non-Core Functionality','','2005-10-03 20:10:00','2005-10-03 20:10:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (155,16,'Identify Customer Expectations (Expected Application Behavior)','','2005-10-03 20:11:00','2005-10-03 20:11:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (156,16,'Test Cases Identification and Nomenclature','','2005-10-03 20:14:00','2005-10-03 20:14:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (157,16,'Design and Strategize Scripts','','2005-10-03 20:13:00','2005-10-03 20:13:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (158,16,'Plan the Tests','','2005-10-03 20:13:00','2005-10-03 20:13:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (159,16,'Document the Test Plan','','2005-10-03 20:14:00','2005-10-03 20:14:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (160,16,'Test the Scripts','','2005-10-03 20:15:00','2005-10-03 20:15:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (161,16,'Check for Patterns / Existing Scripts','','2005-10-03 20:12:00','2005-10-03 20:12:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (162,16,'Check Environment','','2005-10-03 20:15:00','2005-10-03 20:15:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (163,16,'Execute Tests','','2005-10-03 20:15:00','2005-10-03 20:15:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (164,16,'Check and Monitor Logs','','2005-10-03 20:16:00','2005-10-03 20:16:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (165,16,'Report Defects','','2005-10-03 20:16:00','2005-10-03 20:16:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (166,16,'Report and Setup Dashboard','','2005-10-03 20:17:00','2005-10-03 20:17:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (167,17,'Kick off meeting','','2005-10-03 20:07:00','2005-10-03 20:07:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (168,17,'Project Schedule and Resources','','2005-10-03 20:08:00','2005-10-03 20:08:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (169,17,'Requirements Documents, Use Cases, Functional Analysis Study','','2005-10-03 20:09:00','2005-10-03 20:09:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (170,17,'Identification of Core / Non-Core Functionality','','2005-10-03 20:10:00','2005-10-03 20:10:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (171,17,'Identify Customer Expectations (Expected Application Behavior)','','2005-10-03 20:11:00','2005-10-03 20:11:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (172,17,'Test Cases Identification and Nomenclature','','2005-10-03 20:14:00','2005-10-03 20:14:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (173,17,'Design and Strategize Scripts','','2005-10-03 20:13:00','2005-10-03 20:13:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (174,17,'Plan the Tests','','2005-10-03 20:13:00','2005-10-03 20:13:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (175,17,'Document the Test Plan','','2005-10-03 20:14:00','2005-10-03 20:14:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (176,17,'Test the Scripts','','2005-10-03 20:15:00','2005-10-03 20:15:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (177,17,'Check for Patterns / Existing Scripts','','2005-10-03 20:12:00','2005-10-03 20:12:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (178,17,'Check Environment','','2005-10-03 20:15:00','2005-10-03 20:15:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (179,17,'Execute Tests','','2005-10-03 20:15:00','2005-10-03 20:15:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (180,17,'Check and Monitor Logs','','2005-10-03 20:16:00','2005-10-03 20:16:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (181,17,'Report Defects','','2005-10-03 20:16:00','2005-10-03 20:16:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (182,17,'Report and Setup Dashboard','','2005-10-03 20:17:00','2005-10-03 20:17:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (183,18,'Kick off meeting','','2005-10-03 20:07:00','2005-10-03 20:07:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (184,18,'Project Schedule and Resources','','2005-10-03 20:08:00','2005-10-03 20:08:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (185,18,'Requirements Documents, Use Cases, Functional Analysis Study','','2005-10-03 20:09:00','2005-10-03 20:09:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (186,18,'Identification of Core / Non-Core Functionality','','2005-10-03 20:10:00','2005-10-03 20:10:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (187,18,'Identify Customer Expectations (Expected Application Behavior)','','2005-10-03 20:11:00','2005-10-03 20:11:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (188,18,'Test Cases Identification and Nomenclature','','2005-10-03 20:14:00','2005-10-03 20:14:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (189,18,'Design and Strategize Scripts','','2005-10-03 20:13:00','2005-10-03 20:13:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (190,18,'Plan the Tests','','2005-10-03 20:13:00','2005-10-03 20:13:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (191,18,'Document the Test Plan','','2005-10-03 20:14:00','2005-10-03 20:14:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (192,18,'Test the Scripts','','2005-10-03 20:15:00','2005-10-03 20:15:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (193,18,'Check for Patterns / Existing Scripts','','2005-10-03 20:12:00','2005-10-03 20:12:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (194,18,'Check Environment','','2005-10-03 20:15:00','2005-10-03 20:15:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (195,18,'Execute Tests','','2005-10-03 20:15:00','2005-10-03 20:15:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (196,18,'Check and Monitor Logs','','2005-10-03 20:16:00','2005-10-03 20:16:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (197,18,'Report Defects','','2005-10-03 20:16:00','2005-10-03 20:16:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');
INSERT INTO tstask VALUES (198,18,'Report and Setup Dashboard','','2005-10-03 20:17:00','2005-10-03 20:17:00','0000-00-00 00:00:00','0000-00-00 00:00:00','Started');


--
-- Dumping data for table `tstask_assignments`
--

INSERT INTO tstask_assignments VALUES (1,'Tulip',1);
INSERT INTO tstask_assignments VALUES (1,'John',1);
INSERT INTO tstask_assignments VALUES (1,'Suzy',1);
INSERT INTO tstask_assignments VALUES (1,'Jessica',1);
INSERT INTO tstask_assignments VALUES (1,'Goliath',1);
INSERT INTO tstask_assignments VALUES (1,'Donald',1);
INSERT INTO tstask_assignments VALUES (1,'Janice',1);
INSERT INTO tstask_assignments VALUES (1,'Will',1);
INSERT INTO tstask_assignments VALUES (1,'Uma',1);
INSERT INTO tstask_assignments VALUES (1,'Kay',1);
INSERT INTO tstask_assignments VALUES (1,'Joe',1);
INSERT INTO tstask_assignments VALUES (1,'Bjorn',1);
INSERT INTO tstask_assignments VALUES (1,'Sha',1);
INSERT INTO tstask_assignments VALUES (1,'Samantha',1);
INSERT INTO tstask_assignments VALUES (1,'Kingsby',1);
INSERT INTO tstask_assignments VALUES (135,'Noni',15);
INSERT INTO tstask_assignments VALUES (135,'David',15);
INSERT INTO tstask_assignments VALUES (66,'Mohigan',10);
INSERT INTO tstask_assignments VALUES (64,'Mohigan',10);
INSERT INTO tstask_assignments VALUES (63,'Mohigan',10);
INSERT INTO tstask_assignments VALUES (62,'Mohigan',10);
INSERT INTO tstask_assignments VALUES (61,'Mohigan',10);
INSERT INTO tstask_assignments VALUES (60,'Mohigan',10);
INSERT INTO tstask_assignments VALUES (59,'David',10);
INSERT INTO tstask_assignments VALUES (58,'Mohigan',10);
INSERT INTO tstask_assignments VALUES (58,'David',10);
INSERT INTO tstask_assignments VALUES (57,'Mohigan',10);
INSERT INTO tstask_assignments VALUES (56,'David',10);
INSERT INTO tstask_assignments VALUES (55,'David',10);
INSERT INTO tstask_assignments VALUES (55,'Noni',10);
INSERT INTO tstask_assignments VALUES (54,'David',18);
INSERT INTO tstask_assignments VALUES (53,'David',17);
INSERT INTO tstask_assignments VALUES (52,'David',16);
INSERT INTO tstask_assignments VALUES (51,'David',15);
INSERT INTO tstask_assignments VALUES (50,'David',14);
INSERT INTO tstask_assignments VALUES (49,'David',13);
INSERT INTO tstask_assignments VALUES (48,'David',12);
INSERT INTO tstask_assignments VALUES (47,'David',11);
INSERT INTO tstask_assignments VALUES (46,'David',10);
INSERT INTO tstask_assignments VALUES (1,'Mohigan',1);
INSERT INTO tstask_assignments VALUES (1,'Noni',1);
INSERT INTO tstask_assignments VALUES (1,'David',1);


INSERT INTO tsuser VALUES ('pizza',11,'flavor','.*','Timesheet','pizza','','',0.00,20051003145042,'OUT',1);
INSERT INTO tsuser VALUES ('David',11,'1234','.*','David','Campbell','Davidc@mpar.com','212-846-5975',0.00,20051005101506,'OUT',5);
INSERT INTO tsuser VALUES ('Noni',11,'1234','.*','Noni','Zune','Noni.zune@mpar.com','212-846-3213',0.00,00000000000000,'OUT',6);
INSERT INTO tsuser VALUES ('Mohigan',1,'1234','.*','Mohigan','Last','Mohigan.last@mpar.com','',0.00,00000000000000,'OUT',7);
INSERT INTO tsuser VALUES ('Kingsby',1,'1234','.*','Kingsby','Bill','','',0.00,00000000000000,'OUT',8);
INSERT INTO tsuser VALUES ('Samantha',1,'1234','.*','Samantha','Jonathan','','',0.00,00000000000000,'OUT',9);
INSERT INTO tsuser VALUES ('Jessica',1,'1234','.*','Jessica','Smith','','',0.00,00000000000000,'OUT',10);
INSERT INTO tsuser VALUES ('Suzy',1,'1234','.*','Suzy','Roberts','','',0.00,00000000000000,'OUT',11);
INSERT INTO tsuser VALUES ('John',1,'1234','.*','John','Wayne','','',0.00,00000000000000,'OUT',12);
INSERT INTO tsuser VALUES ('Sha',1,'1234','.*','Sha','Bee','','',0.00,20051005102237,'OUT',13);
INSERT INTO tsuser VALUES ('Bjorn',1,'1234','.*','Bjorn','Drucker','','',0.00,00000000000000,'OUT',14);
INSERT INTO tsuser VALUES ('Joe',1,'1234','.*','Joe','Someone','','',0.00,00000000000000,'OUT',15);
INSERT INTO tsuser VALUES ('Kay',1,'1234','.*','Kay','Lucky','','',0.00,00000000000000,'OUT',16);
INSERT INTO tsuser VALUES ('Uma',1,'1234','.*','Uma','Mahesh','','',0.00,00000000000000,'OUT',17);
INSERT INTO tsuser VALUES ('Will',1,'1234','.*','Will','Smith','','',0.00,00000000000000,'OUT',18);
INSERT INTO tsuser VALUES ('Janice',1,'1234','.*','Janice','Doors','','',0.00,00000000000000,'OUT',19);
INSERT INTO tsuser VALUES ('Donald',1,'1234','.*','Donald','Duck','','',0.00,00000000000000,'OUT',20);
INSERT INTO tsuser VALUES ('Goliath',1,'1234','.*','Goliath','Big','','',0.00,00000000000000,'OUT',21);
INSERT INTO tsuser VALUES ('Tulip',1,'1234','.*','Tulip','Small','','',0.00,00000000000000,'OUT',22);

DROP TABLE IF EXISTS `vhd_accounts`;
CREATE TABLE `vhd_accounts` (
  `ID` int(11) NOT NULL auto_increment,
  `User` varchar(255) NOT NULL default '',
  `Pass` varchar(255) NOT NULL default '',
  `FirstName` varchar(255) NOT NULL default '',
  `LastName` varchar(255) NOT NULL default '',
  `ComputerName` varchar(255) NOT NULL default '',
  `HelpDeskAddress` blob NOT NULL,
  `email_addr` varchar(255) NOT NULL default '',
  `securityLevel` int(1) NOT NULL default '2',
  PRIMARY KEY  (`ID`)
) ;

INSERT INTO `vhd_accounts` VALUES (1,'pizza','flavor','pizza','flavor','DemoComputerName','','pf@value.erp',1),(2,'jdunes','jdunes','Janice','Dunes','DemoComputerName','','jdunes@value.erp',2);

DROP TABLE IF EXISTS `vhd_data`;
CREATE TABLE `vhd_data` (
  `ID` int(11) NOT NULL auto_increment,
  `FirstName` varchar(255) NOT NULL default '',
  `EMail` varchar(255) NOT NULL default '',
  `LastName` varchar(255) NOT NULL default '',
  `PCatagory` varchar(255) NOT NULL default '',
  `descrip` blob NOT NULL,
  `status` varchar(255) NOT NULL default '',
  `resolution` blob NOT NULL,
  `staff` varchar(255) NOT NULL default '',
  `mainDate` varchar(255) NOT NULL default '',
  `priority` varchar(255) NOT NULL default '',
  `platform` varchar(50) NOT NULL default '',
  `os` varchar(50) NOT NULL default '',
  `ipaddress` varchar(50) NOT NULL default '',
  `browser` varchar(50) NOT NULL default '',
  `bversion` varchar(50) NOT NULL default '',
  `uastring` varchar(50) NOT NULL default '',
  `partNo` int(11) default NULL,
  `phoneNumber` int(10) default '0',
  `phoneExt` int(11) default '0',
  PRIMARY KEY  (`ID`)
) ;

DROP TABLE IF EXISTS `vhd_excess`;
CREATE TABLE `vhd_excess` (
  `ID` int(11) NOT NULL auto_increment,
  `FirstName` varchar(255) NOT NULL default '',
  `LastName` varchar(255) NOT NULL default '',
  `partNum` blob NOT NULL,
  `serial` blob NOT NULL,
  `location` blob NOT NULL,
  `descrip` blob NOT NULL,
  `date` varchar(255) NOT NULL default '0',
  `price` decimal(10,2) NOT NULL default '0.00',
  PRIMARY KEY  (`ID`)
) ;

DROP TABLE IF EXISTS `vhd_inventory`;
CREATE TABLE `vhd_inventory` (
  `ID` int(11) NOT NULL auto_increment,
  `UserName` varchar(255) NOT NULL default '',
  `FirstName` varchar(255) NOT NULL default '',
  `LastName` varchar(255) NOT NULL default '',
  `CompName` varchar(255) NOT NULL default '',
  `Office` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`ID`)
) ;

DROP TABLE IF EXISTS `vhd_priorities`;
CREATE TABLE `vhd_priorities` (
  `pid` int(11) NOT NULL auto_increment,
  `priority` varchar(50) NOT NULL default '',
  PRIMARY KEY  (`pid`)
) ;

DROP TABLE IF EXISTS `vhd_problem`;
CREATE TABLE `vhd_problem` (
  `pid` int(11) NOT NULL auto_increment,
  `pcategory` varchar(50) NOT NULL default '',
  PRIMARY KEY  (`pid`)
) ;

DROP TABLE IF EXISTS `vhd_resolution`;
CREATE TABLE `vhd_resolution` (
  `resid` int(11) NOT NULL auto_increment,
  `id` int(11) NOT NULL default '0',
  `solution` text NOT NULL,
  `resdate` varchar(50) NOT NULL default '',
  PRIMARY KEY  (`resid`)
) ;

DROP TABLE IF EXISTS `vhd_security`;
CREATE TABLE `vhd_security` (
  `ID` int(11) NOT NULL auto_increment,
  `Name1` blob NOT NULL,
  `Name2` blob NOT NULL,
  `Date` varchar(255) NOT NULL default '0',
  `Descrip` blob NOT NULL,
  PRIMARY KEY  (`ID`)
) ;

DROP TABLE IF EXISTS `vhd_settings`;
CREATE TABLE `vhd_settings` (
  `navigation` char(1) NOT NULL default '',
  `helpdesk` char(1) NOT NULL default '',
  `result_page` int(11) NOT NULL default '0',
  `hdticket` int(1) NOT NULL default '0',
  `hdemail` int(1) NOT NULL default '0',
  `email_type` int(1) NOT NULL default '0',
  `req_image` int(1) NOT NULL default '0',
  `hdemail_up` int(1) NOT NULL default '0',
  `hdemail_create` int(1) NOT NULL default '0',
  `hdemail_close` int(1) NOT NULL default '0'
) ;

INSERT INTO `vhd_settings` VALUES ('B','S',5,1,1,1,1,0,0,0);

# *************************************************************************
# END OF FILE
# *************************************************************************

