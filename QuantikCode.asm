; Instituto Tecnologico de Costa Rica 
; Jose David Fernandez Salas #2022045079 
; Arquitectura de Computadores IC3101 
; Profesor: Kirstein Gätjens S.
; Tarea Quantik
; Fecha: 07/10/2022

; ------------------------------Manual-Usuario--------------------------------------------------------------------------------------
;Este programa consiste en simular de una forma muy basica el juego de mesa llamado quantik. Este juego se trata de mover piezas en un tablero cumplendo una serie de reglas hasta que uno gane y haya un empate por la incapacidad de poner piezas.
;Existen 3 funciones diferenetes para esta programacion

;1. C. Crear una partida. Tiene al capacidad de crear un nuevo tablero o cancelar la creacion para que no se borre nada
;2. J. Juega el jugador. Se debe indicar varias cosas pero tiene la capacidad de hacer todo tipo de validaciones, ademas determina que color de jugador sigue. Determina si la pocicion que se quiere poner la pieza es legal e indica si un jugador gana
;3. I. La inteligencia artificial que hace un movimiento dependiendo del valor random que consigue. No tiene parametros y puede ser que se repita mucho 
; ------------------------------Auto-Evaluacion-------------------------------------------------------------------------------------

; Crear tablero nuevo [A]
; Cancelar Creacion Tablero [A]
; Añadir una nueva jugada [A]
; Toma de datos jugada correcta [A]
; Validacion datos entrada [A]
; Validacion sobre espacios posibles [A]
; Validacion ganar por cuadrante [A]
; Validacion ganar por filas o columnas [B]
; Determinar cuando es empate [A]
; Creacion de Inteligencia Artificial []
;-----------------------------------------------------------------------------------------------------------------------------------

datos segment


    ; esferalanca          db 'E'
    ; cuboBlanco           db 'C'
    ; conoBlanco           db 'V'
    ; cilindroBlanco       db 'D'
    ; esferaNegra          db 'e'
    ; cuboNegro            db 'c'
    ; conoNegro            db 'v'
    ; cilindroNegro        db 'd'

    bufferTablero              db "....", 10, "....", 10, "....", 10, "...."
    pruebaTablero              db "........cdev...."
    tableroActual              db 128 dup ( 0 )
    tableroTemporal            db 128 dup ( 0 )
    Buffy                      db 256 dup(0)

    jugadorActual              db 0
    contadorCx                 dw 0
    letraComando               db ?
    turnoJugador               db ?
    pieza                      db ?
    indiceFila                 db 0

    columnaEntrada             db ?
    filaEntrada                db ?
    banderaError               db ?
    
    Semilla                    dw ?


    fila                       db 3
    columna                    db 1
    columnaAux                 db 0

    valor                      db ?

    zona                       db 0
    zonaTemp1                  db ?
    zonaTemp2                  db ?
    zonaTemp3                  db ?
    zonaTemp4                  db ?

 

    Ruta                       db "K:\archivos\Rata.TXT",0
    nombArchivo                db "QUANTIK.TXT",0
    handleE                    dw ?
    handleS                    dw ?

    msgProgramClose            db "Se termino la ejecucion del programa",10,13,'$'
    msgCrearInicio             db "Se va a crear una nueva partida",10,13,'$'
    msgNoSobrescribir          db "No se va a sobrescribir el tablero",10,13,'$'
    msgTableroCreado           db "No se va a sobrescribir el tablero",10,13,'$'
    msgErrorCrearTablero       db "Hubo un error en la creacion del tablero",10,13,'$'
    inputArchivo               db "Ya existe tablero, si quiere reiniciarlo opima Y, sino cualquier tecla",10,13,'$'

    defC                       db "Crear una Partida",10,13,'$'
    defJ                       db "Juega el jugador (Indique color, pieza y casilla).",10,13,'$'
    defI                       db "Solicitar Inteligencia Artifical que juegue",10,13,'$'
    comandoError               db "La letra de comando es invalida consulte las letras correctas con ayuda",10,13,'$'

    msgZonaIncorrecta          db "La zona es invalida porque hay valores repetidos",10,13,'$'
    msgZonCorrecta             db "La zona fue validada correctamente ",10,13,'$'
    msgErrorFilasValidacion    db "Hay valores en la filas repetido, esta incorrecto ",10,13,'$'
    msgErrorColumValidacion    db "Hay vaores en las columnas repetidos, esta incorrecto",10,13,'$'
    msgErrorZona               db "Hubo un error en la toma de zonas ",10,13,'$'

    msgValidacionFilasCorrecta db "La validacion fila columna esta correcta ",10,13,'$'

    msgCuadrante1              db "Esta ubicado en el cuadrante 1 ",10,13,'$'
    msgCuadrante2              db "Esta ubicado en el cuadrante 2 ",10,13,'$'
    msgCuadrante3              db "Esta ubicado en el cuadrante 3 ",10,13,'$'
    msgCuadrante4              db "Esta ubicado en el cuadrante 4 ",10,13,'$'

    jugadorRepetidoMsg         db "El jugador no puede jugar 2 veces seguidas",10,13,'$'
    jugadorInvalidoMsg         db "El color del jugador no es valido",10,13,'$'
    msgCaracterInvalido        db "El carcater que ingreso no es valido, puede ser la mayuscula o el caracter",10,13,'$'
    msgLetraInvalida           db "La letra que se ingreso de coordenadas no esta dentro del rango permitido",10,13,'$'

    msgETablero                db "Hubo un error al escribir el tablero dentro del archivo",10,13,'$'
    msgBienTab                 db "Se ha guardado la jugada exitosamente",10,13,'$'
    msgMalTabClose             db "Como la jugada no fue valida se restauro el tablero",10,13,'$'
    msgCaracterExistente       db "No se puede colocar el caracter porque ya existe uno en esa pocicion",10,13,'$'

    msgBlancasGanan            db "Las blancas ganaron el juego",10,13,'$'
    msgNegrasGanan             db "Las negras ganaron el juego",10,13,'$'
    msgHuboEmpate              db "Hubo un empate",10,13,'$'

    msgPiezaInsertada          db "Se inserto la pieza en la pocision: $"

    enterMsg                   db " ",10,13,'$'

    msgDatoUsabelIa            db "El dato esta temporalmente permitido",10,13,'$'
    msgExtendenTime            db "La inteligenica artificial no encontro movimientos en un rango previsto y se cerro",10,13,'$'

datos endS

pila segment stack 'stack'
         dw 256 dup(?)
pila endS


codigo segment
                                 Assume CS:codigo,DS:datos,SS:pila

enterCall proc near
                                 mov    ah, 09h
                                 lea    dx, enterMsg                        ;Hace un enter
                                 int    21h
                                 ret
enterCall endP

funcionAyuda proc near
                 
    A:                           mov    ah, 09h
                                 lea    dx, defC
                                 int    21h
                         
    C:                           mov    ah, 09h
                                 lea    dx, defJ
                                 int    21h
                        
    I:                           mov    ah, 09h
                                 lea    dx, defI
                                 int    21h

                                 ret
funcionAyuda endp

indexOpciones proc near

                                 cmp    al, 'C'
                                 jne    o2
                  
                                 call   verificarTablero
                                 ret
                        
    o2:                          cmp    al, 'J'
                                 jne    o3
                                 call   addNuevaJugada
                                 ret

    o3:                          cmp    al, 'I'
                                 jne    o4
                                 call   IaController
                                 ret
        
    o4:                          mov    ah, 09h
                                 lea    dx, comandoError
                                 int    21h
    
                                 mov    ax, 4C00h
                                 int    21h
indexOpciones endp

buscaPosition proc near
                                 xor    ax,ax
                                 mov    al, fila
                                 mov    bl, 4
                                 mul    bx
                                 mov    dl, columna
                                 add    al,columna

                                 mov    di,ax
                                 ret
buscaPosition endp

pruebaAccederDatos proc near
                                 call   buscaPosition
                                 mov    al, byte ptr tableroActual[di]
                                 mov    valor,al
                                 xor    di,di
                                 xor    bx,bx
                                 ret
pruebaAccederDatos endp

verificarTablero proc near                                                  ;Verifica tablero y puede reinicair
                                 lea    dx,nombArchivo
                                 mov    ax,3D00h
                                 int    21h
                                 jnc    existenteError

    crearPartida:                mov    ah,3Ch
                                 xor    cx,cx
                                 lea    dx, nombArchivo
                                 int    21h
                                 jc     errorSobreEcribir
                                 mov    handleS,ax
                                 jmp    escribirTableroNuevo
   
    existenteError:              mov    ah, 09h
                                 lea    dx, inputArchivo
                                 int    21h
                        
                                 mov    ah,01h
                                 int    21h
                                 cmp    al, 89
                                 je     crearPartida
                                 jmp    errorSobreEcribir
   
    escribirTableroNuevo:        mov    bx, handleS
                                 mov    ah, 40h
                                 mov    cx,19
                                 lea    dx,bufferTablero
                                 int    21h

    cerrarTableroCreado:         mov    ah,3Eh
                                 mov    bx,handleS
                                 int    21h
                                 ret

    errorSobreEcribir:           lea    dx, msgNoSobrescribir
                                 mov    ah, 09h
                                 int    21h

                                 mov    ax,4C00h
                                 int    21h
verificarTablero endp

validacionZona proc near
                                 cmp    zona, 0
                                 je     zoneValidate1Datoss

                                 cmp    zona,1
                                 je     zoneValidate2Datoss

                                 cmp    zona,2
                                 je     auxZone3

                                 cmp    zona,3
                                 je     auxZone4
                                 jmp    salirZone


    zoneValidate1Datoss:         mov    fila,0                              ;Se busca el valor del 00
                                 mov    columna,0
                                 call   pruebaAccederDatos
                                 mov    zonaTemp1, al

                                 mov    fila,0                              ;Se busca el valor del 01
                                 mov    columna,1
                                 call   pruebaAccederDatos
                                 mov    zonaTemp2, al

                           
                                 mov    fila,1                              ;Se busca el valor del 10
                                 mov    columna,0
                                 call   pruebaAccederDatos
                                 mov    zonaTemp3, al

                           
                                 mov    fila,1                              ;Se busca el valor del 11
                                 mov    columna,1
                                 call   pruebaAccederDatos
                                 mov    zonaTemp4, al
                                 jmp    comparacionesZonas

    auxZone3:                    jmp    zoneValidate3Datoss
    auxZone4:                    jmp    zoneValidate4Datoss

    zoneValidate2Datoss:         mov    fila,0                              ;Se busca el valor del 00
                                 mov    columna,2
                                 call   pruebaAccederDatos
                                 mov    zonaTemp1, al

                                 mov    fila,0                              ;Se busca el valor del 01
                                 mov    columna,3
                                 call   pruebaAccederDatos
                                 mov    zonaTemp2, al

                           
                                 mov    fila,1                              ;Se busca el valor del 10
                                 mov    columna,2
                                 call   pruebaAccederDatos
                                 mov    zonaTemp3, al

                           
                                 mov    fila,1                              ;Se busca el valor del 11
                                 mov    columna,3
                                 call   pruebaAccederDatos
                                 mov    zonaTemp4, al
                                 jmp    comparacionesZonas

    zoneValidate3Datoss:         mov    fila,2                              ;Se busca el valor del 00
                                 mov    columna,0
                                 call   pruebaAccederDatos
                                 mov    zonaTemp1, al

                                 mov    fila,2                              ;Se busca el valor del 01
                                 mov    columna,1
                                 call   pruebaAccederDatos
                                 mov    zonaTemp2, al

                           
                                 mov    fila,3                              ;Se busca el valor del 10
                                 mov    columna,0
                                 call   pruebaAccederDatos
                                 mov    zonaTemp3, al

                           
                                 mov    fila,3                              ;Se busca el valor del 11
                                 mov    columna,1
                                 call   pruebaAccederDatos
                                 mov    zonaTemp4, al
                                 jmp    comparacionesZonas

    zoneValidate4Datoss:         mov    fila,2                              ;Se busca el valor del 00
                                 mov    columna,2
                                 call   pruebaAccederDatos
                                 mov    zonaTemp1, al

                                 mov    fila,2                              ;Se busca el valor del 01
                                 mov    columna,3
                                 call   pruebaAccederDatos
                                 mov    zonaTemp2, al

                           
                                 mov    fila,3                              ;Se busca el valor del 10
                                 mov    columna,2
                                 call   pruebaAccederDatos
                                 mov    zonaTemp3, al

                           
                                 mov    fila,3                              ;Se busca el valor del 11
                                 mov    columna,3
                                 call   pruebaAccederDatos
                                 mov    zonaTemp4, al
                                 jmp    comparacionesZonas

    comparacionesZonas:          xor    ax,ax
                                 mov    al, zonaTemp1
                                 cmp    al, '.'
                                 je     zoneTemp2Comp
    zoneTem1Comp:                                                           ;cmp    al, zonaTemp2

                                 add    al,32
                                 cmp    al, zonaTemp2
                                 je     auxValorRepetidoZona
                                 sub    al,64
                                 cmp    al, zonaTemp2
                                 je     auxValorRepetidoZona
                                 add    al ,32

                                 add    al,32
                                 cmp    al, zonaTemp3
                                 je     auxValorRepetidoZona
                                 sub    al,64
                                 cmp    al, zonaTemp3
                                 je     auxValorRepetidoZona
                                 add    al ,32

                                 add    al,32
                                 cmp    al, zonaTemp4
                                 je     auxValorRepetidoZona
                                 sub    al,64
                                 cmp    al, zonaTemp4
                                 je     auxValorRepetidoZona
                                 jmp    zoneTemp2Comp

    auxValorRepetidoZona:        jmp    valoresRepetidos

    zoneTemp2Comp:               mov    al, zonaTemp2
                                 cmp    al, '.'
                                 je     zone3Tem3Comp

                                 add    al,32
                                 cmp    al, zonaTemp3
                                 je     valoresRepetidos
                                 sub    al,64
                                 cmp    al, zonaTemp3
                                 je     valoresRepetidos
                                 add    al ,32

    ;cmp    al, zonaTemp4
    ;je     valoresRepetidos
                                 add    al,32
                                 cmp    al, zonaTemp4
                                 je     valoresRepetidos
                                 sub    al,64
                                 cmp    al, zonaTemp4
                                 je     valoresRepetidos
                                 add    al ,32

    zone3Tem3Comp:               mov    al, zonaTemp3
                                 cmp    al, '.'
                                 je     zonaCorrecta
    ;cmp    al, zonaTemp4
    ;je     valoresRepetidos
                                 add    al,32
                                 cmp    al, zonaTemp4
                                 je     valoresRepetidos
                                 sub    al,64
                                 cmp    al, zonaTemp4
                                 je     valoresRepetidos
                                 jmp    zonaCorrecta

    zonaCorrecta:                mov    ah, 09h
                                 lea    dx, msgZonCorrecta
                                 int    21h
                                 ret

    valoresRepetidos:            cmp    banderaError,7
                                 je     zonaIAError
    
                                 mov    ah, 09h
                                 lea    dx, msgZonaIncorrecta
                                 int    21h
                                 jmp    salirZone

    salirzone:                   mov    ah, 09h
                                 lea    dx, msgZonaIncorrecta
                                 int    21h
    
                                 mov    ax, 4C00h
                                 int    21h

    zonaIAError:                 mov    banderaError,1
                                 ret
validacionZona endp

validacionLinea proc near
    ;vamos a suponer que el usario pone fila y columnas
                                 mov    al,columna
                                 mov    columnaAux, al

    filaValidate:                xor    ax,ax
                                 mov    columna,0
                                 call   pruebaAccederDatos
                                 mov    zonaTemp1, al
                                 mov    columna,1
                                 call   pruebaAccederDatos
                                 mov    zonaTemp2, al
                                 mov    columna,2
                                 call   pruebaAccederDatos
                                 mov    zonaTemp3, al
                                 mov    columna,3
                                 call   pruebaAccederDatos
                                 mov    zonaTemp4, al

    comparacionColumna:          xor    ax,ax
                                 mov    al, zonaTemp1
                                 cmp    al, '.'
                                 je     columna2Val
    columna1Val:                                                            ;cmp    al, zonaTemp2
    ;je     auxValorRepetido
                                 add    al,32
                                 cmp    al, zonaTemp2
                                 je     auxValorRepetido
                                 sub    al,64
                                 cmp    al, zonaTemp2
                                 je     auxValorRepetido
                                 add    al ,32
    ;cmp    al, zonaTemp3
    ;je     auxValorRepetido
                                 add    al,32
                                 cmp    al, zonaTemp3
                                 je     auxValorRepetido
                                 sub    al,64
                                 cmp    al, zonaTemp3
                                 je     auxValorRepetido
                                 add    al ,32
    ;cmp    al, zonaTemp4
    ;je     auxValorRepetido
                                 add    al,32
                                 cmp    al, zonaTemp4
                                 je     auxValorRepetido
                                 sub    al,64
                                 cmp    al, zonaTemp4
                                 je     auxValorRepetido
                                 add    al ,32
                                 jmp    columna2Val

    auxValorRepetido:            jmp    valoresRepetidosColu
                                
    columna2Val:                 mov    al, zonaTemp2
                                 cmp    al, '.'
                                 je     columna3Val
    ;cmp    al, zonaTemp3
    ;je     valoresRepetidosColu
                                 add    al,32
                                 cmp    al, zonaTemp3
                                 je     valoresRepetidosColu
                                 sub    al,64
                                 cmp    al, zonaTemp3
                                 je     valoresRepetidosColu
                                 add    al ,32
    ;cmp    al, zonaTemp4
    ;je     valoresRepetidosColu
                                 add    al,32
                                 cmp    al, zonaTemp4
                                 je     valoresRepetidosColu
                                 sub    al,64
                                 cmp    al, zonaTemp4
                                 je     valoresRepetidosColu
                                 add    al ,32
    columna3Val:                 mov    al, zonaTemp3
                                 cmp    al, '.'
                                 je     columnaValidate
    ;cmp    al, zonaTemp4
    ;je     valoresRepetidosColu
                                 add    al,32
                                 cmp    al, zonaTemp4
                                 je     valoresRepetidosColu
                                 sub    al,64
                                 cmp    al, zonaTemp4
                                 je     valoresRepetidosColu
                                 add    al ,32
                                 jmp    columnaValidate

    valoresRepetidosColu:        cmp    banderaError,7
                                 je     auxFilasIa
    
                                 mov    ah, 09h
                                 lea    dx, msgErrorFilasValidacion
                                 int    21h
                                 jmp    salirFilasColuVal
    ;TERMINA EL DE FILASSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS


    columnaValidate:             mov    al,columnaAux
                                 mov    columna, al
                                 mov    fila,0
                                 call   pruebaAccederDatos
                                 mov    zonaTemp1, al
                                 mov    fila,1
                                 call   pruebaAccederDatos
                                 mov    zonaTemp2, al
                                 mov    fila,2
                                 call   pruebaAccederDatos
                                 mov    zonaTemp3, al
                                 mov    fila,3
                                 call   pruebaAccederDatos
                                 mov    zonaTemp4, al
                                 jmp    comparacionFila

    auxFilasIa:                  jmp    salirValidarLineaIa

    comparacionFila:             xor    ax,ax
                                 mov    al, zonaTemp1
                                 cmp    al, '.'
                                 je     fil2Val
    fila1Val:                    
                                 add    al,32
                                 cmp    al, zonaTemp2
                                 je     auxColuRepetido
                                 sub    al,64
                                 cmp    al, zonaTemp2
                                 je     auxColuRepetido
                                 add    al ,32

                                 add    al,32
                                 cmp    al, zonaTemp3
                                 je     auxColuRepetido
                                 sub    al,64
                                 cmp    al, zonaTemp3
                                 je     auxColuRepetido
                                 add    al ,32
 
                                 add    al,32
                                 cmp    al, zonaTemp4
                                 je     auxColuRepetido
                                 sub    al,64
                                 cmp    al, zonaTemp4
                                 je     auxColuRepetido
                                 add    al ,32
                                 jmp    fil2Val

    auxColuRepetido:             jmp    valoresRepetidosFila
                                
    fil2Val:                     mov    al, zonaTemp2
                                 cmp    al, '.'
                                 je     fila3Val

                                 add    al,32
                                 cmp    al, zonaTemp3
                                 je     valoresRepetidosFila
                                 sub    al,64
                                 cmp    al, zonaTemp3
                                 je     valoresRepetidosFila
                                 add    al ,32

                                 add    al,32
                                 cmp    al, zonaTemp4
                                 je     valoresRepetidosFila
                                 sub    al,64
                                 cmp    al, zonaTemp4
                                 je     valoresRepetidosFila
                                 add    al ,32
    fila3Val:                    mov    al, zonaTemp3
                                 cmp    al, '.'
                                 je     pocicionCorrecta
    ;cmp    al, zonaTemp4
    ;je     valoresRepetidosFila
                                 add    al,32
                                 cmp    al, zonaTemp4
                                 je     valoresRepetidosFila
                                 sub    al,64
                                 cmp    al, zonaTemp4
                                 je     valoresRepetidosFila
                                 add    al ,32
                                 jmp    pocicionCorrecta

    pocicionCorrecta:            mov    ah, 09h
                                 lea    dx, msgValidacionFilasCorrecta
                                 int    21h
                                 ret

    valoresRepetidosFila:        cmp    banderaError,1
                                 je     salirValidarLineaIa
                     
                                 mov    ah, 09h
                                 lea    dx, msgErrorColumValidacion
                                 int    21h
                                 jmp    salirFilasColuVal
                           
    salirFilasColuVal:           mov    ax, 4C00h
                                 int    21h

    salirValidarLineaIa:         mov    banderaError,1
                                 ret
validacionLinea endp

definirCuadrante proc near                                                  ;Sirve
                                 mov    al, fila
                                 cmp    al, 0
                                 je     posibleZone1
                                 cmp    al, 1
                                 je     posibleZone1
                                 cmp    al, 2
                                 je     posibleZone3
                                 cmp    al, 3
                                 je     posibleZone3


    posibleZone1:                xor    al, al
                                 mov    al, columna
                                 cmp    al, 0
                                 je     cuadrante1
                                 cmp    al, 1
                                 je     cuadrante1
                                 jmp    cuadrante2

    posibleZone3:                xor    al, al
                                 mov    al, columna
                                 cmp    al, 0
                                 je     cuadrante3
                                 cmp    al, 1
                                 je     cuadrante3
                                 jmp    cuadrante4


    cuadrante1:                  mov    zona, 0
                                 jmp    salirCuadrante

    cuadrante2:                  mov    zona,1
                                 jmp    salirCuadrante

    cuadrante3:                  mov    zona,2
                                 jmp    salirCuadrante

    cuadrante4:                  mov    zona,3

    salirCuadrante:              ret

definirCuadrante endp

recargarVariables proc near
                                 mov    al, columnaEntrada
                                 mov    columna, al

                                 mov    al, filaEntrada
                                 mov    fila,al
                                 ret
recargarVariables endp

verificarGanadorZona proc near
                                 cmp    zona, 0
                                 je     zonaGanador1

                                 cmp    zona,1
                                 je     zonaGanador2

                                 cmp    zona,2
                                 je     auxGanador3

                                 cmp    zona,3
                                 je     auxGanador4
                                 jmp    salirZone

    zonaGanador1:                mov    fila,0                              ;Se busca el valor del 00
                                 mov    columna,0
                                 call   pruebaAccederDatos
                                 mov    zonaTemp1, al

                                 mov    fila,0                              ;Se busca el valor del 01
                                 mov    columna,1
                                 call   pruebaAccederDatos
                                 mov    zonaTemp2, al

                           
                                 mov    fila,1                              ;Se busca el valor del 10
                                 mov    columna,0
                                 call   pruebaAccederDatos
                                 mov    zonaTemp3, al

                           
                                 mov    fila,1                              ;Se busca el valor del 11
                                 mov    columna,1
                                 call   pruebaAccederDatos
                                 mov    zonaTemp4, al
                                 jmp    busquedaGanador

    auxGanador3:                 jmp    zonaGanador3
    auxGanador4:                 jmp    zonaGanador4

    zonaGanador2:                mov    fila,0                              ;Se busca el valor del 00
                                 mov    columna,2
                                 call   pruebaAccederDatos
                                 mov    zonaTemp1, al

                                 mov    fila,0                              ;Se busca el valor del 01
                                 mov    columna,3
                                 call   pruebaAccederDatos
                                 mov    zonaTemp2, al

                           
                                 mov    fila,1                              ;Se busca el valor del 10
                                 mov    columna,2
                                 call   pruebaAccederDatos
                                 mov    zonaTemp3, al

                           
                                 mov    fila,1                              ;Se busca el valor del 11
                                 mov    columna,3
                                 call   pruebaAccederDatos
                                 mov    zonaTemp4, al
                                 jmp    busquedaGanador

    zonaGanador3:                mov    fila,2                              ;Se busca el valor del 00
                                 mov    columna,0
                                 call   pruebaAccederDatos
                                 mov    zonaTemp1, al

                                 mov    fila,2                              ;Se busca el valor del 01
                                 mov    columna,1
                                 call   pruebaAccederDatos
                                 mov    zonaTemp2, al

                           
                                 mov    fila,3                              ;Se busca el valor del 10
                                 mov    columna,0
                                 call   pruebaAccederDatos
                                 mov    zonaTemp3, al

                           
                                 mov    fila,3                              ;Se busca el valor del 11
                                 mov    columna,1
                                 call   pruebaAccederDatos
                                 mov    zonaTemp4, al
                                 jmp    busquedaGanador

    zonaGanador4:                mov    fila,2                              ;Se busca el valor del 00
                                 mov    columna,2
                                 call   pruebaAccederDatos
                                 mov    zonaTemp1, al

                                 mov    fila,2                              ;Se busca el valor del 01
                                 mov    columna,3
                                 call   pruebaAccederDatos
                                 mov    zonaTemp2, al

                           
                                 mov    fila,3                              ;Se busca el valor del 10
                                 mov    columna,2
                                 call   pruebaAccederDatos
                                 mov    zonaTemp3, al

                           
                                 mov    fila,3                              ;Se busca el valor del 11
                                 mov    columna,3
                                 call   pruebaAccederDatos
                                 mov    zonaTemp4, al

    busquedaGanador:             xor    ax,ax
                                 mov    ax,1
                                 mul    zonaTemp1
                                 mov    dx,ax

                                 mov    ax,1
                                 mul    zonaTemp2
                                 mov    bx,ax

                                 add    bx, dx

                                 mov    ax,1
                                 mul    zonaTemp3
                                 mov    dx,ax

                                 add    bx,dx

                                 mov    ax,1
                                 mul    zonaTemp4
                                 mov    dx,ax

                                 add    bx, dx
                                
                                 cmp    bx, 290
                                 je     ganadorBlancas
                                 cmp    bx, 418
                                 je     ganadorNegras
                                 ret

    ganadorBlancas:              lea    dx, msgBlancasGanan
                                 mov    ah, 09h
                                 int    21h
                                 jmp    salirVictoria
    
    ganadorNegras:               lea    dx, msgNegrasGanan
                                 mov    ah, 09h
                                 int    21h

    salirVictoria:               mov    ax, 4C00h
                                 int    21h

verificarGanadorZona endp

verificarGanadorColu proc near
                                 mov    al,columna
                                 mov    columnaAux, al
                                 xor    di,di
                                 xor    bx,bx

    buscarFilaGanar:             mov    columna,0
                                 call   pruebaAccederDatos
                                 mov    zonaTemp1, al
                                 mov    columna,1
                                 call   pruebaAccederDatos
                                 mov    zonaTemp2, al
                                 mov    columna,2
                                 call   pruebaAccederDatos
                                 mov    zonaTemp3, al
                                 mov    columna,3
                                 call   pruebaAccederDatos
                                 mov    zonaTemp4, al


    busquedaGanadorColu:         xor    ax,ax
                                 mov    ax,1
                                 mul    zonaTemp1
                                 mov    dx,ax

                                 mov    ax,1
                                 mul    zonaTemp2
                                 mov    bx,ax

                                 add    bx, dx

                                 mov    ax,1
                                 mul    zonaTemp3
                                 mov    dx,ax

                                 add    bx,dx

                                 mov    ax,1
                                 mul    zonaTemp4
                                 mov    dx,ax

                                 add    bx, dx
                                
                                 cmp    bx, 290
                                 je     ganadorBlancasMat
                                 cmp    bx, 418
                                 je     ganadorNegrasMat
                                 jmp    segirColumnas


    segirColumnas:               mov    al,columnaAux
                                 xor    di,di
                                 xor    bx,bx

                                 mov    columna, al
                                 mov    fila,0
                                 call   pruebaAccederDatos
                                 mov    zonaTemp1, al
                                 mov    fila,1
                                 call   pruebaAccederDatos
                                 mov    zonaTemp2, al
                                 mov    fila,2
                                 call   pruebaAccederDatos
                                 mov    zonaTemp3, al
                                 mov    fila,3
                                 call   pruebaAccederDatos
                                 mov    zonaTemp4, al

    busquedaGanadorFila:         xor    ax,ax
                                 mov    ax,1
                                 mul    zonaTemp1
                                 mov    dx,ax

                                 mov    ax,1
                                 mul    zonaTemp2
                                 mov    bx,ax

                                 add    bx, dx

                                 mov    ax,1
                                 mul    zonaTemp3
                                 mov    dx,ax

                                 add    bx,dx

                                 mov    ax,1
                                 mul    zonaTemp4
                                 mov    dx,ax

                                 add    bx, dx
                                
                                 cmp    bx, 290
                                 je     ganadorBlancasMat
                                 cmp    bx, 418
                                 je     ganadorNegrasMat
                                 ret

    ganadorBlancasMat:           lea    dx, msgBlancasGanan
                                 mov    ah, 09h
                                 int    21h
                                 jmp    salirVictoriaMat
    
    ganadorNegrasMat:            lea    dx, msgNegrasGanan
                                 mov    ah, 09h
                                 int    21h

    salirVictoriaMat:            mov    ax, 4C00h
                                 int    21h
verificarGanadorColu endp

lectorPiezas proc near                                                      ;Valida Jugador que juega
                                 mov    jugadorActual,0
                                 mov    indiceFila, 0
                                 xor    cx,cx
                                 jmp    loopColumna
                        
    restartColumna:              mov    cx,0
                                 inc    indiceFila
                                 cmp    indiceFila, 4
                                 je     salirLectorPiezas

    loopColumna:                 mov    al, indiceFila
                                 mov    fila, al
                                 xor    al, al
                                 mov    columna,cl

                                 call   pruebaAccederDatos
                                 cmp    al, '.'
                                 je     backLoopColu

    increaseVariable:            inc    jugadorActual

    backLoopColu:                inc    cx
                                 cmp    cx, 4
                                 je     restartColumna
                                 jmp    loopColumna

    salirLectorPiezas:           cmp    jugadorActual, 15
                                 je     empate
                                 ret

    empate:                      lea    dx, msgHuboEmpate
                                 mov    ah, 09h
                                 int    21h

                                 mov    ax, 4C00h
                                 int    21h
lectorPiezas endp

cargarTablero proc near

    converterMatriz:             xor    di,di
                                 mov    ah, 3Dh
                                 xor    al, al
                                 lea    dx, nombArchivo
                                 int    21h
                                 jnc    followInsert
                                 jmp    error

    followInsert:                mov    handleS, ax
                                 mov    cx,1
                                 mov    bx, handleS

    readFileInsertar:            mov    ah, 3Fh
                                 lea    dx, Buffy
                                 mov    bx, handleS
                                 int    21h
                                 jc     error
                                 jmp    writeTxt
                                
    writeTxt:                    cmp    ax,0
                                 je     finalInsert
                                 mov    al, Buffy
                                 cmp    al, 10
                                 je     readFileInsertar
                                 mov    byte ptr tableroActual[di], al
                                 mov    byte ptr tableroTemporal[di], al
                                 inc    di
                                 jmp    readFileInsertar

    error:                       lea    dx, msgNoSobrescribir
                                 mov    ah, 09h
                                 int    21h

    finalInsert:                 mov    ah,3Eh
                                 mov    bx,handleS
                                 int    21h
                                 ret
cargarTablero endp

actualizarTablero proc near
                                 call   lectorPiezas
                                 mov    cl,jugadorActual

                                 mov    si, 80h
                                 inc    si
                                 inc    si
                                 inc    si
                                 inc    si
                                
                                 xor    di,di
                                 mov    al, byte ptr es:[si]
                                 cmp    al, 'B'
                                 je     comparacionBlanas
                                 cmp    al, 'N'
                                 je     comparacionNegras
                                 jmp    letraJugadorNoValida

    comparacionBlanas:           shr    cl,1
                                 jc     jugadorRepetido
    ;Aca se valida las letras
                                 mov    byte ptr turnoJugador[di], al
                                 inc    si
                                 inc    si

                                 xor    di,di
                                 mov    al, byte ptr es:[si]
                                 cmp    al, 'E'
                                 je     sigueInsert
                                 cmp    al, 'C'
                                 je     sigueInsert
                                 cmp    al, 'V'
                                 je     sigueInsert
                                 cmp    al, 'D'
                                 je     sigueInsert
                                 jmp    caracterJuegoInvalido

    comparacionNegras:           shr    cl,1
                                 jnc    jugadorRepetido
    ;Aca se valida las letras
                                 mov    byte ptr turnoJugador[di], al
                                 inc    si
                                 inc    si

                                 xor    di,di
                                 mov    al, byte ptr es:[si]
                                 cmp    al, 'e'
                                 je     sigueInsert
                                 cmp    al, 'c'
                                 je     sigueInsert
                                 cmp    al, 'v'
                                 je     sigueInsert
                                 cmp    al, 'd'
                                 je     sigueInsert
                                 jmp    caracterJuegoInvalido
                                           
    sigueInsert:                 mov    byte ptr pieza[di], al
                                 inc    si
                                 inc    si

                                 xor    di,di
                                 mov    al, byte ptr es:[si]
                                 cmp    al, 64
                                 jb     letraNoValidaMensaje
                                 cmp    al, 69
                                 ja     letraNoValidaMensaje
                                 sub    al,65
                                 mov    byte ptr filaEntrada[di], al
                                 inc    si

                                 xor    di,di
                                 mov    al, byte ptr es:[si]
                                 sub    al,48
                                 mov    byte ptr columnaEntrada[di], al

    actualizacionCorrecta:       ret

    jugadorRepetido:             lea    dx, jugadorRepetidoMsg
                                 mov    ah, 09h
                                 int    21h
                                 jmp    terminarAcualizacionTablero

    caracterJuegoInvalido:       lea    dx, msgCaracterInvalido
                                 mov    ah, 09h
                                 int    21h
                                 jmp    terminarAcualizacionTablero

    letraJugadorNoValida:        lea    dx, jugadorInvalidoMsg
                                 mov    ah, 09h
                                 int    21h
                                 jmp    terminarAcualizacionTablero

    letraNoValidaMensaje:        lea    dx, msgLetraInvalida
                                 mov    ah, 09h
                                 int    21h
                                
    terminarAcualizacionTablero: mov    ax, 4C00h
                                 int    21h
actualizarTablero endp

insertarElementoTablero proc near

                                 mov    al, columnaEntrada
                                 mov    columna, al

                                 mov    al, filaEntrada
                                 mov    fila,al
                                 call   buscaPosition

                                 mov    al, pieza
                                 cmp    byte ptr tableroActual[di], '.'
                                 je     jugadaValida
                                 jmp    jugadaNoValida

    jugadaValida:                mov    byte ptr tableroActual[di], al
                                 ret

    jugadaNoValida:              cmp    banderaError, 7
                                 je     insertarIAExit
                                 lea    dx, msgCaracterExistente
                                 mov    ah, 09h
                                 int    21h
              
                                 mov    ax, 4C00h
                                 int    21h

    insertarIAExit:              mov    banderaError,1
                                 ret
insertarElementoTablero endP

addNuevaJugada proc near
                                 call   cargarTablero                       ;Carga tablero
                                 call   actualizarTablero                   ;Obtiene datos entrada
                                
                                 call   insertarElementoTablero

                                 call   recargarVariables
                                 call   validacionLinea

                                 call   recargarVariables
                                 call   definirCuadrante

                                 call   recargarVariables
                                 call   validacionZona

                                 call   recargarVariables
                                 call   verificarGanadorZona

                                 call   recargarVariables
                                 call   verificarGanadorColu

                                 call   cerrarZonaCorrecta

addNuevaJugada endp

validarTableroIa proc near
                                 call   lectorPiezas
                                 mov    cl,jugadorActual
                                
                                 xor    di,di
                                 mov    al, turnoJugador
                                 cmp    al, 'B'
                                 je     comparacionBlanas1
                                 cmp    al, 'N'
                                 je     comparacionNegras1
                                 jmp    letraJugadorNoValida1

    comparacionBlanas1:          shr    cl,1
                                 jc     jugadorRepetido1
                                 jmp    actualizacionCorrecta1

    comparacionNegras1:          shr    cl,1
                                 jnc    jugadorRepetido1

    actualizacionCorrecta1:      ret

    jugadorRepetido1:            mov    banderaError,1
                                 jmp    terminarAcualizacionTablero1

    letraJugadorNoValida1:       mov    banderaError,1
                                 jmp    terminarAcualizacionTablero1
                                
    terminarAcualizacionTablero1:ret
validarTableroIa endp

printAX proc near
                                 push   AX
                                 push   BX
                                 push   CX
                                 push   DX

                                 xor    cx, cx
                                 mov    bx, 10
    ciclo1PAX:                   xor    dx, dx
                                 div    bx
                                 push   dx
                                 inc    cx
                                 cmp    ax, 0
                                 jne    ciclo1PAX
                                 mov    ah, 02h
    ciclo2PAX:                   pop    DX
                                 add    dl, 30h
                                 int    21h
                                 loop   ciclo2PAX

                                 pop    DX
                                 pop    CX
                                 pop    BX
                                 pop    AX
                                 ret
printAX endP

Randomize Proc
                                 push   ax
                                 push   cx
                                 push   dx

                                 mov    ah, 2Ch
                                 int    21h
                                 mov    word ptr Semilla, dx

                                 pop    dx
                                 pop    cx
                                 pop    ax
                                 ret
Randomize EndP

Random Proc
                                 push   dx
                                 mov    ax, Semilla
                                 inc    ax
                                 inc    ax
                                 mul    ax
                                 xchg   ah, al
                                 mov    Semilla, ax

                                 xor    dx, dx
                                 div    bx

                                 mov    ax, dx

                                 pop    dx

                                 ret
Random Endp

movimientoIA proc near

    jugador:                     call   Randomize
                                 mov    bx, 2
                                 call   random
                        
                                 cmp    al, 0
                                 je     negro
                                 jmp    blanco
                               
    negro:                       mov    byte ptr turnoJugador[0],'N'

    piezaNegraRan:               call   Randomize
                                 mov    bx, 4
                                 call   random
                                 cmp    al,0
                                 je     esferaN
                                 cmp    al,1
                                 je     cuboNegra
                                 cmp    al,2
                                 je     dNegro
                                 cmp    al,3
                                 je     vNegro

    esferaN:                     mov    byte ptr pieza[0],'e'
                                 jmp    filaIA

    cuboNegra:                   mov    byte ptr pieza[0],'c'
                                 jmp    filaIA

    dNegro:                      mov    byte ptr pieza[0],'d'
                                 jmp    filaIA

    vNegro:                      mov    byte ptr pieza[0],'v'
                                 jmp    filaIA

    blanco:                      mov    byte ptr turnoJugador[0],'B'

    piezaBlancaRan:              call   Randomize
                                 mov    bx, 4
                                 call   random
                                 cmp    al,0
                                 je     esferaB
                                 cmp    al,1
                                 je     cuboB
                                 cmp    al,2
                                 je     dBlanco
                                 cmp    al,3
                                 je     vBlanco

    esferaB:                     mov    byte ptr pieza[0],'E'
                                 jmp    filaIA

    cuboB:                       mov    byte ptr pieza[0],'C'
                                 jmp    filaIA

    dBlanco:                     mov    byte ptr pieza[0],'D'
                                 jmp    filaIA

    vBlanco:                     mov    byte ptr pieza[0],'V'

    filaIA:                      call   Randomize
                                 mov    bx, 4
                                 call   random
                                 mov    filaEntrada,AL
                          
    columnaIA:                   call   Randomize
                                 mov    bx, 4
                                 call   random
                                 mov    columnaEntrada,AL
                          
                                 ret
movimientoIA endp


IaController proc near
                                 call   cargarTablero                       ;Se carga tablero con patida anterior
                                 mov    cx,3000

    loopMoviminetoIa:            cmp    cx,0
                                 je     finalPorTiempo
                                 push   cx

                                 mov    banderaError, 7
                                 call   movimientoIA
                                 call   validarTableroIa                    ;Valida datos correctos

                                 cmp    banderaError,1
                                 je     loopMoviminetoIaOtra

                                 call   insertarElementoTablero
                                 cmp    banderaError,1
                                 je     loopMoviminetoIaOtra

                                 call   recargarVariables
                                 call   validacionLinea
                                 cmp    banderaError,1
                                 je     loopMoviminetoIaOtra

                                 call   recargarVariables
                                 call   definirCuadrante

                                 call   recargarVariables
                                 call   validacionZona
                                 cmp    banderaError,1
                                 je     loopMoviminetoIaOtra

                                 call   recargarVariables
                                 call   verificarGanadorZona

                                 call   recargarVariables
                                 call   verificarGanadorColu

                                 call   cerrarZonaCorrecta

    loopMoviminetoIaOtra:        pop    cx
                                 dec    cx
                                 jmp    loopMoviminetoIa

                                 lea    dx, msgDatoUsabelIa
                                 mov    ah, 09h
                                 int    21h
                                

    finalPorTiempo:              lea    dx, msgExtendenTime
                                 mov    ah, 09h
                                 int    21h
    
                                 ret

IaController endp


cerrarZonaCorrecta proc near
                                 xor    si,si
                                 xor    di,di

    restartBx10:                 mov    bx,4

                                 mov    cx,16
    loopInsertDi:                cmp    bx, 0
                                 je     add10Bx
                                 mov    al, byte ptr tableroActual[si]
                                 mov    byte ptr Buffy[di], al
                                 inc    di
                                 inc    si
                                 dec    bx
                                 loop   loopInsertDi

    add10Bx:                     cmp    si, 16
                                 je     createToFile
                                 mov    byte ptr Buffy[di], 10
                                 inc    di
                                 jmp    restartBx10
                                
    createToFile:                mov    ah, 3Ch
                                 lea    dx, nombArchivo
                              
                                 xor    cx, cx
                                 int    21h
                                 jc     auxErrorSobre
                                 mov    handleS, ax

                                 mov    cx, 19
                                 lea    dx, Buffy
                                 mov    bx, handleS

                                 mov    ah, 40h
                                 int    21h
                                 jc     auxErrorSobre
                                 jmp    cerrar

    auxErrorSobre:               lea    dx, msgETablero
                                 mov    ah, 09h
                                 int    21h

                                 jmp    salir

    cerrar:                      
                                 mov    ah, 3Eh                             ; cerrar el archivo
                                 mov    bx, handleS
                                 int    21h
                                 jmp    salir

    salir:                       lea    dx, msgPiezaInsertada
                                 mov    ah, 09h
                                 int    21h

    ;  mov    al,pieza
    ;  xor    ah,ah
    ;  call   printAX

    ;  mov    ah, 02h
    ;  mov    dl, 32
    ;  int    21h

                                 mov    al,filaEntrada
                                 xor    ah,ah
    ;add    ax,17
                                 call   printAX

                                 mov    al,columnaEntrada
                                 xor    ah,ah
                                 call   printAX


                                 mov    ax, 4C00h
                                 int    21h
cerrarZonaCorrecta endp

    main:                        mov    ax, ds
                                 mov    es, ax
                                 mov    ax, datos
                                 mov    ds, ax
                                 mov    ax, pila
                                 mov    ss, ax
                                 
                                 mov    si, 80h
                                 mov    cl, byte ptr es:[si]
                                 xor    ch, ch
                                 xor    di, di
                                 inc    si
                                 inc    si
                                 dec    cx
                                 mov    contadorCx,cx

                                 mov    al, byte ptr es:[si]                ;Lo que escribe el usario
                                 mov    byte ptr letraComando[di], al       ;Se escribe en el rotulo
                                 inc    si
                                 call   indexOpciones

                                 mov    ah, 09h
                                 lea    dx, msgProgramClose
                                 int    21h

                                 mov    ax, 4C00h
                                 int    21h
codigo ends

end main                                
