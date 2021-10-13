//RODDI01A JOB (124300000),'MBDEMO',CLASS=A,MSGCLASS=X,MSGLEVEL=(1,1),
//           NOTIFY=&SYSUID                                           
//**--------------------------------------                            
//RENAME   EXEC PGM=IKJEFT01,COND=(0,NE)                              
//SYSTSPRT DD SYSOUT=*                                                
//SYSTSIN  DD *                                                       
TSS LIST(RODDI01)DATA(ALL)                                            