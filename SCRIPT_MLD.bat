REM ESCREVE O ARQUILO MULTILOAD E O CHAMA A SEGUIR PARA REALIZAÇÃO DA CARGA
REM MOVE O ARQUIVO CARREGADO PARA UMA PASTA RECEM CRIADA.
REM TROCAR A PALAVRA TABELA PELO NOME DA TABELA QUE SERÁ CARREGADA. TABELAS DE LOG, WT, ET, UV SERÃO CRIADAS

ECHO  .logtable BD.TABELA_LOG; 			>script.mld
ECHO  .dateform ansidate;				>>script.mld

REM ############## TROCAR SERVIDOR USUARIO E SENHA ; #####################################
ECHO  .logon HOST/USER,PASS;			>>script.mld

ECHO  .begin import mload				>>script.mld
ECHO   tables							>>script.mld
ECHO     BD.TABELA						>>script.mld
ECHO   Worktables						>>script.mld
ECHO     BD.TABELA_WT					>>script.mld
ECHO   Errortables						>>script.mld
ECHO     BD.TABELA_ET					>>script.mld
ECHO     BD.TABELA_UV					>>script.mld
ECHO  sessions 100;						>>script.mld

ECHO  .layout TABELA_lay;				>>script.mld
ECHO    .field CAMPO1 * VARCHAR(255);	>>script.mld
ECHO    .field CAMPO2 * VARCHAR(255);	>>script.mld
ECHO    .field CAMPO3 * VARCHAR(255);	>>script.mld
ECHO    .field CAMPO4 * VARCHAR(255);	>>script.mld
ECHO    .field CAMPON * VARCHAR(255);	>>script.mld

ECHO .dml label TABELA_ins;				>>script.mld

ECHO INSERT INTO BD.TABELA  			>>script.mld
ECHO (									>>script.mld
ECHO    CAMPO1							>>script.mld
ECHO   ,CAMPO2							>>script.mld
ECHO   ,CAMPO3							>>script.mld
ECHO   ,CAMPO4							>>script.mld
ECHO   ,CAMPON							>>script.mld
ECHO )                                  >>script.mld
ECHO VALUES                             >>script.mld
ECHO (									>>script.mld
ECHO    :CAMPO1							>>script.mld
ECHO   ,:CAMPO2							>>script.mld
ECHO   ,:CAMPO3							>>script.mld
ECHO   ,:CAMPO4							>>script.mld
ECHO   ,:CAMPON							>>script.mld
ECHO );									>>script.mld

ECHO .import infile .\%1				>>script.mld

REM ############## SEPARADOR DO ARQUIVO DEVE SER TROCADO AQUI CASO NÃO SEJA ; #####################################
ECHO format VARTEXT ';'					>>script.mld
ECHO layout TABELA_lay					>>script.mld
ECHO apply  TABELA_ins;					>>script.mld

ECHO .end mload;						>>script.mld
ECHO .logoff;							>>script.mld

REM PREPARA A CARGA DELETANDO OS ARQUIVOS LOG WT UV ET. SE ESTES ARQUIVOS NÃO FORAEM DELETADOS O MLOAD REPORTA ERRO
BTEQ <PREPARA_CARGA.btq > PREPARA_CARGA.log

REM CARREGA O ARQUIVO COM O SCRIPT ESCRITO ANTERIORMENTE
MLOAD <script.mld >.\%1.logmload

REM MOVE OS ARUIVOS JA CARREGADOS
MOVE %1 .\Carregado\%1
