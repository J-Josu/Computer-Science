const
	MAXF= 9;
	MAXC= 2;
	MAXNB= 99;
	MAXNC= 15;
	MAXP= 20;


type
	columnaBolillero= array[0..9] of string[34];
	
	matrizNumero= array[3..8] of string[6];
	vectorMatrizNumeros= array[0..9] of matrizNumero;
	
	casilla= record
		num: integer;
		estado: integer;
	end;
	columna= array[0..MAXC] of casilla;
	matrizCarton= array[0..MAXF] of columna;
	
	jugador= record
		nombre: string;
		puntos: integer;
		nAcertados: integer;
		nFullCartones: integer;
		carton: matrizCarton;
	end;

	listaJugadores= ^nodoJ;

	nodoJ= record
		dato: jugador;
		sig: listaJugadores;
	end;

	fila= array[0..MAXF] of integer;
	numeros0A99= array[0..MAXNB] of boolean;
	vHacerMinuscula= array['A'..'Z'] of char;
	integerToLetter= array[0..9] of char;
	integerToInteger= array['0'..'9'] of integer;
	



// VARIABLES GLOBALES
var
	vITL: integerToLetter;
	vITI: integerToInteger;
	bAplicacion,bJugar,bPartida: boolean;
	modoJuego: integer;
	nRonda,nBots,nBolilla: integer;
	lJ,lJUser: listaJugadores;
	vHacerMinus: vHacerMinuscula;
	vN0A99: numeros0A99;
	marcoS,marcoI,marcoM: string;
	nombreSala,nombreUser: string;
	mBV,mBD,mBI: columnaBolillero;
	vMN: vectorMatrizNumeros;
	cB,cA,cC: char;

// MODULOS
// Setear configuraciones Defaults
procedure iniciarVITIVITL();
	var
		i: char;
		n: integer;
	begin
		n:=-1;
		for i:='0' to '9' do begin
			n:= n +1;
			vITI[i]:= n;
			vITL[n]:= i;
		end;
	end;

procedure setearMarcos();
	var
		i,tamBorde: integer;
	begin
		marcoS:= chr(218);
		marcoM:= chr(195);
		marcoI:= chr(192);
		tamBorde:= (MAXF+1)*4 +MAXF;
		for i:=1 to tamBorde  do begin
			if (i mod 5)= 0 then begin
				marcoS:= marcoS + chr(194);
				marcoM:= marcoM + chr(197);
				marcoI:= marcoI + chr(193);
			end
			else begin
				marcoS:= marcoS + chr(196);
				marcoM:= marcoM + chr(196);
				marcoI:= marcoI + chr(196);
			end;
		end;
		marcoS:= marcoS + chr(191);
		marcoM:= marcoM + chr(180);
		marcoI:= marcoI + chr(217);
	end;

procedure setearVHacerMinus();
	var
		i: char;
		n: integer;
	begin
		n:=0;
		for i:= 'a' to 'z' do begin
			n:= n+1;
			vHacerMinus[chr(64 +n)]:= i;
		end;
	end;

procedure iniciarMBVacia();
	var
		nColumna: integer;
	begin
		for nColumna:= 0 to 9 do
			mBV[nColumna]:='';
	end;
procedure inciarCaracteres();
	begin
		cB:= chr(220);
		cA:= chr(223);
		cC:= chr(219);
	end;
procedure iniciarMBDibujado();
	begin
		mBD[0]:= '     '+chr(218)+chr(196)+chr(196)+chr(196)+chr(196)+chr(196)+chr(196)+chr(191)+'                     ';
		mBD[1]:= '   '+chr(218)+chr(196)+chr(217)+'o     '+chr(192)+chr(196)+chr(191)+'                   ';
		mBD[2]:= '  '+chr(218)+chr(217)+'    o  o  '+chr(192)+chr(191)+'                  ';
		mBD[3]:= '  '+chr(179)+' o        o '+chr(179)+'                  ';
		mBD[4]:= '  '+chr(179)+'   o  o     '+chr(179)+'                  ';
		mBD[5]:= '  '+chr(192)+chr(196)+chr(191)+'   oo  o'+chr(218)+chr(196)+chr(217)+'                  ';
		mBD[6]:= '    '+chr(192)+chr(196)+chr(191)+'o   '+chr(218)+chr(196)+chr(217)+'                    ';
		mBD[7]:= '   '+chr(201)+chr(205)+chr(205)+chr(202)+chr(205)+chr(205)+chr(205)+chr(205)+chr(202)+chr(205)+chr(205)+chr(187)+'                   ';
		mBD[8]:= '   '+chr(186)+'    '+chr(192)+chr(217)+'    '+chr(186)+'                   ';
		mBD[9]:= '   '+chr(200)+chr(205)+chr(205)+chr(205)+chr(205)+chr(205)+chr(205)+chr(205)+chr(205)+chr(205)+chr(205)+chr(188)+'                   ';
	end;
procedure iniciarVMN();
	begin
		vMN[0][3]:= chr(218)+chr(196)+chr(196)+chr(196)+chr(196)+chr(191);
		vMN[0][4]:= chr(179)+'    '+chr(179);
		vMN[0][5]:= vMN[0][4];
		vMN[0][6]:= vMN[0][4];
		vMN[0][7]:= vMN[0][4];
		vMN[0][8]:= chr(192)+chr(196)+chr(196)+chr(196)+chr(196)+chr(217);
		
		vMN[1][3]:= '     '+chr(191);
		vMN[1][4]:= '     '+chr(179);
		vMN[1][5]:= vMN[1][4];
		vMN[1][6]:= vMN[1][4];
		vMN[1][7]:= vMN[1][4];
		vMN[1][8]:= '     '+chr(193);
		
		vMN[2][3]:= chr(196)+chr(196)+chr(196)+chr(196)+chr(196)+chr(191);
		vMN[2][4]:= vMN[1][4];
		vMN[2][5]:= chr(218)+chr(196)+chr(196)+chr(196)+chr(196)+chr(217);
		vMN[2][6]:= chr(179)+'    ';
		vMN[2][7]:= vMN[2][6];
		vMN[2][8]:= chr(192)+chr(196)+chr(196)+chr(196)+chr(196)+chr(196);
		
		vMN[3][3]:= vMN[2][3];
		vMN[3][4]:= vMN[1][4];
		vMN[3][5]:= chr(196)+chr(196)+chr(196)+chr(196)+chr(196)+chr(180);
		vMN[3][6]:= vMN[1][4];
		vMN[3][7]:= vMN[1][4];
		vMN[3][8]:= chr(196)+chr(196)+chr(196)+chr(196)+chr(196)+chr(217);
		
		vMN[4][3]:= chr(124)+'    '+chr(124);
		vMN[4][4]:= vMN[0][4];
		vMN[4][5]:= chr(192)+chr(196)+chr(196)+chr(196)+chr(196)+chr(180);
		vMN[4][6]:= vMN[1][4];
		vMN[4][7]:= vMN[1][4];
		vMN[4][8]:= vMN[1][8];
		
		vMN[5][3]:= chr(218)+chr(196)+chr(196)+chr(196)+chr(196)+chr(196);
		vMN[5][4]:= vMN[2][6];
		vMN[5][5]:= chr(192)+chr(196)+chr(196)+chr(196)+chr(196)+chr(191);
		vMN[5][6]:= vMN[1][4];
		vMN[5][7]:= vMN[1][4];
		vMN[5][8]:= vMN[3][8];
		
		vMN[6][3]:= vMN[5][3];
		vMN[6][4]:= vMN[2][6];
		vMN[6][5]:= chr(195)+chr(196)+chr(196)+chr(196)+chr(196)+chr(191);
		vMN[6][6]:= vMN[0][4];
		vMN[6][7]:= vMN[0][4];
		vMN[6][8]:= vMN[0][8];
		
		vMN[7][3]:= vMN[2][3];
		vMN[7][4]:= vMN[1][4];
		vMN[7][5]:= vMN[1][4];
		vMN[7][6]:= vMN[1][4];
		vMN[7][7]:= vMN[1][4];
		vMN[7][8]:= vMN[1][8];
		
		vMN[8][3]:= vMN[0][3];
		vMN[8][4]:= vMN[0][4];
		vMN[8][5]:= chr(195)+chr(196)+chr(196)+chr(196)+chr(196)+chr(180);
		vMN[8][6]:= vMN[0][4];
		vMN[8][7]:= vMN[0][4];
		vMN[8][8]:= vMN[0][8];
		
		vMN[9][3]:= vMN[0][3];
		vMN[9][4]:= vMN[0][4];
		vMN[9][5]:= chr(192)+chr(196)+chr(196)+chr(196)+chr(196)+chr(180);
		vMN[9][6]:= vMN[1][4];
		vMN[9][7]:= vMN[1][4];
		vMN[9][8]:= vMN[1][8];
	end;

procedure iniciarDefault();
	begin
		lJ:= nil;
		bAplicacion:= true;
		modoJuego:= -1;
		nombreUser:= ' ';
		iniciarVITIVITL();
		setearVHacerMinus();
		setearMarcos();
		iniciarMBVacia();
		iniciarMBDibujado();
		iniciarVMN();
		inciarCaracteres();
	end;




// Modulos comunes
procedure cartelBingo();
	begin
		writeln('    ',cB,cB,cB,cB,cB,cB,cB,cB,cB,cB,cB,cB,'     ',cB,cB,cB,cB,cB,cB,cB,cB,cB,'  ',cB,cB,cB,cB,cB,cB,'     ',cB,cB,cB,'       ',cB,cB,cB,cB,cB,cB,'        ',cB,cB,cB,cB,cB,cB,cB,cB);
		writeln('     ',cC,cC,cC,cC,cC,cC,'  ',cC,cC,cC,cC,cC,'     ',cC,cC,cC,cC,cC,'     ',cC,cC,cC,cC,cC,cC,'     ',cC,'    ',cB,cC,cC,cC,cC,cA,'  ',cA,cA,cC,cC,cC,'  ',cB,cC,cC,cC,cC,cC,'  ',cC,cC,cC,cC,cC,cB);
		writeln('     ',cC,cC,cC,cC,cC,cC,'  ',cC,cC,cC,cC,cC,'     ',cC,cC,cC,cC,cC,'     ',cC,cC,cC,cC,cC,cC,cC,cB,'   ',cC,'    ',cC,cC,cC,cC,'           ',cC,cC,cC,cC,cC,'    ',cC,cC,cC,cC,cC);
		writeln('     ',cC,cC,cC,cC,cC,cC,cC,cC,cC,cC,cC,cB,'      ',cC,cC,cC,cC,cC,'     ',cC,'  ',cC,cC,cC,cC,cC,cC,'  ',cC,'   ',cC,cC,cC,cC,cC,'    ',cB,cB,cB,cB,cB,'  ',cC,cC,cC,cC,cC,'    ',cC,cC,cC,cC,cC);
		writeln('     ',cC,cC,cC,cC,cC,cC,'  ',cC,cC,cC,cC,cC,cC,'    ',cC,cC,cC,cC,cC,'     ',cC,'   ',cA,cC,cC,cC,cC,cC,cC,cC,'    ',cC,cC,cC,cC,'    ',cA,cA,cC,cC,cC,'  ',cC,cC,cC,cC,cC,'    ',cC,cC,cC,cC,cC);
		writeln('     ',cC,cC,cC,cC,cC,cC,'  ',cC,cC,cC,cC,cC,cC,'    ',cC,cC,cC,cC,cC,'     ',cC,'     ',cC,cC,cC,cC,cC,cC,'    ',cA,cC,cC,cC,cC,cB,'  ',cB,cC,cC,cC,cA,'  ',cA,cC,cC,cC,cC,cC,'  ',cC,cC,cC,cC,cC,cA);
		writeln('    ',cA,cA,cA,cA,cA,cA,cA,cA,cA,cA,cA,cA,cA,cA,'   ',cA,cA,cA,cA,cA,cA,cA,cA,cA,'  ',cA,cA,cA,'     ',cA,cA,cA,cA,cA,cA,'      ',cA,cA,cA,cA,cA,cA,cA,cA,'       ',cA,cA,cA,cA,cA,cA,cA,cA);
	end;

procedure saltosLinea10();
	begin
		writeln; writeln; writeln; writeln; writeln; writeln; writeln; writeln; writeln; writeln;
	end;

procedure confirmarContinuar();
	begin
		writeln('  Presione ENTER para continuar');
		readln;
	end;

procedure leerSiNo(var opc: char);
	begin
		writeln('    S |  Si');
		writeln('    N |  No');
		repeat
			write('  Opcion: ');readln(opc);
			if opc= 's' then
				opc:= 'S'
			else if opc= 'n' then
				opc:= 'N'
			else if (opc<> 'S') and (opc<>'N') then
				writeln('  Opcion no valida, intente nuevamente');
			writeln;
		until (opc= 'S') or (opc= 'N');
	end;

procedure cerrarAplicacion();
	begin
		bAplicacion:= false;
		bJugar:= false;
		bPartida:= false;
	end;

procedure eliminarLJ(var lE: listaJugadores);
	var
		aux: listaJugadores;
	begin
		while lE<> nil do begin
			aux:= lE;
			lE:= lE^.sig;
			dispose(aux);
		end;
	end;



//	Matriz Bolillero
procedure actualizarMBDibujado();
	var
		digD,digU,nColum,nFila: integer;
	begin
		digD:= nBolilla div 10;
		digU:= nBolilla mod 10;
		for nColum:= 0 to 5 do begin
			for nFila:= 0 to 5 do
				mBD[nColum +3][nFila +21]:= vMN[digD][nColum +3][nFila +1];
		end;
		for nColum:= 0 to 5 do begin
			for nFila:= 0 to 5 do
				mBD[nColum +3][nFila +28]:= vMN[digU][nColum +3][nFila +1];
		end;
	end;




// IMPRIMIR CARTON

procedure imprimirFilaCarton(mCarton: matrizCarton; nCCarton,nCBolillero: integer);
	var
		i: integer;
	begin
		write(mBI[nCBolillero+1],'    ',chr(179));
		for i:=0 to MAXF do begin
			if mCarton[i][nCCarton].estado= 0 then
				write('    ')
			else if mCarton[i][nCCarton].estado= 1 then begin
				if mCarton[i][nCCarton].num<10 then
					write('0');
				write(mCarton[i][nCCarton].num,'  ')
			end
			else begin
				if mCarton[i][nCCarton].num<10 then
					write('0');
				write(mCarton[i][nCCarton].num,' ',chr(219));
			end;
			write(chr(179));
		end;
		writeln;
		write(mBI[nCBolillero+2],'    ',chr(179));
		for i:=0 to MAXF do begin
			if mCarton[i][nCCarton].estado< 2 then
				write('    ')
			else
				write(chr(220),chr(220),chr(220),chr(219));
			write(chr(179));
		end;
		writeln;
	end;
procedure imprimirCarton(mCarton: matrizCarton; nombre: string);
	var
		nCCarton,nCBolillero: integer;
		espaciosTitulo: string;
	begin
		if bPartida then begin
			actualizarMBDibujado();
			mBI:= mBD;
			espaciosTitulo:= '  BOLILLERO                           ';
		end
		else begin
			mBI:= MBV;
			espaciosTitulo:= '    ';
		end;
		nCCarton:=0;
		nCBolillero:= 0;
		if nombre<>' ' then
			writeln(espaciosTitulo,'Carton de: ',nombre);
		
		writeln;
		writeln(mBI[nCBolillero],'    ',marcoS);
		imprimirFilaCarton(mCarton,nCCarton,nCBolillero);
		
		nCCarton:= nCCarton +1;
		nCBolillero:= nCBolillero +3;
		writeln(mBI[nCBolillero],'    ',marcoM);
		imprimirFilaCarton(mCarton,nCCarton,nCBolillero);
		
		nCCarton:= nCCarton +1;
		nCBolillero:= nCBolillero +3;
		writeln(mBI[nCBolillero],'    ',marcoM);
		imprimirFilaCarton(mCarton,nCCarton,nCBolillero);
		
		writeln(mBI[nCBolillero+3],'    ',marcoI);
	end;




// GENERAR CARTON

procedure iniciarVN0A99();
	var
		i: integer;
	begin
		for i:=0 to MAXNB do
			vN0A99[i]:= false;
	end;

procedure iniciarCarton(var mCarton: matrizCarton);
	var
		i,j: integer;
	begin
		for i:= 0 to MAXC do
			for j:= 0 to MAXF do begin
				mCarton[j][i].num:= -1;
				mCarton[j][i].estado:= 0;
			end;
	end;

procedure iniciarCantEnColumnas(var cantEnColumnas: fila);
	var
		i: integer;
	begin
		for i:= 0 to MAXF do
			cantEnColumnas[i]:= 0;
	end;

function cualCasilla(n: integer): integer;
	begin
		if (n>=0) and (n< 3) then
			cualCasilla:= 0
		else if n<7 then
			cualCasilla:= 1
		else
			cualCasilla:= 2;
	end;

procedure fueGenerado(var vN0A99Aux: numeros0A99; num: integer; var bFueGenerado: boolean);
	begin
		if vN0A99Aux[num]= false then begin
			vN0A99Aux[num]:= true;
			bFueGenerado:= false;
		end
		else
			bFueGenerado:= true;
	end;

procedure agregarEnCasilla(var columnaCarton: columna; nColumna,n: integer);
	begin
		if columnaCarton[nColumna].estado= 0 then begin
			columnaCarton[nColumna].num:= n;
			columnaCarton[nColumna].estado:= 1;
		end
		else
			case nColumna of
				0 : begin
						if columnaCarton[nColumna].num < n then begin
							columnaCarton[nColumna +1].num:= n;
							columnaCarton[nColumna +1].estado:= 1;
						end
						else begin
							columnaCarton[nColumna +1].num:= columnaCarton[nColumna].num;
							columnaCarton[nColumna +1].estado:= 1;
							columnaCarton[nColumna].num:= n;
						end;
					end;
				1 : begin
						if columnaCarton[nColumna].num < n then begin
							columnaCarton[nColumna +1].num:= n;
							columnaCarton[nColumna +1].estado:= 1;
						end
						else begin
							columnaCarton[nColumna -1].num:= n;
							columnaCarton[nColumna -1].estado:= 1;
						end;
					end;
				2 : begin
						if columnaCarton[nColumna].num < n then begin
							columnaCarton[nColumna -1].num:= columnaCarton[nColumna].num;
							columnaCarton[nColumna -1].estado:= 1;
							columnaCarton[nColumna].num:= n;
						end
						else begin
							columnaCarton[nColumna -1].num:= n;
							columnaCarton[nColumna -1].estado:= 1;
						end;
					end;
			end;
	end;
procedure generarCarton(var mCarton: matrizCarton);
	var
		n,c2,nCargados,nFila,nColumna: integer;
		bFueGenerado: boolean;
		cantEnColumnas: fila;
	begin
		c2:= 0;
		nCargados:= 0;
		iniciarVN0A99();
		iniciarCantEnColumnas(cantEnColumnas);
		iniciarCarton(mCarton);
		repeat
			n:= random(100);
			fueGenerado(vN0A99,n,bFueGenerado);
			if not bFueGenerado then begin
				nColumna:= cualCasilla(n mod 10);
				nFila:= n div 10;
				if cantEnColumnas[nFila]= 0 then begin
					mCarton[nFila][nColumna].num:= n;
					mCarton[nFila][nColumna].estado:= 1;
					cantEnColumnas[nFila]:= cantEnColumnas[nFila] +1;
					nCargados:= nCargados +1;
				end
				else if (cantEnColumnas[nFila]= 1) and (c2< 5) then begin
					agregarEnCasilla(mCarton[nFila],nColumna,n);
					cantEnColumnas[nFila]:= cantEnColumnas[nFila] +1;
					c2:= c2 +1;
					nCargados:= nCargados +1;
				end;
			end;
		until nCargados= MAXNC;
	end;




//	PARTIDA

procedure finPartida();
	var
		opc: char;
	begin
		saltosLinea10(); saltosLinea10(); saltosLinea10();
		writeln('  Quieres seguir jugando en la misma modalidad/forma ?');
		leerSiNo(opc);
		if opc='S' then begin
			writeln;
			writeln('  Preparando nueva partida');
			confirmarContinuar();
		end
		else begin
			bJugar:= false;
			writeln;
			writeln('  Regresando al MENU Principal');
			confirmarContinuar();
		end;
	end;

procedure insertarPorPuntaje(var pri: listaJugadores; j: jugador);
	var
		ant,act,nuevo: listaJugadores;
	begin
		new(nuevo);
		nuevo^.dato:= j;
		ant:= pri;
		act:= pri;
		while (act<> nil) and (act^.dato.puntos> j.puntos) do begin
			ant:= act;
			act:= act^.sig;
		end;
		if ant=act then
			pri:= nuevo
		else
			ant^.sig:= nuevo;
		nuevo^.sig:= act;
	end;

procedure insertarNAcertados(var pri: listaJugadores; j: jugador);
	var
		ant,act,nuevo: listaJugadores;
	begin
		new(nuevo);
		nuevo^.dato:= j;
		ant:= pri;
		act:= pri;
		while (act<> nil) and (act^.dato.nAcertados> j.nAcertados) do begin
			ant:= act;
			act:= act^.sig;
		end;
		if ant=act then
			pri:= nuevo
		else
			ant^.sig:= nuevo;
		nuevo^.sig:= act;
	end;

procedure informarMejoresPartida(lI: listaJugadores);
	var
		nPuntos: integer;
	begin
		nPuntos:= MAXP -4;
		if lI<> nil then begin
			writeln('  EL ganador indiscutiple es: ',lI^.dato.nombre);
			writeln('  Lo consiguio con ',lI^.dato.puntos,' puntos');
			writeln;
			lI:= lI^.sig;
			while (lI<> nil)  and (lI^.dato.puntos>nPuntos) do begin
				writeln('  El que le sigue es: ',lI^.dato.nombre);
				writeln('  Lo consiguio con ',lI^.dato.puntos,' puntos');
				writeln;
				if lI^.dato.puntos= 19 then
					nPuntos:= MAXP -2
				else if lI^.dato.puntos= 18 then
					nPuntos:= MAXP -3;
				lI:= lI^.sig;
			end;
		end;
	end;
procedure informarListaCompleta(lI: listaJugadores);
	begin
		saltosLinea10(); saltosLinea10(); saltosLinea10();
		writeln('  La lista completa es:');
		writeln;
		while lI<> nil do begin
			writeln('  Jugador ',lI^.dato.nombre,' consiguio: ',lI^.dato.puntos,' puntos, completo: ',lI^.dato.nFullCartones,' cartones');
			writeln;
			lI:= lI^.sig;
		end;
	end;

procedure resultadoPartida();
	var
		opc: char;
		lA,lC: listaJugadores;
	begin
		lA:= lJ;
		lC:= nil;
		while lA<> nil do begin
			insertarPorPuntaje(lC,lA^.dato);
			lA:= lA^.sig;
		end;
		saltosLinea10(); saltosLinea10(); saltosLinea10();
		writeln('  En la partida se jugaron un total de ',nRonda,' rondas');
		informarMejoresPartida(lC);
		confirmarContinuar();
		writeln('  Quiere ver la lista de todos los jugadores ?');
		leerSiNo(opc);
		if opc= 'S' then begin
			saltosLinea10(); saltosLinea10(); saltosLinea10();
			informarListaCompleta(lC);
		end
		else
			writeln('  Finalizando partida');
		writeln;
		confirmarContinuar();
	end;

procedure finRonda();
	begin
		if bPartida then begin
			writeln;
			writeln('  Esta listo para seguir con la siguiente ronda ?');
		end;
		confirmarContinuar();
	end;

procedure sumarPuntos(var puntos: integer; nAcertados: integer);
	begin
		case nAcertados of
			MAXNC : puntos:= puntos +3;
			(MAXNC -1) : puntos := puntos +2;
			(MAXNC -2) : puntos := puntos +1;
		end;
		if puntos>= MAXP then
			bPartida:= false;
	end;

procedure resultadoRonda();
	var
		lC,lA: listaJugadores;
		nAcertados: integer;
	begin
		lA:= lJ;
		lC:= nil;
		while lA<> nil do begin
			sumarPuntos(lA^.dato.puntos,lA^.dato.nAcertados);
			insertarNAcertados(lC,lA^.dato);
			lA:= lA^.sig;
		end;
		nAcertados:= 11;
		saltosLinea10(); saltosLinea10(); saltosLinea10();
		if lC<> nil then begin
			cartelBingo();
			writeln;
			writeln('  EL ganador de la ronda ',nRonda,' es: ',lC^.dato.nombre);
			writeln('  Lo consiguio con ',lC^.dato.nAcertados,' numeros completados');
			writeln('  Su carton es: ');
			imprimirCarton(lC^.dato.carton,' ');
			writeln;
			lC:= lC^.sig;
			while (lC<> nil)  and (lC^.dato.nAcertados>nAcertados) do begin
				writeln('  El que le sigue es: ',lC^.dato.nombre);
				writeln('  Lo consiguio con ',lC^.dato.nAcertados,' numeros completados');
				writeln('  Su carton es: ');
				imprimirCarton(lC^.dato.carton,' ');
				writeln;
				if lC^.dato.nAcertados= 14 then
					nAcertados:=13
				else if lC^.dato.nAcertados= 13 then
					nAcertados:=12;
				lC:= lC^.sig;
			end;
		end;
	end;

procedure sacarN0A99(var n: integer);
	var
		bEsta: boolean;
	begin
		repeat
			n:= random(100);
			if vN0A99[n]= false then begin
				vN0A99[n]:= true;
				bEsta:= false;
			end
			else
				bEsta:= true;
		until not bEsta;
	end;

procedure tachar(n: integer; var mCarton: matrizCarton; var bTachado: boolean);
	var
		i: integer;
	begin
		bTachado:= false;
		for i:=0 to MAXC do begin
			if mCarton[n div 10][i].num = n then begin
				mCarton[n div 10][i].estado:= 2;
				bTachado:= true;
			end;
		end;
	end;
procedure mostrarCarton(lAnt,lAct: listaJugadores);
	var
		bAcerto: boolean;
		opc: char;
	begin
		saltosLinea10(); saltosLinea10(); saltosLinea10();
		imprimirCarton(lAnt^.dato.carton,lAnt^.dato.nombre);
		bAcerto:= lAnt^.dato.nAcertados<> lAct^.dato.nAcertados;
		writeln('  Tiene la bolilla que salio en su carton ?');
		leerSiNo(opc);
		saltosLinea10(); saltosLinea10(); saltosLinea10();
		if lAct^.dato.nAcertados= MAXNC then
			cartelBingo();
		writeln;
		imprimirCarton(lAct^.dato.carton,lAct^.dato.nombre);
		if bAcerto then begin
			if opc= 'S' then
				writeln('  Perfecto, tachado en tablero')
			else
				writeln('  Cuidado, te equivocaste, si tenes el numero');
		end
		else begin
			if opc= 'S' then
				writeln('  Mentiroso >:| , no tenes ese numero')
			else
				writeln('  Mala suerte, sera en la proxima');
		end;
		confirmarContinuar();
	end;
procedure desarrollarRonda();
	var
		aux: listaJugadores;
		bTachado,bGanador: boolean;
		lJC: listaJugadores;
	begin
		bGanador:= false;
		iniciarVN0A99();
		repeat
			aux:= lJ;
			if modoJuego<> 1 then begin
				new(lJC);
				lJC^.dato:= lJUser^.dato;
				lJC^.sig:= nil;
			end;
			sacarN0A99(nBolilla);
			while aux<>nil do begin
				tachar(nBolilla, aux^.dato.carton, bTachado);
				if bTachado then
					aux^.dato.nAcertados:= aux^.dato.nAcertados +1;
				if aux^.dato.nAcertados = MAXNC then begin
					aux^.dato.nFullCartones:= aux^.dato.nFullCartones +1;
					bGanador:= true;
				end;
				aux:= aux^.sig;
			end;
			if modoJuego<> 1 then
				mostrarCarton(lJC,lJUser);
			eliminarLJ(lJC);
		until bGanador;
	end;

procedure resetearRonda();
	var
		aux: listaJugadores;
	begin
		aux:= lJ;
		nRonda:= nRonda +1;
		nBolilla:= -1;
		while aux<> nil do begin
			generarCarton(aux^.dato.carton);
			aux^.dato.nAcertados:= 0;
			aux:= aux^.sig;
		end;
	end;

procedure resetearPartida();
	var
		aux: listaJugadores;
	begin
		bPartida:= true;
		nRonda:= 0;
		aux:= lJ;
		while aux<> nil do begin
			aux^.dato.puntos:= 0;
			aux^.dato.nFullCartones:= 0;
			aux:= aux^.sig;
		end;
	end;




// TOMAR DATOS



procedure asegurarMinuscula(var letra: char);
	begin
		if (letra>='A') and (letra<= 'Z') then
			letra:= vHacerMinus[letra];
	end;

function vaAqui(nombreExistente,nombreNuevo: string): boolean;
	var
		tamE,tamN,i,j: integer;
	begin
		tamE:= length(nombreExistente);
		tamN:= length(nombreNuevo);
		if tamE>tamN then
			tamE:= tamN;
		i:= 1;
		for j:= 1 to tamE do begin
			asegurarMinuscula(nombreExistente[i]);
			asegurarMinuscula(nombreNuevo[i]);
		end;
		while (i<= tamE) and (nombreExistente[i] = nombreNuevo[i]) do
			i:= i +1;
		vaAqui:= nombreExistente[i] > nombreNuevo[i];
	end;

procedure insertarAlfabeticamente(var pri: listaJugadores; nombre: string);
	var
		ant,act,nuevo: listaJugadores;
	begin
		new(nuevo);
		nuevo^.dato.nombre:= nombre;
		ant:= pri;
		act:= pri;
		while (act<> nil) and (not vaAqui(act^.dato.nombre, nombre)) do begin
			ant:= act;
			act:= act^.sig;
		end;
		if ant=act then
			pri:= nuevo
		else
			ant^.sig:= nuevo;
		nuevo^.sig:= act;
	end;

procedure insertarUserLJ();
	begin
		insertarAlfabeticamente(lJ, nombreUser);
		lJUser:= lJ;
	end;

procedure validarNumeroString(nString: string; var bConfirmacion: boolean; var nInteger: integer);
	var
		tam: integer;
	begin
		nInteger:= 0;
		tam:= length(nString);
		bConfirmacion:= false;
		if (tam= 2) and (nString[1]>= '0') and (nString[1]<= '9') and (nString[2]>= '0') and (nString[2]<= '9') then begin
			nInteger:= vITI[nString[1]]*10 + vITI[nString[2]];
			bConfirmacion:= true;
		end
		else if (tam= 1) and (nString[1]>= '0') and (nString[1]<= '9') then begin
			nInteger:= vITI[nString[1]];
			bConfirmacion:= true;
		end;
	end;

procedure leerNumeroString(var num: integer);
	var
		bConfirmacion: boolean;
		numString: string;
	begin
		repeat
			write('  Cantidad: ');readln(numString);
			validarNumeroString(numString,bConfirmacion,num);
			if not bConfirmacion then
				writeln('  Cantidad invalida, intente nuevamente');
			writeln
		until bConfirmacion;
	end;

function cargarMasJugadores(): boolean;
	var
		opc: char;
	begin
		writeln('  Tiene que ingresar un jugador mas ?');
		leerSiNo(opc);
		cargarMasJugadores:= opc= 'S';
	end;
procedure leerJugador(var nombre: string);
	var
		opc: char;
	begin
		repeat
			write('  Nombre: ');readln(nombre);
			writeln;
			writeln('  Confirme que el jugador se llama ',nombre);
			leerSiNo(opc);
			if opc= 'N' then
				writeln('  Proceda a ingresar nuevamente el jugador');
			writeln;
		until opc= 'S';
	end;
procedure leerUser();
	var
		opc: char;
	begin
		repeat
			saltosLinea10(); saltosLinea10(); saltosLinea10();
			writeln('  Antes de configurar la partida, elija el nombre ');
			writeln('  que va a tener durante la misma');
			write('  Nombre: ');readln(nombreUser);
			writeln;
			writeln('  Quiere llamarse ',nombreUser,' ?');
			leerSiNo(opc);
			if opc= 'N' then begin
				writeln('  Proceda a ingresar nuevamente su nombre');
				confirmarContinuar();
			end;
			writeln;
		until opc= 'S';
		writeln('  Nombre cargado con exito');
		confirmarContinuar();
	end;

procedure generarLJMaquina();
	var
		i: integer;
		nombre: string;
	begin
		insertarUserLJ();
		if modoJuego= 0 then
			nombre:= 'Bot '
		else
			nombre:= 'Jugador ';
		for i:= 1 to nBots do begin
			if nBots <10 then
				insertarAlfabeticamente(lJ,nombre + vITL[i])
			else
				insertarAlfabeticamente(lJ,nombre + vITL[i div 10]+ vITL[i mod 10]);
		end;
	end;
procedure datosBots();
	var
		opc: char;
		bConfirmacion: boolean;
	begin
		repeat
			bConfirmacion:= true;
			saltosLinea10(); saltosLinea10(); saltosLinea10();
			writeln('  MODO LOCAL VS. BOTS');
			writeln;
			writeln('  Cuantos bots quiere tener en la partida, min 1, max 99');
			leerNumeroString(nBots);
			writeln('  La cantidad ingresada de bots fue: ',nBots);
			writeln('  Confirma que esa es la cantidad ?');
			leerSiNo(opc);
			if opc= 'N' then
				bConfirmacion:= false;
			writeln;
		until bConfirmacion;
		generarLJMaquina();
	end;


procedure datosAmigosLocal();
	var
		bConfirmacion: boolean;
		aux: listaJugadores;
		nombre: string;
		opc: char;
	begin
		bConfirmacion:= false;
		repeat
			eliminarLJ(lJ);
			insertarUserLJ();
			saltosLinea10(); saltosLinea10(); saltosLinea10();
			writeln('  MODO LOCAL VS. AMIGOS');
			writeln;
			writeln('  Proceda a cargar los nombres de los otros jugadores');
			writeln;
			while not bConfirmacion do begin
				leerJugador(nombre);
				insertarAlfabeticamente(lJ,nombre);
				bConfirmacion:= not cargarMasJugadores();
			end;
			bConfirmacion:= false;
			aux:= lJ;
			writeln('  Esta es la lista con todos los jugadores que ingreso:');
			while aux<> nil do begin
				writeln('  ',aux^.dato.nombre);
				aux:= aux^.sig;
			end;
			writeln;
			writeln('  Esta seguro que esos son los nombres ?');
			leerSiNo(opc);
			if opc= 'S' then
				bConfirmacion:= true
			else begin
				writeln('  Listado reseteado, comienze denuevo');
				confirmarContinuar();
			end;
			writeln;
		until bConfirmacion;
	end;
	
procedure datosRandoms();
	var
		bConfirmacion: boolean;
		opc: char;
	begin
		bConfirmacion:= true;
		repeat
			saltosLinea10(); saltosLinea10(); saltosLinea10();
			writeln('  MODO ONLINE VS. RANDOMS');
			writeln;
			writeln('  Cual es el nombre de la sala ?');
			write('  Nombre: ');readln(nombreSala);
			writeln;
			writeln('  Cuantos jugadores podran conectarse a la sala ?, min 1, max 99');
			leerNumeroString(nBots);
			writeln('  La cantidad ingresada de jugadores fue: ',nBots);
			writeln('  Confirma esa cantidad ?');
			leerSiNo(opc);
			if opc= 'N' then
				bConfirmacion:= false;
			writeln;
		until bConfirmacion;
		generarLJMaquina();
	end;

procedure datosAmigosLinea();
	var
		bConfirmacion: boolean;
		aux: listaJugadores;
		nombre: string;
		opc: char;
	begin
		bConfirmacion:= false;
		repeat
			eliminarLJ(lJ);
			saltosLinea10(); saltosLinea10(); saltosLinea10();
			writeln('  Proceda a cargar los nombres de los jugadores');
			writeln('  IMPORTANTE: TODOS TIENEN QUE CARGAR LOS MISMOS NOMBRE');
			writeln;
			while not bConfirmacion do begin
				leerJugador(nombre);
				insertarAlfabeticamente(lJ,nombre);
				bConfirmacion:= not cargarMasJugadores();
			end;
			bConfirmacion:= false;
			aux:= lJ;
			writeln('  Esta es la lista con todos los jugadores que ingreso:');
			while aux<> nil do begin
				writeln('  ',aux^.dato.nombre);
				aux:= aux^.sig;
			end;
			writeln;
			writeln('  Esta seguro que ingreso los mismos nombres que los otros jugadores ?');
			leerSiNo(opc);
			if opc= 'S' then
				bConfirmacion:= true
			else
				writeln('  Listado reseteado');
			writeln;
		until bConfirmacion;
	end;

procedure setearPartida();
	begin
		bJugar:= true;
		eliminarLJ(lJ);
		leerUser();
		case modoJuego of
			0 :	datosBots();
			1 :	datosAmigosLocal();
			2 :	datosRandoms();
			3 : datosAmigosLinea();
		end;
		writeln('  Partida configurada con exito');
		writeln('  Ahora, empezemos a jugar');
		confirmarContinuar();
	end;




//	MENU PRINCIPAL
//			Como jugar

procedure volverMenuAyuda();
	begin
		writeln;
		writeln('  Para regresar al MENU Ayuda');
		confirmarContinuar();
	end;

procedure infoObjetivoJuego();
	begin
		saltosLinea10(); saltosLinea10(); saltosLinea10();
		writeln('  OBJETIVO del juego');
		writeln;
		writeln('  Escribir aqui');
		writeln('');
		volverMenuAyuda();
	end;

procedure infoEtapasPartida();
	begin
		saltosLinea10(); saltosLinea10(); saltosLinea10();
		writeln('  ETAPAS');
		writeln;
		writeln('  Escribir aqui');
		writeln('');
		volverMenuAyuda();
	end;

procedure infoModoLocal();
	begin
		saltosLinea10(); saltosLinea10(); saltosLinea10();
		writeln('  MODO LOCAL');
		writeln;
		writeln('  Escribir aqui');
		writeln('');
		volverMenuAyuda();
	end;

procedure infoModoEnLinea();
	begin
		saltosLinea10(); saltosLinea10(); saltosLinea10();
		writeln('  MODO EN LINEA');
		writeln;
		writeln('  Escribir aqui');
		writeln('');
		volverMenuAyuda();
	end;

procedure comoJugar(var opc: char);
	begin
		repeat
			saltosLinea10(); saltosLinea10(); saltosLinea10();
			writeln('     MENU Ayuda');
			writeln;
			writeln('  A continuacion elija lo que quiere saber');
			writeln('    1 |  Objetivo del juego');
			writeln('    2 |  Etapas de la Partida');
			writeln('    3 |  Modo Local');
			writeln('    4 |  Modo en Linea');
			writeln;
			writeln('    9 |  Volver al MENU Principal');
			writeln('    0 |  Cerrar el juego');
			repeat
				write('  Opcion: ');readln(opc);
				case opc of
					'1' : 	infoObjetivoJuego();
					'2' : 	infoEtapasPartida();
					'3' : 	infoModoLocal();
					'4' : 	infoModoEnLinea();
					'9' : 	begin
								writeln;
								writeln('  Regresando al MENU Principal');
								confirmarContinuar();
							end;
					'0' :  	cerrarAplicacion();
					else
						writeln('  Opcion no valida, intente nuevamente');
				end;
				writeln;
			until (opc>= '0') and (opc<= '4') or (opc= '9');
		until (opc= '9') or (opc= '0');
	end;



//			Empezar a jugar

procedure modoLocal(var opc: char);
	begin
		saltosLinea10(); saltosLinea10(); saltosLinea10();
		writeln('  MODALIDAD LOCAL');
		writeln;
		writeln('    1 |  Contra la Maquina');
		writeln('    2 |  Con Amigos');
		writeln;
		writeln('    9 |  Volver al MENU Principal');
		writeln('    0 |  Cerrar el juego');
		repeat
			write('  Opcion: ');readln(opc);
			case opc of
				'1' : 	begin
							opc:= '8';
							modoJuego:= 0;
							writeln;
							writeln('  Preparando para jugar contra Bots');
							confirmarContinuar();
						end;
				'2' : 	begin
							opc:= '8';
							modoJuego:= 1;
							writeln;
							writeln('  Preparando para jugar contra tus amigos');
							confirmarContinuar();
						end;
				'9' : 	begin
							writeln;
							writeln('  Regresando al MENU Principal');
							confirmarContinuar();
						end;
				'0' : 	cerrarAplicacion();
				else
					writeln('  Opcion no valida, intente nuevamente');
			end;
			writeln;
		until (opc= '0') or (opc= '8') or (opc= '9');
	end;

procedure modoEnLinea(var opc: char);
	begin
		saltosLinea10(); saltosLinea10(); saltosLinea10();
		writeln('  MODALIDAD EN LINEA');
		writeln;
		writeln('    1 |  Contra Randoms');
		writeln('    2 |  Con Amigos');
		writeln;
		writeln('    9 |  Volver al MENU Principal');
		writeln('    0 |  Cerrar el juego');
		repeat
			write('  Opcion: ');readln(opc);
			case opc of
				'1' : 	begin
							opc:= '8';
							modoJuego:= 2;
							writeln;
							writeln('  Preparando para jugar contra Randoms');
							confirmarContinuar();
						end;
				'2' : 	begin
							opc:= '8';
							modoJuego:= 3;
							writeln;
							writeln('  Preparando para jugar contra tus amigos');
							confirmarContinuar();
						end;
				'9' : 	begin
							writeln;
							writeln('  Regresando al MENU Principal');
							confirmarContinuar();
						end;
				'0' : 	cerrarAplicacion();
				else
					writeln('  Opcion no valida, intente nuevamente');
			end;
			writeln;
		until (opc= '0') or (opc= '8') or (opc= '9');
	end;

procedure mododalidadJuego(var opc: char);
	begin
		saltosLinea10(); saltosLinea10(); saltosLinea10();
		writeln('  MODALIDAD');
		writeln;
		writeln('    1 |  Local');
		writeln('    2 |  En Linea');
		writeln;
		writeln('    9 |  Volver al MENU Principal');
		writeln('    0 |  Cerrar el juego');
		repeat
			write('  Opcion: ');readln(opc);
			case opc of
				'1' :	modoLocal(opc);
				'2' :	modoEnLinea(opc);
				'9' :	begin
							writeln;
							writeln('  Regresando al MENU Principal');
							confirmarContinuar();
						end;
				'0' :	cerrarAplicacion();
				else
					writeln('  Opcion no valida, intente nuevamente');
			end;
			writeln;
		until (opc= '0') or (opc= '8') or (opc= '9');
	end;



//			Menu principal

procedure inicioJuego();
	var
		opc: char;
	begin
		modoJuego:= -1;
		repeat
			saltosLinea10(); saltosLinea10(); saltosLinea10();
			writeln('  Bienvenido a');
			cartelBingo();
			writeln('                                                                             v. Pascal <3');
			writeln;
			writeln('  MENU Principal');
			writeln;
			writeln('   A continuacion elija lo que desea hacer');
			writeln('     1 |  Como jugar');
			writeln('     2 |  Empezar a jugar');
			writeln('     0 |  Cerrar juego');
			repeat
				write('   Opcion: ');readln(opc);
				case opc of
					'1' : 	comoJugar(opc);
					'2' : 	mododalidadJuego(opc);
					'0' : 	cerrarAplicacion();
					else
						writeln('   Opcion no valida, intente nuevamente');
				end;
				writeln;
			until (opc= '0') or (opc= '8') or (opc= '9');
		until (opc= '0') or (opc= '8');
	end;




//	MENSAJE AUTORES
procedure derechosAutor();
	begin
		writeln;
		writeln;
		writeln('            BINGO version Pascal');
		writeln('         Por: Josue Suarez, Cata ZM,');
		writeln('          Nico Bonoris, Inaki y Feli');
		writeln;
		writeln;
		confirmarContinuar();
	end;



//	MENSAJE CIERRE APLICACION
procedure cierreAplicacion();
	begin
		saltosLinea10(); saltosLinea10(); saltosLinea10();
		writeln('  Gracias por jugar a');
		cartelBingo();
		writeln('                                                                             v. Pascal <3');
		writeln('  Presione enter para cerrar la aplicacion');
		writeln;
		readln;
	end;




//	CUERPO PRINCIPAL
begin
	iniciarDefault();
	derechosAutor();
	while bAplicacion do begin
		inicioJuego();
		if modoJuego> -1 then begin
			setearPartida();
			while bJugar do begin
				resetearPartida();
				while bPartida do begin
					resetearRonda();
					desarrollarRonda();
					resultadoRonda();
					finRonda();
				end;
				resultadoPartida();
				finPartida();
			end;
		end;
	end;
	cierreAplicacion();
end.
