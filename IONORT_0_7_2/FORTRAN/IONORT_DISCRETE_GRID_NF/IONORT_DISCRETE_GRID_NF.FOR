      PROGRAM NITIAL                                                    NITI001
C          SETS THE INITIAL CONDITIONS FOR EACH RAY AND CALLS TRACE     NITI002
      DIMENSION MFLD(2)                                                 NITI003
      COMMON /CONST/ PI,PIT2,PID2,DEGS,RAD,K,C,LOGTEN                   NITI004
      COMMON /FLG/ NTYP,PENET,IHOP,HPUNCH                               NITI005
      COMMON /RIN/ MODRIN(3),COLL,FIELD,SPACE,ZZN,N2I,PNP(10),POLAR,    NITI006
     1             LPOLAR,SGN                                           NITI007
      COMMON /RK/ N,STEP,MODE,E1MAX,E1MIN,E2MAX,E2MIN,FACT,RSTART       NITI008
      COMMON /XX/ MODX(2),X,PXPR,PXPTH,PXPPH,PXPT,HMAX                  NITI009
      COMMON /YY/ MODY,Y(16) /ZZ/ MODZ,Z(4)                             NITI010
      COMMON R(20),T,STP,DRDT(20),N2                                    NITI011
      COMMON /WW/ ID,W0,W(400)                                          
      EQUIVALENCE (RAY,W(1)),(EARTHR,W(2)),(XMTRH,W(3)),(TLAT,W(4)),    NITI012
     1 (TLON,W(5)),(F,W(6)),(FBEG,W(7)),(FEND,W(8)),(FSTEP,W(9)),       NITI013
     2 (AZ1,W(10)),(AZBEG,W(11)),(AZEND,W(12)),(AZSTEP,W(13)),          NITI014
     3 (BETA,W(14)),(ELBEG,W(15)),(ELEND,W(16)),(ELSTEP,W(17)),         NITI015
     4 (ONLY,W(21)),(HOP,W(22)),(MAXSTP,W(23)),(PLAT,W(24)),(PLON,W(25))NITI016
     5,(MDE,W(26)),(INTYP,W(41)),(MAXERR,W(42)),(ERATIO,W(43)),         NITI017
     6 (STEP1,W(44)),(STPMAX,W(45)),(STPMIN,W(46)),(FACTR,W(47))        NITI018
C                                                                       NITI019
      LOGICAL SPACE,PENET                                               NITI020
      REAL N2,N2I,LOGTEN,K,MAXSTP,INTYP,MAXERR,MU                       NITI021
      COMPLEX PNP,POLAR,LPOLAR                                          NITI022
C***********************************************************************
      OPEN(6,FILE='DATA_OUT.txt',STATUS='unknown')                      
      ID=4H X00                                                         NITI023
      NDATE=4H21OT                                                      NITI024
      WRITE(6,999) ID,NDATE                                             NITI025
  999 FORMAT (A4,1X,A4,/)                                               NITI026
      KOLL=4H  NO                                                       NITI027
      IF (COLL.NE.0.) KOLL=4HWITH                                       NITI028
C********* CONSTANTS                                                    NITI029
      PI=3.1415926536                                                   NITI030
      PIT2=2.*PI                                                        NITI031
      PID2=PI/2.                                                        NITI032
      DEGS=180./PI                                                      NITI033
      RAD=PI/180.                                                       NITI034
      C=2.997925E5                                                      NITI035
      K=2.81785E-15*C**2/PI                                             NITI036
      LOGTEN=ALOG(10.)                                                  NITI037
C********* INITIALIZE SOME VARIABLES IN THE W ARRAY                     NITI038
      DO 5 NW=1,400                                                     NITI039
    5 W(NW)=0.                                                          NITI040
      PLON=0.                                                           NITI041
      PLAT=PID2                                                         NITI042
      EARTHR=6371.                                                      NITI043
      INTYP=3.                                                          NITI044
      MAXERR=1.E-4                                                      NITI045
      ERATIO=50.                                                        NITI046
      STEP1=1.                                                          NITI047
      STPMAX=100.                                                       NITI048
      STPMIN=1.E-8                                                      NITI049
      FACTR=0.5                                                         NITI050
      MAXSTP=1000.                                                      NITI051
      HOP=1.                                                            NITI052
C********* READ W ARRAY AND WRITE NON-ZERO VALUES                       NITI053
      CALL READW                                                        NITI054
      IF (SKIP.EQ.0.) SKIP=MAXSTP                                       NITI056
   12 RAY=SIGN(1.,RAY)                                                  NITI057
      NTYP=2.+FIELD*RAY                                                 NITI058
      GO TO (13,14,15), NTYP                                            NITI059
   13 MFLD(1)=4HEXTR                                                    NITI060
      MFLD(2)=4HORDI                                                    NITI061
      GO TO 16                                                          NITI062
   14 MFLD(1)=4HNO F                                                    NITI063
      MFLD(2)=4H----                                                    NITI064
      GO TO 16                                                          NITI065
   15 MFLD(1)=4HORDI                                                    NITI066
      MFLD(2)=4H----                                                    NITI067
   16 MODSAV=MODX(2)                                                    NITI068
      IF (PERT.EQ.0.) MODX(2)=4H  NO                                    NITI069
C    
      WRITE(6,1050)                                                     NITI077
 1050 FORMAT (85H INITIAL VALUES FOR THE W ARRAY -- ALL ANGLES IN RADIANNITI078
     1S, ONLY NONZERO VALUES PRINTED/)                                  NITI079
      DO 17 NW=1,400                                                    NITI080
      IF (W(NW).NE.0.) WRITE(6,1700) NW,W(NW)                           NITI081
 1700 FORMAT (I4,E20.10,/)                                              NITI082
   17 CONTINUE                                                          NITI083
C********* INITIALIZE PARAMETERS FOR INTEGRATION SUBROUTINE RKAM        NITI087
      N=6                                                               NITI088
      DO 20 NR=7,20                                                     NITI089
      IF (W(50+NR).NE.0.) N=N+1                                         NITI090
   20 CONTINUE                                                          NITI091
      MODE=INTYP                                                        NITI092
      STEP=STEP1                                                        NITI093
      E1MAX=MAXERR                                                      NITI094
      E1MIN=MAXERR/ERATIO                                               NITI095
      E2MAX=STPMAX                                                      NITI096
      E2MIN=STPMIN                                                      NITI097
      FACT=FACTR                                                        NITI098
C********* DETERMINE TRANSMITTER LOCATION IN COMPUTATIONAL COORDINATE   NITI099
C********* SYSTEM (GEOMAGNETIC COORDINATES IF DIPOLE FIELD IS USED)     NITI100
      R0=EARTHR+XMTRH                                                   NITI101
      SP=SIN (PLAT)                                                     NITI102
      CP=SIN (PID2-PLAT)                                                NITI103
      SDPH=SIN (TLON-PLON)                                              NITI104
      CDPH=SIN (PID2-(TLON-PLON))                                       NITI105
      SL=SIN (TLAT)                                                     NITI106
      CL=SIN (PID2-TLAT)                                                NITI107
      ALPHA=ATAN2(-SDPH*CP,-CDPH*CP*SL+SP*CL)                           NITI108
      TH0=ACOS (CDPH*CP*CL+SP*SL)                                       NITI109
      PH0=ATAN2(SDPH*CL,CDPH*SP*CL-CP*SL)                               NITI110
C********* LOOP ON FREQUENCY, AZIMUTH ANGLE, AND ELEVATION ANGLE        NITI111
      NFREQ=1                                                           NITI112
      IF (FSTEP.NE.0.) NFREQ=(FEND-FBEG)/FSTEP+1.5                      NITI113
      NAZ=1                                                             NITI114
      IF (AZSTEP.NE.0.) NAZ=(AZEND-AZBEG)/AZSTEP+1.5                    NITI115
      NBETA=1                                                           NITI116
      IF (ELSTEP.NE.0.) NBETA=(ELEND-ELBEG)/ELSTEP+1.5                  NITI117
      DO 50 NF=1,NFREQ                                                  NITI118
      F=FBEG+(NF-1)*FSTEP                                               NITI119
      DO 45 J=1,NAZ                                                     NITI120
      AZ1=AZBEG+(J-1)*AZSTEP                                            NITI121
      AZA=AZ1*DEGS                                                      NITI122
      GAMMA=PI-AZ1+ALPHA                                                NITI123
      SGAMMA=SIN (GAMMA)                                                NITI124
      CGAMMA=SIN (PID2-GAMMA)                                           NITI125
      DO 40 I=1,NBETA                                                   NITI126
      BETA=ELBEG+(I-1)*ELSTEP                                           NITI127
      EL=BETA*DEGS                                                      NITI128
      CBETA=SIN (PID2-BETA)                                             NITI129
      R(1)=R0                                                           NITI130
      R(2)=TH0                                                          NITI131
      R(3)=PH0                                                          NITI132
      R(4)=SIN (BETA)                                                   NITI133
      R(5)=CBETA*CGAMMA                                                 NITI134
      R(6)=CBETA*SGAMMA                                                 NITI135
      T=0.                                                              NITI136
      RSTART=1.                                                         NITI137
C     SGN=1.  (NEED FOR RAY TRACING IN COMPLEX SPACE.)                  NITI138
C********* ALLOW IONOSPHERIC MODEL SUBROUTINES TO READ AND WRITE DATA   NITI139
      CALL RINDEX                                                       NITI140
      WRITE(6,1000) MODX(1),MODX(2),MFLD(1)                             NITI143
     1,KOLL,MODRIN(1),MODRIN(2),MODRIN(3)                               
 1000 FORMAT (/,1X,A4,1X,8HPROFILES,1X,A4,1X,12HPERTURBATION            
     1,1X,A4,1X,A4,11H COLLISIONS,/,3(1X,8A))                           
      WRITE(6,2400) F,AZA                                               NITI144
 2400 FORMAT (1X,33HFREQUENCY                       =,F10.5,4H MHZ,/    NITI145
     1,1X,33HAZIMUTH ANGLE OF TRANSMISSION   =,F10.5,4H DEG)            NITI146
      WRITE(6,2500) EL                                                  NITI148
 2500 FORMAT (1X,33HELEVATION ANGLE OF TRANSMISSION =,F10.5,4H DEG/)    NITI149
      IF (N2.GT.0.) GO TO 30                                            NITI150
      CALL ELECTX                                                       NITI151
      FN=SIGN (SQRT (ABS (X))*F,X)                                      NITI152
     
C*******************************************************************************
      PRINT 2900,FN                                                             SET
 2900 FORMAT (6H 333.3,18X,F20.10,9X,3H 3 )                                     SET
      WRITE(6,2901) FN                                                  NITI153
 2901 FORMAT (33H TRANSMITTER IN EVANESCENT REGION,':',/                NITI154
     1,24H TRANSMISSION IMPOSSIBLE,',',/                                NITI155
     2,20H PLASMA FREQUENCY = ,E20.10,4H MHz,'.')                       NITI155
C*******************************************************************************
     
C*******************************************************************************
      CALL ZERO                                                                 AZZ
C*******************************************************************************
          
      GO TO 45                                                          NITI156
   30 MU=SQRT (N2/(R(4)**2+R(5)**2+R(6)**2))                            NITI157
      DO 34 NN=4,6                                                      NITI158
   34 R(NN)=R(NN)*MU                                                    NITI159
      DO 35 NN=7,N                                                      NITI160
   35 R(NN)=0.                                                          NITI161
      CALL TRACE                                                        NITI162
C*****CALCOLO DEL RITARDO DI GRUPPO****                                 NITI163
      C_km_ms=C/1000.0                                                  NITI164
      GRPDELAY=T/C_km_ms                                                NITI165
      PRINT 3501,GRPDELAY                                                       AZZ
 3501 FORMAT (6H 333.3,18X,F20.10,9X,3H 1 )                                     AZZ
      WRITE (6,3502) GRPDELAY                                           NITI166A
 3502 FORMAT (15H GROUP DELAY IS,5X,F20.10,4H  ms)                      NITI167A
      PRINT 3503,T                                                              AZZ
 3503 FORMAT (6H 333.3,18X,F20.10,9X,3H 2 )                                     AZZ
      WRITE (6,3504) T                                                  NITI166B
 3504 FORMAT (15H GROUP PATH  IS,5X,F20.10,4H  km)                      NITI167B
      IF (PENET.AND.ONLY.NE.0..AND.IHOP.EQ.1) GO TO 45                  NITI168
     
C*******************************************************************************
      CALL ZERO                                                                 AZZ
C*******************************************************************************
     
   40 CONTINUE                                                          NITI169
   45 CONTINUE                                                          NITI171
      IF(PENET.AND.ONLY.NE.0..AND.IHOP.EQ.1.AND.NAZ.EQ.1.AND.NBETA.EQ.1)NITI172
     1 GO TO 55                                                         NITI173
   50 CONTINUE                                                          NITI174
   55 WRITE(6,*)'THE END'                                               NITI175
      END                                                               NITI176-
C     ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C     +++                          NITI END                          +++
C     ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      SUBROUTINE READW                                                  READ001
      COMMON /CONST/ PI,PIT2,PID2,DEGS,RAD,K,C,LOGTEN                   READ002
      COMMON /WW/ ID,W0,W(400)                                          READ003
      EQUIVALENCE (EARTHR,W(2))                                         READ004
      OPEN(5,FILE='DATA_IN.txt',STATUS='unknown')                       READ005
      DO NW=1,400                                                       READ006
      READ (5,*,END=10001) W(NW)                                        READ007
10001 IF (NW.EQ.400.AND.NW.GT.400) GO TO 10                             READ008
      ENDDO                                                             READ009
   10 RETURN                                                            READ010
         END                                                            READ011-
C ******************************************************************************
C     ALEX: Lettura file 'GRIDPROFILES.txt',                            
C           scrittura file 'GRIDPROFILES_TEST.txt',                     
C           inizializzazione matrice per "plasma frequency profiles" FNC(K,J,I) 
C ******************************************************************************
      SUBROUTINE GRIDPROFILES                                           GPROF000
C ******************************************************************************
      COMMON /ALEX1/ NLAT,NLON,LAT(10),LON(25)                          GPROF000
      COMMON /ALEX2/ NOC,HPC(600),FNC(600,10,25)                        GPROF000
      SAVE /ALEX1/,/ALEX2/                                              GPROF000
      CHARACTER LINE1*18,LINE2*43,LINE3*44,LINEa*24,LINEb*16            GPROF000
C ******************************************************************************
      LATINF=31.0                                                       GPROF000
      LATSUP=49.0                                                       GPROF000
      LATSTEP=2.0                                                       GPROF000
      NLAT=1+(LATSUP-LATINF)/LATSTEP                                    GPROF000
      LONINF=-9.0                                                       GPROF000
      LONSUP=39.0                                                       GPROF000
      LONSTEP=2.0                                                       GPROF000
      NLON=1+(LONSUP-LONINF)/LONSTEP                                    GPROF000
      HINF=1.0                                                          GPROF000
      HSUP=600.0                                                        GPROF000
      HSTEP=1.0                                                         GPROF000
      NOC=1+(HSUP-HINF)/HSTEP                                           GPROF000
      OPEN(9,FILE='GRIDPROFILES.txt',STATUS='unknown')                  GPROF000
      OPEN(10,FILE='GRIDPROFILES_TEST.txt',STATUS='unknown')            GPROF000
      READ(9,1) LINE1                                                   GPROF000
C      PRINT 1,LINE1                                                     GPROF000
      WRITE(10,1) LINE1                                                 GPROF000
    1 FORMAT(A18)                                                       GPROF000
      READ(9,2) LINE2                                                   GPROF000
C      PRINT 2,LINE2                                                     GPROF000
      WRITE(10,2) LINE2                                                 GPROF000
    2 FORMAT(A43)                                                       GPROF000
      READ(9,3) LINE3                                                   GPROF000
C      PRINT 3,LINE3                                                     GPROF000
      WRITE(10,3) LINE3                                                 GPROF000
    3 FORMAT(A44)                                                       GPROF000 
      DO 10 I=1,NLON                                                    GPROF000
      LON(I)=LONINF+LONSTEP*(I-1)                                       GPROF000
      DO 9 J=1,NLAT                                                     GPROF000
      LAT(J)=LATINF+LATSTEP*(J-1)                                       GPROF000
      READ(9,4) LINEa                                                   GPROF000
C      PRINT 4,LINEa                                                     GPROF000
      WRITE(10,4) LINEa                                                 GPROF000
    4 FORMAT(A24)                                                       GPROF000
      READ(9,5) LINEb                                                   GPROF000
C      PRINT 5,LINEb                                                     GPROF000
      WRITE(10,5) LINEb                                                 GPROF000
    5 FORMAT(A16)                                                       GPROF000
      DO 8 K=1,NOC                                                      GPROF000
C      HPC(K)=HINF+HSTEP*(K-1)                                          GPROF000
      READ(9,*,END=6) HPC(K),FNC(K,J,I)                                 GPROF000
C    6 PRINT 7, HPC(K),FNC(K,J,I)                                        GPROF000
    6 WRITE(10,7) HPC(K),FNC(K,J,I)                                     GPROF000
    7 FORMAT(F5.1,3X,F5.2)                                              GPROF000
    8 CONTINUE                                                          GPROF000
    9 CONTINUE                                                          GPROF000
   10 CONTINUE                                                          GPROF000
      CLOSE(9)                                                          GPROF000
      CLOSE(10)                                                         GPROF000
      RETURN                                                            GPROF000
      END                                                               -
      SUBROUTINE TRACE                                                  TRAC001
C     CALCULATES THE RAY PATH                                           TRAC002
      DIMENSION ROLD(20),DROLD(20)                                      TRAC003
      COMMON /RK/ N,STEP,MODE,E1MAX,E1MIN,E2MAX,E2MIN,FACT,RSTART       TRAC004
      COMMON /FLG/ NTYP,PENET,IHOP,HPUNCH                               TRAC005
      COMMON /TRAC/ GROUND,PERIGE,THERE,MINDIS,NEWRAY,SMT               TRAC006
      COMMON /RIN/ MODRIN(3),COLL,FIELD,SPACE,ZZN,PNP(10),POLAR,LPOLAR  TRAC007
      COMMON /XX/ MODX(2),X,PXPR,PXPTH,PXPPH,PXPT,HMAX                  TRAC008
      COMMON R(20),T,STP,DRDT(20),N2                                    TRAC009
      COMMON /WW/ ID,W0,W(400)                                          
      LOGICAL SPACE,HOME,WASNT,GROUND,PERIGE,THERE,MINDIS,PENET,NEWRAY, TRAC010
     1WAS                                                               TRAC011
      REAL MAXSTP                                                       TRAC012
      COMPLEX N2,PNP,POLAR,LPOLAR                                       TRAC013
      EQUIVALENCE (EARTHR,W(2)),(RCVRH,W(20)),(HOP,W(22)),(MAXSTP,W(23))TRAC014
     
C*******************************************************************************
C     ALEX: Per ogni iterazione di raytracing,                          
C           è stato necessario introdurre                               
C           una variabile logica di controllo                           
C           che forzasse, una ed una sola volta, la stampa              
C           su file dell'input '+++ RAY OUT THE IONOSPHERE +++'         
C           e da schermo della coordinata speciale '111.1 0 3'.         
C*******************************************************************************
      LOGICAL OUT                                                       
C      IF (NEWRAY) OUT=.FALSE.                                           
      OUT=.FALSE.                                                       
C*******************************************************************************
     
      NHOP=HOP                                                          TRAC016
      MAX=MAXSTP                                                        TRAC017
C                                                                       TRAC018
      RSTART=1.                                                         TRAC019
      CALL HAMLTN                                                       TRAC020
      HOME=DRDT(1)*(R(1)-EARTHR-RCVRH).GE.0.                            TRAC021
C*********                                                              TRAC022
C*********                                                              TRAC023
      IHOP=0                                                            TRAC024
      WRITE(6,1701)XMTR,RCVRH,NHOP,MAXSTP,HOME                          TRAC025
 1701 FORMAT(/,26H Begin TRACE h TX and h RX,2(2X,F10.5)                TRAC026
     1,1X,4HNHOP,I4,1X,6HMAXSTP,2X,F10.5,1X,4HHOME,1X,I4,/)                     BIA
      HTMAX=0.                                                          TRAC027
      NEWRAY=.TRUE.                                                     TRAC028
      THERE=R(1)-EARTHR.EQ.RCVRH                                        TRAC029
C********* LOOP ON NUMBER OF HOPS                                       TRAC030
   10 IHOP=IHOP+1                                                       TRAC031
      IF (IHOP.GT.NHOP) RETURN                                          TRAC032
      PENET=.FALSE.                                                     TRAC033
      APHT=RCVRH                                                        TRAC034
C********* LOOP ON MAXIMUM NUMBER OF STEPS PER HOP                      TRAC035
      DO 79 J=1,MAX                                                     TRAC036
      H=R(1)-EARTHR                                                     TRAC037
      IF (ABS(H-RCVRH).GT.ABS(APHT-RCVRH)) APHT=H                       TRAC038
      HTMAX=AMAX1(H,HTMAX)                                              TRAC039
      IF (.NOT.SPACE) GO TO 12                                          TRAC040
      CALL REACH                                                        TRAC041
      RSTART=1.                                                         TRAC042
      H=R(1)-EARTHR                                                     TRAC043
      IF (ABS(H-RCVRH).GT.ABS(APHT-RCVRH)) APHT=H                       TRAC044
      HTMAX=AMAX1(H,HTMAX)                                              TRAC045
      IF (.NOT.SPACE) GO TO 12                                          TRAC046
      IF (PERIGE) WRITE (6,*)'PERIGEE'                                  TRAC047
      IF (THERE) GO TO 51                                               TRAC048
      IF (MINDIS) GO TO 40                                              TRAC049
      IF (GROUND) GO TO 60                                              TRAC050
C *****     QUI CHIAMAVA RAYPLOT                                        TRAC051
      IF (PERIGE) GO TO 79                                              TRAC052
   12 DO 13 L=1,N                                                       TRAC053
      ROLD(L)=R(L)                                                      TRAC054
   13 DROLD(L)=DRDT(L)                                                  TRAC055
      TOLD=T                                                            TRAC056
      WAS=THERE                                                         TRAC057
      CALL RKAM                                                         TRAC058
     
C*******************************************************************************
      WRITE(6,*) 'BEFORE: OUT=', OUT                                            AZZ
      IF((.NOT.OUT).AND.(.NOT.PENET).AND.SPACE.AND.(DRDT(1).LT.0.))THEN         AZZ
      OUT=.TRUE.                                                                AZZ
      PRINT *,'111.1 0 3'                                                       AZZ
      WRITE(6,*) '+++ RAY OUT THE IONOSPHERE +++'                               AZZ
      ENDIF                                                                     AZZ
      WRITE(6,*) 'AFTER: OUT=', OUT                                             AZZ
C*******************************************************************************
     
      PRINT 1234, R(1),R(2),R(3)                                        
 1234 FORMAT (3(2X,F20.10))                                             
      WRITE (6,1703) R(1),R(2),R(3),R(4),R(5),R(6)                         	BIA
 1703 FORMAT (8H TRAC000,/,6(2X,F20.10))                                        BIA
      H=R(1)-EARTHR                                                     TRAC059
      THERE=.FALSE.                                                     TRAC060
      WASNT=.NOT.HOME                                                   TRAC061
      HOME=DRDT(1)*(H-RCVRH).GE.0.                                      TRAC062
      TMP=(DRDT(1)-DROLD(1))*(T-TOLD)                                   TRAC063
      SMT=0.                                                            TRAC064
      IF (TMP.NE.0.) SMT=0.5*(R(1)-ROLD(1)+0.5*TMP)**2/ABS(TMP)         TRAC065
      IF (((H-RCVRH)*(ROLD(1)-EARTHR-RCVRH).LT.0..AND..NOT.WAS).OR.     TRAC066
     1 (WAS.AND.DRDT(1)*DROLD(1).LT.0..AND.HOME)) GO TO 50              TRAC067
      IF (HOME.AND.WASNT) GO TO 30                                      TRAC068
      IF (H.LT.0..OR.DRDT(1).GT.0..AND.DROLD(1).LT.0..AND.SMT.GT.H)     TRAC069
     1 GO TO 20                                                         TRAC070
      IF (DROLD(1).LT.0..AND.DRDT(1).GT.0.) WRITE(6,*)'PERIGEE'         TRAC071
      IF (DROLD(1).GT.0..AND.DRDT(1).LT.0.) THEN                        TRAC072
      PRINT *,'111.1 0 2'                                                       AZZ
      WRITE(6,*)'APOGEE'                                                        AZZ
      ENDIF                                                                     AZZ
      IF (DROLD(2)*DRDT(2).LT.0.) WRITE(6,*)'REACHED MAX LAT'           TRAC073
      IF (DROLD(3)*DRDT(3).LT.0.) WRITE(6,*)'REACHED MAX LONG'          TRAC074
      DO 14 I=4,6                                                       TRAC075
      IF (ROLD(I)*R(I).LT.0.) WRITE(6,*)'WAVE REVERSE'                  TRAC076
   14 CONTINUE                                                          TRAC077
      GO TO 75                                                          TRAC078
C********* RAY WENT UNDERGROUND                                         TRAC079
   20 CALL BACK UP(0.)                                                  TRAC080
      GO TO 60                                                          TRAC081
C********* RAY MAY HAVE MADE A CLOSEST APPROACH                         TRAC082
   30 CALL GRAZE(RCVRH)                                                 TRAC083
      IF (THERE) GO TO 51                                               TRAC084
   40 DRDT(1)=0.                                                        TRAC085
      HPUNCH=R(1)-EARTHR                                                TRAC086
     
C*******************************************************************************
      PRINT *,'222.2 0 1'                                                       AZZ
      WRITE(6,*)'CLOSEST APPROACH : MIN. DIST.'                         TRAC087
C*******************************************************************************
     
      IF (IHOP.GE.NHOP) RETURN                                          TRAC089
      IHOP=IHOP+1                                                       TRAC090
     
C*******************************************************************************
      PRINT *,'222.2 0 1'                                                       AZZ
      WRITE(6,*)'CLOSEST APPROACH : MIN. DIST.'                         TRAC091
C*******************************************************************************
     
      GO TO 89                                                          TRAC092
C********* RAY CROSSED RECEIVER HEIGHT                                  TRAC093
   50 CALL BACK UP(RCVRH)                                               TRAC094
      THERE=.TRUE.                                                      TRAC095
   51 R(1)=EARTHR+RCVRH                                                 TRAC096
      HTMAX=AMAX1(RCVRH,HTMAX)                                          TRAC097
      HPUNCH=APHT                                                       TRAC098
      WRITE(6,*)'RAY CROSSED RECEIVER HEIGHT'                           TRAC099
                                                                        TRAC100
      IF (RCVRH.NE.0.) GO TO 89                                         TRAC101
      IF (IHOP.GE.NHOP) RETURN                                          TRAC102
      IHOP=IHOP+1                                                       TRAC103
      APHT=RCVRH                                                        TRAC104
C********* GROUND REFLECT                                               TRAC105
   60 R(1)=EARTHR                                                       TRAC106
      IF (ABS(RCVRH).GT.ABS(APHT-RCVRH)) APHT=0.                        TRAC107
      R(4)=ABS (R(4))                                                   TRAC108
      DRDT(1)=ABS (DRDT(1))                                             TRAC109
      RSTART=1.                                                         TRAC110
      HPUNCH=HTMAX                                                      TRAC111
     
C*******************************************************************************
      PRINT *,'222.2 0 2'                                                       AZZ
      WRITE(6,*)'GROUND REFLECTION'                                     TRAC112
C*******************************************************************************
     
C*******************************************************************************
      CALL ZERO                                                                 AZZ
C*******************************************************************************
     
      HTMAX=0.                                                          TRAC113
      IF (RCVRH.NE.0.) GO TO 65                                         TRAC114
      THERE=.TRUE.                                                      TRAC115
      HPUNCH=APHT                                                       TRAC116
      WRITE(6,*)'AT THE RECEIVER'                                       TRAC117
      GO TO 89                                                          TRAC118
   65 H=0.                                                              TRAC119
      THERE=.FALSE.                                                     TRAC120
C*********                                                              TRAC121
   75 CONTINUE                                                          TRAC122
      IF (H.GT.HMAX.AND.H.GT.RCVRH.AND.DRDT(1).GT.0.) GO TO 90          TRAC123
      IF (MOD(J,NSKIP).EQ.0) CONTINUE                                   TRAC124
   79 CONTINUE                                                          TRAC125
C********* EXCEEDED MAXIMUM NUMBER OF STEPS                             TRAC126
      HPUNCH=H                                                          TRAC127
     
C*******************************************************************************
      PRINT *,'222.2 0 3'                                                       AZZ
      WRITE(6,*)'EXCEEDED MAX NUM. STEPS'                               TRAC128
C*******************************************************************************
     
      RETURN                                                            TRAC129
C*********                                                              TRAC130
   89 HOME=.TRUE.                                                       TRAC131
      GO TO 10                                                          TRAC132
C********* RAY PENETRATED                                               TRAC133
   90 PENET=.TRUE.                                                      TRAC134
      HPUNCH=H                                                          TRAC135
     
C*******************************************************************************
      PRINT *,'222.2 0 0'                                                       AZZ
      WRITE(6,*)'RAY PENETRATE'                                         TRAC136
C*******************************************************************************
     
      RETURN                                                            TRAC137
         END                                                            TRAC138-
      SUBROUTINE REACH                                                  REAC001
C          CALCULATES THE STRAIGHT LINE RAY PATH BETWEEN THE EARTH      REAC002
C          AND THE IONOSPHERE OR BETWEEN IONOSPHERIC LAYERS             REAC003
      COMMON /RK/ N,STEP,MODE,E1MAX,E1MIN,E2MAX,E2MIN,FACT,RSTART       REAC004
      COMMON /TRAC/ GROUND,PERIGE,THERE,MINDIS,NEWRAY,SMT               REAC005
      COMMON /COORD/ S,X0(6),GG(6),R0(4),VERT                           REAC006
      COMMON /RIN/ MODRIN(3),COLL,FIELD,SPACE,ZZN,N2I,PNP(10),POLAR,    REAC007
     1             LPOLAR                                               REAC008
      COMMON /XX/ MODX(2),X,PXPR,PXPTH,PXPPH,PXPT,HMAX                  REAC009
      COMMON R(20),T,STP,DRDT(20),N2                                    REAC010
      COMMON /WW/ ID,W0,W(400)                                          
      EQUIVALENCE (EARTHR,W(2)),(XMTRH,W(3)),(RCVRH,W(20))              REAC011
     
C*******************************************************************************
      EQUIVALENCE (STEP1,W(44)),(TH,R(2))                                       GPROF000
C      EQUIVALENCE (DTHDT,DRDT(2)),(DPHDT,DRDT(3))                               GPROF000
C*******************************************************************************
     
      LOGICAL CROSS,CROSSG,CROSSR,SPACE,GROUND,PERIGE,THERE,MINDIS,     REAC012
     1        NEWRAY,RSPACE                                             REAC013
      REAL N2,N2I                                                       REAC 14
      COMPLEX PNP,POLAR,LPOLAR                                          REAC 15
      DATA  NSTEP/500/                                                  REAC 16
     
C*******************************************************************************
C     ALEX: Per ogni iterazione di raytracing,                          
C           è stato necessario introdurre                               
C           una variabile logica di controllo                           
C           che forzasse, una ed una sola volta, la stampa              
C           su file dell'input '+++ RAY IN THE IONOSPHERE +++'          
C           e da schermo della coordinata speciale '111.1 0 1'.         
C*******************************************************************************
      LOGICAL IN                                                        
      IF (NEWRAY) IN=.FALSE.                                            
C*******************************************************************************
     
      CALL HAMLTN                                                       REAC 17
      H=R(1)-EARTHR                                                     REAC 18
      IF (.NOT.NEWRAY.AND..NOT.RSPACE)  WRITE(6,*)'(8HEXIT ION,0.)'     REAC 19
      NEWRAY=.FALSE.                                                    REAC 20
      V=SQRT(R(4)**2+R(5)**2+R(6)**2)                                   REAC 21
C********* NORMALIZE THE WAVE NORMAL DIRECTION TO ONE                   REAC 22
      R(4)=R(4)/V                                                       REAC 23
      R(5)=R(5)/V                                                       REAC 24
      R(6)=R(6)/V                                                       REAC 25
C********* NEGATIVE OF DISTANCE ALONG RAY TO CLOSEST APPROACH TO CENTER REAC 26
C********* OF EARTH                                                     REAC 27
      UP=R(1)*R(4)                                                      REAC 28
      RADG=EARTHR**2-R(1)**2*(R(5)**2+R(6)**2)                          REAC 29
      DISTG=SQRT (AMAX1(0.,RADG))                                       REAC 30
C********* DISTANCE ALONG RAY TO FIRST INTERSECTION WITH OR CLOSEST     REAC 31
C********* APPROACH TO THE EARTH                                        REAC 32
      SG=-UP-DISTG                                                      REAC 33
C********* CROSSG IS TRUE IF THE RAY WILL INTERSECT OR TOUCH THE EARTH  REAC 34
      CROSSG=UP.LT.0..AND.RADG.GE.0.                                    REAC 35
      RADR=(EARTHR+RCVRH)**2-R(1)**2*(R(5)**2+R(6)**2)                  REAC 36
      DISTR=SQRT (AMAX1(0.,RADR))                                       REAC 37
C********* DISTANCE ALONG RAY TO THE FIRST INTERSECTION WITH OR CLOSEST REAC 38
C********* APPROACH TO THE RECEIVER HEIGHT                              REAC 39
      SR=DISTR-UP                                                       REAC 40
      IF (UP.LT.0..AND.DISTR.LT.-UP.AND.R(1).NE.EARTHR+RCVRH) SR=-DISTR REAC 41
     1 -UP                                                              REAC 42
C********* CROSSR IS TRUE IF THE RAY WILL INTERSECT WITH OR MAKE A      REAC 43
C********* CLOSEST APPROACH TO THE RECEIVER HEIGHT                      REAC 44
      CROSSR=R(4).LT.0..OR.R(1).LT.(EARTHR+RCVRH)                       REAC 45
      CROSS=CROSSG.OR.CROSSR                                            REAC 46
C********* MAXIMUM DISTANCE IN WHICH TO LOOK FOR THE IONOSPHERE         REAC 47
      S1=AMIN1(SR,SG)                                                   REAC 48
      IF(.NOT.CROSSG) S1=SR                                             REAC 49
      IF (UP.GE.0.) GO TO 15                                            REAC 50
      CROSS=.TRUE.                                                      REAC 51
C********* IF RAY IS GOING DOWN, S1 IS AT MOST THE DISTANCE TO A PERIGEEREAC 52
      S1=AMIN1(S1,-UP)                                                  REAC 53
C********* CONVERT THE POSITION AND DIRECTION OF THE RAY TO CARTESIAN   REAC 54
C********* COORDINATES                                                  REAC 55
   15 CALL POLCAR                                                       REAC 56
     
C      SSTEP=100.                                                        REAC 57
C*******************************************************************************
C     ALEX: Originariamente, SSTEP=100.0 .                              
C           In realtà, applicando la trigonometria,                     
C           si può dimostrare, in prima approssimazione,                
C           che l'elemento di ascissa curvilinea è ...                  
C*******************************************************************************
      SSTEP=STEP1/COS(TH)                                                       GPROF000
C*******************************************************************************
C     FORMULA ESATTA PER L'ELEMENTO DI ASCISSA CURVILINEA IN COORDINATE POLARI: 
C*******************************************************************************
C      SSTEP=STEP1*SQRT(1+(R(1)*(DTHDT/DRDT(1)))**2+                             GPROF000
C     1(R(1)*SIN(TH)*(DPHDT/DRDT(1)))**2)                                        GPROF000
C*******************************************************************************
     
      S=SSTEP                                                           REAC 58
      DO 20 I=1,NSTEP                                                   REAC 59
      IF ((S-SSTEP).GT.S1.AND.CROSS) GO TO 25                           REAC 60
C********* CONVERT POSITION AND DIRECTION TO SPHERICAL POLAR COORDINATESREAC 61
C********* AT A DISTANCE S ALONG THE RAY                                REAC 62
      CALL CARPOL                                                       REAC 63
      CALL ELECTX                                                       REAC 64
C********* FREE SPACE                                                   REAC 65
      IF (X.EQ.0) GO TO 20                                              REAC 66
      CALL RINDEX                                                       REAC 67
C********* NORMALIZE THE WAVE NORMAL DIRECTION TO ONE                   REAC 22
      R(4)=R(4)/V                                                       REAC 22a
      R(5)=R(5)/V                                                       REAC 22b
      R(6)=R(6)/V                                                       REAC 22c
C********* EFFECTIVELY FREE SPACE                                       REAC 68
      IF (SPACE) GO TO 20                                               REAC 69
      IF (SSTEP.LT.0.5E-4) GO TO 25                                     REAC 70
C********* RAY IN THE IONOSPHERE.  STEP BACK OUT                        REAC 71
      S=S-SSTEP                                                         REAC 72
C********* DECREASE STEP SIZE                                           REAC 73
      SSTEP=SSTEP/10.                                                   REAC 74
   20 S=S+SSTEP                                                         REAC 75
     
C*******************************************************************************
      PRINT *,'222.2 0 3'                                                       AZZ
C*******************************************************************************
     
      WRITE(6,2000) NSTEP                                               REAC 76
 2000 FORMAT (9H EXCEEDED,I5,26H STEPS IN SUBROUTINE REACH)             REAC 77
     
C*******************************************************************************
      CALL ZERO                                                                 AZZ
C*******************************************************************************
     
      STOP                                                              REAC 78
   25 IF(CROSS) S=AMIN1(S,S1)                                           REAC 79
C********* CONVERT POSITION AND DIRECTION TO SPHERICAL POLAR COORDINATESREAC 80
C********* AT A DISTANCE S ALONG THE RAY                                REAC 81
      CALL CARPOL                                                       REAC 82
C********* AVOID THE RAY BEING SLIGHTLY UNDERGROUND                     REAC 83
      R(1)=AMAX1(R(1),EARTHR)                                           REAC 84
C********* ONE STEP INTEGRATION                                         REAC 85
      IF (N.LT.7) GO TO 31                                              REAC 86
      DO 30 NN=7,N                                                      REAC 87
   30 R(NN)=R(NN)+S*DRDT(NN)                                            REAC 88
   31 T=T+S                                                             REAC 89
      CALL RINDEX                                                       REAC 90
C********* AT A PERIGEE                                                 REAC 91
      PERIGE=S.EQ.(-UP)                                                 REAC 92
C********* CORRECT MINOR ERRORS                                         REAC 93
      IF (PERIGE) R(4)=0.                                               REAC 94
C********* KEEP CONSISTENCY AFTER CORRECTING MINOR ERRORS               REAC 95
      DRDT(1)=R(4)                                                      REAC 96
C********* ON THE GROUND                                                REAC 97
      GROUND=S.EQ.SG.AND.CROSSG                                         REAC 98
C********* AT THE RECEIVER HEIGHT                                       REAC 99
      THERE=S.EQ.SR.AND.CROSSR.AND..NOT.PERIGE                          REAC100
C********* AT A CLOSEST APPROACH TO THE RECEIVER HEIGHT                 REAC101
      MINDIS=PERIGE.AND.S.EQ.SR.AND.CROSSR                              REAC102
      RSPACE=SPACE                                                      REAC103
      V=SQRT(N2/(R(4)**2+R(5)**2+R(6)**2))                              REAC104
C********* RENORMALIZE THE WAVE NORMAL DIRECTION TO = SQRT(REAL(N**2))  REAC105
      R(4)=R(4)*V                                                       REAC106
      R(5)=R(5)*V                                                       REAC107
      R(6)=R(6)*V                                                       REAC108
      RSTART=1.                                                         REAC109
     
C*******************************************************************************
      WRITE(6,*) 'BEFORE: IN=', IN                                              AZZ
      IF ((.NOT.IN).AND.(.NOT.SPACE).AND.(DRDT(1).GT.0.)) THEN          REAC110
      IN=.TRUE.                                                                 AZZ
      PRINT *,'111.1 0 1'                                                       AZZ
      WRITE(6,*) '+++ RAY IN THE IONOSPHERE +++'                                AZZ
      END IF                                                                    AZZ
      WRITE(6,*) 'AFTER: IN=', IN                                               AZZ
C*******************************************************************************
     
      RETURN                                                            REAC111
         END                                                            REAC112-
      SUBROUTINE BACK UP(HS)                                            BACK001
      COMMON /RK/ N,STEP,MODE,E1MAX,E1MIN,E2MAX,E2MIN,FACT,RSTART       BACK002
      COMMON /TRAC/ GROUND,PERIGE,THERE,MINDIS,NEWRAY,SMT               BACK003
      COMMON R(20),T,STP,DRDT(20),N2                                    BACK004
      COMMON /WW/ ID,W0,W(400)                                          
      EQUIVALENCE (EARTHR,W(2)),(INTYP,W(41)),(STEP1,W(44))             BACK005
      REAL INTYP                                                        BACK006
      LOGICAL GROUND,PERIGE,THERE,MINDIS,NEWRAY,HOME                    BACK007
C********* DIAGNOSTIC PRINTOUT                                          BACK008
C        CALL PRINTR (8HBACK UP0,0.)                                    BACK009
C********* GOING AWAY FROM THE HEIGHT HS                                BACK010
      HOME=DRDT(1)*(R(1)-EARTHR-HS).GE.0.                               BACK011
      IF (HS.GT.0..AND..NOT.HOME.OR.HS.EQ.0..AND.DRDT(1).GT.0.) GO TO 30BACK012
C********* FIND NEAREST INTERSECTION OF RAY WITH THE HEIGHT HS          BACK013
      DO 10 I=1,10                                                      BACK014
      STEP=-(R(1)-EARTHR-HS)/DRDT(1)                                    BACK015
     
C*******************************************************************************
C     NB: La variabile STP è definita ma non inizializzata,             
C         quindi si omette la seguente istruzione                       
C         che potrebbe dar luogo a valori aleatori.                     
C*******************************************************************************
C      STEP=SIGN(AMIN1(ABS(STP),ABS(STEP)),STEP)                         BACK016
C*******************************************************************************
     
      IF (ABS(R(1)-EARTHR-HS).LT..5E-4.AND.ABS(STEP).LT.1.) GO TO 60    BACK017
C********* DIAGNOSTIC PRINTOUT                                          BACK018
      WRITE(6,*)'(8HBACK UP1,0.)'                                       BACK019
      MODE=1                                                            BACK020
      RSTART=1.                                                         BACK021
      CALL RKAM                                                         BACK022
   10 RSTART=1.                                                         BACK023
C********* IF A CLOSEST APPROACH COULD NOT BE FOUND IN 10 STEPS, IT     BACK044
C********* PROBABLY MEANS THAT THE RAY INTERSECTS THE HEIGHT HS         BACK045
   30 CONTINUE                                                          BACK046
C********* DIAGNOSTIC PRINTOUT                                          BACK047
      WRITE(6,*)'(8HBACK UP2,0.)'                                       BACK048
      MODE=1                                                            BACK049
C********* ESTIMATE DISTANCE TO NEAREST INTERSECTION OF RAY WITH HEIGHT BACK050
C********* HS BEHIND THE PRESENT RAY POINT                              BACK051
     
C*******************************************************************************
C     ERRATA CORRIGE DA DISPENSE DI JONES STEVENSON                     
C*******************************************************************************
C      STEP=(-R(4)-SQRT(R(4)**2-2.*(R(1)-EARTHR-HS)*DRDT(4)))/DRDT(4)    BACK052
      H=R(1)-EARTHR                                                     BACK052BIS
      STEP=(-R(4)-SQRT(R(4)**2-2.*(H-HS)*R(4)/DRDT(1)*DRDT(4)))/DRDT(4) BACK052TRIS
C*******************************************************************************
     
      RSTART=1.                                                         BACK053
      CALL RKAM                                                         BACK054
      RSTART=1.                                                         BACK055
C********* FIND NEAREST INTERSECTION OF RAY WITH HEIGHT HS              BACK056
      DO 40 I=1,10                                                      BACK057
      STEP=-(R(1)-EARTHR-HS)/DRDT(1)                                    BACK058
     
C*******************************************************************************
C     NB: La variabile STP è definita ma non inizializzata,             
C         quindi si omette la seguente istruzione                       
C         che potrebbe dar luogo a valori aleatori.                     
C*******************************************************************************
C      STEP=SIGN(AMIN1(ABS(STP),ABS(STEP)),STEP)                         BACK059
C*******************************************************************************
     
C*******************************************************************************
C     ERRATA CORRIGE DA DISPENSE DI JONES STEVENSON                     
C*******************************************************************************
C      IF(ABS(R(1)-EARTHR-HS).LT..5E-4.AND.ABS(STEP).LT.1.) GO TO 60     BACK060
      IF(ABS(R(1)-EARTHR-HS).LT..5E-4.AND.ABS(STEP).LT.1.) GO TO 50     BACK060BIS
C*******************************************************************************
     
C********* DIAGNOSTIC PRINTOUT                                          BACK061
      WRITE(6,*)'(8HBACK UP3,0.)'                                       BACK062
      MODE=1                                                            BACK063
      RSTART=1.                                                         BACK064
      CALL RKAM                                                         BACK065
   40 RSTART=1.                                                         BACK066
   50 THERE=.TRUE.                                                      BACK067
C********* RESET STANDARD MODE AND INTEGRATION TYPE                     BACK068
   60 MODE=INTYP                                                        BACK069
      STEP=STEP1                                                        BACK070
      RETURN                                                            BACK071
         END                                                            BACK072-
          SUBROUTINE GRAZE(HS)                                          GRAZ001
      COMMON /RK/ N,STEP,MODE,E1MAX,E1MIN,E2MAX,E2MIN,FACT,RSTART       GRAZ002
      COMMON /TRAC/ GROUND,PERIGE,THERE,MINDIS,NEWRAY,SMT               GRAZ003
      COMMON R(20),T,STP,DRDT(20),N2                                    GRAZ004
      COMMON /WW/ ID,W0,W(400)                                          
      EQUIVALENCE (EARTHR,W(2)),(INTYP,W(41)),(STEP1,W(44))             GRAZ005
      REAL INTYP                                                        GRAZ006
      LOGICAL GROUND,PERIGE,THERE,MINDIS,NEWRAY                         GRAZ007
C    
      THERE=.FALSE.                                                     GRAZ027
C********* DIAGNOSTIC PRINTOUT                                          GRAZ028
      WRITE(6,*)'(8HGRAZE 0 ,0.)'                                       GRAZ029
      IF (SMT.GT.ABS(R(1)-EARTHR-HS)) GO TO 30                          GRAZ030
      DO 20 I=1,10                                                      GRAZ031
      STEP=-R(4)/DRDT(4)                                                GRAZ032
     
C*******************************************************************************
C     NB: La variabile STP è definita ma non inizializzata,             
C         quindi si omette la seguente istruzione                       
C         che potrebbe dar luogo a valori aleatori.                     
C*******************************************************************************
C      STEP=SIGN(AMIN1(ABS(STP),ABS(STEP)),STEP)                         GRAZ033
C*******************************************************************************
     
      IF (ABS(R(4)).LE.1.E-6.AND.ABS(STEP).LT.1.) GO TO 60              GRAZ034
C********* DIAGNOSTIC PRINTOUT                                          GRAZ035
      WRITE(6,*)'(8HGRAZE 1 ,0.)'                                       GRAZ036
      MODE=1                                                            GRAZ037
      RSTART=1.                                                         GRAZ038
      CALL RKAM                                                         GRAZ039
      RSTART=1.                                                         GRAZ040
      IF (DRDT(4)*(R(1)-EARTHR-HS).LT.0.) GO TO 30                      GRAZ041
      IF(R(5).EQ.0..AND.R(6).EQ.0.) GO TO 60                            GRAZ042
   20 CONTINUE                                                          GRAZ043
C********* IF A CLOSEST APPROACH COULD NOT BE FOUND IN 10 STEPS, IT     GRAZ044
C********* PROBABLY MEANS THAT THE RAY INTERSECTS THE HEIGHT HS         GRAZ045
   30 CONTINUE                                                          GRAZ046
C********* DIAGNOSTIC PRINTOUT                                          GRAZ047
      WRITE(6,*)' (8HBACK UP2,0.)'                                      GRAZ048
      MODE=1                                                            GRAZ049
C********* ESTIMATE DISTANCE TO NEAREST INTERSECTION OF RAY WITH HEIGHT GRAZ050
C********* HS BEHIND THE PRESENT RAY POINT                              GRAZ051
     
C*******************************************************************************
C     ERRATA CORRIGE DA DISPENSE DI JONES STEVENSON                     
C*******************************************************************************
C      STEP=(-R(4)-SQRT(R(4)**2-2.*(R(1)-EARTHR-HS)*DRDT(4)))/DRDT(4)    GRAZ052
      H=R(1)-EARTHR                                                     GRAZ052BIS
      STEP=(-R(4)-SQRT(R(4)**2-2.*(H-HS)*R(4)/DRDT(1)*DRDT(4)))/DRDT(4) GRAZ052TRIS
C*******************************************************************************
     
      RSTART=1.                                                         GRAZ053
      CALL RKAM                                                         GRAZ054
      RSTART=1.                                                         GRAZ055
C********* FIND NEAREST INTERSECTION OF RAY WITH HEIGHT HS              GRAZ056
      DO 40 I=1,10                                                      GRAZ057
      STEP=-(R(1)-EARTHR-HS)/DRDT(1)                                    GRAZ058
     
C*******************************************************************************
C     NB: La variabile STP è definita ma non inizializzata,             
C         quindi si omette la seguente istruzione                       
C         che potrebbe dar luogo a valori aleatori.                     
C*******************************************************************************
C      STEP=SIGN(AMIN1(ABS(STP),ABS(STEP)),STEP)                         GRAZ059
C*******************************************************************************
     
C*******************************************************************************
C     ERRATA CORRIGE DA DISPENSE DI JONES STEVENSON                     
C*******************************************************************************
C      IF(ABS(R(1)-EARTHR-HS).LT..5E-4.AND.ABS(STEP).LT.1.) GO TO 60     GRAZ060
      IF(ABS(R(1)-EARTHR-HS).LT..5E-4.AND.ABS(STEP).LT.1.) GO TO 50     GRAZ060BIS
C*******************************************************************************
     
C********* DIAGNOSTIC PRINTOUT                                          GRAZ061
      WRITE(6,*)'(8HBACK UP3,0.)'                                       GRAZ062
      MODE=1                                                            GRAZ063
      RSTART=1.                                                         GRAZ064
      CALL RKAM                                                         GRAZ065
   40 RSTART=1.                                                         GRAZ066
   50 THERE=.TRUE.                                                      GRAZ067
C********* RESET STANDARD MODE AND INTEGRATION TYPE                     GRAZ068
   60 MODE=INTYP                                                        GRAZ069
      STEP=STEP1                                                        GRAZ070
      RETURN                                                            GRAZ071
         END                                                            GRAZ072-
      SUBROUTINE POLCAR                                                 POLC001
C                                                                       POLC002
      COMMON /COORD/ S,X0(6),GG(6),R0(4),VERT                           POLC003
      COMMON /CONST/ PI,PIT2,PID2,DEGS,RAD,K,C,LOGTEN                   POLC004
      COMMON R(20),T,STP,DRDT(20),N2                                    POLC005
C          CONVERTS SPHERICAL COORDINATES TO CARTESIAN                  POLC006
      IF (R(5).EQ.0..AND.R(6).EQ.0.) GO TO 1                            POLC007
      VERT=0.                                                           POLC008
      SINA=SIN(R(2))                                                    POLC009
      COSA=SIN(PID2-R(2))                                               POLC010
      SINP=SIN(R(3))                                                    POLC011
      COSP=SIN(PID2-R(3))                                               POLC012
      X0(1)=R(1)*SINA*COSP                                              POLC013
      X0(2)=R(1)*SINA*SINP                                              POLC014
      X0(3)=R(1)*COSA                                                   POLC015
      GG(4)=R(4)*SINA*COSP+R(5)*COSA*COSP-R(6)*SINP                     POLC016
      GG(5)=R(4)*SINA*SINP+R(5)*COSA*SINP+R(6)*COSP                     POLC017
      GG(6)=R(4)*COSA-R(5)*SINA                                         POLC018
      RETURN                                                            POLC019
C          VERTICAL INCIDENCE                                           POLC020
    1 VERT=1.                                                           POLC021
      R0(1)=R(1)                                                        POLC022
      R0(2)=R(2)                                                        POLC023
      R0(3)=R(3)                                                        POLC024
      R0(4)=SIGN (1.,R(4))                                              POLC025
      RETURN                                                            POLC026
         END                                                            POLC026-
C                                                                       POLC027
C          STEPS THE RAY A DISTANCE S, AND THEN                         POLC028
C          CONVERTS CARTESIAN COORDINATES TO SPHERICAL COORDINATES      POLC029
      SUBROUTINE CARPOL                                                 POLC030
      COMMON /COORD/ S,X0(6),GG(6),R0(4),VERT                           POLC003bis
      COMMON /CONST/ PI,PIT2,PID2,DEGS,RAD,K,C,LOGTEN                   POLC004bis
      COMMON R(20),T,STP,DRDT(20),N2                                    POLC005bis
      IF (VERT.NE.0.) GO TO 2                                           POLC031
      GG(1)=X0(1)+S*GG(4)                                               POLC032
      GG(2)=X0(2)+S*GG(5)                                               POLC033
      GG(3)=X0(3)+S*GG(6)                                               POLC034
      TEMP=SQRT(GG(1)**2+GG(2)**2)                                      POLC035
      R(1)=SQRT(GG(1)**2+GG(2)**2+GG(3)**2)                             POLC036
      R(2)=ATAN2(TEMP,GG(3))                                            POLC037
      R(3)=ATAN2(GG(2),GG(1))                                           POLC038
      R(4)=(GG(1)*GG(4)+GG(2)*GG(5)+GG(3)*GG(6))/R(1)                   POLC039
      R(5)=(GG(3)*(GG(1)*GG(4)+GG(2)*GG(5))-(GG(1)**2+GG(2)**2)*GG(6))/ POLC040
     1(R(1)*TEMP)                                                       POLC041
      R(6)=(GG(1)*GG(5)-GG(2)*GG(4))/TEMP                               POLC042
      RETURN                                                            POLC043
C          VERTICAL INCIDENCE                                           POLC044
    2 R(1)=R0(1)+R0(4)*S                                                POLC045
      R(2)=R0(2)                                                        POLC046
      R(3)=R0(3)                                                        POLC047
      R(4)=R0(4)                                                        POLC048
      R(5)=0.                                                           POLC049
      R(6)=0.                                                           POLC050
      RETURN                                                            POLC051
         END                                                            POLC 52-
      SUBROUTINE RKAM                                                   RKAM001
C        NUMERICAL INTEGRATION OF DIFFERENTIAL EQUATIONS                RKAM002
      COMMON /RK/ NN,SPACE,MODE,E1MAX,E1MIN,E2MAX,E2MIN,FACT,RSTART     RKAM003
      COMMON Y(20),T,STEP,DYDT(20),N2                                   RKAM004
      DIMENSION DELY(4,20),BET(4),XV(5),FV(4,20),YU(5,20)               RKAM005
      DOUBLE PRECISION YU                                               RKAM006
      IF (RSTART.EQ.0.) GO TO 1000                                      RKAM007
      LL=1                                                              RKAM008a
      MM=1                                                              RKAM008b
      IF (MODE.EQ.1) MM=4                                               RKAM009
      ALPHA=T                                                           RKAM010
      EPM=0.0                                                           RKAM011
      BET(1)=0.5                                                        RKAM012a
      BET(2)=0.5                                                        RKAM012b
      BET(3)=1.0                                                        RKAM013
      BET(4)=0.0                                                        RKAM014
      STEP=SPACE                                                        RKAM015
      R=19.0/270.0                                                      RKAM016
      XV(MM)=T                                                          RKAM017
      IF (E1MIN.LE.0.) E1MIN=E1MAX/55.                                  RKAM018
      IF (FACT.LE.0.) FACT=0.5                                          RKAM019
      CALL HAMLTN                                                       RKAM020
      DO 320 I=1,NN                                                     RKAM021
      FV(MM,I)=DYDT(I)                                                  RKAM022
  320 YU(MM,I)=Y(I)                                                     RKAM023
      RSTART=1.                                                         RKAM024
      GO TO 1001                                                        RKAM025
 1000 IF (MODE.NE.1) GO TO 2000                                         RKAM026
C                                                                       RKAM027
C          RUNGE-KUTTA                                                  RKAM028
 1001 DO 1034 K=1,4                                                     RKAM029
      DO 1350 I=1,NN                                                    RKAM030
      DELY(K,I)=STEP*FV(MM,I)                                           RKAM031
      Z=YU(MM,I)                                                        RKAM032
 1350 Y(I)=Z+BET(K)*DELY(K,I)                                           RKAM033
      T=BET(K)*STEP+XV(MM)                                              RKAM034
      CALL HAMLTN                                                       RKAM035
      DO 1034 I=1,NN                                                    RKAM036
 1034 FV(MM,I)=DYDT(I)                                                  RKAM037
      DO 1039 I=1,NN                                                    RKAM038
      DEL=(DELY(1,I)+2.0*DELY(2,I)+2.0*DELY(3,I)+DELY(4,I))/6.0         RKAM039
 1039 YU(MM+1,I)=YU(MM,I)+DEL                                           RKAM040
      MM=MM+1                                                           RKAM041
      XV(MM)=XV(MM-1)+STEP                                              RKAM042
      DO 1400 I=1,NN                                                    RKAM043
 1400 Y(I)=YU(MM,I)                                                     RKAM044
      T=XV(MM)                                                          RKAM045
      CALL HAMLTN                                                       RKAM046
      IF (MODE.EQ.1) GO TO 42                                           RKAM047
      DO 150 I=1,NN                                                     RKAM048
  150 FV(MM,I)=DYDT(I)                                                  RKAM049
      IF (MM.LE.3) GO TO 1001                                           RKAM050
C                                                                       RKAM051
C          ADAMS-MOULTON                                                RKAM052
 2000 DO 2048 I=1,NN                                                    RKAM053
      DEL=STEP*(55.*FV(4,I)-59.*FV(3,I)+37.*FV(2,I)-9.*FV(1,I))/24.     RKAM054
      Y(I)=YU(4,I)+DEL                                                  RKAM055
 2048 DELY(1,I)=Y(I)                                                    RKAM056
      T=XV(4)+STEP                                                      RKAM057
      CALL HAMLTN                                                       RKAM058
      XV(5)=T                                                           RKAM059
      DO 2051 I=1,NN                                                    RKAM060
      DEL=STEP*(9.*DYDT(I)+19.*FV(4,I)-5.*FV(3,I)+FV(2,I))/24.          RKAM061
      YU(5,I)=YU(4,I)+DEL                                               RKAM062
 2051 Y(I)=YU(5,I)                                                      RKAM063
      CALL HAMLTN                                                       RKAM064
      IF (MODE.LE.2) GO TO 42                                           RKAM065
C                                                                       RKAM066
C          ERROR ANALYSIS                                               RKAM067
      SSE=0.0                                                           RKAM068
      DO 3033 I=1,NN                                                    RKAM069
      EPSIL=R*ABS(Y(I)-DELY(1,I))                                       RKAM070
      IF (MODE.EQ.3.AND.Y(I).NE.0.) EPSIL=EPSIL/ABS(Y(I))               RKAM071
      IF (SSE.LT.EPSIL) SSE=EPSIL                                       RKAM072
 3033 CONTINUE                                                          RKAM073
      IF (E1MAX.GT.SSE) GO TO 3035                                      RKAM074
      IF (ABS(STEP).LE.E2MIN) GO TO 42                                  RKAM075
      LL=1                                                              RKAM076a
      MM=1                                                              RKAM076b
      STEP=STEP*FACT                                                    RKAM077
      GO TO 1001                                                        RKAM078
 3035 IF (LL.LE.1.OR.SSE.GE.E1MIN.OR.E2MAX.LE.ABS(STEP)) GO TO 42       RKAM079
      LL=2                                                              RKAM080
      MM=3                                                              RKAM081
      XV(2)=XV(3)                                                       RKAM082
      XV(3)=XV(5)                                                       RKAM083
      DO 5363 I=1,NN                                                    RKAM084
      FV(2,I)=FV(3,I)                                                   RKAM085
      FV(3,I)=DYDT(I)                                                   RKAM086
      YU(2,I)=YU(3,I)                                                   RKAM087
 5363 YU(3,I)=YU(5,I)                                                   RKAM088
      STEP=2.0*STEP                                                     RKAM089
      GO TO 1001                                                        RKAM090
     
C                                                                       RKAM091
C          EXIT ROUTINE                                                 RKAM092
     
   42 LL=2                                                              RKAM093
      MM=4                                                              RKAM094
      DO 12 K=1,3                                                       RKAM095
      XV(K)=XV(K+1)                                                     RKAM096
      DO 12 I=1,NN                                                      RKAM097
      FV(K,I)=FV(K+1,I)                                                 RKAM098
   12 YU(K,I)=YU(K+1,I)                                                 RKAM099
      XV(4)=XV(5)                                                       RKAM100
      DO 52 I=1,NN                                                      RKAM101
      FV(4,I)=DYDT(I)                                                   RKAM102
   52 YU(4,I)=YU(5,I)                                                   RKAM103
      IF (MODE.LE.2) RETURN                                             RKAM104
      E=ABS(XV(4)-ALPHA)                                                RKAM105
      IF (E.LE.EPM) GO TO 2000                                          RKAM106
      EPM=E                                                             RKAM107
      RETURN                                                            RKAM108
         END                                                            RKAM109-
      SUBROUTINE HAMLTN                                                 HAML001
C********* CALCULATES HAMILTONS EQUATIONS FOR RAY TRACING               HAML002
      COMMON /CONST/ PI,PIT2,PID2,DEGS,RAD,K,C,LOGTEN                   HAML003
C      COMMON /RIN/ MODRIN(3),COLL,FIELD,SPACE,KAY2,KAY2I,               HAML004
C     1             H,HI,PHPT,PHPTI,PHPR,PHPRI,PHPTH,PHPTHI,PHPPH,PHPPHI,HAML005
C     2             PHPOM,PHPOMI,PHPKR,PHPKRI,PHPKTH,PHPKTI,PHPKPH,PHPKPIHAML006
C     3            ,KPHPK,KPHPKI,POLAR,POLARI,LPOLAR,LPOLRI,SGN          HAML007
      COMMON /RIN/ MODRIN(3),COLL,FIELD,SPACE,KAY2,KAY2I,               HAML004
     1               HI,PHPT,PHPTI,PHPR,PHPRI,PHPTH,PHPTHI,PHPPH,PHPPHI,HAML005
     2             PHPOM,PHPOMI,PHPKR,PHPKRI,PHPKTH,PHPKTI,PHPKPH,PHPKPIHAML006
     3            ,KPHPK,KPHPKI,POLAR,POLARI,LPOLAR,LPOLRI              HAML007
     
      COMMON R(20),T,STP,DRDT(20),N2                                    HAML008
      COMMON /WW/ ID,W0,W(400)                                          
      EQUIVALENCE (TH,R(2)),(PH,R(3)),(KR,R(4)),(KTH,R(5)),(KPH,R(6)),  HAML009
     1 (DTHDT,DRDT(2)),(DPHDT,DRDT(3)),(DKRDT,DRDT(4)),(DKTHDT,DRDT(5)),HAML010
     2 (DKPHDT,DRDT(6)),(F,W(6))                                        HAML011
      REAL KR,KTH,KPH,KPHPK,KPHPKI,LPOLAR,LPOLRI,LOGTEN,K,KAY2,KAY2I    HAML012
      OM=PIT2*1.E6*F                                                    HAML013
      STH=SIN(TH)                                                       HAML014
      CTH=SIN(PID2-TH)                                                  HAML015
      RSTH=R(1)*STH                                                     HAML016
      RCTH=R(1)*CTH                                                     HAML017
      CALL RINDEX                                                       HAML018
      DR1DT=-PHPKR/(PHPOM*C)                                            HAML019
      DRDT(1)=DR1DT                                                     HAML019a
      DTHDT=-PHPKTH/(PHPOM*R(1)*C)                                      HAML020
      DPHDT=-PHPKPH/(PHPOM*RSTH*C)                                      HAML021
      DKRDT=PHPR/(PHPOM*C)+KTH*DTHDT+KPH*STH*DPHDT                      HAML022
      DKTHDT=(PHPTH/(PHPOM*C)-KTH*DR1DT+KPH*RCTH*DPHDT)/R(1)            HAML023
      DKPHDT=(PHPPH/(PHPOM*C)-KPH*STH*DR1DT-KPH*RCTH*DTHDT)/RSTH        HAML024
      NR=6                                                              HAML025
C********* PHASE PATH                                                   HAML026
      IF (W(57).EQ.0.) GO TO 10                                         HAML027
      NR=NR+1                                                           HAML028
      DRDT(NR)=-     KPHPK/PHPOM/OM                                     HAML029
C********* ABSORPTION                                                   HAML030
   10 IF (W(58).EQ.0.) GO TO 15                                         HAML031
      NR=NR+1                                                           HAML032
      DRDT(NR)= 10./LOGTEN*KPHPK*KAY2I/(KR*KR+KTH*KTH+KPH*KPH)/PHPOM/C  HAML033
C********* DOPPLER SHIFT                                                HAML034
   15 IF (W(59).EQ.0.) GO TO 20                                         HAML035
      NR=NR+1                                                           HAML036
      DRDT(NR)=-PHPT/PHPOM/C/PIT2                                       HAML037
C********* GEOMETRICAL PATH LENGTH                                      HAML038
   20 IF (W(60).EQ.0.) GO TO 25                                         HAML039
      NR=NR+1                                                           HAML040
      DRDT(NR)=-SQRT(PHPKR**2+PHPKTH**2+PHPKPH**2)/PHPOM   /C           HAML041
C********* OTHER CALCULATIONS                                           HAML042
   25 CONTINUE                                                          HAML043
      RETURN                                                            HAML044
         END                                                            HAML045-
      SUBROUTINE RINDEX                                                 NFNC001
C          CALCULATES THE REFRACTIVE INDEX AND ITS GRADIENT USING THE   NFNC002
C          APPLETON-HARTREE FORMULA -- NO FIELD, NO COLLISIONS          NFNC003
      COMMON /CONST/ PI,PIT2,PID2,DEGS,RADIAN,K,C,LOGTEN                NFNC004
C      COMMON /RIN/ MODRIN(3),COLL,FIELD,SPACE,KAY2,KAY2I,               NFNC005
C     1             H,HI,PHPT,PHPTI,PHPR,PHPRI,PHPTH,PHPTHI,PHPPH,PHPPHI,NFNC006
C     2             PHPOM,PHPOMI,PHPKR,PHPKRI,PHPKTH,PHPKTI,PHPKPH,PHPKPINFNC007
C     3            ,KPHPK,KPHPKI,POLAR,POLARI,LPOLAR,LPOLRI,SGN          NFNC008
      COMMON /RIN/ MODRIN(3),COLL,FIELD,SPACE,KAY2,KAY2I,               NFNC005
     1               HI,PHPT,PHPTI,PHPR,PHPRI,PHPTH,PHPTHI,PHPPH,PHPPHI,NFNC006
     2             PHPOM,PHPOMI,PHPKR,PHPKRI,PHPKTH,PHPKTI,PHPKPH,PHPKPINFNC007
     3            ,KPHPK,KPHPKI,POLAR,POLARI,LPOLAR,LPOLRI              NFNC008
     
      COMMON /XX/ MODX(2),X,PXPR,PXPTH,PXPPH,PXPT,HMAX                  NFNC009
      COMMON /YY/ MODY,Y(16)  /ZZ/ MODZ,Z(4)                            NFNC010
      COMMON /RK/ N,STEP,MODE,E1MAX,E1MIN,E2MAX,E2MIN,FACT,RSTART       NFNC011
C      COMMON R,TH,PH,KR,KTH,KPH,ZZZZZ(14),T,STP,DRDT(20),N2             NFNC012
      COMMON R(20),T,STP,DRDT(20),N2                                    NFNC012
     
      COMMON /WW/ ID,W0,W(400)                                          
      EQUIVALENCE (RAY,W(1)),(F,W(6))                                   NFNC013
      EQUIVALENCE (KR,R(4)),(KTH,R(5)),(KPH,R(6))                       NFNC013BIS
     
      LOGICAL SPACE                                                     NFNC014
      REAL N2,NNP,KR,KTH,KPH,K2,KPHPK,KPHPKI,KAY2,KAY2I,LPOLAR,LPOLRI   NFNC015
      DATA MODRIN(1)/4HAPPL/,MODRIN(2)/4H-HAR/,MODRIN(3)/4H FOR/,COLL/0.NFNC016
     1/
      DATA  FIELD/0./, KAY2I/0./, HI/0./, PHPTI/0./, PHPRI/0./          NFNC017
      DATA  PHPTHI/0./, PHPPHI/0./, PHPOMI/0./, PHPKRI/0./, PHPKTI/0./  NFNC018
      DATA  PHPKPI/0./, KPHPKI/0./, POLAR/0./, POLARI/1./, LPOLAR/0./   NFNC019
      DATA  LPOLRI/1./                                                  NFNC020
      DATA  X/0./, PXPR/0./, PXPTH/0./, PXPPH/0./, PXPT/0./             NFNC021
      DATA  MODY/1H /, MODZ/1H /                                        NFNC022
      DATA  NNP/1./, PNPX/-0.5/, PNPVR/0./, PNPVTH/0./, PNPVPH/0./      NFNC023
     
C ******************************************************************************
      DOUBLE PRECISION ONE                                              NFNC024
C ******************************************************************************
     
      OM=PIT2*1.E6*F                                                    NFNC025
      C2=C*C                                                            NFNC026
      K2=KR*KR+KTH*KTH+KPH*KPH                                          NFNC027
      OM2=OM*OM                                                         NFNC028
      VR =(C/OM)*KR                                                     NFNC029
      VTH=(C/OM)*KTH                                                    NFNC030
      VPH=(C/OM)*KPH                                                    NFNC031
      CALL ELECTX                                                       NFNC032
      PNPR =PNPX*PXPR                                                   NFNC033
      PNPTH=PNPX*PXPTH                                                  NFNC034
      PNPPH=PNPX*PXPPH                                                  NFNC035
      PNPT=PNPX*PXPT                                                    NFNC036
      N2=1.-X                                                           NFNC037
      WRITE(6,1707) X,N2                                                        BIA
 1707 FORMAT (1X,4H X= ,E20.10,2X,4H N2= ,E20.10)                               BIA
     
C ******************************************************************************
C     CARLO&ALEX: Se si vogliono smussare le oscillazioni numeriche spurie      
C                 allora si devono evitare le divergenze,               
C                 sottostimando l'indice di rifrazione nel vuoto ONE,   
C                 idealmente pari ad 1.,                                
C                 di una varianza infinitesimale paragonabile           
C                 al maximum allowable single step error E1MAX.         
C ******************************************************************************
C      SPACE=N2.EQ.1.                                                    NFNC038
      ONE=1.                                                                    NEW: ALEX
      ONE=ONE-E1MAX                                                             NEW: ALEX
      SPACE=N2.EQ.ONE                                                           NFNC038
C ******************************************************************************
     
      KAY2=(OM2/C2)*N2                                                  NFNC039
      IF(RSTART.EQ.0.) GO TO 1                                          NFNC040
      SCALE=SQRT(KAY2/K2)                                               NFNC041
      KR =SCALE*KR                                                      NFNC042
      KTH=SCALE*KTH                                                     NFNC043
      KPH=SCALE*KPH                                                     NFNC044
  1   CONTINUE                                                          NFNC045
C********* CALCULATES A HAMILTONIAN H                                   NFNC046
      H=.5*(C2*K2/OM2-N2)                                               NFNC047
C********* AND ITS PARTIAL DERIVATIVES WITH RESPECT TO                  NFNC048
C********* TIME, R, THETA, PHI, OMEGA, KR, KTHETA, AND KPHI.            NFNC049
      PHPT =-PNPT                                                       NFNC050
      PHPR =-PNPR                                                       NFNC051
      PHPTH=-PNPTH                                                      NFNC052
      PHPPH=-PNPPH                                                      NFNC053
      PHPOM=-NNP/OM                                                     NFNC054
      PHPKR =C2/OM2*KR                                                  NFNC055
      PHPKTH=C2/OM2*KTH                                                 NFNC056
      PHPKPH=C2/OM2*KPH                                                 NFNC057
      KPHPK=N2                                                          NFNC058
      RETURN                                                            NFNC059
         END                                                            NFNC060-
      SUBROUTINE ELECTX                                                 ELECTX01
C        CALCULATES ELECTRON DENSITY AND GRADIENT FROM ACQUIRED         ELECTX02
C        PROFILES PERFORMING A POLINOMIAL INTERPOLATION                 ELECTX03
C ******************************************************************************
     
      DIMENSION FN2C(600,10,25)                                         
      DIMENSION COE(4),XA(4),YA(4)                                      
      DIMENSION ALPHA(600),BETA(600),GAMMA(600)                         
C      DIMENSION ALPHA(600),BETA(600),GAMMA(600),DELTA(600)              
     
      SAVE ALPHA,BETA,GAMMA                                             
C      SAVE ALPHA,BETA,GAMMA,DELTA                                       
     
      COMMON /ALEX2/ NOC,HPC(600),FNC(600,10,25)                                GPROF000
      COMMON /ZZZZ/ ZZLAT,ZZLON,JLAT,JLON                                       LATLON00
      SAVE LATOLD,LONOLD                                                        LATLON00
     
C ******************************************************************************
C      EQUIVALENCE (XMTRH,W(3)),(RCVRH,W(20))                            ELECTX04
C ******************************************************************************
     
      COMMON /CONST/ PI,PIT2,PID2,DEGS,RAD,K,C,LOGTEN                   ELECTX05
      COMMON /XX/ MODX(2),X,PXPR,PXPTH,PXPPH,PXPT,HMAX                  ELECTX06
      COMMON R(20),T,STP,DRDT(20),N2                                    ELECTX07
      COMMON /WW/ ID,W0,W(400)                                          ELECTX08
      EQUIVALENCE (EARTHR,W(2)),(F,W(6)),(PVOLTA,W(100)),(PERT,W(150))  ELECTX09
C      REAL K                                                            ELECTX10
C ******************************************************************************
     
      F2=F*F                                                            ELECTX11
      MODX(1)=4HGRID                                                    ELECTX12
      IF(PVOLTA.EQ.0.) GO TO 32                                         ELECTX13
      PVOLTA=0.                                                         ELECTX14
      LATOLD=-1.                                                        ELECTX15
      LONOLD=-1.                                                        ELECTX16
C ******************************************************************************
C     ALEX: Lettura file 'GRIDPROFILES.txt',                            
C           scrittura file 'GRIDPROFILES_TEST.txt',                     
C           inizializzazione matrice per "plasma frequency profiles" FNC(K,J,I) 
C ******************************************************************************
      CALL GRIDPROFILES                                                         GPROF000
C ******************************************************************************
   32 ZZLAT=DEGS*(PID2-R(2))                                            ELECTX17
      ZZLON=DEGS*R(3)                                                   ELECTX18
      CALL LATLON                                                       ELECTX19
      IF(JLAT.EQ.LATOLD.AND.JLON.EQ.LONOLD) GO TO 33                    ELECTX20
      IF (JLAT.NE.LATOLD) LATOLD=JLAT                                   ELECTX21
      IF (JLON.NE.LONOLD) LONOLD=JLON                                   ELECTX22
C ******  FIND A PARAMETER TO EXTRAPOLATE THE ELECTRONIC DENSITY   *****ELECTX23
C ******  (BOTTOM PROFILE) NORMALIZE ITS VALUES TO OBTAIN X*F2     *****ELECTX24
C ******   FIND THE HEIGHT OF THE MAXIMUM                ***************ELECTX25
C      IF(FN2C(1,JLAT,JLON).NE.0.)                                               GPROF000
C     1A=ALOG(FN2C(2,JLAT,JLON)/FN2C(1,JLAT,JLON))/(HPC(2)-HPC(1))               GPROF000
      NMAX=1                                                            ELECTX26
      DO NH=1,NOC                                                       
C      FN2C(NH,JLAT,JLON)=K*FN2C(NH,JLAT,JLON)                                   GPROF000
      FN2C(NH,JLAT,JLON)=FNC(NH,JLAT,JLON)**2                                   GPROF000
     
      IF (FNC(NH,JLAT,JLON).GT.FNC(NMAX,JLAT,JLON)) NMAX=NH                     GPROF000
      IF (NH.EQ.NOC) GO TO 4                                            
      ENDDO                                                             
C*******************************************************************************
C     POLINOMIAL INTERPOLATION IN THE INTERVAL OF VALUES FN2C           
C*******************************************************************************
    4 DO 10 I=1,NOC-3                                                   
      DO 22 MP=1,4                                                      
      XA(MP)=HPC(I+MP-1)                                                        GPROF000
C      YA(MP)=FN2C(I+MP-1)                                                       GPROF000
C ******************************************************************************
      YA(MP)=FN2C(I+MP-1,JLAT,JLON)                                             GPROF000
C ******************************************************************************
   22 CONTINUE                                                          
      CALL POLCOE (XA,YA,3,COE)                                         
C      CALL POLCOE (XA,YA,4,COE)                                         
      ALPHA(I)=COE(1)                                                   
      BETA(I)=COE(2)                                                    
      GAMMA(I)=COE(3)                                                   
C      DELTA(I)=COE(4)                                                   
C      WRITE(6,1707)I,ALPHA(I),BETA(I),GAMMA(I),DELTA(I)                 
C 1707 FORMAT (1X,I4,4(2X,E20.10))                                       
   10 CONTINUE                                                          
C ******************************************************************************
      HMAX=HPC(NMAX)                                                    ELECTX27
   33 H=R(1)-EARTHR                                                     ELECTX28
      PXPR=0.                                                           ELECTX29
      IF (H.GE.HPC(1)) GO TO 12                                         ELECTX30
      X=0.                                                              ELECTX31
C      IF(FN2C(1,JLAT,JLON).EQ.0.) GO TO 50                                      GPROF000
C      X=FN2C(1,JLAT,JLON)*EXP(A*(H-HPC(1)))/F2                                  GPROF000
C      PXPR=A*X                                                          ELECTX32
      GO TO 50                                                          ELECTX33
   12 IF (H.GE.HPC(NOC)) GO TO 18                                       ELECTX34
      NH=2                                                              ELECTX35
      NSTEP=1                                                           ELECTX36
      IF (H.LT.HPC(NH-1)) NSTEP=-1                                      ELECTX37
   15 IF (HPC(NH-1).LE.H.AND.H.LT.HPC(NH)) GO TO 16                     ELECTX38
      NH=NH+NSTEP                                                       ELECTX39
      GO TO 15                                                          ELECTX40
C ******************************************************************************
C     LINEAR INTERPOLATION IN THE INTERVAL FN2C(K-1,J,I) AND FN2C(K,J,I)
C ******************************************************************************
C   16 X=(ALPHA(NH-1)+BETA(NH-1)*H)/F2                                   
C      PXPR=(BETA(NH-1))/F2                                              
C ******************************************************************************
C     POLINOMIAL INTERPOLATION IN THE INTERVAL FN2C(K-1,J,I) AND FN2C(K,J,I)    
C ******************************************************************************
   16 X=(ALPHA(NH-1)+BETA(NH-1)*H+GAMMA(NH-1)*H**2)/F2                  
      PXPR=(BETA(NH-1)+H*(2.*GAMMA(NH-1)))/F2                           
C   16 X=(ALPHA(NH-1)+BETA(NH-1)*H+GAMMA(NH-1)*H**2+DELTA(NH-1)*H**3)/F2 
C      PXPR=(BETA(NH-1)+H*(2.*GAMMA(NH-1))+H**2*(3.*DELTA(NH-1)))/F2     
C ******************************************************************************
     
      GO TO 50                                                          ELECTX41
   18 X=FN2C(NOC,JLAT,JLON)/F2                                                  GPROF000
   50 IF (PERT.NE.0.) CALL ELECT1                                       ELECTX42
     
C*******************************************************************************
C     ALEX: Si è risolto un BUG                                         
C           dovuto ad una condizione troppo restrittiva per cui         
C           la stampa su schermo                                        
C           delle coordinate per il raggio d'onda R(1),R(2),R(3)        
C           avveniva solo quando                                        
C           il trasmettitore era più in alto del ricevitore,            
C           i.e., H.GE.RCVRH .                                          
C*******************************************************************************
C      IF (X.EQ.0..AND.H.GE.RCVRH) PRINT 1234, R(1),R(2),R(3)            ELECTX43
      IF (X.EQ.0.) PRINT 1234, R(1),R(2),R(3)                                   AZZ
C*******************************************************************************
     
 1234 FORMAT (3(2X,F20.10))                                             ELECTX44
      WRITE(6,1704) R(1),R(2),R(3),R(4),R(5),R(6)                       ELECTX45
 1704 FORMAT (6(2X,F20.10))                                             ELECTX46
      RETURN                                                            ELECTX47
      END                                                               -
      SUBROUTINE LATLON                                                 LATLON01
C*******************************************************************************
     
      COMMON /ZZZZ/ ZZLAT,ZZLON,JLAT,JLON                               LATLON02
     
      COMMON /ALEX1/ NLAT,NLON,LAT(10),LON(25)                                  GPROF000
C*******************************************************************************
     
      JL=0                                                              LATLON03
      JU=NLAT+1                                                                 GPROF000
   10 IF(JU-JL.GT.1)THEN                                                LATLON04
      JM=(JU+JL)/2                                                      LATLON05
      IF(LAT(NLAT).GT.LAT(1).EQV.(ZZLAT.GT.LAT(JM)))THEN                        GPROF000
         JL=JM                                                          LATLON06
      ELSE                                                              LATLON07
         JU=JM                                                          LATLON08
      ENDIF                                                             LATLON09
      GO TO 10                                                          LATLON10
      ENDIF                                                             LATLON11
      JLAT=JL                                                           LATLON12
      JLO=0                                                             LATLON13
      JUO=NLON+1                                                                GPROF000
   11 IF(JUO-JLO.GT.1)THEN                                              LATLON14
      JMO=(JUO+JLO)/2                                                   LATLON15
      IF(LON(NLON).GT.LON(1).EQV.(ZZLON.GT.LON(JMO)))THEN                       GPROF000
        JLO=JMO                                                         LATLON16
      ELSE                                                              LATLON17
         JUO=JMO                                                        LATLON18
      ENDIF                                                             LATLON19
      GO TO 11                                                          LATLON20
      ENDIF                                                             LATLON21
      JLON=JLO                                                          LATLON22
      WRITE(6,998)JLAT,JLON                                             LATLON23
  998 FORMAT (2(1X,I4))                                                 LATLON24
      RETURN                                                            LATLON25
      END                                                               -
      SUBROUTINE POLCOE(X,Y,N,COF)                                      POLCOE01
      PARAMETER(NMAX=15)                                                POLCOE02
      DIMENSION X(4),Y(4),COF(4),S(NMAX)                                POLCOE03
      DO 11 I=1,N                                                       POLCOE04
      S(I)=0                                                            POLCOE05
      COF(I)=0                                                          POLCOE06
   11 CONTINUE                                                          POLCOE07
      S(N)= -X(1)                                                       POLCOE08
      DO 13 I=2,N                                                       POLCOE09
      DO 12 J=N+1-I,N-1                                                 POLCOE10
      S(J)=S(J)-X(I)*S(J+1)                                             POLCOE11
   12 CONTINUE                                                          POLCOE12
      S(N)=S(N)-X(I)                                                    POLCOE13
   13 CONTINUE                                                          POLCOE14
      DO 16 J=1,N                                                       POLCOE15
      PHI=N                                                             POLCOE16
      DO 14 K=N-1,1,-1                                                  POLCOE17
      PHI=K*S(K+1)+X(J)*PHI                                             POLCOE18
   14 CONTINUE                                                          POLCOE19
      FF=Y(J)/PHI                                                       POLCOE20
      B=1.                                                              POLCOE21
      DO 15 K=N,1,-1                                                    POLCOE22
      COF(K)=COF(K)+B*FF                                                POLCOE23
      B=S(K)+X(J)*B                                                     POLCOE24
   15 CONTINUE                                                          POLCOE25
   16 CONTINUE                                                          POLCOE26
      RETURN                                                            POLCOE27
      END                                                               -
      SUBROUTINE ELECT1                                                 ELEC001
C          USE WHEN AN ELECTRON DENSITY PERTURBATION IS NOT WANTED      ELEC002
      COMMON /XX/ MODX(2),X(6)                                          ELEC003
      COMMON /WW/ ID,W0,W(400)                                          ELEC004
      EQUIVALENCE (PERT,W(150))                                         ELEC005
      MODX(2)=4HNONE                                                    ELEC006
      PERT=0.                                                           ELEC007
      RETURN                                                            ELEC008
      END                                                               ELEC009-
C*******************************************************************************
C     ADRIANO: Subroutine che stampa su schermo                         
C              la coordinata speciale '000.0 0 0'                       
C              per eseguire il necessario split degli step              
C              alla fine di ogni elaborazione in MATLAB.                
C*******************************************************************************
      SUBROUTINE ZERO                                                   ZERO000
      PRINT *,'000.0 0 0'                                               ZERO000
      RETURN                                                            ZERO000
      END                                                               -
