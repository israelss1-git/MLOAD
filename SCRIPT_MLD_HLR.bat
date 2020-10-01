REM ESCREVE O ARQUILO MULTILOAD E O CHAMA A SEGUIR PARA REALIZAÇÃO DA CARGA
REM MOVE O ARQUIVO CARREGADO PARA UMA PASTA RECEM CRIADA.

ECHO  .logtable D_GR.RA_HLR_WRKS_IMSI_LOG;     				 >script.mld
ECHO  .dateform ansidate;                      				>>script.mld
ECHO  .logon HOST/USER,PASS;        						>>script.mld

ECHO  .begin import mload                      				>>script.mld
ECHO   tables                                  				>>script.mld
ECHO     D_GR.RA_HLR_WRKS_IMSI                 				>>script.mld
ECHO   Worktables                              				>>script.mld
ECHO     D_GR.RA_HLR_WRKS_IMSI_WT              				>>script.mld
ECHO   Errortables                             				>>script.mld
ECHO     D_GR.RA_HLR_WRKS_IMSI_ET              				>>script.mld
ECHO     D_GR.RA_HLR_WRKS_IMSI_UV              				>>script.mld
ECHO  sessions 100;                            				>>script.mld

ECHO  .layout RA_HLR_WRKS_IMSI_lay;     					>>script.mld
ECHO    .field IMSI                        * VARCHAR(255);  >>script.mld
ECHO    .field MSISDN                      * VARCHAR(255);  >>script.mld
ECHO    .field DESATIVADO                  * VARCHAR(255);  >>script.mld
ECHO    .field SUBS_BS_GROUP               * VARCHAR(255);  >>script.mld
ECHO    .field BSERV_TYPE_BS_INDEX         * VARCHAR(255);  >>script.mld
ECHO    .field BSERV_TYPE_BASIC_SERVICE_ID * VARCHAR(255);  >>script.mld
ECHO    .field PLANO                       * VARCHAR(255);  >>script.mld
ECHO    .field ISDN_ADDRESS                * VARCHAR(255);  >>script.mld
ECHO    .field HLR                         * VARCHAR(255);  >>script.mld
ECHO    .field VLR_ADDRESS                 * VARCHAR(255);  >>script.mld

ECHO .dml label RA_HLR_WRKS_IMSI_ins;   					>>script.mld
					
ECHO INSERT INTO D_GR.RA_HLR_WRKS_IMSI  					>>script.mld
ECHO (                                  					>>script.mld
ECHO    IMSI                            					>>script.mld
ECHO   ,MSISDN                          					>>script.mld
ECHO   ,DESATIVADO                      					>>script.mld
ECHO   ,SUBS_BS_GROUP                   					>>script.mld
ECHO   ,BSERV_TYPE_BS_INDEX             					>>script.mld
ECHO   ,BSERV_TYPE_BASIC_SERVICE_ID     					>>script.mld
ECHO   ,PLANO                           					>>script.mld
ECHO   ,ISDN_ADDRESS                    					>>script.mld
ECHO   ,HLR                             					>>script.mld
ECHO   ,VLR_ADDRESS                     					>>script.mld
ECHO )                                  					>>script.mld
ECHO VALUES                             					>>script.mld
ECHO (                                  					>>script.mld
ECHO    :IMSI                           					>>script.mld
ECHO   ,:MSISDN                         					>>script.mld
ECHO   ,:DESATIVADO                     					>>script.mld
ECHO   ,:SUBS_BS_GROUP                  					>>script.mld
ECHO   ,:BSERV_TYPE_BS_INDEX            					>>script.mld
ECHO   ,:BSERV_TYPE_BASIC_SERVICE_ID    					>>script.mld
ECHO   ,:PLANO                          					>>script.mld
ECHO   ,:ISDN_ADDRESS                   					>>script.mld
ECHO   ,:HLR                            					>>script.mld
ECHO   ,:VLR_ADDRESS                    					>>script.mld
ECHO );                                 					>>script.mld

ECHO .import infile .\%1     								>>script.mld

ECHO format VARTEXT ';'                						>>script.mld
ECHO layout RA_HLR_WRKS_IMSI_lay   							>>script.mld
ECHO apply  RA_HLR_WRKS_IMSI_ins;  							>>script.mld

ECHO .end mload;                       						>>script.mld
ECHO .logoff;                          						>>script.mld

REM PREPARA A CARGA DELETANDO OS ARQUIVOS LOG WT UV ET. SE ESTES ARQUIVOS NÃO FORAEM DELETADOS O MLOAD REPORTA ERRO
BTEQ <PREPARA_CARGA_HLR.btq > PREPARA_CARGA_HLR.log                                                         

REM CARREGA O ARQUIVO COM O SCRIPT ESCRITO ANTERIORMENTE
MLOAD <script.mld >.\%1.logmload

REM MOVE OS ARUIVOS JA CARREGADOS
MOVE %1 .\Carregado\%1
