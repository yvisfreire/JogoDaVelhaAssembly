; Hello World - Escreve mensagem armazenada na memoria na tela


; ------- TABELA DE CORES -------
; adicione ao caracter para Selecionar a cor correspondente

; 0 branco							0000 0000
; 256 marrom						0001 0000
; 512 verde							0010 0000
; 768 oliva							0011 0000
; 1024 azul marinho					0100 0000
; 1280 roxo							0101 0000
; 1536 teal							0110 0000
; 1792 prata						0111 0000
; 2048 cinza						1000 0000
; 2304 vermelho						1001 0000
; 2560 lima							1010 0000
; 2816 amarelo						1011 0000
; 3072 azul							1100 0000
; 3328 rosa							1101 0000
; 3584 aqua							1110 0000
; 3840 preto						1111 0000


jmp main

linhaVazia: string "___"

jogadorAtual: var #1
static jogadorAtual + #0, #'X' ; Começa com o jogador X

tabuleiro: var #9
static tabuleiro + #0, #0
static tabuleiro + #1, #0
static tabuleiro + #2, #0
static tabuleiro + #3, #0
static tabuleiro + #4, #0
static tabuleiro + #5, #0
static tabuleiro + #6, #0
static tabuleiro + #7, #0
static tabuleiro + #8, #0

espacosOcupados: var #1
static espacosOcupados + #0, #0

strVezJogador: string "- Sua vez!"
strVelha: string "Deu velha!" 
strVencedor: string "ganhou!      "	; espaços extras para facilitar formatação
strResetStr: string "Aperte espaco para reiniciar!"
apagaString: string "                             "

;---- Inicio do Programa Principal -----
main:
	call inicia_tabuleiro
	call game_loop
	
	halt	; Fim do programa - Para o Processador
	
;---- Fim do Programa Principal -----
	
;---- Inicio das Subrotinas -----
	
game_loop:
	jmp imprimeVezJogador
	
	input_loop:
		inchar r0
		loadn r1, #255
		
		cmp r0, r1		; reseta o loop enquanto nao receber input
		jeq input_loop
			
		loadn r1, #57 	; maior que '9'
		cmp r0, r1
		jgr input_loop
		loadn r1, #49 	; menor que '1'
		cmp r0, r1
		jle input_loop
	
	call posValida

	printJogada:
		; printa jogador atual na posicao dada pelo usuario
		load r1, jogadorAtual
		outchar r1, r2
		
		load r1, espacosOcupados
		inc r1
		store espacosOcupados, r1	; incrementa o total de espaços ocupados
		
	checkVitoria:
		loadn r4, #0
		call checkVitoriaLinhas

	trocaJogador:	
		; troca de jogador
		loadn r2, #'X'
		load r3, jogadorAtual
		cmp r2, r3
		jeq setJogadorO
		
		loadn r2, #'O'
		load r3, jogadorAtual
		cmp r2, r3
		jeq setJogadorX

imprimeVezJogador:
	load r4, jogadorAtual
	loadn r3, #160
	outchar r4, r3

	loadn r0, #162	; posicao
	loadn r1, #strVezJogador	; string
	loadn r2, #0 	; cor branca
	call Imprimestr
	jmp input_loop

checkVitoriaLinhas:
	loadn r0, #tabuleiro
	add r0, r0, r4
	loadi r1, r0	; indice 0 do tabuleiro
	
	loadn r2, #0
	cmp r1, r2		; checa se é vazio
	jeq pulaLinha
	 
	mov r5, r4
	inc r5
	add r0, r0, r5 
	loadi r2, r0  	; pega a posicao adjacente e comapara
	cmp r1, r2
	jne pulaLinha
	
	mov r5, r4
	inc r5
	add r0, r0, r5 
	loadi r3, r0  	; pega a posicao adjacente e comapara
	cmp r2, r3
	jne pulaLinha
	
	jmp vitoria

pulaLinha:
	loadn r5, #3	; pula uma linha no tabuleiro
	add r4, r4, r5
	loadn r5, #9
	cmp r4, r5
	jle checkVitoriaLinhas
	
	loadn r4, #0
	jmp checkVitoriaColunas
	
checkVitoriaColunas:
	loadn r0, #tabuleiro
	add r0, r0, r4
	loadi r1, r0	; indice 0 do tabuleiro
	
	loadn r2, #0
	cmp r1, r2		; checa se é vazio
	jeq pulaColuna
	 
	loadn r5, #3
	add r0, r0, r5 
	loadi r2, r0  	; pega a posicao adjacente e comapara
	cmp r1, r2
	jne pulaColuna
	
	loadn r5, #3
	add r0, r0, r5 
	loadi r3, r0  	; pega a posicao adjacente e comapara
	cmp r2, r3
	jne pulaColuna
	
	jmp vitoria

pulaColuna:
	inc r4		; pula uma coluna no tabuleiro
	loadn r5, #3
	cmp r4, r5
	jle checkVitoriaColunas
	
	loadn r4, #0
	jmp checkVitoriaDiagonais
	
checkVitoriaDiagonais:
	checkDiagonal1:
		loadn r0, #tabuleiro
		add r0, r0, r4
		loadi r1, r0	; indice 0 do tabuleiro
		
		loadn r2, #0
		cmp r1, r2		; checa se é vazio
		jeq semVitoriaDiagonal
		 
		loadn r5, #4
		add r0, r0, r5 
		loadi r2, r0  	; pega a posicao adjacente e comapara
		cmp r1, r2
		jne semVitoriaDiagonal
		
		loadn r5, #4
		add r0, r0, r5 
		loadi r3, r0  	; pega a posicao adjacente e comapara
		cmp r2, r3
		jne semVitoriaDiagonal
		
		jmp vitoria
	
	checkDiagonal2:
		loadn r0, #tabuleiro
		add r0, r0, r4
		loadi r1, r0	; indice 0 do tabuleiro
		
		loadn r2, #0
		cmp r1, r2		; checa se é vazio
		jeq semVitoriaDiagonal
		 
		loadn r5, #2
		add r0, r0, r5 
		loadi r2, r0  	; pega a posicao adjacente e comapara
		cmp r1, r2
		jne semVitoriaDiagonal
		
		loadn r5, #2
		add r0, r0, r5 
		loadi r3, r0  	; pega a posicao adjacente e comapara
		cmp r2, r3
		jne semVitoriaDiagonal
		
		jmp vitoria				
	

semVitoriaDiagonal:
	inc r4			; pula pra diagonal secundaria do tabuleiro
	inc r4
	loadn r5, #4
	cmp r4, r5
	jle checkDiagonal2
	
	jmp checkVelha	; verifica se deu velha quando não houve vitória em nenhum dos casos

checkVelha:
;	jmp trocaJogador
	loadn r4, #9	; ocupação máxima do tabuleiro
	load r5, espacosOcupados
	cmp r4, r5
	jne trocaJogador
	
	jmp velha
	
velha:
	loadn r0, #160	; posicao
	loadn r1, #strVelha	; string
	loadn r2, #0 	; cor branca
	call Imprimestr
	
	loadn r0, #200	; posicao
	loadn r1, #strResetStr	; string
	loadn r2, #0 	; cor branca
	call Imprimestr
	
	inchar r0
	loadn r1, #' '
	
	cmp r0, r1
	jne velha
	
	loadn r0, #160	; posicao
	loadn r1, #apagaString	; string
	loadn r2, #0 	; cor branca
	call Imprimestr
	
	loadn r0, #200	; posicao
	loadn r1, #apagaString	; string
	loadn r2, #0 	; cor branca
	call Imprimestr
	
	loadn r0, #tabuleiro
	loadn r1, #0	; vazio
	loadn r2, #1	; incremento
	
	; atribui zero para todas posições do vetor
	storei r0, r1
	add r0, r0, r2
	
	storei r0, r1
	add r0, r0, r2
	
	storei r0, r1
	add r0, r0, r2
	
	storei r0, r1
	add r0, r0, r2
	
	storei r0, r1
	add r0, r0, r2
	
	storei r0, r1
	add r0, r0, r2
	
	storei r0, r1
	add r0, r0, r2

	storei r0, r1
	add r0, r0, r2
	
	storei r0, r1
	add r0, r0, r2
	
	loadn r0, #'X'
	store jogadorAtual, r0
	
	loadn r0, #0
	store espacosOcupados, r0
	
	jmp main
	
vitoria:
	load r4, jogadorAtual
	loadn r3, #160
	outchar r4, r3
	
	loadn r0, #162	; posicao
	loadn r1, #strVencedor	; string
	loadn r2, #0 	; cor branca
	call Imprimestr
	
	loadn r0, #200	; posicao
	loadn r1, #strResetStr	; string
	loadn r2, #0 	; cor branca
	call Imprimestr
	
	inchar r0
	loadn r1, #' '
	
	cmp r0, r1
	jne vitoria
	
	loadn r0, #160	; posicao
	loadn r1, #apagaString	; string
	loadn r2, #0 	; cor branca
	call Imprimestr
	
	loadn r0, #200	; posicao
	loadn r1, #apagaString	; string
	loadn r2, #0 	; cor branca
	call Imprimestr
	
	loadn r0, #tabuleiro
	loadn r1, #0	; vazio
	loadn r2, #1	; incremento
	
	; atribui zero para todas posições do vetor
	storei r0, r1
	add r0, r0, r2
	
	storei r0, r1
	add r0, r0, r2
	
	storei r0, r1
	add r0, r0, r2
	
	storei r0, r1
	add r0, r0, r2
	
	storei r0, r1
	add r0, r0, r2
	
	storei r0, r1
	add r0, r0, r2
	
	storei r0, r1
	add r0, r0, r2

	storei r0, r1
	add r0, r0, r2
	
	storei r0, r1
	add r0, r0, r2
	
	loadn r0, #'X'
	store jogadorAtual, r0
	
	loadn r0, #0
	store espacosOcupados, r0
	
	jmp main

; verifica se a posicao dada pelo usuario é valida
posValida:
	mov r1, r0
	loadn r3, #'0'
	
	sub r1, r1, r3 	; numero entre 1 e 9
	dec r1		   	; numero entre 0 e 8
	
	loadn r2, #tabuleiro
	add r2, r2, r1 	; r2 recebe endereco da posicao no vetor
	
	loadi r1, r2	; r1 recebe o conteudo do endereco em r2
	loadn r3, #0
	cmp r1, r3		; reinicia o input caso posicao esteja ocupada
	jne game_loop
	
	load r1, jogadorAtual
	storei r2, r1	; preenche a pos do vetor com a letra do jogador
	
	jmp getPosicaoTela
	

getPosicaoTela:
	loadn r3, #'4'
	cmp r0, r3
	jle p123
	
	loadn r3, #'7'
	cmp r0, r3
	jle p456
	
	loadn r3, #':'	; char logo apos o '9'
	cmp r0, r3
	jle p789
	
	; atribui posicao 1, 2 ou 3 pro r2
	p123:
		mov r2, r0
		loadn r3, #'0'
		
		sub r2, r2, r3 	; char - '0' = 1, 2 ou 3
		dec r2		   	; 0, 1 ou 2 
		jmp printJogada
	
	; atribui posicao 4, 5 ou 6 pro r2
	p456:
		mov r2, r0
		loadn r3, #'3'
		
		sub r2, r2, r3	; char - '0' = 1, 2 ou 3
		loadn r3, #40
		
		add r2, r2, r3
		dec r2			; 40, 41 ou 42
		jmp printJogada
	
	; atribui posicao 4, 5 ou 6 pro r2
	p789:
		mov r2, r0
		loadn r3, #'6'
		
		sub r2, r2, r3	; char - '0' = 1, 2 ou 3
		loadn r3, #80
		
		add r2, r2, r3
		dec r2			; 80, 81 ou 82
		jmp printJogada

setJogadorX:
	loadn r2, #'X'
	store jogadorAtual, r2
	jmp game_loop

setJogadorO:
	loadn r2, #'O'
	store jogadorAtual, r2
	jmp game_loop
	
inicia_tabuleiro:
	loadn r0, #0			; Posicao na tela onde a mensagem sera' escrita
	loadn r1, #linhaVazia	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #256			; Seleciona a COR da Mensagem
	
	call Imprimestr
	
	loadn r0, #40			; Posicao na tela onde a mensagem sera' escrita
	loadn r1, #linhaVazia	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #256			; Seleciona a COR da Mensagem
	
	call Imprimestr   	
	
	loadn r0, #80			; Posicao na tela onde a mensagem sera' escrita
	loadn r1, #linhaVazia	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #256			; Seleciona a COR da Mensagem
	
	call Imprimestr   	   	
		
	
Imprimestr:		;  Rotina de Impresao de Mensagens:    
				; r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso
				; r1 = endereco onde comeca a mensagem
				; r2 = cor da mensagem
				; Obs: a mensagem sera' impressa ate' encontrar "/0"
				
;---- Empilhamento: protege os registradores utilizados na subrotina na pilha para preservar seu valor				
	push r0	; Posicao da tela que o primeiro caractere da mensagem sera' impresso
	push r1	; endereco onde comeca a mensagem
	push r2	; cor da mensagem
	push r3	; Criterio de parada
	push r4	; Recebe o codigo do caractere da Mensagem
	
	loadn r3, #'\0'	; Criterio de parada

ImprimestrLoop:	
	loadi r4, r1		; aponta para a memoria no endereco r1 e busca seu conteudo em r4
	cmp r4, r3			; compara o codigo do caractere buscado com o criterio de parada
	jeq ImprimestrSai	; goto Final da rotina
	add r4, r2, r4		; soma a cor (r2) no codigo do caractere em r4
	outchar r4, r0		; imprime o caractere cujo codigo está em r4 na posicao r0 da tela
	inc r0				; incrementa a posicao que o proximo caractere sera' escrito na tela
	inc r1				; incrementa o ponteiro para a mensagem na memoria
	jmp ImprimestrLoop	; goto Loop
	
ImprimestrSai:	
;---- Desempilhamento: resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r4	
	pop r3
	pop r2
	pop r1
	pop r0
	rts		; retorno da subrotina