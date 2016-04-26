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
# >\. value_small.sql
# >\t
# *************************************************************************

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

CREATE TABLE organization (
    organization_id integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
    organization_name varchar (90) NOT NULL,
    type varchar(90) NOT NULL ,
    description varchar(254)
) TYPE=INNODB;


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
) TYPE=INNODB;

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
) TYPE=INNODB;


create table pword
    (pwuser     varchar(90) NOT NULL PRIMARY KEY,
     pwword     varchar(12) NOT NULL,
     email      varchar(90) NOT NULL,
     table_owner        VARCHAR(50),
     role           VARCHAR(20),
     responsibility VARCHAR(20)
) TYPE=INNODB;

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
) TYPE=INNODB;

create table grouper
    (group_id   integer NOT NULL PRIMARY KEY,
     group_desc varchar(90)
) TYPE=INNODB;

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
) TYPE=INNODB;

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
) TYPE=INNODB;

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
) TYPE=INNODB;

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
) TYPE=INNODB;


create table analysis
        (analys     integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
     adescribe  varchar(35),
         aconum     integer NOT NULL,
         ayrno      integer NOT NULL,
         index      co_ind8(aconum, ayrno),
         CONSTRAINT analysis_fk FOREIGN KEY (aconum, ayrno)
                    references accyear(aconum, ayearno)
) TYPE=INNODB;


create table bookref
    (
     bkref integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
     bkdesc varchar(90)
) TYPE=INNODB;

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
) TYPE=INNODB;

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
) TYPE=INNODB;

create table itemlocn
    (locn       integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
     locndesc   varchar(90) NOT NULL,
         larea      numeric(14,4),
         lconum     integer NOT NULL
) TYPE=INNODB;


create table itemsection
    (section    integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
     sdesc      varchar(90) NOT NULL,
         sconum     integer NOT NULL
) TYPE=INNODB;


create table itemgroup
    (igroup     integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
     igdesc     varchar(90) NOT NULL,
     igopval    decimal(20,4),
     igrcval    decimal(20,4),
     igisval    decimal(20,4),
         iconum     integer
) TYPE=INNODB;


create table itemunits
        (uname      integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
         udesc      varchar(35),
         uconv      char(3),
         ufactor    decimal(20,4) ,
         uconum     integer NOT NULL
) TYPE=INNODB;

create table itemsalestax
        (stype      integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
         sdesc      varchar(35),
         sperc      numeric(13,4) NOT NULL
                    check(SPERC >= 0),
         sconum     integer NOT NULL,
         syrno      integer NOT NULL
) TYPE=INNODB;


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
) TYPE=INNODB;

create index indexitemsgrp on items (igroup, icode);
create index indexabc on items (islval DESC);

create table warehouse
        (wnum       integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
         wdesc      varchar(90),
         waddress   varchar(90)
) TYPE=INNODB;

create table department
        (dnum       integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
         ddesc      varchar(90),
         daddress   varchar(90)
) TYPE=INNODB;

create table settlement
        (stype      integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
         sdesc      varchar(90),
         sperc      decimal(20,4) NOT NULL,
         sac_head   integer NOT NULL,
         INDEX        isettle(sac_head),
         ssales     decimal(20, 4),
         CONSTRAINT stlac_fk FOREIGN KEY (sac_head)
                    references chartacs (gac_head)
) TYPE=INNODB;


create table shop
        (shopnum    integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
         sdesc      varchar(90),
         saddress   varchar(90),
         sphone     varchar(90),
         sfax       varchar(90),
         smanager   varchar(90),
         ssales     decimal(20, 4)
) TYPE=INNODB;

create table cashregs
        (regnum     integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
         rdesc      varchar(90),
         rshop      integer NOT NULL,
         INDEX      icashregs_shop(rshop),
         rsales     decimal(20, 4),
         CONSTRAINT cr_fk FOREIGN KEY (rshop)
                 references shop(shopnum)
) TYPE=INNODB;

create table prefers
        (prefno     integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
         pdesc      varchar(90),
         pgender    varchar(1) default 'A',
         pconum     integer NOT NULL,
     CONSTRAINT prefgender_ck
                    check (pgender in ('M','F','T','C','A'))
) TYPE=INNODB;

create table originate
        (ono        integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
         owhere     varchar(90)
) TYPE=INNODB;

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
) TYPE=INNODB;


create table purchorder
        (ponum      integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
         podate     date ,
         powhouse   integer NOT NULL,
         INDEX         ipowhouse(powhouse),
         podept     integer NOT NULL,
         INDEX      ipodept(podept),
         poachead   integer,
         INDEX      ipoachead(poachead),
         posupp     integer NOT NULL,
         INDEX         iposupp(posupp),
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
) TYPE=INNODB;

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
         rrmake        varchar(50),
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
) TYPE=INNODB;


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
) TYPE=INNODB;

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
) TYPE=INNODB;

create table custprefs
        (cphone     integer NOT NULL PRIMARY KEY,
         cprefs     integer NOT NULL,
         INDEX      icustprefs(cprefs),
         cnotes     varchar(90),
         cconum     integer NOT NULL,
         CONSTRAINT custpref2_fk
                    FOREIGN KEY (cprefs) references prefers (prefno)
) TYPE=INNODB;

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
) TYPE=INNODB;

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
) TYPE=INNODB;


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
) TYPE=INNODB;

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
) TYPE=INNODB;

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
) TYPE=INNODB;

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
) TYPE=INNODB;


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
) TYPE=INNODB;


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

INSERT INTO itemstag (tagno, trrno, titem, tmake, tstax, tlocn, tsection, tuom, topqty, tsoldqty, tretqty, topval, tsprice1, tsprice2, tsprice3, tsprice4, tsprice5, trecdate, tissdate, tconum, tyrno, rtagged)
    SELECT CONCAT('SKU',icode), 0, icode, idesc, 1, 1, 1, 1, iopqty, 0, 0, iopqty*ipprice, isprice1, isprice1, isprice1, isprice1, isprice1, now(), now(), 1, 2005, 'Y' from items

INSERT INTO custprofile(custnum, cachead, cname, cconum)
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

# *************************************************************************
# END OF FILE
# *************************************************************************

