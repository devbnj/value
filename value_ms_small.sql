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

DROP TABLE custhistory;
DROP TABLE salescrnote;
DROP TABLE invoicelines;
DROP TABLE invoicesettlelines;
DROP TABLE invoice;
DROP TABLE salesorderlines;
DROP TABLE salesorder;
DROP TABLE custprefs;
DROP TABLE itemstag;
DROP TABLE issuesubcont;
DROP TABLE jobreturn;
DROP TABLE issuejob;
DROP TABLE purchdebitnote;
DROP TABLE receiving;
DROP TABLE purchorder;
DROP TABLE custprofile;
DROP TABLE originate;
DROP TABLE prefers;
DROP TABLE cashregs;
DROP TABLE shop;
DROP TABLE settlement;
DROP TABLE department;
DROP TABLE warehouse;
DROP TABLE items;
DROP TABLE jobs;
DROP TABLE itemsalestax;
DROP TABLE itemunits;
DROP TABLE itemgroup;
DROP TABLE itemsection;
DROP TABLE itemlocn;
DROP TABLE jourlines;
DROP TABLE journals;
DROP TABLE bookref;
DROP TABLE analysis;
DROP TABLE subledger;
DROP TABLE activity;
DROP TABLE activitygroup;
DROP TABLE chartacs;
DROP TABLE groupfile;
DROP TABLE grouper;
DROP TABLE pword;
DROP TABLE accyear;
DROP TABLE company;
DROP TABLE organization;

CREATE TABLE organization (
    organization_id integer NOT NULL PRIMARY KEY IDENTITY(1, 1),
    organization_name varchar (90) NOT NULL,
    org_type varchar(90) NOT NULL ,
    description varchar(254)
) ;


create table company
    (cconum   integer NOT NULL PRIMARY KEY,
     cconame  varchar(90),
     orgid    integer,
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
     ayearno    integer NOT NULL,
     ast_date   datetime NOT NULL ,
     aen_date   datetime NOT NULL ,
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
     table_owner    VARCHAR(50),
     role       VARCHAR(20),
     responsibility VARCHAR(20)
) ;

create table groupfile
    (rsubgrp    integer NOT NULL PRIMARY KEY,
     rdescribe  varchar(90),
     rdrbal     decimal(20,4) NOT NULL,
     rcrbal     decimal(20,4) NOT NULL,
     rconum     integer NOT NULL,
     ryrno      integer NOT NULL,
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
    (gac_head   integer NOT NULL PRIMARY KEY IDENTITY(1, 1),
     gdesc      varchar(90) NOT NULL,
     gopdr      decimal(20,4) NOT NULL,
     gopcr      decimal(20,4) NOT NULL,
     gdr    decimal(20,4) NOT NULL,
     gcr    decimal(20,4) NOT NULL,
     gbudgdr    decimal(20,4) ,
     gbudgcr    decimal(20,4) ,
     ggroup     integer NOT NULL,
     gsubyn     char(1),
     gsubgrp    integer NOT NULL,
     gconum     integer NOT NULL,
     gyrno      integer NOT NULL,
     gtype      varchar(3),
     CONSTRAINT subgrp_fk FOREIGN KEY
            (gsubgrp) references groupfile (rsubgrp) on delete cascade,
     CONSTRAINT chartacs_fk FOREIGN KEY (gac_head, gconum, gyrno)
            references accyear(aconum, ayearno) on delete cascade,
     CONSTRAINT ggroup_ck
            check (ggroup in (100,200,300,400,500)),
     CONSTRAINT gsubyn_ck
            check (gsubyn is null or gsubyn in ('Y', 'N'))
) ;

create table activitygroup
    (aggrp      integer NOT NULL PRIMARY KEY IDENTITY(1, 1),
     agdescribe varchar(90),
     agdrbal    decimal(20,4) ,
     agcrbal    decimal(20,4) ,
     agconum    integer NOT NULL,
     agyrno     integer NOT NULL,
     CONSTRAINT agroup_fk FOREIGN KEY (agconum, agyrno)
            references accyear(aconum, ayearno)
) ;

create table activity
    (accode    integer NOT NULL PRIMARY KEY IDENTITY(1, 1),
     adesc      varchar(90) NOT NULL,
     abudgdr    decimal(20,4) ,
     abudgcr    decimal(20,4) ,
     aopdr      decimal(20,4) ,
     aopcr      decimal(20,4) ,
     adr    decimal(20,4),
     acr    decimal(20,4),
     asubgrp    integer NOT NULL,
     aconum     integer NOT NULL,
     ayrno      integer NOT NULL,
     CONSTRAINT acgroup1_fk FOREIGN KEY
            (asubgrp) references activitygroup (aggrp),
     CONSTRAINT activity_fk FOREIGN KEY (aconum, ayrno)
            references accyear(aconum, ayearno)
) ;

create table subledger
    (sid    integer NOT NULL PRIMARY KEY IDENTITY(1, 1),
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
     sdr    decimal(20,4),
     scr    decimal(20,4),
     sac_head   integer NOT NULL,
     sconum     integer NOT NULL,
     syrno      integer NOT NULL,
     CONSTRAINT sac_fk
            FOREIGN KEY (sac_head) references chartacs (gac_head)
            on delete cascade,
     CONSTRAINT subledger_fk FOREIGN KEY (sconum, syrno)
            references accyear(aconum, ayearno)
) ;


create table analysis
    (analys     integer NOT NULL PRIMARY KEY IDENTITY(1, 1),
     adescribe  varchar(35),
     aconum     integer NOT NULL,
     ayrno      integer NOT NULL,
     CONSTRAINT analysis_fk FOREIGN KEY (aconum, ayrno)
            references accyear(aconum, ayearno)
) ;


create table bookref
    (
     bkref integer NOT NULL PRIMARY KEY IDENTITY(1, 1),
     bkdesc varchar(90)
) ;

create table journals
    (
     jrno       integer NOT NULL PRIMARY KEY IDENTITY(1, 1),
     jrefno     varchar(30),
     jdate      datetime NOT NULL,
     jcheck     varchar(30),
     jcheckdate datetime,
     jinvno     varchar(90),
     jidate     datetime ,
     jdelynote  varchar(90),
     jorder     integer,
     janalysis  integer,
     jactivity  integer,
     jdetails   varchar(90),
     jnarration varchar(90),
     jdr    decimal(20,4),
     jcr    decimal(20,4),
     jbkref     integer,
     jentryby   varchar(90),
     vmdfydate  datetime,
     vmdfyby    varchar(90),
     jconum     integer NOT NULL,
     jyrno      integer NOT NULL,
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
     jlrno      integer NOT NULL PRIMARY KEY IDENTITY(1, 1),
     jlsrno     integer NOT NULL,
     -- index      jr_ind1(jlsrno),
     jldate     datetime NOT NULL,
     jac_head   integer NOT NULL,
     -- index      ac_ind90(jac_head),
     jsubled    integer,
     -- index      sb_ind9(jsubled),
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
    (locn       integer NOT NULL PRIMARY KEY IDENTITY(1, 1),
     locndesc   varchar(90) NOT NULL,
     larea      numeric(14,4),
     lconum     integer NOT NULL
) ;


create table itemsection
    (section    integer NOT NULL PRIMARY KEY IDENTITY(1, 1),
     sdesc      varchar(90) NOT NULL,
     sconum     integer NOT NULL
) ;


create table itemgroup
    (igroup     integer NOT NULL PRIMARY KEY IDENTITY(1, 1),
     igdesc     varchar(90) NOT NULL,
     igopval    decimal(20,4),
     igrcval    decimal(20,4),
     igisval    decimal(20,4),
     iconum     integer
) ;


create table itemunits
    (uname      integer NOT NULL PRIMARY KEY IDENTITY(1, 1),
     udesc      varchar(35),
     uconv      char(3),
     ufactor    decimal(20,4) ,
     uconum     integer NOT NULL
) ;

create table itemsalestax
    (stype      integer NOT NULL PRIMARY KEY IDENTITY(1, 1),
     sdesc      varchar(35),
     sperc      numeric(13,4) NOT NULL
            check(SPERC >= 0),
     sconum     integer NOT NULL,
     syrno      integer NOT NULL
) ;


create table items
    (icode      integer NOT NULL PRIMARY KEY IDENTITY(1, 1),
     idesc      varchar(90) NOT NULL,
     igroup     integer NOT NULL,
     -- index      igroup_ind(igroup),
     iuom       integer NOT NULL,
     -- index      iuom_ind(iuom),
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
     -- index      isales_ind(isales),
     ipurch     integer NOT NULL,
     -- index      ipurch_ind(ipurch),
     istock     integer NOT NULL,
     -- index      istock_ind(istock),
     inetval    decimal (20,4),
     islrate    decimal (20,4),
     iaverate   decimal (20,4),
     iminstk    decimal (20,4),
     isafestk   decimal (20,4),
     irelvl     decimal (20,4),
     ieoq       decimal (20,4),
     ilrdate    datetime,
     ilidate    datetime,
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

create table warehouse
    (wnum       integer NOT NULL PRIMARY KEY IDENTITY(1, 1),
     wdesc      varchar(90),
     waddress   varchar(90)
) ;

create table department
    (dnum       integer NOT NULL PRIMARY KEY IDENTITY(1, 1),
     ddesc      varchar(90),
     daddress   varchar(90)
) ;

create table settlement
    (stype      integer NOT NULL PRIMARY KEY IDENTITY(1, 1),
     sdesc      varchar(90),
     sperc      decimal(20,4) NOT NULL,
     sac_head   integer NOT NULL,
     -- index    isettle(sac_head),
     ssales     decimal(20, 4),
     CONSTRAINT stlac_fk FOREIGN KEY (sac_head)
            references chartacs (gac_head)
) ;


create table shop
    (shopnum    integer NOT NULL PRIMARY KEY IDENTITY(1, 1),
     sdesc      varchar(90),
     saddress   varchar(90),
     sphone     varchar(90),
     sfax       varchar(90),
     smanager   varchar(90),
     ssales     decimal(20, 4)
) ;

create table cashregs
    (regnum     integer NOT NULL PRIMARY KEY IDENTITY(1, 1),
     rdesc      varchar(90),
     rshop      integer NOT NULL,
     -- index      icashregs_shop(rshop),
     rsales     decimal(20, 4),
     CONSTRAINT cr_fk FOREIGN KEY (rshop)
         references shop(shopnum)
) ;

create table prefers
    (prefno     integer NOT NULL PRIMARY KEY IDENTITY(1, 1),
     pdesc      varchar(90),
     pgender    varchar(1) default 'A',
     pconum     integer NOT NULL,
     CONSTRAINT prefgender_ck
            check (pgender in ('M','F','T','C','A'))
) ;

create table originate
    (ono    integer NOT NULL PRIMARY KEY IDENTITY(1, 1),
     owhere     varchar(90)
) ;

create table custprofile
    (custnum    integer NOT NULL PRIMARY KEY,
     cachead    integer,
     -- index      icustp(cachead),
     cname      varchar(80),
     cgender    varchar(1) default 'A',
     cspouse    varchar(80),
     cdob       datetime,
     canivers   datetime,
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
    (ponum      integer NOT NULL PRIMARY KEY IDENTITY(1, 1),
     podate     datetime ,
     powhouse   integer NOT NULL,
     -- index     ipowhouse(powhouse),
     podept     integer NOT NULL,
     -- index      ipodept(podept),
     poachead   integer,
     -- index      ipoachead(poachead),
     posupp     integer NOT NULL,
     -- index     iposupp(posupp),
     poactivity integer,
     -- index      ipoactivity(poactivity),
     podetail   varchar(90),
     poship     varchar(10),
     podueon    datetime ,
     poitem     integer NOT NULL,
     -- index      ipoitem(poitem),
     poqty      decimal(20,4),
     porate     decimal(20,4),
     poamt      decimal(20,4),
     pentrydate datetime ,
     pentryby   varchar(90),
     pmdfydate  datetime,
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
    (rrno       integer NOT NULL PRIMARY KEY IDENTITY(1, 1),
     rrpono     integer NOT NULL,
     -- index      irrpono(rrpono),
     rrpodate   datetime,
     rrwhouse   integer NOT NULL,
     rrdept     integer NOT NULL,
     rrdate     datetime ,
     rrpaydue   datetime,
     rrinvoice  integer,
     rrsupp     integer NOT NULL,
     rractivity integer,
     rrdetail   varchar(55),
     rrship     varchar(10),
     rentrydate datetime ,
     rentryby   varchar(90),
     rmdfydate  datetime,
     rmdfyby    varchar(90),
     rrtamt     decimal(20, 4),
     rritem     integer,
     rrmake    varchar(50),
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
     -- index      ipdnrrno(drrno),
     ddate      datetime ,
     drrdate    datetime,
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

create table itemstag
    (tagno      varchar(20) NOT NULL PRIMARY KEY,
     trrno      integer NOT NULL,
     -- index      itagrrno(trrno),
     titem      integer NOT NULL,
     tstax      integer NOT NULL,
     -- index      itagstax(tstax),
     tlocn      integer NOT NULL,
     -- index      itaglocn(tlocn),
     tsection   integer NOT NULL,
     -- index      itagsection(tsection),
     tuom       integer NOT NULL,
     -- index      itaguom(tuom),
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
     trecdate   datetime NOT NULL,
     tissdate   datetime,
     tretdate   datetime,
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
     -- index      icustprefs(cprefs),
     cnotes     varchar(90),
     cconum     integer NOT NULL,
     CONSTRAINT custpref2_fk
            FOREIGN KEY (cprefs) references prefers (prefno)
) ;

create table salesorder
    (sono       integer NOT NULL PRIMARY KEY IDENTITY(1, 1),
     sorigin    integer NOT NULL,
     -- index      isalesordori(sorigin),
     scust      integer NOT NULL,
     -- index      isalesordercust(scust),
     sdate      datetime,
     ssettle    integer NOT NULL,
     -- index      isalesorderset(ssettle),
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
    (sseq       integer NOT NULL PRIMARY KEY IDENTITY(1, 1),
     sono       integer NOT NULL,
     -- index      isalesorder(sono),
     scust      integer NOT NULL,
     sdate      datetime,
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
    (invno      integer NOT NULL PRIMARY KEY IDENTITY(1, 1),
     mcust      integer,
     -- index      iinvoicecust(mcust),
     msorder    integer,
     -- index      iinvorder(msorder),
     mdate      datetime NOT NULL,
     mcashadv   decimal(20,4) NOT NULL,
     mtamt      decimal(20,4),
     mnotes     varchar(90),
     mshopno    integer,
     -- index      iinvshop(mshopno),
     mregno     integer,
     -- index      iinvregno(mregno),
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
    (invseq     integer NOT NULL PRIMARY KEY IDENTITY(1, 1),
     invno      integer NOT NULL,
     -- index      iinvsettleno(invno),
     mprefs     integer,
     msettle    integer,
     -- index      iinvsettletype(msettle),
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
    (invseq     integer NOT NULL PRIMARY KEY IDENTITY(1, 1),
     invno      integer NOT NULL,
     -- index      iinvlinesno(invno),
     mtagno     varchar(20),
     -- index      iinvlinestag(mtagno),
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
     -- index      icrnoteinv(cinvno),
     cseqno     integer NOT NULL,
     cmemdate   datetime,
     cdate      datetime ,
     ccust      integer,
     cltagno    integer,
     clqty      decimal(20, 4),
     clrate     decimal(20, 4),
     clamt      decimal(20, 4),
     cltax      decimal(20, 4),
     cldisc     decimal(20, 4),
     clgross    decimal(20, 4),
     centrydate datetime ,
     centryby   varchar(90) NOT NULL,
     cconum     integer NOT NULL,
     cyrno      integer NOT NULL,
     CONSTRAINT crnote1_fk FOREIGN KEY (cinvno)
            references invoice (invno)
) ;


create table custhistory
    (cphone     integer NOT NULL,
     cinvno     integer NOT NULL,
     cdate      datetime,
     camt       decimal(20, 4),
     centrydate datetime NOT NULL,
     centryby   varchar(90) NOT NULL,
     cconum     integer NOT NULL,
     CONSTRAINT chist_pk
            PRIMARY KEY (cphone, cinvno),
     CONSTRAINT chist1_fk
            FOREIGN KEY (cphone) references custprofile (custnum)
) ;


# ------ Test Data --------

ALTER TABLE [organization] NOCHECK CONSTRAINT ALL
SET IDENTITY_INSERT [organization] ON
INSERT INTO organization (organization_id,organization_name,org_type) VALUES (1,'ABC Group of Companies','Limited Liability');
SET IDENTITY_INSERT [organization] OFF
ALTER TABLE [organization] CHECK CONSTRAINT ALL

INSERT INTO company (cconum, cconame,ccoshort, orgid) VALUES
       (1, 'ABC Consulting', 'ABC', 1);

INSERT INTO accyear (aconum, ayearno, ast_date, aen_date) VALUES
     (1, 2005, '2005-01-01', '2005-12-31');
INSERT INTO accyear (aconum, ayearno, ast_date, aen_date) VALUES
     (1, 2006, '2006-01-01', '2006-12-31');

ALTER TABLE [groupfile] NOCHECK CONSTRAINT ALL
    insert into groupfile
        (rconum, ryrno, rsubgrp, rdescribe, rdrbal, rcrbal) values
        (1, 2005,100,'Liability',0,0);
    insert into groupfile
        (rconum, ryrno, rsubgrp, rdescribe, rdrbal, rcrbal) values
        (1, 2005,105,'Capital',0,0);
    insert into groupfile
        (rconum, ryrno, rsubgrp, rdescribe, rdrbal, rcrbal) values
        (1, 2005,110,'Loans and Advances',0,0);
    insert into groupfile
        (rconum, ryrno, rsubgrp, rdescribe, rdrbal, rcrbal) values
        (1, 2005,115,'Deposits',0,0);
    insert into groupfile
        (rconum, ryrno, rsubgrp, rdescribe, rdrbal, rcrbal) values
        (1, 2005,120,'Accounts Payable',0,0);
    insert into groupfile
        (rconum, ryrno, rsubgrp, rdescribe, rdrbal, rcrbal) values
        (1, 2005,125,'Reserves',0,0);
    insert into groupfile
        (rconum, ryrno, rsubgrp, rdescribe, rdrbal, rcrbal) values
        (1, 2005,195,'Current Liability',0,0);
    insert into groupfile
        (rconum, ryrno, rsubgrp, rdescribe, rdrbal, rcrbal) values
        (1, 2005,196,'Profit and Loss',0,0);
    insert into groupfile
        (rconum, ryrno, rsubgrp, rdescribe, rdrbal, rcrbal) values
        (1, 2005,200,'Assets',0,0);
    insert into groupfile
        (rconum, ryrno, rsubgrp, rdescribe, rdrbal, rcrbal) values
        (1, 2005,205,'Fixed Assets',0,0);
    insert into groupfile
        (rconum, ryrno, rsubgrp, rdescribe, rdrbal, rcrbal) values
        (1, 2005,206,'Depreciation',0,0);
    insert into groupfile
        (rconum, ryrno, rsubgrp, rdescribe, rdrbal, rcrbal) values
        (1, 2005,210,'Loans and Advances',0,0);
    insert into groupfile
        (rconum, ryrno, rsubgrp, rdescribe, rdrbal, rcrbal) values
        (1, 2005,211,'Payments Due',0,0);
    insert into groupfile
        (rconum, ryrno, rsubgrp, rdescribe, rdrbal, rcrbal) values
        (1, 2005,215,'Cash in Hand',0,0);
    insert into groupfile
        (rconum, ryrno, rsubgrp, rdescribe, rdrbal, rcrbal) values
        (1, 2005,220,'Stock',0,0);
    insert into groupfile
        (rconum, ryrno, rsubgrp, rdescribe, rdrbal, rcrbal) values
        (1, 2005,225,'Deposits',0,0);
    insert into groupfile
        (rconum, ryrno, rsubgrp, rdescribe, rdrbal, rcrbal) values
        (1, 2005,230,'Accounts Receivable',0,0);
    insert into groupfile
        (rconum, ryrno, rsubgrp, rdescribe, rdrbal, rcrbal) values
        (1, 2005,295,'Current Assets',0,0);
    insert into groupfile
        (rconum, ryrno, rsubgrp, rdescribe, rdrbal, rcrbal) values
        (1, 2005,300,'Income',0,0);
    insert into groupfile
        (rconum, ryrno, rsubgrp, rdescribe, rdrbal, rcrbal) values
        (1, 2005,305,'Sales',0,0);
    insert into groupfile
        (rconum, ryrno, rsubgrp, rdescribe, rdrbal, rcrbal) values
        (1, 2005,310,'Other Income',0,0);
    insert into groupfile
        (rconum, ryrno, rsubgrp, rdescribe, rdrbal, rcrbal) values
        (1, 2005,400,'Expenditure',0,0);
    insert into groupfile
        (rconum, ryrno, rsubgrp, rdescribe, rdrbal, rcrbal) values
        (1, 2005,405,'Purchase',0,0);
    insert into groupfile
        (rconum, ryrno, rsubgrp, rdescribe, rdrbal, rcrbal) values
        (1, 2005,410,'Other Expense',0,0);
    insert into groupfile
        (rconum, ryrno, rsubgrp, rdescribe, rdrbal, rcrbal) values
        (1, 2005,500,'Contras',0,0);
ALTER TABLE [groupfile] CHECK CONSTRAINT ALL

ALTER TABLE [chartacs] NOCHECK CONSTRAINT ALL
SET IDENTITY_INSERT [chartacs] ON
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (1, 1, 2005,'Accounting Charges',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (2, 1, 2005,'Accounts Payable',0,0,0,0,100,'Y','PRV',120);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (3, 1, 2005,'Accounts Receivable',0,0,0,0,200,'Y','SLV',230);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (4, 1, 2005,'Advances from Customers',900,0,0,0,100,'N',null,110);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (5, 1, 2005,'Advances Given',0,1000,0,0,200,'Y',null,210);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (6, 1, 2005,'Advances Received',0,0,0,0,100,'N',null,110);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (7, 1, 2005,'Advertisement',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (8, 1, 2005,'Audit Fees',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (9, 1, 2005,'Bad Debts',0,0,0,0,200,'N',null,230);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (10, 1, 2005,'Bank Account',10000,0,0,0,200,'N','BBV',215);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (11, 1, 2005,'Bank Charges',0,0,0,0,400,'N',null,400);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (12, 1, 2005,'Bonus and Staff Welfare',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (13, 1, 2005,'Books and Periodicals',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (14, 1, 2005,'Capital Account',0,9900,0,0,100,'N',null,105);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (15, 1, 2005,'Carriage Inwards',0,0,0,0,400,'N','PRP',405);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (16, 1, 2005,'Cash Balance',0,0,0,0,200,'N','CBV',215);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (17, 1, 2005,'Cheques In Hand',0,0,0,0,200,'N','BBV',215);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (18, 1, 2005,'Closing Stock',0,0,0,0,200,'N',null,205);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (19, 1, 2005,'Commision Earned',0,0,0,0,300,'N',null,310);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (20, 1, 2005,'Commission Paid',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (21, 1, 2005,'Computer',0,0,0,0,200,'N',null,205);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (22, 1, 2005,'Contra',0,0,0,0,500,'N',null,500);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (23, 1, 2005,'Credit Cards',0,0,0,0,200,'N','CBV',215);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (24, 1, 2005,'Deposits Given',0,0,0,0,200,'N',null,225);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (25, 1, 2005,'Deposits Received',0,0,0,0,100,'N',null,210);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (26, 1, 2005,'Depreciation',0,0,0,0,400,'N',null,206);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (27, 1, 2005,'Electricity Charges',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (28, 1, 2005,'Entertainment',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (29, 1, 2005,'ExGratia',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (30, 1, 2005,'Exports',0,0,0,0,300,'N','SBP',305);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (31, 1, 2005,'Factory Expenses',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (32, 1, 2005,'Fax Expenses',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (33, 1, 2005,'Fees',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (34, 1, 2005,'Freight Expenses',0,0,0,0,400,'N','SBP',305);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (35, 1, 2005,'Fuel Expenses',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (36, 1, 2005,'General Reserves',0,0,0,0,100,'N',null,125);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (37, 1, 2005,'Goodwill',0,0,0,0,100,'N',null,195);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (38, 1, 2005,'Incentives',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (39, 1, 2005,'Income Tax',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (40, 1, 2005,'Insurance',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (41, 1, 2005,'Legal Expenses',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (42, 1, 2005,'Medical Expenses',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (43, 1, 2005,'Car Expenses',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (44, 1, 2005,'Office Expenses',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (45, 1, 2005,'Office Maintenance',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (46, 1, 2005,'Opening Stock',0,0,0,0,200,'N',null,205);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (47, 1, 2005,'Other Revenue',0,0,0,0,300,'N',null,310);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (48, 1, 2005,'Postage',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (49, 1, 2005,'Preliminary Expenses',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (50, 1, 2005,'Printing and Stationary',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (51, 1, 2005,'Profit and Loss',0,0,0,0,100,'N',null,196);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (52, 1, 2005,'Purchase',0,0,0,0,400,'N','PRP',405);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (53, 1, 2005,'Purchase Returns',0,0,0,0,400,'N','PRP',405);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (54, 1, 2005,'Remunerations',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (55, 1, 2005,'Rent',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (56, 1, 2005,'Salaries Due',0,0,0,0,100,'N',null,211);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (57, 1, 2005,'Salary',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (58, 1, 2005,'Sales',0,0,0,0,300,'N','SBP',305);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (59, 1, 2005,'Selling Expenses',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (60, 1, 2005,'Service Charges Paid',0,0,0,0,400,'N','PRP',405);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (61, 1, 2005,'Service Charges Received',0,0,0,0,300,'N','SBP',305);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (62, 1, 2005,'Share Account',0,0,0,0,100,'N',null,105);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (63, 1, 2005,'Shipping Expenses',0,0,0,0,400,'N','SBP',305);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (64, 1, 2005,'Stock In Trade',0,0,0,0,200,'N',null,205);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (65, 1, 2005,'Subscriptions',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (66, 1, 2005,'Sundry Expenses',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (67, 1, 2005,'Telephone Expenses',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (68, 1, 2005,'Trading Fees',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (69, 1, 2005,'Transfer of Funds',0,0,0,0,500,'N',null,500);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (70, 1, 2005,'Traveling',0,0,0,0,400,'N',null,410);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (71, 1, 2005,'Work in Progress',0,0,0,0,200,'N',null,295);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (72, 1, 2005,'Visa',0,0,0,0,200,'N','BBV',215);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (73, 1, 2005,'MasterCard',0,0,0,0,200,'N','BBV',215);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (74, 1, 2005,'American Express',0,0,0,0,200,'N','BBV',215);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (75, 1, 2005,'Discover',0,0,0,0,200,'N','BBV',215);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (76, 1, 2005,'Diners',0,0,0,0,200,'N','BBV',215);
    insert into chartacs
	(gac_head, gconum, gyrno,  gdesc,  gopdr, gopcr, gdr, gcr, ggroup, gsubyn, gtype, gsubgrp)
	values
        (77, 1, 2005,'ShopCard',0,0,0,0,200,'N','BBV',215);
SET IDENTITY_INSERT [chartacs] OFF
ALTER TABLE [chartacs] CHECK CONSTRAINT ALL


ALTER TABLE [subledger] NOCHECK CONSTRAINT ALL
SET IDENTITY_INSERT [subledger] ON
-- sub ledger -- creditors
insert into subledger (sid, sconum, syrno, sdesc, sac_head) values
       (1, 1,2005,'Matrox',2);
insert into subledger (sid, sconum, syrno, sdesc, sac_head) values
       (2, 1,2005,'Microsoft',2);
insert into subledger (sid, sconum, syrno, sdesc, sac_head) values
       (3, 1,2005,'Warner',2);
insert into subledger (sid, sconum, syrno, sdesc, sac_head) values
       (4, 1,2005,'Warner',2);
insert into subledger (sid, sconum, syrno, sdesc, sac_head) values
       (5, 1,2005,'Fox',2);
insert into subledger (sid, sconum, syrno, sdesc, sac_head) values
       (6, 1,2005,'Canon',2);
insert into subledger (sid, sconum, syrno, sdesc, sac_head) values
       (7, 1,2005,'Sierra',2);
insert into subledger (sid, sconum, syrno, sdesc, sac_head) values
       (8, 1,2005,'GT Interactive',2);
insert into subledger (sid, sconum, syrno, sdesc, sac_head) values
       (9, 1,2005,'Hewlett Packard',2);
-- sub ledger -- debtors
insert into subledger (sid, sconum, syrno, sdesc, sac_head) values
       (10, 1,2005,'Cotorolla',3);
insert into subledger (sid, sconum, syrno, sdesc, sac_head) values
       (11, 1,2005,'Xicrosoft',3);
insert into subledger (sid, sconum, syrno, sdesc, sac_head) values
       (12, 1,2005,'SunMoon Systems',3);
insert into subledger (sid, sconum, syrno, sdesc, sac_head) values
       (13, 1,2005,'Generally Electric',3);
insert into subledger (sid, sconum, syrno, sdesc, sac_head) values
       (14, 1,2005,'Joe Holland',3);
insert into subledger (sid, sconum, syrno, sdesc, sac_head) values
       (15, 1,2005,'Sabir Shah',3);
insert into subledger (sid, sconum, syrno, sdesc, sac_head) values
       (16, 1,2005,'Jill Disposed',3);
insert into subledger (sid, sconum, syrno, sdesc, sac_head) values
       (17, 1,2005,'Sue Maryland',3);
SET IDENTITY_INSERT [subledger] OFF
ALTER TABLE [subledger] CHECK CONSTRAINT ALL

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

INSERT INTO itemstag (tagno, trrno, titem, tmake, tstax, tlocn, tsection, tuom, topqty, tsoldqty, tretqty, topval, tsprice1, tsprice2, tsprice3, tsprice4, tsprice5, trecdatetime, tissdatetime, tconum, tyrno, rtagged)
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

