# Descrição
Cinco equipamentos extraem uma base de informações de configuração. Todos são arquivos texto de extensão “.txt”, separados por ponto e vírgula “;” iniciado por um mesmo prefixo de máscara no nome. Estes arquivos devem ser inseridos em uma única tabela em SGBD Teradata. Para este processo, o projeto utiliza o utilitário Teradadata MultLoad que realiza a carga por comandos em script. A tabela a ser atualizada é deleta completamente para receber a nova carga com a “foto” mais recente.
O Exemplo deste projeto é para atender esta necessidade. O script batch é programado em um schedule e periodicamente é executado atualizando a base informacional. 

# Configuração
Três arquivos devem ser modificados para execução:
1.	EXEC_CARGA_TERADATA.bat
2.	SCRIPT_MLD.bat
3.	LIMPA_TAB_HLR.bteq
4.	PREPARA_CARGA.bteq

### EXEC_CARGA_TERADATA.bat
Script que executa um loop, passando os arquivos extraídos para o próximo script que fará o load do arquivo, acrescentando na base. Modificar a máscara de do arquivo de forma que ele coloque na fila todos os arquivos que vão ser carregados. Os arquivos devem ter um padrão comum para serem identificados.

### SCRIPT_MLD.bat
Script que escreve o arquivo script.mdl que será utilizado pelo MLOD. 
1.	Trocar o host, usuário e  senha de acesso ao BD. Similar a uma string de conexão.
2.	Trocar todas as palavras TABELA pelo nome da tabela a ser carregada. Atenção parao fato de que tem tabelas _LOG, _UV, _lay, etc. Todas essas também devem ser trocadas para o mesmo nome da tabela mantendo os sufixos.
3.	Trocar todas as palavras BD pelo nome do banco onde está a tabela.
4.	Trocar os campos da estrutura da tabela na ordem que está criado.
5.	SE o separador não for ponto e vírgula (;) , trocar na linha indicada no script.

### LIMPA_TAB_HLR.bteq
Este arquivo prepara a carga, deletando todo o conteúdo da tabela para receber a nova carga. __IMPORTANTE__ observar o cenário para o qual foi pensado. Caso não deseje deletar os dados anteriores, criando um histórico, o script deverá ser modificado sem executar este passo.
1.	Trocar o host, usuário e senha de acesso ao BD. Similar a uma string de conexão.
2.	Trocar o nome da tabela que será deletada e posteriormente carregada. 

### PREPARA_CARGA.bteq
Este arquivo prepara a carga, garantindo que estas tabelas não estão criadas no schema do BD. Caso ela exista, será reportado erro e a carga para no meio do caminho, escrevendo o motivo no log.
1.	Trocar o host, usuário e senha de acesso ao BD. Similar a uma string de conexão.
2.	Trocar o nome da tabela que será deletada mantendo os sufixos _LOG, _UV, _ET, _WT.

# Execução
Feito todas a alterações, deve ser executado somente o script  EXEC_CARGA_TERADATA.bat. Todos os demais serão executados e utilizados automaticamente. Este script pode ser programa do em schedule, rodando periodicamente e acompanhado sua execução através do log.

 


